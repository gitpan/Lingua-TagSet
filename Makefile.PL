# $Id: Makefile.PL,v 1.3 2004/06/11 11:33:18 rousse Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Lingua::TagSet',
    'VERSION_FROM' => 'lib/Lingua/TagSet.pm',
    'AUTHOR'       => 'Guillaume Rousse',
    'PREREQ_PM'    => {
	'Lingua::Features' => 0.3,
	'Memoize'          => 0
    }
);
