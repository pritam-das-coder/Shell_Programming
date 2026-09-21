#!/bin/bash
cat << 'EOF' > QQuestion_5_Process_Lab.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();
    if (pid > 0) {
        printf("Parent (PID: %d): Sleeping for 3 seconds. Check 'ps -l' in another terminal.\n", getpid());
        /* The child finishes immediately, but the parent delays reading its status. 
           The child's entry remains in the process table as a 'Zombie' (defunct). */
        sleep(3);
        wait(NULL);
        printf("Parent: Reaped the zombie child. Exiting.\n");
    } else if (pid == 0) {
        printf("Child (PID: %d): Terminating immediately to become a zombie.\n", getpid());
        exit(0);
    }
    return 0;
}
EOF
gcc QQuestion_5_Process_Lab.c -o QQuestion_5_Process_Lab
./QQuestion_5_Process_Lab

