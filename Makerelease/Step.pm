package Makerelease::Step;

use strict;
use Makerelease;

our @ISA=qw(Makerelease);

sub start_step {
    my ($self, $step) = @_;
}

sub possibly_skip_yn {
    my ($self, $step, $parentstep, $counter) = @_;
    if ($self->{'opts'}{'i'}) {
	my $info = $self->getinput("Do step $parentstep$counter (y,n)?");
	if ($info eq 'n') {
	    $self->output("... skipping step $parentstep$counter\n");
	    return 1;
	}
    }
    return 0;
}

sub possibly_skip_dryrun {
    my ($self, $step, $parentstep, $counter) = @_;
    return 1 if ($self->{'opts'}{'n'});
    return 0;
}

# return 1 to skip, 0 to do it
sub possibly_skip {
    my ($self, $step, $parentstep, $counter) = @_;

    # handle -n
    return 1 if ($self->possibly_skip_dryrun(@_));

    # handle -i
    return $self->possibly_skip_yn(@_);
}

sub print_description {
    my ($self, $step) = @_;
    my $text = $step->{'text'};
    $text =~ s/\n\s*//g;
    print $step->{'text'}, "\n\n" if (exists($step->{'text'}));
}

sub finish_step {
    my ($self, $step) = @_;
    sleep($self->{'opts'}{'s'}) if ($self->{'opts'}{'s'});
    return if (!$self->{'opts'}{'p'});
    my $info = $self->getinput("---- PRESS ENTER TO CONTINUE ----");
}

1;

