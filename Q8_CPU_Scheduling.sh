#!/bin/bash

cat << 'EOF' > Q8_CPU_Scheduling.c
#include<stdio.h>

int main() {
    int n, at[20], bt[20], rt[20], ct[20], tat[20], wt[20], resp_t[20];
    int pid[20], first_start[20], queue[1000], visited[20];
    int q, time=0, rem, front=0, rear=0;
    float sum_tat=0, sum_wt=0, sum_rt=0;

    printf("Enter number of processes: ");
    if(scanf("%d", &n) != 1) return 1;

    rem = n;
    printf("Enter AT and BT for each process:\n");
    for(int i=0; i<n; i++) {
        pid[i] = i+1;
        printf("Process %d: ", pid[i]);
        scanf("%d %d", &at[i], &bt[i]);
        rt[i] = bt[i];
        first_start[i] = -1;
        visited[i] = 0;
    }

    printf("Enter Time Quantum: ");
    scanf("%d", &q);

    if(q <= 0) {
        printf("Error: Time Quantum must be positive.\n");
        return 1;
    }

    for(int i=0; i<n-1; i++) {
        for(int j=i+1; j<n; j++) {
            if(at[i] > at[j]) {
                int temp = at[i]; at[i] = at[j]; at[j] = temp;
                temp = bt[i]; bt[i] = bt[j]; bt[j] = temp;
                temp = rt[i]; rt[i] = rt[j]; rt[j] = temp;
                temp = pid[i]; pid[i] = pid[j]; pid[j] = temp;
            }
        }
    }

    if(at[0] > time) time = at[0];
    queue[rear++] = 0;
    visited[0] = 1;

    while(front < rear) {
        int i = queue[front++];
        
        if(first_start[i] == -1) {
            first_start[i] = time;
            resp_t[i] = first_start[i] - at[i];
        }
        
        if(rt[i] > q) {
            time += q;
            rt[i] -= q;
        } else {
            time += rt[i];
            rt[i] = 0;
            rem--;
            ct[i] = time;
            tat[i] = ct[i] - at[i];
            wt[i] = tat[i] - bt[i];
            sum_tat += tat[i];
            sum_wt += wt[i];
            sum_rt += resp_t[i];
        }
        
        for(int j=0; j<n; j++) {
            if(at[j] <= time && visited[j] == 0) {
                queue[rear++] = j;
                visited[j] = 1;
            }
        }
        
        if(rt[i] > 0) {
            queue[rear++] = i;
        }
        
        if(front == rear && rem > 0) {
            for(int j=0; j<n; j++) {
                if(visited[j] == 0) {
                    if(time < at[j]) time = at[j];
                    queue[rear++] = j;
                    visited[j] = 1;
                    break;
                }
            }
        }
    }

    printf("\n| PID | AT | BT | CT | TAT | WT | RT |\n");
    printf("|-----|----|----|----|-----|----|----|\n");
    for(int i=0; i<n; i++) {
        printf("| %3d | %2d | %2d | %2d | %3d | %2d | %2d |\n",
               pid[i], at[i], bt[i], ct[i], tat[i], wt[i], resp_t[i]);
    }
    printf("\nAvg TAT = %.2f\nAvg WT  = %.2f\nAvg RT  = %.2f\n",
           sum_tat/n, sum_wt/n, sum_rt/n);

    return 0;
}
EOF

gcc Q8_CPU_Scheduling.c -o Q8
if [ $? -eq 0 ]; then
    ./Q8
else
    printf "Compilation failed.\n"
fi
