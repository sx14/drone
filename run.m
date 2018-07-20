close all; clc; clear;
data_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/sequences';
output_root = '/home/sunx/output/drone/val';
video_name = 'uav0000339_00001_v';
scene_parsing_interval = 3;
% flow_main_v1(data_root, fullfile(output_root, 'flow'), video_name);
% flow_main_v2(data_root, fullfile(output_root, 'flow'), fullfile(output_root, 'resize'), video_name);
% pspnet_main(data_root, fullfile(output_root, 'pspnet'), scene_parsing_interval, video_name);
% scene_parsing_main(fullfile(output_root, 'pspnet', 'gray'), fullfile(output_root, 'scene'), video_name);
scene_supply_with_flow(fullfile(output_root, 'scene'), fullfile(output_root, 'flow'), scene_parsing_interval)
% motion_main(fullfile(output_root, 'flow'), fullfile(output_root, 'scene', 'gray'), fullfile(output_root, 'motion'), video_name);
% scene_classify_main(data_root, fullfile(output_root, 'scene_category'));