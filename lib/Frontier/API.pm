package Frontier::API;

use strict;
use warnings;
use base 'Respite::Base';

sub api_meta {
    return shift->{'api_meta'} ||= { lib_dirs  => 1 };
}

sub __hello {
    my ($self, $args) = @_;
    return {
        msg         => 'hello from frontier',
        server_time => time(),
    }
}

1;

__END__

=head1 NAME

Frontier::API

=head1 SYNOPSIS

Base class to inherit from.

=head1 METHODS

=cut
