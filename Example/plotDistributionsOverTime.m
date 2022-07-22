% Developed by: Zachary Schmidt, Jason Kim
% Summer 2022, University of Alberta

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

% Creating gpaOverTime struct with field as semester (eg: 'S2021', 'W1986')
% and value as average GPA for that semester
for i=1:numel(semesters)
    currentSemester = char(semesters(i));
    distOverTime.(currentSemester) = struct;
    for j=1:numel(classData.(currentSemester))
        currentClass = classData.(currentSemester)(j);
        if allInstructors == 1
            % Need to accumulate gpa & average after
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

for i=1:numel(includedSemesters)
    yAxis = [];
    sectionNames = fieldnames(distOverTime.(includedSemesters{i}));
    for j=1:numel(sectionNames)
        gradeNames = fieldnames(distOverTime.(includedSemesters{i}).(sectionNames{j}));
        xAxis = categorical(gradeNames);
        xAxis = reordercats(xAxis, gradeNames);
        for k=1:numel(gradeNames)
            numStudents = distOverTime.(includedSemesters{i}).(sectionNames{j}).(gradeNames{k}).NumberOfStudents;
            yAxis(end + 1) = numStudents;
        end
    end
    bar(xAxis, yAxis)
end




