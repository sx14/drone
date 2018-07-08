if ~exist(root,'dir')
    error('Error installing the package, try updating the value of root in the file "root.m"')
end

% Install own lib
addpath(root);
addpath(genpath(fullfile(root,'src')));
addpath(genpath(fullfile(root,'SLIC_mex')));
addpath(fullfile(root, 'PSPNet', 'evaluation'));
addpath(fullfile(root, 'PSPNet'));
% addpath(genpath(fullfile(root,'flownet2-master')));
addpath(fullfile(root, 'flownet2-master'));