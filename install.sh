#! /bin/bash

#### FUNCIONS
SetDockerRepository() {
	 sudo apt-get install -y \
    	 apt-transport-https \
   	 ca-certificates \
   	 curl \
   	 gnupg-agent \
   	 software-properties-common

	echo -n "Installing GPG key...	" ; 
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	echo "Verifying that the key with the fingerprint is correctly installed...";

	if (( ! $(sudo apt-key fingerprint 0EBFCD88 2>/dev/null | wc -c) )); then
		echo ""; echo "[-]	Error: Fingerprint not found!"; echo "";
		return 2;
	else 
		echo ""; echo "[+]	Fingerprint found!"; echo "";
	fi
	
	sudo add-apt-repository \
   	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   	$(lsb_release -cs) \
   	stable"
	return 0;
}

### SCRIPT

if [ ! -f "./src/data/dhcpd.conf" ];then
echo "ERROR: Are you in the installation folder?"
exit 1
fi
if [[ -z $(grep "export AUCOOP_DIR=" ~/.bashrc) ]]; then
	echo "export AUCOOP_DIR=`pwd`" >> ~/.bashrc  #Això cal fer-ho abans de començar tot.
else
	#linea=`grep -m1 -n 'AUCOOP_DIR' ~/.bashrc | cut -d: -f1`
	sed -i "s|AUCOOP_DIR=.*|AUCOOP_DIR=`pwd`|" ~/.bashrc
fi
source ./config/config.sh

sudo apt-get update -y
#sudo apt-get upgrade -y

#ssh
sudo apt-get install openssh-server
sudo systemctl start ssh.service
#end ssh

#docker
a=$(docker --version | grep version)
if [[ -z $a ]]; then
echo "Installing docker"
	SetDockerRepository;
	if (( $? )); then
		echo "Error installing the docker repositories, exiting...";
	else
		sudo apt-get update -y;
		sudo apt-get install -y docker-ce docker-ce-cli containerd.io
		sudo apt autoremove -y;
	fi
else 
echo "Docker already installed"
fi 
#end docker

#python
sudo apt-get install python3 python3-pip -y
sudo pip3 install getch

#dhcp config
IFACE=`ip link show | awk -F: '$0 !~ "lo|vir|docker*|wl|^[^0-9]"{print substr($2,2,length($2)); exit 0}'`
sudo ip link set dev $IFACE up
sudo ip address add 10.0.0.1/24 dev $IFACE
interfaces="iface $IFACE inet static address  
10.0.0.1 netmask 255.255.255.0
pre-up /sbin/iptables-restore /etc/network/iptables"

# mkdir -p ./data
# cp dhcpd.conf data/dhcpd.conf
# sudo docker pull networkboot/dhcpd
# docker run -it --rm --init --net host -v "$(pwd)/data":/data networkboot/dhcpd $iface
# end dhcp config

# per poder reengegar quan es reboota.

if [[ -z $(grep "export IFACE=" ~/.bashrc) ]]; then
	echo "export IFACE=$IFACE" >> ~/.bashrc  #Això cal fer-ho abans de començar tot.
else
	#linea=`grep -m1 -n 'AUCOOP_DIR' ~/.bashrc | cut -d: -f1`
	sed -i "s|IFACE=.*|IFACE=${IFACE}|" ~/.bashrc
fi

if [ ! -f "./src/docker-compose.yaml" ]; then
	cd ${PWD}/src
	python3 menu.py
fi

echo "Installation complete"




