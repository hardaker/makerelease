package Makerelease::Step;

use strict;
use Makerelease;

our @ISA=qw(Makerelease);

sub start_step {
    my ($self, $step) = @_;
}

sub print_description {
    my ($self, $step) = @_;
    print $step->{'text'}, "\n\n" if (exists($step->{'text'}));
}

sub finish_step {
    my ($self, $step) = @_;
    my $info = $self->getinput("---- PRESS ENTER TO CONTINUE ----");
}



1;

