#!/bin/bash
###BEGIN NX STUFF
cp /mnt/passwd /etc/passwd
cp /mnt/group /etc/group
cp /mnt/shadow /etc/shadow
rm /var/lib/nxserver/home/.ssh/authorized_keys2
/usr/lib/nx/nxsetup --install --clean --purge --auto --setup-nomachine-key

mkdir /var/run/sshd
#/usr/bin/supervisord -c /supervisord.conf

mkdir /tmp/.X11-unix
mkdir /tmp/.ICE-unix
chmod 1777 /tmp/.X11-unix 
/etc/init.d/freenx-server start
###END NX STUFF

###START VNC STUFF
# create an ubuntu user
# PASS=`pwgen -c -n -1 10`
PASS=ubuntu
# echo "Username: ubuntu Password: $PASS"
id -u ubuntu &>/dev/null || useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu
echo "ubuntu:$PASS" | chpasswd
sudo -u ubuntu -i bash -c "mkdir -p /home/ubuntu/.config/pcmanfm/LXDE/ \
    && cp /usr/share/doro-lxde-wallpapers/desktop-items-0.conf /home/ubuntu/.config/pcmanfm/LXDE/"

cd /web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf
exec /usr/bin/supervisord -n
