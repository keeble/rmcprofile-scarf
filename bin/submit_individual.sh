#!/bin/bash

Help()
{
    # Display some help
    echo "--------------------------------------------------------------------------"
    echo "submitter takes a stem name as a single input, and submits this stemname"
    echo "to the SLURM queue system"
    echo
    echo "Syntax: submitter [-h] working_dir stemname"
    echo
    echo "Options"
    echo " h                 Displays this help message"
    echo " working_dir       the directory in which your rmcprofile files are"
    echo " stemnane          The stemname of the RMCProfile run "
    echo "--------------------------------------------------------------------------"
}

OPTIONS=h
LONGOPTS=help

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

while true; do
    case "$1" in
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


if [[ $# -ne 2 ]]; then
    Help
    echo "incorrect number of input params"
    exit 1
fi

# combine stemname and directoryname for job name
JOBSTEM=${1##*/}
JOBFILE=$1/$2_$JOBSTEM.job
echo '#!/bin/bash' > $JOBFILE
echo '#SBATCH -o '$1'/'$JOBSTEM'.log' >> $JOBFILE
echo '#SBATCH -e '$1'/'$JOBSTEM'.err' >> $JOBFILE
echo '#SBATCH -p scarf' >> $JOBFILE
echo '#SBATCH -t 10080' >> $JOBFILE
echo '#SBATCH --job-name='$JOBSTEM >> $JOBFILE
echo '#SBATCH -D ' $1 >> $JOBFILE
echo 'runme.sh ' $2  >> $JOBFILE

sbatch $JOBFILE
