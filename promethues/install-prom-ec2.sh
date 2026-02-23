#!/bin/bash

# --- Configuration ---
PROM_VERSION="2.45.0"
USER="prometheus"
DIR_BASE="/etc/prometheus"
DIR_DATA="/var/lib/prometheus"

echo "Starting Prometheus Installation..."

# 1. Create System User
# Using -r for system account and -s /sbin/nologin for security
if ! id "$USER" &>/dev/null; then
    sudo useradd --no-create-home --shell /bin/false $USER
fi

# 2. Create Directories
sudo mkdir -p $DIR_BASE $DIR_DATA
sudo chown $USER:$USER $DIR_BASE $DIR_DATA

# 3. Download and Extract Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# 4. Copy Binaries and Set Permissions
sudo cp prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo chown $USER:$USER /usr/local/bin/prometheus /usr/local/bin/promtool

# 5. Copy Console Libraries and Configuration
sudo cp -r prometheus-${PROM_VERSION}.linux-amd64/consoles $DIR_BASE
sudo cp -r prometheus-${PROM_VERSION}.linux-amd64/console_libraries $DIR_BASE
sudo cp prometheus-${PROM_VERSION}.linux-amd64/prometheus.yml $DIR_BASE/prometheus.yml
sudo chown -R $USER:$USER $DIR_BASE

# 6. Create Systemd Unit File
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file=$DIR_BASE/prometheus.yml \\
    --storage.tsdb.path=$DIR_DATA \\
    --web.console.templates=$DIR_BASE/consoles \\
    --web.console.libraries=$DIR_BASE/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# 7. Reload systemd, Start and Enable Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

echo "Prometheus is installed and running on port 9090."