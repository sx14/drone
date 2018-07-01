function output(path, file_name, content, type)
if strcmp(type,'img')
    imwrite(content, fullfile(path,file_name));
elseif strcmp(type, 'txt')
    fp=fopen(fullfile(path,file_name),'w');
    for i = 1:size(content,1)
        fprintf(fp,'%s\n',content(i,:));
    end
    fclose(fp);
end
