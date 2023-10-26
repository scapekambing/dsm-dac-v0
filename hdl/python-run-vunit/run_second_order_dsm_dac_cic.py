from pathlib import Path
from vunit.verilog import VUnit
import numpy as np

TB_PATH = Path(__file__).parent / "../tb"

vu = VUnit.from_argv()
vu.add_verilog_builtins()

dsm = vu.add_library("cic")
dsm.add_source_files(TB_PATH / "*second_order_dsm_dac_cic.sv")

tb = dsm.test_bench("tb_second_order_dsm_dac_cic")

vu.main()