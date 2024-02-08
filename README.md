# leaRning

R Learning following [R for Data Science (2e)](https://r4ds.hadley.nz/).

### Built with

- R
- RStudio
- tidyverse

## Quickstart

```bash
# Installing R
apt update
apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
apt install --no-install-recommends r-base

# Setting R libs location
echo 'export R_LIBS="$HOME/.local/lib/R"' >> ~/.bashrc
. ~/.bashrc
mkdir $R_LIBS

# Installing dependencies
Rscript -e 'install.packages(c("ggplot2", "tidyr"))'
Rscript 02-scripts/97-atpiec_atp.R
```
