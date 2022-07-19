function plotGPAForInstructor(classData, instructor)

semesters = fieldnames(classData);
gpaOverTime = struct;

for i=1:numel(semesters)
    currentSemester = char(semesters(i));
    for j=1:numel(classData.(currentSemester))
        currentClass = classData.(currentSemester)(j);
        if strcmp(currentClass.instructor, instructor)
            gpaOverTime.(currentSemester) = currentClass.classGPA;
        end
    end
end