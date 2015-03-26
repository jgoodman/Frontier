package Frontier::Base;

use strict;
use warnings;

sub new { bless($_[1] || { }, $_[0]) }

1;

__END__

=head1 NAME

Frontier::Base

=head1 SYNOPSIS

Base class to inherit from.

=head1 METHODS

=head2 new

Contstructor method which returns an instantiated object of the class

=cut
