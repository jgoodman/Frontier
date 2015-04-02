package Frontier::Obj::Ship;

use strict;
use warnings;
use base 'Frontier::Obj';

sub table { 'ship' }

sub meta {
    return {
        name => {
            desc => 'Ship name',
        },
    }
}

1;

__END__

=head1 NAME

Frontier::Obj::Ship

=head1 SYNOPSIS

This module abstracts a ship

=head1 METHODS

=head2 new

Constructor method which initializes stats for the ship object.

=cut
