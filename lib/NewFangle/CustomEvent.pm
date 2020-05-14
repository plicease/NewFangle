package NewFangle::CustomEvent {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use Carp ();

# ABSTRACT: NewRelic custom event class

=head1 SYNOPSIS

 use NewFangle;
 my $event = NewFangle::CustomEvent->new("my event");

=head1 DESCRIPTION

NewRelic custom event class.

=head1 CONSTRUCTOR

=head2 new

 my $event = NewFangle::CustomEvent->new($event_type);

Creates a NewRelic application custom event.

(csdk: newrelic_create_custom_event)

=cut

  $ffi->attach( [ create_custom_event => 'new' ] => ['string'] => 'newrelic_custom_event_t' => sub {
    my($xsub, undef, $event_type) = @_;
    my $self = $xsub->($event_type);
    Carp::croak("unable to create NewFangle::CustomEvent instance, see log for details") unless defined $self;
    $self;
  });

=head2 add_attribute_int

 $event->add_attribute_int($key, $value);

(csdk: newrelic_custom_event_add_attribute_int)

=head2 add_attribute_long

 $event->add_attribute_long($key, $value);

(csdk: newrelic_custom_event_add_attribute_long)

=head2 add_attribute_double

 $event->add_attribute_double($key, $value);

(csdk: newrelic_custom_event_add_attribute_double)

=head2 add_attribute_string

 $event->add_attribute_string($key, $value);

(csdk: newrelic_custom_event_add_attribute_string)

=cut

  $ffi->attach( [ "custom_event_add_attribute_$_" => "add_attribute_$_" ] => [ 'newrelic_custom_event_t', 'string', $_ ] => 'bool' )
    for qw( int long double string );

  $ffi->attach( [ discard_custom_event => 'DESTROY' ] => ['opaque*'] => 'bool' => sub {
    my($xsub, $self) = @_;
    my $ptr = $$self;
    $xsub->(\$ptr) if $ptr;
  });

};

1;

=head1 SEE ALSO

=over 4

=item L<NewFangle>

=back

=cut
