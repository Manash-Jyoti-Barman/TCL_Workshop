#!/bin/tclsh

#Converting .csv to matrix and creation of initial variables
set filename [lindex $argv 0]
package require csv
package require struct::matrix
struct::matrix m
set f [open $filename]
csv::read2matrix $f m , auto
close $f
m link my_arr
set columns [m columns]
set rows [m rows]
set i 0

#Auto creation of variable names and assignment of variables
while {$i < $rows} {

	puts "\nInfo: assigning $my_arr(0,$i) as $my_arr(1,$i)"

	if {$i == 0} {
		set  [string map {" " ""} $my_arr(0,$i)] $my_arr(1,$i)
	} else {
		set [string map {" " ""} $my_arr(0,$i)] [file normalize $my_arr(1,$i)]
	}
	set i [expr {$i+1}]
}

puts "\nInfo: The list of initial variables and their values are as follows"
puts "\nDesignName = $DesignName"
puts "OutputDirectory = $OutputDirectory"
puts "NetlistDirectory = $NetlistDirectory"
puts "EarlyLibraryPath = $EarlyLibraryPath"
puts "LateLibraryPath  = $LateLibraryPath"
puts "ConstraintsFile = $ConstraintsFile"

#Checking whether the files and directories that are mentioned in the .csv file exists or not
if {! [file exists $EarlyLibraryPath] } {
	puts "\nError: cannot find early cell library in $EarlyLibraryPath. Exiting...."
	exit
} else {
	puts "\nInfo: Early cell library found in $EarlyLibraryPath."
}
if {! [file exists $LateLibraryPath] } {
	puts "\nError: cannot find Late cell library in $LateLibraryPath. Exiting...."
	exit
} else {
	puts "\nInfo: Late cell library found in $LateLibraryPath."
}
if {! [file isdirectory $NetlistDirectory] } {
	puts "\nError: cannot find RTL Netlist directory in path $NetlistDirectory. Exiting..."
} else {
	puts "\nInfo: RTL Netlist directory found in $NetlistDirectory"
}
if {! [file isdirectory $OutputDirectory] } {
	puts "\nError: cannot find Output directory in path $OutputDirectory.Creating Directory..."
	file mkdir $OutputDirectory
} else {
	puts "\nInfo: Output directory found in $OutputDirectory"
}
if {! [file exists $ConstraintsFile] } {
	puts "\nError: cannot find Constraints file in $ConstraintsFile. Exiting...."
	exit
} else {
	puts "\nInfo: Constraints file found in $ConstraintsFile."
}

#Constraints CSV file to format[1] and SDC
puts "\nInfo: Dumping sdc constraints for $DesignName"
::struct::matrix constraints
set chan [open $ConstraintsFile]
csv::read2matrix $chan constraints , auto
close $chan
set rows [constraints rows]
set columns [constraints columns]

puts "Number of rows in constraints file = $rows"
puts "Number of columns in constraints file = $columns"

#Calculating the row number for clock
set clk_start [lindex [lindex [constraints search all CLOCKS] 0 ] 1]
set clk_start_col [lindex [lindex [constraints search all CLOCKS] 0 ] 0]
puts "Clock start = $clk_start"
puts "Clock start_column =  $clk_start_col"

#Calculating the row numbers for input and output
set input_start [lindex [lindex [constraints search all INPUTS] 0 ] 1]
set output_start [lindex [lindex [constraints search all OUTPUTS] 0 ] 1]
puts "Inputs start = $input_start"
puts "Outputs start = $output_start"

#Processing the Clock constraints for SDC
#Clock latency constraints
set clock_early_rise_delay_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  early_rise_delay] 0 ] 0]

set clock_early_fall_delay_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  early_fall_delay] 0 ] 0]

set clock_late_rise_delay_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  late_rise_delay] 0 ] 0]

set clock_late_fall_delay_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  late_fall_delay] 0 ] 0]

#Clock Transition constraints
set clock_early_rise_slew_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  early_rise_slew] 0 ] 0]

set clock_early_fall_slew_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  early_fall_slew] 0 ] 0]

set clock_late_rise_slew_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  late_rise_slew] 0 ] 0]

set clock_late_fall_slew_start [lindex [lindex [constraints search rect $clk_start_col $clk_start [expr {$columns-1}] [expr {$input_start-1}]  late_fall_slew] 0 ] 0]

