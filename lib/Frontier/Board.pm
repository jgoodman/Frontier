package Frontier::Board;

use strict;
use warnings;
use Throw qw(throw);
use Frontier::MetaCommon;

sub new { __PACKAGE__ } # For Respite::Server

sub __new__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Start a new game board',
        args => {
            board_name => $Frontier::MetaCommon::args->{'board_name'},
            board_pass => $Frontier::MetaCommon::args->{'board_pass'},
            max_players => $Frontier::MetaCommon::args->{'max_players'},
            spawn_frontier_ship => $Frontier::MetaCommon::args->{'spawn_frontier_ship'},
        },
        resp => {
            board_name => $Frontier::MetaCommon::args->{'board_name'}->{'desc'},
        },
    };
}

sub __new {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __info__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Details about the players/ships for a board',
        args => {
            board_pass => $Frontier::MetaCommon::args->{'board_pass'},
        },
        resp => {
            board_name => $Frontier::MetaCommon::args->{'board_name'}->{'desc'},
            max_players => $Frontier::MetaCommon::args->{'max_players'}->{'desc'},
            players => [{
                ship_id => $Frontier::MetaCommon::args->{'ship_id'}->{'desc'},
                ship_name => $Frontier::MetaCommon::args->{'ship_name'}->{'desc'},
                TODO => 'other ship data will go here eventually',
            }],
        },
    };
}

sub __info {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __list__meta {
    my ($self,$args) = @_;
    return {
        desc => 'List of active or recently active boards',
        args => {},
        resp => {
            rows => [{
                board_name => $Frontier::MetaCommon::args->{'board_name'}->{'desc'},
                max_players => $Frontier::MetaCommon::args->{'max_players'}->{'desc'},
                TODO => 'other board info will go here eventually',
            }],
        },
    };
}

sub __list {
    my ($self,$args) = @_;
    {TODO=>1};
}

1;
