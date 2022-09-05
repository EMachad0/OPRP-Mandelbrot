#!/bin/bash

RUNS=10
WARMUP=1
PARAMETERS="num_threads 1 16"

# Prepare execution
ID=`date +%y%m%d%H%M%S`

IN=mandelbrot.in
OUT=out/$ID
LOG=log/$ID

mkdir $OUT
mkdir $LOG

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

# Benchmarks
hyperfine -s "$SEQ_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "$SEQ" --export-markdown $LOG/log_seq.md --export-csv $LOG/log_seq.csv --export-json $LOG/log_seq.json #--show-output

hyperfine -s "$CPP_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "$CPP" --export-markdown $LOG/log_cpp.md --export-csv $LOG/log_cpp.csv --export-json $LOG/log_cpp.json #--show-output

hyperfine -s "$RUST_SETUP" -r $RUNS -w $WARMUP -P $PARAMETERS "$RUST" --export-markdown $LOG/log_rust.md --export-csv $LOG/log_rust.csv --export-json $LOG/log_rust.json #--show-output

# Generate plots
./plot.sh $ID