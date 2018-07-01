% calculate and save forward optical flow for each frame
function flow_set = cal_flow(video_dir, flow_path, resized_imgs, direction)
if strcmp(direction,'forward')
    start_one = 1;
    last_one = length(resized_imgs);
    step = 1;
elseif strcmp(direction,'backward')
    start_one = length(resized_imgs);
    last_one = 1;
    step = -1;
else
    error('param : direction is "forward" or "backward".');
end
video_flow_path = fullfile(flow_path,video_dir);
if ~exist(video_flow_path,'dir')
    mkdir(flow_path, video_dir);
end
flow_set = cell(length(resized_imgs),1);
% the optical flow of the last frame is zero.
for i = start_one:step:last_one
    num=num2str(i-1,'%06d');
    flow_name = [num,'.mat'];
    flow_path = fullfile(video_flow_path, flow_name);
    if ~exist(flow_path,'file')
        I1 = resized_imgs{i};
        if i ~= last_one
            I2 = resized_imgs{i+step};
            flow = deepflow2(single(I1), single(I2));
        else
            flow = zeros(size(I1,1),size(I1,2),2);
        end
        flow_set{i} = flow;
        save(flow_path, 'flow');
    else
        flow_file = load(flow_path);
        flow_set{i} = flow_file.flow;
    end
end
disp(['cal_',direction,'_flow finished.']);

