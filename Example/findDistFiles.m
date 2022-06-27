% Developed by: Jason Kim, Zachary Schmidt
% Summer 2022, University of Alberta

% Searches through a folder for all Excel files with grade distributions.
% Returns the semester names and path to each Excel file.

% Parameters:
%   folderName (char array): name of the folder that contains grade dist.
%   Excel files
%
% Returns:
%   distFiles (struct): fields are semester names and the value in each
%   field is a cell array of the paths to all the grade dist. Excel files
%   taken in that semester
function distFiles = findDistFiles(folderName)

% findfiles returns all Excel files in the folderName folder
allExcel = findfiles('*.xlsx', folderName);

distFiles = struct;

for i = 1:size(allExcel, 1)
    backSlash = strfind(allExcel{i}, '\');

    % folder format is specific. Semester name will be between 3rd last and
    % 2nd last backslashes
    semesterNameStart = backSlash(end - 2) + 1;
    semesterNameEnd = backSlash(end - 1) - 1;
    semesterName = allExcel{i}(semesterNameStart:semesterNameEnd);

    if ~(strcmp(semesterName(1), 'F') || strcmp(semesterName(1), 'W') || strcmp(semesterName(1), 'S'))
        % Folder name doesn't start with F or W or S (season of semester)
        error(['Invalid first char in folder name, should be F or W or S: ', allExcel{i}])
    end
    % append the file path to distFiles under the field semesterName 
    if ~isfield(distFiles, semesterName)
        distFiles.(semesterName) = {};
    end
    distFiles.(semesterName){end + 1} = allExcel{i};
end
