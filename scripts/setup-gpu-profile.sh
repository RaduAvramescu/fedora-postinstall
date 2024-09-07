SCRIPT_NAME="gpu-profile"
SCRIPT_DIR="/usr/local/bin"
SERVICE_DIR="/etc/systemd/system"

# Copy GPU profile script
sudo mkdir -p "$SCRIPT_DIR"
sudo cp "./$SCRIPT_NAME.sh" "$SCRIPT_DIR/$SCRIPT_NAME.sh"
sudo chmod +x "$SCRIPT_DIR/$SCRIPT_NAME.sh"

# Copy GPU profile service
sudo cp "./$SCRIPT_NAME.service" "$SERVICE_DIR/$SCRIPT_NAME.service"

# Enable GPU profile script immediately
systemctl enable --now "$SCRIPT_NAME.service"

# Fix SELinux label of script file
if [ $(which semanage) ] && [ $(which restorecon) ]; then
    if ! [[ -z $(sudo semanage fcontext --list | grep -i "$SCRIPT_DIR/$SCRIPT_NAME.sh") ]]; then
        sudo semanage fcontext -d "$SCRIPT_DIR/$SCRIPT_NAME.sh"
    fi
    sudo semanage fcontext -a -s system_u -t bin_t "$SCRIPT_DIR/$SCRIPT_NAME.sh"
    sudo restorecon -RFv "$SCRIPT_DIR/$SCRIPT_NAME.sh"
fi
