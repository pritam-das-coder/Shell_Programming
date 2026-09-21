#!/bin/bash

cat << 'EOF' > Q4_CPU_Scheduling.c
#include<stdio.h>

int main() {
    int n, at[20], bt[20], ct[20], tat[20], wt[20], pid[20], comp[20]={0};
    
    printf("Enter number of processes: ");
    if(scanf("%d", &n) != 1) return 1;
    
    printf("Enter AT and BT for each process:\n");
    for(int i=0; i<n; i++) {
        pid[i]=i+1;
        printf("Process %d: ", pid[i]);
        scanf("%d %d", &at[i], &bt[i]);
    }
    
    int time=0, completed=0;
    float sum_wt=0, sum_tat=0;
    int max_wt = -1;
    
    printf("\nExecution Log:\n");
    while(completed < n) {
        int idx = -1, min_bt = 1e9;
        
        for(int i=0; i<n; i++) {
            if(at[i] <= time && !comp[i]) {
                if(bt[i] < min_bt) { 
                    min_bt = bt[i]; 
                    idx = i; 
                }
                else if(bt[i] == min_bt && at[i] < at[idx]) { 
                    idx = i; 
                }
            }
        }
        
        if(idx != -1) {
            wt[idx] = time - at[idx];
            if(wt[idx] > max_wt) max_wt = wt[idx];
            
            time += bt[idx];
            ct[idx] = time;
            tat[idx] = ct[idx] - at[idx];
            comp[idx] = 1;
            completed++;
            
            sum_wt += wt[idx]; 
            sum_tat += tat[idx];
        } else {
            int next_at = 1e9;
            for(int i=0; i<n; i++) {
                if(!comp[i] && at[i] < next_at) {
                    next_at = at[i];
                }
            }
            printf("CPU Idle from %d to %d\n", time, next_at);
            time = next_at;
        }
    }
    
    printf("\n| PID | AT | BT | CT | TAT | WT |\n");
    printf("|-----|----|----|----|-----|----|\n");
    for(int i=0; i<n; i++) {
        printf("| %3d | %2d | %2d | %2d | %3d | %2d |\n", 
               pid[i], at[i], bt[i], ct[i], tat[i], wt[i]);
    }
    
    printf("\nTotal TAT = %.0f\nTotal WT  = %.0f\n", sum_tat, sum_wt);
    printf("Avg TAT   = %.2f\nAvg WT    = %.2f\n", sum_tat/n, sum_wt/n);
    printf("Max WT    = %d\n", max_wt);
    
    return 0;
}
EOF

gcc Q4_CPU_Scheduling.c -o Q4
if [ $? -eq 0 ]; then
    ./Q4
else
    printf "Compilation failed.\n"
fi
