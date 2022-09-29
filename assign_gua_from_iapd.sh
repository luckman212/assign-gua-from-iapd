#!/bin/sh

[ -n "$1" ] || { echo "specify an interface"; exit 1; }
if ! ifconfig -l | grep -qc $1; then
  echo "$1 is not a valid interface, choose one of:"
  ifconfig -l
  exit 1
fi
IA_PD=$(grep 'IA_PD prefix' /var/log/dhcpd.log | tail -1 | sed -rn 's#^.*IA_PD prefix: ([0-9a-f:]+/56).*$#\1#p')
[ -n "$IA_PD" ] || exit 1
echo "IA_PD: $IA_PD"
GUA=$(/usr/local/bin/python3.8 -c '
import sys, ipaddress
nets = list(ipaddress.ip_network(sys.argv[1]).subnets(new_prefix=64))
last_net = ipaddress.IPv6Network(nets[-1],strict=False)
first = last_net[1]
print(first)' $IA_PD)
echo "  GUA: $GUA"
[ -n "$GUA" ] || { echo "failed to calculate GUA"; exit 1; }
echo "assigning GUA to $1"
ifconfig $1 inet6 $GUA prefixlen 64
echo "restarting dpinger"
/usr/local/bin/php -r 'include("gwlb.inc"); setup_gateways_monitor();'
echo "done"
