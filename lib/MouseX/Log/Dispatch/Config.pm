package MouseX::Log::Dispatch::Config;

use 5.8.1;
use Mouse::Role;
use MouseX::Types::Log::Dispatch::Configurator;
use Log::Dispatch::Config;
use namespace::clean -except => ['meta'];

our $VERSION = '0.02';

has 'logger' => (
    is         => 'rw',
    isa        => 'Log::Dispatch::Config',
    lazy_build => 1,
    handles    => [qw(
        log debug info notice warning error critical alert emergency
    )],
);

has 'config' => (
    is        => 'rw',
    isa       => 'Log::Dispatch::Configurator',
    coerce    => 1,
    predicate => 'has_config',
);

sub _build_logger {
    my $self = shift;

    if ($self->has_config) {
        Log::Dispatch::Config->configure($self->config);
    }

    return Log::Dispatch::Config->instance;
}

no Mouse::Role; 1;

=head1 NAME

MouseX::Log::Dispatch::Config

=head1 SYNOPSIS

    package MyLogger;
    use MouseX::Log::Dispatch::Config;

    # file-based (AppConfig style)
    has '+config' => (default => '/path/to/log.cfg');

    package HashLogger;
    use MouseX::Log::Dispatch::Config;

    # hash-based
    has '+config' => (default => sub {
        {
            class     => 'Log::Dispatch::Screen',
            min_level => 'debug',
            stderr    => 1,
            format    => '[%p] %m at %F line %L%n',
        }
    });

    package CustomLogger;
    use MouseX::Log::Dispatch::Config;
    use Log::Dispatch::Configurator::YAML;

    # custom configurator
    has '+config' => (default => sub {
        Log::Dispatch::Configurator::YAML->new('/path/to/log.yml');
    });

    package main;

    my $log = MyLogger->new;

    $log->debug('foo');
    $log->logger->debug('bar'); # also works

    $log->info('baz');
    $log->error('error');

=head1 DESCRIPTION

This is a role which provides a L<Log::Dispatch::Config> logger.

=head1 METHODS

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

=head2 config

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
