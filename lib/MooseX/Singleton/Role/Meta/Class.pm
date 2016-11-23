package MooseX::Singleton::Role::Meta::Class;
use Moose::Role;
use MooseX::Singleton::Role::Meta::Instance;
use MooseX::Singleton::Role::Meta::Method::Constructor;

our $VERSION = '0.31';

sub existing_singleton {
    my ($class) = @_;
    my $pkg = $class->name;

    no strict 'refs';

    # create exactly one instance
    if ( defined ${"$pkg\::singleton"} ) {
        return ${"$pkg\::singleton"};
    }

    return;
}

sub clear_singleton {
    my ($class) = @_;
    my $pkg = $class->name;
    no strict 'refs';
    undef ${"$pkg\::singleton"};
}

override _construct_instance => sub {
    my ($class) = @_;

    # create exactly one instance
    my $existing = $class->existing_singleton;
    return $existing if $existing;

    my $pkg = $class->name;
    no strict 'refs';
    no warnings 'once';
    return ${"$pkg\::singleton"} = super;
};

if ( $Moose::VERSION >= 1.9900 ) {
    override _inline_params => sub {
        my $self = shift;

        return
            'my $existing = do {',
                'no strict "refs";',
                'no warnings "once";',
                '\${"$class\::singleton"};',
            '};',
            'return ${$existing} if ${$existing};',
            super();
    };

    override _inline_extra_init => sub {
        my $self = shift;

        return '${$existing} = $instance;';
    };
}

no Moose::Role;

1;

# ABSTRACT: Metaclass role for MooseX::Singleton

__END__

=pod

=for Pod::Coverage *EVERYTHING*

=head1 DESCRIPTION

This metaclass role makes sure that there is only ever one instance of an
object for a singleton class. The first call to C<construct_instance> is run
normally (and then cached). Subsequent calls will return the cached version.

=cut

