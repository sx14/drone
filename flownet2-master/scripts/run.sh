#! /bin/bash
# $1 PYTHONPATH $2 run-flownet-many.py $3 model $4 deploy $5 list
LD_LIBRARY_PATH=""
PYTHONPATH=$1
python $2 $3 $4 $5
