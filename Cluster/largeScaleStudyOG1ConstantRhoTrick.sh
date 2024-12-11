#!/bin/bash
#SBATCH --job-name=TrickOG1ConstantRho
#SBATCH --time=1-24:00:00
#SBATCH --mem=1g 
#SBATCH --export=ALL
#SBATCH --array=1-100%100
#SBATCH --ntasks=1


module load matlab 

cd ../MATLAB

matlab -nodisplay -nodesktop -nosplash -r "constantRhoOG1Analysis; quit"

