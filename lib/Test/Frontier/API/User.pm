package Test::Frontier::API::User;

use strict;
use warnings;
use Test::More;
use Test::Deep;
use base 'Test::Frontier::API';

sub __user_info : Test(1) {
    my $self = shift;
    my $resp = $self->client->user_info;
    cmp_deeply($resp, { name => '', password => '', email => ''}, 'Call api method "user_info"') or diag(explain($resp));
}

1;

__END__

=head1 NAME

Test::Frontier::API::User - Unit Tests for Frontier::API::User module

=head1 TEST_METHODS

Below are test methods this module contains

=head2 __user_info

=cut
