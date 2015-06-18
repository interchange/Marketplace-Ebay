package Marketplace::Ebay::Order::Address;

use Moo;
use MooX::Types::MooseLike::Base qw(Str);
use namespace::clean;

has Name => (is => 'ro', isa => Str);
has Street1 => (is => 'ro', isa => Str);
has Street2 => (is => 'ro', isa => Str);
has CityName => (is => 'ro', isa => Str);
has PostalCode => (is => 'ro', isa => Str);
has StateOrProvince => (is => 'ro', isa => Str);
has Country => (is => 'ro', isa => Str);
has CountryName => (is => 'ro', isa => Str);
has Phone => (is => 'ro', isa => Str);
has AddressOwner => (is => 'ro', isa => Str);
has ExternalAddressID => (is => 'ro', isa => Str);
has AddressID => (is => 'ro', isa => Str);

sub address1 {
    return shift->Street1;
}

sub address2 {
    return shift->Street2;
}

sub name {
    return shift->Name;
}

sub city {
    return shift->CityName;
}

sub state {
    return shift->StateOrProvince;
}

sub zip {
    return shift->PostalCode;
}

sub phone {
    my $self = shift;
    my $phone = $self->Phone;
    if ($phone and $phone eq 'Invalid Request') {
        return '';
    }
    else {
        return $phone;
    }
}

sub country {
    return shift->Country;
}

1;
