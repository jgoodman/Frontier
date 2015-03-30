package Frontier::User;

use strict;
use warnings;
use base 'Frontier::Obj';

sub table { 'user' }

sub meta {
    return {
        name => {
            desc => 'Username',
        },
        password => {
            desc => 'Password',
        },
        email    => {
            desc => 'Email Address',
        },
    }
}

1;

__END__

=head1 NAME

Frontier::User

=head1 SYNOPSIS

This module abstracts a user

=head1 METHODS

=cut
