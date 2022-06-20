filename = input("Enter path to Excel file: ")
classData = readGradeDist(filename)
save("classData.mat", "classData")