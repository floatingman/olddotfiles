import subprocess

from i3pystatus import Status

status = Status(standalone=True)

#battery
#status.register("battery",
#        format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%] {remaining:%E%hh:%Mm}",
#        alert=True,
#        alert_percentage=5,
#        status={
#            "DIS": "↓",
#            "CHR": "↑",
#            "FULL": "=",
#        },)

#status.register("uptime")

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load")

# Shows your CPU temperature, if you have a Intel CPU
#status.register("temp",
#        format="CPU TEMP {temp:.0f}C",)

# Show memory
status.register("mem",
        format="Memory: {used_mem}/{total_mem}MiB [{avail_mem}MiB]",
        )

# Displays whether a DHCP client is running
#status.register("runwatch",
#        name="DHCP",
#        path="/var/run/dhclient*.pid",)

# Shows the address and up/down state of eth0. If it is up the address
# is shown in green (the default value of color_up) and the CIDR-address
# is shown (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
        interface="enp4s0",
        format_up="{v4cidr}",)

# Has all the options of the normal network and adds some wireless
# specific things like quality and network names.
#
# Note: requires both netifaces and basiciw
#status.register("wireless",
#        interface="wlan0",
#        format_up="{essid} {quality:03.0f}% {v4}",)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
        path="/",
        format="/: {used}/{total}G [{avail}G]",)
status.register("disk",
        path="/mnt/Extra/",
        format="E: {used}/{total}G [{avail}G]",)
status.register("disk",
        path="/mnt/BigMamaMedia/",
        format="BMM: {used}/{total}G [{avail}G]",)
status.register("disk",
        path="/mnt/BigMama2/",
        format="BM2: {used}/{total}G [{avail}G]",)
status.register("disk",
        path="/mnt/SeagateMedia/",
        format="SM: {used}/{total}G [{avail}G]",)


# all my custom buttons
#status.register("text",
#        text="Off",
#        cmd_leftclick="sleep 1; xset dpms force off",
#        color="#44bbff")

#status.register("text",
#        text="Suspend",
#        cmd_leftclick="systemctl suspend",
#        color="#44bbff")

#status.register("text",
#        text="Screensaver",
#        cmd_leftclick="xscreensaver-command -activate",
#        color="#44bbff")

status.run()
