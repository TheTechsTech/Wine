# Linux Wine on Docker

Wine 2.0.2 32bit and 64bit CentOs 7 image base on a script from https://www.systutorials.com/239913/install-32-bit-wine-1-8-centos-7/

## Cross compile on Linux for Windows
Using the ideas from http://sparkandshine.net/en/build-a-windows-executable-from-python-scripts-on-linux/  

This container can automatically turn python scripts directly to windows executable by dropping *.py into a mounted watch folder, and *.exe will be in another mounted folder for the binary. 

### Usage
To run it:
```
docker run --name wine \
-v py2watch:/opt/watch \
-v py2windows:/opt/windows \
-d technoexpress/wine
```

### Create an RPM image
You can create an Wine 2.0.3 RPM base version of an 32bit and 64bit for CentOs 7.
Running `make_wine_rpm.sh` will produce wine-2.0.2-1.x86_64.rpm in directory `/root/rpmbuild/RPMS/`

Use also can create an Windows Python RPM to cross compile on linux for windows by running `make_wine_profile_rpm.sh` will produce windows-python-2.7.14-1.x86_64.rpm in directory `/root/rpmbuild/RPMS/`

To retrieve run:
```
docker cp wine:/root/rpmbuild/RPMS/ /opt/rmpbuild
```

