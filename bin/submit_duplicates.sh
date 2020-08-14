#!/bin/bash

Help()
{
    # Display some help
    echo "--------------------------------------------------------------------------"
    echo "submit_duplicates will go through all of the directories you specifiy,"
    echo "and submit RMCProfile <stemname> for each one to the queue system. "
    echo
    echo "Syntax: submit_duplicates [-h] [-d directory_prefix] stem_name"
    echo
    echo "Arguments"
    echo " stem_name         the RMCProfile stem name"
    echo
    echo "Options"
    echo " h                 Displays this help message"
    echo " directory_prefix  All of the directories in this directory matching this"
    echo "                   prefix will be included (default: run)"
    echo "--------------------------------------------------------------------------"
}

OPTIONS=hd:
LONGOPTS=help,directory_prefix

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

DIRECTORY_PREFIX="run"

while true; do
    case "$1" in
        -d|--directory_prefix)
            DIRECTORY_PREFIX="$2"
            shift 2
            ;;
        -h|--help)
            Help
            exit
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error parsing input arguments"
            Help
            exit 3
            ;;
    esac
done

if [[ $# -ne 1 ]]; then
    Help
    echo "No stem name supplied"
    exit 1
fi

Submit()
{
    submit_individual.sh $1 $2
}
export -f Submit
find . -maxdepth 1 -mindepth 1 -type d -name "$DIRECTORY_PREFIX*" -exec readlink -f {} \; | xargs -I{} bash -c "Submit {} $1" 

exit 0 
