% Developed by: Jason Kim, Zachary Schmidt
% Summer 2022, University of Alberta

% Entry point to read one grade distribution Excel file
% Saves classData as a .mat file in the current directory
% Writes an output Excel file called ConfigErrors.xlsx listing entries in
% grade dists not matching config file

disp("Finding files...")

% saves filepaths organized by semester
distFiles = findDistFiles('Distribution Files');

configData = readConfig('configuration_file');
classData = struct;

% fieldNames are all semesters
fieldNames = fieldnames(distFiles);

% cell array that is written out to ConfigErrors.xlsx
errorCell = cell(1, 3);
errorCell{1, 1} = 'Type of Entry';
errorCell{1, 2} = 'Excel Entry';
errorCell{1, 3} = 'File Path';

for i = 1:numel(fieldNames)  % for each semester
    for j = 1:size(distFiles.(fieldNames{i}), 2)  % for each course
        if ~isfield(classData, fieldNames{i})
            % if semester not seen yet, initialize array
            classData.(fieldNames{i}) = [];
        end
        % semester has been seen previously, read in data and append
        [newClass, errorCell] = readGradeDist(distFiles.(fieldNames{i}){j}, configData, errorCell);
        classData.(fieldNames{i}) = [classData.(fieldNames{i}) newClass];
        disp(classData)
    end
end

save("classData.mat", "classData")

writecell(errorCell, 'ConfigErrors.xlsx', 'WriteMode', 'replacefile')  % overwite the file if it exists