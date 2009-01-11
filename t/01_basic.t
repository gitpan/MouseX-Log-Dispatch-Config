use Test::Base;
use IO::Scalar;

plan tests => 5 * blocks;

{
    package MyLogger;
    use Mouse;
    with 'MouseX::Log::Dispatch::Config';
}

filters { config => ['eval'] };

run {
    my $block = shift;

    my $log = MyLogger->new(
        config => $block->file || $block->config
    );

    isa_ok $log->logger => 'Log::Dispatch';

    tie *STDERR, 'IO::Scalar', \my $err;
    local $SIG{__DIE__} = sub { untie *STDERR; die @_ };
    $log->debug('debug');
    $log->info('info');
    $log->error('error');
    $log->logger->debug('debug with logger');
    untie *STDERR;

    like $err => qr!\[debug\] debug at !;
    like $err => qr!\[info\] info at !;
    like $err => qr!\[error\] error at !;
    like $err => qr!\[debug\] debug with logger at !;
};

__END__
=== str config
--- file: t/log.cfg

=== hash config
--- config
{
    class     => 'Log::Dispatch::Screen',
    min_level => 'debug',
    stderr    => 1,
    format    => '[%d] [%p] %m at %F line %L%n',
}

=== custom config
--- config: Log::Dispatch::Configurator::AppConfig->new('t/log.cfg')
