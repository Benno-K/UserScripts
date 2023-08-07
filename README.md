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

created by another script, fblogread, that reads all log messages from the FRITZ!box