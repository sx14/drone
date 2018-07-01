clear;clc;
annotation_path = '/home/sunx/dataset/drone/scene/region/annotation';
org_data_path = '/home/sunx/dataset/drone/scene/scene/train';
train_path = '/home/sunx/dataset/drone/scene/region/train'; 
% generate train data, so this is output path
scenes = dir(fullfile(annotation_path,'*'));
for s = 3:length(scenes)
    scene_path = fullfile(annotation_path, scenes(s).name);
    anno_dirs = dir(fullfile(scene_path,'*_json'));
    for a = 1:length(anno_dirs)
        anno_dir_name = anno_dirs(a).name;
        anno_dir_path = fullfile(scene_path, anno_dirs(a).name);
        img_index = anno_dir_name(start:end-5);
        org_img_path = fullfile(org_data_path, scenes(s).name,[img_index,'.jpg']);
        org_img = imread(org_img_path);
        [slic_mask, sp_sum] = slicmex(org_img,100);
        manual_mask_path = fullfile(anno_dir_path,'label.png');
        manual_mask = imread(mask_path);
        region_classes = get_region_classes(fullfile(anno_dir_path,'label_names.txt'));
    end
end

function region_classes = get_region_classes(label_file)
    file = fopen(label_file);
    labels = {};
    while ~feof(file)
        label = fgetl(file);
        labels = {labels, label};
    end
end
