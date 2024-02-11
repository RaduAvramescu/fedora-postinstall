function add_flathub_repo() {
    echo -ne "
-------------------------------------------------------------------------
                    Adding Flathub repo
-------------------------------------------------------------------------
"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-modify --enable flathub
    flatpak update -y
}

function install_flatpaks() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing $1 flatpaks
-------------------------------------------------------------------------
"

    cat "$2" | while read line
    do
        if flatpak list | grep -q "${line}"; then
            echo "${line} is already installed"
        else
            flatpak install flathub -y --noninteractive "${line}"
        fi
    done
}

function handle_gaming_flatpaks() {
    read -p "Do you want to install gaming flatpaks? (y/N) " answer

    case $answer in 
        y ) install_flatpaks "gaming" "gaming-flatpaks.txt";;
        N ) ;;
        * ) ;;
    esac
}

add_flathub_repo
install_flatpaks "generic" "generic-flatpaks.txt"
handle_gaming_flatpaks