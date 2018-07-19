function scene_main(data_root, output_root)
if ~exist(output_root, 'dir')
    mkdir(output_root);
end
step = 100;
cmd1 = ['cd ', fullfile(root, 'scene_classification')];
cmd2 = ['sh ',fullfile(root, 'scene_classification', 'test.sh'),' ', data_root, ' ', output_root, ' ', num2str(step)];
cmd = [cmd1, ' ; ', cmd2];
system(cmd);

