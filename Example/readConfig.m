% Developed by: Jason Kim, Zachary Schmidt
% Summer 2022, University of Alberta

% Parses a configuration file with all potential names of departments,
% instructors, and course numbers along with alternative names. Saves this
% data in a struct.
%
% Parameters:
%   filename (char array): name of the configuration file (must be in
%   current directory)
%
% Returns:
%   configData (struct): struct with fields 'Departments', 'Instructors',
%   and 'CourseNums'. Each of these is a nested cell array with each
%   individual cell containing a cell array with the preferred name
%   as the first entry and the alterative names as proceeding entries.
function configData = readConfig(filename)

close all

Config = readcell(filename);

Config(cellfun(@(x) isa(x,'missing'), Config)) = {''};  % replace missing cells with empty string

configData = struct;

configData.Departments = {};
configData.Instructors = {};
configData.CourseNums = {};

for row = 1:size(Config, 1)
    switch Config{row, 1}
        % only 3 options in configuration file
        case 'Department'
            field = 'Departments';
        case 'Instructor'
            field = 'Instructors';
        case 'Course Number'
            field = 'CourseNums';
    end
    interCell = {};  % used to store pref & alt names, appended to configData at end
    for col = 2:size(Config, 2)
        if ~strcmp(Config{row, col}, '')
            interCell{end + 1} = Config{row, col};
        end
    end
    configData.(field){end + 1} = interCell;  % append to cell array
end
