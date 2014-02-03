# WSUWP Indie Development

A development environment for working with individual WordPress sites on WSUWP Indie.

Provisioning for this environment is pulled from [WSU Web Provisioner](https://github.com/washingtonstateuniversity/WSU-Web-Provisioner) and is intended to be a match with the server provisioning used in production.

## Getting Started

1. Install [VirtualBox](http://virtualbox.org)
2. Install [Vagrant](http://vagrantup.com)
3. Clone WSUWP Indie Development
4. Add projects (see instructions below)
5. `vagrant plugin install vagrant-hostsupdater`
6. `vagrant plugin install vagrant-hosts`
6. `vagrant up`

## Adding Projects

### Required Local Data

A `pillar/sites.sls` file should be created with a `wsuwp-indie-sites` property containing the following data structure:

```
wsuwp-indie-sites:
  site1.wsu.edu:
    directory: site1.wsu.edu
    database: site1_db_name
    nginx:
      server_name: dev.site1.wsu.edu
  site2.wsu.edu:
    directory: site2.wsu.edu
    database: site2_db_name
    nginx:
      server_name: dev.site2.wsu.edu
```

This *pillar* data is provided to provisioning and helps in database creation and determining where the server will look to find your project files.

### Optional Local Data

In the same `pillar/sites.sls` file, additional values can be specified to enable more complex setups.

```
wsuwp-indie-sites:
  site1.wsu.edu:
    directory: site1.wsu.edu
    database: site1_db_name
    db_user: user
    db_pass: password
    db_host: 127.0.0.1
    batcache: true
    cache_key: site1_wsu
    nginx:
      server_name: dev.site1.wsu.edu
      config: manual
    nonces: |
        define('AUTH_KEY',         'uniquekeygoeshere');
        define('SECURE_AUTH_KEY',  'uniquekeygoeshere');
        define('LOGGED_IN_KEY',    'uniquekeygoeshere');
        define('NONCE_KEY',        'uniquekeygoeshere');
        define('AUTH_SALT',        'uniquekeygoeshere');
        define('SECURE_AUTH_SALT', 'uniquekeygoeshere');
        define('LOGGED_IN_SALT',   'uniquekeygoeshere');
        define('NONCE_SALT',       'uniquekeygoeshere');
```

* `db_user`, `db_pass`, and `db_host` can all be used to configure different database settings for the WordPress site.
* `batcache` is assumed to be false. If specified as `true` as in the example above, [Batcache](https://github.com/Automattic/batcache) will be used to provide a page cache.
* `cache_key` should be a short, unique value to distinguish it from other sites. An `object-cache.php` is necessary for this to be useful.
* `config` under `nginx` defaults to `auto` and does not need to be specified. If you change this to `manual`, a `dev.site1.wsu.edu.conf` Nginx config should be included in `site1.wsu.edu/config/` so that provisioning uses that instead of automatically configuring Nginx for your site.
* The data for 'nonces' can be generated here: [https://api.wordpress.org/secret-key/1.1/salt/](https://api.wordpress.org/secret-key/1.1/salt/) - note the `|` after `nonces:` that allows for the multiline data to be included. This is most important in production and can be used to cause reauthentication to occur on a site.

### Individual Site (Project) Structure

Your WordPress project should live in a `site1.wsu.edu/wp-content/` directory in the form of plugins and themes. WordPress itself will be provided automatically by provisioning. If you do want to override the default WordPress installation, include a `site1.wsu.edu/wordpress` directory as well.

An example directory and file structure:

```
Vagrantfile
README.md
...
www/
  news.wsu.edu/
    hosts
    config/
      news.wsu.edu.conf
      dev.news.wsu.edu.conf
    wp-content/
      plugins/
      mu-plugins/
      themes/
      uploads/
```

Provisioning will parse the `hosts` file and so that the VM and your local machine are aware of the domain the project is associated with.

The `hosts` file should contain one domain on each line of the file. These domains will be added to both your local machine (via [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)) and to the guest machine (via [vagrant-hosts](https://github.com/adrienthebo/vagrant-hosts/)).
