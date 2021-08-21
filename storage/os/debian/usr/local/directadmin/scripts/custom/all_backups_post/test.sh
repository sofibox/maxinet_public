#!/bin/bash

script_path="$(dirname "$(readlink -f "$0")")"
script_name=$(basename -- "$0")
echo "The name of this script is: ${script_name}"
echo "==========="
# env | grep -v pass > "${script_name}.env"
env >"${script_path}/${script_name}.env"
echo "==========="
echo "The script ${script_name} has finished executed"
