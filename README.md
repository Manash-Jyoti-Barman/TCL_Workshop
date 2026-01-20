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
![constraints](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/constraints.png)
![calcrow](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/calcrow.png)

##  Day 3: Processing Clock and Input Constraints
The objective of day 3 was to automatically extract clock-related and input-related parameters from the constraints CSV and generate complete clock and input constraints in a newly created SDC file.

For processing of **clock constraints**, an algorithm using ```search rect``` (Search for a value (pattern) inside a rectangular region of the matrix, defined by start and end column and row indices.) was implemented to identify the column indices corresponding to clock latency and clock transition parameters (early/late, rise/fall). Using matrix search operations, the script dynamically located these constraint fields.

All clock-related constraints were written sequentially into the SDC file by creating and opening it in write (w) mode one by one automatically.
![clock1](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/clock1.png)

For processing of **input constraints**, first of all special emphasis was given on differentiating between scalar (bit) inputs and bussed inputs.The task began with identifying the relevant constraint columns for input delays and input transitions from the constraints CSV similarly like it is done for clock constraints.
The main steps include after identifying input constraints in csv file are:
1. Using pattern matching and regular expressions ```regexp``` to identify input declarations.
2. Normalizing whitespace using regular substitution ```\S+``` to create fixed-space strings.
3. Reading, splitting, uniquifying, sorting, and joining input port names to eliminate duplication.
4. Evaluating string length to Distinguish between single-bit ports and bus ports.
5. Concatenate '*' at the end of the bus input port to distinguish them. 

These ports which are distinguised and stored are then used to add the input constaints in the SDC file.
![input1](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/input1.png)

## Day 4: Complete Scripting and Yosys Synthesis Introduction
On Day 4 of the workshop SDC file generation is completed by output constraint generation. This SDC file is passed to synthesis tools along with some other files for synthesis. Integration of the open source synthesis tool **Yosys** is integrated with the TCL box.

The session was divided into three major parts: output constraint generation, hierarchy check with error handling.

For processing of **output constraints**, same algorithm and methods were used as we used in processing of input constraints.
![output1](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/output1.png)
The SDC file generated ```openMSP430.sdc``` looks like:
![SDC_file](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/sdcfile.png)

A dedicated Yosys script was automatically generated using TCL to:
1. Read the standard cell library
2. Read all RTL netlist files
3. Perform a hierarchy check to detect missing or undefined modules

The TCL script then executed this hierarchy check and captured the output log. Error handling logic was implemented to detect hierarchy-related failures by parsing the Yosys log file. 
* If missing module references were found, the script reported clear, user-friendly error message FAIL indicating the problematic or missing module and RTL path.
![FAIL](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/hierarchyFAIL.png)
Below is the Error Message highlighted in the hierarchy check log file which is used by the TCL script.
![Error_log](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/hierarchylog.png)
* If no errors were detected, the hierarchy check was marked as successful displaying PASS message.
![PASS](https://github.com/Manash-Jyoti-Barman/TCL_Workshop/blob/main/Assets/hierarchyPASS.png)
