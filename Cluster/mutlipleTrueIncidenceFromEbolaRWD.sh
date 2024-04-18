#!/bin/bash
#SBATCH --job-name=RWDebolaVariousTrueIncidence
#SBATCH --time=1-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=fast 

module load julia

cd ../julia

julia ebolaRWDVariousTrueIncAndInfRho04.jl

