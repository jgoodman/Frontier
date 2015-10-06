package Frontier;

use strict;
use warnings;
use base qw(Respite::Base);
use Cache::Memcached::Fast;
use Time::HiRes qw(time);
use DBD::SQLite;
use Frontier::Common;
use Throw qw(throw);

use config;

sub api_meta {
    return shift->{'api_meta'} ||= { # vtable cached here
        namespaces => {
            ship => {
                match => '__',
                package => 'Frontier::Ship',
            },
            board => {
                match => '__',
                package => 'Frontier::Board',
            },
            multi => {
                match => '__',
                package => 'Frontier::Multi',
            },
        },
    };
}

sub server_init {
    my $self = shift;
    $self->memd;
}

sub run_method {
    my $self = shift;
    my $method = shift;
    my $args = shift;
    my $meta;
    my $cache_key;
    if ($method !~ /__meta$/) {
        $self->check_permissions($method,$args,$meta) unless $method ~~ ['methods','hello','board_list','board_new','ship_new'];
        my $code = $self->find_method($method.'__meta');
        if ($code) {
            $meta = $self->$code();
            $self->validate_args($args,$meta->{'args'});
            if ($meta->{'cacheable'}) {
                $cache_key = $method;
                $cache_key .= ':'.$args->{$_} foreach @{$meta->{'cacheable'}->{'key'}};
                $cache_key =~ s/_//g; # for some reason memcache does not like _
                my $cached = $self->memd->get($cache_key);
                return $cached if $cached && ($args->{'cached'} || time - $cached->{'_cached'} <= $meta->{'cacheable'}->{'cached'});
                return {} if $args->{'cached'} && $args->{'cached'} eq 'forced';
            }
        }
    }
    my $ret = eval{$self->SUPER::run_method($method,$args,@_)} || $@;
    if ($ret && $meta && $meta->{'ship_status'}) {
        # TODO add/deduct energy/shield/etc base on $meta->{'ship_status'}
    }
    if ($cache_key) {
        $ret->{'_cached'} = time;
        $self->memd->set($cache_key,$ret,30);
    }
    $ret->{'_cached'} = 0 if $cache_key;
    $ret->{'_extra_headers'} = [ ['Access-Control-Allow-Origin' => '*'], ];
    $ret;
}

sub call {
    my ($self,$method,$args) = @_;
    my $data = $self->frontier->run_method($method => $args);
    throw $data->data unless $data;
    $data->data;
}

sub frontier {
    my $self = shift;
    $self->{'frontier_client'} ||= do {
        require Respite::Client;
        Respite::Client->new({
            service=>'frontier',
            brand=>$self->api_brand,
        });
    }
}

sub throw {
    $_[1]->{'_extra_headers'} = [ ['Access-Control-Allow-Origin' => '*'], ];
    Throw::throw(@_);
}

sub check_permissions {
    my ($self,$method,$args,$meta) = @_;
    if ($method =~ /^board_/) {
        throw 'permission denied', {board_name=>$self->api_brand} unless $args->{'board_pass'};
        # TODO check database to make sure board_pass matches board
    } elsif ($method =~ /^ship_/) {
        throw 'permission denied', {method=>$method,ship_id=>$args->{'ship_id'}} unless $args->{'ship_id'} && $args->{'ship_pass'};
        # TODO check database to make sure ship_pass matches ship
        # TODO make sure $self->api_brand matches the board_name
        $self->{'ship_id'} = $args->{'ship_id'};
    }
}

sub memd {
    my ($self) = @_;
    $self->{'memd'} ||= do {
        my $addr = $config::config{'memd'}->{'host'};
        my $port = $config::config{'memd'}->{'port'};
        new Cache::Memcached::Fast({
            servers => [ { address => 'localhost:11211', weight => 2.5 },
                         "$addr:$port",
                         { address => '/path/to/unix.sock', noreply => 1 } ],
            namespace => 'my:',
            connect_timeout => 0.2,
            io_timeout => 0.5,
            close_on_error => 1,
            compress_threshold => 100_000,
            compress_ratio => 0.9,
            compress_methods => [ \&IO::Compress::Gzip::gzip,
                                  \&IO::Uncompress::Gunzip::gunzip ],
            max_failures => 3,
            failure_timeout => 2,
            ketama_points => 150,
            nowait => 1,
            hash_namespace => 1,
            serialize_methods => [ \&Storable::freeze, \&Storable::thaw ],
            utf8 => ($^V ge v5.8.1 ? 1 : 0),
            max_size => 512 * 1024,
        });
    }
}

sub dbh {
    my $self = shift;
    return $self->{'dbh'} ||= Frontier::Common::new_dbh();
}

=item

me - shortcut to get to your own ship

=cut

sub me {
    my $self = shift;
    return undef unless $self->{'ship_id'};
    $self->{'me'} ||= do{ }; # TODO get this
}

1;

__END__

=head1 NAME

Frontier

=head1 SYNOPSIS

=head1 METHODS

=cut
