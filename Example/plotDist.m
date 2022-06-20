function plotDist(classData)

fields = fieldnames(classData.Grades);
fieldArr = {};
percentArr = [];

for i = 1:numel(fields)
    fieldArr{i} = fields{i};
    percentArr(i) = classData.Grades.(fields{i}).PercentOfStudents;
end

fieldArr = rot90(fieldArr);
percentArr = flip(percentArr);

plot(percentArr, '-o', 'MarkerSize', 10,'Color', 'red');

set(gca, 'XTick', linspace(1, length(fieldArr), length(fieldArr)));
set(gca, 'xticklabel', fieldArr);