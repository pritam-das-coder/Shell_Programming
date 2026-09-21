#!/bin/bash
cat << 'EOF' > QQuestion_9_Process_Lab.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();
    if (pid < 0) { perror("Fork failed"); return 1; }
    
    if (pid == 0) {
        int a = 15, b = 27;
        int sum = a + b;
        printf("Child: Calculated sum %d + %d = %d\n", a, b, sum);
        exit(sum); // Returning status
    } else {
        int status;
        waitpid(pid, &status, 0);
        if (WIFEXITED(status)) {
            printf("Parent: Child exited normally with status: %d\n", WEXITSTATUS(status));
        } else {
            printf("Parent: Child did not exit normally.\n");
        }
    }
    return 0;
}
EOF
gcc QQuestion_9_Process_Lab.c -o QQuestion_9_Process_Lab
./QQuestion_9_Process_Lab
