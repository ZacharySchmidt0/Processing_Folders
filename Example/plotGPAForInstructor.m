% Developed by: Zachary Schmidt, Jason Kim
% Summer 2022, University of Alberta

% Plots the average GPA for each semester that a course is offered by one
% instructor. The plot is a bar graph.
% Parameters:
%   classData (struct) - struct with all data parsed from grade
%   distribution files by readExcelFile.m
%   instructor (char array) - name of the instructor. Can be a main or
%   alt name found in configuration_file.xlsx
%   className (char array) - name of the course. Can be a main or alt
%   name found in configuration_file.xlsx
function plotGPAForInstructor(classData, instructor, className)

% Pulling configuration info. File name hardcoded
configData = readConfig('configuration_file');

% Checking if instructor name is a main or alt name. If it is a main name, 
% it is left alone. If it is an alt name, it is converted to the main name.
% If it is not a main or alt name, an error is thrown.
foundAltName = 0;
for i = 1:numel(configData.Instructors)
    configFieldName = configData.Instructors{i}{1};
    for j = 1:numel(configData.Instructors{i})
        % check if entry is an alternative name
        % replace flags with original values
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

% Same as above but checking className
foundAltName = 0;
for i = 1:numel(configData.CourseNums)
    configFieldName = configData.CourseNums{i}{1};
    for j = 1:numel(configData.CourseNums{i})
        % check if entry is an alternative name
        % replace flags with original values
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
% and value as average GPA
for i=1:numel(semesters)
    currentSemester = char(semesters(i));
    for j=1:numel(classData.(currentSemester))
        currentClass = classData.(currentSemester)(j);
        if strcmp(currentClass.instructor, instructor) && strcmp(currentClass.course_number, className)
            % only want specified courses offered by the specified
            % instructor
            gpaOverTime.(currentSemester) = currentClass.classGPA;
        end
    end
end

% Creating cell array of semesters in datetime format (datetime allows for
% easy comparison using <, >)
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
    for j = i:(numel(semesterTimes) - i)
        if semesterTimes{j} < semesterTimes{j + 1}
            temp = semesterTimes{j};
            semesterTimes{j} = semesterTimes{j + 1};
            semesterTimes{j + 1} = temp;
        end
    end
end

% Converting datetimes back to original format of semesters
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

gpaList = [];  % sorted list of GPAs
for i=1:numel(charSortedSems)
    gpaList(end + 1) = gpaOverTime.(charSortedSems{i});
end

xAxis = categorical(charSortedSems);  % allows for plotting on bar graph
xAxis = reordercats(xAxis, charSortedSems);  % ensures order is unchanged when plotting

bar(xAxis, gpaList)
title(['Average Class GPA for instructor:', ' ', instructor, ' ', 'in class:', ' ', className])
xlabel('Semester')
ylabel('Avergae GPA (/4.0)')
