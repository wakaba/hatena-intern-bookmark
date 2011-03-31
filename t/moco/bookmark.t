package test::Bookmark::MoCo::Bookmark;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;
use Test::Bookmark;
use base qw(Test::Class);
use Test::More;
use Bookmark::MoCo;

sub _created_on : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    my $bookmark = moco('Bookmark')->create(
        user_id => $user->id,
        entry_id => $entry->id,
    );
    
    my $created = $bookmark->created_on;
    isa_ok $created, 'DateTime';
}

sub _entry : Test(2) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    my $bookmark = moco('Bookmark')->create(
        user_id => $user->id,
        entry_id => $entry->id,
    );

    my $entry2 = $bookmark->entry;
    isa_ok $entry2, moco('Entry');
    is $entry2->id, $entry->id;
}

sub _user : Test(2) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    my $bookmark = moco('Bookmark')->create(
        user_id => $user->id,
        entry_id => $entry->id,
    );

    my $user2 = $bookmark->user;
    isa_ok $user2, moco('User');
    is $user2->id, $user->id;
}

sub _as_string_no_comment : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    my $bookmark = moco('Bookmark')->create(
        user_id => $user->id,
        entry_id => $entry->id,
    );

    my $str = $bookmark->as_string;
    my $entry_str = $entry->as_string;
    like $str, qr[^\Q$entry_str\E \(\d{4}/\d{2}/\d{2}\)\n\n$];
}

sub _as_string_with_comment : Test(1) {
    use utf8;
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    my $bookmark = moco('Bookmark')->create(
        user_id => $user->id,
        entry_id => $entry->id,
        comment => "あいうえお",
    );

    my $str = $bookmark->as_string;
    my $entry_str = $entry->as_string;
    like $str, qr[^\Q$entry_str\Eあいうえお \(\d{4}/\d{2}/\d{2}\)\n\n$];
}

__PACKAGE__->runtests;

1;

