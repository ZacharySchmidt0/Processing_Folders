% test_Read_xls

close all
clear
%fs = matlab.io.datastore.FileSet("airlinesmall_subset.xlsx");
%ssds = spreadsheetDatastore("airlinesmall_subset.xlsx")
%ssds = spreadsheetDatastore("MecE260_UNDERGRAD Grade Dist Form.xlsx")
%sheetnames(ssds,1)
filename = "MecE260_UNDERGRAD Grade Dist Form.xlsx";
T = readtable(filename,'Sheet','SECOND YEAR')