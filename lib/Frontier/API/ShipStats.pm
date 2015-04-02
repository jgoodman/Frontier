package Frontier::API::ShipStats;

use strict;
use warnings;
use Frontier::Obj::ShipStats;
use base 'Frontier::API';

sub __ship_stats_info__meta {
    return {
        desc => 'Query stats pertaining to a ship.',
        args => { },
        resp => { },
    },
}

sub __ship_stats_info {
    my ($self, $args) = @_;
    $self->validate_args($args);
    return Frontier::Obj::ShipStats->new($args->{'id'})->pretty;
}

1;
