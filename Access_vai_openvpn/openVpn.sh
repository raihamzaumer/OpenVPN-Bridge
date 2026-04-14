#!/bin/bash
set -e

# 1. Non-interactive mode
export DEBIAN_FRONTEND=noninteractive
exec > /var/log/user-data.log 2>&1

# 2. Update and Install
apt-get update -y
apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y
apt-get install -y curl wget gnupg lsb-release apt-transport-https ca-certificates

# 3. Add OpenVPN repo
mkdir -p /etc/apt/keyrings
curl -fsSL https://as-repository.openvpn.net/as-repo-public.gpg | gpg --dearmor -o /etc/apt/keyrings/openvpn-as.gpg

echo "deb [signed-by=/etc/apt/keyrings/openvpn-as.gpg] http://as-repository.openvpn.net/as/debian $(lsb_release -cs) main" \
> /etc/apt/sources.list.d/openvpn-as.list

apt-get update -y
apt-get install -y openvpn-as

# 4. Wait for service startup
sleep 30

# 5. Get Public IP
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
-s http://169.254.169.254/latest/meta-data/public-ipv4)

# 6. FORCE stable configuration
/usr/local/openvpn_as/scripts/sacli --key "host.name" --value "$PUBLIC_IP" ConfigPut
/usr/local/openvpn_as/scripts/sacli --key "cs.host" --value "$PUBLIC_IP" ConfigPut
/usr/local/openvpn_as/scripts/sacli --key "vpn.client.config.external_addresses.0" --value "$PUBLIC_IP" ConfigPut

# :fire: FORCE FIX PORTS (remove 914–917 issue)
/usr/local/openvpn_as/scripts/sacli --key "vpn.tcp.port" --value "443" ConfigPut
/usr/local/openvpn_as/scripts/sacli --key "vpn.udp.port" --value "1194" ConfigPut
/usr/local/openvpn_as/scripts/sacli --key "cs.tcp_port" --value "943" ConfigPut
/usr/local/openvpn_as/scripts/sacli --key "admin_ui.https.port" --value "943" ConfigPut

# 7. Routing
/usr/local/openvpn_as/scripts/sacli --key "vpn.server.routing.private_network.0" --value "10.0.0.0/16" ConfigPut

# 8. USERNAME + PASSWORD (FIXED)
/usr/local/openvpn_as/scripts/sacli --user openvpn --new_pass 'AerodynePasswd2024' SetLocalPassword

# 9. FINAL STABLE RESTART
systemctl restart openvpnas
sleep 10

echo "OpenVPN READY - Public IP: $PUBLIC_IP"