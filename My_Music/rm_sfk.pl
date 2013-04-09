=head1

A rm_sfk.bat rewrite in Perl.
Given a folder removes its files recursively which end with one of the extensions from the list.
The input to the script is a folder. The script works on files only.

x Install script into the Windows Explorer context menu
	x Test with a x) file x) folder ?) current directory
	/ Test with !) non-English filenames and x) spaces
? Check input to be a folder
x Remove files with File::Find x) find only files. For each file:
	x Check for error x) Print error
x Pause script
- add counters
- re-test

=cut

use Common;
use File::Find;
# Not a subroutine reference at C:/strawberry/perl/vendor/lib/File/Find/Rule.pm line 73.
# use File::Find::Rule;

my @rm_exts = qw/
BAK
DLL
EXE
PK
SFK
SFL
/;

find({ wanted => \&wanted }, $ARGV[0]);
Common::pause();

sub wanted {
	if (! -f $File::Find::name) {
		return;
	}
	
	foreach my $ext (@rm_exts) {
		if ($File::Find::name =~ /\.${ext}$/i) {
			if (unlink $File::Find::name) {
				print "Removed $File::Find::name\n";
			} else {
				warn "Failed to remove $File::Find::name: $!";
			}
			
			return;
		}
	}
}

