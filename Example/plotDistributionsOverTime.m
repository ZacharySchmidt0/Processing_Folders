% Developed by: Zachary Schmidt, Jason Kim
% Summer 2022, University of Alberta

% Plots the grade distributions for one course (& one or all instructors).
% The grade distribution for each semester is plotted on a separate figure
% window.
% Parameters:
%   classData (struct) - struct with all data parsed from grade
%   distribution files by readExcelFile.m
%   className (char array) - name of the course. Can be a main or alt
%   name found in configuration_file.xlsx
%   instructor (char array) - name of the instructor. Can be a main or
%   alt name found in configuration_file.xlsx or '*' for all instructors
function plotDistributionsOverTime(classData, className, instructor)

allInstructors = 0;
if strcmp(instructor, '*')
    allInstructors = 1;
    instructor = 'All instructors';
end

% Pulling configuration info. File name hardcoded
configData = readConfig('configuration_file');

% Checking if instructor name is a main or alt name. If it is a main name, 
% it is left alone. If it is an alt name, it is converted to the main name.
% If it is not a main or alt name, an error is thrown.
if allInstructors == 0
    foundAltName = 0;
    for i = 1:numel(configData.Instructors)
        configFieldName = configData.Instructors{i}{1};
        for j = 1:numel(configData.Instructors{i})
            % check if entry is an alternative name
            if strcmp(instructor, configData.Instructors{i}{j})
                % alternative name found
                foundAltName = 1;
                instructor = configFieldName;
            end
        end
    end
    if foundAltName == 0
        % entry is not main or alt name
        error('Instructor name is not a main or alt name found in config file')
    end
end

% Same as above but checking className
foundAltName = 0;
for i = 1:numel(configData.CourseNums)
    configFieldName = configData.CourseNums{i}{1};
    for j = 1:numel(configData.CourseNums{i})
        % check if entry is an alternative name
        if strcmp(className, configData.CourseNums{i}{j})
            % alternative name found
            foundAltName = 1;
            className = configFieldName;
        end
    end
end
if foundAltName == 0
    % entry is not main or alt name
    error('Class name is not a main or alt name found in config file')
end

semesters = fieldnames(classData);
distOverTime = struct;

% Creating distOverTime struct with field as semester (eg: 'S2021', 'W1986')
% and value as another struct with field as course name (with section
% number) and value as a struct containing the grade distribution
for i=1:numel(semesters)
    currentSemester = char(semesters(i));
    distOverTime.(currentSemester) = struct;
    for j=1:numel(classData.(currentSemester))
        currentClass = classData.(currentSemester)(j);
        if allInstructors == 1
            % include all instructors
            if strcmp(currentClass.course_number, className)
                % only want specified course
                distOverTime.(currentSemester).(strrep(strcat(currentClass.course_number, currentClass.section), ' ', '')) = currentClass.Grades;
            end
        elseif strcmp(currentClass.instructor, instructor)
            % only want sepcified instructor
            if strcmp(currentClass.course_number, className)
                % only want specified course
                distOverTime.(currentSemester).(strrep(strcat(currentClass.course_number, currentClass.section), ' ', '')) = currentClass.Grades;
            end
        end
    end
end

includedSemesters  = fieldnames(distOverTime);
figures = [];  % each semester is plot on a new figure window

for i=1:numel(includedSemesters)
    sectionNames = fieldnames(distOverTime.(includedSemesters{i}));  % could have many course sections
    for j=1:numel(sectionNames)
        gradeNames = fieldnames(distOverTime.(includedSemesters{i}).(sectionNames{j}));
        yAxis = zeros(numel(gradeNames), 1);
        plotNames = gradeNames;
        for m=1:numel(gradeNames)
            % field names couldn't have + or - in name, can change it back
            plotNames{m} = strrep(plotNames{m}, '_plus', '+');
            plotNames{m} = strrep(plotNames{m}, '_minus', '-');
        end
        xAxis = categorical(flip(plotNames));  % flip xaxis order
        xAxis = reordercats(xAxis, flip(plotNames));  % lock the order in
        for k=1:numel(gradeNames)
            % pulling the number of students achieving each grade
            numStudents = distOverTime.(includedSemesters{i}).(sectionNames{j}).(gradeNames{k}).NumberOfStudents;
            yAxis(k) = numStudents;
        end
        % plotting the data in new figure window
        xAxis = flip(xAxis);
        figures(end + 1) = figure;
        figure(figures(end))
        bar(xAxis, yAxis)
        title(['Grade Dist for Semester:', ' ', includedSemesters{i}, ' ', 'and Class:', ' ', className, '. Instructor:', ' ', instructor])
    end
end




