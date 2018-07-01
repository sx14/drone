function motion_map = extract_moving_region(scene_map, flow, background_labels)
    background_map = false(size(scene_map));
    for i = 1:length(background_labels)
        background_map = background_map | (scene_map == background_labels(i));
    end
    flow_power_map = sqrt(flow(:,:,1) .^ 2 + flow(:,:,2) .^2);
%     temp = mod(flow_power_map * 128,256);
%     figure,imshow(uint8(temp));
    camera_flow_power = mean(flow_power_map(background_map));
    motion_map = flow_power_map - camera_flow_power;
    motion_map(motion_map < 0) = 0;
    threshold = mean(motion_map(motion_map > 0));
%     threshold = (threshold + max(max(motion_map))) / 2;
    motion_map(motion_map < threshold) = 0;
    filter_size = 4;
    filter = ones(filter_size,filter_size);
    motion_map = imfilter(motion_map,filter,'replicate');
    motion_map(motion_map > 0) = 1;
    motion_map(background_map) = 0;
%     figure,imshow(motion_map);