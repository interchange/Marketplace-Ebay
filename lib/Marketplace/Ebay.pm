package Marketplace::Ebay;

use 5.010001;
use strict;
use warnings FATAL => 'all';

use HTTP::Thin;
use HTTP::Request;
use XML::LibXML;
use XML::Compile::Schema;

use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use namespace::clean;

=head1 NAME

Marketplace::Ebay - Making API calls to eBay (with XSD validation)

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Marketplace::Ebay;

    my $foo = Marketplace::Ebay->new();
    ...

=head1 ACCESSORS

=head2 Credentials

The following are required for a successful API call.

=head3 developer_key

=head3 application_key

=head3 certificate_key

=head3 token

=cut

has developer_key =>   (is => 'ro', required => 1);
has application_key => (is => 'ro', required => 1);
has certificate_key => (is => 'ro', required => 1);
has token =>           (is => 'ro', required => 1);

has session_certificate => (is => 'lazy');

sub _build_session_certificate {
    my $self = shift;
    return join(';',
                $self->developer_key,
                $self->application_key,
                $self->certificate_key);
}

has xsd_file => (is => 'ro', required => 1);

has schema => (is => 'lazy');

sub _build_schema {
    my $self = shift;
    return XML::Compile::Schema->new($self->xsd_file);
}


=head1 METHODS

=head2 api_call($name, \%data)

=cut

sub api_call {

}

sub prepare_xml {
    my ($self, $name, $data) = @_;
    $data ||= {};
    # inject the token
    $data->{RequesterCredentials}->{eBayAuthToken} = $self->token;
    my $doc    = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $type = '{urn:ebay:apis:eBLBaseComponents}' . $name . 'Request';
    my $write  = $self->schema->compile(WRITER => $type,
                                        use_default_namespace => 1);
    my $xml    = $write->($doc, $data);
    return $xml->toString;
}


=head1 AUTHOR

Marco Pessotto, C<< <melmothx at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-marketplace-ebay at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Marketplace-Ebay>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Marketplace::Ebay


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Marketplace-Ebay>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Marketplace-Ebay>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Marketplace-Ebay>

=item * Search CPAN

L<http://search.cpan.org/dist/Marketplace-Ebay/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Marco Pessotto.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of Marketplace::Ebay
