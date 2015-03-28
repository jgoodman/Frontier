package Frontier::Base::Ship;

use strict;
use warnings;
use Frontier::Ship;
use base 'Frontier::Base';

sub __ship_info__meta {
    return {
        desc => 'Query single ship',
        args => { },
        resp => { },
    },
}

sub __ship_info {
    my ($self, $args) = @_;
    $self->validate_args($args);
    my $ship = Frontier::Ship->new;
    return $ship->stats;
}

1;
