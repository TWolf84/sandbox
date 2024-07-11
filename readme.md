# Требования
1. Установлен git-клиент
2. Установлен wsl2
3. Установлен Rancher Desktop

# Использование
## Подготовка ПО
Выполение команд в Windows PowerShell
   - Устанавливаем git клиент
     ```
     choco install git.install
     ```
   - Включаем компонент wsl2
     ```
     Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
     Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
     ```
   - Обновляем компонент wsl2 (опционально)
     ```
     Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile "$($env:userprofile)\Downloads\wsl_update_x64.msi" -UseBasicParsing
     Invoke-Item "$($env:userprofile)\Downloads\wsl_update_x64.msi"
     rm "$($env:userprofile)\Downloads\wsl_update_x64.msi"
     ```
   - Устанавливаем [Rancher Desktop](https://rancherdesktop.io/), скачиваем [дистрибутив](https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.14.2/Rancher.Desktop.Setup.1.14.2.msi)
        
## Разворачивание песочницы
   - клонирование репозитория https://github.com/TWolf84/sandbox
     ```
     cd c:\dev
     git config --global http.proxy http://10.30.30.30:3030
     git clone https://github.com/TWolf84/sandbox
     ```     
   - копирование дистрибутивов
     ```
     xcopy /S /E /I \\V-TAMBOVSKIY\share\sandbox\packages C:\dev\sandbox\packages
     ```
   - использование переменных окружения
     ```
     notepad D:\dev\sandbox\.env     
     ```
   - подготовка образов
     ```
     docker compose build
     ```
   - запуск контейнеров
     ```
     docker compose up
     ```
   - установка расширений ФАП  
   - установка контейнера задач и отчетной формы
   
## Подключение внешних репозиториев
   - настройка repos.yml
     ```
     notepad D:\dev\sandbox\repos.yml
     ```
   - подключение через стандартный веб
   
## Настройка проектного КБП
   - 
   
# Для справки
## Cборка и запуск PG

cd D:\docker\pg

docker build -t user/postgresql .

docker run -it --rm -p 5432:5432 --name db user/postgresql
или
docker run -d -p 5432:5432 --name sandbox_db user/postgresql

## Cборка и запуск BI

cd D:\docker\bi\fp9_cert

docker build -t user/fp9_cert .

docker run -it --rm -p 8809:8809 --name bi --link db user/fp9_cert
или
docker run -it -p 8809:8809 --name sandbox_bi --link sandbox_db user/fp9_cert

http://localhost:8809/FPBI_App_v9.x/axis2/services/PP.SOM.Som?wsdl


docker exec -it sandbox-bi-1 /bin/bash

## Сборка и запуск REDIS

docker run -it --rm -p 6379:6379 --name redis sandbox-redis

## Сборка и запуск WEB

docker exec -it sandbox-dba-1 /bin/bash

http://localhost:8109/fp9.x/app/PPService.axd?wsdl

http://localhost:8109/fp9.x/app

http://localhost:8109/dba/

## Очистка диска

dispart
select vdisk file="d:\wsl\rancher-desktop\ext4.vhdx"
compact vdisk

либо

Optimize-VHD -Path d:\wsl\rancher-desktop\ext4.vhdx -Mode Full

## Перенос диска

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