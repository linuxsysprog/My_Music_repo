=head1

A rm_sfk.bat rewrite in Perl.
Deletes files with certain extensions from a directory recursing into subdirs.

x Install script into the Windows Explorer context menu
	x Test with a x) file x) folder ?) current directory
	/ Test with !) non-English filenames and x) spaces
x print errors with warn "\n"
x make output consistent with toggle vob script

=cut

use Common;
use File::Find;
use Cwd;

my $dir = getcwd() . '/' . $ARGV[0];
if ($ARGV[1] eq 'gui') {
	$dir = $ARGV[0];
}

if (! -d $dir) {
	warn "$dir is not a directory\n";
	Common::exit(1);
}

my @rm_exts = qw/
bak
dll
exe
pk
scc
sfk
sfl
peak
/;

# Reset counters
my $entries = 0;
my $plain_files = 0;
my $matching_files = 0;
my $unlinked = 0;
my $failed = 0;

print "Cleaning ", uc join(' ', sort @rm_exts), " out of $dir\n";

find(\&wanted, $dir);

# Print counters
print "Total entries (files and dirs) found: $entries\n";
print "Plain files found: $plain_files\n";
print "Files matching a pattern found: $matching_files\n";
if (!$matching_files) {
	print "Nothing to unlink.\n";
	Common::exit(1);
}
print "Files unlinked: $unlinked\n";
if ($failed) {
	warn "Files failed to unlink: $failed\n";
}

Common::pause;

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
		warn "failed to unlink $file: $!\n"
	}
}

