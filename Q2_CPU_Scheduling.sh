#!/bin/bash

cat << 'EOF' > Q2_CPU_Scheduling.c
#include <stdio.h>

int main() {
    int n, at[20], bt[20], ct[20], tat[20], wt[20], rt[20], pid[20];

    printf("Enter number of processes: ");
    if (scanf("%d", &n) != 1) return 1;

    printf("Enter Arrival Time (AT) and Burst Time (BT) for each process:\n");
    for(int i=0; i<n; i++) { 
        pid[i] = i+1; 
        printf("Process %d (AT BT): ", pid[i]);
        scanf("%d %d", &at[i], &bt[i]); 
    }

    // Sort processes by Arrival Time (AT)
    for(int i=0; i<n-1; i++) {
        for(int j=i+1; j<n; j++) {
            if(at[i] > at[j]) {
                int t = at[i]; at[i] = at[j]; at[j] = t;
                t = bt[i]; bt[i] = bt[j]; bt[j] = t;
                t = pid[i]; pid[i] = pid[j]; pid[j] = t;
            }
        }
    }

    int time = 0; 
    float sum_tat = 0, sum_wt = 0, sum_rt = 0;

    printf("\n--- Gantt Chart ---\n");
    
    for(int i=0; i<n; i++) {
        // Handle CPU Idle time
        if(time < at[i]) { 
            printf("| Idle (%d-%d) ", time, at[i]); 
            time = at[i]; 
        }
        
        // Print process execution on Gantt Chart
        printf("| P%d (%d-%d) ", pid[i], time, time + bt[i]);

        rt[i] = time - at[i];
        wt[i] = time - at[i];
        
        time += bt[i];
        ct[i] = time;
        tat[i] = ct[i] - at[i];
        
        sum_tat += tat[i]; 
        sum_wt += wt[i]; 
        sum_rt += rt[i];
    }
    printf("|\n");

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

# Compile and execute interactively
gcc Q2_CPU_Scheduling.c -o Q2
if [ $? -eq 0 ]; then
    ./Q2
else
    echo "Compilation failed."
fi
