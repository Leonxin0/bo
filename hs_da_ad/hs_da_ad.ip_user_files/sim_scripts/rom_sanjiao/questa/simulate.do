onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rom_sanjiao_opt

do {wave.do}

view wave
view structure
view signals

do {rom_sanjiao.udo}

run -all

quit -force
