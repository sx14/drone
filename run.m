close all; clc; clear;
data_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/sequences';
output_root = '/home/sunx/output/drone';
video_name = 'uav0000013_00000_v';
% pspnet_main(data_root, fullfile(output_root, 'pspnet'), video_name);
% cal_flow_match(data_root, fullfile(output_root, 'flow'), video_name, 'forward');
% scene_main(fullfile(output_root, 'pspnet', 'gray'), fullfile(output_root, 'scene'), video_name);
% motion_main(fullfile(output_root, 'flow'), fullfile(output_root, 'scene'), fullfile(output_root, 'motion'), video_name);