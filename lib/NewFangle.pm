package NewFangle {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use NewFangle::Config;
  use NewFangle::App;
  use NewFangle::CustomEvent;
  use base qw( Exporter );

# ABSTRACT: Unofficial Perl NewRelic SDK

=head1 SYNOPSIS

 use NewRelic;
 my $app = NewRelic::App->new('MyApp', $license_key);
 my $txn = $app->start_transaction('my transaction');
 $txn->end;

=head1 DESCRIPTION

This module provides bindings to the NewRelic C-SDK.  Since NewRelic doesn't provide
native Perl bindings for their product, and the older Agent SDK is not supported,
this is probably the best way to instrument your Perl application with NewRelic.

This distribution provides a light OO interface using L<FFI::Platypus> and will
optionally use L<Alien::libnewrelic> if the C-SDK can't be found in your library
path.  Unfortunately the naming convention used by NewRelic doesn't always have an
obvious mapping to the OO Perl interface, so I've added notation (example:
(csdk: newrelic_version)) so that the C version of functions and methods can be
found easily.  The documentation has decent coverage of all methods, but it doesn't
always make sense to reproduce everything that is in the C-SDK documentation, so
it is recommended that you review it before getting started.

I've called this module L<NewFangle> in the hopes that one day NewRelic will write
native Perl bindings and they can use the more obvious NewRelic namespace.

=head1 FUNCTIONS

These may be imported on request using L<Exporter>.

=head2 newrelic_configure_log

 my $bool = newrelic_configure_log($filename, $level);

Configure the C SDK's logging system.  C<$level> should be one of:

=over 4

=item C<error>

=item C<warning>

=item C<info>

=item C<debug>

=back

(csdk: newrelic_configure_log)

=head2 newrelic_init

 my $bool = newrelic_init($daemon_socket, $time_limit_ms);

Initialize the C SDK with non-default settings.

(csdk: newrelic_init)

=head2 newrelic_version

 my $version = newrelic_version();

(csdk: newrelic_version)

Returns the

=cut

  $ffi->mangler(sub { $_[0] });
  $ffi->attach( newrelic_configure_log => ['string','newrelic_loglevel_t' ] => 'bool'   );
  $ffi->attach( newrelic_init          => ['string','int' ]                 => 'bool'   );
  $ffi->attach( newrelic_version       => []                                => 'string' );
  $ffi->mangler(sub { "newrelic_$_[0]" });

  our @EXPORT_OK = grep /^newrelic_/, keys %NewFangle::;

};

1;

=head1 ENVIRONMENT

=over 4

=item C<NEWRELIC_APP_NAME>

The default app name, if not specified in the configuration.

=item C<NEWRELIC_LICENSE_KEY>

The NewRelic license key.

=back

=head1 CAVEATS

Unlike the older NewRelic Agent SDK, there is no interface to set the programming
language or version.  Since we are using the C-SDK the language shows up as C<C>
instead of C<Perl>.

=head1 SEE ALSO

=over 4

=item L<NewFangle::App>

=item L<NewFangle::Config>

=item L<NewFangle::CustomEvent>

=item L<NewFangle::Segment>

=item L<NewFangle::Transaction>

=back

=cut
