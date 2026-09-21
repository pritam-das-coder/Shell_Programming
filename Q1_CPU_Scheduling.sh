#!/bin/bash

# Create the C program file
cat << 'EOF' > Q1_CPU_Scheduling.c
#include<stdio.h>

int main() {
    int n, bt[20], ct[20], tat[20], wt[20], pid[20];

    printf("Enter number of processes: ");
    if(scanf("%d", &n) != 1) return 1;

    // AT is 0 for all, so we only need to take BT as input
    printf("Enter burst time for each process:\n");
    for(int i=0; i<n; i++) { 
        pid[i] = i+1;
        printf("Process %d: ", pid[i]);
        scanf("%d", &bt[i]); 
    }

    int time=0; 
    float sum_tat=0, sum_wt=0;

    // Display Gantt Chart
    printf("\n--- Gantt Chart ---\n");
    printf("%d", time);

    for(int i=0; i<n; i++) {
        wt[i] = time;           // Wait Time = Start Time - Arrival Time (0)
        time += bt[i];
        ct[i] = time;           // Completion Time
        tat[i] = ct[i];         // Turnaround Time = CT - Arrival Time (0)
        
        sum_tat += tat[i]; 
        sum_wt += wt[i]; 

        printf(" -> [P%d] -> %d", pid[i], time);
    }
    printf("\n");

    // Display Results in a Formatted Table
    printf("\n| PID | BT | CT | TAT | WT |\n");
    printf("|-----|----|----|-----|----|\n");
    for(int i=0; i<n; i++) {
        printf("| %3d | %2d | %2d | %3d | %2d |\n", 
               pid[i], bt[i], ct[i], tat[i], wt[i]);
    }

    // Display Averages
    printf("\nAvg TAT=%.2f, Avg WT=%.2f\n", sum_tat/n, sum_wt/n);
    
    return 0;
}
EOF

# Compile and run the C program, allowing it to take terminal input
gcc Q1_CPU_Scheduling.c -o Q1_CPU_Scheduling
if [ $? -eq 0 ]; then
    ./Q1_CPU_Scheduling
else
    echo "Compilation failed."
fi
