#!/bin/bash
#$ -M yxu6@nd.edu       # Email address for job notification
#$ -m abe               # Send mail when job begins, ends and aborts
#$ -q debug             # Specify queue
#$ -pe smp 20           # Specify number of cores to use.
#$ -N  editorial_wire # Specify job name

module load R gsl

R CMD BATCH topicmodel_editorial_wire.r