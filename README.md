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

Provisioning can be made aware of local projects by adding a `provision/salt/pillar/projects.sls` file once this repository is checked out locally.

A `pillar/sites.sls` file should be created with a `wsuwp-indie-sites` property containing the following data structure:

```
wsuwp-indie-sites:
  site1.wsu.edu:
    name: site1.wsu.edu
    database: site1_db_name
    db_user: user
    db_pass: password
    db_host: 127.0.0.1
    nginx:
      server_name: dev.site1.wsu.edu
      root_path: site1.wsu.edu
  site2.wsu.edu:
    name: site2.wsu.edu
    database: site2_db_name
    db_user: user
    db_pass: password
    db_host: 127.0.0.1
    nginx:
      server_name: dev.site2.wsu.edu
      root_path: directory: site2.wsu.edu
```

This provides `wsuwp-indie-sites` pillar data to other parts of provisioning, which helps explain what database to setup and where to find other files.

Options like `cache_key`, `batcache`, and `nonces` are available to add some more complex setups to the created WordPress installations.

```
wsuwp-indie-sites:
  site1.wsu.edu
    name: site1.wsu.edu
    database: site1_db_name
    db_user: user
    db_pass: password
    db_host: 127.0.0.1
    batcache: true
    cache_key: site1_wsu
    nginx:
      server_name: dev.site1.wsu.edu
      root_path: site1.wsu.edu
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

* The data for 'nonces' can be generated here: [https://api.wordpress.org/secret-key/1.1/salt/](https://api.wordpress.org/secret-key/1.1/salt/)
* `cache_key` should be a short, unique value to distinguish it from other sites. An `object-cache.php` is necessary for this to be useful.

Your WordPress project should live in a `site1.wsu.edu/wp-content/` directory in the form of plugins and themes. WordPress itself will be provided automatically by provisioning. If you do want to override the default WordPress installation, include a `site1.wsu.edu/wordpress` directory as well.

An example directory and file structure:

```
Vagrantfile
README.md
...
www/
  news.wsu.edu/
    hosts
    wp-content/
      plugins/
      mu-plugins/
      themes/
      uploads/
```

Provisioning will parse the `hosts` file and so that the VM and your local machine are aware of the domain the project is associated with.

The `hosts` file should contain one domain on each line of the file. These domains will be added to both your local machine (via [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)) and to the guest machine (via [vagrant-hosts](https://github.com/adrienthebo/vagrant-hosts/)).
