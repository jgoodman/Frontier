package Frontier::Multi;
use strict;
use warnings;
use Throw qw(throw);

sub new { __PACKAGE__ } # For Respite::Server

sub __run_method__meta {
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

sub __run_method {
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

1;
