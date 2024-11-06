#!/bin/bash
#SBATCH --job-name=OG1RevConstRho
#SBATCH --time=1-24:00:00
#SBATCH --mem=1g 
#SBATCH --export=ALL
#SBATCH --array=1-100%20
#SBATCH --ntasks=1


module load julia

cd ../julia

julia largeScaleStudyOriginalMethodSLURM.jl