set sdc_file [open $OutputDirectory/$DesignName.sdc "w"]
set i [expr {$clk_start+1}]
set end_of_clock [expr {$input_start-1}]
puts "\nInfo: Working on clock constraints....."
while { $i < $end_of_clock } {
	#puts "      working on clock [constraints get cell 0 $i]"
        puts -nonewline $sdc_file "\ncreate_clock -name [constraints get cell 0 $i] -period [constraints get cell 1 $i] -waveform \{0 [expr {[constraints get cell 1 $i]*[constraints get cell 2 $i]/100}]\} \[get_ports [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -rise -min [constraints get cell $clock_early_rise_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -fall -min [constraints get cell $clock_early_fall_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        puts -nonewline $sdc_file "\nset_clock_transition -rise -max [constraints get cell $clock_late_rise_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        puts -nonewline $sdc_file "\nset_clock_transition -fall -max [constraints get cell $clock_late_fall_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        puts -nonewline $sdc_file "\nset_clock_latency -source -early -rise [constraints get cell $clock_early_rise_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        puts -nonewline $sdc_file "\nset_clock_latency -source -early -fall [constraints get cell $clock_early_fall_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        puts -nonewline $sdc_file "\nset_clock_latency -source -late -rise [constraints get cell $clock_late_rise_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        puts -nonewline $sdc_file "\nset_clock_latency -source -late -fall [constraints get cell $clock_late_fall_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
        set i [expr {$i+1}]
}

#Processing the Input constraints for SDC
#Finding starting column number for inputs
set input_early_rise_delay_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  early_rise_delay] 0 ] 0]
set input_early_fall_delay_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  early_fall_delay] 0 ] 0]
set input_late_rise_delay_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  late_rise_delay] 0 ] 0]
set input_late_fall_delay_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  late_fall_delay] 0 ] 0]

set input_early_rise_slew_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  early_rise_slew] 0 ] 0]
set input_early_fall_slew_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  early_fall_slew] 0 ] 0]
set input_late_rise_slew_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  late_rise_slew] 0 ] 0]
set input_late_fall_slew_start [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}]  late_fall_slew] 0 ] 0]

set input_related_clock [lindex [lindex [constraints search rect $clk_start_col $input_start [expr {$columns-1}] [expr {$output_start-1}] clocks] 0 ] 0]

set i [expr {$input_start+1}]
set end_of_inputs [expr {$output_start-1}]
puts "\nInfo: Working on input constraints....."
puts "\nInfo: Categorizing the input ports as bits and busses"
#Input_transition constraints
while { $i < $end_of_inputs } {
	set netlist [glob -dir $NetlistDirectory *.v]
	set tmp_file [open /tmp/1 w]
	foreach f $netlist {
		set fd [open $f]
		#puts "reading file $f"
		while { [gets $fd line] != -1 } {
			set pattern1 " [constraints get cell 0 $i];"
			if { [regexp -all -- $pattern1 $line] } {
				set pattern2 [lindex [split $line ";"] 0]
				if { [regexp -all {input} [lindex [split $pattern2 "\S+"] 0]] } {
					set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
					puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
				}	
			}
		}
	close $fd
	}
	close $tmp_file

	#Reading the /tmp/1 file
	set tmp_file [open /tmp/1 r]
	set tmp2_file [open /tmp/2 w]
	puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
	close $tmp_file
	close $tmp2_file
	set tmp2_file [open /tmp/2 r]
	set count [llength [read $tmp2_file]]
	close $tmp2_file
	if {$count > 2} {
		set in_ports [concat [constraints get cell 0 $i]*]
		#puts "      working on input $in_ports"

	} else {
		set in_ports [constraints get cell 0 $i]
		#puts "      working on input $in_ports"
	}

#Input_transition constraints
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_slew_start $i] $in_ports"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_slew_start $i] $in_ports"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_slew_start $i] $in_ports"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_slew_start $i] $in_ports"

	#Input_delay constraints
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_delay_start $i] $in_ports"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_delay_start $i] $in_ports"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_delay_start $i] $in_ports"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_delay_start $i] $in_ports"

	set i [expr {$i+1}]
}

