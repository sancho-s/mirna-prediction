#!/usr/bin/env python

#-------------------------------------------------------------------------------
# Name:        make_run_scripts_04.py
# Purpose:     Make a run script for qsub and log extra info for each chr.
#              Output a file with all required qsub commands.
#
# Author:
#
# Created:     11/11/2015
# Copyright:   (c)  2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

def main():
    """Make a run script for qsub and log extra info for each chr.
    Output a file with all required qsub commands."""
    prescript = '04_calc_GRMs'
    with open('qsub.txt','w') as qsubfile :

        #for i in range(22,23) :
        #for i in range(1,23) :
        for i in range(0,23) :
            jobfilename = 'runscripts/run_' + prescript + '_chr' + str(i) + '.sh'
            output = '''#!/bin/bash
#PBS -N R.grms.chr''' + str(i) + '''
#PBS -S /bin/bash
#PBS -l walltime=4:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
cd $PBS_O_WORKDIR

module load R
module load gcta

export LOGFILE=logs/log_chr''' + str(i) + '''.txt
echo PBS_O_WORKDIR = $PBS_O_WORKDIR > $LOGFILE
echo " " >> $LOGFILE

echo PBS_O_WORKDIR = $PBS_O_WORKDIR
echo " "
echo R info:
module display R
echo " "
echo gcta info:
module display gcta

time R --vanilla < ''' + prescript + '.r --args ' + str(i) + '\n'
            with open(jobfilename,'w') as jobfile :
                jobfile.write(output)
            qsubfile.write('qsub ' + jobfilename + '\nsleep 3\n')


#---------------------------------------------------------------------------

if __name__ == '__main__' :
    main()
