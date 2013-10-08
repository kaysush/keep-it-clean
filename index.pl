#!/usr/bin/perl

use strict;
use MP3::Info qw(get_mp3tag);
use File::Copy qw(move);

# Data Directory where all the music files are kept
# When you change it make sure its a directory name 
# without leading or trailing '/' just directory name.
my $data_directory = '.music';

my $directory = shift @ARGV;
die "Error!!! Usage : perl index.pl <directory>" unless $directory;
chdir $directory or die "Can not change directory : $!";
print "Changing to  -----> $directory\n";
mkdir $data_directory or die "Can't create data directory : $!" unless ( -e $data_directory);

my @files = <*.mp3>;

foreach (@files){
	print "Moving $_ to .music/$_\n";
	move($_ , "$data_directory/$_");
}

chdir $data_directory or die "Error !!! can't find data directory : $!";
print "Collection meta data about files\n";

@files = map { "$data_directory/$_"} @files;