function distFiles = findDistFiles()

allExcel = findfiles('*.xlsx');

distFiles = struct;

for i = 1:size(allExcel, 1)
    backSlash = strfind(allExcel{i}, '\');
    folderNameStart = backSlash(end - 3) + 1;
    folderNameEnd = backSlash(end - 2) - 1;
    folderName = allExcel{i}(folderNameStart:folderNameEnd);

    semesterNameStart = backSlash(end - 2) + 1;
    semesterNameEnd = backSlash(end - 1) - 1;
    semesterName = allExcel{i}(semesterNameStart:semesterNameEnd);

    if strcmp(folderName, 'Distribution Files')
        switch semesterName(1)
            case 'F'
                semester = 'Fall';
            case 'W'
                semester = 'Winter';
            case 'S'
                semester = 'Summer';
            otherwise
                error('Invalid first char in folder name, should be F or W or S: ' + allExcel{i})
        end
        if ~isfield(distFiles, semesterName)
            distFiles.(semesterName) = {};
        end
        distFiles.(semesterName){end + 1} = allExcel{i};
    end
end

