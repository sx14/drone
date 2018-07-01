function video_scene_seg(video_path,model_weights,model_deploy,fea_cha,base_size,crop_size,data_class,data_colormap, ...
    save_gray_folder,save_color_folder,gpu_id,scale_array,mean_r,mean_g,mean_b,interval)
load(data_class);
load(data_colormap);
load('objectName150.mat');
if(~isdir(save_gray_folder))
    mkdir(save_gray_folder);
end
if(~isdir(save_color_folder))
    mkdir(save_color_folder);
end

phase = 'test'; %run with phase test (so that dropout isn't applied)
if ~exist(model_weights, 'file')
    error('Model missing!');
end
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(model_deploy, model_weights, phase);

frames = dir(fullfile(video_path, '*.jpg'));
for i = 1:interval:length(frames)
    frame_index = num2str(i,'%07d');
    if exist(fullfile(save_color_folder, [frame_index, '.png']), 'file')
        continue;
    end
    t1 = clock;
    img = imread(fullfile(video_path, [frame_index, '.jpg']));
    if(size(img,3) < 3) %for gray image
        im_r = img;
        im_g = img;
        im_b = img;
        img = cat(3,im_r,im_g,im_b);
    end
    ori_rows = size(img,1);
    ori_cols = size(img,2);
    data_all = zeros(ori_rows,ori_cols,fea_cha,'single');
    for j = 1:size(scale_array,2)
        long_size = base_size*scale_array(j) + 1;
        new_rows = long_size;
        new_cols = long_size;
        if ori_rows > ori_cols
            new_cols = round(long_size/single(ori_rows)*ori_cols);
        else
            new_rows = round(long_size/single(ori_cols)*ori_rows);
        end
        img_scale = imresize(img,[new_rows new_cols],'bilinear');
        data_all = data_all + scale_process(net,img_scale,fea_cha,crop_size,ori_rows,ori_cols,mean_r,mean_g,mean_b);
    end

    data_all = data_all/size(scale_array,2);
    data = data_all; %already exp process
    [~,imPred] = max(data,[],3);
    imPred = uint8(imPred);
    t2 = clock;
    t = etime(t2,t1);
    fprintf('time consuming: %d\n', t);
    rgbPred = colorEncode(imPred, colors);
    imwrite(imPred,fullfile(save_gray_folder, [frame_index '.png']));
    imwrite(rgbPred,fullfile(save_color_folder, [frame_index '.png']));
end
caffe.reset_all();
end
