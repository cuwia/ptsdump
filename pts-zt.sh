#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh

question1() {
  
  mkdir -p /var/plexguide/auth/
  mkdir -p /var/lib/zerotier-one
  domain=$(cat /var/plexguide/server.domain)

  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛡️  PTS-ZeroTier 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬   ZeroTier Requires a Network ID and API Token!
[1] Set Network ID & API Token
[2] Deploy PTS-Zerotier
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  phase1
}

phase1() {

  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

  case $typed in
  1) ztid && phase1 ;;
  2)
    # Sanity Check to Network ID is set
    if [ -z "$NW_ID" ]]; then
      echo
      echo "SANITY CHECK: Set Network ID! Exiting!"
      read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
      question1
    fi

    # Sanity Check to Ensure that API is set
    if [ -z "$API_TOKEN" ]]; then
      echo
      echo "SANITY CHECK: Set API Key"
      read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
      question1
    fi

    # Sanity Check to Ensure Portgaurd is Enabled
    touch /var/plexguide/server.ports
    ports=$(cat "/var/plexguide/server.ports")
    if [ "$ports" != "" ]; then
      echo
      echo "SANITY CHECK: PortGaurd is not Enabled, PTS-ZeroTier cannot be enabled until they are closed due to security risks!"
      read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
      question1
    fi

if [ -n "$NW_ID" ]; then
    sleep 1; 
    MYID=$(docker exec zerotier-one zerotier-cli info | cut -d " " -f 3);

    if [ -z "$(docker exec zerotier-one zerotier-cli listnetworks | grep $NW_ID)" ]; then
        docker exec zerotier-one zerotier-cli join "${NW_ID}";
        echo "Join to ${NW_ID}, my ID: ${MYID}"
        while [ -z "$(docker exec zerotier-one zerotier-cli listnetworks | grep $NW_ID | grep ACCESS_DENIED)" ]; do echo "wait for connect"; sleep 1 ; done
    fi
    
    if [ -n "$API_TOKEN" ]; then
      if [ -n "$(docker exec zerotier-one zerotier-cli listnetworks | grep $NW_ID | grep ACCESS_DENIED)" ]; then
        echo "Found ENV: API_TOKEN, will auto auth myself ..."
        MYURL=https://my.zerotier.com/api/network/${NW_ID}/member/$MYID
        wget --header "Authorization: Bearer ${API_TOKEN}" "${MYURL}" -q -O /tmp/ztinfo.txt
        sed 's/"authorized":false/"authorized":true/' /tmp/ztinfo.txt > /tmp/ztright.txt
        wget --header "Authorization: Bearer ${API_TOKEN}" --post-data="$(cat /tmp/ztright.txt)" -q -O- "${MYURL}"
        rm /tmp/ztinfo.txt && rm /tmp/ztright.txt
      fi
    fi

    while [ -z "$(docker exec zerotier-one zerotier-cli listnetworks | grep $NW_ID | grep OK)" ]; do echo "wait for auth";sleep 1 ; done
    MYIP=$(docker exec zerotier-one zerotier-cli listnetworks | grep $NW_ID |grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' )
    echo "Success! IP: ${MYIP}"

 fi
   
        ;;
  z) exit ;;
  Z) exit ;;
  *) question1 ;;
  esac
}


ztid() {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔑 Zerotier Config - Network ID & API
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Note :  Use the link for more information 
https://github.com/PTS-Team/PTS-Team/wiki/PTS-ZeroTier
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Network ID     | Press [Enter]: ' NW_ID </dev/tty
  if [ "$NW_ID" = "exit" ]; then question1; fi
  
  read -p '↘️  Zerotier API Key | Press [Enter]: ' API_TOKEN </dev/tty
  if [ "$API_TOKEN" = "exit" ]; then question1; fi
  
read -p '🔑 Network ID & API Key Set |  Press [ENTER] ' public </dev/tty
 
   question1
}


