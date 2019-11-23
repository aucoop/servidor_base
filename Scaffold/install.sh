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

sudo apt-get update -y
sudo apt-get upgrade -y

#ssh
sudo apt-get install openssh-server
sudo systemctl start ssh.service
#end ssh

#docker

SetDockerRepository;
if (( $? )); then
	echo "Error installing the docker repositories, exiting...";
else
	sudo apt-get update -y;
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	sudo apt autoremove -y;
fi
	
#end docker


#dhcp config
iface=ip link | awk -F: '$0 !~ "lo|vir|docker*|wl|^[^0-9]"{print $2;getline}' | head -n1
sudo ip link set dev $iface up
sudo ip add address add 172.17.0.1/24 dev $iface
mkdir ./data
cp dhcpd.conf data/dhcpd.conf
sudo docker pull networkboot/dhcpd
docker run -it --rm --init --net host -v "$(pwd)/data":/data networkboot/dhcpd $iface
# end dhcp config

#config dns




