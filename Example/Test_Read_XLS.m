% test_Read_xls

close all
clear
%fs = matlab.io.datastore.FileSet("airlinesmall_subset.xlsx");
%ssds = spreadsheetDatastore("airlinesmall_subset.xlsx")
%ssds = spreadsheetDatastore("MecE260_UNDERGRAD Grade Dist Form.xlsx")
%sheetnames(ssds,1)
filename = "MecE260_UNDERGRAD Grade Dist Form.xlsx";
T = readtable(filename,'Sheet','SECOND YEAR');

data = struct;
valueFlag = 0;

for i = 1:size(T.Properties.VariableNames, 2)
    if ~strcmp(extractBetween(T.Properties.VariableNames(i), 1, 3), 'Var')
        if valueFlag == 0
            field = T.Properties.VariableNames(i);
            valueFlag = 1;
        elseif valueFlag == 1
            [data(:).(field{1})] = T.Properties.VariableNames(i);
            valueFlag = 0;
        end     
    end
end
