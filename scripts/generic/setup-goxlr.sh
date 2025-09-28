# Copy GoXLR Utility service
sudo cp ./systemd/goxlr-utility.service /etc/systemd/user/goxlr-utility.service

# Enable service immediately
systemctl enable --user --now goxlr-utility.service
