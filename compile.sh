#!/bin/bash -x
#echo "set_param synth.elaboration.rodinMoreOptions \"rt::set_parameter synRetiming true\"" >> system.tcl

VERILOG_FILE=$1
CONSTRAINT_FILE=$2
BUILDDIR_INPUT=$3
#OUTFILE=$4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VERILOG_BUILD_COPY=$(basename $VERILOG_FILE)
CONSTRAINT_BUILD_COPY=$(basename $CONSTRAINT_FILE)
CURRENT_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
 
BUILDDIR=$BUILDDIR_INPUT.$CURRENT_TIME

mkdir -p $BUILDDIR
cp $VERILOG_FILE $BUILDDIR
cp $CONSTRAINT_FILE $BUILDDIR
cd $BUILDDIR
echo "read_verilog $VERILOG_BUILD_COPY" > system.tcl
echo "set_param synth.elaboration.rodinMoreOptions \"rt::set_parameter synRetiming true\"" >> system.tcl
echo "synth_design -top top -part xc7z020clg484-1 -mode out_of_context" >> system.tcl
echo "read_xdc $CONSTRAINT_BUILD_COPY" >> system.tcl
echo "set_property SEVERITY {Warning} [get_drc_checks UCIO-1]" >> system.tcl
echo "set_property SEVERITY {Warning} [get_drc_checks NSTD-1]" >> system.tcl
echo "opt_design" >> system.tcl
echo "place_design" >> system.tcl
echo "phys_opt_design" >> system.tcl
echo "route_design" >> system.tcl
echo "write_checkpoint final.dcp" >> system.tcl
echo "write_bitstream system.bit" >> system.tcl
echo "report_timing" >> system.tcl
echo "report_timing_summary" >> system.tcl
echo "report_utilization -hierarchical -file utilization_h.txt" >> system.tcl
echo "report_utilization -file utilization.txt" >> system.tcl
vivado -mode batch -source 'system.tcl' -nojournal -log 'vivado.log' > /dev/null
#bootgen -image $DIR/../axi/boot.bif -arch zynqmp -process_bitstream bin

#cp system.bit.bin $OUTFILE
                                          
