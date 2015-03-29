package Frontier::Obj;

use strict;
use warnings;
use Throw qw(throw);

sub table { throw 'table not overridden' }
sub meta  { throw 'meta not overridden' }

sub new {
    my $proto = shift;
    my $args  = shift;

    unless(ref $args) {
        #TODO: We are assuming this is the id. Code out a lookup
        $args = { id => $args->{'id'} };
    }

    my $class = ref $proto || $proto;
    my $self  = bless $args, $class;

    my $info  = $self->info;
    my $meta  = $self->meta;
    $meta->{'id'} //= { }; # Allow for universal id
    my @bad_keys;
    foreach my $key (%$info) { push @bad_keys, $key unless exists $meta->{$key} }
    throw 'bad keys supplied for info: '.join(', ', @bad_keys) if scalar @bad_keys;

    return $self;
}

sub info {
    my $self = shift;
    return $self->{'info'} ||= { };
}

sub id {
    my $self = shift;
    return $self->get('id');
}

sub get {
    my $self  = shift;
    my $field = shift or throw 'field undef';
    $self->info->{$field};
}

sub set {
    my $self  = shift;
    my $field = shift or throw 'field undef';
    my $value = shift;
    return $self->info->{$field} = $value;
}

sub pretty { return shift->info }

1;

__END__

=head1 NAME

Frontier::Obj

=head1 SYNOPSIS

This is a base class module

=head1 METHODS

=head2 new

Constructor method which initializes an object.

=cut
