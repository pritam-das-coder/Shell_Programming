#!/bin/bash
cat << 'EOF' > QQuestion_6_Process_Lab.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    pid_t pid = fork();
    if (pid > 0) {
        printf("Parent (PID: %d): Terminating now. Child (PID: %d) will be orphaned.\n", getpid(), pid);
        exit(0);
    } else if (pid == 0) {
        printf("Child (PID: %d): Initial PPID = %d\n", getpid(), getppid());
        sleep(2);
        /* The parent has died, so the child is adopted by a system init process (usually PID 1 or user systemd). */
        printf("Child (PID: %d): Parent terminated. New PPID (adopted) = %d\n", getpid(), getppid());
        printf("Child: A system process (like init or upstart) re-parents the orphan process.\n");
    }
    return 0;
}
EOF
gcc QQuestion_6_Process_Lab.c -o QQuestion_6_Process_Lab
./QQuestion_6_Process_Lab
