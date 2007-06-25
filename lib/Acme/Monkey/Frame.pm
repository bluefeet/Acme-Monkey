package Acme::Monkey::Frame;

use Moose;

use Acme::Monkey::ClearScreen;

extends 'Acme::Monkey::ClearScreen';

has 'width'   => (is=>'rw', isa=>'Int', required=>1);
has 'height'  => (is=>'rw', isa=>'Int', required=>1);

has 'layers' => (is=>'rw', isa=>'HashRef', default=>sub{ {} });

sub add_layer {
    my ($self, $key, $layer) = @_;

    $self->layers->{$key} = $layer;
}

sub draw {
    my ($self) = @_;

    $self->clear_screen();
    my @layers = map { $self->layers->{$_} } sort keys( %{ $self->layers() } );

    foreach my $y (1..$self->height()) {
        my $line = '';
        foreach my $x (1..$self->width()) {
            my $char;
            foreach my $layer (@layers) {
                $char = $layer->get(
                    $x - $layer->x() + 1,
                    $y - $layer->y() + 1,
                );
                if ($char) {
                    last;
                }
            }
            $char ||= ' ';
            $line .= $char;
        }
        print "$line\n";
    }
}

1;
