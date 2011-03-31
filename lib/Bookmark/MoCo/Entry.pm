package Bookmark::MoCo::Entry;
use strict;
use warnings;
use Bookmark::MoCo;
use base qw(Bookmark::MoCo);

use DateTime::Format::MySQL;
use URI;
use Web::Scraper;

our $NoHttpAccess;

__PACKAGE__->table('entry');

__PACKAGE__->utf8_columns(qw/title/);

__PACKAGE__->inflate_column(
    url        => 'URI',
    created_on => {
        deflate => sub {
            if ($_[0]) {
                return DateTime::Format::MySQL->format_datetime($_[0]);
            } else {
                return '0000-00-00 00:00:00';
            }
        },
        inflate => sub {
            if ($_[0] && $_[0] ne '0000-00-00 00:00:00') {
                return DateTime::Format::MySQL->parse_datetime($_[0]);
            }
        },
    },
);

sub bookmarks {
    my $self = shift;
    return scalar moco('Bookmark')->search(
        where => {
            entry_id => $self->id,
        },
        order => 'created_on ASC',
    );
}

__PACKAGE__->add_trigger(
    'before_create' => \&set_created_on
);

__PACKAGE__->add_trigger(
    'before_create' => \&set_title
);

sub set_created_on {
  my ($class, $args) = @_;
  $args->{'created_on'} = DateTime::Format::MySQL->
    format_datetime(DateTime->now(time_zone => 'UTC'));
}

sub set_title {
    my ($class, $args) = @_;
    return if $NoHttpAccess;
    my $uri = URI->new($args->{url}) or return;
    my $scraper = scraper {
        process 'title', title => 'TEXT',
    };
    $args->{title} = $scraper->scrape($uri)->{title};
}

sub as_string {
    my $self = shift;
    sprintf "[%d] %s\n%s\n", $self->id, $self->title, $self->url;
}

1;
