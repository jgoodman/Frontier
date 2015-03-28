package Test::Frontier::Ship;

use strict;
use warnings;
use Test::More;
use Test::Deep;
use Test::Exception;
use base 'Test::Frontier::Obj';

sub has_subs { ( shift->SUPER::has_subs, qw(stats hull shields energy) ) }

sub test_new : Test(+1) {
    my $self = shift;
    my $ship = $self->SUPER::test_new(@_);
    cmp_deeply($ship, noclass({ stats => $self->_expect_stats }), 'Introspect Frontier::Ship object');
}

sub _expect_stats {
    my $self = shift;
    return {
        hull    => $self->is_int,
        shields => $self->is_int,
        energy  => $self->is_int,
    }
}

sub stats : Test(3) {
    my $self  = shift;
    my $stats = $self->obj->stats;
    ok($stats, 'Call stats method');
    isa_ok($stats, 'HASH');
    cmp_deeply($stats, $self->_expect_stats, 'Validate stats');
}

sub hull : Test(5) { shift->_test_stat('hull') }
sub shields : Test(5) { shift->_test_stat('shields') }
sub energy : Test(5) { shift->_test_stat('energy') }

sub _test_stat {
    my $self  = shift;
    my $stat  = shift or die 'Stat undef';
    my $ship  = $self->obj;
    my $value = $ship->$stat;
    ok($value, "Call $stat method");
    ok($value =~ m/^\d+$/, "$stat is integer value");
    my $new_value = $value + 1;
    is($ship->$stat($new_value), $new_value, "Set new value for $stat");
    is($ship->$stat, $new_value, "Get new value for $stat");
    throws_ok { $ship->$stat('aaa') } qr/$stat does not match type UINT/, "Throw error when non INT value passed into $stat";
}

1;

__END__

=head1 NAME

Test::Frontier::Ship - Unit Tests for Frontier::Ship module

=head1 TEST_METHODS

Below are test methods this module contains

=head test_new

Calls the parent test_name method, then does additional testing.

=head2 stats

=head2 hull

=head2 sheilds

=head2 energy

=cut
