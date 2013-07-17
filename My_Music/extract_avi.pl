=head1

Extracts video from AVI files in a folder.
The script does not recurse into subdirs.

=cut

use Common;
use Cwd;

my $dir = getcwd() . '/' . $ARGV[0];
if ($ARGV[1] eq 'gui') {
	$dir = $ARGV[0];
}

my $avis_config = "$dir/myclip.avs";
my $vdub_config = "$dir/test.jobs";

Common::find(\&wanted, $dir, '\.avi$');
Common::pause;

sub wanted {
	my $file = shift;
	$file =~ s/\.avi$//;
	
	my $avis_contents = <<END;
AviSource("$dir/$file.avi")
KillAudio
END

	my $trimmed_dir = $dir;
	$trimmed_dir =~ s/\\/\\\\/g;

	my $trimmed_avis_config = $avis_config;
	$trimmed_avis_config =~ s/\//\\/g;
	$trimmed_avis_config =~ s/\\/\\\\/g;

	my $vdub_contents= <<END;
VirtualDub.Open("$trimmed_avis_config");
VirtualDub.SaveAVI("$trimmed_dir\\\\$file.vo.avi");
END

	Common::create_config_file($avis_config, $avis_contents);
	Common::create_config_file($vdub_config, $vdub_contents);

	my $cmd = "vdub /s \"$vdub_config\"";
	
	`$cmd`;
	if ($? != 0) {
		Common::exit(1);
	}
}
