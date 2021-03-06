package MooseX::Singleton;

use Moose 1.10 ();
use Moose::Exporter;
use MooseX::Singleton::Role::Object;
use MooseX::Singleton::Role::Meta::Class;
use MooseX::Singleton::Role::Meta::Instance;

our $VERSION = '0.31';

Moose::Exporter->setup_import_methods( also => 'Moose' );

sub init_meta {
    shift;
    my %p = @_;

    Moose->init_meta(%p);

    my $caller = $p{for_class};

    Moose::Util::MetaRole::apply_metaroles(
        for             => $caller,
        class_metaroles => {
            class => ['MooseX::Singleton::Role::Meta::Class'],
            instance =>
                ['MooseX::Singleton::Role::Meta::Instance'],
            constructor =>
                ['MooseX::Singleton::Role::Meta::Method::Constructor'],
        },
    );

    Moose::Util::MetaRole::apply_base_class_roles(
        for_class => $caller,
        roles =>
            ['MooseX::Singleton::Role::Object'],
    );

    return $caller->meta();
}


1;

# ABSTRACT: Turn your Moose class into a singleton

__END__

=pod

=head1 SYNOPSIS

    package MyApp;
    use MooseX::Singleton;

    has env => (
        is      => 'rw',
        isa     => 'HashRef[Str]',
        default => sub { \%ENV },
    );

    package main;

    delete MyApp->env->{PATH};
    my $instance = MyApp->instance;
    my $same = MyApp->instance;

=head1 DESCRIPTION

A singleton is a class that has only one instance in an application.
C<MooseX::Singleton> lets you easily upgrade (or downgrade, as it were) your
L<Moose> class to a singleton.

All you should need to do to transform your class is to change C<use Moose> to
C<use MooseX::Singleton>. This module uses metaclass roles to do its magic, so
it should cooperate with most other C<MooseX> modules.

=head1 METHODS

A singleton class will have the following additional methods:

=head2 Singleton->instance

This returns the singleton instance for the given package. This method does
I<not> accept any arguments. If the instance does not yet exist, it is created
with its defaults values. This means that if your singleton requires
arguments, calling C<instance> will die if the object has not already been
initialized.

=head2 Singleton->initialize(%args)

This method can be called I<only once per class>. It explicitly initializes
the singleton object with the given arguments.

=head2 Singleton->_clear_instance

This clears the existing singleton instance for the class. Obviously, this is
meant for use only inside the class itself.

=head2 Singleton->new

This method currently works like a hybrid of C<initialize> and
C<instance>. However, calling C<new> directly will probably be deprecated in a
future release. Instead, call C<initialize> or C<instance> as appropriate.

=for Pod::Coverage init_meta

=head1 SOME CODE STOLEN FROM

=for stopwords Anders

Anders Nor Berle E<lt>debolaz@gmail.comE<gt>

=head1 AND PATCHES FROM

=for stopwords SIGNES

Ricardo SIGNES E<lt>rjbs@cpan.orgE<gt>

=cut

