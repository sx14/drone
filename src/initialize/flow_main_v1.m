function flow_main_v1(video_root, output_root, video_name)
direction = 'forward'; % backward
if ~exist(output_root, 'dir')
    mkdir(output_root);
end
if nargin==2
    videos = dir(fullfile(video_root,'*'));
    for i = 3:length(videos)
        video = videos(i);
        cal_flow_fn(fullfile(video_root, video.name), fullfile(output_root, video.name), direction)
%         cal_flow_match(video_root, output_root, video.name, direction);
    end
end
if nargin==3
    cal_flow_fn(fullfile(video_root, video_name), fullfile(output_root, video_name), direction)
%     cal_flow_match(video_root, output_root, video_name, direction);
end
