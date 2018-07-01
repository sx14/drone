function scene_main(pspnet_scene_root, output_root, video_name)
if ~exist(output_root, 'dir')
    mkdir(output_root);
end
if nargin==2
    pspnet_scene_videos = dir(fullfile(pspnet_scene_root,'*'));
    for i = 3:length(pspnet_scene_videos)
        pspnet_scene_video = pspnet_scene_videos(i);
        save_scene_path = fullfile(output_root, pspnet_scene_video.name);
        pspnet_scene_video_path = fullfile(pspnet_scene_root, pspnet_scene_video.name);
        process_video(pspnet_scene_video_path, save_scene_path);
    end
end
if nargin==3
        save_scene_path = fullfile(output_root, video_name);
        pspnet_scene_video_path = fullfile(pspnet_scene_root, video_name);
        process_video(pspnet_scene_video_path, save_scene_path);
end


function process_video(pspnet_scene_path, output_path)
if ~isdir(output_path)
    mkdir(output_path);
end
pspnet_scene_maps = dir(fullfile(pspnet_scene_path,'*.png'));
for i = 1:length(pspnet_scene_maps)
    frame_index = num2str(i, '%07d');
    pspnet_scene_map = imread(fullfile(pspnet_scene_path, [frame_index, '.png']));
    scene_map = convert2scene(pspnet_scene_map);
    imwrite(uint8(scene_map), fullfile(output_path, [frame_index, '.png']));
end
