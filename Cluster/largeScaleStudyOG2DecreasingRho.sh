#!/bin/bash
#SBATCH --job-name=OG2Dec
#SBATCH --time=1-24:00:00
#SBATCH --mem=1g 
#SBATCH --export=ALL
#SBATCH --array=1-20%20
#SBATCH --ntasks=1


module load julia

cd ../julia

julia largeScaleStudyDecreasingRhoSLURM.jl

