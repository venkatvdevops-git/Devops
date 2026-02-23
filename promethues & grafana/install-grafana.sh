#!/bin/bash

# --- Configuration ---
# You can change this to "grafana" for the OSS version, 
# but "grafana-enterprise" is recommended for enterprise environments.
GRAFANA_PACKAGE="grafana-enterprise"

echo "Starting Grafana Installation..."

# 1. Create the Grafana Repository file
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

# 2. Update and Install
sudo yum update -y
sudo yum install -y $GRAFANA_PACKAGE

# 3. Reload systemd to recognize the new service
sudo systemctl daemon-reload

# 4. Start Grafana and enable it to start on boot
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# 5. Verify the service status
sudo systemctl is-active --quiet grafana-server && echo "Grafana is running successfully!"

echo "Grafana is accessible at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo "Default Credentials: admin / admin"