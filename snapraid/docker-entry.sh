#!/bin/ash
# Ensures that configuration files for both SnapRAID and snapraid-runner are present
# in /config. In reality, both files should be edited manually before running this
# container to ensure correct operation.

if [ ! -L /etc/crontabs/root ] && [ -f /etc/crontabs/root ]; then
    rm /etc/crontabs/root
fi
# test for /etc/snapraid.conf being a file and not a link, delete if file.
if [ ! -L /etc/snapraid.conf ] && [ -f /etc/snapraid.conf ]; then
    rm /etc/snapraid.conf
fi


if [ ! -f /config/snapraid-cron ]; then
    echo "No snapraid-cron found. You must add snapraid-cron before running this container."
    exit 1
fi
# test if snapraid.conf is in /config, copy from /defaults/snapraid.conf.example if not.
if [ ! -f /config/snapraid.conf ]; then
    echo "No config found. You must configure SnapRAID before running this container."
    exit 1
fi
if [ ! -f /config/snapraid-runner.conf ]; then
    echo "No config found. You must configure snapraid-runner before running this container"
    exit 1
fi


if [ ! -L /etc/crontabs/root ]; then
    ln -s /config/snapraid-cron /etc/crontabs/root
fi
if [ ! -L /etc/snapraid.conf ]; then
    ln -s /config/snapraid.conf /etc/snapraid.conf
fi


/usr/sbin/crond -d 6 -c /etc/crontabs -f
