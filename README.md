# TCL Workshop
![Banner](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/banner.png)
>Engaged in a 5-day VSD training workshop focused on EDA automation using TCL scripting, gaining hands-on experience with Yosys and OpenTimer. Developed a TCL-based workflow that takes design information through CSV-formatted inputs, automates synthesis and static timing analysis, and generates a consolidated design report. Learned to develop a “TCL BOX” automation interface, which streamlines design execution by processing design data paths and tool configurations to deliver structured and detailed reporting. I have named my designed TCL Box here as "msynth".

## Day 1: Introduction to TCL and VSDSYNTH Toolbox Usage 
The objective of the designed TCL box is to act as a single command-line interface that accepts design inputs in from an Excel/CSV file automates tool execution passing these inputs to Yosys for RTL synthesis and OpenTimer for Static Timing Analysis, and generates a consolidated design report.

![Task](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/Task.png)
The subtasks and tools needed for the TCL box:

• Create command (for eg. vsdsynth) and pass
.csv from UNIX shell to TCL script

• Convert all inputs to format[1] & SDC format,
and pass to synthesis tool ‘Yosys’

• Convert format[1] & SDC to format[2] and pass
to timing tool ‘Opentimer’

• Generate output report

The goal of this day is to make two files - ```msynth```, a shell script and ```msynth.tcl```, a tcl script. The The shell script ```msynth``` handles user input and validation, and delegates the core automation tasks to ```msynth.tcl``` using the command below
>tclsh msynth.tcl $argv[1]
In the above command, $argv[1] is argument placeholder. We pass the design detail csv file her in this argument.Then we also design the toolbox to behave under different user input conditions. Three main scenarios were explored:
### Scenario 1: No CSV File Provided
![Scenario1](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/scenario1.png)
### Scenario 2: Incorrect CSV File Provided
![Scenario2](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/scenario2.png)
### Scenario 3: Help Option (-help)
![Scenario3](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/scenario3.png)

## Day 2: Variable Creation and Processing Constraints from CSV
All design inputs provided through the CSV file are first converted into Format[1] along with corresponding SDC constraints, and then passed to the synthesis tool Yosys, this involves following tasks:
1. Create TCL variables from the design input CSV file.
2. Verify the existence of all directories and files mentioned in the CSV input.
3. Read the Constraints File specified in the CSV and convert it into SDC format.
4. Read all RTL files present in the Netlist Directory.
5. Generate the main synthesis script in Format[2].
6. Pass the generated synthesis script to Yosys for execution

Day 2 mainly focuses on tasks 1 and 2. It starts with creating and editing the ```msynth.tcl``` file to read the design_details.csv file and converting it into a matrix object using TCL’s ```csv``` and ```struct::matrix``` packages. The matrix and array approach helps us autocreate variables using string mapping.
![designdetails](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/designdetails.png)

Then we write the tcl script to check for the existence of the directiories and files mentioned in the above csv file:
![verify](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/verifyexistyes.png)
The data in the csv format is stored in the these autocreated variables:
* DesignName = openMSP430
* OutputDirectory = /home/vsduser/vsdsynth/outdir_openMSP430
* NetlistDirectory = /home/vsduser/vsdsynth/verilog
* EarlyLibraryPath = /home/vsduser/vsdsynth/osu018_stdcells.lib
* LateLibraryPath = /home/vsduser/vsdsynth/osu018_stdcells.lib
* ConstraintsFile = /home/vsduser/vsdsynth/openMSP430_design_constraints.csv

On Day 2, we also write the TCL stript to read the constraints csv file and calculate row numbers for Clock, input and Output Ports in the csv file by converting it to matrix and accessing it using ```lindex``` command. The row numbers are then stored in variables to process it later to create SDC format file.
![calcrow](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/calcrow.png)
