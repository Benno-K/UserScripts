# User-Scripts
Collection of scripts to be run from
the users ~/bin/ directory.
Usually they do not require
special permissions.

## bootcheck
Check if the system has been
rebooted since last check.
Intended to run frequently
by cron (e. g. every 15 mins)
Sends a mail to whichever
mail address is hardcoded
into script. Default is $USER.

## crnupdate
PERL script to update copyright notice of source files.

Here's how to use:
```
Usage: crnupdate [option [param]..] inputfile [outputfile]
 The inputfile is mandatory
 The outputfile is mandatory
 The outputfile must not be given when one of
  the options -b or -c are present
 Options:
  -b backup-file-suffix
     edit input file in place, but keep a backup
     file, the suffix will be appended to the
		 name of the inputfile
     e.g. -b .bck for file i.txt will get you
     i.txt.bck as backup. (do this twice and the
     original content will be gone!)
  -c copyright-filename
     specify the name of the file containing the
     copyright infos. If not given copyright.txt
     is used.
  -h this text is displayed
  -m copyright-marker-string
     give a new marker line for enclosing the
     copyright info. MUST start with ##
     otherwise ## will be prepended.
  -r replace the inputfile with the result
  -s stay silent if copyright notice is already
     up to date and no files where touched therefor
```

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
~/fblogs/fblog-YYYY.log where
YYYY represents the year

### Files
- ~/fblogs/fblog-YYYY.log where

created by another script, fblogfetcher,(which calls fblogread), that reads all log messages from the FRITZ!box

## fbdownstats
Create a statistic out of
the track-files that 
fbdowntrack stores

Gives a short summary of all tracked outages by date

Outputs something like

    2020-09-16  3m21s Low rate
    2020-09-16  13m41s DSL outage
    2020-11-04  3m11s DSL outage
    2020-11-10  1m38s DSL outage
    2020-11-20  14m9s DSL outage
    2021-10-26  14m17s DSL outage
    2022-02-07  14m12s DSL outage
    2022-05-11  15m13s DSL outage


(assuming you run it in autumn
2022 and have now track-files
before 2020 :-))

## fbyearstat
Takes all (or selected)
FRITZBOX!box log files to
create charts showing downtimes
and times of lowered speed of
the DSL-connection.

## fbdowntrack.personal-data.sample
Sample to demonstrate the 
settings that need to be 
incorporated for the mail

## fblogfetcher
Fetches log data from FRITZ!box (all types, as you can see in the WebGUI as "System/Ereignisse/Alle"), but only one day. If no date is specified it uses yesterday 

### Arguments

Specify yesterday or today or any other date to get the logs for that day. Off course it will return nothing at all if the requested date is before boot-time of the FRITZ!box.

## fblogread
called ny fblogfetcher 

Actually sends a query to FRITZ!box and returns ALL log messages since boot. Needs an user account on thr box.

### Files
Needs ~/.fblogsrc which must contain
a definition like this:

`keycc="UmVnaXN0cmllcnVuDfCpysK"`

That file is sourced by fblogread
to decrypt the contents of the 
credentials file (~/,fblogcred.logfetch) which
contains the crypted password
of the non-privileged account

## fbpwdget, fbpwdsave

Skripts to get an save the password 
out of a credentials file.

### Arguments:
#1: filepath to the credentials file

### Files
Needs ~/.fblogsrc which must contain
a definition like this:

`keycc="UmVnaXN0cmllcnVuDfCpysK`

That file is sourced by fblogread,
fbpwdget and fbpwdsave to decrypt 
the contents of the credentials file (~/,fböogcred.logfetch) which
contains the crypted password
of the non-privileged account
