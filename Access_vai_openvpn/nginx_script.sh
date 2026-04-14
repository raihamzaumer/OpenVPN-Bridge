#!/bin/bash

# Update packages
apt update -y

# Install nginx
apt install nginx -y

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Add custom page
echo '<html><body style="background-color:#111; color:#fff; text-align:center; padding:20px;">
<h1><b>Hello from Private EC2 via Proxy | Configured By: Hamza Umer!</b></h1>
</body></html>' > /var/www/html/index.html