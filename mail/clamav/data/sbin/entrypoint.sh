#!/bin/ash
set -ex
echo Starting Entry point..

echo -e "1 Starting freshclam.."
freshclam -d &

echo -e "2 Waiting for clam to update..."
until [[ -e /var/lib/clamav/main.cvd ]]; do
    ls -l /var/lib/clamav/
    sleep 5
done

echo -e "3 Starting clamd..."
clamd

echo Entry point ended with sucess