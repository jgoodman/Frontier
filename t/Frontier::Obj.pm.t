#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Test::Frontier::Obj;

Test::Frontier::Obj->new->runtests();
