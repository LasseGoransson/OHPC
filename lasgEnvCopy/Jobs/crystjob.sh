#!/bin/bash
#SBATCH -A <account>
#SBATCH -n 8
# Spread the tasks evenly among the nodes
#SBATCH --ntasks-per-node=8
#SBATCH --time=35:15:00
# Want the node exlusively
#SBATCH --exclusive 

echo "Starting at `date`"
echo "Running on hosts: $SLURM_NODELIST"
echo "Running on $SLURM_NNODES nodes."
echo "Running on $SLURM_NPROCS processors."
echo "Current working directory is `pwd`"

srun /usr/lib64/openmpi/bin/lmp_g++ -in /home/lasg/cryst/cryst.lam
echo "Program finished with exit code $? at: `date`"
