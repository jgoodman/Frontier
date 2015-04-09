package Frontier::ShipAI::Orbiter;
use strict;
use warnings;
use Data::Dumper;
use base qw(Frontier::ShipAI);
use Math::Trig;

sub main {
    my ($self) = @_;
    my $hello = $self->call(hello=>{});
    my $scan= $self->call(ship_scan=>{});
    my $ship = $scan->{'obj'}->{$self->{'ship_id'}};

    my $nav= $self->call(ship_navigation=>{ship_engine_power=>7,ship_radians=>$ship->{'obj_radians'} + 0.2});
    #my $nav= $self->call(ship_navigation=>{ship_engine_power=>1,ship_radians=>1});
}

1;
