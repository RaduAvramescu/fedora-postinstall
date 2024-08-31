# Copy GPU profile script
sudo mkdir -p /usr/local/bin
sudo cp ./gpu-profile.sh /usr/local/bin/gpu-profile.sh
sudo chmod +x /usr/local/bin/gpu-profile.sh

# Copy GPU profile service
sudo cp ./gpu-profile.service /etc/systemd/system/gpu-profile.service

# Enable GPU profile script immediately
systemctl enable --now gpu-profile.service

# Fix SELinux label of script file
if [ $(which restorecon) ]; then
    sudo restorecon -RFv /usr/local/bin/
fi
