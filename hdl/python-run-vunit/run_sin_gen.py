from pathlib import Path
from vunit.verilog import VUnit
import numpy as np

TB_PATH = Path(__file__).parent / "../tb"

vu = VUnit.from_argv()
vu.add_verilog_builtins()

sin_gen = vu.add_library("sin_gen")
sin_gen.add_source_files(TB_PATH / "*sin_gen.sv")

tb = sin_gen.test_bench("tb_sin_gen")

# parameterize
dividers = np.array([1, 4, 10])
n_pts = 50
freq = 100/dividers/n_pts #Mhz
i = 0
for i in range(len(freq)):
  tb.add_config(
    name="sin_%sMHz" % (freq[i]),
    generics=dict(div_const=dividers[i])
  )

vu.main()