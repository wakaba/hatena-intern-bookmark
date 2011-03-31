package Test::Bookmark;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->parent->parent->subdir('lib')->stringify;
use lib glob file(__FILE__)->dir->parent->parent->parent->subdir('modules/*/lib')->stringify;
use Bookmark::DataBase;

Bookmark::DataBase->dsn('dbi:mysql:dbname=mybookmark_test');

{
    no warnings 'once';
    $Bookmark::MoCo::Entry::NoHttpAccess = 1;
}

1;
