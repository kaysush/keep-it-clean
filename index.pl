#!/usr/bin/perl

use strict;
use MP3::Info qw(get_mp3tag);
use File::Copy qw(move);

# Hash to store the meta data of the files.
my %metadata;

my $directory = shift @ARGV;
die "Error!!! Usage : perl index.pl <directory>" unless $directory;
chdir $directory or die "Can not change directory : $!";
print "Changing to  -----> $directory\n";

# Looks only the files at the root of the directory
my @files = <*.mp3>;

# Get info of all the files and store that in the hash.
print "Collecting metadata about the files...\n";
foreach (@files){
	$metadata{$_} = get_mp3tag($_);
}


my @keys = sort keys %metadata;

# Start placing the files in the respective folders.
foreach (@files)  {
	my $album = $metadata{$_}->{ALBUM};
	
	# Replace any stray character from the album so that 
	# there is no problem when creating a folder with that name.
	$album =~ s/[^\w\s\(\)_]/_/g;

	# If there is no album for the given track then
	# move it to 'Other' album.
	$album = "Other" unless(defined $album && $album ne "");

	# Create the directory with the album name if don't exist already.
	mkdir $album or die "Can't create album directory $album : $!" unless (-e $album);

	# Actually move the file to its folder.
	move("$_" , "$album/$_") or die "Can't move the file $_ : $!" ;
}