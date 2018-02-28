#!/usr/bin/env bash

BUILD_SCRIPT_PATH=/build_scripts

echo "In $0, about to loop through ${BUILD_SCRIPT_PATH}"

for s in ${BUILD_SCRIPT_PATH}/*; do
    echo "Executing $s"
    $s
    echo "Status code from $s is $?"
done
