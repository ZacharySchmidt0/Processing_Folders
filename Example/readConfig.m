% Developed by: Jason Kim, Zachary Schmidt
% Last Revised: June 27, 2022

% P
function configData = readConfig(filename)

close all

Config = readcell(filename);

Config(cellfun(@(x) isa(x,'missing'), Config)) = {''};  % replace missing cells with empty string

configData = struct;

configData.Departments = struct;
configData.Instructors = struct;
configData.CourseNums = struct;
for col = 1:size(Config, 2)
    switch Config{1, col}
        case 'Department'
            field = 'Departments';
        case 'Instructor'
            field = 'Instructors';
        case 'Course Number'
            field = 'CourseNums';
    end
    for row = 2:size(Config, 1)
        if ~strcmp(Config{row, col}, '')
            innerField = strrep(Config{row, col}, ' ', '_');  % field names can't contain whitespace
            innerField = strrep(innerField, '.', '__1');  % field names can't contain . so replace with flag
            innerField = lower(innerField);
            configData.(field).(innerField) = {};
            configData.(field).(innerField){end + 1} = Config{row, col};  % append to cell array
        end
    end
end

