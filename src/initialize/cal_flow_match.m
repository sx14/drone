% calculate and save forward optical flow for each frame
function flow_set = cal_flow_match(video_package_path, output_path, video_dir, direction)
flow_path = fullfile(output_path, 'flow');
if ~exists(flow_path, 'dir')
    mkdir(flow_path);
end
img_suffix = 'jpg';
video_path = fullfile(video_package_path,video_dir);
if exist(video_path,'dir')
    imgs = dir(fullfile(video_path, ['*.',img_suffix]));
else
    error('cal_flow_match : video not found.')
end
if strcmp(direction,'forward')
    start_one = 1;
    last_one = length(imgs);
    step = 1;
elseif strcmp(direction,'backward')
    start_one = length(imgs);
    last_one = 1;
    step = -1;
else
    error('param : direction is "forward" or "backward".');
end
video_flow_path = fullfile(flow_path,video_dir);
if ~exist(video_flow_path,'dir')
    mkdir(flow_path, video_dir);
end
flow_set = cell(length(imgs),1);
% the optical flow of the last frame is zero.
for i = start_one:step:last_one
    flo_path = fullfile(video_flow_path,[num2str(i,'%07d'),'.flo']);
    if ~exist(flo_path,'file')
        if i ~= last_one
            I1_path = fullfile(video_package_path,video_dir,[num2str(i,'%07d'),'.',img_suffix]);
            I2_path = fullfile(video_package_path,video_dir,[num2str(i+step,'%07d'),'.',img_suffix]);
            cmd = ['./deepflow/deepmatching-static ',I1_path,' ',I2_path,' -nt 4 | ./deepflow/deepflow2-static ',I1_path,' ',I2_path,' ',flo_path,' -match -sintel'];
            system(cmd);
        else
            I1 = imread(fullfile(video_path,['0000000','.',img_suffix]));
            flow = zeros(size(I1,1),size(I1,2),2);
            writeFlowFile(flow,flo_path);
        end
    end
    flow = readFlowFile(flo_path);
    flow_set{i} = flow;
end
disp(['cal_',direction,'_flow finished.']);