#Processing the Output constraints for SDC
#Finding starting column number for outputs
set output_early_rise_delay_start [lindex [lindex [constraints search rect $clk_start_col $output_start [expr {$columns-1}] [expr {$rows-1}]  early_rise_delay] 0 ] 0]
set output_early_fall_delay_start [lindex [lindex [constraints search rect $clk_start_col $output_start [expr {$columns-1}] [expr {$rows-1}]  early_fall_delay] 0 ] 0]
set output_late_rise_delay_start [lindex [lindex [constraints search rect $clk_start_col $output_start [expr {$columns-1}] [expr {$rows-1}]  late_rise_delay] 0 ] 0]
set output_late_fall_delay_start [lindex [lindex [constraints search rect $clk_start_col $output_start [expr {$columns-1}] [expr {$rows-1}]  late_fall_delay] 0 ] 0]
set output_load_start [lindex [lindex [constraints search rect $clk_start_col $output_start [expr {$columns-1}] [expr {$rows-1}]  load] 0 ] 0]
set related_clock [lindex [lindex [constraints search rect $clk_start_col $output_start [expr {$columns-1}] [expr {$rows-1}]  clocks] 0 ] 0]

set i [expr {$output_start+1}]
set end_of_outputs [expr {$rows-1}]
puts "\nInfo: Working on output constraints....."
puts "\nInfo: Categorizing the output ports as bits and busses"
#output_transition constraints
while { $i < $end_of_outputs } {
	set netlist [glob -dir $NetlistDirectory *.v]
	set tmp_file [open /tmp/1 w]
	foreach f $netlist {
		set fd [open $f]
		#puts "reading file $f"
		while { [gets $fd line] != -1 } {
			set pattern1 " [constraints get cell 0 $i];"
			if { [regexp -all -- $pattern1 $line] } {
				set pattern2 [lindex [split $line ";"] 0]
				if { [regexp -all {output} [lindex [split $pattern2 "\S+"] 0]] } {
					set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
				puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
				}	
			}
		}
	close $fd
	}
	close $tmp_file

	#Reading the /tmp/1 file
	set tmp_file [open /tmp/1 r]
	set tmp2_file [open /tmp/2 w]
	puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
	close $tmp_file
	close $tmp2_file
	set tmp2_file [open /tmp/2 r]
	set count [llength [read $tmp2_file]]
	close $tmp2_file
	if {$count > 2} {
		set out_ports [concat [constraints get cell 0 $i]*]
		#puts "      working on output $out_ports"

	} else {
		set out_ports [constraints get cell 0 $i]
		#puts "      working on output $out_ports"
}
        puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $output_early_rise_delay_start $i] \[get_ports $out_ports\]"
        puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $output_early_fall_delay_start $i] \[get_ports $out_ports\]"
        puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $output_late_rise_delay_start $i] \[get_ports $out_ports\]"
        puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $output_late_fall_delay_start $i] \[get_ports $out_ports\]"
	puts -nonewline $sdc_file "\nset_load [constraints get cell $output_load_start $i] \[get_ports $out_ports\]"
	set i [expr {$i+1}]
}
close $sdc_file
puts "\nInfo: SDC file created. It can be found in the path  $OutputDirectory/$DesignName.sdc"

#Hierarchy check
puts "\nInfo: Creating Hierarchy check script to be used by yosys"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${LateLibraryPath}"
set filename "$DesignName.hier.ys"
set fileId [open $OutputDirectory/$filename "w"]
puts -nonewline $fileId $data
set netlist [glob -dir $NetlistDirectory *.v]
foreach f $netlist {
puts -nonewline $fileId "\nread_verilog $f"
}
puts -nonewline $fileId "\nhierarchy -check"
close $fileId

#Error handling for hierarchy check
set error_flag [catch {exec yosys -s $OutputDirectory/$DesignName.hier.ys >& $OutputDirectory/$DesignName.hierarchy_check.log} msg]
if {$error_flag} {
	set filename "$OutputDirectory/$DesignName.hierarchy_check.log"
	set pattern {referenced in module}
	set count 0
	set fid [open $filename r]
	while { [gets $fid line ] != -1} {
		incr count [regexp -all -- $pattern $line]
		if { [regexp -all -- $pattern $line] } {
			puts "\nError: Module [lindex $line 2] is not a part of the $DesignName. Please correct RTL in the path '$NetlistDirectory'"
			puts "\nInfo: Hierarchy check result: FAIL"
		}
	}
	close $fid
	exit
} else {
	puts "\nInfo: Hierarchy check result: PASS"
}
puts "\nInfo: Please check file hierarchy details in '[file normalize $OutputDirectory/$DesignName.hierarchy_check.log]'"

