package config::override;
use strict;
use warnings;
use config;

sub initialize {
    $config::config->{'frontier_service'}->{'host'}  = '192.168.174.129';
    $config::config->{'sql_pass'} = 'frontierpass';
}

1;
