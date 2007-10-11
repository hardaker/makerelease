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

	    my $ignoreerror = 0;

	    if (ref($command) eq 'HASH') {
		$ignoreerror = 1 if ($command->{'ignoreerrors'});
		$command = $command->{'content'};
	    }

	    $self->output("running '",$command,"'\n\n");
	    system("$command");
	    $status = $?;

	    if (!$ignoreerror && $status ne 0 ) {
		# command failed, prompt for what to do?
		my $dowhat = '';

		while ($dowhat eq '') {
		    $dowhat =
		      $self->getinput("failed: status=$? what now (c,r,q)?");
			
		    # if answered:
		    #   c => continue
		    #   q => quit
		    if ($dowhat eq 'c') {
			$status = 0;
		    } elsif ($dowhat eq 'q') {
			$self->output("Quitting at step '$parentstep$counter' as requested\n");
			exit 1;
		    } elsif ($dowhat eq 'r') {
			$self->output("-- re-running ----------\n");
		    } else {
			$self->output("unknown response: $dowhat\n");
			$dowhat = '';
		    }
		}
	    }
	    $self->output("\n");
	}
    }
}

1;

