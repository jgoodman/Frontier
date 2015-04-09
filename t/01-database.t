#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 8;

use_ok('DBD::Pg');
use_ok('config');
require_ok('Frontier::Common');
ok($config::config{'sql_db'},'Found database name');
ok($config::config{'sql_user'},'Found database username');
ok($config::config{'sql_pass'},'Found database password');

my $dbh = Frontier::Common::new_dbh();
ok($dbh,'DBH connected');

my ($test) = $dbh->selectrow_array("SELECT 'woot'");
cmp_ok($test,'eq','woot','SELECT worked');
