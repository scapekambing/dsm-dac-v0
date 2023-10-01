from vunit.verilog import VUnit

vu = VUnit.from_argv()

vu.add_verilog_builtins()

dsm_dac = vu.add_library("dsm_dac")
dsm_dac.add_source_files("*dsm_dac.sv")
dsm_dac.add_source_files("sin_gen.sv")
dsm_dac.add_source_files("clk_div.sv")

# tb = dsm_dac.test_bench("tb_dsm_dac")

vu.main()