clear;clc;
img_path = '/media/sunx/Data/drone_dataset/stanford dataset/images';
label_path = '/media/sunx/Data/drone_dataset/stanford dataset/labels';
svm_path = '/home/sunx/workspace/matlab-workspace/drone/background/svm';
[hog_data, labels] = generate_train_data(img_path, label_path);
region_classes = stanford_labels();
for d = region_classes.indexes
%     if exist(fullfile(svm_path,[num2str(d),'.mat']), 'file')
%         svmStruct = load(fullfile(svm_path,[num2str(d),'.mat']));
%         svmStruct = svmStruct.svmStruct;
%     else
        [positives,~,~] = find(labels == d);
        [negatives,~,~] = find(labels ~= d);
        curr_labels = labels;
        curr_labels(negatives) = 0;
        curr_labels(positives) = 1;
        interval = max(floor(length(negatives) / length(positives))*2,1);
        selected_negatives = negatives(1:interval:end);
        training_data = hog_data([positives;selected_negatives],:);
        training_labels = curr_labels([positives;selected_negatives],:);
        
        [train, test] = crossvalind('holdOut',training_labels);    
        cp = classperf(training_labels);    
        svmStruct = fitcsvm(training_data(train,:),training_labels(train));    
%         save(fullfile(svm_path,[num2str(d),'.mat']),'svmStruct');
        [classes,score] = predict(svmStruct,training_data(test,:));
        classperf(cp,classes,test);    
        fprintf('%d : %d\n',d, cp.CorrectRate);
%     end
end