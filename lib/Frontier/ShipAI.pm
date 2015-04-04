package Frontier::ShipAI;
use strict;
use warnings;
use config;
use Respite::Client;
use Data::Dumper;
use config;

sub new {
    my ($class,$args) = @_;
    $args ||= {};
    my $self = bless {%$args}, $class;
    if (!$args->{'ship_pass'}) { $args->{'ship_pass'} .= chr( int(rand(25) + 65) ) foreach ( 1 .. 10 ) }
    if (!$args->{'ship_name'}) { $args->{'ship_name'} = $class.'_'; $args->{'ship_name'} .= chr( int(rand(25) + 65) ) foreach ( 1 .. 10 ) }
    my $ship_data = $self->frontier->ship_new($args);
    die $ship_data unless $ship_data;
    $self->{'ship'} = $ship_data->data;
    warn "Ship name: ".$args->{'ship_name'}."\n";
    warn "Ship pass: ".$args->{'ship_pass'}."\n";
    return $self;
}

sub main { } # main loop for processing AI
sub main_sleep { 1 } # how many seconds to sleep before running main() again
sub main_keep_going { 1 } # should the main loop be called again
sub frontier { shift->{'frontier_client'} ||= do { Respite::Client->new({service=>'frontier'}); } }

1;
