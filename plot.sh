#!/bin/bash

ID=`ls log | tail -n 1`

if [ ! -z "$1" ]
    then
    ID=$1
fi

LOG=log/$ID

# Create python virtual enviroment and locally install required packages
if [[ ! -d plot/venv ]]
then
    echo "Creating python virtual enviroment"
    python3 -m venv plot/venv
    source plot/venv/bin/activate
    pip3 install --upgrade pip
    pip3 install -r plot/requirements.txt
fi

# Activate virtual enviroment
source plot/venv/bin/activate

# python3 plot/plot_parametrized.py $LOG/log_seq.json $LOG/log_cpp.json $LOG/log_rust.json --titles seq,cpp,rust -o plot/parametrized.png
python3 plot/plot_parametrized.py $LOG/log_cpp.json $LOG/log_rust.json $LOG/log_openmp_static.json $LOG/log_openmp_dynamic.json $LOG/log_openmp_guided.json --titles cpp_pthread,rust_rayon,cpp_openmp_static,cpp_openmp_dynamic,cpp_openmp_guided -o plot/parametrized.png

python3 plot/plot_speedup.py $LOG/log_cpp.json $LOG/log_rust.json $LOG/log_openmp_static.json $LOG/log_openmp_dynamic.json $LOG/log_openmp_guided.json --titles cpp_pthread,rust_rayon,cpp_openmp_static,cpp_openmp_dynamic,cpp_openmp_guided -o plot/speedup.png
