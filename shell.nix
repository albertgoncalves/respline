{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "OcamlPython";
    buildInputs = [
        (with ocaml-ng.ocamlPackages_4_07; [
            cairo2
            findlib
            ocaml
            ounit
            utop
        ])
        (python37.withPackages(ps: with ps; [
            flake8
            matplotlib
        ]))
    ];
    shellHook = ''
        if [ $(uname -s) = "Darwin" ]; then
            alias ls="ls --color=auto"
            alias ll="ls -l"
        else
            alias open="xdg-open"
        fi
        alias flake8="flake8 --ignore E124,E128,E201,E203,E241,E306,W503,E731"
        export WD=$(pwd)
        for d in pngs/ bin/; do
            if [ ! -d $d ]; then
                mkdir $d
            fi
        done
    '';
}
