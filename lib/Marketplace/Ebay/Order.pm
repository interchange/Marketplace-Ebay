package Marketplace::Ebay::Order;

use strict;
use warnings;
use DateTime;
use DateTime::Format::ISO8601;
use Data::Dumper;

use Moo;
use MooX::Types::MooseLike::Base qw(Str HashRef);
use Marketplace::Ebay::Order::Address;
use Marketplace::Ebay::Order::Item;
use namespace::clean;

=head1 NAME

Marketplace::Ebay::Order

=head1 DESCRIPTION

Class to handle the xml structures found in the GetOrders call.

L<http://developer.ebay.com/devzone/xml/docs/Reference/ebay/GetOrders.html>

The aim is to have a consistent interface with
L<Amazon::MWS::XML::Order> so importing the orders can happens almost
transparently.

=cut

=head1 ACCESSORS/METHODS

=head2 order

The raw structure got from the XML parsing

=head2 shop_type

Always returns C<ebay>

=cut

has order => (is => 'ro', isa => HashRef, required => 1);

sub shop_type {
    return 'ebay';
}

=head2 order_number

read-write accessor for the (shop) order number so you can set this
while importing it.

=cut

has order_number => (is => 'rw', isa => Str);

=head2 can_be_imported

Return true if both orderstatus and checkout status are completed

=cut

sub can_be_imported {
    my ($self) = @_;
    my $order = $self->order;
    if ($order->{OrderStatus} eq 'Completed' and
        $order->{CheckoutStatus}->{Status} eq 'Complete') {
        return 1;
    }
    else {
        return 0;
    }
}

=head2 ebay_order_number

Ebay order id.

=head2 remote_shop_order_id

Same as C<ebay_order_number>

=cut

sub ebay_order_number {
    return shift->order->{OrderID};
}

sub remote_shop_order_id {
    return shift->ebay_order_number;
}

has shipping_address => (is => 'lazy');

sub _build_shipping_address {
    my $self = shift;
    my $address = $self->order->{ShippingAddress};
    return Marketplace::Ebay::Order::Address->new(%$address);
}

has items_ref => (is => 'lazy');

sub orderline {
    return shift->order->{TransactionArray}->{Transaction};
}

sub _build_items_ref {
    my ($self) = @_;
    my $orderline = $self->orderline;
    my @items;
    foreach my $item (@$orderline) {
        # print Dumper($item);
        push @items, Marketplace::Ebay::Order::Item->new(struct => $item);
    }
    return \@items;
}

sub items {
    my $self = shift;
    return @{ $self->items_ref };
}

sub order_date {
    
}

sub email {
    
}

sub first_name {
    
}
sub last_name {
    
}


1;
