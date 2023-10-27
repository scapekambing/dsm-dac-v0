from pathlib import Path
from vunit.verilog import VUnit
import numpy as np

TB_PATH = Path(__file__).parent / "../tb"

vu = VUnit.from_argv()
vu.add_verilog_builtins()

sin_gen = vu.add_library("sin_gen")
sin_gen.add_source_files(TB_PATH / "*axis_sin_gen.sv")

tb = sin_gen.test_bench("tb_sin_gen")

vu.main()