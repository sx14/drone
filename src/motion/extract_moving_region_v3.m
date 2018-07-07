function motion_map = extract_moving_region_v3(scene_map, flow, strong_background_labels, weak_background_labels)
    strong_background_map = false(size(scene_map));
    [h,w,~] = size(flow);
    for i = 1:length(strong_background_labels)
        strong_background_map = strong_background_map | (scene_map == strong_background_labels(i));
    end
    weak_background_map = false(size(scene_map));
    for i = 1:length(weak_background_labels)
        weak_background_map = weak_background_map | (scene_map == weak_background_labels(i));
    end
    flow_x = flow(:,:,1);
    flow_y = flow(:,:,2);
    part_height = 10;
    motion_map = zeros(h,w);
    for x = 1:10:h
        part_top = x;
        part_bottom = min(x+part_height-1, h);
        part_weak_background = weak_background_map(part_top:part_bottom,:);
        part_flow_x = flow_x(part_top:part_bottom,:);
        part_flow_y = flow_y(part_top:part_bottom,:);
        part_weak_bg_x_mean = mean(part_flow_x(part_weak_background));
        part_weak_bg_y_mean = mean(part_flow_y(part_weak_background));
        part_flow_x = part_flow_x - part_weak_bg_x_mean;
        part_flow_y = part_flow_y - part_weak_bg_y_mean;
        part_motion_map = sqrt(part_flow_x .^ 2 + part_flow_y .^ 2);
        threshold = median(part_motion_map(part_motion_map > 0));
        part_motion_map(part_motion_map < threshold) = 0;
        motion_map(part_top:part_bottom,:) = part_motion_map;
    end
    filter_size = 4;
    filter = ones(filter_size,filter_size);
    motion_map = imfilter(motion_map,filter,'replicate');
    motion_map(motion_map > 0) = 1;
    motion_map(strong_background_map) = 0;