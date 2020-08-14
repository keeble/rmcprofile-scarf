#!/bin/bash

Help()
{
    # Display some help
    echo "--------------------------------------------------------------------------"
    echo "rmcprofile-submitter submits your duplicated rmcprofile initial configs"
    echo " to scarf for processing"
    echo
    echo "Syntax: rmcprofile-submitter [-h] [-n number] [-d destination] [initial]"
    echo
    echo "Options"
    echo " h                Displays this help message"
    echo " n <number>       number of duplicates to create (default is 100)"
    echo " d <destination>  destination directory into which the duplicates "
    echo "                  are to be placed. (default is current directory) "
    echo " <initial>        path to initial directory. defaults to ./initial"
    echo "--------------------------------------------------------------------------"
}

OPTIONS=hn:d:
LONGOPTS=help,number,destination


! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

NUMBER=100
DEST=$(pwd)
INITIAL=$DEST/initial

while true; do
    case "$1" in
        -n|--number)
            NUMBER="$2"
            shift 2
            ;;
        -d|--destination)
            DEST="$2"
            shift 2
            ;;
        -m|--macro)
            MACROFILE="$2"
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


if [[ $# -eq 1 ]]; then
    INITIAL=$1
fi

echo "copying $INITIAL to $DEST $NUMBER times"
for i in $(seq 1 $NUMBER)
    do
        echo "setting up run $i"
        thisrun=$(printf "%03d" $i)
        cp -r $INITIAL $DEST"/run_"$thisrun
done
exit 0 
