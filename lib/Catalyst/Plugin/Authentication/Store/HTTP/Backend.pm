package Catalyst::Plugin::Authentication::Store::HTTP::Backend;
use strict;
use warnings;

use Catalyst::Plugin::Authentication::User::Hash;
use LWP::UserAgent;

=head1 NAME

Catalyst::Plugin::Authentication::Atore::HTTP::Backend - HTTP authentication storage backend

=head1 SYNOPSIS

See L<Catalyst::Plugin::Authentication::Store::HTTP>.

=head1 DESCRIPTION

HTTP authentication storage backend

=head1 METHODS

=head2 new

=cut

sub new {
    my ( $class, $config ) = @_;

    bless {%$config}, $class;
}

=head2 get_user

=cut

sub get_user {
    my ( $self, $id ) = @_;

    return unless defined $self->{users}->{$id};

    my $password = $self->{users}->{$id};
    $self->{ua} ||= LWP::UserAgent->new;

    my $request = HTTP::Request->new( HEAD => $self->{auth_url} );
    $request->headers->authorization_basic( $id, $password );

    my $response = $self->{ua}->request( $request );

    return unless $response->is_success;
    return bless { id => $id }, 'Catalyst::Plugin::Authentication::User::Hash';
}

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;

