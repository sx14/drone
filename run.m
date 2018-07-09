close all; clc; clear;
data_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/sequences';
output_root = '/home/sunx/output/drone/train';
video_name = 'uav0000124_00944_v';
% pspnet_main(data_root, fullfile(output_root, 'pspnet'), video_name);
flow_main_v1(data_root, fullfile(output_root, 'flow'), video_name);
flow_main_v2(data_root, fullfile(output_root, 'flow'), fullfile(output_root, 'resize'), video_name);
% scene_main(fullfile(output_root, 'pspnet', 'gray'), fullfile(output_root, 'scene'), video_name);
% motion_main(fullfile(output_root, 'flow'), fullfile(output_root, 'scene', 'gray'), fullfile(output_root, 'motion'), video_name);