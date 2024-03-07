import logging
from pathlib import Path

from pytrade.configuration import Configuration
from pytrade.data import Data

logging.basicConfig(
    format="[%(levelname)7s] %(asctime)s | "
           "%(name)11s:%(lineno)4d > %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger("pcap_parser")

base = Path("01-data") / "atpiec"

mala_base = base / "mala"
sgc_base = base / "sgc"

mala = mala_base / "mala"
sgc_pub = sgc_base / "pub"
sgc_sub = sgc_base / "sub"

csv_path = base / "csv"
csv_path.mkdir(parents=True, exist_ok=True)

mala_channels = ("I_2_1_0", "I_2_2_0", "I_2_3_0", "V_2_1_0", "V_2_2_0", "V_2_3_0")
ied_channels = ("IAW", "IBW", "ICW", "VAY", "VBY", "VCY")

for file in (
    mala,
    sgc_pub,
    sgc_sub,
):
    logger.info("Reading %s COMTRADE", file.name)
    cfg = Configuration.load(file.with_suffix(".CFG"))
    dat = Data.load(file.with_suffix(".DAT"), cfg)

    analog_channel_names = mala_channels if file.name == "mala" else ied_channels

    with (csv_path / file.name).with_suffix(".csv").open("w") as csv:
        csv.write("T (us), IAW, IBW, ICW, VAY, VBY, VCY\n")

        logger.info("Saving to csv...\n")
        for timestamp, ia, ib, ic, va, vb, vc in dat.get_analogs(analog_channel_names):
            csv.write(f"{timestamp}, {ia}, {ib}, {ic}, {va}, {vb}, {vc}\n")
