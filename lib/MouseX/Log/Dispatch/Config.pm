package MouseX::Log::Dispatch::Config;

use 5.8.1;
use Mouse::Role;
use MouseX::Types::Log::Dispatch::Configurator;
use Log::Dispatch::Config;
use namespace::clean -except => ['meta'];

our $VERSION = '0.03';

has 'logger' => (
    is         => 'rw',
    isa        => 'Log::Dispatch::Config',
    lazy_build => 1,
    handles    => [qw(
        log debug info notice warning error critical alert emergency
    )],
);

has '_logger_config' => (
    is        => 'rw',
    isa       => 'Log::Dispatch::Configurator',
    coerce    => 1,
    init_arg  => 'config',
    predicate => 'has_logger_config',
);

sub _build_logger {
    my $self = shift;

    if ($self->has_logger_config) {
        Log::Dispatch::Config->configure($self->_logger_config);
    }

    return Log::Dispatch::Config->instance;
}

no Mouse::Role; 1;

=head1 NAME

MouseX::Log::Dispatch::Config - A Mouse role for logging

=head1 SYNOPSIS

    package MyLogger;
    use Mouse;
    with 'MouseX::Log::Dispatch::Config';

    package main;

    # file-based (AppConfig style)
    my $log = MyLogger->new(config => '/path/to/log.cfg');

    # hash-based
    my $log = MyLogger->new(config => {
        class     => 'Log::Dispatch::Screen',
        min_level => 'debug',
        stderr    => 1,
        format    => '[%p] %m at %F line %L%n',
    });

    # custom configurator
    my $log = MyLogger->new(
        config => Log::Dispatch::Configurator::YAML->new('/path/to/log.yml')
    );

    $log->debug('foo');
    $log->logger->debug('bar'); # also works

    $log->info('baz');
    $log->error('error');

=head1 DESCRIPTION

This is a role which provides a L<Log::Dispatch::Config> logger.

=head1 METHODS

=head2 new(config => $config)

This method accepts logger config which is C<Str>, C<HashRef> and
C<Log::Dispatch::Configurator> object.

Coerces from C<Str> and C<HashRef> via
L<MouseX::Types::Log::Dispatch::Configurator>.

=head2 log

=head2 debug

=head2 info

=head2 notice

=head2 warning

=head2 error

=head2 critical

=head2 alert

=head2 emergency

=head1 PROPERTIES

=head2 logger

Returns a L<Log::Dispatch::Config> object.

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 THANKS TO

Ash Berlin, and L<MooseX::LogDispatch/AUTHOR>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Mouse>, L<Mouse::Role>, L<MouseX::Types::Log::Dispatch::Configurator>,

L<Log::Dispatch::Config>, L<Log::Dispatch::Configurator>, L<Log::Dispatch>,

L<MooseX::LogDispatch>

=cut
