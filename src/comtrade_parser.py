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
    base = Path("01-data") / "atpiec" / "comtrade"
    file = base / "HR_10022"

    mala_channels = ("I_2_1_0", "I_2_2_0", "I_2_3_0", "V_2_1_0", "V_2_2_0", "V_2_3_0")
    ied_channels = ("IAW", "IBW", "ICW", "VAY", "VBY", "VCY")
    logger.info("Reading %s COMTRADE", file.name)
    cfg = Configuration.load(file.with_suffix(".CFG"))
    dat = Data.load(file.with_suffix(".DAT"), cfg)

    analog_channel_names = mala_channels if file.name == "mala" else ied_channels

    with (base / file.name).with_suffix(".csv").open("w") as csv:
        csv.write("T (us), IAW, IBW, ICW, VAY, VBY, VCY\n")  # T in us, Current in A, Voltage in V
        logger.info(
            "%s [%d Hz], original timestamp in microseconds? %s",
            file.name,
            cfg.frequency,
            cfg.in_microseconds,
        )
        logger.info(
            "COMTRADE has %.2f ms of samples",
            cfg.last_sample / cfg._sample_rate * 1_000,
        )
        logger.info(
            "Trip triggered after %.2f ms",
            (cfg.trigger_datetime - cfg.start_datetime).microseconds / 1_000,
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
