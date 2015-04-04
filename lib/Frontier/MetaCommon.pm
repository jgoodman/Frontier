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
    board_id => {
        desc     => 'Your board_id (provided by board_new)',
        type     => 'UINT',
        required => 1,
    },
    board_name => {
        desc     => 'Displayed in board_info and board_list results',
        type     => 'STRING',
        required => 1,
    },
    board_pass => {
        desc     => 'The new password all ships will need to connect to this board',
        type     => 'STRING',
        required => 1,
    },
};

1;
