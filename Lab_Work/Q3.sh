#!/bin/bash

# Counting Semaphore - 3 Printers
# 6 processes, maximum 3 can use printers simultaneously

fifo="/tmp/printer_semaphore_$$"

# Create named pipe
mkfifo "$fifo"

# Open FIFO for reading and writing
exec 3<>"$fifo"

# Add 3 tokens = 3 available printers
echo 1 >&3
echo 2 >&3
echo 3 >&3

# Function representing a process using a printer
use_printer() {
    process_id=$1

    # Acquire a printer (take one token)
    read -u 3 printer_id

    echo "Process $process_id got Printer $printer_id"

    # Critical section
    echo "Process $process_id is printing..."
    sleep 3

    echo "Process $process_id finished printing on Printer $printer_id"

    # Release the printer (return token)
    echo "$printer_id" >&3
}

# Start 6 processes
for i in {1..6}
do
    use_printer "$i" &
done

# Wait for all processes to finish
wait

# Cleanup
exec 3>&-
rm "$fifo"

echo "All 6 processes completed."
