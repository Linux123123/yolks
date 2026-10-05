#!/usr/bin/env python3
"""Keep the original CRDB process and independently restart lab sidecars."""
import json
import os
from pathlib import Path
import signal
import subprocess
import time

ROOT = Path('/home/container')
STOP = False

def request_stop(signum, frame):
    global STOP
    STOP = True


def main():
    signal.signal(signal.SIGINT, request_stop)
    signal.signal(signal.SIGTERM, request_stop)
    os.chdir(ROOT)
    crdb = subprocess.Popen(['/bin/bash', str(ROOT / 'start.sh')])
    services = []
    try:
        config = json.loads((ROOT / 'tikv-config/services.json').read_text())
        for name, command in config.items():
            if name not in ('pd', 'tikv') or not isinstance(command, list):
                raise ValueError('Invalid sidecar service definition')
            if command[0] != f'/usr/local/bin/{name}-server':
                raise ValueError('Unexpected sidecar executable')
            services.append({'name': name, 'command': command, 'process': None,
                             'retry_at': 0, 'backoff': 2, 'started_at': 0})
    except Exception as error:
        print(f'Sidecars disabled: {error}; CRDB continues.', flush=True)
    try:
        while not STOP and crdb.poll() is None:
            now = time.monotonic()
            for service in services:
                process = service['process']
                if process is not None and process.poll() is not None:
                    if now - service['started_at'] > 60:
                        service['backoff'] = 2
                    print(f"{service['name']} exited {process.returncode}; retrying independently.", flush=True)
                    service['process'] = None
                    service['retry_at'] = now + service['backoff']
                    service['backoff'] = min(60, service['backoff'] * 2)
                if service['process'] is None and now >= service['retry_at']:
                    try:
                        service['process'] = subprocess.Popen(service['command'], stdin=subprocess.DEVNULL)
                        service['started_at'] = now
                    except OSError as error:
                        print(f"{service['name']}: {error}", flush=True)
                        service['retry_at'] = now + 60
            time.sleep(0.25)
    finally:
        processes = [crdb] + [s['process'] for s in services if s['process'] is not None]
        for process in processes:
            if process.poll() is None:
                process.send_signal(signal.SIGINT if process is crdb else signal.SIGTERM)
        deadline = time.monotonic() + 30
        while time.monotonic() < deadline and any(p.poll() is None for p in processes):
            time.sleep(0.1)
        for process in processes:
            if process.poll() is None:
                process.kill()
            process.wait()
    return max(0, crdb.returncode or 0)


if __name__ == '__main__':
    raise SystemExit(main())
