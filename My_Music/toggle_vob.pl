=head1

Renames all *.VOB files to *.avi and vice versa in a folder.
The script does not recurse into subdirs.

x Install script into the Windows Explorer context menu
	x Test with a x) file x) folder ?) current directory
	/ Test with !) non-English filenames and x) spaces
x skip over . and ..
x adjust the script to run from Windows Explorer context menu
	x distinguish between shell arg and "%1"

=cut

use Common;
use Cwd;
use File::Basename;

my $dir = getcwd() . '/' . $ARGV[0];
if ($ARGV[1] eq 'gui') {
	$dir = $ARGV[0];
}

if (! -d $dir) {
	warn "$dir is not a directory\n";
	Common::exit(1);
}

# Reset counters
my $entries = 0;
my $plain_files = 0;
my @vob_files = ();
my @avi_files = ();
my $renamed = 0;
my $exists = 0;
my $failed = 0;

print "Renaming VOB<->avi in $dir\n";

my $dh;
if (!opendir($dh, $dir)) {
	warn "can't opendir $dir: $!\n";
	Common::exit(1);
}

while (readdir $dh) {
	if ($_ eq '.' || $_ eq '..') {
		next;
	}

	$entries++;

	my $file = "$dir/$_";
	
	if (! -f $file) {
		next;
	}
	$plain_files++;

	if ($file =~ /\.vob$/i) {
		push @vob_files, $file;
	} elsif ($file =~ /\.avi$/i) {
		push @avi_files, $file;
	}
}

closedir $dh;

print "Total entries (files and dirs) found: $entries\n";
print "Plain files found: $plain_files\n";
print "VOB files found: ", scalar @vob_files, "\n";
print "AVI files found: ", scalar @avi_files, "\n";

if (!@vob_files && !@avi_files) {
	print "Nothing to rename.\n";
	Common::exit;
}

rename_(\@vob_files, 'vob2avi');
rename_(\@avi_files, 'avi2vob');

print "Files renamed: $renamed\n";
if ($exists) {
	print "Files skipped (target exists): $exists\n";
}
if ($failed) {
	warn "Files failed to rename: $failed\n";
}

Common::pause;

sub rename_ {
	my $files = shift;
	my $direction = shift;

	foreach my $file (@$files) {
		my $new_file = $file;
		
		if ($direction eq 'vob2avi') {
			$new_file =~ s/\.vob$/\.avi/i;
		} else {
			$new_file =~ s/\.avi$/\.VOB/i;
		}
		
		my $msg = basename($file) . ' -> ' . basename($new_file);
		
		if (-e $new_file) {
			$exists++;
			warn "skipped (target exists) $msg\n";
			next;
		}
		
		my $ret = rename $file, $new_file;
		if ($ret) {
			$renamed++;
			print "$msg\n";
		} else {
			$failed++;
			warn "can't rename $msg: $!\n";
		}
	}
}

