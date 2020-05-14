package NewFangle::Transaction {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use NewFangle::Segment;
  use Carp ();

# ABSTRACT: NewRelic application class

=head1 SYNOPSIS

 use NewFangle;
 my $app = NewFangle::App->new;
 $app->start_web_transaction("txn_name");

=head1 DESCRIPTION

NewRelic transaction class

=head1 METHODS

=head2 start_segment

 my $seg = $txn->start_segment($name, $category);

Start a new segment.  Returns L<NewFangle::Segment> instance.

(csdk: newrelic_start_segment)

=head2 start_datastore_segment

 my $seg = $txn->start_datastore_segment([$product, $collection, $operation, $host, $port_path_or_id, $database_name, $query]);

Start a new datastore segment.  Returns L<NewFangle::Segment> instance.

(csdk: newrelic_start_datastore_segment)

=head2 start_external_segment

 my $seg = $txn->start_external_segment([$uri,$method,$library]);

Start a new external segment.  Returns L<NewFangle::Segment> instance.

(csdk: newrelic_start_external_segment)

=cut

  sub _segment
  {
    my $xsub = shift;
    my $txn = shift;
    my $seg = $xsub->($txn, @_);
    $seg->{txn} = $txn;
    $seg;
  }

  $ffi->attach( start_segment           => ['newrelic_txn_t','string','string'] => 'newrelic_segment_t' => \&_segment );
  $ffi->attach( start_datastore_segment => ['newrelic_txn_t','string[7]']       => 'newrelic_segment_t' => \&_segment );
  $ffi->attach( start_external_segment  => ['newrelic_txn_t','string[3]']       => 'newrelic_segment_t' => \&_segment );

=head2 add_attribute_int

 my $bool = $txn->add_attribute_int($key, $value);

(csdk: newrelic_add_attribute_int)

=head2 add_attribute_long

 my $bool = $txn->add_attribute_long($key, $value);

(csdk: newrelic_add_attribute_long)

=head2 add_attribute_double

 my $bool = $txn->add_attribute_double($key, $value);

(csdk: newrelic_add_attribute_double)

=head2 add_attribute_string

 my $bool = $txn->add_attribute_string($key, $value);

(csdk: newrelic_add_attribute_string)

=cut

  $ffi->attach( "add_attribute_$_" => ['newrelic_txn_t','string',$_] => 'bool' )
    for qw( int long double string );

=head2 notice_error

 $txn->notice_error($priority, $errmsg, $errclass);

(csdk: newrelic_notice_error)

=cut

  $ffi->attach( "notice_error" => [ 'newrelic_txn_t', 'int', 'string', 'string' ] );

=head2 end

 my $bool = $txn->end;

Ends the transaction.

(csdk: newrelic_end_transaction)

=cut

  $ffi->attach( [ end_transaction => 'end' ] => ['opaque*'] => 'bool' );

  sub DESTROY
  {
    my($self) = @_;
    $self->end if defined $$self;
  }

};

1;

=head1 SEE ALSO

=over 4

=item L<NewFangle>

=back

=cut
