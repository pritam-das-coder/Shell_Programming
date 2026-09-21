#!/bin/bash
cat << 'EOF' > q3.c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid1 = fork();
    if (pid1 < 0) { perror("Fork 1 failed"); return 1; }
    if (pid1 == 0) {
        printf("Child 1 (PID: %d) executing 'pwd':\n", getpid());
        execlp("pwd", "pwd", NULL);
        perror("exec pwd failed");
        return 1;
    }

    pid_t pid2 = fork();
    if (pid2 < 0) { perror("Fork 2 failed"); return 1; }
    if (pid2 == 0) {
        printf("\nChild 2 (PID: %d) executing 'ls':\n", getpid());
        execlp("ls", "ls", NULL);
        perror("exec ls failed");
        return 1;
    }

    waitpid(pid1, NULL, 0);
    waitpid(pid2, NULL, 0);
    printf("\nParent: Both children finished.\n");
    return 0;
}
EOF
gcc q3.c -o q3 && ./q3

