package Frontier::ShipAI::Orbiter;
use strict;
use warnings;
use Data::Dumper;
use base qw(Frontier::ShipAI);

sub main {
    my ($self) = @_;
    my $hello = $self->call(hello=>{});
    warn "main loop - server time: ".$hello->{'server_time'}."\n";
}

1;
