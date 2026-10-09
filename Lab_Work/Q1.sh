#!/bin/bash

lock_file="/tmp/binary_semaphore.lock"

process() {
    process_id=$1

    (
        flock -x 200

        echo "Process $process_id entered critical section"
        sleep 3
        echo "Process $process_id is working..."
        sleep 2
        echo "Process $process_id leaving critical section"

    ) 200>"$lock_file"
}

process 1 &
process 2 &

wait

rm -f "$lock_file"

echo "Both processes finished."
