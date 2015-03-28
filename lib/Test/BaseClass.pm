package Test::BaseClass;

use strict;
use warnings;
use Test::More;
use Test::Deep;
use base 'Test::Class';

our $DEBUG = 0;

sub startup : Test(startup => 2) {
    my $self = shift;
    note($self->test_class . '->startup') if $DEBUG;
    my $module = $self->module;
    require_ok($module);
    can_ok($module, $self->has_subs);
}

sub setup : Test(setup => 1) {
    my $self = shift;
    note($self->test_class . '->setup') if $DEBUG;
    my $obj  = $self->obj;
    ok($obj, ref($obj) . ' object instantiated');
}

# Can't call this "new' since that is already taken
sub test_new : Test(1) {
    my $self = shift;
    my $obj  = $self->obj;
    isa_ok($obj, $self->module);
    return $obj;
}

sub teardown : Test(teardown => 1) {
    my $self = shift;
    note($self->test_class . '->teardown') if $DEBUG;
    my $obj  = delete $self->{'obj'};
    ok($obj, ref($obj) . ' object destroyed');
}

sub test_class {
    my $self = shift;
    return (ref $self || $self);
}

sub module {
    my $self  = shift;
    my $class = ref $self;
    return $self->{'module'} = $class =~ m/^Test::([:\w]+)$/ ? $1 : die 'Could not determine module being tested';
}

sub has_subs { qw(new) }

sub obj {
    my $self = shift;
    my $obj  = shift;
    $self->{'obj'} = $obj if defined $obj;
    return $self->{'obj'} ||= $self->module->new;
}

sub is_int { re('^\d+$') }

1;

__END__

=head1 NAME

Test::BaseClass

=head1 SYNOPSIS

This is a Test::Class based module intended to be subclassed.

=head1 FIXTURES

Below are fixtures this module contains.
These are executed by Test::Class.

=head2 startup

A startup fixture which loads modules and does a can_ok

=head2 setup

A setup fixture which instantiates an object of the class being tested.

=head2 teardown

A teardown fixture which destroys an object of the class being tested.

=head1 TEST_METHODS

Below are test methods this module contains.
These are executed by Test::Class.

=head2 test_new

Tests the new method to validate the object instantiated during setup.
Typically, test_methods are named the same as the module which is being testing.
However, new is already taken by Test::Class so this name is used instead.
Returns the object so the subclass may do additiona testing. Example in subclass:

  sub test_new : Test(+1) {
      my $self = shift;
      my $obj  = $self->SUPER::test_new(@_);
      ok($obj, 'Yep, I got the object back!');
  }

=head METHODs

Below are standard methods this module contains.

=head test_class

Returns the name of the testing module.

=head module

Return the name of the module which is being tested

=head2 has_subs

Returns array of methods or subs the assoiated module which is being tested has.
By default, it only has "new".
Can be overridden in subclass to properly define what those are.

=head2 obj

Gets or sets an instantiated object of the class which is being tested

=head2 is_int

Used for Test::Deep::cmp_deeply.
Returns a Test::Deep::re() object which validates if value is an integer.

=cut
