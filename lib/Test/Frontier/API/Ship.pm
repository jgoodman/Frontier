package Test::Frontier::API::Ship;

use strict;
use warnings;
use Test::More;
use Test::Deep;
use base 'Test::Frontier::API';

sub __ship_info : Test(1) {
    my $self = shift;
    my $resp = $self->client->ship_info;
    cmp_deeply($resp, {id => 1, name => 'foo ship-name1'}, 'Call api method "ship_info"') or diag(explain($resp));
}

1;

__END__

=head1 NAME

Test::Frontier::API::Ship - Unit Tests for Frontier::API::Ship module

=head1 TEST_METHODS

Below are test methods this module contains

=head2 ship_info

=cut
