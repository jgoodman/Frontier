package Frontier::API;

use strict;
use warnings;
use Throw qw(throw);

sub __scan {
    my ($self, $args) = @_;
    return {
        msg         => 'hello from frontier',
        server_time => time(),
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
