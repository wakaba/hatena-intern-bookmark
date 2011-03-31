package test::Bookmark::MoCo::Entry;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;
use Test::Bookmark;
use base qw(Test::Class);
use Test::More;
use Bookmark::MoCo;

sub _url : Test(2) {
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    
    my $url = $entry->url;
    isa_ok $url, 'URI';
    is $url . '', $entry_url;
}

sub _created_on : Test(1) {
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    
    my $created = $entry->created_on;
    isa_ok $created, 'DateTime';
}

sub _bookmarks : Test(5) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    my $bookmark1 = moco('Bookmark')->create(
        user_id => $user->id,
        entry_id => $entry->id,
    );

    my $bookmarks = $entry->bookmarks;
    isa_ok $bookmarks, 'DBIx::MoCo::List';
    is $bookmarks->length, 1;
    
    my $bookmark2 = $bookmarks->[0];
    isa_ok $bookmark2, moco('Bookmark');
    is $bookmark2->user_id, $bookmark1->user_id;
    is $bookmark2->entry_id, $bookmark1->entry_id;
}

sub _as_string : Test(1) {
    my $user = moco('User')->find(name => 'onishi');
    my $entry_url = q<http://bookmark.test/?> . rand;
    my $entry = moco('Entry')->create(
        url => $entry_url,
    );
    $entry = moco('Entry')->find(url => $entry->url);

    is $entry->as_string, '['.$entry->id.'] ' . "\n" . $entry->url . "\n";
}

__PACKAGE__->runtests;

1;

