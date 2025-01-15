[![](https://github.com/forinil/docker-virt-manager/workflows/docker%20build/badge.svg)](https://github.com/forinil/docker-virt-manager/actions/workflows/deploy.yml)[![](https://img.shields.io/docker/pulls/forinil/virt-manager)](https://hub.docker.com/r/forinil/virt-manager)

# Docker virt-manager

Forked from [m-bers/docker-virt-manager](https://github.com/m-bers/docker-virt-manager)

### GTK Broadway web UI for libvirt

![Docker virt-manager](docker-virt-manager.gif)

## What is it?

virt-manager: https://virt-manager.org/  
broadway: https://developer.gnome.org/gtk3/stable/gtk-broadway.html


## Features:

* Uses GTK3 Broadway (HTML5) backend--no vnc, xrdp, etc needed!
* Password/SSH passphrase support via ttyd (thanks to [@obazda20](https://github.com/obazda20/docker-virt-manager) for the idea!) Just click the terminal icon at the bottom left to get to the password prompt after adding an ssh connection. 
<img width="114" alt="Screen Shot 2021-10-25 at 12 01 02 AM" src="https://user-images.githubusercontent.com/4750774/138649110-73c097cc-b054-424c-8fa0-d0c23540b499.png">

* Dark mode

## Requirements:

git, docker, docker-compose, at least one libvirt/kvm host

## Usage

### docker-compose

If docker and libvirt are on the same host

```yaml
services: 
  virt-manager:
    image: forinil/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
    # Set DARK_MODE to true to enable dark mode
      DARK_MODE: false

    # Set HOSTS: "['qemu:///session']" to connect to a user session
      HOSTS: "['qemu:///system']"

    # If on an Ubuntu host (or any host with the libvirt AppArmor policy,
    # you will need to use an ssh connection to localhost
    # or use qemu:///system and uncomment the below line

    # privileged: true

    volumes:
      - "/var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock"
      - "/var/lib/libvirt/images:/var/lib/libvirt/images"
    devices:
      - "/dev/kvm:/dev/kvm"
```

If docker and libvirt are on different hosts

```yaml
services: 
  virt-manager:
    image: forinil/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
    # Set DARK_MODE to true to enable dark mode
      DARK_MODE: false

      # Substitute comma separated qemu connect strings, e.g.: 
      # HOSTS: "['qemu+ssh://user@host1/system', 'qemu+ssh://user@host2/system']"
      HOSTS: "[]"
    # volumes:
      # If not using password auth, substitute location of ssh private key, e.g.:
      # - /home/user/.ssh/id_rsa:/root/.ssh/id_rsa:ro
```

### CasaOS

#### Installing Necessary Dependencies on Host

To make sure that everything works, you should first install ``qemu`` and ``libvirt`` on your system for the Virtual Machine Manager application to work, because otherwise it doesn't and won't be able to connect to the QEMU/KVM connection (this always applies if you have left HOST at the default).

Ubuntu/Debian/Raspberry Pi OS:

```bash
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients
```

Alpine Linux:

```bash
sudo apk update
sudo apk add qemu libvirt qemu-img
sudo rc-update add libvirtd default
sudo systemctl enable --now libvirtd
```

OpenWrt (compile from source):

```bash
# Install necessary packages to compile from source
sudo opkg update
sudo opkg install build-essential libtool automake autoconf pkg-config libudev-dev libnl-tiny-dev glib2-dev libssl-dev

# Clone QEMU and libvirt repositories
git clone https://github.com/qemu/qemu.git
git clone https://github.com/libvirt/libvirt.git

# Build and install QEMU
cd qemu
./configure
make -j$(nproc)
sudo make install

# Build and install libvirt
cd ../libvirt
./autogen.sh
./configure
make -j$(nproc)
sudo make install
```

Arch Linux:

```bash
sudo pacman -S --noconfirm qemu libvirt virt-manager
sudo systemctl enable --now libvirtd
```

#### Setting up Directories (for ISO Images, Hard Disk Images etc.)

In order to set up directories and volumes for storing and accessing things (ISO and hard disk images for example), you can go to the panel for Virtual Machine Manager, right click on the 'QEMU/KVM' text at the homepage of Virtual Machine Manager and click on on 'Details'. From there, go to 'Storage' and click on the green plus icon. From there, you can choose a pool name and use 'Target Path' to choose the desired directory. E.g. for ISO images you can choose /DATA/Downloads (mounted on container at default) as directory to store ISO images. Then create it, and you're good to go! You can do the same if you'd want to store the hard disk images on another location or another drive (a volume/mount first needs to be configured with the settings of the Docker container of Virtual Machine Manager) and make sure to point it to the same path as on the host, in order to resolve conflicts when connecting to the server remotely! Also, if you desire you could also choose the ISO images manually from a path later on, but it has to be on the drive that the server uses and mounted.

#### Installing Virtual Machine Manager

Import [docker-compose.casaos.yml](https://github.com/Forinil/docker-virt-manager/blob/main/docker-compose.casaos.yml) as an app

#### Troubleshooting

##### No Connection Found

Just go to 'File' > 'Add Connection...'. Make sure that the hypervisor is on QEMU/KVM and do NOT check the SSH option. I'd recommend to leave the automatic connection option turned on, and click 'Connect'. It should then be fixed!

### Building from Dockerfile

```bash
    git clone https://github.com/m-bers/docker-virt-manager.git
    cd docker-virt-manager
    docker build -t docker-virt-manager . && docker-compose up -d
```

Go to http://localhost:8185 in your browser
