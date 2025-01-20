from pathlib import Path

from atp import pl4parser

base_path = Path("01-data") / "atpiec" / "atp"
in_exp1 = base_path / "REGUAS_BJDLAPA.pl4"
in_exp2 = base_path / "REGUAS_BJDLAPA_2nd.pl4"

out_exp1 = base_path / "2024-05-07exp1.csv"
out_exp2 = base_path / "2024-05-07exp2.csv"

inputs_outputs = (
    (in_exp1, out_exp1),
    (in_exp2, out_exp2),
)

for in_path, out_path in inputs_outputs:
    pl4parser.parse_file(in_path, out_path)
