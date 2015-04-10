package Frontier::ShipAI::Orbiter;
use strict;
use warnings;
use Data::Dumper;
use base qw(Frontier::ShipAI);
use Math::Trig;
use Frontier::Common;

sub main {
    my ($self) = @_;
    my $hello = $self->call(hello=>{});
    my $scan= $self->call(ship_scan=>{});
    my $ship = $scan->{'obj'}->{$self->{'ship_id'}};
    my $target = $scan->{'obj'}->{'1'};

    my $distance = Frontier::Common::distance($ship,$target); # orbit distance
    my $r = Frontier::Common::radians({x=>0,y=>0},{x=>200,y=>$distance});

    my $nav= $self->call(ship_navigation=>{ship_engine_power=>3.3,ship_radians=>$target->{'object_direction'}-$r});
}

1;
