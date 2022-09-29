# assign-gua-from-iapd

Helper script for pfSense. It takes the first address from the top subnet of a delegated `::/56` and assigns it to an interface (typically a WAN interface that is configured in DHCP6 mode where the ISP does not honor `ia-na` or provide a GUA)

_Tested only on pfSense+ 22.05 + Verizon FIOS_

# Setup

Copy the script to your pfSense firewall and make it executable (`chmod u+x /root/assign_gua_from_iapd.sh`)

# Usage

```shell
assign_gua_from_iapd.sh <ifname>
```

# Cron etc.

You can schedule this to occur on regular intervals using the Cron package. Other integrations such as `devd` (probably needs to wait for FreeBSD 14 which will land with pfSense 22.11) or directly into the dhcp6c/rtsold scripts are left as an exercise to the reader 😉

# Reference

see [Netgate Forum thread](https://forum.netgate.com/topic/174980/fios-getting-56-pd-via-dhcp6-but-no-v6-is-assigned-to-wan/)