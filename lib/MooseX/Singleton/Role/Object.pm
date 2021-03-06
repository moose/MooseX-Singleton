package MooseX::Singleton::Role::Object;
use Moose::Role;
use Carp qw( confess );

our $VERSION = '0.31';

sub instance { shift->new }

sub initialize {
    my ( $class, @args ) = @_;

    my $existing = $class->meta->existing_singleton;
    confess "Singleton is already initialized" if $existing;

    return $class->new(@args);
}

override new => sub {
    my ( $class, @args ) = @_;

    my $existing = $class->meta->existing_singleton;
    confess "Singleton is already initialized" if $existing and @args;

    # Otherwise BUILD will be called repeatedly on the existing instance.
    # -- rjbs, 2008-02-03
    return $existing if $existing and !@args;

    return super();
};

sub _clear_instance {
    my ($class) = @_;
    $class->meta->clear_singleton;
}

no Moose::Role;

1;

# ABSTRACT: Object class role for MooseX::Singleton

__END__

=pod

=head1 DESCRIPTION

=for Pod::Coverage *EVERYTHING*

This just adds C<instance> as a shortcut for C<new>.

=cut

