# Copy GPU profile script
sudo mkdir -p /root/.local/bin
sudo cp ./gpu-profile.sh /root/.local/bin/gpu-profile.sh
sudo chmod +x /root/.local/bin/gpu-profile.sh

# Copy GPU profile service
sudo cp ./gpu-profile.service /etc/systemd/system/gpu-profile.service

# Enable GPU profile script immediately
systemctl enable --now gpu-profile.service
