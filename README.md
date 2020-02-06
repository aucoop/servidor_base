# ATENCIO, AIXO ESTA AQUI NOMES PER FER PREVIEW

# INITE: Captive portal basat en DNS spoofing.
Aquesta és la documentació bàsica d'Inite. Inite incorpora un servidor DNS fet en python i un [Captive Portal](https://en.wikipedia.org/wiki/Captive_portal) fen en el _REST framework_ de python Django:

- **CustomDNS:** Aquest senzill dns (a la carpeta customDNS) permet l'aparició automàtica del _captive portal_ i l'enllaç amb els altres serveis del servidor. El seu funcionament és el següent:
  1. Un _host_ de la xarxa interna desitja connectar-se a internet. Si el router ha estat ben configurat com explica la documentació bàsica del projecte (**aqui hi ha d'anar un link a una documentació que encara no està feta**) aquest _host_ farà una petició DNS al servei per resoldre el nom del recurs que demana. La base de dades del DNS serà borrada cada (** encara no ho sabem **) hores per forçar el registre de la gent tenint en compte que els cursos pels que s'ha dissenyat aquest servei duren 4 hores i els ordinadors són compartits.
  2. Al rebre aquesta petició el servidor customDNS té dos comporaments:
    - Aquest host no ha passat pel _captive portal_: En aquest cas mostrarà el portal perquè el host es pugui registar.
    - Aquest host s'ha registrat correctament al _captive portal_: En aquest cas podrà accedir als recurosos d'internet i/o del servidor lliurememt

- **Captive Portal:** La funció principal és recollir les dades de les persones que es dirigeixin al centre a fer els cursos. Aquest portal es veurà cada cop que un nou host entri a la xarxa en les X (**aqui cal posar el nombre d'hores**) hores entre que la base de dades es _reseteja_. Permet també a un administrador amb usuari i contrasenya poder-se descarregar aquestes dades i bloquejar o permetre la sortida a internet.

## Instal·lació ràpida

Guia d'instal·lació ràpida del servei Inite en un servidor Devian/Ubuntu i derivats. La instal·lació pot fer-se de forma automàtica per mitjà del _script_ d'instal·lació _install.sh_ present a la carpeta arrel del projecte o de forma manual amb els passos següents. Si s'opta per la instal·lació automàtica el manual segueix al punt [posada en marxa](#Posada en marxa).

### Instal·lació del programari necessari

1. Cal primer instalar python i l'instal·lador de paquets _pip_, el servidor web Apache2, el SGBD postgresql

```bash
sudo apt update
sudo apt install python python-pip python3 python3-dev python-dev python3-pip apache2 postgresql postgresql-contrib libpq-dev apache2-utils libapache2-mod-wsgi expect 
```
2. Configuració de l'apache. 

```bash
sudo systemctl enable apache2
sudo systemctl restart apache2
cp web_server/inite.conf /etc/apache2/sites-available/ 
ln -s /etc/apache2/sites-available/inite.conf /etc/apache2/sites-enabled/inite.conf 
cp web_server/mod-wsgi.conf /etc/apache2/conf-available/
a2enconf mod-wsgi
a2enmod wsgi
sudo systemctl reload apache2
``` 
3. Configuració de Postgres. És important escriure aquestes comandes per separat per evitar problemes amb el _shell_ de postgres. Al llarg d'aquesta configuració s'ens demanarà la constrasenya de l'usuari de la base de dades. La contrasenya usada en el nostre programa és _NTExMmZhMmU3_. Recomanem usar aquesta. Si es desitja usar una de diferent cal canviar els fitxers customDNS/fakeDNS.py i inite/settings.py perquè usin la mateixa contrasenya.


```bash
sudo systemctl enable postgresql
sudo systemctl start postgresql
su postgres
psql
createuser u_dks;
createdb db_dks;
\password u_dks;  # s'ens demanarà contrasenya
alter user u_dks createdb;
\q
exit
```
4. Deshabilitar el dns server per defecte d'unix
```bash
systemctl disable systemd-resolved
```

### Instal.lació del dns customDNS
1. Procedim a la instal·lació de customDNS

```bash
pip install -r customDNS/requirements.txt
```
2. Copiar la carpeta la carpeta de sistema /usr/local/.

```bash
sudo cp -r ./customDNS /usr/local/
```

3. Copiar el servei a la carpeta de serveis de Debian

```bash
 sudo cp ./customDNS/fakeDNS.service /etc/systemd/system/fakeDNS.service
 ```

### Instal·lació del _Captive portal_

1. Instal·lacció dels requisits de python
```bash
pip3 install -r requirements.txt
```
2. Donar valor a les variables ROUTER_USER, ROUTER_PASSWD i ROUTER_IP presents a inite/settings.py amb les credencials d'administració del router Edgerouter X. (no podem assegurar el seu funcionament amb altres routers). Veure documentació general (**Aqui falta un link a la documentació que encara no està feta**)

## Posada en marxa

Instruccions de posada en marxa dels serveis:
- **Mode debugging:** Permet engegar els serveis en terminals i veure els outputs de _debugging_ per a detectar errors en la configuració/programació
- **Mode producció:** Fet amb daemons de systemd per garantir l'execució en segon plà, l'engegada del servei amb l'engegada de l'ordinador i el restabliment del servei si cau. 

### Posada en marxa com a procés des del terminal. Versió de _debugging_
1. Assegurarnos que tenim tots els daemons al port 80 i al port 53 desctivats
```bash
netstat -putan #per veure les connexions
systemctl stop apache2 #apagar la connexió d'apache que podem tenir encesa
systemctl stop fakeDNS #apagar el dns que podem tenir encès
systemctl stop systemd-resolved #apagar el dns resolver d'ubuntu
```

2. Assegurar-nos que la base de dades està activada
```bash
systemctl start postgresql
```

3. Engegar el dns en un terminal
```bash
python2 customDNS/fakeDNS.py
```
4. Engegar el server DJango
```bash
python3 manage.py runserver 0.0.0.0:80
```

Llest. Al obrir un navegador amb el DNS ben configurat i dirigit al nostre servidor ens sortirà un _popup_ del navegador per registrar-nos.

### Posada en marxa com a server (daemon). Versió de producció
1. Posada en marxa del daemon de customDNS.
```bash 
sudo systemctl enable fakeDNS
sudo systemctl start fakeDNS
```
2. Posada en marxa del daemon apache2
```bash
sudo systemctl start apache2
```
