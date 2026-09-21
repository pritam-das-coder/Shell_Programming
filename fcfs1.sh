#!/bin/bash
cat << 'EOF' > Q1_CPU_Scheduling.c
#include <stdio.h>

int main() {
    int n, bt[20], wt[20], tat[20], ct[20];
    float avg_wt = 0, avg_tat = 0;
    
    printf("Enter number of processes: ");
    if (scanf("%d", &n) != 1) return 1;
    for(int i=0; i<n; i++) {
        printf("Enter Burst Time for P%d: ", i+1);
        scanf("%d", &bt[i]);
    }
    wt[0] = 0;
    ct[0] = bt[0];
    tat[0] = ct[0];
    avg_tat = tat[0];
    for(int i=1; i<n; i++) {
        ct[i] = ct[i-1] + bt[i];
        wt[i] = ct[i-1];
        tat[i] = ct[i];
        avg_wt += wt[i];
        avg_tat += tat[i];
    }
    printf("\n| Process | BT | CT | TAT | WT |\n");
    printf("|---------|----|----|-----|----|\n");
    for(int i=0; i<n; i++) {
        printf("| P%d      | %2d | %2d | %3d | %2d |\n", i+1, bt[i], ct[i], tat[i], wt[i]);
    }
    printf("\nAverage WT: %.2f\nAverage TAT: %.2f\n", avg_wt/n, avg_tat/n);
    printf("Gantt Chart: |");
    for(int i=0; i<n; i++) printf(" P%d |", i+1);
    printf("\n");
    return 0;
}
EOF
gcc Q1_CPU_Scheduling.c -o Q1_CPU_Scheduling && ./Q1_CPU_Scheduling << INP
3
5
8
12
INP