#Main Synthesis Script
puts "\nInfo: Creating main synthesis script to be used by yosys"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${LateLibraryPath}"
set filename "$DesignName.ys"
set fileId [open $OutputDirectory/$filename "w"]
puts -nonewline $fileId $data
set netlist [glob -dir $NetlistDirectory *.v]
foreach f $netlist {
	puts -nonewline $fileId "\nread_verilog $f"
}
puts -nonewline $fileId "\nhierarchy -top $DesignName"
puts -nonewline $fileId "\nsynth -top $DesignName"
puts -nonewline $fileId "\nsplitnets -ports -format ___\ndfflibmap -liberty ${LateLibraryPath} \nopt"
puts -nonewline $fileId "\nabc -liberty ${LateLibraryPath}"
puts -nonewline $fileId "\nflatten"
puts -nonewline $fileId "\nclean -purge\niopadmap -outpad BUFX2 A:Y -bits\nopt\nclean"
puts -nonewline $fileId "\nwrite_verilog $OutputDirectory/$DesignName.synth.v"
close $fileId
puts "\nInfo: Synthesis Script created and can be accessed from path $OutputDirectory/$DesignName.ys"

#Running main synthesis in yosys
puts "\nInfo: Running Synthesis....."
if [catch {exec yosys -s $OutputDirectory/$DesignName.ys >& $OutputDirectory/$DesignName.synthesis.log} msg] {
	puts "\nError: Synthesis failed due to errors"
	exit
} else {
	puts "\nInfo: Synthesis finished Successfully."
}
puts "\nInfo: Please refer to log at $OutputDirectory/$DesignName.synthesis.log"

#Editing synth.v file for OpenTimer
set fileId [open /tmp/1 "w"]
puts -nonewline $fileId [exec grep -v -w "*" $OutputDirectory/$DesignName.synth.v]
close $fileId
set output [open $OutputDirectory/$DesignName.final.synth.v "w"]
set filename "/tmp/1"
set fid [open $filename r]
while { [gets $fid line] != -1} {
	puts -nonewline $output [string map {"\\" ""} $line]
	puts -nonewline $output "\n"
}
close $fid
close $output

puts "\nInfo: Find the synthesized final netlist for the design $DesignName at path mentioned below (USEFUL FOR STA and PNR)"
puts "\n      $OutputDirectory/$DesignName.final.synth.v" 

#Static Timing Analysis
puts "\nInfo: Static Timing Analysis started"
puts "\nInfo: Initializing number of threads,libraries,sdc,verilog netlist path....."

source procs/reopenStdout.proc
source procs/set_num_threads.proc
source procs/read_verilog.proc
source procs/read_lib.proc
source procs/read_sdc.proc

reopenStdout $OutputDirectory/$DesignName.conf
set_multi_cpu_usage -localCpu 4
read_lib -early $EarlyLibraryPath
read_lib -late $LateLibraryPath
read_verilog $OutputDirectory/$DesignName.final.synth.v
read_sdc $OutputDirectory/$DesignName.sdc
reopenStdout /dev/tty

#Creating the .spef file
set enable_prelayout_timing 1
puts "\nInfo: Setting enable_prelayout_timing as $enable_prelayout_timing to write default .spef with zero-wire load parasitics since, actual .spef is not available. For user debug."
if {$enable_prelayout_timing == 1} {
	puts "\nInfo: enable_prelayout_timing is $enable_prelayout_timing. Enabling zero-wire load parasitics"
	set spef_file [open $OutputDirectory/$DesignName.spef w]
	puts $spef_file "*SPEF \"IEEE 1481-1998\" "
	puts $spef_file "*DESIGN \"$DesignName\" "
	puts $spef_file "*DATE \"[clock format [clock seconds] -format {%a %b %d %I:%M:%S %Y}]\" "
	puts $spef_file "*VENDOR \"TAU 2015 Contest\" "
	puts $spef_file "*PROGRAM \"Benchmark Parasitic Generator\" "
	puts $spef_file "*VERSION \"0.0\" "
	puts $spef_file "*DESIGN_FLOW \"NETLIST_TYPE_VERILOG\" "
	puts $spef_file "*DIVIDER / "
	puts $spef_file "*DELIMITER : "
	puts $spef_file "*BUS_DELIMITER \[ \] "
	puts $spef_file "*T_UNIT 1 PS "
	puts $spef_file "*C_UNIT 1 FF "
	puts $spef_file "*R_UNIT 1 KOHM "
	puts $spef_file "*L_UNIT 1 UH "
	close $spef_file
}

