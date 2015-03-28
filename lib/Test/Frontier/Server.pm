package Test::Frontier::Server;

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
        api_meta => 'Frontier::Base',
        flat     => 1,
        client_utf8_encoded => 1,
        no_ssl => 1,
    });

    ok($self->{'client'} = $client, 'Got client');
    ok($self->{'server'} = $server, 'Got server');
}

sub hello : Test(1) {
    my $self = shift;
    my $resp = $self->client->hello;
    cmp_deeply(
        $resp,
        { msg => 'hello from frontier', server_time => re('^\d+$') },
        'Call api method hello'
    ) or diag(explain($resp));
}

sub methods : Test(1) {
    my $self = shift;
    my $resp = $self->client->methods;
    cmp_deeply($resp, { }, 'Call api method methods') or diag(explain($resp));
}

sub ship_info : Test(1) {
    my $self = shift;
    my $resp = $self->client->ship_info;
    cmp_deeply($resp, { }, 'Call api method ship_info') or diag(explain($resp));
}

sub client { return shift->{'client'} }

sub server { return shift->{'server'} }

1;

__END__

=head1 NAME

Test::Frontier::Server - Unit Tests for Frontier::Server module

=head1 FIXTURES

=head2 startup

Starts a Frontier server for testing

=head1 TEST_METHODS

Below are test methods this module contains

=head2 hello

Makes a basic hello call an validates the response

Tests the hello api call

=head1 METHODS

=head2 client

Returns the Frontier::Client object which was created during startup

=head2 server

Returns the Frontier::Server object which was created during startup

=cut
