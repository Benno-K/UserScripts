TARGETS = extipmailer fbdowntrack fblogfetcher fblogread fbpwdget fbpwdsave
UBINDIR = ~/bin/
all: $(TARGETS)
	install -m 755 -t $(UBINDIR) $(TARGETS)
usage:
	@echo "please use"
	@echo "  make fritz"
	@echo "  or"
	@echo "  make tools"

fritz: $(FBTARGETS)
	install -m 755 -t $(LBINDIR) $(FBTARGETS)

tools: $(TOOLTARGETS)
	install -m 755 -t $(LBINDIR) $(TOOLTARGETS)
