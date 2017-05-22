#!/bin/bash

# OS destribution
DESPCN=$(lsb_release -si)

# try locating NGINX install dir
NGXInstallDir="/etc/nginx"

# try typical config files
NGXCfgDir="/conf.d"
NGXCfgDir1="/sites-available"
NGXCfgDir2="/sites-enabled"

installCheck

function checkNginxInstalled
{
  echo -e "Checking install and dependencies:\n"
  if hash nginx 2>/dev/null; then
     echo -e 'Check NGINX install:\t\t\t[PASS]'
     # make sure config directory exists
     # another file
     if [ ! -d  $NGXInstallDir ];
     then
        echo -e 'NGINX install directory:\t\t[NOT FOUND]'
        installCheck=0
        else
        echo -e 'NGINX install directory:\t\t[FOUND]'
            # config directory 1
            if [  -d  $NGXInstallDir$NGXCfgDir ] || [  -d  $NGXInstallDir$NGXCfgDir1 ] ||
            [  -d  $NGXInstallDir$NGXCfgDir2 ];then
             echo -e 'NGINX config directory:\t\t\t[PASS]'
             # if site enabled or available are present, use enabled
              if  [ -d  $NGXInstallDir$NGXCfgDir1 ];then
                NGXCfgDir=$NGXCfgDir1
               fi
               if [ -d  $NGXInstallDir$NGXCfgDir2 ];then
                NGXCfgDir=$NGXCfgDir2 
               fi
               echo -e "NGINX config directory selected: \t$NGXCfgDir"
              installCheck=1
             else
             echo -e 'NGINX config directory:\t\t\t[NOT FOUND]'
             installCheck=0
            fi
     fi
  else
     echo -e 'Check NGINX install:\t\t\t[NOT INSTALLED]\n'
     installCheck=0
  fi
}

# display notice and call for check.
function landingNotice()
{
cols=$( tput cols )
rows=$( tput lines )

fallbackNotice="Welcome to NGINXSE on $DESPCN\n"
notice_length=${#fallbackNotice}
half_input_length=$(( $notice_length / 2 ))
middle_row=$(( $rows / 2 ))
tput clear
tput cup $middle_row $middle_col
tput bold
echo -e $fallbackNotice
echo -e "This script will help you generate NGINX Server Block config Files.\n"
echo -e "IMPORTANT: -The script WILL NOT delete/modify any existing config files"
echo -e "\t   -You will be promped before any steps will be made."
echo -e "\t   -Sudo privileges are needed to save config files."
echo -e "\t   -The script checks that NGINX is up and running."

tput sgr0
tput cup $( tput lines ) 0
}

landingNotice 
checkNginxInstalled
# test dependency result
testResult=$(checkNginxInstalled)


if [ $installCheck == 1 ]; then
echo -e "Dependencies checked!\n\n"
else
echo -e "\nPlease try resolving the issue(s) above and then rerun the script to continue.\n"
fi

# ask for server name
read -p "Server name(s) (e.g., example.com or sub.example.com):   " server_name
echo -e "\n"
read -p "Html files directory absolute path (default: /usr/share/nginx/html):  " server_root
echo -e "\n"
echo -e "Are you using PHP-FPM:\nPHP-FPM can be installed and set a default\nPHP-FPM is usually set in /etc/php-fpm.d/www.conf."
echo -e "\n"
read -p "Use PHP-FPM? (Y/N):  " phpfpmsupport



phpfpmblock="location ~ \.php$ {\n
include /etc/nginx/fastcgi_params;\n
fastcgi_pass unix:/var/run/php5-fpm.sock;\n
fastcgi_index index.php;\n
fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\n
}\n"

phpcgiblock="location ~ \.php$ {\n
              include snippets/fastcgi-php.conf;\n
              # With php5-cgi alone:\n
              fastcgi_pass 127.0.0.1:9000;\n           
 }\n"



case "$phpfpmsupport" in 
  y|Y ) phpblock=$phpfpmblock;;
  n|N ) phpblock=$phpcgiblock;;
  * ) echo -p "No option selected, Ignoring PHP\n";;
esac





serverblock="
server {\n
        listen 80 ;\n
        listen [::]:80 ;\n

        server_name $server_name;\n
        
        root $server_root;\n

        # Add index.php to the list if you are using PHP\n
        index index.php index.html index.htm index.nginx-debian.html;\n

        location / {\n
        # First attempt to serve request as file, then\n
        # as directory, then fall back to displaying a 404.\n
        #try_files \$uri \$uri/ /index.php\$is_args\$args;\n
        try_files \$uri \$uri/ =404;\n
        }\n
       
        $phpblock
}\n"    

echo -e "\n\nServer block succesfully generated!\n
You can save the generated configuration into a new (.conf) file\n
Server block configuration file to create: '$NGXInstallDir$NGXCfgDir/$server_name.conf'\n"
read -p "Create and Save '$server_name.conf'? (Y/N) if you choose 'N' the config will be displayed.  " savefile


case "$savefile" in 
  y|Y ) echo -e "$serverblock" > "$HOME/$server_name.conf"  
  sudo mv "$HOME/$server_name.conf"  "$NGXInstallDir$NGXCfgDir/$server_name.conf"

  if [ ! -f "$NGXInstallDir$NGXCfgDir/$server_name.conf" ]; then
    echo -e "\n[success] $NGXInstallDir$NGXCfgDir/$server_name.conf has been successfully created!\nPlease run\tsystemctl reload nginx"
  fi
  ;;
  
  n|N ) echo -p $serverblock;;
  * ) echo -p $serverblock;;
esac


