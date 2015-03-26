package Test::BaseClass;

use strict;
use warnings;
use Test::More;
use base 'Test::Class';

sub startup : Test(startup => 2) {
    my $self   = shift;
    my $module = $self->module;
    require_ok($module);
    can_ok($module, $self->has_subs);
}

sub setup : Test() {
    my $self = shift;
    ok($self->obj, ref $self . ' object instantiated');
}

sub module {
    my $self  = shift;
    my $class = ref $self;
    return $class =~ m/^Test::([:\w]+)$/ ? $1 : die 'Could not determine module being tested';
}

sub has_subs { qw(new) }

sub obj {
    my $self = shift;
    my $obj  = shift;
    $self->{'obj'} = $obj if defined $obj;
    return $self->{'obj'} ||= $self->module->new;
}

1;

__END__

=head1 NAME

Test::BaseClass

=head1 SYNOPSIS

This is a Test::Class based module intended to be subclassed.

=head1 TEST_METHODS

Below are test methods this module contains.
These are executed by Test::Class.

=head2 startup

A startup fixture which loads modules and does a can_ok

=head2 setup

A setup fixture which instantiates an object of the class being tested.

=head METHOD

Below are standard methods this module contains.

=head2 has_subs

Returns array of methods or subs the assoiated module which is being tested has.
By default, it only has "new".
Can be overridden in subclass to properly define what those are.

=head2 obj

Gets or sets an instantiated object of the class which is being tested

=cut
