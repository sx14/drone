clear;clc;close all;
anno_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/annotations';
video_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/sequences';
flow_root = '/home/sunx/output/drone/flow';
temp_output_root = '/home/sunx/output/drone/temp';
video_name = 'uav0000076_00720_v';
iou_threshold = 0.5;
anno = read_anno_test(anno_root, video_root, video_name);
predict = zeros(size(anno, 1), size(anno, 2));
object_appearance_flags = zeros(size(anno, 2), 1);
for f = 1:size(anno, 1)
    flow = readFlowFile(fullfile(flow_root, video_name, [num2str(f, '%07d'), '.flo']));
    [h,w,~] = size(flow);
    for o = 1:size(anno, 2)
        if o == 33
            a = 1;
        end 
        object_box = anno{f, o};
        if isempty(object_box)
            continue;
        end
        if object_appearance_flags(o) == 0
            predict(f,o) = 1;
            object_appearance_flags(o) = 1;
        end
        x_min = max(object_box(1), 1);
        x_max = min(x_min + object_box(3), w);
        y_min = max(object_box(2), 1);
        y_max = min(y_min + object_box(4), h);
        box_flow_x = flow(y_min:y_max, x_min:x_max, 1);
        box_flow_y = flow(y_min:y_max, x_min:x_max, 2);
        delta_x_mean = mean(box_flow_x(:));
        delta_y_mean = mean(box_flow_y(:));
        predict_box = [floor(x_min+delta_x_mean), floor(y_min+delta_y_mean), object_box(3), object_box(4)];
        if (f+1 <= size(anno, 1)) && (~isempty(anno{f+1, o}))
            iou = cal_IoU(predict_box, anno{f+1, o});
            if iou > iou_threshold
                predict(f+1, o) = 1;
            end
        else
            object_appearance_flags(o) = 0;
        end
    end
end
frame_hit_object_sum = zeros(size(anno, 1), 1);
object_hit_frame_sum = zeros(size(anno, 2), 1);
frame_object_sum = zeros(size(anno, 1), 1);
object_frame_sum = zeros(size(anno, 2), 1);
for f = 1:size(anno, 1)
    for o = 1:size(anno, 2)
        if ~isempty(anno{f,o})
            frame_object_sum(f) = frame_object_sum(f) + 1;
            object_frame_sum(o) = object_frame_sum(o) + 1;
            if predict(f,o) == 1
                frame_hit_object_sum(f) = frame_hit_object_sum(f) + 1;
                object_hit_frame_sum(o) = object_hit_frame_sum(o) + 1;
            end
        end
    end
end

frame_object_precision = frame_hit_object_sum ./ frame_object_sum;
object_frame_precision = object_hit_frame_sum ./ object_frame_sum;

good_trajectory_ratio = sum(object_frame_precision(object_frame_precision > 0.9)) / size(anno, 2);

% show_trajectory(fullfile(video_root, video_name), fullfile(temp_output_root, video_name), anno, 49);