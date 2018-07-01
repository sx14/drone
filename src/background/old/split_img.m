org_img_path = '/home/sunx/dataset/drone/samples_org';
output_path = '/home/sunx/dataset/drone/patch/train';
patch_size = 50;

org_imgs = dir(fullfile(org_img_path,'*.jpg'));
for i = 1:length(org_imgs)
    img_file_name = org_imgs(i).name;
    img = imread(fullfile(org_img_path,img_file_name));
    [h,w,~] = size(img);
    mkdir(output_path,num2str(i));
    patch_index = 1;
    for y = 1:floor(h/patch_size)
        for x = 1:floor(w/patch_size)
            patch = img((y-1)*patch_size+1:y*patch_size,(x-1)*patch_size+1:x*patch_size,:);
            imwrite(patch,fullfile(output_path,num2str(i),[num2str(patch_index),'.jpg']));
            patch_index = patch_index + 1;
        end
    end
end
    
