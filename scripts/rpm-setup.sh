function prompt_rpm_setup() {
    read -p "Do you want to install rpms? (y/N) " answer

    case $answer in 
        y ) install_rpms;;
        N ) ;;
        * ) ;;
    esac
}

function install_rpms() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing rpms
-------------------------------------------------------------------------
"

    cat "../data/rpms.txt" | while read line
    do
        sudo dnf install -y "${line}"
    done

    # Install obs-vkcapture from copr repo
    sudo dnf copr enable kylegospo/obs-vkcapture
    sudo dnf install -y obs-vkcapture.x86_64 obs-vkcapture.i686
}

prompt_rpm_setup
