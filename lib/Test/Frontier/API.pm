package Test::Frontier::API;

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Sub::Override;
use Respite::Server::Test qw(setup_test_server);

use Respite::Base;
use Respite::Server;
use Respite::Client;

use base 'Test::Class';

sub _configs_mock {
    return {
        server_type => 'api',
        provider    => 'unittest',
    }
}

sub startup : Test(startup => +6) {
    my $self = shift;

    my %override;
    foreach my $key (qw(Base Server Client)) {
        my $module = "Respite::$key";
        my $module_sub = "$module\::_configs";
        ok($override{$module_sub} = Sub::Override->new($module_sub => \&_configs_mock), "Override $module_sub")
    }
    my $ps = 'Respite::Server::__ps';
    ok(
        $override{$ps} = Sub::Override->new(
            $ps => sub {
                my $name = shift->server_name;
                my $out = join '', grep {$_ =~ $name && $_ !~ /\b(?:$$|watch|ps)\b/} `ps auwx`;
                warn $out || "No processes found\n";
            }
        ), "Override $ps"
    );
    $self->{'override'} = \%override;

    my ($client, $server) = setup_test_server({
        service  => 'frontier_test',
        api_meta => 'Frontier',
        flat     => 1,
        client_utf8_encoded => 1,
        no_ssl => 1,
    });

    ok($self->{'client'} = $client, 'Got client');
    ok($self->{'server'} = $server, 'Got server');
}

sub __hello : Test(1) {
    my $self = shift;
    my $resp = $self->client->hello;
    cmp_deeply(
        $resp,
        { api_brand=>'unittest',api_ip=>'127.0.0.1',server_time => re('^\d+$'), args=>{_c=>re('.')} },
        'Call api method "hello"'
    ) or diag(explain($resp));
}

sub __methods : Test(1) {
    my $self = shift;
    my $resp = $self->client->methods;
    ok($resp->{'methods'}, 'Call api method "methods"') or diag(explain($resp));
}

sub client { return shift->{'client'} }

sub server { return shift->{'server'} }

1;

__END__

=head1 NAME

Test::Frontier::API - Unit Tests for Frontier::API module

=head1 FIXTURES

=head2 startup

Starts a Frontier server for testing

=head1 TEST_METHODS

Below are test methods this module contains

=head2 hello

Makes a basic hello call an validates the response

Tests the hello api call

=head methods

=head1 METHODS

=head2 client

Returns the Respite::Client object which was created during startup

=head2 server

Returns the Respite::Server object which was created during startup

=cut
