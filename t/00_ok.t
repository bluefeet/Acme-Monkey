#!/usr/bin/perl

use Test::More tests => 1;

ok( 1, 'Its all good baby.' );

__END__


use Acme::Monkey;



__END__


require Term::ReadKey;
Term::ReadKey::ReadMode( 4 );

my $width = 60;

my $buff = Acme::Monkey::ScreenBuffer->new( $width, 20 );

my $last_y = 20;
my $y = $last_y;
$buff->put(1,$y,'-');
my @land;

foreach my $x (2..$width) {
    my $alt = int( rand() * 3 );
    if ($alt==0) {
        $y-- if ($y>10);
    }
    elsif ($alt==2) {
        $y++ if ($y<20);
    }
    push @land, $y;
    my $char = ($y<$last_y) ? '/' : ($y>$last_y) ? '\\' : '-';
    $buff->put($x, $y, $char);
    $last_y = $y;
}

$buff->put( 1, $monkey_y, '@' );

$buff->display();

my $jump_start;
my $jump_height;
my $is_jumping = 0;

while (1) {
    my $y = shift @land;
    $buff->scroll_left();
    my $key = Term::ReadKey::ReadKey( -1 );

    if ($key) {
        last if $key =~ /x/;
        if ($key =~ / / and !$is_jumping) {
            $is_jumping = 1;
            $jump_height = 1;
            $jump_start = $y;
        }
    }
    $buff->display();
    sleep 1;
}

Term::ReadKey::ReadMode( 1 );

__END__

$buff->put( 1, 20, '-' );




foreach my $x (3..10) {
    $buff->put( $x-1, 10, '.' );
    $buff->put( $x, 10, 'o' );
    $buff->display();
    sleep 1;
}


$buff->flush();
$buff->put(10,10,'O');

foreach my $x (3..10) {
    $buff->scroll_left();
    $buff->display();
    sleep 1;
}



