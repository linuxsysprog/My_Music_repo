=head1

Slows down VO.AVI files in a folder.
The script does not recurse into subdirs.

=cut

use Common;
use Cwd;

my $dir = getcwd() . '/' . $ARGV[0];
if ($ARGV[1] eq 'gui') {
	$dir = $ARGV[0];
}

Common::find(\&wanted, $dir, '\.vo.avi$');
Common::pause;

sub wanted {
	my $file = shift;
	$file =~ s/\.vo.avi$//;
	
	foreach my $percentage (@Common::percentages) {
		my $fps = $Common::fps * ($percentage/100);
		
		my $avis_contents = <<END;
AviSource("$dir/$file.vo.avi")
AssumeFPS($fps)
ChangeFPS($Common::fps)
END

		my $vdub_contents = Common::get_vdub_contents($dir, $file, ".$percentage.vo.avi");
		
		Common::create_config_file("$dir/$Common::avis_config", $avis_contents);
		Common::create_config_file("$dir/$Common::vdub_config", $vdub_contents);

		my $cmd = "vdub /s \"$dir/$Common::vdub_config\" > vdub.log 2>&1";
		
		`$cmd`;
		if ($? != 0) {
			Common::exit(1);
		}
	}
}
