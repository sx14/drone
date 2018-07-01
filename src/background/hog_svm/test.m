
clear;clc;
patch_size = 32;
hog_bin_size = 8;
hog_nOrients = 9;

load('/home/sunx/workspace/matlab-workspace/drone/background/svm/2.mat');
img = imread('17.jpg');
[w,h,~] = size(img);
img_area = w * h;
patch_num = floor(img_area/(patch_size ^ 2));
[sp_map, numlabels] = slicmex(img,patch_num,10);
% figure;
% imagesc(sp_map);
% figure;
% imshow(img);
% input('a');

for i = 0:(numlabels-1)
    temp_sp_map = sp_map == i;
    [x,y,~] = find(temp_sp_map);
    x_max = max(x);
    x_min = min(x);
    y_max = max(y);
    y_min = min(y);
    patch = img(x_min:x_max,y_min:y_max,:);
    patch = imresize(patch,[patch_size,patch_size]);
    h = hog(single(patch),hog_bin_size,hog_nOrients);
    [class,score] = predict(svmStruct,h(:)');
    if class == 1
        r = img(:,:,1);
        r(temp_sp_map) = 0;
        g = img(:,:,2);
        g(temp_sp_map) = 0;
        b = img(:,:,3);
        b(temp_sp_map) = 0;
        img(:,:,1) = r;
        img(:,:,2) = g;
        img(:,:,3) = b;
    end
end
a = 1;
