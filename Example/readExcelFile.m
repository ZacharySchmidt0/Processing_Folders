% Developed by: Jason Kim, Zachary Schmidt
% Last Revised: June 24, 2022

% Entry point to read one grade distribution Excel file
% Saves classData as a .mat file in the current directory

disp("Finding files...")
distFiles = findDistFiles();
configData = readConfig('configuration_file');
classData = struct;

fieldNames = fieldnames(distFiles);

for i = 1:numel(fieldNames)
    for j = 1:size(distFiles.(fieldNames{i}), 2)
        if ~isfield(classData, fieldNames{i})
            classData.(fieldNames{i}) = [];
        end
        classData.(fieldNames{i}) = [classData.(fieldNames{i}) readGradeDist(distFiles.(fieldNames{i}){j}, configData)];
        disp(classData)
    end
end

save("classData.mat", "classData")