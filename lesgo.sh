#!/bin/bash
########################################################################
# Use of code or any part of it is strictly prohibited. File protected by copyright law and provided under license.
# To Use any part of this code you need to get a writen approval from the code owner: admin@tokyodevs.com
########################################################################
# rm /Users/macbook/.ssh/known_hosts
# Django Auto Deployment for CentOS 7 Version 1.0.4
#https://github.com/tokyodevs/simple_django.git
########################################################################
progreSh() {
    LR='\033[1;31m'
    LG='\033[1;32m'
    LY='\033[1;33m'
    LC='\033[1;36m'
    LW='\033[1;37m'
    NC='\033[0m'
    if [ "${1}" = "0" ]; then TME=$(date +"%s"); fi
    # SEC=`printf "%04d\n" $(($(date +"%s")-${TME}))`; SEC="$SEC sec"
    SEC="" 
    PRC=`printf "%.0f" ${1}`
    SHW=`printf "%3d\n" ${PRC}`
    LNE=`printf "%.0f" $((${PRC}/2))`
    LRR=`printf "%.0f" $((${PRC}/2-12))`; if [ ${LRR} -le 0 ]; then LRR=0; fi;
    LYY=`printf "%.0f" $((${PRC}/2-24))`; if [ ${LYY} -le 0 ]; then LYY=0; fi;
    LCC=`printf "%.0f" $((${PRC}/2-36))`; if [ ${LCC} -le 0 ]; then LCC=0; fi;
    LGG=`printf "%.0f" $((${PRC}/2-48))`; if [ ${LGG} -le 0 ]; then LGG=0; fi;
    LRR_=""
    LYY_=""
    LCC_=""
    LGG_=""
    for ((i=1;i<=13;i++))
    do
    	DOTS=""; for ((ii=${i};ii<13;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}#"; else LRR_="${LRR_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${DOTS}${LY}............${LC}............${LG}............ ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 1 ]; then sleep .05; fi
    done
    for ((i=14;i<=25;i++))
    do
    	DOTS=""; for ((ii=${i};ii<25;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LYY_="${LYY_}#"; else LYY_="${LYY_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${DOTS}${LC}............${LG}............ ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 14 ]; then sleep .05; fi
    done
    for ((i=26;i<=37;i++))
    do
    	DOTS=""; for ((ii=${i};ii<37;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}#"; else LCC_="${LCC_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${DOTS}${LG}............ ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 26 ]; then sleep .05; fi
    done
    for ((i=38;i<=49;i++))
    do
    	DOTS=""; for ((ii=${i};ii<49;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}#"; else LGG_="${LGG_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${LG}${LGG_}${DOTS} ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 38 ]; then sleep .05; fi
    done
}
echo -e "\e[36m _               ____       "
echo -e "\e[36m| |    ___  ___ / ___| ___  "
echo -e "\e[36m| |   / _ \/ __| |  _ / _ \ "
echo -e "\e[36m| |__|  __/\__ \ |_| | (_) |"
echo -e "\e[36m|_____\___||___/\____|\___/ "
echo -e "\e[39m"       
read -n 1000 -p "GitHub Repo To Clone" gitrepo;
yum install -y firewalld wget
sudo systemctl start firewalld && sudo systemctl enable firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8000/tcp --permanent
firewall-cmd --reload
progreSh 2 && printf "\n\n\n"
cd /tmp && wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && ls *.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
progreSh 5 && printf "\n\n\n"
sudo yum install gcc openssl-devel lsof bzip2-devel libffi-devel sqlite-devel git vim libpqxx-devel.x86_64 postgresql postgresql-contrib nginx curl -y
progreSh 10 && printf "\n\n\n"
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
tar xzf Python-3.7.4.tgz
sudo ./Python-3.7.4/configure --enable-optimizations && make altinstall # need more options
rm /root/Python-3.7.4.tgz
progreSh 15 && printf "\n\n\n"
# python3.7 -V
# pip3.7 install
sudo yum -y install https://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
sudo yum -y install postgresql96-server postgresql96-contrib postgresql96-devel
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
progreSh 20 && printf "\n\n\n"
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6
ran_db_password=$(</dev/urandom tr -dc A-Za-z0-9 | head -c32)
ran_db_name=$(</dev/urandom tr -dc a-z0-9 | head -c5)
db_name="lessgo_$ran_db_name"
ran_db_user=$(</dev/urandom tr -dc a-z0-9 | head -c4)
db_user="du_$ran_db_user"
sudo su - postgres bash -c "createuser $db_user"
sudo -u postgres bash -c "psql -c \"ALTER USER $db_user WITH PASSWORD '$ran_db_password';\""
sudo su - postgres bash -c "createdb --owner $db_user $db_name"
sed 's/ident/md5/g' /var/lib/pgsql/9.6/data/pg_hba.conf
sudo systemctl restart postgresql-9.6
progreSh 30 && printf "\n\n\n"
pip3.7 install pipenv
cd /opt/ && mkdir pyapps && cd pyapps
git clone $gitrepo
basename=$(basename $gitrepo)
filename=${basename%.*}
cd $filename
pipenv install --dev --three 
pipenv install -r requirements.txt
pipenv run python3.7 manage.py makemigrations
pipenv run python3.7 manage.py migrate
ran_django_user=$(</dev/urandom tr -dc a-z0-9 | head -c5)
djl_user="du_$ran_django_user"
ran_django_password=$(</dev/urandom tr -dc A-Za-z0-9 | head -c12)
djl_pass="du_$ran_django_password"
ran_django_email=$(</dev/urandom tr -dc a-z0-9 | head -c32)
djl_email="du_$ran_django_email"
DJ_USER="admin$djl_user"
DJ_PASS=$djl_pass
DJ_EMAIL="$djl_email@riseup.net"
pipenv run python3.7 manage.py shell -c "from django.contrib.auth.models import User; \
                           User.objects.filter(username='$DJ_USER').exists() or \
                           User.objects.create_superuser('$DJ_USER',
                           '$DJ_EMAIL', '$DJ_PASS')"

sudo mkdir /usr/share/nginx/html/media
sudo mkdir /usr/share/nginx/html/static
pipenv run python3.7 manage.py collectstatic --noinput                           
# pipenv run python3.7 manage.py runserver testproject.com 8000
pipenv install gunicorn
nohup pipenv run gunicorn $filename.wsgi:application --bind localhost:8000 & 
ls
sudo echo "#!/bin/bash

# Change to project directory
cd /opt/pyapps/$filename

/usr/bin/pipenv run gunicorn $filename.wsgi:application \
  --name \"$filename\" \
  --workers 4 \
  --user=root --group=root \
  --bind 127.0.0.1:8000 \
  --log-level=debug \
  --log-file=\"/var/log/gunicorn.logs\"" >> /opt/pyapps/$filename/gunicorn_starter.sh
yum install -y supervisor
systemctl enable supervisord
systemctl start supervisord
touch /var/log/gunicorn_supervisor.log
echo '[program:$filename]' >> /etc/supervisord.conf
echo 'directory=/opt/pyapps/$filename/' >> /etc/supervisord.conf
echo 'command =sh /opt/pyapps/$filename/gunicorn_start.sh' >> /etc/supervisord.conf
echo 'user = root       ; User to run as' >> /etc/supervisord.conf
echo 'stdout_logfile = /var/log/gunicorn_supervisor.log                     ; Where to write log messages' >> /etc/supervisord.conf
echo 'redirect_stderr = true                                                ; Save stderr in the same log' >> /etc/supervisord.conf
echo 'environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8                       ; Set UTF-8 as default encoding' >> /etc/supervisord.conf
supervisorctl reread
supervisorctl update
supervisorctl status all
progreSh 60 && printf "\n\n\n"
sudo rm -f /etc/nginx/nginx.conf
cd /etc/nginx/ && wget https://gist.githubusercontent.com/tokyodevs/a5f036d50894930e8dec87217ecd1f48/raw/1be999f444d6ab732dfcecb6804018d94b650b65/nginx-tpl-1
mv nginx-tpl-1 nginx.conf
progreSh 70 && printf "\n\n\n"
sudo nginx -t
sudo systemctl restart nginx
progreSh 100
MY_SERVER_IP=`curl -s http://centos-webpanel.com/webpanel/main.php?app=showip`
printf "\n\n\n"
echo "#############################"
echo "#     Django  Installed     #"
echo "#############################"
echo ""
echo "Go to Django Admin GUI at http://$MY_SERVER_IP/admin/"
echo ""
echo "#########################################################"
echo "Python3.7 + Django + NGINX + PostgreSql + uWSGI Installed"
echo "#########################################################"
echo "Django admin Username: $DJ_USER"
echo "Django admin Password: $DJ_PASS"
echo "Django admin Email: $DJ_EMAIL"
echo "PostgreSql DB Name: $db_name"
echo "PostgreSql DB Password: $ran_db_password"
echo "PostgreSql DB Username: $db_user"
echo "Django Application DIR: /root/pyapps/$filename"
echo "Django Static Files DIR: /usr/share/nginx/html/static"
echo "Django Media Files DIR: /usr/share/nginx/html/media"
echo "Django local port: 8080      NGINX port: 80"
echo "#########################################################"
echo "                   Django SETTING                        "
echo "#########################################################"
echo "DEBUG = False"
echo "ALLOWED_HOSTS = ['127.0.0.1']"
echo "STATIC_URL = '/static/'"
echo "STATIC_ROOT = '/usr/share/nginx/html/static'"
echo "MEDIA_URL = '/media/'"
echo "MEDIA_ROOT = '/usr/share/nginx/html/media'"
echo "#########################################################"
echo
echo "Visit for help: https://tokyodevs.com'
echo "Enjoy Your Day ;)"
