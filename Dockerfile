FROM babim/ubuntubase

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# setup our Ubuntu sources (ADD breaks caching)
RUN echo "deb http://tw.archive.ubuntu.com/ubuntu/ trusty main\n\
deb http://tw.archive.ubuntu.com/ubuntu/ trusty multiverse\n\
deb http://tw.archive.ubuntu.com/ubuntu/ trusty universe\n\
deb http://tw.archive.ubuntu.com/ubuntu/ trusty restricted\n\
deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu trusty main\n\
" >> /etc/apt/sources.list

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
#RUN apt-mark hold initscripts udev plymouth mountall \
#    && dpkg-divert --local --rename --add /sbin/initctl \
#    && ln -sf /bin/true /sbin/initctl

#Doesn't seem to work
#RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9316A7BC7917B12 \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    
RUN apt-get update \
    && apt-add-repository ppa:freenx-team/trusty \
    && apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        pwgen sudo vim-tiny x11vnc x11vnc-data \
        net-tools \
        lxde xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        apt-transport-https ca-certificates \
        wget openssh-server pwgen sudo vim-tiny \
        gtk2-engines-murrine ttf-ubuntu-font-family \
     && apt-get install -y --force-yes software-properties-common python-software-properties \
        xfce4 xfce4-goodies freenx-server libreoffice-gnome \

#Install Dropbox 
RUN cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

#Install Docker (not currently working)
#RUN apt-get update \
#    && apt-get install -y --force-yes --no-install-recommends linux-image-extra-3.13.0-61-generic \
#    apparmor docker-engine vuze

#Set up nxserver
RUN wget https://bugs.launchpad.net/freenx-server/+bug/576359/+attachment/1378450/+files/nxsetup.tar.gz \
    && tar -xvf nxsetup.tar.gz \
    && mv nxsetup /usr/lib/nx/nxsetup \
    && rm nxsetup*
    
RUN apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD web /web/
RUN pip install -r /web/requirements.txt

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/

#For VNC
EXPOSE 6080
#For NX over SSH
EXPOSE 22 
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
