#!/bin/bash
rpmerizor -name windows-python -version 2.7.14 -release 1 -group Applications/System --buildarch x86_64 -summary "Python 2.7.14 for Windows Root Profile for Wine 2.0.2 using CentOS 7 Docker base" -description "Root Profile RPM of 32bit and 64bit of Windows Python 2.7.14 and Setup to produce Windows .exe executable from Python .py scripts" --nosign /root/.local /root/.wine 
ls -ls /root/rpmbuild/RPMS/x86_64
