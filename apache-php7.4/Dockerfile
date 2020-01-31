FROM ubuntu:18.04

# Setup common packages, repo info, etc
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y cron whois sudo vim htop software-properties-common sendmail git iproute2 iputils-ping lsof unzip rsync wget lsyncd openssh-server sshpass cachefilesd && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add - && echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 apache2-bin apache2-data apache2-utils libapache2-mod-fcgid php7.4-bcmath php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-soap php7.4-xml php7.4-xsl php7.4-zip php-xdebug php-imagick mariadb-client curl blackfire-agent blackfire-php && apt-get purge -y software-properties-common && apt-get autoremove -y && apt-get clean && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

# Setup PHP and Apache
RUN mkdir /run/php && touch /run/php/php-fpm.sock && ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf && ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load && ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load && ln -s /etc/apache2/mods-available/proxy_fcgi.load /etc/apache2/mods-enabled/proxy_fcgi.load && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf && ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load && ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load

# Create new user
RUN useradd -m -p `mkpasswd "inchoo"` -s /bin/bash inchoo && adduser inchoo sudo && ln -s /var/www/html /home/inchoo/html && echo "alias php-debug='php -d xdebug.remote_autostart=1'" > /home/inchoo/.bash_aliases && chown -R inchoo:inchoo /var/www/html && rm -rf /var/www/html/* && echo "inchoo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add custom configuration
ADD config/fpm.conf /etc/php/7.4/fpm/pool.d/www.conf
ADD config/apache.conf /etc/apache2/sites-available/000-default.conf

# Add custom scripts
ADD start.sh /start.sh
ADD scripts/robo.phar /usr/bin/robo
ADD scripts/composer.phar /usr/bin/composer
ADD scripts/n98-magerun.phar /usr/bin/n98-magerun
ADD scripts/n98-magerun2.phar /usr/bin/n98-magerun2
ADD scripts/deployer.phar /usr/bin/deployer

RUN chmod 755 /start.sh && chmod 755 /usr/bin/robo && chmod 755 /usr/bin/composer && chmod 755 /usr/bin/n98-magerun && chmod 755 /usr/bin/n98-magerun2 && chmod 755 /usr/bin/deployer

WORKDIR /var/www/html

CMD ["/start.sh"]
