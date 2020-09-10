#!/bin/bash

Help()
{
    # Display some help
    echo "--------------------------------------------------------------------------"
    echo "submit_duplicates will go through all of the directories you specifiy,"
    echo "and submit RMCProfile <stemname> for each one to the queue system. "
    echo
    echo "Syntax: submit_duplicates [-h] [-d directory_prefix] [-v version] stem_name"
    echo
    echo "Arguments"
    echo " stem_name         the RMCProfile stem name"
    echo
    echo "Options"
    echo " h                 Displays this help message"
    echo " directory_prefix  All of the directories in this directory matching this"
    echo "                   prefix will be included (default: run)"
    echo " version           Specify an installed version of RMCProfile, eg 6.7.4"
    echo "                   The default is the current default version installed"
    echo "                   on SCARF. For more information on available and default"
    echo "                   versions, please type 'module avail RMCProfile'"
    echo "--------------------------------------------------------------------------"
}

OPTIONS=hdv:
LONGOPTS=help,directory_prefix,version

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

DIRECTORY_PREFIX="run"
RMCPROFILE_VERSION=""

while true; do
    case "$1" in
        -d|--directory_prefix)
            DIRECTORY_PREFIX="$2"
            shift 2
            ;;
        -v|--version)
            RMCPROFILE_VERSION="-v $2"
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
STEMNAME="$1"
Submit()
{
    submit_individual.sh $1 $2 $3 $4
}
export -f Submit
find . -maxdepth 1 -mindepth 1 -type d -name "$DIRECTORY_PREFIX*" -exec readlink -f {} \; | xargs -I{} bash -c "Submit $RMCPROFILE_VERSION {} $STEMNAME"

exit 0 
