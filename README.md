# WSUWP Single Site Dev

A development environment for working with individual WordPress sites that are not yet part of the WSUWP Platform.

## Getting Started

1. Install Virtualbox
2. Install Vagrant
3. Clone WSUWP Single Site Dev
4. Add projects (see below)
5. `vagrant plugin install vagrant-hostsupdater`
6. `vagrant up`

## Adding Projects

Provisioning can be made aware of local projects by adding a `provision/salt/pillar/projects.sls` file once this repository is checked out locally.

This `projects.sls` file should look something like:
```
wp-single-projects:
  news.wsu.edu:
    name: news.wsu.edu
    database: wsu_news
```

This provides `wp-single-projects` pillar data to other parts of provisioning, which helps explain what database to setup and where to find other files.

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
