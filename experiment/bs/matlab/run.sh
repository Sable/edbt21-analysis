#!/bin/bash
log="log"
log_matlab="$log/log_matlab.txt"
matlab19="/usr/local/pkgs/matlab/R2019a/bin/matlab -nodesktop"
runs=10

mkdir -p $log && rm -f ${log_matlab}

echo "Running MATLAB (save to log/log_matlab.txt) ..."
scales=(1 2 4 8)
for sf in "${scales[@]}"
do
    ${matlab19} -batch "run('data/in_${sf}M.txt', $runs)" >> ${log_matlab}
done

## debug code
##   matlab19 -batch "run('data/in_1M.txt', 1)"

