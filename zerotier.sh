#!/bin/bash
#
# Title:      Zerotier Installer
# Author(s):  Cuwia
# URL:        
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh

# KEY VARIABLE RECALL & EXECUTION
folder=/var/plexguide/zerotier
if [[ "$folder" != "/var/plexguide/zerotier" ]]; then
mkdir -p "$folder" 
else runs2; fi

runs2() {
folder=/var/plexguide/zerotier
rm -rf "$folder" && mkdir -p "$folder"
}
# FUNCTIONS START ##############################################################
# FIRST FUNCTION
doneenter() {
 echo
  read -p 'All done | PRESS [ENTER] ' typed </dev/tty
  question1
}
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty
  clear && question1
}
dontwork() {
 echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
  clear && question1
}
deploycheck() {
  touch /var/plexguide/pgshield.emails
  efg=$(cat "/var/plexguide/pgshield.emails")
  if [[ "$efg" == "" ]]; then
     dstatus="✅ DEPLOYED"
  else dstatus="⚠️ PTS-SHIELD MISSING"; fi
}
question1() {
  touch /var/plexguide/zt.network
  a7=$(cat /var/plexguide/zt.network)
  if [[ "$a7" != "good" ]]; then shieldcheck; fi
  echo good >/var/plexguide/auth.bypass
  domain=$(cat /var/plexguide/server.domain)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛡️  PTS-ZeroTier 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬   Zerotier Must be installed prior from apps

[1] Set Network ID                     [ $idstatus ]
[2] Setup IP                           [ $ipstatus ]
[3] Deploy ZT                          [ $dstatus ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  case $typed in

  1) netid && phase1 ;;
  2) setip && phase1 ;;
  3) sanícheck1 && sanicheck2 && deploy && clear && endbanner && question1 ;;
  z) exit ;;
  Z) exit ;;
  *) question1 ;;
  esac
}
sanicheck1() {
# Sanity Check to Ensure Network ID Set
# touch /var/plexguide/zerotier.ports
touch /var/plexguide/ztNet.id
ztnetid=$(cat "/var/plexguide/ztnet.id")
 if [[ "$ztnetid" != "" ]]; then
    echo
    echo "SANITY CHECK: Network ID is not set, PTS-ZeroTier cannot be enabled until this is set"
    read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
    question1
 fi
}
 sanicheck2() {
# Sanity Check to Ensure Ip Set
touch /var/plexguide/zt.ip
ztip=$(cat "/var/plexguide/zt.ip")
if [[ "$ztip" != "" ]]; then
   echo
   echo "SANITY CHECK: IP is not set, PTS-ZeroTier cannot be enabled until this is set"
   read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
   question1
fi
}
deploy() {
ansible-playbook /opt/plexguide/menu/pg.yml --tags zerotier
sleep 5
#check for docker online status
pcheck=$(docker ps --format '{{.Names}}' | grep "zerotier")
if [[ "$pcheck" == "zerotier" ]]; then 
   bash /opt/plexguide/menu/portguard/rebuild.sh
else error1; fi
sleep 0.5 
}
error1() {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔑 Setup Zerotier - Network ID - IP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ZeroTier Docker deploy failed (( need better note for user ))"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
dontwork
}

netid() {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔑 Setup Zerotier - Network ID - IP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Note :  Use the link for more information 

https://github.com/PTS-Team/PTS-Team/wiki/PTS-Zerotier

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Network ID     | Press [Enter]: ' networkID </dev/tty
  if [[ "$networkid" == "exit" || "$networkid" == "Exit" || "$networkid" == "EXIT" || "$networkid" == "z" || "$networkid" == "Z" ]]; then
  question1
  else
	touch /opt/appdata/zerotier-one/var/networks.d/$networkid.conf
	read -p '🔑 Network ID Set ZeroTier Docker will restart |  Press [ENTER] ' public </dev/tty
	  echo "$networkID" >/var/plexguide/ztNet.id
	ddrestart && question1
  fi
}

ddrestart() {
docker restart zerotier-one
}
setip() {

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔑 Setup Zerotier - Set IP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Note :  Use the link for more information 

https://github.com/PTS-Team/PTS-Team/wiki/PTS-Zerotier

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  IP Address     | Press [Enter]: ' ipadd </dev/tty
  if [[ "$ipadd" = "exit" ]]; then question1; fi
  echo $ipadd & ":" > /var/plexguide/zt.ip
  echo $ipadd & ":" >/var/plexguide/server.ports

  question1
}

