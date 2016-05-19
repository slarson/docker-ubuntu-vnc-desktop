FROM babim/ubuntubase

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update

RUN apt-get install -y openssh-server 

RUN add-apt-repository ppa:x2go/stable

RUN apt-get update

RUN apt-get install x2goserver x2goserver-xsession pwgen -y

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        pwgen sudo vim-tiny x11vnc x11vnc-data \
        net-tools \
        lxde xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        apt-transport-https ca-certificates \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D 

RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list

RUN cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends linux-image-extra-3.13.0-61-generic \
    apparmor docker-engine vuze
    
RUN apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD web /web/
RUN pip install -r /web/requirements.txt

RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN sed -i "s/#PasswordAuthentication/PasswordAuthentication/g" /etc/ssh/sshd_config


RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

ADD set_root_pw.sh /set_root_pw.sh
RUN chmod +x /*.sh

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/

EXPOSE 6080
EXPOSE 22
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
