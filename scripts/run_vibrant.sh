#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate vibrant

# for f in $HOME/project/DeepMicrobeFinder/data/sampled_sequence_subsampled/*.fa
for f in $HOME/project/DeepMicrobeFinder/data/sampled_sequence_subsampled_2000/*.fa
do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo "Predicting $f"
    python $HOME/software/VIBRANT/VIBRANT_run.py -i $f -t 16 -folder $HOME/project/DeepMicrobeFinder/result_other_2000/result_vibrant/
done