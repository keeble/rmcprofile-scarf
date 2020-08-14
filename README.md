# rmcprofile-scarf
Help for running RMCProfile on the Scientific Computing Application Resource for Facilities (SCARF) 
## workarounds
```
export PATH=$PATH:"/apps/eb/software/RMCProfile/6.7.4/exe"
```
## Installation of these tools
1. clone this repo into your home directory:
```
cd ~
git clone https://github.com/keeble/rmcprofile-scarf.git
```
2. add the installation directory to you path
```
export PATH=$PATH:~/rmcprofile-scarf/bin
```
## instructions for use
1. Come up with your good starting configuration for your RMCProfile run on your own machine.
2. Login to SCARF and create a working root directory, for example `mkdir ~/example_root`
3. Copy your good starting point into a subdirectory of your working root directory. Call it something useful like "initial" or "starting". 
4. Duplicate this directory. The tool `create_duplicates.sh`, which should be called from your working root directory, will do this for you. It's call looks like this:
    ```
    cd ~/example_root
    create_duplicates.sh [-h] [-n number] [-d destination] initial
    ```
    where n is an optional number of duplicates to make (default 10) and d is an optional destination to place the duplicates (default is the current directory). Initial is the only required argument, and it's the path to your inital directory you just made. This can be a relative or abolsute path. 

5. Submit your duplicates. The tool `submit_duplicates.sh` will do this for you. It's call looks like this:
    ```
    submit_duplicates.sh [-h] [-d directory_prefix] stem_name
    ```
    which will essentially queue `rmcprofile stem_name` in every directory that begins with a prefix within your current directory (the default prefix if none is supplied is run*, which is the default output of create_duplicates.sh, above). This way you can ensure your starting copy will not be submitted.  
6. Wait for your runs to finish. You can see how many jobs you have in queues with the command `squeue -u $USER` or you can watch this command with `watch "squeue -u $USER"`. Each of the directories should contain a `.job` file, which details the job queue submission; and a `.log` file, which stores the output from RMCProfile as it is run.
# Credits
Massive thanks to Helen Playford (ISIS) and Matt Tucker (Oak Ridge) for doing _all_ of the development on this repo! 
