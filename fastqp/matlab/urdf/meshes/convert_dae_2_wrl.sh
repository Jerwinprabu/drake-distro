#!/bin/bash
 # echo of all files in a directory

for file in *.dae
do
  name=${file%%[.]*}
  meshlabserver -i $file -o $name'.wrl' -om vn
  #echo $name'.wrl' 
done
