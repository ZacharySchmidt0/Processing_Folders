% test_Read_xls

close all
clear
%fs = matlab.io.datastore.FileSet("airlinesmall_subset.xlsx");
%ssds = spreadsheetDatastore("airlinesmall_subset.xlsx")
%ssds = spreadsheetDatastore("MecE260_UNDERGRAD Grade Dist Form.xlsx")
%sheetnames(ssds,1)
filename = "MecE260_UNDERGRAD Grade Dist Form.xlsx";
T = readcell(filename,'Sheet','SECOND YEAR');
T(cellfun(@(x) isa(x,'missing'), T)) = {''};

data = struct;

for row = 3:4
    valueFlag = 0;
    for col = 1:size(T, 2)
        if (~strcmp(T{row, col}, ''))
            if valueFlag == 0
                field = T{row, col};
                field = strrep(field, ' ', '_');
                field = strrep(field, ':', '');
                valueFlag = 1;
            elseif valueFlag == 1
                data.(field) = T{row, col};
                valueFlag = 0;
            end     
        end
    end
end
