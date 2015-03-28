#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 29;

# Libraries for Testing
require_ok('Test::Class');
require_ok('Test::Deep');
require_ok('Test::Exception');
require_ok('Sub::Override');

# Libraries for Respite
require_ok('Respite::AutoDoc');
require_ok('Respite::Base');
require_ok('Respite::Client');
require_ok('Respite::CommandLine');
require_ok('Respite::Server::Test');
require_ok('Respite::Server');
require_ok('Respite::Validate');

# Libraries utilized for Frontier
require_ok('Throw');

# Libraries for Frontier
require_ok('Frontier');
require_ok('Frontier::API');
require_ok('Frontier::API::Ship');
require_ok('Frontier::API::User');
require_ok('Frontier::Obj');
require_ok('Frontier::Ship');
require_ok('Frontier::ShipStats');
require_ok('Frontier::User');
require_ok('Frontier::UserShip');
require_ok('Test::Frontier::API');
require_ok('Test::Frontier::API::Ship');
require_ok('Test::Frontier::API::User');
require_ok('Test::Frontier::Obj');
require_ok('Test::Frontier::Ship');
require_ok('Test::Frontier::ShipStats');
require_ok('Test::Frontier::User');
require_ok('Test::Frontier::UserShip');
