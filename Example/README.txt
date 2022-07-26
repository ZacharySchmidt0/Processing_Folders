Developers: Zachary Schmidt, Jason Kim
Oversight: Dr. David Nobes
Summer 2022, University of Alberta

Purpose:
The purpose of this project is to parse grade distribution Excel files. These files are derived from a template file
and are modified by instructors after the grades for a course are finalized. These files grant the instructors and
other faculty the ability to easily see the distribution of grades for a particular course.

This project helps to amalgamate the data into one location, where it can then be plotted using the included functions.

Entry File: readExcelFiles.m
The readExcelFiles.m script will parse the configuration file (configuration_file.xlsx) then search through the Distribution
Files folder, extracting information from each of the grade distribution files (after checking if the file follows the grade
distribution template). While extracting this information, the program compares the department name, instructor name, and 
course name to the names found in the configuration file. If the name does not match any of the config file names, 
a warning is displayed on the command line and a row in a file called ConfigErrors.xlsx is written with the details of the mismatch.

Configuration File format:
- The configuration file must be in the same directory as readExcelFile.m and must be called "configuration_file.xlsx"
- Each row corresponds to one entry
- The first column in each row should state the type of entry (either "Instructor", "Department", or "Course Number")
- The second column in each row should be the preferred name (this is the name that appear in the return struct)
- The following rows should contain the alternate names and should include all spellings that will appear in the grade dist files

Plotting Functions:

	plotGPAOverTime: plots the average GPA for one course (one or all instructors) over all semesters that course is offered

	plotDistributionsOverTime: plots the grade distribution for one course (one or all instructors). Each semester is displayed
	in a new figure window.

Other functions:

	findAverageGPAforCourse: determines the overall average GPA for a course over all semesters