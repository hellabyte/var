#!/usr/bin/env bash
omega="${1:?'FORCING FREQ MISSING'}"

OVERHEAD_CPUS=48
OVERHEAD_JOBS=24
MKL_CPUS=2

bin="../bin/d2ca_zosc_visc_full_floquet_m32"

sbatch_dir="log/"
sbatch_rec="${sbatch_dir}/d2zv_LSA_harmonics_Gr_o${omega}"
d_dir_base="runs/"

trapped() {
  echo 'TRAPPED -- QUITTING'
  exit 70
}

in_gen() {
  bu="${1:?'BUOY  VAL MISSING'}"
  om="${2:?'OMEGA VAL MISSING'}"
  al="${3:?'ALPHA VAL MISSING'}"
  cat << EOF
'B${om}_N${bu}_Pr1e0_F${al}_m32_tr1e3_flo'       ! prefix
'B${om}_N${bu}_Pr1e0_F${al}_m32_tr1e3_flo.00000' ! restart
1d0       ! gamma scaling on restart sol: g*Rs+(1-g)*BS (gamma)
${bu/e/d} ! Nondimensional Buoyancy freq                (N_B)
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
  bu="${1:?'BUOY  VAL MISSING'}"
  om="${2:?'OMEGA VAL MISSING'}"
  al="${3:?'ALPHA VAL MISSING'}"
  res_dir="${4:-runs}"
  out_rec="${res_dir}/sweep_o${om}_N${bu}_a${al}.out"
# in_gen $bu $om $al > $out_rec
  ../bin/d2ca_zosc_visc_full_floquet_m32 > "$out_rec" < <(
    in_gen $bu $om $al
  )
  mv *B${om}*N${bu}*_*F${al}_* "$res_dir"
}

export -f in_gen my_job

trap "trapped" 1 2 3 4 5 6 7 8 

! [[ -d "$sbatch_dir" ]] && mkdir -p "$sbatch_dir" || :
! [[ -d "$d_dir_base" ]] && mkdir -p "$d_dir_base" || :

mapfile -t alphas < <(
  python -c "for k in range(10,370,10): print('{:d}e-3'.format(k))"
)
buoys_=(1e2 2e2 1e3 2e3 1e4 1e5 2e5)
d_dirs=()

for buoy_ in ${buoys_[@]}; do
  data_dir="${d_dir_base}N${buoy_}/o${omega}"
  ! [[ -d "$data_dir"   ]] && mkdir -p "$data_dir"   || :
  d_dirs+=("$data_dir")
done

sbatch --comment="d2zv LSA Gr o${omega}" << EOF
#!/bin/bash
#SBATCH -p skx-normal
#SBATCH -t 1-0:00
#SBATCH --nodes=1-1
#SBATCH --ntasks=1
#SBATCH --mincpus=$OVERHEAD_CPUS
#SBATCH --mail-type ALL
#SBATCH --mail-user yalim@asu.edu
#SBATCH -o "${sbatch_rec}.out"
#SBATCH -e "${sbatch_rec}.err"
##SBATCH --cpus-per-task=$OVERHEAD_CPUS

ml -python/2.7.13 intel/17.0.4

[[ -d "lib/" ]] && {
  export LD_LIBRARY_PATH=":$(readlink -f lib/):$LD_LIBRARY_PATH"
  export    LIBRARY_PATH="$LD_LIBRARY_PATH"
} || :

export MKL_NUM_THREADS=$MKL_CPUS
ulimit -s unlimited

echo "Jobs:"
parallel -v -j $OVERHEAD_JOBS  \\
  my_job {1} $omega {3} {2}    \\
    :::  ${buoys_[@]}          \\
    :::+ ${d_dirs[@]}          \\
    :::  ${alphas[@]}            
#rsync -avz -r ../LSA_harmonic_hunt $WORK/d2zv/
EOF
