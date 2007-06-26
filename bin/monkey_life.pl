#!/usr/bin/perl
use strict;
use warnings;

use Acme::Monkey::Frame;
use Acme::Monkey::Frame::Layer;
use Term::ANSIColor qw( :constants );
use Time::HiRes qw( sleep );
use Term::ReadKey;

my $frame = Acme::Monkey::Frame->new(
    width  => 20,
    height => 10,
);

my $background = Acme::Monkey::Frame::Layer->new(
    width  => $frame->width(),
    height => $frame->height(),
    color  => GREEN,
);

foreach my $x (1..$background->width()) {
foreach my $y (1..$background->height()) {
    my $folliage = int( rand() * 12) -6;
    if ($folliage < 3) {
        $background->set( $x, $y, '.' );
    }
    elsif ($folliage==3) {
        $background->set( $x, $y, '%' );
    }
    elsif ($folliage==4) {
        $background->set( $x, $y, 'X' );
    }
    else {
        $background->set( $x, $y, '+' );
    }
}
}

$frame->layers->{z} = $background;

my $food = Acme::Monkey::Frame::Layer->new(
    width  => $frame->width(),
    height => $frame->height(),
    color  => BOLD.YELLOW,
);
$frame->layers->{x} = $food;

my %monkeys;
my $monkey_id = 1;

sub create_monkey {
    my ($x, $y, $age) = @_;

    my $layer = Acme::Monkey::Frame::Layer->new(
        width  => 1,
        height => 1,
        x => $x,
        y => $y,
        color  => RED,
    );
    $age = 1;
#    $age ||= int(rand() * 100) + 1;
    $layer->set( 1, 1, age_char($age) );

    $frame->layers->{"monkey_$monkey_id"} = $layer;

    $monkeys{$monkey_id} = {
        layer  => $layer,
#        hunger => int(rand() * 20) + 1,
        hunger => 0,
        age    => $age,
        last_move => 0,
    };

    $monkey_id ++;
}

sub age_char {
    my ($age) = @_;

    return '.' if ($age < 7);
    return 'o' if ($age < 20);
    return '@' if ($age < 80);
    return '#';
}

sub add_food {
    $food->set(
        int(rand() * $frame->width()) + 1,
        int(rand() * $frame->height()) + 1,
        '/',
    );
}

ReadMode 4;
eval {

foreach (1..1000) {
    my $key = ReadKey( -1 ) || '';

    last if ($key =~ /[xq]/);

    if ($key eq 'c') {
        create_monkey(
            int(rand() * $frame->width()) + 1,
            int(rand() * $frame->height()) + 1,
        );
    }
    elsif ($key eq 'f') {
        add_food();
        add_food();
        add_food();
    }

    my $monkey_at = [];
    my $baby_had  = [];

    foreach my $id (keys %monkeys) {
        my $monkey = $monkeys{ $id };
        my $layer = $monkey->{layer};

        $monkey->{age} ++;
        if ($monkey->{age} > 100) {
            delete $frame->layers->{"monkey_$id"};
            delete $monkeys{ $id };
            next;
        }
        $layer->set( 1, 1, age_char($monkey->{age}) );

        $monkey->{hunger}++;
        if ($monkey->{hunger} > 40) {
            delete $frame->layers->{"monkey_$id"};
            delete $monkeys{ $id };
            next;
        }

        my $x = $layer->x();
        my $y = $layer->y();

        if ($food->get($x, $y)) {
            $monkey->{hunger} -= 3;
            $monkey->{hunger} = 0 if ($monkey->{hunger} < 0);
            $food->set($x, $y, "\t")
        }

        if ($monkey->{age} > 14 and $monkey->{age} < 50) {
        if ($monkey_at->[ $x ]->[ $y ]) {
            if (!$baby_had->[ $x ]->[ $y ]) {
                if ($monkey->{hunger}<30) {
                    create_monkey( $x, $y, 1 );
                    $baby_had->[ $x ]->[ $y ] = 1;
                    $monkey->{hunger} += 8;
                }
            }
        }
        }
        if ($monkey->{hunger}<15) {
            $monkey_at->[ $x ]->[ $y ] = 1;
        }

        my $move = int( rand() * 4 ) + 1;
        if ($monkey->{hunger} > 15) {
            $move=1 if ($food->get($x, $y-1));
            $move=2 if ($food->get($x, $y+1));
            $move=3 if ($food->get($x-1, $y));
            $move=4 if ($food->get($x+1, $y));
        }
        else {
            $move=1 if ($monkey_at->[$x]->[$y-1]);
            $move=2 if ($monkey_at->[$x]->[$y+1]);
            $move=3 if ($monkey_at->[$x-1]->[$y]);
            $move=4 if ($monkey_at->[$x+1]->[$y]);
        }

        if ($move==1) {
            next if ($monkey->{last_move} == 2);
            $layer->move_up() if ($y > 1);
        }
        elsif ($move==2) {
            next if ($monkey->{last_move} == 1);
            $layer->move_down() if ($y < $frame->height());
        }
        elsif ($move==3) {
            next if ($monkey->{last_move} == 4);
            $layer->move_left() if ($x > 1);
        }
        elsif ($move==4) {
            next if ($monkey->{last_move} == 3);
            $layer->move_right() if ($x < $frame->width());
        }

        $monkey->{last_move} = $move;
    }

    add_food();

    $frame->draw();

    print "\nc = Create new monkey baby.\nf = Create some bannanas to eat.\nx = Exit.";

    sleep 1;
}

};
ReadMode 0;

