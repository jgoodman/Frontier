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
    $self->{'board_name'} = $args->{'board_name'};
    if (!$args->{'ship_pass'}) { $args->{'ship_pass'} .= chr( int(rand(25) + 65) ) foreach ( 1 .. 10 ) }
    if (!$args->{'ship_name'}) { $args->{'ship_name'} = $class.'_'; $args->{'ship_name'} .= chr( int(rand(25) + 65) ) foreach ( 1 .. 10 ) }
    $self->{'ship_name'} = $args->{'ship_name'};
    $self->{'ship_pass'} = $args->{'ship_pass'};
    my $board_data = $self->call(board_new=>$args);
    my $ship_data = $self->call(ship_new=>$args);
    $self->{'ship_id'} = $ship_data->{'ship_id'};
    return $self;
}

sub main { } # main loop for processing AI
sub main_sleep { 1 } # how many seconds to sleep before running main() again
sub main_keep_going { 1 } # should the main loop be called again
sub frontier {
    my $self = shift;
    $self->{'frontier_client'} ||= do {
        Respite::Client->new({
            service=>'frontier',
            brand=>$self->{'board_name'},
        });
    }
}

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
