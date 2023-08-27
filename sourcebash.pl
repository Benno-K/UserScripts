#!/usr/bin/perl -w
sub getkeycc {
  open(BASHSRC, '<', $_[0]) or die "failed to open file $_[0]";
  while (<BASHSRC>) {
    chomp;
    if (! m/^\s*keycc=/) {next};
    s/^\s*keycc=//;
    s/#.*//;
    s/\"//g;
    s/\'//g;
    $keycc=$_;
  }
  close BASHSRC;
  return $keycc;
}

printf "%s\n",getkeycc($ENV{HOME}.'/.fblogsrc');
exit;
