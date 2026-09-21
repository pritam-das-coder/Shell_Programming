#!/bin/bash

cat << 'EOF' > Q3_CPU_Scheduling.c
#include <stdio.h>

int main() {
    int n, at[20], bt[20], ct[20], tat[20], wt[20], rt[20], pid[20], comp[20]={0};

    printf("Enter number of processes: ");
    if(scanf("%d", &n) != 1) return 1;

    printf("Enter Arrival Time (AT) and Burst Time (BT) for each process:\n");
    for(int i=0; i<n; i++) { 
        pid[i] = i+1; 
        printf("Process %d (AT BT): ", pid[i]);
        scanf("%d %d", &at[i], &bt[i]); 
    }

    int time=0, completed=0; 
    float sum_wt=0, sum_tat=0, sum_rt=0;

    while(completed < n) {
        int idx = -1, min_bt = 1e9;
        
        // Find the arrived process with the minimum burst time
        for(int i=0; i<n; i++) {
            if(at[i] <= time && !comp[i]) {
                if(bt[i] < min_bt) { 
                    min_bt = bt[i]; 
                    idx = i; 
                }
                // Tie-breaker: If burst times are equal, pick the one that arrived earlier
                else if(bt[i] == min_bt && at[i] < at[idx]) { 
                    idx = i; 
                }
            }
        }

        if(idx != -1) {
            wt[idx] = time - at[idx];
            rt[idx] = wt[idx];           // In non-preemptive SJF, Response Time equals Waiting Time
            time += bt[idx];
            ct[idx] = time;
            tat[idx] = ct[idx] - at[idx];
            comp[idx] = 1;
            completed++;
            
            sum_wt += wt[idx]; 
            sum_tat += tat[idx];
            sum_rt += rt[idx];
        } else {
            time++; // CPU is idle
        }
    }

    // Display formatted results
    printf("\n| PID | AT | BT | CT | TAT | WT | RT |\n");
    printf("|-----|----|----|----|-----|----|----|\n");
    for(int i=0; i<n; i++) {
        printf("| %3d | %2d | %2d | %2d | %3d | %2d | %2d |\n", 
               pid[i], at[i], bt[i], ct[i], tat[i], wt[i], rt[i]);
    }

    printf("\nAvg TAT = %.2f\nAvg WT  = %.2f\nAvg RT  = %.2f\n", 
           sum_tat/n, sum_wt/n, sum_rt/n);

    return 0;
}
EOF

# Compile and run interactively
gcc Q3_CPU_Scheduling.c -o Q3
if [ $? -eq 0 ]; then
    ./Q3
else
    echo "Compilation failed."
fi
