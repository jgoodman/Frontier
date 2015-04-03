package Frontier;

use strict;
use warnings;
use base qw(Respite::Base Frontier::API);
use Cache::Memcached::Fast;
use Time::HiRes qw(time);
use Throw qw(throw);

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
    if ($method !~ /__meta$/ && !($method ~~ ['methods','hello','new_board','new_ship'])) {
        $self->check_permissions($method,$args,$meta); # do this first, so we can setup your ship
        my $code = $self->find_method($method.'__meta');
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
    my $ret = eval{$self->SUPER::run_method($method,$args,@_)} || $@;
    if ($ret && $meta && $meta->{'ship_status'}) {
        # TODO add/deduct energy/shield/etc base on $meta->{'ship_status'}
    }
    if ($cache_key) {
        $ret->{'_cached'} = time;
        $self->memd->set($cache_key,$ret,30);
    }
    $ret->{'_cached'} = 0;
    $ret;
}

sub check_permissions {
    my ($self,$method,$args,$meta) = @_;
    throw 'permission denied', {ship_id=>$args->{'ship_id'}} unless $args->{'ship_id'} && $args->{'ship_pass'};
    # TODO check database to make sure ship_pass matches ship_id
    $self->{'ship_id'} = $args->{'ship_id'};
}

sub memd {
    my ($self) = @_;
    $self->{'memd'} ||= do {
        new Cache::Memcached::Fast({
            servers => [ { address => 'localhost:11211', weight => 2.5 },
                         '192.168.254.2:11211',
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
