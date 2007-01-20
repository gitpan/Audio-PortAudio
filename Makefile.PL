#!/usr/bin/perl -w
use strict;

our $VERSION = 0.01;

use ExtUtils::MakeMaker;

open my $f,">","stream-constants.xs" or die "Can't make stream-constants.xs: $!";
for (qw(paFloat32 paInt16 paInt32 paInt24 paInt8 paUInt8)) {
    (my $perlname = lc($_)) =~ s/^pa//;
    print $f <<ENDC;

unsigned long
$perlname()
    CODE:
    RETVAL = $_;
    OUTPUT:
    RETVAL

ENDC
}

for (qw(paClipOff paDitherOff paNeverDropInput)) {
    my $perlname = $_;
    $perlname =~ s/^pa//;
    $perlname =~ s/([a-z])([A-Z])/${1}_${2}/;
    $perlname = uc($perlname);

    print $f <<ENDC;

unsigned long
$perlname()
    CODE:
    RETVAL = $_;
    OUTPUT:
    RETVAL

ENDC
}
close $f;

WriteMakefile(
    'NAME'		=> 'Audio::PortAudio',
    'VERSION_FROM'	=> 'PortAudio.pm', # finds $VERSION
    'PREREQ_PM'		=> {
			    'Test::More' => 0, 
			    'Audio::SndFile' => 0,
    }, # e.g., Module::Name => 1.i
    
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
       (AUTHOR     => 'Joost Diepenmaat <jdiepen AT cpan.org>') : ()),
    LIBS              => ['-lportaudio'], # e.g., '-lm'
    'EXE_FILES'		=> [],
    'OPTIMIZE'		=> '-O',
);

