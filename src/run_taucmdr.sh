#!/bin/bash
#
#SBATCH --job-name=snap_tau
#SBATCH --output=test_tau.txt
#
#SBATCH --ntasks=40
#SBATCH --time=2:00:00
#SBTACH -p skylake-gold

source /usr/projects/artab/soft/taucmdr-x86_64.env
module load mpich/3.3-intel_18.0.3

# parameters for TAU
EXP=sample_ifort_x512  # experiment name - must be created before running this script
tau experiment select $EXP # switch tau to this experiment

export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=^openlib

# command to execute the mkFit program
#    note the '\' before each space
#    also this must be redefined inside the loop to overwrite the variable as they vary
CMD="mpirun -n 40 ./isnap inh0001t1.in temp.out"


#measure_list=(tlb_dm) 
# measurement list; these are tau commander measurements that must be created first
measure_list=(dp_all dp_simd tot_cyc tot_ins lst_ins stl_cyc mem_wcy tcm2 tca2 vec_ins_512 vec_ins_256 vec_ins_128)
# measure_list=(vec_ins_512 vec_ins_256 vec_ins_128)

function run_trials {

	for i in ${measure_list[@]}; do
		tau experiment edit ${EXP} --measurement $i
		tau trial create ${CMD}
	done

}

# run multiple trials that get averaged
#for n in {0..3}; do
run_trials
#done




