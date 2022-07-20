function plotGPAForInstructor(classData, instructor, className)

semesters = fieldnames(classData);
gpaOverTime = struct;

for i=1:numel(semesters)
    currentSemester = char(semesters(i));
    for j=1:numel(classData.(currentSemester))
        currentClass = classData.(currentSemester)(j);
        if strcmp(currentClass.instructor, instructor) && strcmp(currentClass.course_number, className)
            gpaOverTime.(currentSemester) = currentClass.classGPA;
        end
    end
end

semesterTimes = {};
includedSemesters = fieldnames(gpaOverTime);
for i=1:numel(includedSemesters)
    currSem = char(includedSemesters{i});
    if strcmp(currSem(1), 'W')
        semesterTimes{end + 1} = datetime(str2num(currSem(2:5)), 1, 1);
    end
    if strcmp(currSem(1), 'S')
        semesterTimes{end + 1} = datetime(str2num(currSem(2:5)), 5, 1);
    end
    if strcmp(currSem(1), 'F')
        semesterTimes{end + 1} = datetime(str2num(currSem(2:5)), 9, 1);
    end
end

for i=1:numel(semesterTimes)
    for j = i:numel(semesterTimes)
        if semesterTimes{j} < semesterTimes{i}
            temp = semesterTimes{i};
            semesterTimes{i} = semesterTimes{j};
            semesterTimes{j} = temp;
        end
    end
end

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

gpaList = [];
for i=1:numel(charSortedSems)
    gpaList(end + 1) = gpaOverTime.(charSortedSems{i});
end

xAxis = categorical(charSortedSems);
xAxis = reordercats(xAxis, charSortedSems);

bar(xAxis, gpaList)
title(['Average Class GPA for instructor:', ' ', instructor, ' ', 'in class:', ' ', className])
xlabel('Semester')
ylabel('Avergae GPA (/4.0)')


