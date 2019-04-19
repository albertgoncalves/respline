#!/usr/bin/env bash

set -e

echo $WD

ocamlfind ocamlopt \
    -package oUnit $WD/src/spline.ml \
    -linkpkg -g $WD/src/test/test.ml \
    -o $WD/bin/test
cd $WD/src/test/
$WD/bin/test
