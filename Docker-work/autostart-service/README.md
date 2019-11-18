# Launching docker-compose as a Linux service

here there is a service Unit to initialize some Docker images by docker-compose in Systemd.

1. Clone the repo in your `HOME` directory:  
`git clone https://github.com/aucoop/servidor_base.git`. If you don't want to place the project folder in your `HOME` directory, make sure you change the `WorkingDirectory` field to the correct path to the `docker-compose.yml` file.

2. Check that the executable`docker-compose` is placed in `/usr/bin/`. If not, make sure you chage the `ExecStartPre` and the `ExecStart` fields (sometimes it may be in `/usr/local/bin`).

3. In the project root folder move the     `compose-autostart.service` file to `/etc/systemd/system` by running:  
      ```bash
        cd Docker-work/autostart-service
        mv compose-autostart.service /etc/systemd/system
      ```    

4. Then to start the service run
    ```bash
    sudo systemctl start compose-autostart.service
    ```
5. For starting the service on boot:
    ```bash
    sudo systemctl enable compose-autostart.service
    ```
6. For checking the status of the service:
    ```bash
    sudo systemctl status compose-autostart.service
    ```
    If the service is running properly, you should see an output like:
    ```
    p4@p4:/etc/systemd/system$ sudo systemctl status compose-autostart.service 
    ● compose-autostart.service - Auto start service for docker-compose
    Loaded: loaded (/etc/systemd/system/compose-autostart.service; enabled; vendor preset: enabled)
    Active: active (running) since Mon 2019-11-18 21:27:51 UTC; 6min ago
    Process: 1480 ExecStartPre=/bin/bash -c docker ps -aqf "name=%i_*" | xargs docker rm (code=exited, status=123)
    Process: 1452 ExecStartPre=/bin/bash -c docker network ls -qf "name=%i_" | xargs docker network rm (code=exited, status=123)
    Process: 1409 ExecStartPre=/bin/bash -c docker volume ls -qf "name=%i_" | xargs docker volume rm (code=exited, status=123)
    Process: 1401 ExecStartPre=/usr/bin/docker-compose rm -fv (code=exited, status=0/SUCCESS)
    Process: 1369 ExecStartPre=/usr/bin/docker-compose down -v (code=exited, status=0/SUCCESS)
    Main PID: 1513 (docker-compose)
        Tasks: 6
    Memory: 75.3M
        CPU: 3.387s
    CGroup: /system.slice/compose-autostart.service
            ├─1513 /usr/bin/docker-compose up
            └─1554 /usr/bin/docker-compose up

    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | moodle  INFO     Username: user
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | moodle  INFO     Password: **********
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | moodle  INFO     Email: user@example.com
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | moodle  INFO   (Passwords are not shown for security reasons)
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | moodle  INFO  ########################################################################
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | moodle  INFO
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | nami    INFO  moodle successfully initialized
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | INFO  ==> Starting moodle...
    Nov 18 21:32:05 p4 docker-compose[1513]: moodle_1   | Starting Apache...
    Nov 18 21:32:06 p4 docker-compose[1513]: moodle_1   | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.18.0.5. Set the 'S
    ```

Source: [How to make a Systemd Unit for docker-compose?](https://github.com/docker/compose/issues/4266)


