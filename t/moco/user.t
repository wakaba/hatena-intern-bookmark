package test::Bookmark::MoCo::User;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;
use Test::Bookmark;
use base qw(Test::Class);
use Test::More;
use Bookmark::MoCo;

sub _add_bookmark_success : Test(6) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;

    my $bookmark = $user->add_bookmark(
        url => $entry_url,
        comment => 'This is a test.',
    );
    isa_ok $bookmark, moco('Bookmark');
    isa_ok $bookmark->entry, moco('Entry');
    is $bookmark->entry->url, $entry_url;
    isa_ok $bookmark->user, moco('User');
    is $bookmark->user->name, 'onishi';
    is $bookmark->comment, 'This is a test.';
}

sub _add_bookmark_duplicate : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;

    my $bookmark = $user->add_bookmark(
        url => $entry_url,
        comment => 'This is a test.',
    );

    my $bookmark2 = $user->add_bookmark(
        url => $entry_url,
    );
    
    is $bookmark2, undef;
}

sub _add_bookmark_no_url : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;

    my $bookmark = $user->add_bookmark;
    is $bookmark, undef;
}

sub _delete_bookmark : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;

    my $bookmark = $user->add_bookmark(
        url => $entry_url,
        comment => 'This is a test.',
    );
    my $entry_id = $bookmark->entry->id;
    $bookmark = moco('Bookmark')->find(
        user_id => $user->id,
        entry_id => $entry_id,
    );

    $user->delete_bookmark($entry_id);
    
    my $bookmark2 = moco('Bookmark')->find(
        user_id => $user->id,
        entry_id => $entry_id,
    );
    ok !$bookmark2;
}

sub _already_has_yes : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;

    my $bookmark = $user->add_bookmark(
        url => $entry_url,
        comment => 'This is a test.',
    );
    my $entry = $bookmark->entry;

    ok $user->already_has($entry)
}

sub _already_has_no : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );

    ok !$user->already_has($entry)
}

__PACKAGE__->runtests;

1;

