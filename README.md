# Dockerized server with maintenance and backup features

**Resume of repo...** (...)

## Services available:

### Academic
* [Khan Academy](https://es.khanacademy.org/)
* [Moodle](https://moodle.org)
* [Wikipedia offline](https://wikipedia.org/wiki/Kiwix)

### Networking
* DHCP
* DNS

### Features:

* Backup of volumes and images
* On the fly network configuration
* Fancy name resolution for the services
* Internet Service Provider for the local network (TBD)

## Software requirements
1. Tested for `Ubuntu Server 18.04.3 LTS`
2. Acces to internet and to the code of this repository

## Hardware requirements (for x users aprox)
1. A networking card
2. Access to a router which you can configure

## Deploy procedure

Clone the repo, change the directory into the project folder and execute the script `install.sh`.

```bash
git clone https://github.com/aucoop/servidor_base
cd servidor_base
./install.sh
```

During the installation process it will be prompt a menu for you to chose which academic services do you want to include in the server.

## Router configuration

Note: For this configuration we are using the Ubiquity EdgeRouter-X. The steps taken from here one descrive the minimum configuration necessary to integrate the services of the repo.

### DHCP Server

Parameters to configure are:

* Subnet 192.168.1.0/24
* Range Start 192.168.1.100
* Range Stop 192.168.1.200
* Router 192.168.1.1
* DNS 192.168.1.2

Now we need to add a rule to make sure all dns query comes from the server. To acomplish this we'll make a rule.



