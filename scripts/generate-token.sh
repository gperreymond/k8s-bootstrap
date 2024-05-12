#!/bin/bash
set -e

generate_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

generate_token() {
    local prefix=$(generate_string 6)
    local suffix=$(generate_string 16)
    echo "${prefix}.${suffix}"
}

echo "Token généré : $(generate_token)"