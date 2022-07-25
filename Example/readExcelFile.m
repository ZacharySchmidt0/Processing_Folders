% Developed by: Jason Kim, Zachary Schmidt
% Summer 2022, University of Alberta

% Entry point to read one grade distribution Excel file
% Saves classData as a .mat file in the current directory

disp("Finding files...")

% saves filepaths organized by semester (all F2021 together)
distFiles = findDistFiles('Distribution Files');

configData = readConfig('configuration_file');
classData = struct;

% fieldNames are all semesters
fieldNames = fieldnames(distFiles);

errorCell = cell(1, 3);
errorCell{1, 1} = 'Type of Entry';
errorCell{1, 2} = 'Excel Entry';
errorCell{1, 3} = 'File Path';

for i = 1:numel(fieldNames)
    for j = 1:size(distFiles.(fieldNames{i}), 2)
        if ~isfield(classData, fieldNames{i})
            classData.(fieldNames{i}) = [];
        end
        [newClass, errorCell] = readGradeDist(distFiles.(fieldNames{i}){j}, configData, errorCell);
        % store classData structs in the same semester under the same field
        classData.(fieldNames{i}) = [classData.(fieldNames{i}) newClass];
        disp(classData)
    end
end

save("classData.mat", "classData")

writecell(errorCell, 'ConfigErrors.xlsx', 'WriteMode', 'replacefile')