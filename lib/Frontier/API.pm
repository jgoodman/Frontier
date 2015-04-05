package Frontier::API;

use strict;
use warnings;
use Throw qw(throw);
use Frontier::MetaCommon;
use Digest::SHA qw(sha256_hex);
use Math::Trig;

sub new {
    my ($class,$server) = @_;
    my $self = bless {server=>$server}, $class;
    $self;
} # For Respite::Server

#  create table ships(ship_id INTEGER PRIMARY KEY NOT NULL, board_id INTEGER NOT NULL, ship_name VARCHAR(100) NOT NULL, ship_pass VARCHAR(100) NOT NULL,x REAL NOT NULL,y REAL NOT NULL,energy INTEGER NOT NULL, shield INTEGER NOT NULL, hull INTEGER NOT NULL, FOREIGN KEY(ship_id) REFERENCES boards(board_id),UNIQUE(ship_name,board_id));
sub dbh { my $self = shift; $self->{'server'}->{'base'}->dbh; } # TODO shoudln't need to make this in each method

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
        },
        resp => $self->__info__meta()->{'resp'},
    };
}

sub __new {
    my ($self,$args) = @_;

    $args->{'board_name'} = $self->{'server'}->{'base'}->api_brand;
    my $board = $self->{'server'}->{'base'}->call('board_info'=>$args);

    my $x = rand(9999) - 5000;
    my $y = rand(9999) - 5000;
    my $energy = 100;
    my $hull = 100;
    my $shield = 100;
    {
        local $self->dbh->{'PrintError'} = 0;
        $self->dbh->do('INSERT INTO ships (ship_name,ship_pass,board_id,x,y,energy,hull,shield) VALUES (?,?,?,?,?,?,?,?)',{},
            $args->{'ship_name'},$self->enc($args),$board->{'board_id'},$x,$y,$energy,$hull,$shield)
            or throw 'Could not create ship';
    }
    ($args->{'ship_id'}) = $self->dbh->selectrow_array('SELECT last_insert_rowid()');

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
    my $ship = $self->dbh->selectrow_hashref('SELECT * FROM ships WHERE ship_id = ?',{},$args->{'ship_id'});
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
            ship_radians => {desc=>'TODO'},
            ship_engine_power => {desc=>'TODO'},
        },
        resp => {
            TODO => 1,
        },
    };
}

sub __navigation {
    my ($self,$args) = @_;
    {TODO=>1};
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
            obj => [{
                id => {
                    id => 'object id, listed again for convenience',
                    img => 'Image to display for this object',
                    scale => 'Size to display the img. 1 = 100%',
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

sub _distance {
    my($obj1,$obj2) = @_;
    return sqrt(abs($obj1->{'x'} - $obj2->{'x'}) ** 2 + abs($obj1->{'y'} - $obj2->{'y'}) ** 2);
}
sub _radians {
    my($obj1,$obj2) = @_;
    my $dy = $obj1->{'y'}-$obj2->{'y'};
    my $dx = $obj1->{'x'}-$obj2->{'x'};
    my $rad = abs($dx == 0 ? pi/2 : atan($dy/$dx));
    return pi-$rad if ($dx <  0 && $dy >= 0);
    return pi+$rad if ($dx <  0 && $dy < 0);
    return (2*pi)-$rad if ($dx >= 0 && $dy < 0);
    return $rad;
}
sub __scan {
    my ($self, $args) = @_;
    my $sth = $self->dbh->prepare('SELECT * FROM ships WHERE board_id = (SELECT board_id FROM boards WHERE board_name = ?)');
    $sth->execute($self->{'server'}->{'base'}->api_brand);
    my $obj = $sth->fetchall_hashref('ship_id');

    my $obj_ret;
    foreach my $id (keys %$obj) {
        my $is_long = _distance($obj->{$args->{'ship_id'}},$obj->{$id}) > 2000;
        $obj_ret->{$id}->{'obj_direction'} = _radians($obj->{$args->{'ship_id'}},$obj->{$id});
        $obj_ret->{$id}->{$_} = $obj->{$id}->{$_} foreach ('ship_id','img','scale','type','team');
        $obj_ret->{$id}->{$_} = ($is_long ? undef : $obj->{$id}->{$_}) foreach ('x','y','shield','hull','energy','move_radians','obj_radians','obj_speed');
    }

    return {
        obj => $obj_ret,
        msg => ['hello from frontier '.time()],
    }
}

sub obj_class {
    my $self  = shift;
    return $self->{'obj_class'} ||= do {
        my $class = ref $self || $self;
        my $name  = m/^Frontier::API::([:\w]+)$/ ? $1 : throw 'Unable to determine obj name';
        'Frontier::'.$name;
    }
}

sub info_meta {
    my $self  = shift;
    my $class = shift || $self->obj_class;
    my $meta  = $class->new->meta;
    return {
        desc => 'Query individual '.$class->table.
        args => {
            id       => 'Primary key',
            type     => 'UINT',
            required => 1,
        },
        resp => {
            todo => 'TODO: Need to implement this!',
        },
    }
}

sub info {
    my $self  = shift;
    my $args  = shift;
    my $class = shift || $self->obj_class;
    $self->validate($args, $self->info_meta($class));
    return $class->new($args->{'id'})->pretty;
}

1;

__END__

=head1 NAME

Frontier::API

=head1 SYNOPSIS

Base class to inherit from.

=head1 METHODS

=cut
