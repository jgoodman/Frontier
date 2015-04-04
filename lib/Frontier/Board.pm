package Frontier::Board;

use strict;
use warnings;
use Throw qw(throw);

sub new { __PACKAGE__ } # For Respite::Server

sub __new__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Start a new game board',
        args => {
            board_name => $Frontier::MetaCommon::args->{'board_name'},
            board_pass => $Frontier::MetaCommon::args->{'board_pass'},
        },
        resp => {
            board_id => $Frontier::MetaCommon::args->{'board_id'}->{'desc'},
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
            board_id => $Frontier::MetaCommon::args->{'board_id'},
            board_pass => $Frontier::MetaCommon::args->{'board_pass'},
        },
        resp => {
            board_id => $Frontier::MetaCommon::args->{'board_id'}->{'desc'},
            players => [{
                ship_id => $Frontier::MetaCommon::args->{'ship_id'}->{'desc'},
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
                board_id => $Frontier::MetaCommon::args->{'board_id'}->{'desc'},
                board_name => $Frontier::MetaCommon::args->{'board_name'}->{'desc'},
                #curent_players => 'TODO',
                #max_players => 'TODO',
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
