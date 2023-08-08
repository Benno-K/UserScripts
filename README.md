# UserScripts
Collection of scripts to be run from
the users ~/bin/ directory.

## extipmailer
To be run frequently (by cron).
Sends an email whenever the external IP address changes.
### Requires:
extip, a script that echos
the current external IP.
### Files
~/.extip holds the IP for comparison

## fbdownmail
Check logfile of FRITZ!box for
DSL outages and send a mail if there
were outages. Reports each outage,
tracks the times and sums them up, all in German, because FRITZ!box is German snd provider is German.
### Options
- -takelogfrombox


fetches log directly from FRITZ!box, otherwise from the file
~/fblogs/fritzboxlog-all.txt

### Files
- ~/fblogs/fritzboxlog-all.txt

created by another script, fblogfetcher,(which calls fblogread), that reads all log messages from the FRITZ!box

## fblogfetcher
Fetches log data from FRITZ!box (all types, as you can see in the WebGUI as "System/Ereignisse/Alle", but only one day. If no date is specified it uses yesterdsy 

### Arguments

Specify yesterday or today or any other date to get the logs for that day. Off course it will return nothing at all if the requested date is before boot-time of the FRITZ!box.

## fblogread
called ny fblogfetcher 

Actually sends a query to FRITZ!box and returns ALL log messages since boot. Needs an user account on thr box.