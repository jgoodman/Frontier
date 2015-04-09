package Frontier::Ship;

use strict;
use warnings;
use Throw qw(throw);
use Frontier::MetaCommon;
use Digest::SHA qw(sha256_hex);
use Frontier::Common;
use Math::Trig;

sub new {
    my ($class,$server) = @_;
    my $self = bless {server=>$server}, $class;
    $self;
} # For Respite::Server

sub dbh { my $self = shift; $self->{'server'}->{'base'}->dbh; } # TODO shouldn't need to make this in each method

sub enc {
    my ($self,$args) = @_;
    sha256_hex($config::config->{'salt'},$self->{'server'}->{'base'}->api_brand,$args->{'ship_name'},$args->{'ship_pass'});
}

sub __new__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Create a new ship',
        args => {
            ship_name => $Frontier::MetaCommon::args->{'ship_name'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
            board_pass => $Frontier::MetaCommon::args->{'board_pass'},
            ship_image => {enum => ['ship.png','redship.png'],default=>'ship.png'},
        },
        resp => $self->__info__meta()->{'resp'},
    };
}

sub __new {
    my ($self,$args) = @_;

    $args->{'board_name'} = $self->{'server'}->{'base'}->api_brand;
    my $board = $self->{'server'}->{'base'}->call('board_info'=>$args);

    my $energy = 100;
    my $hull = 100;
    my $shield = 100;

    my $old_autocommit = $self->dbh->{AutoCommit};
    local $self->dbh->{AutoCommit} = 0;
    {
        #local $self->dbh->{'PrintError'} = 0;
        $self->dbh->do('INSERT INTO objects (board_id,hull,image) VALUES (?,?,?)',{},
            $board->{'board_id'},$hull,$args->{'ship_image'})
            or throw 'Could not create ship';
    }
    ($args->{'ship_id'}) = $self->dbh->selectrow_array('select last_value from object_id');
    $self->dbh->do('INSERT INTO ships (object_id,ship_name,ship_pass,board_id,energy,shield,ship_engine_power) VALUES (?,?,?,?,?,?,0)',{},
        $args->{'ship_id'},$args->{'ship_name'},$self->enc($args),$board->{'board_id'},$energy,$shield);
    $self->dbh->commit unless $old_autocommit;

    $self->__info($args);
}

sub __info__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Information about your ship',
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
        },
        resp => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'}->{'desc'},
        }
    };
}

sub __info {
    my ($self,$args) = @_;
    my $ship = $self->dbh->selectrow_hashref('SELECT * FROM ships LEFT JOIN objects USING (object_id) WHERE object_id = ?',{},$args->{'ship_id'});
    delete $ship->{'ship_pass'};
    $ship->{$_} = int($ship->{$_}) foreach ('x','y');
    $ship;
}

sub __navigation__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Turn ship and thrust/engine power',
        ship_status => {
            energy => 0, # TODO how much is deducted or added for a non-cached call to this method
            hull   => 0, # TODO how much is deducted or added for a non-cached call to this method
            shield => 0, # TODO how much is deducted or added for a non-cached call to this method
        },
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
            ship_radians => {type=>'NUM',min=>0,max=>7,required=>1},
            ship_engine_power => {type=>'NUM',min=>0,max=>7,required=>1},
        },
        resp => {
            success => 1,
        },
    };
}

sub __navigation {
    my ($self,$args) = @_;
    $self->dbh->do('UPDATE ships SET obj_radians = ?,ship_engine_power = ? WHERE ship_id = ?',{},
        $args->{'ship_radians'},$args->{'ship_engine_power'},$args->{'ship_id'});
    {success=>1};
}

sub __repair_hull__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Activate/Deactivate hull repairs.  Automatically turns off if there is not sufficient energy.',
        ship_status => {
            energy_drain => 0, # TODO how much added/drained per time slice
            hull_drain => 0, # TODO how much added/drained per time slice
            hull_drain => 0, # TODO how much added/drained per time slice
            energy => 0, # TODO how much is deducted or added for a non-cached call to this method
            hull   => 0, # TODO how much is deducted or added for a non-cached call to this method
            shield => 0, # TODO how much is deducted or added for a non-cached call to this method
        },
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
            
        },
        resp => {
            TODO => 1,
        },
    };
}

