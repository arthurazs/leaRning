import decimal as dec
import logging
from pathlib import Path
from statistics import mean

from pysv.sv import unpack_sv
from scapy.all import PcapReader

logging.basicConfig(
    format="[%(levelname)7s] %(asctime)s | "
           "%(name)11s:%(lineno)4d > %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger("pcap_parser")


def main() -> None:
    base = Path("01-data") / "atpiec" / "pcap"
    file = base / "svMeuFullLoad"

    pcap_file = file.with_suffix(".pcapng")
    if not pcap_file.is_file():
        pcap_file = file.with_suffix(".pcap")
    csv_file = (base / file.name).with_suffix(".csv")
    logger.info("Reading %s pcap...", file.name)
    with PcapReader(str(pcap_file)) as pcap, csv_file.open("w", encoding="utf8") as csv:
        baseline = None
        previous = 0
        deltas = []

        csv.write("T (us), IAW, IBW, ICW, VAY, VBY, VCY\n")
        logger.info("Parsing frames...")
        for packet in pcap:
            if packet.type == 0x8100:  # VLAN
                eth_type = packet.payload.type
                packet.payload = packet.payload.payload
                packet.type = eth_type

            if packet.type != 0x88BA:  # SV
                continue

            packet_time = packet.time * dec.Decimal(1e6)

            if baseline is None:
                baseline = packet_time

            timestamp = packet_time - baseline
            sv = unpack_sv(bytes(packet))

            # razao LE  # TODO @arthurazs: implementar direto no pysv
            ia = sv.i_a / 1_000
            ib = sv.i_b / 1_000
            ic = sv.i_c / 1_000
            va = sv.v_a / 100
            vb = sv.v_b / 100
            vc = sv.v_c / 100

            # passando valores do primario para secundario
            output_in_secondary = False
            if output_in_secondary:
                ia /= 300
                ib /= 300
                ic /= 300
                va /= 4347.8
                vb /= 4347.8
                vc /= 4347.8

            csv.write(f"{timestamp}, {ia}, {ib}, {ic}, {va}, {vb}, {vc}\n")

            deltas.append(timestamp - previous)
            previous = timestamp
        logger.info("Calculating min/mean/max (us)...")
        logger.info("%.3f/%.3f/%.3f\n", min(deltas), mean(deltas), max(deltas))


if __name__ == "__main__":
    main()
