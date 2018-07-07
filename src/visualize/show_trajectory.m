function show_trajectory(video_path, output_path, anno, object_id)
if ~exist(output_path, 'dir')
    mkdir(output_path);
end
frames = dir(fullfile(video_path, '*.jpg'));
for f = 1: length(frames)
    frame = imread(fullfile(video_path, [num2str(f, '%07d'), '.jpg']));
    if ~isempty(anno{f,object_id})
        box = anno{f, object_id};
        frame = draw_rect(frame, box(1:2), box(3:4),  2, [255, 0, 0]);
    end
    frame = imresize(frame, [480, 680]);
    imwrite(frame, fullfile(output_path, [num2str(f, '%07d'), '.jpg']));
end