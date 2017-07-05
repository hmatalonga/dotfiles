#!/usr/bin/env bash

# Before running this script:
# sudo chown -R hugo /usr/local

mode=$1
distro=$(lsb_release -s -c)

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
    ssh-keygen -t rsa -b 4096 -C "hugo@hmatalonga.com"

    # Some git defaults
    echo "Setting git defaults..."
    git config --global color.ui true
    git config --global core.editor nano
    git config --global push.default simple
    git config --global user.name "Hugo Matalonga"
    git config --global user.email hugo@hmatalonga.com

    # Install nvm
    echo "Installing nvm..."
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    nvm install stable
    nvm alias default stable

    # Centralize global npm packages for different node versions
    echo "prefix = /opt/nvm" > ~/.npmrc

    # Install Node modules
    modules=(
        bower
        eslint
        gulp
        vue-cli
        yarn
    )

    echo "installing node modules..."
    npm install -g ${modules[@]}

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
        curl -fsSL https://get.docker.com/ | sh
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
        sudo apt-get install -y virtualbox-5.1
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
    echo "Install Development tools Atom and Vagrant? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        if [[ ! -d "$~/tmp" ]]; then
            mkdir ~/tmp
        fi
        wget https://atom.io/download/deb -O ~/tmp/atom-deb64.deb
        wget -P ~/tmp https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
        sudo dpkg -i ~/tmp/*.deb

        packages=(
            advanced-open-file
            atom-beautify
            attom-css-comb
            auto-detect-indentation
            autocomplete-python
            busy-signal
            dockblockr
            editorconfig
            emmet
            file-icons
            git-plus
            go-plus
            hyperclick
            language-vue
            linter
            linter-eslint
            merge-conflicts
            minimap
            pigments
            sort-lines
        )

        apm install ${packages[@]}
    fi


    # intellij, pycharm or webstorm --if
    echo "Download PhpStorm? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        wget -P ~/Downloads https://download.jetbrains.com/webide/PhpStorm-2017.1.4.tar.gz
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
    mkdir ~/Apps
    mkdir ~/Personal
    mkdir -p ~/Work/Code
    mkdir -p ~/Work/WebApps

    echo "Install Homestead? (Y/n):"
    read opt
    if [[ ${opt,,} = "y" ]]; then
        vagrant box add laravel/homestead
        git clone https://github.com/laravel/homestead.git ~/Apps/Homestead
        bash ~/Apps/Homestead/init.sh
    fi

    # Clone dotfiles
    git clone https://github.com/hmatalonga/dotfiles ~/.dotfiles

    # Source dot files
    echo '. ~/.dotfiles/bash/.profile' >> ~/.profile
    source ~/.profile

    echo "Cleaning setup..."
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
    sudo apt-get clean 0
    rm -rf ~/tmp
    sudo apt-get update

elif [[ $mode = "drivers" ]]; then
    echo "Graphics card drivers go here..."
    sudo apt-get update
    # VERY IMPORTANT upgrade Xorg to 2.15 at least to avoid crashes
    # nvidia-current 352
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
