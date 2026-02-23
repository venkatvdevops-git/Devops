#!/bin/bash

# --- Configuration ---
NODE_EXPORTER_VERSION="1.6.1"
USER="node_exporter"

echo "Starting Node Exporter Installation..."

# 1. Create System User
if ! id "$USER" &>/dev/null; then
    sudo useradd --no-create-home --shell /bin/false $USER
fi

# 2. Download and Extract
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# 3. Copy Binary
sudo cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo chown $USER:$USER /usr/local/bin/node_exporter

# 4. Create Systemd Service
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# 5. Start and Enable
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo "Node Exporter is running on port 9100."