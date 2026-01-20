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

The goal of this day is to make two files - ```msynth```, a shell script and ```msynth.tcl```, a tcl script. The The shell script ```msynth``` handles user input and validation, and delegates the core automation tasks to ```msynth.tcl``` using the command ```tclsh msynth.tcl $argv[1]```. Also understand how the toolbox behaves under different user input conditions. Three main scenarios were explored:
### Scenario 1: No CSV File Provided


