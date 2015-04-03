package Frontier::API;

use strict;
use warnings;
use Throw qw(throw);

sub __do_multi__meta {
    return {
        desc => 'Cut down on latency by batching calls, they are run in the order you send',
        args => {
            calls => [{method=>'see individual methods for meta details'}],
        },
        resp => {
            calls => [{method=>'see individual methods for meta details'}],
        },
    };
}
sub __do_multi {
    my ($self,$args) = @_;
    my $ret = {};
    foreach my $call (@{$args->{'calls'}}) {
        my $method = [keys %$call]->[0];
        my $args = $call->{$method};
        $args = ref $args eq 'HASH' ? $args : {};
        my $resp = eval{$self->run_method($method,$args)} || $@;
        push @{$ret->{'calls'}}, {$method => $resp};
    }
    return $ret;
}

sub __new_board__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Start a new game board',
        args => {
            board_pass => {
                desc => 'The new password all ships will need to connect to this board',
                type=>'STRING',
                required => 1,
            },
        },
        resp => {
        },
    };
}

sub __new_board {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __new_ship__meta {
    my ($self,$args) = @_;
    return {
        desc => 'Create a new ship',
        args => {
            ship_id => {
                type=>'UINT',
                required => 1,
            },
            ship_pass => {
                desc => 'The password used when performing any ship action',
                type=>'STRING',
                required => 1,
            },
            board_pass => {
                desc => 'The new password all ships will need to connect to this board',
                type=>'STRING',
                required => 1,
            },
        },
        resp => {
        },
    };
}

sub __new_ship {
    my ($self,$args) = @_;
    {TODO=>1};
}

sub __scan__meta {
    return {
        desc => 'Performs a short range scan, giving details about nearby objects in play.',
        cacheable => {
            cached => 1, # TODO number of seconds to cache this result per ship
            key => [], # args to use as a cache key
        },
        ship_status => {
            energy => 0, # TODO how much is deducted or added for a non-cached call to this method
            hull   => 0, # TODO how much is deducted or added for a non-cached call to this method
            shield => 0, # TODO how much is deducted or added for a non-cached call to this method
        },
        args => {
            ship_id => {
                type=>'UINT',
                required => 1,
            },
            ship_pass => {
                desc => 'The password used when performing any ship action',
                type=>'STRING',
                required => 1,
            },
        },
        resp => {
            obj => {
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
            },
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

sub __scan_long__meta {
    my $self = shift;
    my $ret = $self->__scan__meta(@_);
    $ret->{'desc'} = 'Performs a long range scan, giving basic info for objects beyond the short range scanners range.',
    $ret->{'ship_status'}->{'energy'} = '-1TODO'; #$self->my->scanner->energy; # TODO calculated from ship stats
    $ret;
}

sub __scan_long {
    my ($self,$args) = @_;
    $self->__scan($args,1);
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
