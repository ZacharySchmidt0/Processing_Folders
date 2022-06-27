% Developed by: Jason Kim, Zachary Schmidt
% Last Revised: June 24, 2022

% Entry point to read one grade distribution Excel file
% Saves classData as a .mat file in the current directory

disp("Finding files...")
filenames = findfiles('MecE*?.xlsx');
disp(filenames)
configData = readConfig('configuration_file');
classData = [];

for i = 1:size(filenames)
    classData = [classData readGradeDist(filenames{i}, configData)];
    disp(classData)
end

save("classData.mat", "classData")