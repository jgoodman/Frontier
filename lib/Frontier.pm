package Frontier;

use strict;
use warnings;
use base qw(Respite::Base Frontier::API);

sub run_method {
    my $self = shift;
    my $method = shift;
    my $args = shift;
    if ($method !~ /__meta$/) {
        my $code = $self->find_method($method.'__meta');
        my $meta = $self->$code();
        $self->validate_args($args,$meta->{'args'});
        # TODO permission check goes here
        # TODO look for cached=1 result
        # TODO add/deduct energy/shield/etc base on $meta->{'ship_status'}
    }
    my $ret = $self->SUPER::run_method($method,$args,@_);
    $ret->{'cached'} = 0;
    $ret;
}

=item

me - shortcut to get to your own ship

=cut

sub me {
    my $self = shift;
    $self->{'me'} ||= do{ }; # TODO get this
}

1;

__END__

=head1 NAME

Frontier

=head1 SYNOPSIS

=head1 METHODS

=cut
