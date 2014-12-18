package Marketplace::Ebay::Response;

use 5.010001;
use strict;
use warnings FATAL => 'all';

use Data::Dumper;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use namespace::clean;

=head1 NAME

Marketplace::Ebay::Response - Generic response parser for ebay api calls

=head1 SYNOPSIS

  my $ebay = Marketplace::Ebay->new(...);
  my $res = $ebay->api_call('GeteBayOfficialTime', {});
  if (defined($res)) {
      my $parsed = Marketplace::Ebay::Response->new(struct => $res);
      print "OK" if $parsed->is_success;
      if (defined $parsed->fees) {
          print "Total fees are " . $parsed->total_fees;
      }
  }

=head1 ACCESSORS

The constructor asks for a C<struct> key where the C<api_call> return
value should be saved. This module provide some convenience routines.

=head2 struct

The XML data deserialized into a perl hashref. It should be the return
value of L<Marketplace::Ebay>'s api_call, if defined.

=cut

has struct => (is => 'ro',
               isa => HashRef,
               required => 1);


=head1 SHORTCUTS

Given that we can't know beforehand which kind of response we have,
depending on the API version and on the used XSD, the convention for
all these shortcuts is to return undef when we can't reliably provide
an answer (this is true for booleans as well, which return 0 or 1).
C<undef> means that we don't know, so you're recommend to inspect the
C<struct> yourself to make sense of the unknown, if you're expecting
something.

=head2 is_success

Boolean.

=head2 version

The API version of the remote site.

=cut

sub is_success {
    my $self = shift;
    my $struct = $self->struct;
    if (exists $struct->{Ack}) {
        if ($struct->{Ack} eq 'Success') {
            return 1;
        }
        else {
            return 0;
        }
    }
    return;
}

sub version {
    my $self = shift;
    my $struct = $self->struct;
    if (exists $struct->{Version}) {
        return $struct->{Version};
    }
    return;
}

=head2 fees

The fees detail returned by an add_item (or equivalent) call.

=head2 total_listing_fee

As per documentation: The total cost of all listing features is found
in the Fees container whose Name is ListingFee. This does not reflect
the full cost of listing and selling an item on eBay, for the Final
Value Fee cannot be calculated by eBay until the listing has ended,
when a final sale price is known. Total cost is then the sum of the
Final Value Fee and the Fee corresponding to ListingFee.

L<http://developer.ebay.com/DevZone/guides/ebayfeatures/Development/Listing-Fees.html>

=cut

sub fees {
    my $self = shift;
    my $struct = $self->struct;
    if (exists $struct->{Fees}) {
        if (exists $struct->{Fees}->{Fee}) {
            my $fees = $struct->{Fees}->{Fee};
            if ($fees && @$fees) {
                my %out;
                FEE: foreach my $fee (@$fees) {
                      # we hope this structure is stable...
                      foreach my $k (qw/Name Fee/) {
                          unless (exists $fee->{$k}) {
                              warn "$k not found in fee:" . Dumper($fee);
                              next FEE;
                          }
                      }
                      $out{$fee->{Name}} ||= 0;
                      $out{$fee->{Name}} += $fee->{Fee}->{_};
                  }
                foreach my $k (keys %out) {
                    my $float = $out{$k};
                    $out{$k} = sprintf('%.2f', $float);
                }
                return \%out;
            }
        }
    }
    return;
}

sub total_listing_fee {
    my $self = shift;
    if (my $fees = $self->fees) {
        if (exists $fees->{ListingFee}) {
            return $fees->{ListingFee};
        }
    }
    return;
}


1;
