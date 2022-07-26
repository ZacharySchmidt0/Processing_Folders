% Developed by: Zachary Schmidt, Jason Kim
% Summer 2022, University of Alberta

% Function that takes in a course and the classData struct and determines
% the average GPA over all semesters provided
% Parameters:
%   classData (struct) - the struct containing the grade distribution data
%   course (char array) - the name of the course
% Returns: the average GPA for that course over all semesters (double)
function average = findAverageGPAforCourse(classData, course)
    fieldNms = fieldnames(classData);  % names of semesters
    GPtotal = 0;  % running sum of grade points earned
    studentTotal = 0;  % running sum of # of students 
    for i=1:numel(fieldNms)  % for each semester
        structArray = classData.(fieldNms{i});
        for j=1:numel(structArray)  % for each class
            struct = structArray(j);
            if strcmp(struct.course_number, course)
                GPtotal = GPtotal + (struct.classGPA * struct.number_of_students_in_class);
                studentTotal = studentTotal + struct.number_of_students_in_class;
            end
        end
        average = GPtotal / studentTotal;
    end
