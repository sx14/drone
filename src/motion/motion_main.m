function motion_main(flow_root, scene_root, output_root, video_name)
if ~exist(output_root, 'dir')
    mkdir(output_root);
end
if nargin==3
    flow_videos = dir(fullfile(flow_root,'*'));
    for i = 3:length(flow_videos)
        flow_video = flow_videos(i);
        save_motion_path = fullfile(output_root,flow_video.name);
        flow_video_path = fullfile(flow_root, flow_video.name);
        scene_video_path = fullfile(scene_root, video.name);
        process_video(flow_video_path,scene_video_path, save_motion_path);
    end
end
if nargin==4
   save_motion_path = fullfile(output_root,video_name);
   flow_video_path = fullfile(flow_root, video_name);
   scene_video_path = fullfile(scene_root, video_name);
   process_video(flow_video_path, scene_video_path, save_motion_path);
end


function process_video(flow_path, scene_path, output_path)
if ~isdir(output_path)
    mkdir(output_path);
end
background_labels = [2,3,5,10];
flows = dir(fullfile(flow_path,'*.flo'));
for i = 1:length(flows)
    frame_index = num2str(i, '%07d');
    flow = readFlowFile(fullfile(flow_path, [frame_index, '.flo']));
    scene = imread(fullfile(scene_path,[frame_index, '.png']));
    motion_map = extract_moving_region(scene, flow, background_labels);
    imwrite(motion_map, fullfile(output_path, [frame_index, '.png']));
end
