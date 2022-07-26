% Developed by: Zachary Schmidt, Jason Kim
% Summer 2022, University of Alberta

% Function that takes in a course and the classData struct and detrimines
% the average GPA over all semesters provided
% Parameters:
%   classData (sturct) - the struct containing the grade distrubution data
%   course - (char array) - the name of the course
% Returns: the average GPA for that course over all semesters (double)
function average = findAverageGPAforCourse(classData, course)
    fieldNms = fieldnames(classData);
    GPtotal = 0
    studentTotal = 0
    for i=1:numel(fieldNms)
        structArray = classData.(fieldNms{i});
        for j=1:numel(structArray)
            struct = structArray(j);
            if (struct.course == course)
                GPtotal = GPtotal + (struct.classGPA * struct.number_of_stundents_in_class);
                studentTotal = studentTotal + struct.number_of_stundents_in_class
            end
        end
        average = GPtotal / studentTotal
    end