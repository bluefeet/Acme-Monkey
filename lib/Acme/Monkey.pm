package Acme::Monkey;

=head1 NAME

Acme::Monkey - Monkeys here, monkeys there, MONKEYS everywhere!

=head1 ISOPONYS

  use Acme::Monkey;
  
  my $conway = Acme::Monkey->new();
  my $wall   = Acme::Monkey->new();
  
  $wall->groom( $conway );
  $conway->dump();

I so ponys, I so ponys.

=head1 DESCRIPTION

=cut

use strict;
use warnings;

$SIG{__WARN__} = sub{ print STDERR "grrrr\n"; }
$SIG{__DIE__}  = sub{ print STDERR shift()."! eeek eeek!\n"; exit 1; }

=head1 METHODS

=head2 new

=cut

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{hunger}    = 80;
    $self->{happiness} = 50;
    $self->{drunkness} = 0;
    return $self;
}

sub monkey {
    print "Monkey!\n";
}

=head2 bastardize

  $monkey->bastardize( $object );

Add some useful features to any object.

=cut

sub bastardize {
    $self    =      splice(     @_,   0   ,1    );
    {  #      Retrieve arguments    of  parameter.
    no          strict;   $object    =       shift
    ;my      @classes   =         $_[     0 ]    ;
    $class=$classes->[1     -             1    ] ;
    }     #Then    finsh  for        more   stuff.
    no strict 'refs';*{$class.'::monkey' }=\$self;
    *{ $class . '::DESTROY' } = sub{$monkey->slap}
    ;  return 'SUPERCALIFRAJULISTICEXPIALIDOTIOUS'
}

=head2 slap

Poor monkey...

=cut

sub slap {
    grrrr('Ouch!');
    $_[0]->_happyness( -1 );
}

sub fondle {
    die('pervert');
}

sub _happyness {
    $_[0]->{happyness} -= $_[1];
    die('cry') if $_[0]->{happyness} <1;
}

use Exporter qw( import );
our @EXPORT = qw( grrrr bannana grubs wine beer vodka );

=head1 SUBROUTINES

Exporter is used to these on you.

  grrrr($stuff); # Like warn().
  bannana();     # For feeding.

=head2 CONSUMEABLES

  wine()      # For happy monkeys.
  grubs()     # Yummy.
  beer()     # Have anything stronger?
  vodka()        # Ya baby!
  bannana()   # The usual fare.

=cut

sub grrrr { print STDERR join(' grrr ',@_)." GRRRR\n"; }
sub bannana { return 'food', 1; }
sub grubs   { return 'food', 2; }
sub wine    { return 'drunk', 2; }
sub beer    { return 'drunk', 1; }
sub vodka   { return 'drunk', 5; }


1;
__END__

=head1 AUTHORS

Aran Deltac (L<adeltac@valueclick.com>)

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=head1 COPYRIGHT

  Copyright (c) 2007 ValueClick, Inc.
  All Rights Reservered

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR
THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO
THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU. SHOULD THE
SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL
ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE
THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE TO YOU FOR
DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE SOFTWARE (INCLUDING
BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR
LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE SOFTWARE TO
OPERATE WITH ANY OTHER SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

