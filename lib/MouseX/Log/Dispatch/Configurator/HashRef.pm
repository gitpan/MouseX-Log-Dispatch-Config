package # hide from PAUSE
    MouseX::Log::Dispatch::Configurator::HashRef;

use Mouse;

extends 'Mouse::Object', 'Log::Dispatch::Configurator';

has 'config' => (
    is       => 'rw',
    isa      => 'HashRef',
    required => 1,
);

sub get_attrs_global {
    my $self = shift;
    return +{ format => undef, dispatchers => [''] };
}

sub get_attrs {
    my ($self, $name) = @_;
    return $self->config;
}

sub needs_reload { 0 }

no Mouse; __PACKAGE__->meta->make_immutable; 1;
