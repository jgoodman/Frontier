package Frontier::API::User;

use strict;
use warnings;
use Frontier::User;
use base 'Frontier::API';

sub __user_info__meta {
    return {
        desc => 'Query single user info',
        args => { },
        resp => { },
    },
}

sub __user_info {
    my ($self, $args) = @_;
    $self->validate_args($args);
    my $user = Frontier::User->new;
    return $user->stats;
}

1;
