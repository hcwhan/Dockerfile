
This is the Alpine version with Snapraid 12.1

# snapraid

Use is made of the [snapraid-runner](https://github.com/Chronial/snapraid-runner) project, a simple Python app which provides the following features:

* Runs diff before sync to see how many files were deleted and aborts if that number exceeds a set threshold
* Can create a size-limited rotated logfile
* Can send notification emails after each run or only for failures
* Can run scrub after sync

## Usage

```
docker create -d \
  -v /mnt:/mnt \
  -v <local-configs-path-on-host>/snapraid:/config \
  -e PGID=1001 -e PUID=1001 \
  --name snapraid \
  hcwhan/snapraid
```

This container is configured using two files `snapraid.conf` and `snapraid-runner.conf`. These should both be placed into your hosts local config directory to be mounted as a volume **before** the container is executed for the first time.

**Parameters**
* `-v /mnt` - The location of your data disks, a good convention is `/mnt/disk*` for your data drives
* `-v /config` - The location of the Snapraid and SnapRAID-runner configurations
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it snapraid /bin/bash`.

### Detecting move operations
You'll probably notice when snapraid runs it gives a warning like `WARNING! UUID is unsupported for disks` and it may not detect moved files. Instead it seems them as copied and removed. In order to detect the file moves you can run with the following additional paramters.

```
--privileged --mount type=bind,source=/dev/disk,target=/dev/disk
```

* `--privileged` will share all your devices (ie `/dev/sdb`, `/dev/sdb1`, etc) with your container. Alternatively, you could probably use something like `--device /dev/sdb:/dev/sdb --device /dev/sdb1:/dev/sdb1`, but you'd need to do it for each drive you have setup.
* `--mount type=bind,source=/dev/disk,target=/dev/disk` mounts the disk listing into the container, so snapraid can run something like `ls /dev/disk/by-uuid` to get a list of all the disks by UUID

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.

## Setting up the application

SnapRAID has a comprehensive manual available [here](http://www.snapraid.it/). Any SnapRAID command can be executed from the host easily using `docker exec -it <container-name> <command>`, for example `docker exec -it snapraid snapraid diff`.

* To monitor the logs of the container in realtime `docker logs -f snapraid`.
