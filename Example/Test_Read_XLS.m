% test_Read_xls

close all
clear
%fs = matlab.io.datastore.FileSet("airlinesmall_subset.xlsx");
%ssds = spreadsheetDatastore("airlinesmall_subset.xlsx")
%ssds = spreadsheetDatastore("MecE260_UNDERGRAD Grade Dist Form.xlsx")
%sheetnames(ssds,1)
filename = "MecE260_UNDERGRAD Grade Dist Form.xlsx";
T = readcell(filename,'Sheet','SECOND YEAR');
T(cellfun(@(x) isa(x,'missing'), T)) = {''};

classData = struct;

for row = 3:4
    valueFlag = 0;
    for col = 1:size(T, 2)
        if (~strcmp(T{row, col}, ''))
            if valueFlag == 0
                field = T{row, col};
                field = strrep(field, ' ', '_');
                field = strrep(field, ':', '');
                valueFlag = 1;
            elseif valueFlag == 1
                classData.(field) = T{row, col};
                valueFlag = 0;
            end     
        end
    end
end

structTemplate = struct('GPA', '', 'NumberOfStudents', '', ...
    'GradePointxNumber', '', 'PercentOfStudents', '', 'SuggestedPercent', '');

for row = 8:19
    letterGrade = T{row, 3};
    letterGrade = strrep(letterGrade, '+', '_plus');
    letterGrade = strrep(letterGrade, '–', 'minus');
    classData.(letterGrade) = structTemplate;
    classData.(letterGrade).GPA = T{row, 4};
    classData.(letterGrade).NumberOfStudents = T{row, 5};
    classData.(letterGrade).GradePointxNumber = T{row, 7};
    classData.(letterGrade).PercentOfStudents = T{row, 9};
    classData.(letterGrade).SuggestedPercent = T{row, 12};
end
        

classData.Totals = struct;
classData.Totals.NumberOfStudents = T{20, 5};
classData.Totals.GradePointxNumber = T{20, 7};
classData.Totals.PercentOfStudents = T{20, 9};
classData.Totals.SuggestedPercent = T{20, 12};

classData.classGPA = T{22, 15};
classData.medianGrade = T{27, 15};
