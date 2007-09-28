package Makerelease;

use strict;

our $VERSION = "0.1";

# note: this new clause is used by most sub-modules too, altering it
# will alter them.
sub new {
    my $type = shift;
    my ($class) = ref($type) || $type;
    my $self = {};
    %$self = @_;
    bless($self, $class);
    return $self;
}

sub process_steps {
    my ($self, $relinfo, $parentstep) = @_;
    my $counter;
    foreach my $step (@{$relinfo->{'steps'}[0]{'step'}}) {
	$counter++;

	# print the step header
	$self->start_step("$parentstep$counter", $step->{'title'});

	# make sure we can load it before bailing with -n
	my $steptype = $step->{'type'};
	my $steptypecap = $steptype;
	$steptypecap =~ s/^(.)/uc($1)/e;
	my $module = "Makerelease::Step::$steptypecap";
	my $haveit = eval "require $module";
	if (!$haveit) {
	    print STDERR
	      "Could not load a module for release step type \"$steptype\";\n";
	    print STDERR
	      "  Tried: $module\n";
	    print STDERR
	      "  Error: $@\n";
	    die;
	}

	# create a module instance
	my $stepmodule = eval "new $module";
	print "here: " . ref($stepmodule) . "\n";
	if (!$stepmodule) {
	    print STDERR
	      "Can't create an instance of the \"step\" module\n";
	    print STDERR
	      "  Tried: $module\n";
	    print STDERR
	      "  Error: $@\n";
	    die;
	}

	# auto-inherit some parameters
	$stepmodule->{'opts'} = $self->{'opts'};
	$stepmodule->{'master'} = $self;

	# print description of the step if it exists
	$stepmodule->print_description($step);

	# skip running the step if this is a dry run.
	next if ($self->{'opts'}{'n'});

	# XXX: interactive prompt to do step here

	# XXX: skip up to step based on number here

	# XXX: skip up to step based on nmae here

	$self->DEBUG("processing step: $parentstep.$counter: type=$step->{'type'}\n");

	$stepmodule->step($step, $parentstep, $counter);
	$stepmodule->finish_step($step);
	next;

	die "illegal step type: $step->{'type'}\n";
    }
}

sub start_step {
    my ($self, $vernum, $vername) = @_;
    print STDERR "\n********** STEP: $vernum: $vername **********\n";
}

sub getinput {
    my ($self, $prompt) = @_;
    print "$prompt\n" if ($prompt);
    my $bogus = <STDIN>;
    return $bogus;
}

sub DEBUG {
    my ($self, @args) = @_;
    if ($self->{'opts'}{'v'}) {
	print STDERR @args;
    }
}

1;

=head1 NAME

Makerelease - A base perl module for Makerelease Plugins

=head1 SYNOPSIS



=head1 DESCRIPTION



=cut



