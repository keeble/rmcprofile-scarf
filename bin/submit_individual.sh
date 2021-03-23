#!/bin/bash

Help()
{
    # Display some help
    echo "--------------------------------------------------------------------------"
    echo "submitter takes a stem name as a single input, and submits this stemname"
    echo "to the SLURM queue system"
    echo
    echo "Syntax: submitter [-h] [-v version] working_dir stemnam"
    echo
    echo "Options"
    echo " h                 Displays this help message"
    echo " working_dir       the directory in which your rmcprofile files are"
    echo " stemnane          The stemname of the RMCProfile run "
    echo " version           version of rmcprofile to use. leave blank for current"
    echo "--------------------------------------------------------------------------"
}
OPTIONS=hv:
LONGOPTS=help,version

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

VERSION=""

while true; do
    case "$1" in
        -h|--help)
            Help
            exit
            ;;
        -v|--version)
            VERSION="/$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error parsing input arguments"
            echo "$2"
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

if [[ $VERSION == "/6.7.8" ]]; then
    # echo 'export SINGULARITY_BIND="/work3,/scratch,/apps,/usr/share/lmod/lmod,/usr/share/lmod/lmod/libexec,/usr/share/lua,/usr/share/tcl8.5/init.tcl,/usr/bin/lua,/usr/bin/tclsh,/etc/profile.modules,/usr/lib64/liblua-5.1.so,/usr/lib64/libreadline.so.6,/usr/lib64/libncurses.so.5,/usr/lib64/libtinfo.so.5,/usr/lib64/lua,/usr/lib64/libtcl8.5.so"' >> $JOBFILE
    echo 'export SINGULARITY_BIND="/work3,/scratch,/apps"' >> $JOBFILE
    # echo 'source /usr/share/lmod/lmod/init/bash' >> $JOBFILE
    echo 'singularity exec /home/vol05/scarf835/rmcprofile-scarf/bin/rmcprofile.sif rmcprofile' $2 >> $JOBFILE
else
    echo 'runme.sh ' $2 $VERSION >> $JOBFILE
fi

sbatch $JOBFILE
