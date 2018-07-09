% calculate and save forward optical flow for each frame
function cal_flow_fn(video_path, output_path, direction)
if ~exist(output_path, 'dir')
    mkdir(output_path);
end
flownet_root_path = flownet_root();
img_suffix = 'jpg';
if exist(video_path,'dir')
    imgs = dir(fullfile(video_path, ['*.',img_suffix]));
else
    error('cal_flow_fn : video not found.')
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


list_file_path = fullfile(flownet_root_path, 'list.txt');
if exist(list_file_path, 'file')
    delete(list_file_path);
end
img_list_file = fopen(list_file_path,'w');
% the optical flow of the last frame is zero.
for i = start_one:step:last_one
    flo_path = fullfile(output_path,[num2str(i,'%07d'),'.flo']);
    if ~exist(flo_path,'file')
        if i ~= last_one
            I1_path = fullfile(video_path,[num2str(i,'%07d'),'.',img_suffix]);
            I2_path = fullfile(video_path,[num2str(i+step,'%07d'),'.',img_suffix]);
            if i ~= last_one-1
                fprintf(img_list_file, [I1_path ' ' I2_path ' ' flo_path '\n']);
            else
                fprintf(img_list_file, [I1_path ' ' I2_path ' ' flo_path]);
            end
        else
            I1 = imread(fullfile(video_path,[num2str(i,'%07d'),'.',img_suffix]));
            flow = zeros(size(I1,1),size(I1,2),2);
            writeFlowFile(flow,flo_path);
        end
    end
end
fclose(img_list_file);
model_path = fullfile(flownet_root_path, 'models', 'FlowNet2', 'FlowNet2_weights.caffemodel.h5');
deploy_prototxt_path = fullfile(flownet_root_path, 'models', 'FlowNet2', 'FlowNet2_deploy.prototxt.template');
PYTHONPATH = fullfile(flownet_root_path, 'python');
python_script_path = fullfile(flownet_root_path, 'scripts', 'run-flownet-many.py');
run_script_path = fullfile(flownet_root_path, 'scripts', 'run.sh');
cal_flow_cmd = ['sh ' run_script_path ' ' PYTHONPATH ' ' python_script_path ' ' model_path ' ' deploy_prototxt_path ' ' list_file_path];
system(cal_flow_cmd);
disp(['cal_',direction,'_flow finished.']);