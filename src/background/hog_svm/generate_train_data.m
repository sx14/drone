function [hog_data, labels] = generate_train_data(img_path, annotation_path)
hog_feature_file_name = 'features.mat';
feature_file_path = '/home/sunx/workspace/matlab-workspace/drone/background';
if exist(fullfile(feature_file_path,hog_feature_file_name),'file')
    hog_feature_file = load(fullfile(feature_file_path,hog_feature_file_name));
    feature = hog_feature_file.feature;
    hog_data = feature.hog_features;
    labels = feature.labels;
    return;
end
patch_size = 32;
hog_bin_size = 8;
hog_nOrients = 9;
imgs = dir(fullfile(img_path,'*.jpg'));
img_patches = [];
labels = [];

for i = 1:length(imgs)
    img_name = imgs(i).name;
    img_index = img_name(1:end-4);
    img = imread(fullfile(img_path,imgs(i).name));
    if i == 1 % estimate patch num
        [w,h,~] = size(img);
        img_area = w * h;
        patch_num = floor(img_area/(patch_size ^ 2));
    end
    label_map = load(fullfile(annotation_path,[img_index,'.regions.txt']));
    [~, curr_img_patches, curr_labels] = split_img_with_labels(img, patch_num, patch_size, label_map);
    labels = [labels;curr_labels];
    img_patches = [img_patches; curr_img_patches];
end

for i = 1:length(img_patches)
    img = imResample(img_patches{i},[patch_size patch_size])/255;
    h = hog(single(img),hog_bin_size,hog_nOrients);
    if i == 1
        hog_data = zeros(length(img_patches),size(h,1)*size(h,2)*size(h,3));
    end
    hog_data(i,:) = h(:);
end
feature.hog_features = hog_data;
feature.labels = labels;

% save(fullfile(feature_file_path,hog_feature_file_name), 'feature');