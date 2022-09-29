# assign-gua-from-iapd

Helper script for pfSense. It takes the first address from the top subnet of a delegated `::/56` and assigns it to an interface (typically a WAN interface that is configured in DHCP6 mode where the ISP does not honor `ia-na` or provide a GUA)

_Tested only on pfSense+ 22.05 / Verizon FIOS, but should work for CE as well_

# Setup

1. Copy the script to your pfSense firewall and make it executable (`chmod u+x /root/assign_gua_from_iapd.sh`)
2. Make sure the **DHCP6 Debug** checkbox is enabled at System → Advanced → Networking.

# Usage

```shell
assign_gua_from_iapd.sh <ifname>
```

# Cron etc.

You can schedule this to occur on regular intervals using the Cron package, or use [this small patch][2] (apply with System Patches) to have the script automatically hooked into the dhcp6c request/renew process.

Other integrations such as `devd` (probably needs to wait for FreeBSD 14 which [brings a new `ADDR_ADD` event][1]— that will land with pfSense 22.11) are left as an exercise to the reader 😉

# Reference

see [Netgate Forum thread](https://forum.netgate.com/topic/174980/fios-getting-56-pd-via-dhcp6-but-no-v6-is-assigned-to-wan/)

[1]: https://reviews.freebsd.org/rGa75819461ec7c7d8468498362f9104637ff7c9e9
[2]: https://github.com/luckman212/pfsense/commit/a20cd10a34020e09dcdc14882c04dc749d3c6487
