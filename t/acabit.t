#!/usr/bin/perl
# $Id: acabit.t,v 1.1 2004/05/19 13:38:56 rousse Exp $

use Lingua::TagSet::Acabit;
use Test::More;
use strict;

# compute plan
open(T2S, 'acabit2feature') or die "unable to open acabit2feature: $!";
my @tags2strings = <T2S>;
close(T2S);
open(S2T, 'feature2acabit') or die "unable to open feature2acabit: $!";
my @strings2tags = <S2T>;
close(S2T);
plan tests => @tags2strings + @strings2tags;

foreach my $test (@tags2strings ) {
    chomp $test;
    my ($tag, $string) = split(/\t/, $test);
    is(Lingua::TagSet::Acabit->tag2string($tag), $string, "$tag conversion"); 
}

foreach my $test (@strings2tags) {
    chomp $test;
    my ($string, $tag) = split(/\t/, $test);
    is(Lingua::TagSet::Acabit->string2tag($string), $tag, "$string conversion"); 
}
