venv := .venv
bin := $(venv)/bin

.PHONY: i install
i: install
install:
	@ echo "\n>> Installing python dependencies..."
	uv venv $(venv)
	uv pip install -e .[dev]

	@ echo "\n>> Installing R dependencies..."
	Rscript -e 'install.packages(c("ggplot2", "tidyr"))'

.PHONY: p preprocess
p: preprocess
preprocess:
	@ echo "\n>> Parsing .pl4 files..."
	$(bin)/python src/pl4_parser.py

	@ echo "\n>> Parsing .pcap files..."
	$(bin)/python src/pcap_parser.py

	@ echo "\n>> Parsing COMTRADE files..."
	$(bin)/python src/comtrade_parser.py

.PHONY: r run
r: run
run:
	@ echo "\n>> Plotting ATP files..."
	Rscript 02-scripts/01-atpiec/01-atp.R 

	@ echo "\n>> Plotting PCAP files..."
	Rscript 02-scripts/01-atpiec/02-pcap.R

	@ echo "\n>> Plotting COMTRADE files..."
	Rscript 02-scripts/01-atpiec/03-comtrade.R
