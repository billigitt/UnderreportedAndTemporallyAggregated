#!/bin/bash
#SBATCH --job-name=OG1Inc
#SBATCH --time=1-24:00:00
#SBATCH --mem=1g 
#SBATCH --export=ALL
#SBATCH --array=1-20%20
#SBATCH --ntasks=1


module load julia

cd ../julia

julia largeScaleStudyIncreasingSLURMRhoOG1.jl

