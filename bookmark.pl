#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib      "$FindBin::Bin/lib";
use lib glob "$FindBin::Bin/modules/*/lib";

use Encode;
use Term::Encoding qw/term_encoding/;
use Pod::Usage;

use Bookmark::MoCo;

my $user_name = 'onishi';

my %commands = (
    list => \&list_events,
    add  => \&add_events,
    del  => \&del_events,
);

my $user = moco('User')->find(name => $user_name)
    or die "No such user ($user_name)";

my $command = $commands{shift || 'list'}
    or pod2usage(2);

$command->($user, @ARGV);

sub list_events {
    my $user = shift;
    $user->bookmarks->each(
        sub {
            print encode(term_encoding, $_->as_string)
        }
    );
}

sub add_events {
    my ($user, $url, $comment) = @_;
    return unless $url;
    my $bookmark = $user->add_bookmark(
        url     => $url,
        comment => $comment,
    ) or return;
    print encode(term_encoding, $bookmark->as_string);
}

sub del_events {
    my ($user, $entry_id) = @_;
    $user->delete_bookmark($entry_id)
      or die "Couldn't delete bookmark with $entry_id";
}

__END__

=head1 NAME

bookmark.pl - a CLI for bookmark app

=head1 SYNOPSIS

  bookmark.pl list
    List all entries in your bookmark.

  bookmark.pl add <url> [comment]
    Add a new entry to your bookmark.

  bookmark.pl del <entry_id>
    Delete an entry with entry_id.

=cut
