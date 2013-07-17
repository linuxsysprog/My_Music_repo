=head1

Slows down (speeds up) WAV files in a folder.
The script does not recurse into subdirs.

=cut

use Common;
use Cwd;

my $dir = getcwd() . '/' . $ARGV[0];
if ($ARGV[1] eq 'gui') {
	$dir = $ARGV[0];
}

my $phantom = "C:\\Program Files\\Phantom\\Phantom.exe";
my $phantom_script = "D:\\Aussie\\My_Music\\Phantom_scripts\\Transcribe.psc";

Common::find(\&wanted, $dir, '\.wav$');
Common::pause;

sub wanted {
	my $file = shift;
	$file =~ s/\.wav$//;
	
	foreach my $percentage (@Common::percentages) {
		my $script_args = "string filename = \\\"$dir\\$file\\\"; string rate = \\\"$percentage\\\"; ";
		
		my $cmd = "\"$phantom\" $phantom_script $script_args > Phantom.log 2>&1";
		
		`$cmd`;
		if ($? != 0) {
			Common::exit(1);
		}
	}
}
