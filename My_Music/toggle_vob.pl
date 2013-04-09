=head1

Renames all *.VOB files to *.avi and vice versa.
The input to the script is a folder. The script works on files only and does not recurse into subfolders.

x Install script into the Windows Explorer context menu
	x Test with a x) file x) folder ?) current directory
	/ Test with !) non-English filenames and x) spaces
? Check input to be a folder
x Filter dir entries: x) files only
x Check for error x) Print error
x Pause script
? implement dir separators in a portable way
x extract pause() into a *.pm
- add counters
- test
=cut

use Common;

my $dh;
if (!opendir($dh, $ARGV[0])) {
	warn "Failed to open directory ", $ARGV[0], ": $!";
	Common::pause();
	exit(1);
}

while (readdir $dh) {
	my $file = $ARGV[0] . '\\' . $_;
	if (! -f $file) {
		next;
	}
	
	print "$_\n";
}

closedir $dh;
Common::pause();

