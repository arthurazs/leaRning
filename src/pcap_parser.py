import logging

from scapy.all import PcapReader
from pathlib import Path
from pysv.sv import unpack_sv
from statistics import mean

logging.basicConfig(
    format="[%(levelname)7s] %(asctime)s | "
           "%(name)11s:%(lineno)4d > %(message)s",
    level=logging.INFO
)
logger = logging.getLogger("pcap_parser")

base = Path("01-data")
pcap_path = base / "sv.pcap"
csv_path = base / "pcap.csv"

with PcapReader(str(pcap_path)) as pcap, csv_path.open("w", encoding="utf8") as csv:
    baseline = None
    previous = 0
    deltas = []

    csv.write("T (us), IAW, IBW, ICW, VAY, VBY, VCY\n")
    logger.info("Reading frames...")
    for packet in pcap:
        if packet.type != 0x88BA:  # SV
            continue

        packet_time = packet.time * 1e6
        
        if baseline is None:
            baseline = packet_time
        
        timestamp = packet_time - baseline
        sv = unpack_sv(bytes(packet))

        csv.write(f"{timestamp:.2f}, {sv.i_a}, {sv.i_b}, {sv.i_c}, {sv.v_a}, {sv.v_b}, {sv.v_c}\n")

        deltas.append(timestamp - previous)
        previous = timestamp
    logger.info("Done reading!")
    logger.info("Calculating min/mean/max (us)...")
    logger.info("%.3f/%.3f/%.3f", min(deltas), mean(deltas), max(deltas))

