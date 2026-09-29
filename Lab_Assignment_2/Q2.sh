#!/bin/bash
cat<<'EOF'>q2.c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main(){
    pid_t pid=fork();
    if(pid<0){
        perror("Fork failed");
        return 1;
    }
    else if(pid==0){
        printf("Child (PID: %d, PPID: %d): Starting...\n",getpid(),getppid());
        for(int i=1;i<=3;i++){
            printf("Child: Message %d\n",i);
            sleep(1);
        }
        printf("Child: Finished.\n");
        return 0;
    }
    else{
        printf("Parent (PID: %d): Waiting for child %d to finish.\n",getpid(),pid);
        int status; // child status
        if(waitpid(pid, &status,0)==-1){ // blocks parent with process id pid
            perror("waitpid failed");
            return 1;
        }
        printf("Parent: Child has terminated. Parent finishing now.\n");
    }

    return 0;
}
EOF
gcc q2.c -o q2
./q2