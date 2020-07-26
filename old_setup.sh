#!/usr/bin/env bash

# Before running this script:
# sudo chown -R hugo /usr/local

mode=$1
distro=$(lsb_release -cs)

if [[ $mode = "init" ]]; then
    # make in case they aren't already there
    mkdir -p "/usr/local/lib"
    mkdir -p "/usr/local/bin"

    # update the system
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y

    # reboot afterwards
elif [[ $mode = "install" ]]; then
    mkdir ~/tmp
    sudo apt-get update

    # install barebone software
    echo "Installing essentials"
    sudo apt-get install -y build-essential make git curl gparted preload openssh-server

    # generate ssh key
    echo "Generating ssh key..."
    ssh-keygen -t rsa -b 4096 -C "hmatalonga@gmail.com"

    # Some git defaults
    echo "Setting git defaults..."
    cp git/.* ~

    # Install nvm
    echo "Installing nvm..."
    mkdir -p /opt/nvm
    export NVM_DIR="/opt/nvm"
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    nvm install --lts

    curl -o- -L https://yarnpkg.com/install.sh | bash
    # Install Node modules
    modules=(
        np
        vtop
        surge
        vue-cli
    )

    # Install pip
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user

    echo "installing node modules..."
    yarn global add ${modules[@]}

    echo "Installing Ubuntu restricted extras..."
    sudo apt-get install -y ubuntu-restricted-extras

    echo "Install Java JDK? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo add-apt-repository -y ppa:webupd8team/java
        sudo apt-get update

        sudo apt-get install -y oracle-java8-installer
        sudo apt-get install -y oracle-java8-set-default
    fi

    echo "Install OCaml? (Y/n)"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
    fi

    echo "Install Software pack? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo apt-get update
        sudo apt-get install -y synaptic vlc deluge filezilla python-pygame keepassx unetbootin bleachbit
        # Utils
        sudo apt-get install -y p7zip-full p7zip-rar unrar-free
        # Conky
        sudo apt-get install conky lm-sensors hddtemp
    fi

    echo "Install Multimedia pack? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        # Multimedia software
        sudo apt-get install -y audacity blender gimp imagemagick cheese inkscape
    fi

    # Libreoffice
    echo "Install Libreoffice? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo add-apt-repository -y ppa:libreoffice/ppa
        sudo apt-get update
        sudo apt-get install -y libreoffice
    fi

    # Docker
    echo "Install Docker? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo apt-get remove docker docker-engine docker.io
        sudo apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $distro \
            stable"
        sudo apt-get update
        sudo apt-get install docker-ce
        sudo usermod -aG docker $USER
    fi

    # VirtualBox 5.1
    echo "Install VirtualBox? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        if [[ $distro = "xenial" ]]; then
            wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
        else
            wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
        fi
        sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian $distro contrib"
        sudo apt-get update
        sudo apt-get install -y dkms
        sudo apt-get install -y virtualbox-5.2
        sudo usermod -aG vboxusers $USER
    fi

    # Dropbox
    echo "Install Dropbox? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
        sudo add-apt-repository -y "deb http://linux.dropbox.com/ubuntu $distro main"
        sudo apt-get update
        sudo apt-get install -y dropbox
    fi

    # PHP --if
    echo "Install PHP and Composer? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo apt-get install -y php
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    fi

    # Dev tools --if
    echo "Install Development tools VSCode and Vagrant? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        if [[ ! -d "$~/tmp" ]]; then
            mkdir ~/tmp
        fi
        wget https://go.microsoft.com/fwlink/?LinkID=760868 -O ~/tmp/vscode.deb
        wget -P ~/tmp https://releases.hashicorp.com/vagrant/2.0.4/vagrant_2.0.4_x86_64.deb
        sudo dpkg -i ~/tmp/*.deb
    fi


    # PhpStorm --if
    echo "Download PhpStorm? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        wget -P ~/Downloads https://download.jetbrains.com/webide/PhpStorm-2018.1.2.tar.gz
    fi

    # Laptop battery tools
    echo "Laptop battery Tools? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo add-apt-repository ppa:linrunner/tlp
        sudo apt-get update
        sudo apt-get install tlp tlp-rdw
        sudo tlp start
        sudo apt-get install -y xbacklight
    fi

    # Spotify
    echo "Install Spotify? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        # 1. Add the Spotify repository signing key to be able to verify downloaded packages
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
        # 2. Add the Spotify repository
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        # 3. Update list of available packages
        sudo apt-get update
        # 4. Install Spotify
        sudo apt-get install -y spotify-client
    fi

    echo "Creating Work directories"
    mkdir ~/Personal
    mkdir -p ~/Code

    echo "Install Homestead? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        vagrant box add laravel/homestead
        git clone https://github.com/laravel/homestead.git /opt/Homestead
        bash /opt/Homestead/init.sh
    fi

    # Clone dotfiles
    git clone https://github.com/hmatalonga/dotfiles ~/.dotfiles

    # Source dot files
    echo '. ~/.dotfiles/bash/.profile' >> ~/.bashrc
    source ~/.bashrc

    echo "Cleaning setup..."
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
    sudo apt-get clean 0
    rm -rf ~/tmp
    sudo apt-get update

elif [[ $mode = "drivers" ]]; then
    echo "Graphics card drivers go here..."
    sudo apt-get update
    sudo apt-get install nvidia-current
elif [[ $mode = "config" ]]; then
    echo "Changing ownership of /opt..."
    sudo chown $USER:$USER /opt
    echo "Adding public DNS nameservers..."
    echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" | sudo tee /etc/resolvconf/resolv.conf.d/head
    sudo resolvconf -u
    # fstab
elif [[ $mode = "themes" ]]; then
    echo "Install Moka theme? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        sudo add-apt-repository ppa:moka/daily
        sudo apt-get update
        sudo apt-get install moka-icon-theme -y
    fi
else
    echo "Usage: bootstrap {init/install/drivers/config/themes}"
fi
