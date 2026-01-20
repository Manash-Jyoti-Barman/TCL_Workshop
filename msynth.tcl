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
puts "\nInfo-SDC: Working on clock constraints....."
while { $i < $end_of_clock } {
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
puts "\nInfo: Working on input constraints"
puts "\nInfo: Categorizing the input ports as bits and busses"
#Input_transition constraints
while { $i < $end_of_inputs } {
	set netlist [glob -dir $NetlistDirectory *.v]
	set tmp_file [open /tmp/1 w]
	foreach f $netlist {
		set fd [open $f]
		puts "reading file $f"
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
		set inp_ports [concat [constraints get cell 0 $i]*]

	} else {
		set inp_ports [constraints get cell 0 $i]
}

#Input_transition constraints
puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_slew_start $i] $inp_ports"
puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_slew_start $i] $inp_ports"
puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_slew_start $i] $inp_ports"
puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_slew_start $i] $inp_ports"

#Input_delay constraints
puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_delay_start $i] $inp_ports"
puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_delay_start $i] $inp_ports"
puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_delay_start $i] $inp_ports"
puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $input_related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_delay_start $i] $inp_ports"

set i [expr {$i+1}]
}

return
