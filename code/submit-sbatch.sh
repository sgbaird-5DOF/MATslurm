#!/bin/bash
module load matlab/r2019b
#fn='get_cmd_test'
fn='randOctParityData'
matlab -nodisplay -nosplash -r "cd ../../; $fn; exit"
