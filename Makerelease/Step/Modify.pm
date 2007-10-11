package Makerelease::Step::Modify;

use strict;
use Makerelease::Step;
use IO::File;

our @ISA=qw(Makerelease::Step);

sub step {
    my ($self, $step, $parentstep, $counter) = @_;

    foreach my $modify (@{$step->{'modifications'}[0]{'modify'}}) {
	my @files = glob($modify->{'files'});
	my $findregex = $modify->{'find'};
	my $replaceregex = $modify->{'replace'};

	foreach my $file (@files) {

	    $self->output("modifying $file\n");

	    my $in = new IO::File();
	    my $out = new IO::File();
	    $in->open("<$file") || die "ack: couldn't open $file";
	    $out->open(">$file.mrnew") || die "ack: couldn't open $file.mrnew";

	    while (<$in>) {
		s/$findregex/$replaceregex/g;
		print $out $_;
	    }

	    $in->close();
	    $out->close();
			
	    rename("$file","$file.bak");
	    rename("$file.mrnew","$file");
	}
    }
}

1;

