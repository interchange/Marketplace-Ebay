package Marketplace::Ebay::Order::Item;

# items must implement sku quantity price subtotal
# remote_shop_order_item
# and a rw merchant_order_item

use strict;
use warnings;

use Moo;
use MooX::Types::MooseLike::Base qw(HashRef Str);
use Data::Dumper;
use namespace::clean;

has struct => (is => 'ro', isa => HashRef);
has merchant_order_item => (is => 'rw', isa => Str);

sub sku {
    my $self = shift;
    return $self->variant_sku || $self->canonical_sku;
}

sub canonical_sku {
    # Item is always present
    return shift->struct->{Item}->{SKU};
}

sub variant_sku {
    my $self = shift;
    my $struct = $self->struct;
    if ($struct->{Variation}) {
        return $struct->{Variation}->{SKU};
    }
    else {
        return;
    }
}

sub remote_shop_order_item {
    return shift->struct->{OrderLineItemID};
}

# guaranteed to be there  http://developer.ebay.com/devzone/xml/docs/Reference/ebay/GetOrders.html#Response.OrderArray.Order.TransactionArray.Transaction.QuantityPurchased

sub quantity {
    return shift->struct->{QuantityPurchased};
}

# The price of the order line item (transaction). This amount does not
# take into account shipping, sales tax, and other costs related to
# the order line item. If multiple units were purchased through a non-
# variation, fixed-price listing, consider this value the per-unit
# price. In this case, the TransactionPrice would be multiplied by the
# Transaction.QuantityPurchased value.
sub price {
    my $self = shift;
    return sprintf('%.2f', $self->struct->{TransactionPrice}->{_});
}

sub subtotal {
    my $self = shift;
    return sprintf('%.2f', $self->price * $self->quantity);
}

sub shipping {
    return 0; # not available in the item
}

sub is_shipped {
    my $self = shift;
    return $self->struct->{ShippedTime};
}

sub email {
    return shift->struct->{Buyer}->{Email};
}
sub first_name {
    return shift->struct->{Buyer}->{UserFirstName};
}
sub last_name {
    return shift->struct->{Buyer}->{UserLastName};
}


1;

