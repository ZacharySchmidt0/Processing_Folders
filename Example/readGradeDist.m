function classData = readGradeDist(filename)

close all

% finding the only non-empty sheet
% read first year sheet, if instructor is blank, go to next, and so on
T = readcell(filename,'Sheet','FIRST YEAR');
T(cellfun(@(x) isa(x,'missing'), T)) = {''};
if strcmp(T{3, 12}, '')  % row 3, col 12 is instructor location
    T = readcell(filename,'Sheet','SECOND YEAR');
    T(cellfun(@(x) isa(x,'missing'), T)) = {''};
end
if strcmp(T{3, 12}, '')
    T = readcell(filename,'Sheet','THIRD YEAR');
    T(cellfun(@(x) isa(x,'missing'), T)) = {''};
end
if strcmp(T{3, 12}, '')
    T = readcell(filename,'Sheet','FOURTH YEAR');
    T(cellfun(@(x) isa(x,'missing'), T)) = {''};
end

% replace all 'missing' cells with empty string
T(cellfun(@(x) isa(x,'missing'), T)) = {''};

classData = struct;

for row = 3:4  % rows 3 and 4 contain info about class (instructor, dept)
    valueFlag = 0;
    for col = 1:size(T, 2)
        if (~strcmp(T{row, col}, ''))
            if valueFlag == 0
                % cell value is a field (not a value)
                field = T{row, col};  % store the field for until we get the value
                field = strrep(field, ' ', '_');  % field names can't contain _
                field = strrep(field, ':', '');  % field names can't contain :
                valueFlag = 1;
            elseif valueFlag == 1
                % cell is a value
                classData.(field) = T{row, col};
                valueFlag = 0;
            end     
        end
    end
end

for row = 8:19
    % the main class data in rows 8-19
    letterGrade = T{row, 3};
    letterGrade = strrep(letterGrade, '+', '_plus');  % field names can't contain +
    letterGrade = strrep(letterGrade, '–', 'minus');  % field names can't contain -

    % save the cell data in appropriate field
    % locations of data harcoded for now, fix later?
    classData.(letterGrade).GPA = T{row, 4};
    classData.(letterGrade).NumberOfStudents = T{row, 5};
    classData.(letterGrade).GradePointxNumber = T{row, 7};
    classData.(letterGrade).PercentOfStudents = T{row, 9};
    classData.(letterGrade).SuggestedPercent = T{row, 12};
end
        
% totals for the class
% locations of data harcoded for now, fix later?
classData.Totals = struct;
classData.Totals.NumberOfStudents = T{20, 5};
classData.Totals.GradePointxNumber = T{20, 7};
classData.Totals.PercentOfStudents = T{20, 9};
classData.Totals.SuggestedPercent = T{20, 12};

% calculations done in Excel
% locations of data harcoded for now, fix later?
classData.classGPA = T{22, 15};
classData.medianGrade = T{27, 15};
