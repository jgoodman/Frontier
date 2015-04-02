#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Getopt::Long;
use Pod::Usage;
use File::Find;
use DBI;

use Frontier::Obj;

my $man;
my $help;
my $dry;
my $verbose = 0;
GetOptions(
    'help|?'   => \$help,
    man        => \$man,
    dry        => \$dry,
    'verbose+' => \$verbose,
) or pod2usage(2);;
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

my @modules;
find( sub { push @modules, 'Frontier::Obj::'.$1 if $_ =~ m/(\w+).pm$/ }, "$Bin/../lib/Frontier/Obj/");

my %has_loaded;
my $dbh = DBI->connect("dbi:SQLite:dbname=frontier.db","","");
load_tables(@modules);

sub load_tables {
    my @classes = @_;
    foreach my $class (@classes) {
        if($has_loaded{$class}) {
            print "  - $class has already been setup\n" if $verbose;
            next;
        }
        print "Loading $class\n" if $verbose;
        Frontier::Obj->require_class($class);

        # Create tables that this module depends on
        my $meta = $class->meta;
        foreach my $key (keys %$meta) {
            my $join_class = $meta->{$key}->{'join_class'};
            next unless $join_class;
            print "  - Needs $join_class\n" if $verbose;
            load_tables($join_class);
        }

        # Create table
        my $sql = $class->create_table_sql;
        print "$sql\n" if $verbose > 1;
        $dbh->do($sql) unless $dry;
        $has_loaded{$class} = 1;
    }

}

__END__

=head1 NAME

setup.pl

=head1 DESCRIPTION

This is a script which will create database tables

=head1 USAGE

setup.pl [options]

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=item B<-dry>

Flag to not create the database tables

=item B<-verbose>

Print diagnostic information.

=back

=cut
