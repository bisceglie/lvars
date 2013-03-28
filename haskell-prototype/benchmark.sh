#!/bin/bash

set -e

make data

num_cores="1 2 4";
# trials=100
trials=9

if [ $(hostname) = "hive.soic.indiana.edu" ];
then
    lock_for_experiments 1000
    num_cores="1 2 4 8 16 32";
fi

## BFS:

# Impure version (experimental -- not working at the moment)
# make q
# for i in $num_cores; do ./quick_io.exe +RTS -N$i; done

# Pure version
make qp

# Run 100 times for each core count.

# Grid graph.  Probably less realistic than a random graph.
#for i in $num_cores; do ./ntimes_minmedmax 100 ./quick_pure.exe +RTS -N$i; done

# Random graph.
for i in $num_cores; do 
  ./ntimes_minmedmax $trials ./quick_lvarpure.exe /tmp/rand +RTS -s -N$i; 
done

if [ $(hostname) = "hive.soic.indiana.edu" ];
then
    unlock_for_experiments
fi