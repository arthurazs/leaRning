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
mala = mala_base / "mala"
sgc_base = base / "sgc"
sgc_pub = sgc_base / "pub"
sgc_sub = sgc_base / "sub"

# mala
cfg = Configuration.load(mala.with_suffix(".CFG"))
dat = Data.load(mala.with_suffix(".DAT"), cfg)

for name, channel in cfg.analogs.items():
    logger.info("%s: %s [%s]", name, channel.unit, channel._phase)

# logger.info(cfg.analogs)
# logger.info(cfg.analogs_order)
# for analog in dat.get_analogs(("IAW", "IBW", "ICW", "VAY", "VBY", "VCY")):
#     logger.info(analog)
