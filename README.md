# assign-gua-from-iapd

Helper script for pfSense. It takes the first address from the top subnet of a delegated `::/56` and assigns it to an interface (typically a WAN interface configured in DHCP6 mode). Useful for situations where ISPs such as Verizon FIOS do not honor `ia-na` or provide a GUA to the router itself.

_Tested only on pfSense+ 22.05, but should work for CE as well_

# Setup

1. Copy the script to your pfSense firewall and make it executable (`chmod u+x /root/assign_gua_from_iapd.sh`)
2. Make sure the **DHCP6 Debug** checkbox is enabled at System → Advanced → Networking.

> **N.B.** if you haven't applied my patch from [PR #4595][3] you'll need to comment out [line 57][4] (put `//` at the start of the line, or just delete it) because the `create_interface_ipv6_cfgcache()` function doesn't exist in the base pfSense (yet). 

# Usage

```shell
assign_gua_from_iapd.sh <ifname>
```

# Automatic Update

You can schedule this to occur at regular intervals using the Cron package, or use [this small patch][2] (apply with System Patches) to have the script automatically hooked into the dhcp6c request/renew process.

Tighter integrations such as `devd` will need to wait for FreeBSD 14 which [brings a new `ADDR_ADD` event][1]. That will be landing with pfSense 22.11, so I will probably update this around then if there's any way to make it more efficient.

# Reference

see [Netgate Forum thread](https://forum.netgate.com/topic/174980/fios-getting-56-pd-via-dhcp6-but-no-v6-is-assigned-to-wan/)

[1]: https://reviews.freebsd.org/rGa75819461ec7c7d8468498362f9104637ff7c9e9
[2]: https://github.com/luckman212/pfsense/commit/a20cd10a34020e09dcdc14882c04dc749d3c6487
[3]: https://github.com/pfsense/pfsense/pull/4595/
[4]: https://github.com/luckman212/assign-gua-from-iapd/blob/main/assign_gua_from_iapd.sh#L57
