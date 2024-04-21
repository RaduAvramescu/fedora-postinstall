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
}

prompt_rpm_setup
