function resize_img(video_package_path,output_path,video_dir,suffix,width,height, method)
video_path = fullfile(video_package_path,video_dir);
video_resize_path = fullfile(output_path,video_dir);
if ~exist(video_resize_path,'dir')
    mkdir(output_path, video_dir);
end
imgs = dir(fullfile(video_path, ['*.',suffix]));
for i = 1:length(imgs)
    num1=num2str(i,'%07d');
    img_name = [num1,'.',suffix];
    resized_img_name = fullfile(video_resize_path,img_name);
    if strcmp(suffix, 'jpg')
        I1 = imread(fullfile(video_path, img_name));
        I1 = imresize(I1, [height, width], method);
        imwrite(I1, resized_img_name);
    else
        I1 = readFlowFile(fullfile(video_path, img_name));
        I1 = imresize(I1, [height, width], method);
        writeFlowFile(I1, resized_img_name);
    end
end
disp('resize_img finished.');
