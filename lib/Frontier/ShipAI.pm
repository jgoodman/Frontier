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
    $self->{'ship_name'} = $args->{'ship_name'};
    $self->{'ship_pass'} = $args->{'ship_pass'};
    my $ship_data = $self->call(ship_new=>$args);
    $self->{'ship_id'} = $ship_data->{'ship_id'};
    return $self;
}

sub main { } # main loop for processing AI
sub main_sleep { 1 } # how many seconds to sleep before running main() again
sub main_keep_going { 1 } # should the main loop be called again
sub frontier { shift->{'frontier_client'} ||= do { Respite::Client->new({service=>'frontier'}); } }

# helper method to make easy api calls
sub call {
    my ($self,$method,$args) = @_;
    $args->{'ship_pass'} //= $self->{'ship_pass'};
    $args->{'ship_name'} //= $self->{'ship_name'};
    $args->{'ship_id'} //= $self->{'ship_id'};
    my $data = $self->frontier->run_method($method => $args);
    die $data unless $data;
    $data->data;
}

1;
