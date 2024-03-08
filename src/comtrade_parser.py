import decimal as dec
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


def multiply_voltage(unit) -> dec.Decimal:
    match unit:
        case "V":
            return dec.Decimal(1)
        case "kV":
            return dec.Decimal(1_000)
        case _:
            msg = "Expected V or kV unit"
            raise NotImplementedError(msg)


def assert_current(unit: str) -> None:
    if unit != "A":
        msg = "Expected A unit"
        raise ValueError(msg)

def main() -> None:
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

        with (csv_path / (file.name + "_comtrade")).with_suffix(".csv").open("w") as csv:
            csv.write("T (us), IAW, IBW, ICW, VAY, VBY, VCY\n")  # T in ms, Current in A, Voltage in V
            logger.info(
                "%s [%d Hz], original timestamp in microseconds? %s",
                file.name,
                cfg.frequency,
                cfg.in_microseconds,
            )

            units = []
            for channel in analog_channel_names:
                analog_channel = cfg.analogs[channel]
                is_primary = analog_channel.is_primary
                unit = analog_channel.unit
                primary = analog_channel.primary
                secondary = analog_channel.secondary
                logger.info(
                    " > %s: %s in %s [%d | %d]",
                    channel,
                    "Primary" if is_primary else "Secondary",
                    unit,
                    primary,
                    secondary,
                )
                units.append(unit)

            logger.info("Saving to csv...\n")
            for timestamp, ia, ib, ic, va, vb, vc in dat.get_analogs(analog_channel_names):
                for unit in units[:3]:
                    assert_current(unit)
                va *= multiply_voltage(units[3])
                vb *= multiply_voltage(units[4])
                vc *= multiply_voltage(units[5])
                timestamp *= 1 if cfg.in_microseconds else 1_000
                csv.write(f"{timestamp}, {ia}, {ib}, {ic}, {va}, {vb}, {vc}\n")


if __name__ == "__main__":
    main()
