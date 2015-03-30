package Frontier::Ship;

use strict;
use warnings;
use base 'Frontier::Obj';

sub table { 'ship' }

sub meta {
    return {
        user_id => {
            join_class => 'Frontier::User',
        },
        name => {
            desc => 'Ship name',
        }
    }
}

1;

__END__

=head1 NAME

Frontier::Ship

=head1 SYNOPSIS

This module abstracts a ship

=head1 METHODS

=head2 new

Constructor method which initializes stats for the ship object.

=head2 stats

Returns a Frontier::ShipStats object pertaining to the Frontier::Ship object.

=cut
