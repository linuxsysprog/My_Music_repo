=head1

Part of My_Music/*.pl Perl scripts.

=cut

package Common;

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

1;
