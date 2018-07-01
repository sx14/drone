function [sp_map, img_patches, patch_labels] = split_img_with_labels(img, patch_num, patch_size, annotation_map)
[sp_map, numlabels] = slicmex(img,patch_num,10);
% figure;
% imagesc(sp_map);
% figure;
% imshow(img);
% input('a');
img_patches = cell(numlabels,1);
patch_labels = zeros(numlabels,1);
for i = 0:(numlabels-1)
    temp_sp_map = sp_map == i;
    temp_labels = annotation_map(temp_sp_map);
    points_num = length(temp_labels);
    temp_label = mode(temp_labels);
    temp_label_sum = length(find(temp_labels == temp_label));
    if temp_label_sum < points_num * 0.8
        temp_label = -1;
    end
    [x,y,~] = find(temp_sp_map);
    x_max = max(x);
    x_min = min(x);
    y_max = max(y);
    y_min = min(y);
    patch = img(x_min:x_max,y_min:y_max,:);
    patch = imresize(patch,[patch_size,patch_size]);
    img_patches{i+1} = rgb2gray(patch);
    patch_labels(i+1) = temp_label;
end


