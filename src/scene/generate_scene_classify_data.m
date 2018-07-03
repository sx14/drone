clear;clc;
org_data_root = '/home/sunx/dataset/temp';
dest_data_root = '/home/sunx/dataset/scene';
package = 'test';
interval = 50;
if ~exist(fullfile(dest_data_root, package), 'dir')
    mkdir(dest_data_root, package);
end

classes = dir(fullfile(org_data_root, package, '*'));
for i = 3:length(classes)
    class = classes(i);
    videos = dir(fullfile(org_data_root, package, class.name, '*'));
    img_index = 1;
    if ~exist(fullfile(dest_data_root, package, class.name), 'dir');
        mkdir(fullfile(dest_data_root, package), class.name)
    end
    for v = 3:length(videos)
        video = videos(v);
        frames = dir(fullfile(org_data_root, package, class.name, video.name, '*.jpg'));
        for f = 1:(length(frames) / interval)
            frame_index = num2str(f*interval, '%07d');
            img = imread(fullfile(org_data_root, package, class.name, video.name, [frame_index, '.jpg']));
            imwrite(img, fullfile(dest_data_root, package, class.name, [num2str(img_index, '%07d'), '.jpg']));
            img_index = img_index + 1;
        end
    end
end