from scapy.all import PcapReader
from pathlib import Path

path = Path("01-data") / "sv.pcap"

with PcapReader(str(path)) as pcap:
    for packet in pcap:
        if packet.type != 0x88BA:  # SV
            continue
        header = packet.raw_packet_cache
        payload = bytes(packet.payload)

        break
        print(packet.direction, '\n---')
        print(packet.display, '\n---')
        print(packet.dissect, '\n---')
        print(packet.do_dissect, '\n---')
        print(packet.do_dissect_payload, '\n---')
        print(packet.dst, '\n---')
        print(packet.fields, '\n---')
        print(packet.fields_desc, '\n---')
        print(packet.fieldtype, '\n---')
        print(packet.firstlayer, '\n---')
        print(packet.fragment, '\n---')
        print(packet.lastlayer, '\n---')
        print(packet.layers, '\n---')
        print(packet.name, '\n---')
        print(packet.original, '\n---')
        print(packet.parent, '\n---')
        print(packet.sprintf, '\n---')
        print(packet.src, '\n---')
        print(packet.summary, '\n---')
        print(packet.time, '\n---')
        print(packet.type, '\n---')
        print(packet.wirelen, '\n---')
        break