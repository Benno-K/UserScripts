#!/usr/bin/perl

############## License / Copyright ###############
# Author: Himbeertoni
# Email: Toni.Himbeer@fn.de
# Github: https://www.github.com/himbeer-toni
# 
# This script is available for
# public use under GPL V3 (see
# https://www.gnu.org/licenses/gpl-3.0.en.html )
############## License / Copyright ###############

use Getopt::Std;
use File::Temp;
use File::Basename;
use File::Copy;

my $seen=0;
my $comment = '#';
my $commentmark = '##';
my $searchmark = $commentmark;

sub usage () {
	my $bn = basename($0);
	print <<~"EOI";
	Usage: $bn [option [param]..] inputfile [outputfile]
	 The inputfile is mandatory
	 The outputfile is mandatory
	 The outputfile must not be given when one of
	  the options -b or -c are present
	 Options:
	  -b bsckup-file-suffix
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
	EOI
}

if ( ! getopts('b:c:hm:r') ) {
	usage;
	exit 1;
}

if ( $opt_h ) {
	my $bn = basename($0);
	usage;
	exit(0),
}

if ( $opt_m ) {
	if ( $opt_m =~ /^##/ ) {
		$commentmark=$opt_m;
	} else {
		$commentmark="## $opt_m";
	}
}
my $crn;

if ( $opt_c ) {
	$crnf = $opt_c;
} else {
	$crnf = "copyright.txt";
}

my $outfil;
if ( $opt_r || $opt_b ) {
	my $fh = File::Temp->new(TEMPLATE => "$ARGV[0]-XXXXXX");
	$ARGV[1] = sprintf("%s.tmp",$fh->filename);
	undef $fh;
}
if ( ( ( $#ARGV < 0 ) || ( $#ARGV > 1  ) ) ||
   ( ( $#ARGV == 0 ) && ( !$opt_r && !$opt_b ) ) ) {
	print STDERR "Wrong (number of) arguments\n";
	usage;
	exit(1);
}

open(CRN, '<', $crnf) or die "error opening $crnf: $!";
while (<CRN>) {
	$crn = sprintf("%s%s %s", $crn, $comment, $_);
}
close(CRN);

open(SRC, "<", $ARGV[0]) or die "error opening input $ARGV[0]";
open(DST, ">", $ARGV[1]) or die "error opening output $ARGV[1]";
while (<SRC>) {
	if ( /^$searchmark/ ) {
		if ( $seen == 1 ) {
			if ( ! $opt_m ) {
				chomp($commentmark = $_);
			}
			print DST "$commentmark\n$crn$commentmark\n";
		}
		$seen++;
	} else {
		if ( $seen != 1 ) {
			print DST;
		}
	}
}
if ( $seen == 0 ) {
	# Re-open source as we did not find a line where
	# to insert copyright information, so we put it
	# on top (after a possible she-bang)
	close SRC;
	open(SRC, "<$ARGV[0]") or die "error opening input $src";
	$_=<SRC>;
	# Truncate output file, we're starting over this
	# time inserting copyright at line 2
	close DST;
	open(DST, ">", $ARGV[1]) or die "error opening output $ARGV[1]";
	# Write first line that was read, followed by
	print DST;
	# copyright notice
	print DST "$commentmark\n$crn$commentmark\n";
	# and append the rest
	while (<SRC>) {
		print DST;
	}
}
close(SRC);
close(DST);
if ( $opt_b ) {
		copy($ARGV[0],$ARGV[0].$opt_b)|| die ( "Error in copying $ARGV[1] to $ARGV[0]: $!" );
		rename($ARGV[1],$ARGV[0])|| die ( "Error in renaming $ARGV[1] to $ARGV[0]: $!" );
} elsif ( $opt_r ) {
		rename($ARGV[1],$ARGV[0])|| die ( "Error in renaming $ARGV[1] to $ARGV[0]: $!" );
}
exit(0);
