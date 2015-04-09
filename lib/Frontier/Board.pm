package Frontier::Board;

use strict;
use warnings;
use Throw qw(throw);
use Frontier::MetaCommon;
use Digest::SHA qw(sha256_hex);

sub new {
    my ($class,$server) = @_;
    my $self = bless {server=>$server}, $class;
    $self;
} # For Respite::Server

# pg_hba.conf change from "peer" to "md5" auth
# create database frontier
# create user frontier password 'change me';
# GRANT ALL PRIVILEGES ON DATABASE frontier to frontier;
# create table boards(board_id INTEGER PRIMARY KEY NOT NULL, board_name VARCHAR(100) NOT NULL,board_pass VARCHAR(100) NOT NULL,max_players SMALLINT,last_used INTEGER,UNIQUE(board_name));
sub dbh { my $self = shift; $self->{'server'}->{'base'}->dbh; } # TODO shoudln't need to make this in each method

sub enc {
    my ($self,$args) = @_;
    sha256_hex($config::config->{'salt'},$args->{'board_name'},$args->{'board_pass'});
}

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

    my $board_pass_enc = $self->enc($args);

    my $old_autocommit = $self->dbh->{AutoCommit};
    local $self->dbh->{AutoCommit} = 0;
    my $board = $self->dbh->selectrow_hashref('SELECT * FROM boards WHERE board_name = ?',{},$args->{'board_name'});
    if (!$board) {
        local $self->dbh->{'PrintError'} = 0;
        $self->dbh->do('INSERT INTO boards (board_name,board_pass,max_players) VALUES (?,?,?)',{},$args->{'board_name'},$board_pass_enc,$args->{'max_players'});
        $board = $self->dbh->selectrow_hashref('SELECT * FROM boards WHERE board_name = ?',{},$args->{'board_name'});
    }
    $self->dbh->commit unless $old_autocommit;
    throw 'Unable to create board.  Perhaps someone else has already used that board_name.' unless $board;
    throw 'Board found, but password does not match.' unless $board->{'board_pass'} eq $board_pass_enc;

    $self->__info($args);
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
    my $board_pass_enc = $self->enc($args);
    my $board = $self->dbh->selectrow_hashref('SELECT * FROM boards WHERE board_name = ?',{},$args->{'board_name'});
    throw 'Board not found.' unless $board;
    throw 'Board found, but password does not match.' unless $board->{'board_pass'} eq $board_pass_enc;

    delete $board->{'board_pass'};
    delete $board->{'last_used'};
    $self->dbh->do('UPDATE boards SET last_used = extract(epoch FROM now()) WHERE board_name = ?',{},$args->{'board_name'});
    $board;
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
    my $sth = $self->dbh->prepare('SELECT board_name,max_players FROM boards');
    $sth->execute;
    {
        rows=>$sth->fetchall_arrayref({}),
    };
}

1;
