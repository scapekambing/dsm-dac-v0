from pathlib import Path
from vunit.verilog import VUnit
import numpy as np

TB_PATH = Path(__file__).parent / "../tb"

vu = VUnit.from_argv()
vu.add_verilog_builtins()

cic = vu.add_library("cic")
cic.add_source_files(TB_PATH / "*sin_gen_cic.sv")

tb = cic.test_bench("tb_sin_gen_cic")

vu.main()