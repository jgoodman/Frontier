#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 19;

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

# Libraries for Frontier
require_ok('Frontier');
require_ok('Frontier::API::Ship');
require_ok('Frontier::API');
require_ok('Frontier::Ship');
require_ok('Test::BaseClass');
require_ok('Test::Frontier::API::Ship');
require_ok('Test::Frontier::API');
require_ok('Test::Frontier::Ship');
