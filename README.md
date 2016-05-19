docker-ubuntu-vnc-desktop
=========================

From Docker Index
```
docker pull babim/ubuntu-novnc
```

Build yourself
```
git clone https://github.com/babim/docker-ubuntu-vnc-desktop.git
docker build --rm -t babim/ubuntu-novnc docker-ubuntu-vnc-desktop
```

Run without password
```
docker run -i -t -p 6080:6080 babim/ubuntu-novnc
```
Run with password
```
docker run -i -t -p 6080:6080 -e PASS=ubuntu babim/ubuntu-novnc
```

Browse http://127.0.0.1:6080/vnc.html

<img src="https://raw.github.com/babim/docker-ubuntu-vnc-desktop/master/screenshots/lxde.png" width=400/>

License
==================

desktop-mirror is under the Apache 2.0 license. See the LICENSE file for details.


### How to run a Xubuntu Desktop  ?

Pull from Docker Index and run the image

```
CID=$(docker run -p 2222:22 -t -d paimpozhil/docker-x2go-xubuntu)
docker logs $CID

note down the root/dockerx passwords.
```

OR

build it yourself.

```
git clone https://github.com/paimpozhil/DockerX2go.git .
docker build -t [yourimagename] .
CID=$(docker run -p 2222:22 -t -d [yourimagename])

docker logs $CID

note the root/dockerx passwords
```

### How to run/connect to server with a Client?

Download the x2go client for your OS from:
http://wiki.x2go.org/doku.php/doc:installation:x2goclient

Create a new session and connect to your seerver
Host : (Your Server IP) Port : 2222 Username : dockerx Password : (get it from the Docker logs above)

Select the Session TYPE as : ~~XFCE~~  LXDE

You can also SSH to the docker container directly with root or dockerx users and their passwords over the port 2222 with linux ssh or windows putty client.


