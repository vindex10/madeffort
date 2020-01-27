#!/bin/bash

set -e
set -x

CMD=$1
MAD_OUTPUT="${MAD_OUTPUT}"

if [ -z "$MAD_OUTPUT" ]; then
    echo "Provide path to madgraph output: MAD_OUTPUT='path...' ./build.sh cmd"
    exit 1;
fi

# madeffort dir. location of build.sh executable
MADEFFORT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUTPUT_DIR=`pwd`/output/madeffort

# make sure libs are built
make -C "$MAD_OUTPUT/Source"

function make_dirs () {
    path="$1";
    echo "$path"
    path_dir="$(dirname "$path")"
    mkdir -p "$path_dir"
    subdirs=$(find "$path_dir" -type d)
    for subdir in $subdirs; do
        touch "$subdir/__init__.py"
    done
}

function build_matrix () {
    matrix_fs=$(ls "$MAD_OUTPUT/SubProcesses/"P*/matrix*.f)
    for matrix_f in $matrix_fs; do
        key="${matrix_f#$MAD_OUTPUT/}"

        m_target="$OUTPUT_DIR/${key%.f}.so"
        m_fname=$(cat "$matrix_f" | grep -m1 "SUBROUTINE" | sed 's/SUBROUTINE//' | sed 's/([^)]\+)//' | sed 's/[[:blank:]]//g' | awk '{ print tolower($0) }')
        m_sources="$MADEFFORT_DIR/src/matrix/matrix.cpp"

        make_dirs "$m_target"

        subprocess_dir="$(echo $matrix_f | grep -o -E 'SubProcesses/P[^/]+/')"
        subprocess_dir="$MAD_OUTPUT/$subprocess_dir"
        TARGET="$m_target" FNAME="$m_fname" SOURCES="$m_sources" make -C "$subprocess_dir" -f "$MADEFFORT_DIR/src/matrix/Makefile" "$m_target"
    done
}

build_${CMD}
