function scene_main(pspnet_scene_root, output_root, video_name)
if ~exist(output_root, 'dir')
    mkdir(output_root);
end
load('color11.mat');
if nargin==2
    pspnet_scene_videos = dir(fullfile(pspnet_scene_root,'*'));
    for i = 3:length(pspnet_scene_videos)
        pspnet_scene_video = pspnet_scene_videos(i);
        save_gray_path = fullfile(output_root, 'gray', pspnet_scene_video.name);
        save_color_path = fullfile(output_root, 'color', pspnet_scene_video.name);
        pspnet_scene_video_path = fullfile(pspnet_scene_root, pspnet_scene_video.name);
        process_video(pspnet_scene_video_path, save_gray_path, save_color_path, colors);
    end
end
if nargin==3
        save_gray_path = fullfile(output_root, 'gray', video_name);
        save_color_path = fullfile(output_root, 'color', video_name);
        pspnet_scene_video_path = fullfile(pspnet_scene_root, video_name);
        process_video(pspnet_scene_video_path, save_gray_path, save_color_path, colors);
end


function process_video(pspnet_scene_path, gray_path, color_path, colors)
if ~isdir(gray_path)
    mkdir(gray_path);
end
if ~isdir(color_path)
    mkdir(color_path);
end
pspnet_scene_maps = dir(fullfile(pspnet_scene_path,'*.png'));
for i = 1:length(pspnet_scene_maps)
    frame_index = num2str(i, '%07d');
    pspnet_scene_map = imread(fullfile(pspnet_scene_path, [frame_index, '.png']));
    scene_map = convert2scene(pspnet_scene_map);
    scene_map = uint8(scene_map);
    rgbPred = colorEncode(scene_map, colors);
    imwrite(uint8(rgbPred), fullfile(color_path, [frame_index, '.png']));
    imwrite(uint8(scene_map), fullfile(gray_path, [frame_index, '.png']));
end
