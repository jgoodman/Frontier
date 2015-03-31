#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 25;

# Libraries for Testing
# TODO: Move below into make file
require_ok('Test::Class');
require_ok('Test::Deep');
require_ok('Test::Exception');
require_ok('Sub::Override');

# Libraries for Respite
# TODO: Move below into make file
require_ok('Respite::AutoDoc');
require_ok('Respite::Base');
require_ok('Respite::Client');
require_ok('Respite::CommandLine');
require_ok('Respite::Server::Test');
require_ok('Respite::Server');
require_ok('Respite::Validate');

# Libraries utilized for Frontier
# TODO: Move below into make file
require_ok('Throw');

# Libraries for Frontier
require_ok('Frontier');
require_ok('Frontier::API');
require_ok('Frontier::API::Ship');
require_ok('Frontier::API::ShipStats');
require_ok('Frontier::Obj');
require_ok('Frontier::Obj::Ship');
require_ok('Frontier::Obj::ShipStats');
require_ok('Test::Frontier::API');
require_ok('Test::Frontier::API::Ship');
require_ok('Test::Frontier::API::ShipStats');
require_ok('Test::Frontier::Obj');
require_ok('Test::Frontier::Obj::Ship');
require_ok('Test::Frontier::Obj::ShipStats');
