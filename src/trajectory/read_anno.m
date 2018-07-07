% anno : cell (frame_sum * 200)
function anno = read_anno(anno_root, video_root, video_name)
frames = dir(fullfile(video_root, video_name, '*.jpg'));
raw_anno = load(fullfile(anno_root, [video_name, '.txt']));
anno = cell(length(frames), max(raw_anno(:, 2))+1);
for i = 1: size(raw_anno, 1)
    frame_index = raw_anno(i, 1);
    target_id = raw_anno(i, 2);
    box_left = raw_anno(i, 3);
    box_top = raw_anno(i, 4);
    box_width = raw_anno(i, 5);
    box_height = raw_anno(i, 6);
%     score = raw_anno(i, 7);
%     class = raw_anno(i, 8);
%     truncation = raw_anno(i, 9);
%     occlusion = raw_anno(i, 10);
    data = [box_left, box_top, box_width, box_height];
    anno{frame_index, target_id+1} = data;
end