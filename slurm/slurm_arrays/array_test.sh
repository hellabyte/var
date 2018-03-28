#!/usr/bin/env bash

sbatch_dir="diags/"
sbatch_rec="${sbatch_dir}array_demo"

myjob() {
  echo $1 -- $2 -- $3
}

! [[ -d "$sbatch_dir" ]] && mkdir -p "$sbatch_dir" || :

export -f myjob

sbatch --comment="array demo" << EOF
#!/bin/bash
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 00:01:00
#SBATCH -o "${sbatch_rec}_%A_%a.out"
#SBATCH -e "${sbatch_rec}_%A_%a.err"
#SBATCH --array=0-10%6

myjob \$SLURM_JOB_ID \$SLURM_ARRAY_TASK_ID \$SLURM_ARRAY_JOB_ID
EOF
