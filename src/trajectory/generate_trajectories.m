function trajectories = generate_trajectories(detections, flow_root)
trajectory_max = 1000;
[frame_sum, detection_max] = size(detections);
% t_f_mat: 3rd dimension(1-detection_id_in_trajectory, 2-matching_detection_id_on_next_frame, 3-matching_score)
t_f_mat = zeros(trajectory_max, size(detections, 1), 3);
next_trajectory = 1;
% init t_f_mat
first_frame_detecions = detections(1,:);
for d = 1:length(first_frame_detecions)
    detection = first_frame_detecions{d};
    if ~isempty(detection)
        t_f_mat(d, 1) = d;
        next_trajectory = next_trajectory + 1;
    else
        break;
    end
end

for f = 2:frame_sum
    fprintf('processing : %d frame\n', f);
    % search matching box backward
    last_flow_path = fullfile(flow_root, [num2str(f-1, '%07d'), '.flo']);
    last_flow = readFlowFile(last_flow_path);
    curr_frame_detections = detections(f,:);
    last_frame_detections = detections(f-1,:);
    for d = 1:length(last_frame_detections)
        last_frame_detection = last_frame_detections{d};
        if ~isempty(last_frame_detection)
            temp_detection = predict_box_with_flow(last_frame_detection, last_flow);
            last_frame_detections{d} = temp_detection;
        end
    end
    for c_d = 1:detection_max
        curr_detection = curr_frame_detections{c_d};
        if ~isempty(curr_detection)
            matched = 0;
            for t = 1:trajectory_max
                if t_f_mat(t,f-1,1) == 0
                    continue;
                end
                last_detection = last_frame_detections{t_f_mat(t,f-1,1)};
                if ~isempty(last_detection)
                    matching_score = match(last_detection, curr_detection);
                    if matching_score > 0
                        % allow matching
                        matched = 1;
                        exist_matching_score = t_f_mat(t,f-1,3);
                        if matching_score > exist_matching_score
                            % match successfully, update trajectory
                            t_f_mat(t,f-1,2) = c_d;
                            t_f_mat(t,f-1,3) = matching_score;
                            t_f_mat(t,f,1) = c_d;
                        end
                    end
                else
                    continue;
                end
            end
            if matched == 0
                % create new trajectory
                t_f_mat(next_trajectory,f,1) = c_d;
                next_trajectory = next_trajectory + 1;
            end
        else
            continue;
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

function matching_score = match(last_detection, curr_detection)
iou_threshold = 0.5;
box1 = last_detection.predict_box;
box2 = curr_detection.box;
iou = cal_IoU(box1, box2);
if iou > iou_threshold
    matching_score = iou;
else
    matching_score = 0;
end