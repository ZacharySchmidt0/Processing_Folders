% Developed by: Jason Kim, Zachary Schmidt
% Last Revised: June 24, 2022

% Entry point to read one grade distribution Excel file
% Saves classData as a .mat file in the current directory

filename = input("Enter path to Excel file: ");
configData = readConfig('configuration_file');
classData = readGradeDist(filename, configData);
save("classData.mat", "classData")