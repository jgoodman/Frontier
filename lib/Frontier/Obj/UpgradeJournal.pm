package Frontier::Obj::UpgradeJournal;

use strict;
use warnings;
use base 'Frontier::Obj';

sub table { 'upgrade_journal' }

sub meta {
    return {
        name => {
            desc => 'Name of the upgrade journal entry',
        },
        date => {
            desc => 'Time of when the upgrade occurred',
        },
    }
}

1;

__END__

=head1 NAME

Frontier::Obj::UpgradeJournal

=head1 DEVEL

This module manages the records of which database upgrades have occurred

=head1 METHODS

=cut
