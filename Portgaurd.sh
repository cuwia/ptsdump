################################################################################

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /tmp/program_var)
mkdir -p /var/plexguide/cron/
mkdir -p /opt/appdata/plexguide/cron
# FUNCTIONS START ##############################################################

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty

}

# FIRST QUESTION
question1() {
  ZTIP=$(cat /var/plexguide/ZT.IP)
  ports=$(cat /var/plexguide/server.ports)
  if [ "$ports" == "127.0.0.1:" ] || [ "$ports" == "$ZTIP" ; then
    guard="CLOSED" && opp="Open"
  else guard="OPEN" && opp="Close"; fi

  if [ "$ports" == "$ztip"] ; then
    ZTSTAT="CLOSED" && ztopp="Open" 
  else ZTSTAT="OPEN" && ztopp="Close"
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 Welcome to PortGuard!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ports Are Currently: [$guard]
Ports with ZeroTier: [$ZTSTAT]
[ 1 ] $opp Ports
[ 1 ] $ztopp Ports With ZeroTier Backend
[ Z ] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  case $typed in
  1)
    if [ "$guard" == "CLOSED" ]; then
      echo "" >/var/plexguide/server.ports
    else echo "127.0.0.1:" >/var/plexguide/server.ports; fi
    bash /opt/plexguide/menu/portguard/rebuild.sh
  question1
    ;;
  2)
    if [ "$ZTSTAT" == "CLOSED" ]; then
      echo "" >/var/plexguide/server.ports
    else echo "$ztip" >/var/plexguide/server.ports; fi
    bash /opt/plexguide/menu/portguard/rebuild.sh
  question1
    ;;    
  z)
    exit
    ;;
  Z)
    exit
    ;;
  *)
    question1
    ;;
  esac
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
