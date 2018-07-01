function [org_height, org_width, resized_imgs] = resize_img(video_package_path,output_path,video_dir)
suffix = 'jpg';
video_path = fullfile(video_package_path,video_dir);
video_resize_path = fullfile(output_path,video_dir);
if ~exist(video_resize_path,'dir')
    mkdir(output_path, video_dir);
end
imgs = dir(fullfile(video_path, ['*.',suffix]));
num1=num2str(1,'%07d');
img_name = [num1,'.',suffix];
I = imread(fullfile(video_path,img_name)); % orginal image
org_height = size(I, 1);
org_width = size(I, 2);
resized_imgs = cell(length(imgs),1);
default_length = 500;
for i = 1:length(imgs)
    num1=num2str(i,'%07d');
    img_name = [num1,'.',suffix];
    resized_img_name = fullfile(video_resize_path,img_name);
    if ~exist(fullfile(video_resize_path, img_name),'file')
        I1 = imread(fullfile(video_path, img_name));
        [max_length,~] = max([org_width,org_height]);
        if max_length > default_length
            scale =  default_length / max_length;
            I1 = imresize(I1, scale);
        end
        imwrite(I1, resized_img_name);
        resized_imgs{i+1} = I1;
    else
        I1 = imread(resized_img_name);
        resized_imgs{i+1} = I1;
    end
end
disp('resize_img finished.');
