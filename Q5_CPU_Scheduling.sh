#!/bin/bash

cat << 'EOF' > Q5_CPU_Scheduling.c
#include <stdio.h>

int main() {
    int n, at[20], bt[20], rem_time[20], ct[20], tat[20], wt[20], resp_t[20], pid[20];
    int first_start[20];

    printf("Enter number of processes: ");
    if (scanf("%d", &n) != 1) return 1;

    printf("Enter Arrival Time (AT) and Burst Time (BT) for each process:\n");
    for(int i = 0; i < n; i++) { 
        pid[i] = i + 1; 
        printf("Process %d (AT BT): ", pid[i]);
        scanf("%d %d", &at[i], &bt[i]); 
        rem_time[i] = bt[i]; 
        first_start[i] = -1; // Initialize first start time as -1
    }

    int time = 0, completed = 0, prev = -1; 
    float sum_tat = 0, sum_wt = 0, sum_rt = 0;

    while(completed < n) {
        int idx = -1, min_rt = 1e9;
        
        for(int i = 0; i < n; i++) {
            if(at[i] <= time && rem_time[i] > 0) {
                if(rem_time[i] < min_rt) { 
                    min_rt = rem_time[i]; 
                    idx = i; 
                } 
                // Tie-breaker: If remaining times are equal, pick the one that arrived earlier
                else if(rem_time[i] == min_rt && at[i] < at[idx]) {
                    idx = i;
                }
            }
        }

        if(idx != -1) {
            // If the process is getting the CPU for the first time, record its response time
            if(first_start[idx] == -1) {
                first_start[idx] = time;
                resp_t[idx] = first_start[idx] - at[idx];
            }

            rem_time[idx]--;
            time++;

            // If the process finishes execution
            if(rem_time[idx] == 0) {
                completed++;
                ct[idx] = time;
                tat[idx] = ct[idx] - at[idx];
                wt[idx] = tat[idx] - bt[idx];
                
                sum_tat += tat[idx];
                sum_wt += wt[idx];
                sum_rt += resp_t[idx];
            }
        } else {
            time++; // CPU is idle
        }
    }

    // Display formatted results
    printf("\n| PID | AT | BT | CT | TAT | WT | RT |\n");
    printf("|-----|----|----|----|-----|----|----|\n");
    for(int i = 0; i < n; i++) {
        printf("| %3d | %2d | %2d | %2d | %3d | %2d | %2d |\n", 
               pid[i], at[i], bt[i], ct[i], tat[i], wt[i], resp_t[i]);
    }

    printf("\nAvg TAT = %.2f\nAvg WT  = %.2f\nAvg RT  = %.2f\n", 
           sum_tat/n, sum_wt/n, sum_rt/n);

    return 0;
}
EOF

# Compile and run interactively
gcc Q5_CPU_Scheduling.c -o Q5
if [ $? -eq 0 ]; then
    ./Q5
else
    echo "Compilation failed."
fi
