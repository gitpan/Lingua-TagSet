# $Id: Makefile.PL,v 1.2 2004/04/16 13:31:38 guillaume Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Lingua::TagSet',
    'VERSION_FROM' => 'lib/Lingua/TagSet.pm',
    'AUTHOR'       => 'Guillaume Rousse',
    'PREREQ_PM'    => {
	'Lingua::Features' => 0.2,
	'Memoize'          => 0
    }
);
