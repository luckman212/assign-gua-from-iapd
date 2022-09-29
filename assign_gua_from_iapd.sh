#!/bin/sh

_log() {
  /usr/bin/logger -t assign_gua_from_iapd "$1"
  echo "$1"
}

[ -n "$1" ] || { echo "specify an interface"; exit 1; }
IFACE=$1
if ! /sbin/ifconfig $IFACE 2>/dev/null >/dev/null; then
  echo "$IFACE is not a valid interface, choose one of:"
  /sbin/ifconfig -l
  exit 1
fi
echo "waiting a few seconds for IA_PD"
/bin/sleep 3
IA_PD=$(/usr/bin/grep 'IA_PD prefix' /var/log/dhcpd.log | /usr/bin/tail -1 | /usr/bin/sed -rn 's#^.*IA_PD prefix: ([0-9a-f:]+/56).*$#\1#p')
[ -n "$IA_PD" ] || { _log "no IA_PD detected in logs"; exit 1; }
_log "IA_PD found: $IA_PD"
GUA=$(/usr/local/bin/python3.8 -c '
import sys, ipaddress
nets = list(ipaddress.ip_network(sys.argv[1]).subnets(new_prefix=64))
last_net = ipaddress.IPv6Network(nets[-1],strict=False)
first = last_net[1]
print(first)' $IA_PD)
[ -n "$GUA" ] || { _log "failed to calculate GUA"; exit 1; }
_log "GUA: $GUA"
_log "assigning $GUA to interface $IFACE"
if /sbin/ifconfig $IFACE inet6 $GUA prefixlen 64; then
  _log "restarting dpinger"
  /usr/local/bin/php -r 'include("gwlb.inc"); setup_gateways_monitor();'
fi
echo "done"
