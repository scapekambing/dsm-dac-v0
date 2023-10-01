from vunit.verilog import VUnit

vu = VUnit.from_argv()

vu.add_verilog_builtins()

sin_gen = vu.add_library("sin_gen")
sin_gen.add_source_files("*sin_gen.sv")

tb = sin_gen.test_bench("tb_sin_gen")

vu.main()