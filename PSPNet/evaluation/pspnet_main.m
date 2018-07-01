function pspnet_main(data_root, output_root, video_name)
if ~exist(output_root, 'dir')
    mkdir(output_root);
end
pspnet_root = fileparts(which(mfilename));
addpath(genpath('visualizationCode'));
model_weights = fullfile(pspnet_root,'model/pspnet50_ADE20K.caffemodel');
model_deploy = fullfile(pspnet_root,'prototxt/pspnet50_ADE20K_473.prototxt');
fea_cha = 150; %number of classes
base_size = 512; %based size for scaling
crop_size = 473; %crop size fed into network
data_class = 'objectName150.mat'; %class name
data_colormap = 'color150.mat'; %color map

interval = 1;

save_gray_folder = fullfile(output_root, 'gray'); %path for predicted gray image
save_color_folder = fullfile(output_root, 'color'); %path for predicted color image
scale_array = [1]; %set to [0.5 0.75 1 1.25 1.5 1.75] for multi-scale testing
mean_r = 123.68; %means to be subtracted and the given values are used in our training stage
mean_g = 116.779;
mean_b = 103.939;

gpu_id = 0;
if nargin==2
    videos = dir(fullfile(data_root,'*'));
    for i = 3:length(videos)
        video = videos(i);
        save_color_folder_curr = fullfile(save_color_folder, video.name);
        save_gray_folder_curr = fullfile(save_gray_folder, video.name);
        video_scene_seg(fullfile(data_root, video.name),model_weights,model_deploy,fea_cha,base_size,crop_size,data_class,data_colormap, ...
            save_gray_folder_curr,save_color_folder_curr,gpu_id,scale_array,mean_r,mean_g,mean_b,interval)
    end
end
if nargin==3
    save_color_folder_curr = fullfile(save_color_folder, video_name);
    save_gray_folder_curr = fullfile(save_gray_folder, video_name);
    video_scene_seg(fullfile(data_root, video_name),model_weights,model_deploy,fea_cha,base_size,crop_size,data_class,data_colormap, ...
        save_gray_folder_curr,save_color_folder_curr,gpu_id,scale_array,mean_r,mean_g,mean_b,interval)
end