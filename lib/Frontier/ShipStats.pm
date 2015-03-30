package Frontier::ShipStats;

use strict;
use warnings;
use base 'Frontier::Obj';

sub table { 'ship_stats' }

sub meta {
    return {
        ship_id => {
            join_class => 'Frontier::Ship',
        },
        hull => {
            desc    => 'Hull',
            type    => 'UINT',
            default => 1,
        },
        shields => {
            desc    => 'Shields',
            type    => 'UINT',
            default => 1,
        },
        energy => {
            desc    => 'Energy',
            type    => 'UINT',
            default => 1,
        },
    }
}

1;

__END__

=head1 NAME

Frontier::ShipStats

=head1 SYNOPSIS

This module abstracts stats for a ship object

=head1 METHODS

=cut
