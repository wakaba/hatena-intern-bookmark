package Bookmark::MoCo;
use strict;
use warnings;
use base qw/DBIx::MoCo/;
use UNIVERSAL::require;
use Exporter::Lite;
use Bookmark::DataBase;

our @EXPORT = qw/moco/;
our @EXPORT_OK = @EXPORT;

__PACKAGE__->db_object('Bookmark::DataBase');

sub moco (@) {
    my $model = shift;
    return __PACKAGE__ unless $model;
    $model = join '::', __PACKAGE__, $model;
    $model->require or die $@;
    $model;
}

$DBIx::MoCo::DataBase::DEBUG = 1 if $ENV{MOCO_DEBUG};

1;
