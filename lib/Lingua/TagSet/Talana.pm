# $Id: Talana.pm,v 1.1.1.1 2004/04/13 15:32:23 guillaume Exp $
package Lingua::TagSet::Talana;

=head1 NAME

Lingua::TagSet::Talana - Talana tagset for Lingua::TagSet

=cut

use base qw/Lingua::TagSet/;
use strict;

our @id_maps = (
    {
	features => [ 'adj' ],
	tokens   => [ 'A' ],
	submap   => [ 'adj_type', 'gender', 'num' ]
    },
    {
	features => [ 'adv' ],
	tokens   => [ 'ADV' ]
    },
    {
	features => [ 'pron' , 'cli' ],
	tokens   => [ 'CL' ],
	submap   => [ 'case', 'pers', 'gender', 'num' ]
    },
    {
	features => [ 'cc' ],
	tokens   => [ 'C', 'C' ]
    },
    { 
	features => [ 'cs' ],
	tokens   => [ 'C', 'S' ]
    },
    {
	features => [ 'det' ],
	tokens   => [ 'D' ],
	submap   => [ 'det_type', 'gender', 'num' ]
     },
     {
	features => [ 'det', 'poss' ],
	tokens   => [ 'D', 'poss' ],
	submap   => [ 'pers', 'gender', 'num', 'numposs' ]
     },
    {
	features => [ 'noun' ],
	tokens   => [ 'N' ],
	submap     => [ 'noun_type', 'gender', 'num' ]
    },
    {
	features => [ 'verb' ],
	tokens   => [ 'V' ],
	submap   => [ undef, 'mode&tense', 'pers', 'num' ]
    },
    {
	features => [ 'pron' ],
	tokens   => [ 'PRO' ],
	submap   => [ 'pron_type', 'pers', 'gender', 'num' ]
    },
    {
	features => [ 'pron', 'poss' ],
	tokens   => [ 'PRO', 'poss' ],
	submap   => [ 'pers', 'gender', 'num', 'numposs' ]
    },
    {
	features => [ 'ponct' ],
	tokens   => [ 'PONCT' ],
    },
);

our %value_maps = (
    det_type_type => [
	[ qw/dem dem/ ],
	[ qw/ind ind/ ],
	[ qw/poss poss/ ],
	[ qw/int int/ ],
	[ qw/excl excl/ ],
	[ qw/part part/ ],
	[ qw/def def/ ],
	[ qw/card card/ ],
    ],
    adj_type_type => [
	[ qw/qual qual/ ],
	[ qw/ord ord/ ],
	[ qw/ind ind/ ],
	[ qw/int int/ ],
	[ qw/card card/ ],
    ],
    noun_type_type => [ 
	[ qw/C common/ ],
	[ qw/P proper/ ],
	[ qw/card ord/ ],
    ],
    pron_type_type => [
    	[ qw/dem dem/ ],
	[ qw/rel rel/ ],
	[ qw/ind ind/ ],
	[ qw/poss poss/ ],
	[ qw/int int/ ],
    ],
    mode_type => [ 
	[ qw/C cond/ ],
    	[ qw/I ind/ ],
	[ qw/F ind/ ],
	[ qw/G part/ ],
	[ qw/J ind/ ],
	[ qw/K part/ ],
	[ qw/P ind/ ],
	[ qw/S subj/ ],
	[ qw/T subj/ ],
	[ qw/Y imp/ ],
    ],
    tense_type => [ 
	[ qw/C pres/ ],
    	[ qw/I imp/ ],
	[ qw/F fut/ ],
	[ qw/G pres/ ],
	[ qw/J past/ ],
	[ qw/K past/ ],
	[ qw/P pres/ ],
	[ qw/S pres/ ],
	[ qw/T imp/ ],
	[ qw/Y pres/ ],
    ],
    pers_type => [
	[ qw/1 1/ ],
	[ qw/2 2/ ],
	[ qw/3 3/ ],
    ],
    gender_type => [
	[ qw/m masc/ ],
	[ qw/f fem/ ],
    ],
    num_type => [
	[ qw/p pl/ ],
	[ qw/s sing/ ],
    ],
    case_type => [
	[ qw/obj dat/ ],
	[ qw/obj gen/ ],
	[ qw/obj obl/ ],
	[ qw/obj acc/ ],
	[ qw/refl ref/ ],
	[ qw/suj nom/ ],
    ]
);

__PACKAGE__->_init();

sub tag2structure {
    my ($class, $tag) = @_;

    # fail fast
    return unless $tag;

    # split tag in parts
    my @tokens = split(/-/, $tag, 3);
    push(@tokens, split(//, pop(@tokens)));

    # convert special values
    @tokens = map { defined $_ ? $_ : '' } @tokens;

    # call generic routine
    return $class->SUPER::tag2structure(\@tokens, no_strict_align => 1);
}

sub structure2tag {
    my ($class, $structure) = @_;

    # call generic routine
    my @tokens = $class->SUPER::structure2tag($structure);

    # force minimum length
    $#tokens = 2 if $#tokens < 2;

    # handle special cases
    @tokens =
	map { ref $_ eq 'ARRAY' ? join('', @$_) : $_ }
	map { $_ ? $_ : '' }
	@tokens;

    # join tokens in tag
    my $tag = join('-', $tokens[0], $tokens[1], join('', @tokens[2 .. $#tokens]));

    return $tag;
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004, INRIA.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Guillaume Rousse <grousse@cpan.org>

=cut

1;
