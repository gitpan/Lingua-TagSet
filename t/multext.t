#!/usr/bin/perl
# $Id: multext.t,v 1.1.1.1 2004/04/13 15:32:23 guillaume Exp $

use Lingua::TagSet::Multext;
use Test::More;
use strict;

# compute plan
open(T2S, 'multext2feature') or die "unable to open multext2feature: $!";
my @tags2strings = <T2S>;
close(T2S);
open(S2T, 'feature2multext') or die "unable to open feature2multext: $!";
my @strings2tags = <S2T>;
close(S2T);
plan tests => @tags2strings + @strings2tags;

foreach my $test (@tags2strings ) {
    chomp $test;
    my ($tag, $string) = split(/\t/, $test);
    is(Lingua::TagSet::Multext->tag2string($tag), $string, "$tag conversion"); 
}

foreach my $test (@strings2tags) {
    chomp $test;
    my ($string, $tag) = split(/\t/, $test);
    is(Lingua::TagSet::Multext->string2tag($string), $tag, "$string conversion"); 
}
