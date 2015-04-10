package Frontier::Common;
use strict;
use warnings;
use DBI;
use Math::Trig;
use config;

# somewhere to stick all the common helper methods used by tons of things in Frontier

sub new_dbh() { DBI->connect("dbi:Pg:dbname=".$config::config{'sql_db'}, $config::config{'sql_user'}, $config::config{'sql_pass'}, {AutoCommit => 1}); }

sub distance($$) {
    my($obj1,$obj2) = @_;
    return sqrt(abs($obj1->{'x'} - $obj2->{'x'}) ** 2 + abs($obj1->{'y'} - $obj2->{'y'}) ** 2);
}
sub radians($$) {
    my($obj1,$obj2) = @_;
    my $dy = $obj2->{'y'}-$obj1->{'y'};
    my $dx = $obj2->{'x'}-$obj1->{'x'};
    my $rad = abs($dx == 0 ? pi/2 : atan($dy/$dx));
    if      ($dx <  0 && $dy >= 0) { $rad = $rad + pi
    } elsif ($dx <  0 && $dy <  0) { $rad = pi - $rad
    } elsif ($dx >= 0 && $dy <  0) { $rad = $rad
    } else { $rad = -$rad;
    }
    while ($rad >= 2*pi) { $rad -= 2*pi }
    while ($rad < 0 ) { $rad += 2*pi }
    2*pi - $rad;
}

1;
