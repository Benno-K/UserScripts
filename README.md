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