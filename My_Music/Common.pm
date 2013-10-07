=head1

Part of My_Music/*.pl Perl scripts.

=cut

package Common;

$vdub_config = "test.jobs";
$avis_config = "myclip.avs";
$fps = 29.97;
@percentages = qw/25 6.25/;

sub pause {
	print "Press Enter to continue . . . ";
	<STDIN>;
}

sub exit {
	pause;
	exit @_;
}

sub find {
	my $wanted = shift;
	my $dir = shift;
	my $pattern = shift;
	
	if (! -d $dir) {
		warn "$dir is not a directory";
		return;
	}

	my $dh;
	if (!opendir($dh, $dir)) {
		warn "can't opendir $dir: $!";
		return;
	}

	while (readdir $dh) {
		if ($_ eq '.' || $_ eq '..') {
			next;
		}

		if (! -f "$dir/$_") {
			next;
		}

		if ($_ =~ /$pattern/i) {
			&{$wanted}($_);
		}
	}

	closedir $dh;
}

sub create_config_file {
	my $file = shift;
	my $contents = shift;
	
	my $fh;
	if (!open($fh, '>', $file)) {
		warn "cannot open $file for writing: $!";
		return;
	}
	
	print $fh $contents;
	
	close $fh;
}

sub get_vdub_contents {
	my $dir = shift;
	my $file = shift;
	my $ext = shift;

	my $trimmed_dir = $dir;
	$trimmed_dir =~ s/\\/\\\\/g;

	return <<END;
VirtualDub.Open("$trimmed_dir\\\\$avis_config");
VirtualDub.SaveAVI("$trimmed_dir\\\\$file$ext");
END
}

1;
