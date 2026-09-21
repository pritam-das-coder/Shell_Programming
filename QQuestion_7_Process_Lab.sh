#!/bin/bash
cat << 'EOF' > QQuestion_7_Process_Lab.c
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    int fd[2];
    if (pipe(fd) == -1) { perror("Pipe failed"); return 1; }
    
    pid_t pid = fork();
    if (pid < 0) { perror("Fork failed"); return 1; }
    
    if (pid > 0) {
        close(fd[0]); // Close read end
        char msg[] = "Hello from Parent Process!";
        write(fd[1], msg, strlen(msg) + 1);
        close(fd[1]);
        wait(NULL);
    } else {
        close(fd[1]); // Close write end
        char buffer[100];
        read(fd[0], buffer, sizeof(buffer));
        printf("Child received message: '%s'\n", buffer);
        close(fd[0]);
    }
    return 0;
}
EOF
gcc QQuestion_7_Process_Lab.c -o QQuestion_7_Process_Lab
./QQuestion_7_Process_Lab
