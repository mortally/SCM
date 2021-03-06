#!/usr/bin/perl

$game=$ARGV[0];

#@bounds = [1000, 500, 205, 430];
@lbounds = (0, 0, 0, 0, 0);
@ubounds = (10000, 10000, 10000, 6);
         
open (GAMETEST,"./messageAggregator.sh  $game |");

while(<GAMETEST>) {
    @line = split(/ /);

    # Check for dummy agents
    if ( $line[0] =~ /[dD]ummy.*/) {
       exit(1);
    }
    
    $agent = $line[0];
    chop($agent);
    
    $length = $#line;

    # Bounds checking
    for($i=0;$i<5;$i++) {
        if($lbounds[$i] > $line[$length-3+$i] || $ubounds[$i] < $line[$length-3+$i]) {
	    exit(1);
        }   
    }
}

close GAMETEST;
