FROM centos:7.8.2003

LABEL maintainer="technoexpressnet@gmail.com"

# Install Required Dependencies
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& yum -y --enablerepo=epel install curl unzip git vim wget which sudo

ENV DISPLAY :0
RUN yum install -y wine \
    && yum -y install https://harbottle.gitlab.io/wine32/7/i386/wine32-release.rpm \
    && yum -y install wine.i686

# Fixes issue with running systemD inside docker builds
# From https://github.com/gdraheim/docker-systemctl-replacement
COPY systemctl.py /usr/bin/systemctl.py
COPY py2exe.sh /usr/local/bin/py2exe

RUN cp -f /usr/bin/systemctl /usr/bin/systemctl.original \
    && chmod +x /usr/bin/systemctl.py \
    && chmod +x /usr/local/bin/py2exe \
    && cp -f /usr/bin/systemctl.py /usr/bin/systemctl

#From http://sparkandshine.net/en/build-a-windows-executable-from-python-scripts-on-linux/
RUN wget -q http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe \
	&& wine dotNetFx40_Full_x86_x64.exe /q /norestart

RUN wget -q https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi \
    && wine msiexec /i python-2.7.18.amd64.msi /quiet /qn \
    && wget -q https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi \
	&& wine msiexec /i VCForPython27.msi /quiet /qn

RUN cd ~/.wine/drive_c/Python27 \
	&& mkdir pyfor_exe \
    && wine python.exe Scripts/pip.exe install pyinstaller==2.1 \
	&& wine python.exe Scripts/pip.exe install pexpect \
	&& wine python.exe Scripts/pip.exe install pycrypto

RUN yum -y install python2-pip python2-devel gcc \
    && pip install --upgrade pip \
    && pip install pyinstaller \
    && pip install pexpect \
    && pip install pycrypto \
    && pip install when-changed

COPY etc /etc/
RUN yum install yum-cron yum-versionlock -y && yum versionlock systemd \
    && (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    rm -f /etc/dbus-1/system.d/*; \
    rm -f /etc/systemd/system/sockets.target.wants/*; \
	systemctl.original enable yum-cron.service containerstartup.service

RUN mkdir -p /opt/watch \
	&& mkdir -p /opt/windows

ENTRYPOINT ["/usr/bin/systemctl","default","--init"]
