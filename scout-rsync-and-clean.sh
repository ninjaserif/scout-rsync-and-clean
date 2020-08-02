#!/bin/bash

# scout-rsync-and-clean

##### START
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPTDIR

if [ -f "$SCRIPTDIR/config.sh" ]; then
  . config.sh
else
  echo "$SCRIPTDIR/config.sh missing - copy config-sample.sh and update with your own config"
  exit 1
fi

##### Load config
HOST=`hostname`                          # get hostname
DATETIME=`date "+%Y-%m-%d %H:%M:%S"`     # get date and time
SWVER="~~ scout-rsync-and-clean version 1.0.0 02/08/2020 ~~"

##### Functions
rsyncandclean()
{
  rsync -zavhu $SRCDIR "$DESDIR"
  find $SRCDIR -mtime +$NDAYS -type f -delete
} # end of rsync

##### Main
if grep -qs "$DESMNT" /proc/mounts; then
  # DESMNT mounted - proceed with sync + cleanup
  rsyncandclean
  exit
else
  mount "$DESMNT"
  if [ $? -eq 0 ]; then
    # DESMNT was mounted successfully - proceed with sync + cleanup
    rsyncandclean
    exit
  else
    # DESMNT not mounted - send email
    LOGVAR=$(echo -e "$DESMNT not mounted on $HOST")'\n\n'
    LOGVAR+=$(echo -e "$SWVER")'\n'
    echo -e "$LOGVAR" | mail -s "$HOST sync recordings failed - $DATETIME" $EMAIL
  fi
fi

#END