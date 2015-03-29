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

sub id {
    my $self = shift;
    return $self->get_info('id');
}

sub info {
    my $self = shift;
    return $self->{'info'} ||= { };
}

sub get_info {
    my $self  = shift;
    my $field = shift or throw 'field undef';
    $self->info->{$field};
}

sub set_info {
    my $self  = shift;
    my $field = shift or throw 'field undef';
    my $value = shift;
    return $self->info->{$field} = $value;
}

sub get {
    my $self  = shift;
    my $field = shift or throw 'field undef';
    $self->{$field};
}

sub set {
    my $self  = shift;
    my $field = shift or throw 'field undef';
    my $value = shift;
    return $self->{$field} = $value;
}

sub pretty { return shift->info }

sub full_meta {
    my $self = shift;

    my %join;
    my $meta = $self->meta;
    foreach my $key (keys %$meta) {
        my $hash = $meta->{$key};
        my $join_class = $hash->{'join_class'};
        next unless $join_class;
        my $join_meta = $join{$join_class} ||= do {
            $self->require_class($join_class);
            # TODO: We need to prevent circular referencing somehow
            $join_class->full_meta;
        };
        my $join_key = $hash->{'join_key'} ||= do {
            my $_key = $join_meta->{$key} or do {
                my $join_table = $join_class->table.'_';
                $key =~ m/^$join_table(\w+)$/ ? $1 : throw "Regex mismatch";
            };
            throw "Meta key not found in $join_class: $key" unless $_key;
            $_key;
        };
        my $join_hash = $join_meta->{$join_key};
        foreach my $k (keys %$join_hash) {
            $hash->{$k} = $join_hash->{$k} unless exists $hash->{$k};
        }
    }
    return $meta;
}

sub require_class {
    my $self  = shift;
    my $class = shift or throw 'class undef';
    my $file  = "$class.pm";
    $file =~ s/::/\//g;
    require $file;
    return $class;
}

sub build_create_schema {
    my $self = shift;

    my %fkey;
    my $table  = $self->table;
    my $schema = "CREATE TABLE $table ( id INT NOT NULL AUTO_INCREMENT,";
    my $meta = $self->full_meta;
    foreach my $col (keys %$meta) {
        my $hash = $meta->{$col};
        $schema .= " $col";
        if(my $type  = $hash->{'type'}) {
            $schema .= ' INT' if uc($type) eq 'UINT';
        }
        else {
            # TODO code out max_len and min_len;
            $schema .= ' VARCHAR(80)';
        }
        $schema .= ' NOT NULL' if $hash->{'required'};
        $schema .= ',';
        if(my $join_class = $hash->{'join_class'}) {
            my $ftable = $join_class->table;
            $fkey{$ftable} = 1;
        }
    }
    $schema .= " CONSTRAINT pk_$table\_id PRIMARY KEY (id),";
    $schema =~ s/,$//; # Remove any trailing comma to avoid SQL syntax errors
    $schema .= ');';

    return $schema;
}

sub upgrade_database { }

1;

__END__

=head1 NAME

Frontier::Obj

=head1 SYNOPSIS

This is a base class module

=head1 METHODS

=head2 table

Intended to be overridden in sub class to return the table name of the object.

=head2 meta

Intended to be overridden in sub class to return a hashref.
Used to supply API validation and how to interface with the database table.

=head2 new

Constructor method which initializes an object.
Can pass in a hashref or scalar.
If scalar is passed in, then it will be assumed as the record id
and a lookup on the database will be performed.

If a hashref is supplied, there is an "info" key which
is a hashref for the database record. If this is supplied,
then validation will occur for any bad key names passed in.
This is done to ensure that syntax error don't occur.

=head2 id

Returns the record ID

=head2 info

Returns the info hashref which is the database record

=head2 get_info

Supply field name.
Returns field name inside the info hashref. <SEE sub info>

=head2 set_info

Supply field name and value.
Sets and returns field name inside the info hashref. <SEE sub info>

=head2 get

Accessor method to get generic field of an object.
Note, the field does not mean database field,
sub get_info should be used instead to access that information.

=head2 set

Accessor method to set generic field of an object.
Note, the field does not mean database field,
sub set_info should be used instead to access that information.

=head2 pretty

Used to return object data to clients using the API.
By default, returns the info hashref.
Can be overridden in subclass to customize what should be returned to clients.

=head2 full_meta

Calls $self->meta and loops through the keys.
If "join_class" is found, it will inherit the hashref from the foriegn class.

=head2 require_class

Helper method to load another module

=head2 build_create_schema

Calls the module's meta method and returns SQL to create the database table.

=head2 upgrade_database

Reserved for upgrades pertaining to the database.
Intended to be overridden in subclasses.

=cut
