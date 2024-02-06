SHELL = /bin/bash
TARGETS = extipmailer fbdowntrack fblogfetcher fblogread fbpwdget fbpwdsave fbdownstats crnupdate bootcheck fbyearstat fbdowntimestat.pl fbrateplot fbratestat
UBINDIR = ~/bin/
all: $(TARGETS)
	@for n in $(TARGETS);\
	do \
	diff -q $$n $(UBINDIR)/$$n > /dev/null;\
	if [ "$$?" != "0"	];then \
	   echo install -m 755 -t $(UBINDIR) $$n;\
	   install -m 755 -t $(UBINDIR) $$n;\
	fi;\
	done

copyright: $(TARGETS)
	crnupdate $(TARGETS)
usage:
	@echo "please use"
	@echo "  make fritz"
	@echo "  or"
	@echo "  make tools"

fritz: $(FBTARGETS)
	install -m 755 -t $(LBINDIR) $(FBTARGETS)

tools: $(TOOLTARGETS)
	install -m 755 -t $(LBINDIR) $(TOOLTARGETS)
