package Frontier::MetaCommon;
use strict;
use warnings;
use Throw qw(throw);

our $args = {
    ship_id => {
        desc     => 'Your ship_id (provided by ship_new)', 
        type     => 'UINT',
        required => 1,
    },
    ship_name => {
        desc     => 'Displayed in board_info and ship_scan results',
        type     => 'STRING',
        required => 1,
    },
    ship_pass => {
        desc     => 'Required when performing any ship action',
        type     => 'STRING',
        required => 1,
    },
    board_name => {
        desc     => 'Displayed in board_info and board_list results', # matches the Respite::Server $api_brand
        type     => 'STRING',
        required => 1,
    },
    board_pass => {
        desc     => 'The new password all ships will need to connect to this board',
        type     => 'STRING',
        required => 1,
    },
    max_players => {
        desc     => 'Maximum number of ships allowed.  Note this includes Frontier controlled opponents.',
        type     => 'UINT',
        min      => 1,
        max      => 50, # may raise this at some point
        default  => 10,
    },
    spawn_frontier_ship => {
        desc     => 'Spawn a Frontier AI controlled ship when the board is created.',
        enum     => ['Orbiter'], # TODO make these work
        max_values => 49, # board_max_players - 1
        validate_if => 'spawn_frontier_ship',
    },
};

1;
