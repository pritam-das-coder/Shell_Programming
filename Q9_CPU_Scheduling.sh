#!/bin/bash

cat << 'EOF' > Q9_CPU_Scheduling.c
#include<stdio.h>

int main() {
    int n, at[20], bt[20], pr[20], ct[20], tat[20], wt[20], rt[20], pid[20], comp[20]={0};
    
    printf("Enter number of processes: ");
    if(scanf("%d", &n) != 1) return 1;
    
    printf("Enter AT, BT and PR for each process:\n");
    for(int i=0; i<n; i++) {
        pid[i] = i+1;
        printf("Process %d: ", pid[i]);
        scanf("%d %d %d", &at[i], &bt[i], &pr[i]);
    }
    
    int time=0, completed=0;
    float sum_tat=0, sum_wt=0, sum_rt=0;
    
    while(completed < n) {
        int idx = -1, min_pr = 1e9;
        
        for(int i=0; i<n; i++) {
            if(at[i] <= time && !comp[i]) {
                if(pr[i] < min_pr) { 
                    min_pr = pr[i]; 
                    idx = i; 
                } else if(pr[i] == min_pr && idx != -1) {
                    if(at[i] < at[idx]) {
                        idx = i;
                    } else if(at[i] == at[idx]) {
                        if(pid[i] < pid[idx]) {
                            idx = i;
                        }
                    }
                }
            }
        }
        
        if(idx != -1) {
            rt[idx] = time - at[idx];
            wt[idx] = time - at[idx];
            time += bt[idx];
            ct[idx] = time;
            tat[idx] = ct[idx] - at[idx];
            comp[idx] = 1;
            completed++;
            
            sum_tat += tat[idx];
            sum_wt += wt[idx];
            sum_rt += rt[idx];
        } else {
            time++;
        }
    }
    
    printf("\n| PID | AT | BT | PR | CT | TAT | WT | RT |\n");
    printf("|-----|----|----|----|----|-----|----|----|\n");
    for(int i=0; i<n; i++) {
        printf("| %3d | %2d | %2d | %2d | %2d | %3d | %2d | %2d |\n", 
               pid[i], at[i], bt[i], pr[i], ct[i], tat[i], wt[i], rt[i]);
    }
    
    printf("\nAvg TAT = %.2f\nAvg WT  = %.2f\nAvg RT  = %.2f\n", sum_tat/n, sum_wt/n, sum_rt/n);
    
    return 0;
}
EOF

gcc Q9_CPU_Scheduling.c -o Q9
if [ $? -eq 0 ]; then
    ./Q9
else
    printf "Compilation failed.\n"
fi
