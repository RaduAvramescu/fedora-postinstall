# Create GoXLR Utility distrobox
distrobox-assemble create --file ./distrobox/goxlr-utility/distrobox.ini

# Copy GoXLR Utility service
sudo cp ./systemd/goxlr-utility.service /etc/systemd/user/goxlr-utility.service

# Enable service immediately
systemctl enable --user --now goxlr-utility.service
