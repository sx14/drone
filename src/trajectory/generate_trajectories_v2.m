function [trajectories, t_f_mat] = generate_trajectories_v2(detections, flow_root)
trajectory_max = 1000;
[frame_sum, detection_max] = size(detections);
% t_f_mat: 3rd dimension(1-detection_id_on_trajectory, 2-link_to_next_detection_id, 3-matching_score)
% t_f_mat: 1st dimension(trajectory_id)
% t_f_mat: 2nd dimension(frame_id)
t_f_mat = zeros(trajectory_max, size(detections, 1), 3);
next_trajectory = 1;
% init t_f_mat
% all the boxes on the first frame initiate a trajectory
first_frame_detecions = detections(1,:);
for d = 1:length(first_frame_detecions)
    detection = first_frame_detecions{d};
    if ~isempty(detection)
        t_f_mat(d,1) = d;
        next_trajectory = next_trajectory + 1;
    else
        break;
    end
end

% try to match the box on next frame
for f = 1:frame_sum-1
    fprintf('processing : %d frame\n', f+1);
    % search matching box backward
    curr_flow_path = fullfile(flow_root, [num2str(f, '%07d'), '.flo']);
    curr_flow = readFlowFile(curr_flow_path);
    next_frame_detections = detections(f+1,:);
    curr_frame_detections = detections(f,:);
    for t = 1:trajectory_max
        if t == 0
            continue;
        end
        curr_frame_detection = curr_frame_detections{t_f_mat(t,f,1)};
        curr_frame_detection = predict_box_with_flow(curr_frame_detection, curr_flow);
        for n_d = 1:detection_max
            if n_d == 0
                continue;
            end
            next_frame_detection = next_frame_detections{n_d};
            matching_score = match(curr_frame_detection, next_frame_detection);
            if matching_score > 0
                % allow matching
                exist_matching_score = t_f_mat(t,f,3);
                if matching_score > exist_matching_score
                    if exist_matching_score > 0
                        % exist_matching_detection is redundant
                        discard_detection = curr_frame_detections{t_f_mat(t,f,2)};
                        discard_detection.discard = 1;
                        curr_frame_detections{t_f_mat(t,f,2)} = discard_detection;
                    end
                    % match successfully, update trajectory
                    t_f_mat(t,f,2) = n_d;
                    t_f_mat(t,f,3) = matching_score;
                    t_f_mat(t,f+1,1) = n_d;
                end
            end
        end
    end
end

trajectories = fill_trajectory_id(t_f_mat, detections);



function detections = fill_trajectory_id(t_f_mat, detections)
for t = 1:size(t_f_mat,1)
    for f = 1:size(t_f_mat,2)
        detection_id = t_f_mat(t,f,1);
        if detection_id > 0
            detection = detections{f,detection_id};
            detection.id = t;
            detections{f,detection_id} = detection;
        end
    end
end

% add 'predict_box' field to detection
function detection = predict_box_with_flow(detection, flow)
box = detection.box;
box_right = box(1) + box(3) - 1;
box_bottom = box(2) + box(4) - 1;
flow_x = flow(box(2):box_bottom, box(1):box_right,1);
flow_y = flow(box(2):box_bottom, box(1):box_right,2);
delta_x = floor(mean(flow_x(:)));
delta_y = floor(mean(flow_y(:)));
predict_box = [box(1)+delta_x, box(2)+delta_y, box(3), box(4)];
detection.predict_box = predict_box;

function matching_score = match(curr_detection, next_detection)
iou_threshold = 0.5;
box1 = curr_detection.predict_box;
box2 = next_detection.box;
iou = cal_IoU(box1, box2);
if iou > iou_threshold
    matching_score = iou;
else
    matching_score = 0;
end