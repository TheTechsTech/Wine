#!/bin/bash
rpmerizor -name wine -version 2.0.2 -release 1 --noverbose -group Applications/System --buildarch x86_64 -summary "Wine 2.0.2 build on Docker using CentOS 7 base" -description "Binary RPM of 32bit and 64bit of Linux Wine 2.0.2" --nosign /usr/local 
ls -ls /root/rpmbuild/RPMS/x86_64
