FBTARGETS = fbpwdsave fbpwdget fblogfetcher fblogread # fbdownmail
TOOLTARGETS = extipmailer
LBINDIR = /usr/local/bin
usage:
	@echo "please use"
	@echo "  make fritz"
	@echo "  or"
	@echo "  make tools"

fritz: $(FBTARGETS)
	install -m 755 -t $(LBINDIR) $(FBTARGETS)

tools: $(TOOLTARGETS)
	install -m 755 -t $(LBINDIR) $(TOOLTARGETS)
