% Developed by: Jason Kim, Zachary Schmidt
% Last Revised: June 23, 2022

% Parses one Grade Distribution file and organizes
% the data into a struct.
%
% Parameters:
%   filename (string or char array): name of the grade distribution file to
%   be parsed
% 
% Returns: 
% classData: struct with fields:
%   Department (char array)
%   Instructor (char array)
%   Course_number (char array): Course code (eg: MECE 260)
%   Section (char array): Specifies course if multiple offerings
%   Number_of_students_in_class (double)
%   Grades (struct): struct with fields as all letter grades,
%       plus letters end in "_plus" and minus letters end in "_minus".
%       Each letter grade has fields "GPA", "NumberOfStudents",
%       "GradePointxNumber", "PercentOfStudents", "SuggestedPercent"
%   Totals (struct): struct with fields:
%       NumberOfStudents (double): number of students in course
%       GradePointxNumber (double): totals grade points earned in class
%   classGPA (double): mean GPA for course
%   medianGrade (char array): median letter grade for course
function classData = readGradeDist(filename)

close all

% finding the only non-empty sheet
% read first year sheet, if instructor is blank, go to next, and so on
T = readcell(filename,'Sheet','FIRST YEAR');
T(cellfun(@(x) isa(x,'missing'), T)) = {''};  % replace missing cells with empty string
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

classData = struct;

for row = 3:4  % rows 3 and 4 contain info about class (instructor, dept)
    valueFlag = 0;
    for col = 1:size(T, 2)
        if (~strcmp(T{row, col}, ''))
            if valueFlag == 0
                % cell value is a field (not a value)
                field = T{row, col};  % save the field, retrieved when we get the value
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
    letterGrade = strrep(letterGrade, '–', '_minus');  % field names can't contain -

    % save the cell data in appropriate field
    % FIXME: locations of data harcoded for now
    classData.Grades.(letterGrade).GPA = T{row, 4};
    classData.Grades.(letterGrade).NumberOfStudents = T{row, 5};
    classData.Grades.(letterGrade).GradePointxNumber = T{row, 7};
    classData.Grades.(letterGrade).PercentOfStudents = T{row, 9};
    classData.Grades.(letterGrade).SuggestedPercent = T{row, 12};
end
        
% totals for the class
% FIXME: locations of data harcoded for now
classData.Totals = struct;
classData.Totals.NumberOfStudents = T{20, 5};
classData.Totals.GradePointxNumber = T{20, 7};

% calculations done in Excel
% FIXME: locations of data harcoded for now
classData.classGPA = T{22, 15};
classData.medianGrade = T{27, 15};
