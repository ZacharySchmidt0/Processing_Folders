% Developed by: Jason Kim, Zachary Schmidt
% Summer 2022, University of Alberta

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
function classData = readGradeDist(filename, configData)

close all

% finding the only non-empty sheet
% read first year sheet, if instructor is blank, go to next, and so on
Class = readcell(filename,'Sheet','FIRST YEAR');
Class(cellfun(@(x) isa(x,'missing'), Class)) = {''};  % replace missing cells with empty string
if strcmp(Class{3, 12}, '')  % row 3, col 12 is instructor location
    Class = readcell(filename,'Sheet','SECOND YEAR');
    Class(cellfun(@(x) isa(x,'missing'), Class)) = {''};
end
if strcmp(Class{3, 12}, '')
    Class = readcell(filename,'Sheet','THIRD YEAR');
    Class(cellfun(@(x) isa(x,'missing'), Class)) = {''};
end
if strcmp(Class{3, 12}, '')
    Class = readcell(filename,'Sheet','FOURTH YEAR');
    Class(cellfun(@(x) isa(x,'missing'), Class)) = {''};
    if strcmp(Class{3, 12}, '')
        % No instructor name on any sheet
        error('Instructor is blank on all sheets in file ' + filename)
    end
end

classData = struct;

for row = 3:4  % rows 3 and 4 contain info about class (instructor, dept)
    valueFlag = 0;
    for col = 1:size(Class, 2)
        if (~strcmp(Class{row, col}, ''))
            if valueFlag == 0
                % cell value is a field (not a value)
                field = Class{row, col};  % save the field, retrieved when we get the value
                field = strrep(field, ' ', '_');  % field names can't contain _
                field = strrep(field, ':', '');  % field names can't contain :
                field = lower(field);
                valueFlag = 1;
            elseif valueFlag == 1
                % cell is a value
                % errormsg = ['The entry on row ', num2str(row), ' and column ', num2str(col), ' in file "', filename, '" is not present in the configuration file.'];
                switch field
                    case 'department'
                        foundAltName = 0;
                        for i = 1:numel(configData.Departments)
                            configFieldName = configData.Departments{i}{1};
                            for j = 1:numel(configData.Departments{i})
                                % check if entry is an alternative name
                                % replace flags with original values
                                if strcmp(Class{row, col}, configData.Departments{i}{j})
                                    % alternative name found
                                    foundAltName = 1;
                                    Class{row, col} = configFieldName;
                                end
                            end
                        end
                        if foundAltName == 0
                            % entry is not main or alt name
                            errormsg = ['Invaild department. The entry "', Class{row, col}, '" on row ', num2str(row), ' and column ', num2str(col), ' in file "', filename, '" is not present in the configuration file as a vaild department name.'];
                            warning(errormsg)

                        end
                    case 'instructor'
                        foundAltName = 0;
                        for i = 1:numel(configData.Instructors)
                            configFieldName = configData.Instructors{i}{1};
                            for j = 1:numel(configData.Instructors{i})
                                % check if entry is an alternative name
                                % replace flags with original values
                                if strcmp(Class{row, col}, configData.Instructors{i}{j})
                                    % alternative name found
                                    foundAltName = 1;
                                    Class{row, col} = configFieldName;
                                end
                            end
                        end
                        if foundAltName == 0
                            % entry is not main or alt name
                            errormsg = ['Invaild instructor. The entry "', Class{row, col}, '" on row ', num2str(row), ' and column ', num2str(col), ' in file "', filename, '" is not present in the configuration file as a vaild instructor name.'];
                            warning(errormsg)

                        end
                    case 'course_number'
                        foundAltName = 0;
                        for i = 1:numel(configData.CourseNums)
                            configFieldName = configData.CourseNums{i}{1};
                            for j = 1:numel(configData.CourseNums{i})
                                % check if entry is an alternative name
                                % replace flags with original values
                                if strcmp(Class{row, col}, configData.CourseNums{i}{j})
                                    % alternative name found
                                    foundAltName = 1;
                                    Class{row, col} = configFieldName;
                                end
                            end
                        end
                        if foundAltName == 0
                            % entry is not main or alt name
                            errormsg = ['Invaild course name. The entry "', Class{row, col}, '" on row ', num2str(row), ' and column ', num2str(col), ' in file "', filename, '" is not present in the configuration file as a vaild course name.'];
                            warning(errormsg)

                        end
                end
                classData.(field) = Class{row, col};
                valueFlag = 0;
            end     
        end
    end
end

for row = 8:19
    % the main class data in rows 8-19
    letterGrade = Class{row, 3};
    letterGrade = strrep(letterGrade, '+', '_plus');  % field names can't contain +
    letterGrade = strrep(letterGrade, '???', '_minus');  % field names can't contain -

    % save the cell data in appropriate field
    % FIXME: locations of data harcoded for now
    classData.Grades.(letterGrade).GPA = Class{row, 4};
    classData.Grades.(letterGrade).NumberOfStudents = Class{row, 5};
    classData.Grades.(letterGrade).GradePointxNumber = Class{row, 7};
    classData.Grades.(letterGrade).PercentOfStudents = Class{row, 9};
    classData.Grades.(letterGrade).SuggestedPercent = Class{row, 12};
end
        
% totals for the class
% FIXME: locations of data harcoded for now
classData.Totals = struct;
classData.Totals.NumberOfStudents = Class{20, 5};
classData.Totals.GradePointxNumber = Class{20, 7};

% calculations done in Excel
% FIXME: locations of data harcoded for now
classData.classGPA = Class{22, 15};
classData.medianGrade = Class{27, 15};
