from pathlib import Path
from vunit.verilog import VUnit

TB_PATH = Path(__file__).parent / "../tb"

vu = VUnit.from_argv()
vu.add_verilog_builtins()

dsm_dac = vu.add_library("dsm_dac")
dsm_dac.add_source_files(TB_PATH / "*first_order_dsm_dac.sv")

vu.main()