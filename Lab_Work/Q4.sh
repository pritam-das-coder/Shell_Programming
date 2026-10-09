#!/bin/bash

echo "Starting Dining Philosophers Simulation..."

# Create 5 Named Pipes (FIFOs) to act as binary semaphores for the 5 forks
mkfifo /tmp/fork0_$$ /tmp/fork1_$$ /tmp/fork2_$$ /tmp/fork3_$$ /tmp/fork4_$$

# Open the FIFOs on file descriptors 3 through 7 and initialize each with one token ('1')
# The token represents the availability of the fork (Binary Semaphore = 1)
exec 3<>/tmp/fork0_$$; echo 1 >&3
exec 4<>/tmp/fork1_$$; echo 1 >&4
exec 5<>/tmp/fork2_$$; echo 1 >&5
exec 6<>/tmp/fork3_$$; echo 1 >&6
exec 7<>/tmp/fork4_$$; echo 1 >&7

# Function representing a philosopher
philosopher() {
    local id=$1
    
    # Map philosopher ID to their left and right fork file descriptors
    local left_fd=$(( id + 3 ))
    local right_fd=$(( (id + 1) % 5 + 3 ))
    
    local left_fork_id=$id
    local right_fork_id=$(( (id + 1) % 5 ))
    
    echo "Philosopher $id is thinking..."
    sleep 1
    
    # Asymmetric solution to prevent circular deadlock:
    # Philosopher 4 picks up the right fork first, while 0-3 pick up the left fork first.
    if [ $id -eq 4 ]; then
        read -u $right_fd token  # Wait (P) on right fork
        read -u $left_fd token   # Wait (P) on left fork
    else
        read -u $left_fd token   # Wait (P) on left fork
        read -u $right_fd token  # Wait (P) on right fork
    fi
    
    # Critical Section
    echo "Philosopher $id is EATING with forks $left_fork_id and $right_fork_id."
    sleep 2
    echo "Philosopher $id finished eating and is putting down forks."
    
    # Signal (V): Release the forks by writing the token back into the FIFOs
    echo 1 >&$left_fd
    echo 1 >&$right_fd
}

# Spawn 5 philosopher processes concurrently
for i in {0..4}; do
    philosopher $i &
done

# Wait for all background philosopher processes to finish
wait

echo "Simulation complete. Cleaning up resources..."

# Close file descriptors
exec 3>&- 4>&- 5>&- 6>&- 7>&-

# Remove temporary FIFO files
rm /tmp/fork0_$$ /tmp/fork1_$$ /tmp/fork2_$$ /tmp/fork3_$$ /tmp/fork4_$$
