#!/bin/bash

echo 0 > counter.txt

increment() {
    for i in {1..10}
    do
        (
            flock -x 200

            counter=$(cat counter.txt) # Read
            counter=$((counter + 1)) # Increment
            echo $counter > counter.txt # Write

        ) 200>semaphore.lock
    done
}

increment &
P1=$!

increment &
P2=$!

wait $P1
wait $P2

echo "Final counter value: $(cat counter.txt)"

rm counter.txt semaphore.lock
