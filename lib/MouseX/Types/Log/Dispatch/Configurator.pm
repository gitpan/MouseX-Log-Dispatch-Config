package MouseX::Types::Log::Dispatch::Configurator;

use strict;
use warnings;
use Log::Dispatch::Configurator;
use Log::Dispatch::Configurator::AppConfig;
use Mouse::Util::TypeConstraints;
use MouseX::Log::Dispatch::Configurator::HashRef;
use MouseX::Types::Mouse qw(Str HashRef);
use namespace::clean;

our $VERSION = '0.01';

class_type 'Log::Dispatch::Configurator'
    => { class => 'Log::Dispatch::Configurator' };

coerce 'Log::Dispatch::Configurator',
    from Str, via {
        if (eval { require Log::Dispatch::Configurator::Any; 1 }) {
            Log::Dispatch::Configurator::Any->new($_);
        }
        else {
            Log::Dispatch::Configurator::AppConfig->new($_);
        }
    },
    from HashRef, via {
        if (eval { require Log::Dispatch::Configurator::Any; 1 }) {
            Log::Dispatch::Configurator::Any->new($_);
        }
        else {
            MouseX::Log::Dispatch::Configurator::HashRef->new(config => $_);
        }
    };

1;

=head1 NAME

MouseX::Types::Log::Dispatch::Configurator - A Log::Dispatch::Configurator type library for Mouse

=head1 TYPES

=head2 Log::Dispatch::Configurator

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::Types>, L<Log::Dispatch::Configurator::AppConfig>, L<MouseX::Log::Dispatch::Config>

=cut
