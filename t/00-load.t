#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 10;

# Libraries for Testing
require_ok('Test::Class');
require_ok('Test::Deep');
require_ok('Test::Exception');

# Libraries for Respite
require_ok('Respite::AutoDoc');
require_ok('Respite::Base');
require_ok('Respite::Client');
require_ok('Respite::CommandLine');
require_ok('Respite::Server::Test');
require_ok('Respite::Server');
require_ok('Respite::Validate');
