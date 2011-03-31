package Bookmark::MoCo::User;
use strict;
use warnings;
use Bookmark::MoCo;
use base qw(Bookmark::MoCo);

__PACKAGE__->table('user');

sub bookmarks {
    my $self = shift;
    return scalar moco('Bookmark')->search(
        where => {
            user_id => $self->id,
        },
        order => 'created_on DESC',
    );
}

sub add_bookmark {
    my $self = shift;
    my %args = @_;
    my $url = $args{url} or return undef;
    my $comment = $args{comment};

    my $entry = moco('Entry')->find(
        url => $url,
    );
    if (! $entry) {
        $entry = moco('Entry')->create(
            url        => $url,
        );
    }
    return undef if $self->already_has($entry);
    return moco('Bookmark')->create(
        user_id  => $self->id,
        entry_id => $entry->id,
        comment  => $comment || '',
    );
}

sub delete_bookmark {
    my ($self, $entry_id) = @_;
    my $bookmark = moco('Bookmark')->find(
        user_id  => $self->id,
        entry_id => $entry_id,
    ) or return;
    $bookmark->delete;
}

sub already_has {
    my ($self, $entry) = @_;
    return moco('Bookmark')->find(
        user_id  => $self->id,
        entry_id => $entry->id,
    ) ? 1 : 0;
}

1;
