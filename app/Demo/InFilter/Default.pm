package Demo::InFilter::Default;
use DBIx::Struct;
use Demo::Common;
use PEF::Front::Session;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;
use strict;
use warnings;

sub auth_to_author {
	my ($field, $def) = @_;
	my $is_author = 0;
	if ($def->{request}->cookies->{auth}) {
		my $session = PEF::Front::Session->new($def->{request});
		if (%{$session->data} && $session->data->{name}) {
			$field     = $session->data->{name};
			$is_author = $session->data->{is_author};
			print STDERR Dumper $session->data, $session->data->{is_oauth};
			if ($session->data->{is_oauth}) {
				$field = "anonymous-" . substr (md5_hex($field), 0, 4);
			}
		} else {
			my $author = get_author_from_auth($def->{request}->cookies->{auth});
			if ($author) {
				$field     = $author->name;
				$is_author = 1;
			}
		}
	}
	if (!$is_author) {
		$field =~ s/^\s*//;
		$field =~ s/\s*$//;
		$field =~ s/&/&amp;/g;
		$field =~ s/</&lt;/g;
		$field =~ s/>/&gt;/g;
		my $fake_author = one_row(author => {name => $field});
		if ($fake_author) {
			$field = "(fake) $field";
		}
	}
	$field;
}

1;
