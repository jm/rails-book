#!/usr/bin/env perl
#
# $Id: multimarkdown2latex.pl 381 2007-05-14 18:09:19Z fletcher $
#
# Required for using MultiMarkdown
#
# Copyright (c) 2006-2007 Fletcher T. Penney
#	<http://fletcherpenney.net/>
#
# MultiMarkdown Version 2.0.b1
#

# Combine all the steps necessary to process MultiMarkdown text into LaTeX
# Not necessary, but might be easier than stringing the commands together
# manually


# Add metadata to guarantee we can transform to a complete XHTML
$data = "Format: complete\n";


# Parse stdin (MultiMarkdown file)

undef $/;
$data .= <>;


# Find name of XSLT File if specified, else use xhtml2memoir.xslt
$xslt_file = _XSLTFlavor($data);
$xslt_file = "memoir.xslt" if ($xslt_file eq "");


# Decide which flavor of SmartyPants to use
$language = _Language($data);
$SmartyPants = "SmartyPants.pl";

$SmartyPants = "SmartyPantsGerman.pl" if ($language =~ /^\s*german\s*$/i);

$SmartyPants = "SmartyPantsFrench.pl" if ($language =~ /^\s*french\s*$/i);

$SmartyPants = "SmartyPantsSwedish.pl" if ($language =~ /^\s*(swedish|norwegian|finnish|danish)\s*$/i);

$SmartyPants = "SmartyPantsDutch.pl" if ($language =~ /^\s*dutch\s*$/i);


# Create a pipe and process
$me = $0;				# Where am I?

# Am I running in Windoze?
my $os = $^O;


if ($os =~ /MSWin/) {
	$me =~ s/\\([^\\]*?)$/\\/;	# Get just the directory portion	

	open (MultiMarkdown, "| cd \"$me\"& .\\MultiMarkdown.pl | .\\$SmartyPants | xsltproc -nonet -novalid .\\$xslt_file - | .\\cleancites.pl");

} else {
	$me =~ s/\/([^\/]*?)$/\//;	# Get just the directory portion

	open (MultiMarkdown, "| cd \"$me\"; ./MultiMarkdown.pl | ./$SmartyPants | xsltproc -nonet -novalid ./$xslt_file - | ./cleancites.pl");
}


print MultiMarkdown $data;

close(MultiMarkdown);


sub _XSLTFlavor {
	my $text = shift;
	
	my ($inMetaData, $currentKey) = (1,'');
	
	foreach my $line ( split /\n/, $text ) {
		$line =~ /^$/ and $inMetaData = 0 and next;
		if ($inMetaData) {
			if ($line =~ /^([a-zA-Z0-9][0-9a-zA-Z _-]*?):\s*(.*)$/ ) {
				$currentKey = $1;
				$currentKey =~ s/  / /g;
				$g_metadata{$currentKey} = $2;
				if (lc($currentKey) eq "xslt file") {
					return $g_metadata{$currentKey};
				}
			} else {
				if ($currentKey eq "") {
					# No metadata present
					$inMetaData = 0;
					next;
				}
			}
		}
	}
		
	return;
}

sub _Language {
	my $text = shift;
	
	my ($inMetaData, $currentKey) = (1,'');
	
	foreach my $line ( split /\n/, $text ) {
		$line =~ /^$/ and $inMetaData = 0 and next;
		if ($inMetaData) {
			if ($line =~ /^([a-zA-Z0-9][0-9a-zA-Z _-]*?):\s*(.*)$/ ) {
				$currentKey = $1;
				$currentKey =~ s/  / /g;
				$g_metadata{$currentKey} = $2;
				if (lc($currentKey) eq "language") {
					return $g_metadata{$currentKey};
				}
			} else {
				if ($currentKey eq "") {
					# No metadata present
					$inMetaData = 0;
					next;
				}
			}
		}
	}
		
	return;
}