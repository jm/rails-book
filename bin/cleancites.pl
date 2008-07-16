#!/usr/bin/env perl
#
# $Id: cleancites.pl 381 2007-05-14 18:09:19Z fletcher $
#
# Adds some utilities for making fancier citations with natbib
#
# Copyright (c) 2006-2007 Fletcher T. Penney
#	<http://fletcherpenney.net/>
#
# MultiMarkdown Version 2.0.b1
#


undef $/;
$data = <>;

# Clean up strings of \cites into one citation

while ($data =~ s{
	(\\cite[tp]?\*?)((?:\[(?:see|e\.g\.)\]\[\])?\{)(.*?)\}
	\1\{(.*?)\}
}{
	$1 . "$2$3, $4\}";	
}egmx) {
	
	
}


# And clean up custom cites that got escaped
# e.g. $\backslash$citeyearpar\{Dewey:1997\}

$data =~ s{
	\$\\backslash\$(cite.*?)
	\\\{(.*?)\\\}
}{
	"\\" . $1 . "{$2}";
}egmx;

print $data;