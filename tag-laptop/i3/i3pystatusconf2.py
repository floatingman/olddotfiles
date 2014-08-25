import subprocess

from i3pystatus import Status

status = Status(standalone=True)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#
status.register("clock",
        format="%a %-d %b %X KW%V",)

# Displays the weather like this:
#
status.register("weather",
        location_code="USTN0013:1",
        units="imperial",
        format="Antioch {current_temp}",
        interval=60)
status.register("weather",
        location_code="USTN0187:1",
        units="imperial",
        format="Franklin {current_temp}",
        interval=60)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
        format="♪: {volume}",)

# Show mpd status
status.register("mpd",
        format="{artist}-{album}-{title} {song_elapsed}/{song_length} {status}",
        status={
            "pause": "▷",
            "play": "▶",
            "stop": "◾",
        },)

status.run()
