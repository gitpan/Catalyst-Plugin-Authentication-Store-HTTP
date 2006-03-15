package Catalyst::Plugin::Authentication::Store::HTTP;
use strict;
use warnings;

our $VERSION = '0.04';

use Catalyst::Exception;
use Catalyst::Plugin::Authentication::Store::HTTP::Backend;

=head1 NAME

Catalyst::Plugin::Authentication::Store::HTTP - Remote HTTP authentication storage

=head1 SYNOPSIS

    # load plugins
    use Catalyst qw/
        Session
        Session::State::Cookie
        Session::Store::FastMmap
    
        Authentication
        Authentication::Store::HTTP
        Authentication::Credential::Password
        # or Authentication::Credential::HTTP
        /;
    
    # configure your authentication host
    MyApp->config(
        authentication => {
            http => {
                auth_url => 'http://example.com/',
            },
        },
    );
    
    # and in action
    sub login : Global {
        my ( $self, $c ) = @_;
    
        $c->login( $username, $password );
    }

=head1 DESCRIPTION

This module is Catalyst authentication storage plugin that use Basic authentication of remote host.

This is re-implementation of L<Catalyst::Plugin::Authentication::Basic::Remote>.

=head1 EXTENDED METHODS

=head2 setup

=cut

sub setup {
    my $c = shift;

    unless ($c->config->{authentication}{http}{auth_url}) {
        Catalyst::Exception->throw(
            message => qq/Require auth_url for Authentication::Store::HTTP/
        );
    }

    $c->default_auth_store(
        Catalyst::Plugin::Authentication::Store::HTTP::Backend->new(
            $c->config->{authentication}{http}
        )
    );

    $c->NEXT::setup(@_);
}

=head1 SEE ALSO

L<Catalyst::Plugin::Authentication>.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;

