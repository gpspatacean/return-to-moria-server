#!/bin/bash

set -e -x

export DISPLAY=:0.0
#Uncomment these to enable ssh access.
#echo "[entrypoint] Staring sshd server..."
#/usr/sbin/sshd &

echo "[entrypoint] Starting Xvfb server..."
Xvfb $DISPLAY -screen 0 1024x768x24 &

echo "[entrypoint] Staring x11vnc server..."
x11vnc -display $DISPLAY -nopw -bg -xkb -forever

echo "[entrypoint] Installing/Updating Game Server files..."
/usr/games/steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "/server" +login anonymous +app_update 3349480 +quit

echo "[entrypoint] Move world files if it is the 1st run..."
if [ ! -f /server/MoriaServerConfig.ini ]; then
  if [ -d /server/Moria/Saved/SaveGamesDedicated/ ]; then
    echo "[entrypoint] Backing up existing SaveGamesDedicated directory..."
    timestamp=$(date +"%Y%m%d_%H%M%S")
    tar -czvf /server/SavedGamesDedicated_"$timestamp".tar.gz -C /server/Moria/Saved SaveGamesDedicated
  fi
  echo "[entrypoint] Copying world files..."
  cp /root/config/* /server/
  mkdir -p /server/Moria/Saved/SaveGamesDedicated/
  cp /root/world/* /server/Moria/Saved/SaveGamesDedicated/
fi


echo "[entrypoint] Starting Moria Server..."
exec wine /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe Moria 2>&1
