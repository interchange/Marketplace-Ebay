package Marketplace::Ebay::Order::Item;

use strict;
use warnings;

use Moo;
use MooX::Types::MooseLike::Base qw(HashRef);
use namespace::clean;

has struct => (is => 'ro', isa => HashRef);

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

1;