__END__

foreach (1..int( ($background->width() * $background->height()) / 8 )) {
    my $x = (int( rand() * $background->width() ) * 2) + 1;
    my $y = int( rand() * $background->height() ) + 1;
    my $char = ($background->get($x, $y)) ? 'o' : '.';
    $background->set( $x, $y, $char );
}

$frame->layers->{z} = $background;

my $ship = Acme::Monkey::Frame::Layer->new(
    x => 2,
    y => 4,
    width  => 4,
    height => 3,
    color  => BOLD.CYAN,
);
$ship->set(
    1, 1,
    join("\n",
        "-\\",
        "=@>",
        "-/",
    )
);
$frame->layers->{a} = $ship;

my $enemy = Acme::Monkey::Frame::Layer->new(
    x => $frame->width()-3,
    y => int( $frame->height() / 2 ),
    width  => 2,
    height => 1,
    color  => BOLD.GREEN,
);
$enemy->set( 1, 1, '<=' );
$frame->layers->{b} = $enemy;

my $laser = Acme::Monkey::Frame::Layer->new(
    width  => 2,
    height => 1,
    hidden => 1,
    color  => BOLD.RED,
);
$laser->set( 1, 1, '--' );
$frame->layers->{c} = $laser;

my $boom = Acme::Monkey::Frame::Layer->new(
    width  => 6,
    height => 3,
    hidden => 1,
    color  => BOLD.RED.BLINK,
);
$boom->set( 1, 1, "\t\\\t\t/\n-BOOM-\n\t/\t\t\\" );
$frame->layers->{d} = $boom;

$frame->draw();

ReadMode 4;
eval {

    my $key = ReadKey( -1 ) || '';

    last if ($key =~ /[xq]/);

    $ship->move_up() if ($key eq 'w');
    $ship->move_down() if ($key eq 's');
    $ship->move_left() if ($key eq 'a');
    $ship->move_right() if ($key eq 'd');

    if (rand() < .5) {
        $enemy->move_up() if ($enemy->y() > 1);
    }
    else {
        $enemy->move_down() if ($enemy->y() < $frame->height());
    }

    if ($key eq ' ') {
        if ($laser->hidden()) {
            $laser->hidden( 0 );
            $laser->x( $ship->x() );
            $laser->y( $ship->y() + 1 );
        }
    }

    if (!$laser->hidden()) {
        $laser->move_right( 2 );
        if ($laser->x() > $frame->width()) {
            $laser->hidden( 1 );
        }
        if ($laser->y() == $enemy->y() and $laser->x() >= $enemy->x()-1) {
            $laser->hidden( 1 );
            $enemy->hidden( 1 );
            $boom->y( $enemy->y() - 1 );
            $boom->x( $enemy->x() - 2 );
            $boom->hidden( 0 );
        }
    }

    $background->move_left();
foreach (1..1000) {
    $frame->draw();

    if (!$boom->hidden()) {
        print "\n\nYOU WON!!!\n";
        last;
    }

    sleep .2;
}

};
ReadMode 0;

