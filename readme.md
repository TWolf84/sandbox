# сборка и запуск PG

cd D:\docker\pg

docker build -t user/postgresql .

docker run -it --rm -p 5432:5432 --name db user/postgresql
или
docker run -d -p 5432:5432 --name sandbox_db user/postgresql

# сборка и запуск BI

cd D:\docker\bi\fp9_cert

docker build -t user/fp9_cert .

docker run -it --rm -p 8809:8809 --name bi --link db user/fp9_cert
или
docker run -it -p 8809:8809 --name sandbox_bi --link sandbox_db user/fp9_cert

http://localhost:8809/FPBI_App_v9.x/axis2/services/PP.SOM.Som?wsdl


docker exec -it sandbox-bi-1 /bin/bash


# сборка и запуск REDIS

docker run -it --rm -p 6379:6379 --name redis sandbox-redis


# сборка и запуск WEB

docker exec -it sandbox-dba-1 /bin/bash

http://localhost:8109/fp9.x/app/PPService.axd?wsdl

http://localhost:8109/fp9.x/app

http://localhost:8109/dba/

# очистка диска

dispart
select vdisk file="c:\Users\User\AppData\Local\rancher-desktop\distro-data\ext4.vhdx"
compact vdisk

# перенос диска

Закройте все приложения, запущенные в среде Linux и консоли WSL:
```commandline
wsl --shutdown
```
Чтобы создать резервную копию (экспортировать) вашу среду WSL и поместить ее на отдельный диск E:, выполните команды:
```commandline
mkdir d:\wsl\backup
wsl --export rancher-desktop d:\wsl\backup\rancher-desktop.tar
```
Дождитесь окончания экспорта WSL (может занять длительное время). В целевом каталоге появится TAR архив с вашей средой WSL.
Теперь можно удалить файлы среды WSL на исходном диске:
```commandline
wsl --unregister rancher-desktop
```
Создайте каталог для вашего образа Linux на новом диске и импортируйте tar архив в WSL командой:
```commandline
mkdir d:\wsl\backup\rancher-desktop
wsl --import rancher-desktop d:\wsl\rancher-desktop d:\wsl\backup\rancher-desktop.tar
```