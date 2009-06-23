#!/usr/bin/perl -w
use strict;
use Test::More tests => 7;

BEGIN { use_ok('WWW::Gazetteer'); }

my $g = WWW::Gazetteer->new('fallingrain');
is_deeply(
    $g->find( "London", "United Kingdom" )->[0],
    {   longitude => "-0.1167",
        latitude  => "51.5000",
        city      => 'London',
        country   => 'United Kingdom',
        elevation => "14",
    }
);
is_deeply(
    $g->find( "United Kingdom", "London" )->[0],
    {   longitude => "-0.1167",
        latitude  => "51.5000",
        city      => 'London',
        country   => 'United Kingdom',
        elevation => "14",
    }
);
is_deeply(
    $g->find( "UK" => "London" )->[0],
    {   longitude => "-0.1167",
        latitude  => "51.5000",
        city      => 'London',
        country   => 'UK',
        elevation => "14",
    }
);

my $nice = ( $g->find( FR => "Nice" ) )[0];
is_deeply(
    $nice,
    {   longitude => "7.2500",
        latitude  => "43.7000",
        city      => 'Nice',
        country   => 'FR',
        elevation => "0",
    }
);
$nice = $g->find( "Nice", "France" )->[0];
is_deeply(
    $nice,
    {   longitude => "7.2500",
        latitude  => "43.7000",
        city      => 'Nice',
        country   => 'France',
        elevation => "0",
    }
);

is_deeply(
    [ $g->find( "Bacton", "United Kingdom" ) ],
    [   {   longitude => "-2.9167",
            latitude  => "51.9833",
            city      => 'Bacton',
            country   => 'United Kingdom',
            elevation => "103",
        },
        {   longitude => "1.0167",
            latitude  => "52.2667",
            city      => 'Bacton',
            country   => 'United Kingdom',
            elevation => "52",
        },
        {   longitude => "1.4667",
            latitude  => "52.8500",
            city      => 'Bacton',
            country   => 'United Kingdom',
            elevation => "0",
        },
    ]
);
