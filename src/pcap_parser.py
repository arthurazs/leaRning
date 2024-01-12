from scapy.all import PcapReader
from pathlib import Path
from pysv.sv import unpack_sv
from statistics import mean

path = Path("01-data") / "sv.pcap"

with PcapReader(str(path)) as pcap:
    baseline = None
    previous = 0
    deltas = []
    for packet in pcap:
        if packet.type != 0x88BA:  # SV
            continue
        
        if baseline is None:
            baseline = packet.time
        
        timestamp = packet.time - baseline
        sv = unpack_sv(bytes(packet))
        # print(timestamp - previous, timestamp, sv)
        deltas.append(timestamp - previous)
        previous = timestamp
    print(min(deltas) * 1e6, mean(deltas) * 1e6, max(deltas) * 1e6)