# Appending to .conf file
puts "Info: Appending rest of the required commands to .conf file. For user debug."
set conf_file [open $OutputDirectory/$DesignName.conf a]
puts $conf_file "set_spef_fpath $OutputDirectory/$DesignName.spef"
puts $conf_file "init_timer "
puts $conf_file "report_timer "
puts $conf_file "report_wns "
puts $conf_file "report_worst_paths -numPaths 10000 "
close $conf_file
puts "      Entering STA analysis using OpenTimer"

#Running STA on OpenTimer dumping log to .results file
set tcl_precision 3
set time_elapsed_in_us [time {exec /home/vsduser/OpenTimer-1.0.5/bin/OpenTimer < $OutputDirectory/$DesignName.conf >& $OutputDirectory/$DesignName.results}]
set time_elapsed_in_sec "[expr {[lindex $time_elapsed_in_us 0]/1000000.0}]sec"
puts "\nInfo: STA finished in $time_elapsed_in_sec seconds"
puts "\nInfo: For Warnings and Errors, refer to $OutputDirectory/$DesignName.results "


#Finding worst output violation(RAT)
set worst_RAT_slack "-"
set report_file [open $OutputDirectory/$DesignName.results r]
set pattern {RAT}
while { [gets $report_file line] != -1} {
	if {[regexp $pattern $line]} {
		set worst_RAT_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file
puts "Worst RAT Slack = $worst_RAT_slack"

#Finding number of output violations
set report_file [open $OutputDirectory/$DesignName.results r]
set count 0
while { [gets $report_file line] != -1} {
	incr count [regexp -all -- $pattern $line]
}
set num_output_violations $count
close $report_file
puts "Number of Output Violations = $num_output_violations"

#Finding worst setup violation
set worst_negative_setup_slack "-"
set report_file [open $OutputDirectory/$DesignName.results r]
set pattern {Setup}
while { [gets $report_file line]!= -1} {
	if {[regexp $pattern $line]} {
		set worst_negative_setup_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file
puts "Worst Negative Setup Slack = $worst_negative_setup_slack"

#Finding number of Setup violations
set report_file [open $OutputDirectory/$DesignName.results r]
set count 0
while { [gets $report_file line]  != -1} {
	incr count [regexp -all -- $pattern $line]
}
set number_of_setup_violations $count
close $report_file
puts "Number of Setup Vioations = $number_of_setup_violations"

#Finding worst Hold violations
set worst_negative_Hold_slack "-"
set report_file [open $OutputDirectory/$DesignName.results r]
set pattern {Hold}
while { [gets $report_file line] != -1} {
	if {[regexp $pattern $line]} {
		set worst_negative_Hold_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file
puts "Worst Negative Hold Slack = $worst_negative_Hold_slack"

#Finding number of Hold violations
set report_file [open $OutputDirectory/$DesignName.results r]
set count 0
while { [gets $report_file line] != -1} {
	incr count [regexp -all -- $pattern $line]
}
set number_of_Hold_violations $count
close $report_file 
puts "Number of Hold Violations = $number_of_Hold_violations"

#Finding number of instances
set pattern {Num of gates}
set report_file [open $OutputDirectory/$DesignName.results r]
while { [gets $report_file line] != -1} {
	if {[regexp -all -- $pattern $line]} {
		set instance_count [lindex [join $line " "] 4 ]
		puts "$instance_count"
		break
	} else {
		continue
	}
}
close $report_file
puts "Instance count = $instance_count"

# Quality of Results (QoR) generation
puts "\n"
puts "                                                           ****PRELAYOUT TIMING RESULTS****\n"
set formatStr {%15s%14s%21s%16s%16s%15s%15s%15s%15s}
puts [format $formatStr "-----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
puts [format $formatStr "Design Name" "Runtime" "Instance Count" "WNS Setup" "FEP Setup" "WNS Hold" "FEP Hold" "WNS RAT" "FEP RAT"]
puts [format $formatStr "-----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
foreach design_name $DesignName runtime $time_elapsed_in_sec instance_count $instance_count wns_setup $worst_negative_setup_slack fep_setup $number_of_setup_violations wns_hold $worst_negative_Hold_slack fep_hold $number_of_Hold_violations wns_rat $worst_RAT_slack fep_rat $num_output_violations {
	puts [format $formatStr $design_name $runtime $instance_count $wns_setup $fep_setup $wns_hold $fep_hold $wns_rat $fep_rat]
}
puts [format $formatStr "-----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
puts "\n"
