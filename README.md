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

During the installation process it will be prompt a menu for you to chose which services do you want to include in the server.

