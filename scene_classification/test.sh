#!/usr/bin bash
# dataset_root=/media/sunx/Data/drone_dataset/VisDrone-Dataset/4-Multi-Object-Tracking/VisDrone2018-MOT-val/sequences
# output_root=/home/sunx/output/drone/val/scene_category
# step=100
python run_placesCNN_basic_all.py --data $1 --output $2 --step $3