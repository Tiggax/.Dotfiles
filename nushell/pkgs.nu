#!/bin/nu
def pacman_deps_wrapper [
    --flag (-f): string
] {
    echo $"pacman ($flag)"

    pacman $flag |
        lines |
        split column " " |
        rename package version
}


def cargo_deps [] {
    echo "cargo install  --list"

    cargo install --list |
        lines |
        find -rm ":\$" |
        str replace ":$" "" |
        split column " v" |
        rename package version
}


def pip_deps [] {
    echo "pip freeze"

    pip freeze  |
        lines |
        split column "==" |
        rename package version
}


def pipx_deps [] {
    echo "pipx list"

    pipx list |
        lines |
        find ", installed" |
        str trim |
        str replace "package " "" |
        str replace ", installed using Python" "" |
        split column " " |
        rename package version python
}


let x = {
    pkgs: {
        pacman:
            {
                all: (pacman_deps_wrapper --flag "-Q"),
                explicit: (pacman_deps_wrapper --flag "-Qe"),
                native: (pacman_deps_wrapper --flag "-Qen"),
                foreign: (pacman_deps_wrapper --flag "-Qem")
            }
        rust:
            {
                cargo: (cargo_deps)
            }
        python:
            {
                pip: (pip_deps),
                pipx: (pipx_deps)
            }
    }
}

$x | save ~/.config/nushell/pkgs.toml
