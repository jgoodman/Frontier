package config;
use strict;
use warnings;

our %config;
our $config = \%config;

sub provider { 'board123'; }

sub new {
    my $class = shift;
    my $self = bless ref($_[0]) ? shift : {@_}, $class;
    return $self;
}

sub load {
    $config->{'no_brand'} = 1;
    $config->{'frontier_service'} = {
        remote => 1,
        host   => 'localhost', # you should override this in config::override.pm
        service_name => 'frontier',
        brand  => 'test',
        pass   => '-',
        port   => 50443,
        no_ssl => 1,
        user   => 'jter',
        group  => 'jter',
    };
      require config::override;
      config::override->initialize();
    $config;
}

sub config {
    return $config;
}

config::load();

1;

=head1 example config::override.pm

package config::override;
use strict;
use warnings;
use config;

sub initialize {
    $config::config->{'frontier_service'}->{'host'}  = '192.168.174.129';
}

1;

=cut
