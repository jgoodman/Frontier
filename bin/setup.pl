#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use DBI;

use Frontier::User;
use Frontier::Ship;
use Frontier::ShipStats;

our $DEBUG = 1;

my $dbh = DBI->connect("dbi:SQLite:dbname=frontier.db","","");

foreach my $module (qw( Frontier::User Frontier::Ship Frontier::ShipStats)) {
    my $sql = $module->new->create_table_sql;
    warn "$sql\n" if $DEBUG;
    $dbh->do($sql);
}

my $user = Frontier::User->new;
$user->set_info('name', 'system');
$user->create;

__END__

=head1 NAME

=head1 DEVEL

This is a script to setup Frontier database

=cut
