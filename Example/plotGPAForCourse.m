function average = plotGPAForCourse(classData, course)
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