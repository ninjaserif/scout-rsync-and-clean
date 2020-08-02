# scout-rsync-and-clean

Linux file rsync utility which also cleans (deletes) files in local directory - to save space.  I created this script to copy files created on a local Ubuntu machine to a remote NAS, and then delete the files from the local Ubuntu machine after 7 days.  This could be used to copy backups - or other files - to a remote location, keeping x days of backups locally but everything in the remote location.

## Features

* email alert if remote mount unavailable
* rsync to remote location
* delete files locally which are older than configured number of days

## Prerequisite

Install:

* ssmtp (apt-get install ssmtp)
* mailutils (apt-get install mailutils)
* rsync (apt-get install rsync)

Configure:

* /etc/ssmtp/ssmtp.conf
  * check out <https://www.cyberciti.biz/tips/linux-use-gmail-as-a-smarthost.html> as a guide
* /etc/ssmtp/revaliases
  * i.e. `<user>:<ssmpt email address>:<ssmpt IP>:<ssmtp port>`
* /etc/fstab
  * setup automatic mount of external location as required

## Setup

* download latest release - <https://github.com/ninjaserif/scout-rsync-and-clean/releases/latest/>

Below is a "one-liner" to download the latest release

```bash
LOCATION=$(curl -s https://api.github.com/repos/ninjaserif/scout-rsync-and-clean/releases/latest \
| grep "tag_name" \
| awk '{print "https://github.com/ninjaserif/scout-rsync-and-clean/archive/" substr($2, 2, length($2)-3) ".tar.gz"}') \
; curl -L -o scout-rsync-and-clean_latest.tar.gz $LOCATION
```

* extract release

```bash
sudo mkdir /usr/local/bin/scout-rsync-and-clean && sudo tar -xvzf scout-rsync-and-clean_latest.tar.gz --strip=1 -C /usr/local/bin/scout-rsync-and-clean
```

* navigate to where you extracted scout-rsync-and-clean - i.e. `cd /usr/local/bin/scout-rsync-and-clean/`
* create your own config file `# this is preferred over renaming to avoid wiping if updating to new release`

```bash
cp config-sample.sh config.sh
```

* edit config.sh and set your configuration

```bash
SRCDIR=<source_directory>              # source directory
DESMNT=<remote_mount>                  # mount point
DESDIR=$DESMNT/<destination_directory> # destination directory
EMAIL=<email_address>                  # email address to alert
NDAYS=7                                # number of days ro keep locally
```

* confirm scripts have execute permissions
  * scout-rsync-and-clean.sh should be executable
  * config.sh should be executable
* add the following entry to cron `# set timing as desired - example below syncs at 4am everyday`

```bash
0 4 * * * /usr/local/bin/scout-rsync-and-clean/scout-rsync-and-clean.sh >/dev/null 2>&1
```

## Change log

* 1.0 03-09-2019
  * first release
* 1.0.0 02-08-2020
  * cleaned up for git - set to version 1.0.0
  * setup config such that only config that needs to be edited by user is in config.sh

## -END-
