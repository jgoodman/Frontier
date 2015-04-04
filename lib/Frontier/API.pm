package Frontier::API;

use strict;
use warnings;
use Throw qw(throw);
use Frontier::MetaCommon;

sub new { __PACKAGE__ } # For Respite::Server

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

    $args->{'ship_id'} = 123; # TODO make the ship

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
    {TODO=>1};
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

sub __scan {
    my ($self, $args, $is_long) = @_;

    #require Frontier::Mock;
    #my $obj = Frontier::Mock::mocked();
    my $obj = {0=>{id=>0,x=>1}};

    my $obj_ret;
    foreach my $id (keys %$obj) {
        $obj_ret->{$_} = $obj->{$id}->{$_} foreach ('id','img','scale','type','team','obj_direction');
        $obj_ret->{$_} = ($is_long ? undef : $obj->{$id}->{$_}) foreach ('x','y','shield','hull','energy','move_radians','obj_radians','obj_speed');
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
