function motion_map = extract_moving_region_v2(scene_map, flow, strong_background_labels, weak_background_labels)
    strong_background_map = false(size(scene_map));
    for i = 1:length(strong_background_labels)
        strong_background_map = strong_background_map | (scene_map == strong_background_labels(i));
    end
    weak_background_map = false(size(scene_map));
    for i = 1:length(weak_background_labels)
        weak_background_map = weak_background_map | (scene_map == weak_background_labels(i));
    end
    flow_x = flow(:,:,1);
    weak_background_x_mean = mean(flow_x(weak_background_map));
    flow_y = flow(:,:,2);
    weak_background_y_mean = mean(flow_y(weak_background_map));
    motion_x = (flow_x - weak_background_x_mean);
    motion_y = (flow_y - weak_background_y_mean);
    motion_map = sqrt(motion_x .^2 + motion_y .^ 2);
    threshold = (min(motion_map(motion_map > 0)) + max(max(motion_map))) / 2;
    motion_map(motion_map < threshold) = 0;
    motion_map(strong_background_map) = 0;