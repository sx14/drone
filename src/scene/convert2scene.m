function scene_map = convert2scene(pspnet_map)
scene_labels = sceneLabelMap();
scene_map = zeros(size(pspnet_map));
for i = 1:size(pspnet_map,1)
    for j = 1:size(pspnet_map,2)
        scene_map(i,j) = scene_labels(pspnet_map(i,j));
    end
end