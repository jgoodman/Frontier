package config;
use strict;
use warnings;

our %config;
our $config = \%config;

sub provider { 'board123'; }

sub new {
    my $class = shift;
    my $self = bless ref($_[0]) ? shift : {@_}, $class;
    return $self;
}

sub load {
    $config->{'no_brand'} = 1;
    $config;
}

1;
