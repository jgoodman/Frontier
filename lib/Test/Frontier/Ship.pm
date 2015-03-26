package Test::Frontier::Ship;

use strict;
use warnings;
use Test::More;
use base 'Test::BaseClass';

sub has_subs { ( shift->SUPER::has_subs, qw(stats) ) }

sub stats : Test(2) {
    my $self  = shift;
    my $stats = $self->obj->stats;
    ok($stats, 'Call stats method');
    isa_ok($stats, 'HASH');
}

1;

__END__

=head1 NAME

Test::Frontier::Ship - Unit Tests for Frontier::Ship module

=head1 TEST_METHODS

Below are test methods this module contains

=head2 stats

=cut
