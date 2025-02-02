#!/bin/sh
for i in {1..32}; 
do
    echo -n "${i} "
    sudo renice 19 -u nixbld${i}
done
