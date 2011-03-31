package Bookmark::MoCo::Bookmark;
use strict;
use warnings;
use Bookmark::MoCo;
use base qw(Bookmark::MoCo);
use DateTime::Format::MySQL;

__PACKAGE__->table('bookmark');

__PACKAGE__->utf8_columns(qw/comment/);

__PACKAGE__->inflate_column(
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

sub entry {
    my $self = shift;
    return moco('Entry')->find(id => $self->entry_id);
}

sub user {
    my $self = shift;
    return moco('User')->find(id => $self->user_id);
}

__PACKAGE__->add_trigger(
    'before_create' => \&set_created_on
);

sub set_created_on {
  my ($class, $args) = @_;
  $args->{'created_on'} = DateTime::Format::MySQL->
    format_datetime(DateTime->now(time_zone => 'UTC'));
}

sub as_string {
    my $self = shift;
    return $self->entry->as_string .
        sprintf (
            "%s (%s)\n\n",
            $self->comment,
            $self->created_on->ymd('/')
        );
}

1;
