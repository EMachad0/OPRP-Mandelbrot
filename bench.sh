#!/bin/bash

RUNS=10
WARMUP=3
PARAMETERS="num_threads 1 8"

# Prepare execution
ID=`date +%y%m%d%H%M%S`

IN=mandelbrot.in
OUT=out/$ID
LOG=log/$ID

mkdir -p $OUT
mkdir -p $LOG

echo "ID" $ID

# Sequential
SEQ_SETUP="make -C seq clean all"
SEQ="./seq/mandelbrot.out {num_threads} < $IN > $OUT/seq.out"

# cpp
CPP_SETUP="make -C cpp clean all"
CPP="./cpp/mandelbrot.out {num_threads} < $IN > $OUT/cpp.out"

# rust
RUST_SETUP="cargo build --manifest-path rust/Cargo.toml --release"
RUST="./rust/target/release/mandelbrot {num_threads} < $IN > $OUT/rust.out"

# openmp
OPENMP_SETUP="make -C openmp clean all"
OPENMP="./openmp/mandelbrot.out {num_threads} < $IN > $OUT/cpp.out"

# Benchmarks
# hyperfine -s "$SEQ_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "$SEQ" --export-markdown $LOG/log_seq.md --export-csv $LOG/log_seq.csv --export-json $LOG/log_seq.json #--show-output

# hyperfine -s "$CPP_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "$CPP" --export-markdown $LOG/log_cpp.md --export-csv $LOG/log_cpp.csv --export-json $LOG/log_cpp.json #--show-output
hyperfine -s "$OPENMP_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "OMP_SCHEDULE=static $OPENMP" --export-markdown $LOG/log_openmp_static.md --export-csv $LOG/log_openmp_static.csv --export-json $LOG/log_openmp_static.json #--show-output
hyperfine -s "$OPENMP_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "OMP_SCHEDULE=dynamic $OPENMP" --export-markdown $LOG/log_openmp_dynamic.md --export-csv $LOG/log_openmp_dynamic.csv --export-json $LOG/log_openmp_dynamic.json #--show-output
hyperfine -s "$OPENMP_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "OMP_SCHEDULE=guided $OPENMP" --export-markdown $LOG/log_openmp_guided.md --export-csv $LOG/log_openmp_guided.csv --export-json $LOG/log_openmp_guided.json #--show-output
# hyperfine -s "$RUST_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "$RUST" --export-markdown $LOG/log_rust.md --export-csv $LOG/log_rust.csv --export-json $LOG/log_rust.json #--show-output

# Generate plots
./plot.sh $ID
