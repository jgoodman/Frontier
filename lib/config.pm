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
    $config->{'frontier_service'} = {
        remote => 1,
        host   => 'localhost',
        service_name => 'frontier',
        brand  => 'test',
        pass   => '-',
        port   => 50443,
        no_ssl => 1,
        user   => 'jter',
        group  => 'jter',
    };
    $config;
}

sub config {
    return $config;
}

config::load();

1;
