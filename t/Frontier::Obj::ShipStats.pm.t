#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Test::Frontier::Obj::ShipStats;

Test::Frontier::Obj::ShipStats->new->runtests();
