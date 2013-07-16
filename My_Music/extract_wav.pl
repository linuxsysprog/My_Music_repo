=head1

Extracts audio from AVI files in a folder.
The script does not recurse into subdirs.

=cut

use Common;
use Cwd;

my $dir = getcwd() . '/' . $ARGV[0];
if ($ARGV[1] eq 'gui') {
	$dir = $ARGV[0];
}

Common::find(\&wanted, $dir, '\.avi$');
Common::pause;

sub wanted {
	my $file = shift;
	$file =~ s/\.avi$//;
	
	my $cmd = "ffmpeg -y -i \"$dir/$file.avi\" \"$dir/$file.wav\"";
	
	`$cmd`;
	if ($? != 0) {
		Common::exit(1);
	}
}
