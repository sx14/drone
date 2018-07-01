% calculate and save hierarchical segmentation of each frame
function hier_set = cal_hier(output_path,video_dir,flow_set,resized_imgs)
video_hier_path = fullfile(output_path,video_dir);
if ~exist(video_hier_path,'dir')
    mkdir(output_path, video_dir);
end
hier_set = cell(length(resized_imgs),1);
for i = 0:(length(resized_imgs) - 1)
    num=num2str(i,'%06d');
    hier_name = [num,'.mat'];
    hier_path = fullfile(video_hier_path,hier_name);
    if ~exist(hier_path,'file')
        I = resized_imgs{i+1};
        curr_flow = flow_set{i+1};
        [hier, ~] = get_hier(I, curr_flow);       
        save(hier_path, 'hier');
        hier_set{i+1,1} = hier;
    else
        heir_file = load(hier_path);
        hier_set{i+1} = heir_file.hier;
    end
end
disp('cal_hier finished.');