sub __repair_hull {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __repair_shield__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Activate/Deactivate shield repairs.  Automatically turns off if there is not sufficient energy.',
        ship_status => {
            energy_drain => 0, # TODO how much added/drained per time slice
            hull_drain => 0, # TODO how much added/drained per time slice
            hull_drain => 0, # TODO how much added/drained per time slice
            energy => 0, # TODO how much is deducted or added for a non-cached call to this method
            hull   => 0, # TODO how much is deducted or added for a non-cached call to this method
            shield => 0, # TODO how much is deducted or added for a non-cached call to this method
        },
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
            
        },
        resp => {
            TODO => 1,
        },
    };
}

sub __repair_shield {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __weapon_fire__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Activate/fire a weapon.',
        ship_status => {
            energy => 0, # TODO how much is deducted or added for a non-cached call to this method
            hull   => 0, # TODO how much is deducted or added for a non-cached call to this method
            shield => 0, # TODO how much is deducted or added for a non-cached call to this method
        },
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
            weapon_radians => {desc=>'TODO'},
            weapon_id => {desc=>'TODO'},
            weapon_power => {desc=>'TODO'},
        },
        resp => {
            TODO => 1,
        },
    };
}

sub __weapon_fire {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __scan__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Performs a scan, giving details about nearby objects.',
        cacheable => {
            cached => 1, # number of seconds to cache this result per ship
            key => ['ship_id'], # args to use as a cache key
        },
        ship_status => {
            energy => 0, # TODO how much is deducted or added for a non-cached call to this method
            hull   => 0, # TODO how much is deducted or added for a non-cached call to this method
            shield => 0, # TODO how much is deducted or added for a non-cached call to this method
        },
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
        },
        resp => {
            long_range => 'The distance where scanning becomes less effective',
            obj => [{
                id => {
                    id => 'object id, listed again for convenience',
                    image => 'Image to display for this object',
                    image_scale => 'Size to display the image. 1 = 100%',
                    type => ['ship','projectile','beam'],
                    team => 'Which team is this object from.  Helpful to detect friend or foe',
                    obj_direction => 'The direction the object is compared to you',
                    x => 'coordinate',
                    y => 'coordinate',
                    shield => 'Amount remaining from 0% - 100%',
                    hull => 'Amount remaining from 0% - 100%',
                    energy => 'Amount remaining from 0% - 100%',
                    move_radians => 'The direction the object is moving',
                    obj_radians => 'The direction the object is facing',
                    obj_speed => 'The speed the object is moving',
                },
            }],
            msg => ['a list of recent messages, if any'],
        },
    };
}

sub __scan {
    my ($self, $args) = @_;

    my $sth = $self->dbh->prepare('SELECT * FROM ships LEFT JOIN objects USING (object_id) WHERE ships.board_id = (SELECT board_id FROM boards WHERE board_name = ?)');
    $sth->execute($self->{'server'}->{'base'}->api_brand);
    my $obj = $sth->fetchall_hashref('object_id');

    # translate everything to be centered around ME
    my $d = {
        x => $obj->{$args->{'ship_id'}}->{'x'},
        y => $obj->{$args->{'ship_id'}}->{'y'},
    };

    my $long_range = 2000;

    my $obj_ret;
    foreach my $id (keys %$obj) {
        my $is_long = Frontier::Common::distance($obj->{$args->{'ship_id'}},$obj->{$id}) > $long_range;
        $obj_ret->{$id}->{'object_direction'} = Frontier::Common::radians($obj->{$args->{'ship_id'}},$obj->{$id});
        $obj_ret->{$id}->{$_} = $obj->{$id}->{$_} foreach ('object_id','image','image_scale','type','team');
        $obj_ret->{$id}->{$_} = ($is_long ? undef : $obj->{$id}->{$_}) foreach ('shield','hull','energy','move_radians','object_radians','move_speed');
        $obj_ret->{$id}->{'x'} = ($is_long ? undef : $obj->{$id}->{'x'} - $d->{'x'});
        $obj_ret->{$id}->{'y'} = ($is_long ? undef : $obj->{$id}->{'y'} - $d->{'y'});
    }

    return {
        obj => $obj_ret,
        long_range => $long_range,
        msg => ['hello from frontier '.time()],
    }
}

sub __exit__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Delete your ship and quit',
        args => {
            ship_id => $Frontier::MetaCommon::args->{'ship_id'},
            ship_pass => $Frontier::MetaCommon::args->{'ship_pass'},
        },
        resp => {
            success => 1,
        },
    };
}

sub __exit {
    my ($self,$args) = @_;
    my $sth = $self->dbh->prepare('DELETE FROM objects WHERE object_id = ?');
    $sth->execute($args->{'ship_id'});
    {success=>1};
}

1;
