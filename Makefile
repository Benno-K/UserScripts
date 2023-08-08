FBTARGETS = fbpwdsave fbpwdget fblogfetcher fblogread # fbdownmail
TOOLTARGETS = extipmailer
LBINDIR = /usr/local/bin
fritz: $(FBTARGETS)
	install -m 755 -t $(LBINDIR) $(FBTARGETS)
tools: $(TOOLTARGETS)
	install -m 755 -t $(LBINDIR) $(TOOLTARGETS)
