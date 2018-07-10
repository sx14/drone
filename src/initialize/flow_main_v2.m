function flow_main_v2(video_root, flow_output_root, resize_output_root, video_name)
direction = 'forward'; % backward
if ~exist(flow_output_root, 'dir')
    mkdir(flow_output_root);
end
if ~exist(resize_output_root, 'dir')
    mkdir(resize_output_root);
end
if nargin==3
    videos = dir(fullfile(video_root,'*'));
    for i = 3:length(videos)
        video = videos(i);
        [resize,width,height,org_width,org_height] = resize_scale(fullfile(video_root, video.name));
        video_path = fullfile(video_root, video.name);
        if resize == 1
            resize_img(video_root,resize_output_root,video.name,'jpg',width,height,'bicubic');
            video_path = fullfile(resize_output_root, video.name);
        end
        cal_flow_fn(video_path, fullfile(flow_output_root, video.name), direction);
        if resize == 1
            resize_img(flow_output_root,flow_output_root,video.name,'flo',org_width,org_height,'nearest');
        end
    end
end
if nargin==4
    [resize,width,height,org_width,org_height] = resize_scale(fullfile(video_root, video_name));
    video_path = fullfile(video_root, video_name);
    if resize == 1
        resize_img(video_root,resize_output_root,video_name,'jpg',width,height,'bicubic');
        video_path = fullfile(resize_output_root, video_name);
    end
    cal_flow_fn(video_path, fullfile(flow_output_root, video_name), direction);
    if resize == 1
        resize_img(flow_output_root,flow_output_root,video_name,'flo',org_width,org_height,'nearest');
    end
end

function [resize,width,height,org_width,org_height] = resize_scale(video_path)
img_path = fullfile(video_path, '0000001.jpg');
img = imread(img_path);
[org_height, org_width, ~] = size(img);
max_length = 1300;
scale = 1;
resize = 0;
max_org_length = max(org_height, org_width);
if max_org_length > max_length
    scale = max_length / max_org_length;
    resize = 1;
end
width = floor(org_width * scale);
height = floor(org_height * scale);