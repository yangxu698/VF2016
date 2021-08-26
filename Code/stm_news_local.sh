#!/bin/bash
#$ -M yxu6@nd.edu       # Email address for job notification
#$ -m abe               # Send mail when job begins, ends and aborts
#$ -q debug             # Specify queue
#$ -pe smp 1           # Specify number of cores to use.
#$ -N  news_local_stm # Specify job name

module load R gsl
export LD_LIBRARY_PATH=/afs/crc.nd.edu/user/y/yxu6/mpfr/lib:$LD_LIBRARY_PATH


R CMD BATCH stm_news_local.r
