#!/usr/bin/perl

use ExtUtils::MakeMaker;

%opts = (
	 'NAME'		=> 'Makerelease',
	 'PREREQ_PM'    => { XML::Simple => 0 },
	 'EXE_FILES' => [qw(makerelease)],
	);

WriteMakefile(%opts);
