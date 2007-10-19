package Makerelease::Step::Prompt;

use strict;
use Makerelease::Step;
use IO::File;

our $VERSION = "0.1";

our @ISA=qw(Makerelease::Step);

sub step {
    my ($self, $step, $parentstep, $counter) = @_;

    my $done = 0;
    my $answer;
    while (!$done) {
	$done = 1;
	$answer = $self->getinput($step->{'prompt'});
	if ($step->{'values'} && $answer !~ $step->{'values'}) {
	    $self->output("Illegal value; must match: $step->{'values'}\n");
	    $done = 0;
	}
    }
    $self->{'parameters'}{$step->{'parameter'}} = $answer;
}

sub document_step {
    my ($self, $step, $parentstep, $counter) = @_;

    $self->output("Decide on a value for parameter '$step->{parameter}'\n");
    $self->output("  prompt: $step->{parameter}\n");
    $self->output("  legal:  $step->{values}\n") if ($self->{'values'});
}

1;

