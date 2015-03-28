#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Test::Frontier::ShipStats;

Test::Frontier::ShipStats->new->runtests();
