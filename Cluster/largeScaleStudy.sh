#!/bin/bash
#SBATCH --job-name=newMethodInference
#SBATCH --time=1-24:00:00
#SBATCH --mem=1g 
#SBATCH --export=ALL
#SBATCH --array=1-110%10
#SBATCH --ntasks=1


module load julia

cd ../julia

# julia largeScaleStudySLURM.jl
julia largeScaleStudySLURMNewFinalMaxInc5e2.jl
