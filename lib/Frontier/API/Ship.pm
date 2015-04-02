package Frontier::API::Ship;

use strict;
use warnings;
use Frontier::Obj::Ship;
use base 'Frontier::API';

sub __ship_info__meta {
    return {
        desc => 'Query single ship info',
        args => { },
        resp => { },
    },
}

sub __ship_info {
    my ($self, $args) = @_;
    $self->validate_args($args);
    return Frontier::Obj::Ship->new($args->{'id'})->pretty;
}

1;
