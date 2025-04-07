FROM ubuntu:24.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN	echo "tzdata tzdata/Areas select Europe" | debconf-set-selections && \
	echo "tzdata tzdata/Zones/Europe select Bucharest" | debconf-set-selections && \
	echo "steam steam/question select I AGREE" | debconf-set-selections && \
	echo "steam steam/license note ''" | debconf-set-selections && \
	apt-get update -y && apt-get upgrade -y && \
	apt-get install -y xvfb x11vnc wine winetricks openssh-server && \
	dpkg --add-architecture i386 && \
	apt-get update -y && apt-get install -y wine32:i386 && \
	apt-get install -y steam steamcmd && \
	mkdir -v /run/sshd

RUN winecfg && sleep 5 && xvfb-run winetricks -q vcrun2022

RUN apt-get clean autoclean && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

#Adjust this line if you want SSH access into the container
#COPY moria.pub /root/.ssh/authorized_keys
COPY world/ /root/world/
COPY config/ /root/config/

RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
