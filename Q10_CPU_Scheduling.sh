#!/bin/bash

cat << 'EOF' > Q10_CPU_Scheduling.c
#include <stdio.h>

int main() {
    int n, at[20], bt[20], pr[20], rem_time[20], ct[20], tat[20], wt[20], resp_t[20], pid[20];
    int first_start[20];

    printf("Enter number of processes: ");
    if (scanf("%d", &n) != 1) return 1;

    printf("Enter Arrival Time (AT), Burst Time (BT), and Priority (PR) for each process:\n");
    printf("(Note: Lower PR number indicates higher priority)\n");
    for(int i = 0; i < n; i++) { 
        pid[i] = i + 1; 
        printf("Process %d (AT BT PR): ", pid[i]);
        scanf("%d %d %d", &at[i], &bt[i], &pr[i]); 
        rem_time[i] = bt[i]; 
        first_start[i] = -1; // Initialize to track response time
    }

    int time = 0, completed = 0; 
    float sum_tat = 0, sum_wt = 0, sum_rt = 0;

    while(completed < n) {
        int idx = -1, min_pr = 1e9;
        
        for(int i = 0; i < n; i++) {
            if(at[i] <= time && rem_time[i] > 0) {
                // Preempt based on highest priority (lowest PR value)
                if(pr[i] < min_pr) { 
                    min_pr = pr[i]; 
                    idx = i; 
                }
                // Tie-breaker logic: Earlier Arrival Time -> Lower Process ID
                else if(pr[i] == min_pr && idx != -1) {
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
            // Record response time when the process first gets the CPU
            if(first_start[idx] == -1) {
                first_start[idx] = time;
                resp_t[idx] = first_start[idx] - at[idx];
            }

            rem_time[idx]--;
            time++;

            // Check if process has finished
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
    printf("\n| PID | AT | BT | PR | CT | TAT | WT | RT |\n");
    printf("|-----|----|----|----|----|-----|----|----|\n");
    for(int i = 0; i < n; i++) {
        printf("| %3d | %2d | %2d | %2d | %2d | %3d | %2d | %2d |\n", 
               pid[i], at[i], bt[i], pr[i], ct[i], tat[i], wt[i], resp_t[i]);
    }

    printf("\nAvg TAT = %.2f\nAvg WT  = %.2f\nAvg RT  = %.2f\n", 
           sum_tat/n, sum_wt/n, sum_rt/n);

    return 0;
}
EOF

# Compile and run interactively
gcc Q10_CPU_Scheduling.c -o Q10
if [ $? -eq 0 ]; then
    ./Q10
else
    echo "Compilation failed."
fi
