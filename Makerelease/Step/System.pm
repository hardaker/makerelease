package Makerelease::Step::System;

use strict;
use Makerelease::Step;

our @ISA=qw(Makerelease::Step);

sub step {
    my ($self, $step, $parentstep, $counter) = @_;

    foreach my $command (@{$step->{'commands'}[0]{'command'}}) {
	my $status = 1;

	# run it till we get a succeesful result or they bail on us
		
	while ($status ne '0') {
	    print STDERR "  running '",$command,"'\n\n";
	    system("$command");
	    $status = $?;

	    if ($status ne 0 ) {
		# command failed, prompt for what to do?
		my $dowhat = '';

		while ($dowhat eq '') {
		    $dowhat = getinput("failed: status=$? what now?");
			
		    # if answered:
		    #   c => continue
		    #   q => quit
		    if ($dowhat eq 'c') {
			$status = 0;
		    } elsif ($dowhat eq 'q') {
			exit 1;
		    } else {
			print "unknown response: $dowhat\n";
			$dowhat = '';
		    }
		}
	    }
	    print "\n";
	}
    }
}

1;

