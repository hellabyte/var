TRUE=1
FALSE=0

base_ntsp=50000
base_freq=1e-1

in_dir='inputs/'

! [[ -d "$in_dir" ]] && mkdir -p "$in_dir" || :

get_ntsp() {
  freq="$1"
  python << __EOF
base_freq = float($base_freq) 
base_ntsp = int( $base_ntsp )
nf_ratio  = int( base_freq * base_ntsp  )
freq      = float( $freq )
ntsp      = int( nf_ratio / freq )
print(ntsp)
__EOF
}

get_pfix() {
  Re="$1"
  G="$2" # Aspect Ratio
  A="$3" # Amplitude
  f="$4" # frequency
  L="$5" # Label
  pfix=$(printf 'Re%s_G%s_A%s_f%s%s' $Re $G $A $f $L)
  echo $pfix
}

in_gen() {
  pfix="$1"
  freq="$2"
  ntsp="$(get_ntsp $freq)"
  
  cat << __EOF
'$pfix'		! prefix for filenames
'Re2800G1p74_LC1_restart'	    ! name of restart file
2.800d3	    ! reynolds  Omega*R^2/nu
5.d-1 	    ! amp       modulation amplitude (nondimensional)
${freq/e/d} ! freq      omega_m/Omega, modulation frequency
1.74d0	    ! gamma     H/R=Height/Radius (aspect ratio)
$ntsp       ! ntsp      Number of time steps per forcing period 
3.d-3	    ! reg       Discontinuous boundary conditions regularization
50000	    ! npas      number of time steps
10000 	    ! insec     write a full solution every insec time-steps
1 	 ! inpas     write in time-series-files every inpas time-steps
1	 ! init_file number of first output file
0	 ! iaxisym=m m=0 axisym; m>0 m-Fourier subspace; m<0 |m|-rotoreflection
1	 ! ibegin -1 start from solid body rotation + pert, set t=0. NOT WORKING
                  0 start from rest with random perturbation, set t=0.
                  1 continue restart solution, set t=0.
                  2 continue restart solution, keep t.
                  3 continue restart sol. with random pert., set t=0.
0 	    ! imode    azimuthal mode to be perturbed
0.d0 	! pert     amplitude of the vz perturbation
__EOF
}

job() {
  in_rec="$1"
  sbatch_pfix="$2"
  comment="$3"
  sbatch --comment "$comment" << __EOF
#!/bin/bash 
#SBATCH -p serial 
#SBATCH -n 8
#SBATCH -t 96:00:00  
#SBATCH -o "${sbatch_pfix}.out" 
#SBATCH -e "${sbatch_pfix}.err" 
#SBATCH --comment 'Initial Condition: LC1'

module load intel/2016.3 
./main_modVBD_mod < "$in_rec"
__EOF
}

Re=2800e0
G=174e-2
A=5e-1
L=_LC1

freqs=( 
  100e-3
  200e-3
)

for freq in ${freqs[@]}; do
  pfix=$(get_pfix $Re $G $A $freq $L)
  in_rec="${in_dir}/in_${pfix}"
  in_gen $pfix $freq > "$in_rec"
  job "$in_rec" "$pfix" "fixed dt amp sweep freq: $freq"
done  

