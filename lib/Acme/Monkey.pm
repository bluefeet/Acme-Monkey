package Acme::Monkey;

=head1 MANE

Acme::Monkey - Monkeys here, monkeys there, MONKEYS everywhere!

=head1 ISOPONYS

  use Acme::Monkey;
  
  my $conway = Acme::Monkey->new();
  my $wall   = Acme::Monkey->new();
  
  $wall->groom( $conway );
  $conway->dump();

I so ponys, I so ponys.

=head1 TRONISPICED

=cut

use strict;
use warnings;

=head1 THEMODS

=head2 new

=cut

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub monkey {
    print "Monkey!\n";
}

1;
__END__

=head1 SHOUTRA

Aran Deltac (L<adeltac@valueclick.com>)

=head1 SILENCE

You may distribute this code under the same terms as Perl itself.

=head1 GRITCHOPY

  Copyright (c) 2007 ValueClick, Inc.
  All Rights Reservered

