package Frontier::Ship;

use strict;
use warnings;
use base 'Frontier::Base';

sub new {
    my $self = shift->SUPER::new(@_);
    $self->$_ foreach (qw(hull shields energy));
    return $self;
}

sub stats { return shift->{'stats'} //= { } }

sub hull { return shift->_get_or_set('hull', @_) }

sub shields { return shift->_get_or_set('shields', @_) }

sub energy { return shift->_get_or_set('energy', @_) }

sub _get_or_set {
    my $self  = shift;
    my $key   = shift;
    my $value = shift;
    my $stats = $self->stats;
    if(defined $value) {
        die "$key does not match type UINT" unless $value =~ m/^\d+$/;
        $stats->{$key} = $value;
    }
    return $stats->{$key} //= 1;
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

Returns a hashref pertaining to the objects stats.

=head hull

Get/set the INT value of "hull" which is a stat of a ship object.

=head2 shields

Get/set the  INT value of "shields" which is a stat of a ship object.

=head2 energy

Get/set the INT value of "energy" which is a stat of a ship object.

=cut
