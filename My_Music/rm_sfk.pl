=head1

A rm_sfk.bat rewrite in Perl.
Deletes files with certain extensions from a directory recursing into subdirs.

x Install script into the Windows Explorer context menu
	x Test with a x) file x) folder ?) current directory
	/ Test with !) non-English filenames and x) spaces

=cut

use Common;
use File::Find;
use Cwd;

if (! -d $ARGV[0]) {
	print $ARGV[0], " is not a directory\n";
	exit 1;
}

my @rm_exts = qw/
bak
dll
exe
pk
sfk
sfl
/;

# Reset counters
my $entries = 0;
my $plain_files = 0;
my $matching_files = 0;
my $unlinked = 0;
my $failed = 0;

print "Cleaning ", uc join(' ', sort @rm_exts), " out of ", getcwd(), '/', $ARGV[0], "\n";

find(\&wanted, $ARGV[0]);

# Print counters
print "Total entries (files and dirs) found: $entries\n";
print "Plain files found: $plain_files\n";
print "Files matching a pattern found: $matching_files\n";
if ($matching_files > 0) {
	print "Files successfully unlinked: $unlinked\n";
	print "Files failed to unlink: $failed\n";
} else {
	print "Nothing to unlink.\n";
}

Common::pause();

sub wanted {
	$entries++;
	
	my $file = getcwd() . '/' . $_;
	
	if (! -f $file) {
		return;
	}
	$plain_files++;
	
	my $matched = 0;
	foreach my $ext (@rm_exts) {
		if ($file =~ /\.${ext}$/i) {
			$matched = 1;
			last;
		}
	}
	if (!$matched) {
		return;
	}
	$matching_files++;
	
	my $ret = unlink $file;
	if ($ret) {
		$unlinked++;
		print "unlinked $file\n"
	} else {
		$failed++;
		print "failed to unlink $file: $!\n"
	}
}

