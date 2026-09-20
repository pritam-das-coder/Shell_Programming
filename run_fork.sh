#!/bin/bash
cat << 'EOF' > q1.c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    for (int i = 0; i < 3; i++) {
        pid_t pid = fork();
        if (pid < 0) {
            perror("Fork failed");
            return 1;
        } else if (pid == 0) {
            printf("Child %d: PID = %d, PPID = %d\n", i + 1, getpid(), getppid());
            return 0;
        }
    }
    for (int i = 0; i < 3; i++) {
        wait(NULL);
    }
    printf("Parent: All three children have completed.\n");
    return 0;
}
EOF
gcc q1.c -o q1
if [ $? -eq 0 ]; then
    ./q1
else
    echo "Compilation failed."
fi
