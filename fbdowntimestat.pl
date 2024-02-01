#!/usr/bin/perl

my $upstreammin=10000;
my $downstreammin=50000;
my $complaints=0;
my $acceptsecs=10;
my $totdownsecs=0;
my $totslowsecs=0;
my $skipnext=0;

my @skippat = ( "Die Internetverbindung wird kurz unterbrochen" );
my @downpat = ( 
		"Internetverbindung wurde getrennt.",
		"PPPoE-Fehler: Zeitüberschreitung.",
	      );
my @uppat = ( 
		"Internetverbindung wurde erfolgreich hergestellt.",
	      );

sub timediffsecs {
#	return 0 if ( !defined(@_[0]);
	my $t1 = shift @_;
	my $t2 = shift @_;
	my ($dp1,$tp1) = split '\/', $t1;
	my ($dp2,$tp2) = split '\/', $t2;
	my ($d1,$m1,$y1) = split '\.',$dp1;
	my ($H1,$M1,$S1) = split ':',$tp1;
	my ($d2,$m2,$y2) = split '\.',$dp2;
	my ($H2,$M2,$S2) = split ':',$tp2;
	my $secs1 = $S1 + $M1 * 60 + $H1 * 3600;
	my $secs2 = $S2 + $M2 * 60 + $H2 * 3600;
	return $secs2 - $secs1;
}

sub timehuman {
    my $resultstr = "";
    my $passedsecs = shift @_;
    my $rest = $passedsecs % (86400*7);
    my $w = ($passedsecs - $rest) / (86400*7);
    $passedsecs -= $w*86400*7;
    $rest %= 86400;
    if ($w > 0) {
	if ($w > 1) {
	    $resultstr .= sprintf "%d Wochen, ",$w;
	} else {
	    $resultstr .= sprintf "%d Woche, ",$w;
	}
    }
    my $d = ($passedsecs - $rest) / 86400;
    $passedsecs -= $d*86400;
    $rest %= 3600;
    if ($d > 0) {
	if ($d > 1) {
	    $resultstr .= sprintf "%d Tage, ",$d;
	} else {
	    $resultstr .= sprintf "%d Tag, ",$d;
	}
    }
    my $h = ($passedsecs - $rest) / 3600;
    $passedsecs -= $h*3600;
    $rest %= 60;
    if ($h > 0) {
	if ($h > 1) {
	    $resultstr .= sprintf "%d Stunden, ",$h;
	} else {
	    $resultstr .= sprintf "%d Stunde, ",$h;
	}
    }
    my $m = ($passedsecs - $rest) / 60;
    $passedsecs -= $m*60;
    if ($m > 0) {
	if ($m > 1) {
	    $resultstr .= sprintf "%d Minuten, ",$m;
	} else {
	    $resultstr .= sprintf "%d Minute, ",$m;
	}
    }
    if ($rest > 0) {
	if ($rest > 1) {
	    $resultstr .= sprintf "%d Sekunden, ",$rest;
	} else {
	    $resultstr .= sprintf "%d Sekunde, ",$rest;
	}
    }

#    printf "DBG: %dw %dd %dh %dm %ds\n",$w,$d,$h,$m,$rest;
#    print "DBG: $resultstr\n";
    $resultstr =~ s/(.*), $/$1/;
    return $resultstr;
}

my $downstate=0;
my $speedstate=0;
my ($downtime, $downline);
while (<STDIN>) {
	chomp();
	my ($date,$time,$line) = split '\t',$_;
	if (!defined($firsttime)) {
		$firsttime = "$date/$time";
	}
	$lasttime = "$date/$time";
	for my $p (@downpat) {
		if ( $line =~ /$p/ ) {
			if ($downstate == 0) {
				$downtime = "$date/$time";
				$downline = $line;
			}
			$downstate=1;
#print "DBG: downstate=$downstate".substr($line,0.40)."\n";
		}
	}	
	for my $p (@skippat) {
		if ( $line =~ /$p/ ) {
			$skipnext+=1;
#print "DBG: skipnext=$skipnext".substr($line,0.40)."\n";
		}
	}
	for my $p (@uppat) {
		if ( $line =~ /$p/ ) {
		   if (defined($downtime)) {
			$downstate=0;
			$complaints++;
			my $tdiff = timediffsecs($downtime,"$date/$time");
			if ($tdiff > $acceptsecs ) {
			    my $tdiffstr = timehuman($tdiff);
			    if ( $skipnext > 0) {
				    $skipnext--;
				    $complaints--;
#print "DBG: skipnext=$skipnext".substr($line,0.40)."\n";
			    } else {
				    $totdownsecs += $tdiff;
			    	    print <<EOI;
$complaints. Kein Internet für $tdiffstr
  von: $downtime
  bis: $date/$time

EOI
			    }
			} else {
				$complaints--;
			}
		    }
		}
#print "DBG: downstate=$downstate\n";
	}	
#print "DBG2: $date/$time:".substr($line,0.40)."\n";
	if ( $line =~ /kbit\/s/ ) {
		$line =~ s/.*mit (.*) kbit.*/$1/;
		my ($downstream,$upstream) = split '/',$line;
		if ( ($downstream < $downstreammin) ||
		     ($upstream < $upstreammin) ) {
			$speedstate=1;
			$lowtime = "$date/$time";
			$lowspeed = "$line";
		}
		if ( ($downstream >= $downstreammin) &&
		     ($upstream >= $upstreammin) ) {
		     if ($speedstate == 1) {
	              if (defined($lowtime)) {
			$speedstate=0;
			$complaints++;
			my $tdiff = timediffsecs($lowtime,"$date/$time");
			$totslowsecs += $tdiff;
			my $tdiffstr = timehuman($tdiff);
			if ($tdiff > $acceptsecs ) {
				print <<EOI;
$complaints. Mindergeschwindigkeit für $tdiffstr
  von: $lowtime ($lowspeed)
  bis: $date/$time ($line)

EOI
			} else {
				$complaints--;
			}     	
		}
		     }
	     	}
	}
}
if ($complaints > 0) {
    if ($totdownsecs > 0) {
	printf "Gesamtzeit ohne Internet:             %s\n",timehuman($totdownsecs);
    }
    if ($totslowsecs > 0) {
	printf "Gesamtzeit mit Mindergeschwindigkeit: %s\n",timehuman($totslowsecs);
    }
		if ($speedstate == 1) {
			$complaints++;
			my ($dwns,$ups) = split '\/',$lowspeed;
			print <<EOI;

$complaints. DERZEIT ANHALTENDE Mindergeschwindigkeit 
  seit $lowtime ($lowspeed)
  mit Datenraten von
  $dwns Kbit/s Downstream
  $ups Kbit/s Upstream

EOI
		}
exit $complaints;
    print "  (aus den Meldungen zwischen $firsttime bis $lasttime)\n";
}
printf "ss=$speedstate\n";
