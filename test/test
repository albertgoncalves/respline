#!/usr/bin/env bash

set -e

ocamlfind ocamlopt \
    -I $WD/src/ \
    -package oUnit \
    -linkpkg $WD/src/utils.ml $WD/src/spline.ml $WD/test/test.ml \
    -o $WD/bin/test
cd $WD/test/
$WD/bin/test
