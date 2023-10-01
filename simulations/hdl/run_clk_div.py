from vunit.verilog import VUnit

vu = VUnit.from_argv()

vu.add_verilog_builtins()

clk_div = vu.add_library("clk_div")
clk_div.add_source_files("*clk_div.sv")

tb = clk_div.test_bench("tb_clk_div")

# parameterize
dividers = [100]
for param in dividers:
  tb.add_config(
    name="divide_100MHz_by_%s" % (param),
    generics=dict(div_constant=param))

vu.main()