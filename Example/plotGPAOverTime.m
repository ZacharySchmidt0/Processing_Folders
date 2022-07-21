% Developed by: Zachary Schmidt, Jason Kim
% Summer 2022, University of Alberta

% Plots the average GPA for each semester that a course is offered.
% The plot is a simple bar graph.
% Usage: instructor can be the main or alt name of an instructor or '*' to
% plot for all instructors of that course. className should be the main or
% alt name for a class. (main/alt names in configuration file)
% Parameters:
%   classData (struct) - struct with all data parsed from grade
%   distribution files by readExcelFile.m
%   className (char array) - name of the course. Can be a main or alt
%   name found in configuration_file.xlsx
%   instructor (char array) - name of the instructor. Can be a main or
%   alt name found in configuration_file.xlsx or '*' for all instructors
function plotGPAOverTime(classData, className, instructor)

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
gpaOverTime = struct;

% Creating gpaOverTime struct with field as semester (eg: 'S2021', 'W1986')
% and value as average GPA for that semester
for i=1:numel(semesters)
    currentSemester = char(semesters(i));
    totalGpa = 0;
    numCourses = 0;
    for j=1:numel(classData.(currentSemester))
        currentClass = classData.(currentSemester)(j);
        if allInstructors == 1
            % Need to accumulate gpa & average after
            if strcmp(currentClass.course_number, className)
                % only want specified course
                totalGpa = totalGpa + currentClass.classGPA;
                numCourses = numCourses + 1;
            end
            gpaOverTime.(currentSemester) = totalGpa/numCourses;  % average over all course sections
        elseif strcmp(currentClass.instructor, instructor)
            % only want sepcified instructor (or all instructors)
            if strcmp(currentClass.course_number, className)
                % only want specified course
                gpaOverTime.(currentSemester) = currentClass.classGPA;
            end
        end
    end
end

% Creating cell array of semesters in datetime format (datetime allows for
% easy comparison during sorting using <, >)
semesterTimes = {};
includedSemesters = fieldnames(gpaOverTime);
for i=1:numel(includedSemesters)
    currSem = char(includedSemesters{i});
    if strcmp(currSem(1), 'W')
        % if in winter, set date as Jan 1 of the year
        semesterTimes{end + 1} = datetime(str2num(currSem(2:5)), 1, 1);
    end
    if strcmp(currSem(1), 'S')
        % if in summer, set date as May 1 of the year
        semesterTimes{end + 1} = datetime(str2num(currSem(2:5)), 5, 1);
    end
    if strcmp(currSem(1), 'F')
        % if in fall, set date as Sep 1 of the year
        semesterTimes{end + 1} = datetime(str2num(currSem(2:5)), 9, 1);
    end
end

% Sorting semesters (bubblesort) from oldest to newest
for i=1:numel(semesterTimes)
    for j = 1:(numel(semesterTimes) - i)
        if semesterTimes{j} > semesterTimes{j + 1}  % if right sem is older than left sem
            % swap adjacent entries
            temp = semesterTimes{j};
            semesterTimes{j} = semesterTimes{j + 1};
            semesterTimes{j + 1} = temp;
        end
    end
end

% Converting datetimes back to original format of semesters (eg: 'F2021')
charSortedSems = {};
for i=1:numel(semesterTimes)
    [year, month, ~] = ymd(semesterTimes{i});
    if month == 1
        season = 'W';
    elseif month == 5
        season = 'S';
    elseif month == 9
        season = 'F';
    end
    charSortedSems{end + 1} = strcat(season, num2str(year));
end

gpaList = [];  % list of GPAs sorted by time (older semesters come first)
for i=1:numel(charSortedSems)
    gpaList(end + 1) = gpaOverTime.(charSortedSems{i});
end

xAxis = categorical(charSortedSems);  % allows for plotting on bar graph
xAxis = reordercats(xAxis, charSortedSems);  % ensures order is unchanged when plotting

bar(xAxis, gpaList)
title(['Average Class GPA for instructor:', ' ', instructor, ' ', 'in class:', ' ', className])
xlabel('Semester')
ylabel('Avergae GPA (/4.0)')
