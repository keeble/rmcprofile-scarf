# rmcprofile-scarf
Help for running RMCProfile on the Scientific Computing Application Resource for Facilities (SCARF).
## 1. General Notes on RMCProfile on SCARF
1. There are, at any given time, potentially multiple versions of RMCProfile installed. To see which are currently installed, type :
    ```
    module avail RMCProfile
    ```
    which should yield, amongst other things, something like this :
    ```
    ------------------- /apps/eb/modulefiles/all --------------------
    RMCProfile/6.7.4    RMCProfile/6.7.7 (D)
    
    Where:
    D:  Default Module
    ```
    showing that there are currently two versions available, and which you get by default.

## 2. Instructions for use
1. Load these tools by typing:
    ```
    module load rmcprofile-tools
    ```
    This step will need to be performed once in each terminal session you'd like to use them. 
2. Come up with your good starting configuration for your RMCProfile run on your own machine.
2. Login to SCARF and create a working root directory, for example `mkdir ~/example_root`
4. Copy your good starting point into a subdirectory of your working root directory. Call it something useful like "initial" or "starting". There are various ways of transferring files to and from SCARF, e.g. [SAMBA](https://www.scarf.rl.ac.uk/documentation/samba) or scp:
    ```
    $ scp -r /path/to/my/starting/configuration/ <username>@scarf.rl.ac.uk:~/example_root
    ```
5. Duplicate this directory. The tool `create_duplicates.sh`, which should be called from your working root directory, will do this for you. It's call looks like this:
    ```
    cd ~/example_root
    create_duplicates.sh [-h] [-n number] [-d destination] [-p prefix] initial
    ```
    where n is an optional number of duplicates to make (default 10), d is an optional destination to place the duplicates (default is the current directory), and prefix will be used to name all the created directories (default is 'run'). Initial is the only required argument, and it's the path to your inital directory you just made. This can be a relative or absolute path. 

6. Submit your duplicates. The tool `submit_duplicates.sh` will do this for you. It's call looks like this:
    ```
    submit_duplicates.sh [-h] [-d directory_prefix] [-v version] stem_name
    ```
    which will essentially queue `rmcprofile stem_name` in every directory that begins with `directory_prefix` within your current directory (the default prefix if none is supplied is run*, which is the default output of create_duplicates.sh, above). This way you can ensure your starting copy will not be submitted. You can optionally supply a version of RMCProfile; if you do not supply a version explicitly, the default version of RMCProfile (see above) is used. Some examples of this call are:
    ```
    submit_duplicates.sh rmcsf6_190k
    submit_duplicates.sh -d sf6_on_scarf rmcsf6_190k
    submit_duplicates.sh -v 6.7.4 rmcsf6_190k
    ```
7. Wait for your runs to finish. You can see how many jobs you have in queues with the command `squeue -u $USER` or you can watch this command with `watch "squeue -u $USER"`. Each of the directories should contain a `.job` file, which details the job queue submission; and a `.log` file, which stores the output from RMCProfile as it is run.
# Credits
Massive thanks to Helen Playford (ISIS) and Matt Tucker (Oak Ridge) for doing _all_ of the development on this repo! 
