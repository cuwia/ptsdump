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
mkdir -p /var/plexguide/zerotier
rm -rf /var/plexguide/zerotier

# FUNCTIONS START ##############################################################
# FIRST FUNCTION
doneenter() {
 echo
  read -p 'All done | PRESS [ENTER] ' typed </dev/tty
  question1
}

deploycheck() {
  touch /var/plexguide/pgshield.emails
  efg=$(cat "/var/plexguide/pgshield.emails")
  if [[ "$efg" == "" ]]; then
     dstatus="✅ DEPLOYED"
  else dstatus="⚠️ NOT DEPLOYED"; fi
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
  3) # ansible-playbook /opt/plexguide/menu/pg.yml --tags zerotier && clear && endbanner && question1 ;;

    # Sanity Check to Ensure Network ID Set
    # touch /var/plexguide/zerotier.ports
    touch /var/plexguide/ztNet.id
    ztnetid=$(cat "/var/plexguide/ztnet.id")
    if [ "$ztnetid" != "" ]; then
      echo
      echo "SANITY CHECK: Network ID is not set, PTS-ZeroTier cannot be enabled until this is set"
      read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
      question1
    fi


    # Sanity Check to Ensure Ip Set
    touch /var/plexguide/zt.ip
    ztip=$(cat "/var/plexguide/zt.ip")
    if [ "$ztip" != "" ]; then
      echo
      echo "SANITY CHECK: IP is not set, PTS-ZeroTier cannot be enabled until this is set"
      read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty
      question1
    fi

  bash /opt/plexguide/menu/portguard/rebuild.sh
  z) exit ;;
  Z) exit ;;
  *) question1 ;;
  esac
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
  if [ "$networkid" = "exit" ]; then question1; fi
  touch /opt/appdata/zerotier-one/var/networks.d/$networkid.conf
  echo $networkID > /var/plexguide/ztNet.id
    read -p '🔑 Network ID Set ZeroTier Docker will restart |  Press [ENTER] ' public </dev/tty
  question1

bash docker restart zerotier-one

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
  if [ "$ipadd" = "exit" ]; then question1; fi
  echo $ipadd & ":" > /var/plexguide/zt.ip
  echo $ipadd & ":" >/var/plexguide/server.ports

  question1
}

