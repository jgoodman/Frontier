package Test::Frontier::API::ShipStats;

use strict;
use warnings;
use Test::More;
use Test::Deep;
use base 'Test::Frontier::API';

sub __ship_stats_info : Test(1) {
    my $self = shift;
    my $resp = $self->client->ship_stats_info;
    cmp_deeply($resp, {energy => 1, hull => 1, shields => 1}, 'Call api method "ship_stats_info"') or diag(explain($resp));
}

1;

__END__

=head1 NAME

Test::Frontier::API::ShipStats - Unit Tests for Frontier::API::Ship module

=head1 TEST_METHODS

Below are test methods this module contains

=head2 ship_info

=cut
