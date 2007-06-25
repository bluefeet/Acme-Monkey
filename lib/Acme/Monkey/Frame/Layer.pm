package Acme::Monkey::Frame::Layer;

use Moose;

has 'x'       => (is=>'rw', isa=>'Int', default=>1);
has 'y'       => (is=>'rw', isa=>'Int', default=>1);

has 'width'   => (is=>'rw', isa=>'Int', required=>1);
has 'height'  => (is=>'rw', isa=>'Int', required=>1);

has '_canvas' => (is=>'rw', isa=>'ArrayRef', default=>\&clear, lazy=>1);

sub clear {
    my ($self) = @_;

    my $canvas = [];

    foreach my $x (1..$self->width()) {
        foreach my $y (1..$self->height()) {
            $canvas->[$x]->[$y] = '';
        }
    }

    $self->_canvas( $canvas );

    return $canvas;
}

sub set {
    my ($self, $x, $y, $char) = @_;

    $self->_canvas->[$x]->[$y] = $char;
}

sub get {
    my ($self, $x, $y) = @_;

    return '' if ($x<1 or $y<1 or $x>$self->width() or $y>$self->height());
    return $self->_canvas->[$x]->[$y] || '';
}

1;
