#!/usr/bin/env bash
omega="$1"

OVERHEAD_CPUS=48
OVERHEAD_JOBS=12
MKL_CPUS=4

sbatch_dir="log/"
sbatch_rec="${sbatch_dir}/d2zv_LSA_harmonics"
bin="../bin/d2ca_zosc_visc_full_floquet_m32"

! [[ -d "$sbatch_dir" ]] && mkdir -p "$sbatch_dir" || :

trapped() {
  echo 'TRAPPED -- QUITTING'
  exit 70
}

trap "trapped" 1 2 3 4 5 6 7 8 

in_gen() {
  om="${1:?'OMEGA VAL MISSING'}"
  al="${2:?'ALPHA VAL MISSING'}"
  cat << EOF
'B${om}_N2e4_Pr1e0_F${al}_m32_tr1e3_flo'       ! prefix
'B${om}_N2e4_Pr1e0_F${al}_m32_tr1e3_flo.00000' ! restart
1d0       ! gamma scaling on restart sol: g*Rs+(1-g)*BS (gamma)
2d4       ! Nondimensional Buoyancy freq                (N_B)
1d0       ! Prandtl number                              (Pr)
2d0       ! ke aspect ratio := 2 / <aspect ratio>       (asp)
${om/e/d} ! Ratio of frequencies := omega / N_B         (BPhi)
${al/e/d} ! Square of Froude Number                     (Fr2)
5d-7      ! rest dt                                     (rdt)
1000      ! temporal forcing period resolution          (nmesh)
1000      ! total number of forcing periods             (pmesh)
500000000 ! save restart frequency in timesteps         (igraph)
100       ! time series output frequency in timsteps    (its)
0         ! initial file number                         (init_file
0         ! controls program options                    (ibegin)
EOF
}

my_job() {
  om="${1:?'OMEGA VAL MISSING'}"
  al="${2:?'ALPHA VAL MISSING'}"
  ../bin/d2ca_zosc_visc_full_floquet_m32 < <(
    in_gen $om $al
  )
}

export -f in_gen my_job

sbatch --comment="d2zv LSA harmonics o${omega}" << EOF
#!/bin/bash
#SBATCH -p skx-normal
#SBATCH -t 1-0:00
#SBATCH --nodes=1-1
#SBATCH --ntasks=1
#SBATCH --mincpus=$OVERHEAD_CPUS
#SBATCH --mail-type ALL
#SBATCH --mail-user yalim@asu.edu
#SBATCH -o "${sbatch_rec}_o${omega}.out"
#SBATCH -e "${sbatch_rec}_o${omega}.err"
##SBATCH --cpus-per-task=$OVERHEAD_CPUS

export MKL_NUM_THREADS=$MKL_CPUS
ulimit -s unlimited

[[ -d "lib/" ]] && {
  export LD_LIBRARY_PATH=":$(readlink -f lib/):$LD_LIBRARY_PATH"
  export    LIBRARY_PATH="$LD_LIBRARY_PATH"
} || :

ml -python/2.7.13 intel/17.0.4

mapfile -t alphas < <(
  python -c "for k in range(250,320,10): print('{:d}e-3'.format(k))"
)

parallel -j $OVERHEAD_JOBS my_job $omega {} ::: \${alphas[@]}
rsync -avz -r ../LSA_harmonic_hunt/ $WORK/d2zv/
EOF
