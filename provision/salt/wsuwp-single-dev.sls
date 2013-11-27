# wsuwp-dev.sls
#
# Setup the WSUWP Single environment for local development in Vagrant.
######################################################################

# Install wp-cli to provide a way to manage WordPress at the command line.
wp-cli:
  cmd.run:
    - name: curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash
    - unless: which wp
    - user: vagrant
    - require:
      - pkg: php-fpm
      - pkg: git
  file.symlink:
    - name: /usr/bin/wp
    - target: /home/vagrant/.wp-cli/bin/wp

wsuwp-db:
  mysql_user.present:
    - name: wp
    - password: wp
    - host: localhost
    - require:
      - sls: dbserver
      - service: mysqld
      - pkg: mysql

{% for project, project_args in pillar.get('wp-single-projects',{}).items() %}
wsuwp-db-{{ project }}:
  mysql_database.present:
    - name: {{ project_args['database'] }}
    - require:
      - sls: dbserver
      - service: mysqld
      - pkg: mysql
  mysql_grants.present:
    - grant: all privileges
    - database: {{ project_args['database'] }}.*
    - user: wp
    - require:
      - sls: dbserver
      - service: mysqld
      - pkg: mysql
  cmd.run:
    - name: cp /var/www/{{ project_args['name'] }}/wsuwp-single-nginx.conf /etc/nginx/sites-enabled/{{ project_args['name'] }}.conf
    - require:
      - pkg: nginx
  cmd.run:
    - name: cat /var/www/{{ project_args['name'] }}/hosts >> /etc/hosts
{% endfor %}

# After the operations in /var/www/ are complete, the mapped directory needs to be
# unmounted and then mounted again with www-data:www-data ownership.
wsuwp-www-umount-initial:
  cmd.run:
    - name: sudo umount /var/www/
    - require:
      - sls: webserver
    - require_in:
      - cmd: wsuwp-www-mount-initial

wsuwp-www-mount-initial:
  cmd.run:
    - name: sudo mount -t vboxsf -o dmode=775,fmode=664,uid=`id -u www-data`,gid=`id -g www-data` /var/www/ /var/www/

wsuwp-flush-cache:
  cmd.run:
    - name: sudo service memcached restart
    - require:
      - sls: cacheserver
  cmd.run:
    - name: sudo service nginx restart
    - require:
      - sls: webserver
