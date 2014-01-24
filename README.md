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

This `projects.sls` file should have a `wsuwp-indie-sites` property with the following data structure:
```
wsuwp-indie-sites:
  site1.wsu.edu:
    name: site1.wsu.edu
    database: site1_db_name
    db_user: user
    db_pass: password
    db_host: localhost
  site2.wsu.edu:
    name: site2.wsu.edu
    database: site2_db_name
    db_user: user
    db_pass: password
    db_host: localhost
```

This provides `wsuwp-indie-sites` pillar data to other parts of provisioning, which helps explain what database to setup and where to find other files.

The web files for the project should be included in their own directory under `www`.

An example directory and file structure:

```
Vagrantfile
README.md
...
www/
  news.wsu.edu/
    hosts
    wsuwp-single-nginx.conf
    web/
      web files here...
```

Provisioning will parse the `hosts` file and copy the `wsuwp-single-nginx.conf` file so that the VM and your local machine are aware of the domain the project is associated with.

The `hosts` file should contain one domain on each line of the file. These domains will be added to both your local machine (via [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)) and to the guest machine (via [vagrant-hosts](https://github.com/adrienthebo/vagrant-hosts/)).

The `wsuwp-single-nginx.conf` should contain all `server` block information. See the [WSU News config](https://github.com/washingtonstateuniversity/WSU-News/blob/master/wsuwp-single-nginx.conf) as an example.
