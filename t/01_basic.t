use Test::Base;
use IO::Scalar;

plan tests => 6 * blocks;

{
    package FileLogger;
    no warnings 'redefine';
    use Mouse;
    with 'MouseX::Log::Dispatch::Config';
    has '+config' => (default => 't/log.cfg');

    package HashLogger;
    no warnings 'redefine';
    use Mouse;
    with 'MouseX::Log::Dispatch::Config';
    has '+config' => (
        default => sub {
            +{
                class     => 'Log::Dispatch::Screen',
                min_level => 'debug',
                stderr    => 1,
                format    => '[%d] [%p] %m at %F line %L%n',
            };
        },
    );

    package CustomLogger;
    no warnings 'redefine';
    use Mouse;
    use Log::Dispatch::Configurator::AppConfig;
    with 'MouseX::Log::Dispatch::Config';
    has '+config' => (
        default => sub { Log::Dispatch::Configurator::AppConfig->new('t/log.cfg') },
    );
}

run {
    my $block = shift;

    my $log = $block->class->new;
    isa_ok $log->logger => 'Log::Dispatch';
    isa_ok $log->config => 'Log::Dispatch::Configurator';

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
--- class: FileLogger

=== hash config
--- class: HashLogger

=== custom config
--- class: CustomLogger
