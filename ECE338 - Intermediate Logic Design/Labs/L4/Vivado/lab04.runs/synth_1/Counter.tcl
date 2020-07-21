# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {/media/psf/Home/OneDrive/OneDrive - University of New Mexico/FALL2019/ECE338/lab04/lab04.cache/wt} [current_project]
set_property parent.project_path {/media/psf/Home/OneDrive/OneDrive - University of New Mexico/FALL2019/ECE338/lab04/lab04.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:zybo-z7-10:part0:1.0 [current_project]
set_property ip_output_repo {/media/psf/Home/OneDrive/OneDrive - University of New Mexico/FALL2019/ECE338/lab04/lab04.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {{/media/psf/Home/OneDrive/OneDrive - University of New Mexico/FALL2019/ECE338/lab04/lab04.srcs/sources_1/imports/Lab04/behavioral.vhd}}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{/media/psf/Home/OneDrive/OneDrive - University of New Mexico/FALL2019/ECE338/lab04/lab04.srcs/constrs_1/imports/Lab04/ZYBO_Z7-10_master.xdc}}
set_property used_in_implementation false [get_files {{/media/psf/Home/OneDrive/OneDrive - University of New Mexico/FALL2019/ECE338/lab04/lab04.srcs/constrs_1/imports/Lab04/ZYBO_Z7-10_master.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top Counter -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Counter.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Counter_utilization_synth.rpt -pb Counter_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
