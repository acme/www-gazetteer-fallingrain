package WWW::Gazetteer::FallingRain;
use strict;
use Carp qw(croak);
use HTTP::Cookies;
use LWP::UserAgent;

use vars qw($VERSION);
$VERSION = '0.14';

my $countries = {
    'aw'                     => 'AA',
    'aruba'                  => 'AA',
    'ag'                     => 'AC',
    'antigua and barbuda'    => 'AC',
    'ae'                     => 'AE',
    'united arab emirates'   => 'AE',
    'af'                     => 'AF',
    'afghanistan'            => 'AF',
    'ag'                     => 'AG',
    'antigua and barbuda'    => 'AG',
    'az'                     => 'AJ',
    'azerbaijan'             => 'AJ',
    'al'                     => 'AL',
    'albania'                => 'AL',
    'am'                     => 'AM',
    'armenia'                => 'AM',
    'an'                     => 'AN',
    'netherlands antilles'   => 'AN',
    'ao'                     => 'AO',
    'angola'                 => 'AO',
    'ar'                     => 'AR',
    'argentina'              => 'AR',
    'as'                     => 'AS',
    'american samoa'         => 'AS',
    'at'                     => 'AT',
    'austria'                => 'AT',
    'au'                     => 'AU',
    'australia'              => 'AU',
    'ai'                     => 'AV',
    'anguilla'               => 'AV',
    'ba'                     => 'BA',
    'bosnia and herzegovina' => 'BA',
    'bb'                     => 'BB',
    'barbados'               => 'BB',
    'bw'                     => 'BC',
    'botswana'               => 'BC',
    'bd'                     => 'BD',
    'bangladesh'             => 'BD',
    'be'                     => 'BE',
    'belgium'                => 'BE',
    'bf'                     => 'BF',
    'burkina faso'           => 'BF',
    'bg'                     => 'BG',
    'bulgaria'               => 'BG',
    'bh'                     => 'BH',
    'bahrain'                => 'BH',
    'ba'                     => 'BK',
    'bosnia and herzegovina' => 'BK',
    'bo'                     => 'BL',
    'bolivia'                => 'BL',
    'bm'                     => 'BM',
    'bermuda'                => 'BM',
    'bn'                     => 'BN',
    'brunei darussalam'      => 'BN',
    'bo'                     => 'BO',
    'bolivia'                => 'BO',

    # Missing code for Soloman Islands
    'br'            => 'BR',
    'brazil'        => 'BR',
    'bs'            => 'BS',
    'bahamas'       => 'BS',
    'bt'            => 'BT',
    'bhutan'        => 'BT',
    'bg'            => 'BU',
    'bulgaria'      => 'BU',
    'bv'            => 'BV',
    'bouvet island' => 'BV',

    # Missing code for Brunei
    'by'                                    => 'BY',
    'belarus'                               => 'BY',
    'ca'                                    => 'CA',
    'canada'                                => 'CA',
    'kh'                                    => 'CB',
    'cambodia'                              => 'CB',
    'cd'                                    => 'CD',
    'congo, the democratic republic of the' => 'CD',
    'lk'                                    => 'CE',
    'sri lanka'                             => 'CE',
    'cf'                                    => 'CF',
    'central african republic'              => 'CF',
    'cg'                                    => 'CG',
    'congo'                                 => 'CG',
    'ch'                                    => 'CH',
    'switzerland'                           => 'CH',
    'ci'                                    => 'CI',
    'cote d\'ivoire'                        => 'CI',
    'ky'                                    => 'CJ',
    'cayman islands'                        => 'CJ',
    'ck'                                    => 'CK',
    'cook islands'                          => 'CK',
    'cm'                                    => 'CM',
    'cameroon'                              => 'CM',
    'cn'                                    => 'CN',
    'china'                                 => 'CN',
    'co'                                    => 'CO',
    'colombia'                              => 'CO',
    'cr'                                    => 'CR',
    'costa rica'                            => 'CR',
    'cs'                                    => 'CS',
    'serbia and montenegro'                 => 'CS',
    'cf'                                    => 'CT',
    'central african republic'              => 'CT',
    'cu'                                    => 'CU',
    'cuba'                                  => 'CU',
    'cv'                                    => 'CV',
    'cape verde'                            => 'CV',
    'ck'                                    => 'CW',
    'cook islands'                          => 'CW',
    'cy'                                    => 'CY',
    'cyprus'                                => 'CY',
    'dk'                                    => 'DA',
    'denmark'                               => 'DA',
    'dj'                                    => 'DJ',
    'djibouti'                              => 'DJ',
    'do'                                    => 'DO',
    'dominican republic'                    => 'DO',
    'do'                                    => 'DR',
    'dominican republic'                    => 'DR',
    'ec'                                    => 'EC',
    'ecuador'                               => 'EC',
    'eg'                                    => 'EG',
    'egypt'                                 => 'EG',
    'ie'                                    => 'EI',
    'ireland'                               => 'EI',
    'gq'                                    => 'EK',
    'equatorial guinea'                     => 'EK',
    'ee'                                    => 'EN',
    'estonia'                               => 'EN',
    'er'                                    => 'ER',
    'eritrea'                               => 'ER',
    'es'                                    => 'ES',
    'spain'                                 => 'ES',
    'et'                                    => 'ET',
    'ethiopia'                              => 'ET',

    # Missing code for Europa Island
    'cz'                              => 'EZ',
    'czech republic'                  => 'EZ',
    'gf'                              => 'FG',
    'french guiana'                   => 'FG',
    'fi'                              => 'FI',
    'finland'                         => 'FI',
    'fj'                              => 'FJ',
    'fiji'                            => 'FJ',
    'fk'                              => 'FK',
    'falkland islands (malvinas)'     => 'FK',
    'fm'                              => 'FM',
    'micronesia, federated states of' => 'FM',
    'fo'                              => 'FO',
    'faroe islands'                   => 'FO',
    'pf'                              => 'FP',
    'french polynesia'                => 'FP',
    'fr'                              => 'FR',
    'france'                          => 'FR',

    # Missing code for French Southern and Antarctic Islands
    'ga'             => 'GA',
    'gabon'          => 'GA',
    'gb'             => 'GB',
    'united kingdom' => 'GB',
    'ge'             => 'GG',
    'georgia'        => 'GG',
    'gh'             => 'GH',
    'ghana'          => 'GH',
    'gi'             => 'GI',
    'gibraltar'      => 'GI',
    'gd'             => 'GJ',
    'grenada'        => 'GJ',

    # Missing code for Guernsey
    'gl'        => 'GL',
    'greenland' => 'GL',
    'gm'        => 'GM',
    'gambia'    => 'GM',

    # Missing code for Glorioso Islands
    'gp'         => 'GP',
    'guadeloupe' => 'GP',
    'gr'         => 'GR',
    'greece'     => 'GR',
    'gt'         => 'GT',
    'guatemala'  => 'GT',
    'gn'         => 'GV',
    'guinea'     => 'GV',
    'gy'         => 'GY',
    'guyana'     => 'GY',

    # Missing code for Gaza Strip
    'ht'                                => 'HA',
    'haiti'                             => 'HA',
    'hk'                                => 'HK',
    'hong kong'                         => 'HK',
    'hm'                                => 'HM',
    'heard island and mcdonald islands' => 'HM',
    'hn'                                => 'HO',
    'honduras'                          => 'HO',
    'hr'                                => 'HR',
    'croatia'                           => 'HR',
    'hu'                                => 'HU',
    'hungary'                           => 'HU',
    'is'                                => 'IC',
    'iceland'                           => 'IC',
    'id'                                => 'ID',
    'indonesia'                         => 'ID',

    # Missing code for Man, Isle of
    'in'                             => 'IN',
    'india'                          => 'IN',
    'io'                             => 'IO',
    'british indian ocean territory' => 'IO',

    # Missing code for Clipperton Island
    'ir'                        => 'IR',
    'iran, islamic republic of' => 'IR',
    'is'                        => 'IS',
    'iceland'                   => 'IS',
    'it'                        => 'IT',
    'italy'                     => 'IT',

    # Missing code for Cote D'Ivoire (Ivory Coast)
    'iq'    => 'IZ',
    'iraq'  => 'IZ',
    'jp'    => 'JA',
    'japan' => 'JA',

    # Missing code for Jersey
    'jm'                     => 'JM',
    'jamaica'                => 'JM',
    'sj'                     => 'JN',
    'svalbard and jan mayen' => 'JN',
    'jo'                     => 'JO',
    'jordan'                 => 'JO',

    # Missing code for Juan De Nova Island
    'ke'                    => 'KE',
    'kenya'                 => 'KE',
    'kg'                    => 'KG',
    'kyrgyzstan'            => 'KG',
    'kn'                    => 'KN',
    'saint kitts and nevis' => 'KN',
    'kr'                    => 'KR',
    'korea, republic of'    => 'KR',

    # Missing code for Korea, Republic of (South)
    'cx'                                => 'KT',
    'christmas island'                  => 'KT',
    'kw'                                => 'KU',
    'kuwait'                            => 'KU',
    'kz'                                => 'KZ',
    'kazakhstan'                        => 'KZ',
    'la'                                => 'LA',
    'lao people\'s democratic republic' => 'LA',
    'lb'                                => 'LE',
    'lebanon'                           => 'LE',
    'lv'                                => 'LG',
    'latvia'                            => 'LG',
    'lt'                                => 'LH',
    'lithuania'                         => 'LH',
    'li'                                => 'LI',
    'liechtenstein'                     => 'LI',
    'sk'                                => 'LO',
    'slovakia'                          => 'LO',
    'ls'                                => 'LS',
    'lesotho'                           => 'LS',
    'lt'                                => 'LT',
    'lithuania'                         => 'LT',
    'lu'                                => 'LU',
    'luxembourg'                        => 'LU',
    'ly'                                => 'LY',
    'libyan arab jamahiriya'            => 'LY',
    'ma'                                => 'MA',
    'morocco'                           => 'MA',

    # Missing code for Martinque
    'mc'                                         => 'MC',
    'monaco'                                     => 'MC',
    'md'                                         => 'MD',
    'moldova, republic of'                       => 'MD',
    'yt'                                         => 'MF',
    'mayotte'                                    => 'MF',
    'mg'                                         => 'MG',
    'madagascar'                                 => 'MG',
    'mh'                                         => 'MH',
    'marshall islands'                           => 'MH',
    'mw'                                         => 'MI',
    'malawi'                                     => 'MI',
    'mk'                                         => 'MK',
    'macedonia, the former yugoslav republic of' => 'MK',
    'ml'                                         => 'ML',
    'mali'                                       => 'ML',
    'mn'                                         => 'MN',
    'mongolia'                                   => 'MN',
    'mo'                                         => 'MO',
    'macao'                                      => 'MO',
    'mp'                                         => 'MP',
    'northern mariana islands'                   => 'MP',
    'mr'                                         => 'MR',
    'mauritania'                                 => 'MR',
    'mt'                                         => 'MT',
    'malta'                                      => 'MT',
    'mu'                                         => 'MU',
    'mauritius'                                  => 'MU',
    'mv'                                         => 'MV',
    'maldives'                                   => 'MV',
    'mx'                                         => 'MX',
    'mexico'                                     => 'MX',
    'my'                                         => 'MY',
    'malaysia'                                   => 'MY',
    'mz'                                         => 'MZ',
    'mozambique'                                 => 'MZ',
    'nc'                                         => 'NC',
    'new caledonia'                              => 'NC',
    'ne'                                         => 'NE',
    'niger'                                      => 'NE',
    'nf'                                         => 'NF',
    'norfolk island'                             => 'NF',
    'ng'                                         => 'NG',
    'nigeria'                                    => 'NG',
    'vu'                                         => 'NH',
    'vanuatu'                                    => 'NH',
    'ni'                                         => 'NI',
    'nicaragua'                                  => 'NI',
    'nl'                                         => 'NL',
    'netherlands'                                => 'NL',

    # Missing code for No Man's Land
    'no'                   => 'NO',
    'norway'               => 'NO',
    'np'                   => 'NP',
    'nepal'                => 'NP',
    'nr'                   => 'NR',
    'nauru'                => 'NR',
    'sr'                   => 'NS',
    'suriname'             => 'NS',
    'an'                   => 'NT',
    'netherlands antilles' => 'NT',
    'nu'                   => 'NU',
    'niue'                 => 'NU',
    'nz'                   => 'NZ',
    'new zealand'          => 'NZ',
    'pa'                   => 'PA',
    'panama'               => 'PA',

    # Missing code for Pitcairn Islands
    'pe'                                           => 'PE',
    'peru'                                         => 'PE',
    'pf'                                           => 'PF',
    'french polynesia'                             => 'PF',
    'pg'                                           => 'PG',
    'papua new guinea'                             => 'PG',
    'pk'                                           => 'PK',
    'pakistan'                                     => 'PK',
    'pl'                                           => 'PL',
    'poland'                                       => 'PL',
    'pm'                                           => 'PM',
    'saint pierre and miquelon'                    => 'PM',
    'pt'                                           => 'PO',
    'portugal'                                     => 'PO',
    'pg'                                           => 'PP',
    'papua new guinea'                             => 'PP',
    'ps'                                           => 'PS',
    'palestinian territory, occupied'              => 'PS',
    'gw'                                           => 'PU',
    'guinea-bissau'                                => 'PU',
    'qa'                                           => 'QA',
    'qatar'                                        => 'QA',
    're'                                           => 'RE',
    'reunion'                                      => 'RE',
    'mh'                                           => 'RM',
    'marshall islands'                             => 'RM',
    'ro'                                           => 'RO',
    'romania'                                      => 'RO',
    'ph'                                           => 'RP',
    'philippines'                                  => 'RP',
    'ru'                                           => 'RS',
    'russian federation'                           => 'RS',
    'rw'                                           => 'RW',
    'rwanda'                                       => 'RW',
    'sa'                                           => 'SA',
    'saudi arabia'                                 => 'SA',
    'sb'                                           => 'SB',
    'solomon islands'                              => 'SB',
    'sc'                                           => 'SC',
    'seychelles'                                   => 'SC',
    'se'                                           => 'SE',
    'sweden'                                       => 'SE',
    'za'                                           => 'SF',
    'south africa'                                 => 'SF',
    'sg'                                           => 'SG',
    'singapore'                                    => 'SG',
    'sh'                                           => 'SH',
    'saint helena'                                 => 'SH',
    'si'                                           => 'SI',
    'slovenia'                                     => 'SI',
    'sl'                                           => 'SL',
    'sierra leone'                                 => 'SL',
    'sm'                                           => 'SM',
    'san marino'                                   => 'SM',
    'sn'                                           => 'SN',
    'senegal'                                      => 'SN',
    'so'                                           => 'SO',
    'somalia'                                      => 'SO',
    'es'                                           => 'SP',
    'spain'                                        => 'SP',
    'st'                                           => 'ST',
    'sao tome and principe'                        => 'ST',
    'sd'                                           => 'SU',
    'sudan'                                        => 'SU',
    'sv'                                           => 'SV',
    'el salvador'                                  => 'SV',
    'se'                                           => 'SW',
    'sweden'                                       => 'SW',
    'gs'                                           => 'SX',
    'south georgia and the south sandwich islands' => 'SX',
    'sy'                                           => 'SY',
    'syrian arab republic'                         => 'SY',
    'sz'                                           => 'SZ',
    'swaziland'                                    => 'SZ',
    'td'                                           => 'TD',
    'chad'                                         => 'TD',

    # Missing code for Tromelin Island
    'th'                               => 'TH',
    'thailand'                         => 'TH',
    'tj'                               => 'TI',
    'tajikistan'                       => 'TI',
    'tk'                               => 'TK',
    'tokelau'                          => 'TK',
    'tl'                               => 'TL',
    'timor-leste'                      => 'TL',
    'tn'                               => 'TN',
    'tunisia'                          => 'TN',
    'to'                               => 'TO',
    'tonga'                            => 'TO',
    'st'                               => 'TP',
    'sao tome and principe'            => 'TP',
    'tn'                               => 'TS',
    'tunisia'                          => 'TS',
    'tt'                               => 'TT',
    'trinidad and tobago'              => 'TT',
    'tr'                               => 'TU',
    'turkey'                           => 'TU',
    'tv'                               => 'TV',
    'tuvalu'                           => 'TV',
    'tw'                               => 'TW',
    'taiwan, province of china'        => 'TW',
    'tm'                               => 'TX',
    'turkmenistan'                     => 'TX',
    'tz'                               => 'TZ',
    'tanzania, united republic of'     => 'TZ',
    'ug'                               => 'UG',
    'uganda'                           => 'UG',
    'gb'                               => 'UK',
    'united kingdom'                   => 'UK',
    'ua'                               => 'UP',
    'ukraine'                          => 'UP',
    'us'                               => 'US',
    'united states'                    => 'US',
    'bf'                               => 'UV',
    'burkina faso'                     => 'UV',
    'uy'                               => 'UY',
    'uruguay'                          => 'UY',
    'uz'                               => 'UZ',
    'uzbekistan'                       => 'UZ',
    'vc'                               => 'VC',
    'saint vincent and the grenadines' => 'VC',
    've'                               => 'VE',
    'venezuela'                        => 'VE',
    'vi'                               => 'VI',
    'virgin islands, u.s.'             => 'VI',
    'vn'                               => 'VM',
    'vietnam'                          => 'VM',

    # Missing code for Vatican City
    'na'      => 'WA',
    'namibia' => 'WA',

    # Missing code for West Bank
    'wf'                    => 'WF',
    'wallis and futuna'     => 'WF',
    'eh'                    => 'WI',
    'western sahara'        => 'WI',
    'ws'                    => 'WS',
    'samoa'                 => 'WS',
    'sz'                    => 'WZ',
    'swaziland'             => 'WZ',
    'cs'                    => 'YI',
    'serbia and montenegro' => 'YI',
    'ye'                    => 'YM',
    'yemen'                 => 'YM',
    'za'                    => 'ZA',
    'south africa'          => 'ZA',
    'zw'                    => 'ZI',
    'zimbabwe'              => 'ZI',
    'uk'                    => 'UK',
};

sub new {
    my ($class) = @_;

    my $self = {};
    my $ua   = LWP::UserAgent->new(
        env_proxy  => 1,
        keep_alive => 1,
        timeout    => 30,
    );
    $ua->agent( "WWW::Gazetteer::FallingRain/$VERSION " . $ua->agent );

    $self->{ua} = $ua;

    bless $self, $class;
    return $self;
}

sub find {
    my ( $self, $city, $country ) = @_;

    my $ua = $self->{ua};

    my $base_url    = 'http://www.fallingrain.com/world/';
    my $countrycode = $countries->{ lc $country };
    if ( not defined $countrycode ) {
        ( $city, $country ) = ( $country, $city );
        $countrycode = $countries->{ lc $country };
        if ( not defined $countrycode ) {
            croak(
                "WWW::Gazetteer::FallingRain: Country $city / $country not found"
            );
            return;
        }
    }

    my @chars;
    foreach my $i ( 0 .. length($city) - 1 ) {
        $chars[$i] = substr( $city, $i, 1 );
    }
    @chars = map {
        if ( $_ eq ' ' )
        {
            "32";
        } else {
            $_;
        }
    } @chars;

    my @urls;
    {
        no warnings "uninitialized";
        @urls = (
            "$base_url$countrycode/a/"
                . $chars[0] . "/"
                . $chars[1] . "/"
                . $chars[2] . "/"
                . $chars[3] . "/"
                . $chars[4] . "/",
            "$base_url$countrycode/a/"
                . $chars[0] . "/"
                . $chars[1] . "/"
                . $chars[2] . "/"
                . $chars[3] . "/",
            "$base_url$countrycode/a/"
                . $chars[0] . "/"
                . $chars[1] . "/"
                . $chars[2] . "/",
            "$base_url$countrycode/a/" . $chars[0] . "/" . $chars[1] . "/",
            "$base_url$countrycode/a/" . $chars[0] . "/",
        );
        @urls = grep { $_ !~ m{//$} } @urls;
    }

    sleep 1;    # be nice to the remote server
    my $response;
    foreach my $url (@urls) {
        my $request = HTTP::Request->new( 'GET', $url );
        $response = $ua->request($request);
        last if $response->is_success;
    }
    if ( not $response->is_success ) {
        croak(
            "WWW::Gazetteer::FallingRain: City $city in $country not found");
        return;
    }

    my @cities;
    my $content = $response->content;
    while (
        $content =~ s{
<tr>
<td>
<a\shref=(.+?)>$city</a>
<td>city
  }{}x
        )
    {
        my $url = "http://www.fallingrain.com" . $1;
        my $request = HTTP::Request->new( 'GET', $url );
        $response = $ua->request($request);
        if ( not $response->is_success ) {
            croak(
                "WWW::Gazetteer::FallingRain: City $city in $country not found"
            );
            return;
        }
        my $html = $response->content;
        my ( $latitude, $longitude, $elevation ) = $html =~ m{
<th>Latitude<td>(.+?)
<th>Longitude<td>(.+?)
<th>Altitude\s\(feet\)<td>(.+?)
<td
}x;
        $elevation = int( $elevation * 0.3048 );
        push @cities,
            {
            city      => $city,
            country   => $country,
            latitude  => $latitude,
            longitude => $longitude,
            elevation => $elevation,
            };
    }
    return wantarray ? @cities : \@cities;
}

__END__

=head1 NAME

WWW::Gazetteer::FallingRain - Find location of world towns and cities

=head1 SYNOPSYS

  use WWW::Gazetteer;
  my $g = WWW::Gazetteer::FallingRain->new('calle');
  my @londons = $g->find(UK => 'London');
  my $london = $londons[0];
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  my $nice = $g->find("Nice", "France")->[0];
  print $nice->{city}, ", ", $nice->{elevation}, "\n";

=head1 DESCRIPTION

A gazetteer is a geographical dictionary (as at the back of an
atlas). The C<WWW::Gazetteer::FallingRain> module uses the information at
http://www.fallingrain.com/world/ to return geographical location
(longitude, latitude, elevation) for towns and cities in countries in
the world.

This module is a subclass of C<WWW::Gazetteer>, so you must use that
to create a C<WWW::Gazetteer::FallingRain> object. Once you have imported
the module and created a gazetteer object, calling find($country =>
$town) will return a list of hashrefs with longitude and latitude
information.

  my @londons = $g->find(UK => 'London');
  my $london = $londons[0];
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  # prints -0.1167, 51.5000

The hashref for London actually looks like this:

  $london = {
    longitude => "-0.1167",
    latitude  => "51.5000",
    city      => 'London',
    country   => 'UK',
    elevation => "14",
  };

The city and country values are the same as the ones you used. The
elevation is elevation above sea level in meters. The longitude and
latitude are in degrees, ranging from -180 to 180 where (0, 0) is on
the Prime Meridian and the equator.

=head1 METHODS

=head2 new()

This returns a new WWW::Gazetteer::FallingRain object. It currently has no
arguments:

  use WWW::Gazetteer;
  my $g = WWW::Gazetteer->new('calle');

=head2 find()

The find method looks up geographical information and returns it to
you. It takes in a country and a city, with the recommended syntax
being ISO 3166 code and city name. However, it also tries to do what
you mean.

Note that there may be more than one town or city with that name in
the country. You will get a list of hashrefs for each town/city.

  my @londons = $g->find("UK" => "London");
  my @londons = $g->find("United Kingdom" => "London");
  my @londons = $g->find("London", "United Kingdom");

The following countries are valid (as are their ISO 3166 codes):
Afghanistan, Albania, American Samoa, Angola, Anguilla, Antigua and
Barbuda, Argentina, Armenia, Aruba, Australia, Austria, Azerbaijan,
Bahamas, Bahrain, Bangladesh, Barbados, Belarus, Belgium, Bermuda,
Bhutan, Bolivia, Bosnia and Herzegovina, Botswana, Bouvet Island,
Brazil, British Indian Ocean Territory, Brunei Darussalam, Bulgaria,
Burkina Faso, Cambodia, Cameroon, Canada, Cape Verde, Cayman Islands,
Central African Republic, Chad, China, Christmas Island, Colombia,
Congo, Congo, The Democratic Republic of the, Cook Islands, Costa
Rica, Cote D'Ivoire, Croatia, Cuba, Cyprus, Czech Republic, Denmark,
Djibouti, Dominican Republic, Ecuador, Egypt, El Salvador, Equatorial
Guinea, Eritrea, Estonia, Ethiopia, Falkland Islands (Malvinas), Faroe
Islands, Fiji, Finland, France, French Guiana, French Polynesia,
Gabon, Gambia, Georgia, Ghana, Gibraltar, Greece, Greenland, Grenada,
Guadeloupe, Guatemala, Guinea, Guinea-Bissau, Guyana, Haiti, Heard
Island and McDonald Islands, Honduras, Hong Kong, Hungary, Iceland,
India, Indonesia, Iran, Islamic Republic of, Iraq, Ireland, Italy,
Jamaica, Japan, Jordan, Kazakhstan, Kenya, Korea, Republic of, Kuwait,
Kyrgyzstan, Lao People's Democratic Republic, Latvia, Lebanon,
Lesotho, Libyan Arab Jamahiriya, Liechtenstein, Lithuania, Luxembourg,
Macao, Macedonia, the Former Yugoslav Republic of, Madagascar, Malawi,
Malaysia, Maldives, Mali, Malta, Marshall Islands, Mauritania,
Mauritius, Mayotte, Mexico, Micronesia, Federated States of, Moldova,
Republic of, Monaco, Mongolia, Morocco, Mozambique, Namibia, Nauru,
Nepal, Netherlands Antilles, Netherlands, New Caledonia, New Zealand,
Nicaragua, Niger, Nigeria, Niue, Norfolk Island, Northern Mariana
Islands, Norway, Pakistan, Palestinian Territory, Occupied, Panama,
Papua New Guinea, Peru, Philippines, Poland, Portugal, Qatar, Reunion,
Romania, Russian Federation, Rwanda, Saint Helena, Saint Kitts and
Nevis, Saint Pierre and Miquelon, Saint Vincent and the Grenadines,
Samoa, San Marino, Sao Tome and Principe, Saudi Arabia, Senegal,
Serbia and Montenegro, Seychelles, Sierra Leone, Singapore, Slovakia,
Slovenia, Solomon Islands, Somalia, South Africa, South Georgia and
the South Sandwich Islands, Spain, Sri Lanka, Sudan, Suriname,
Svalbard and Jan Mayen, Swaziland, Sweden, Switzerland, Syrian Arab
Republic, Taiwan, Province of China, Tajikistan, Tanzania, United
Republic of, Thailand, Timor-Leste, Tokelau, Tonga, Trinidad and
Tobago, Tunisia, Turkey, Turkmenistan, Tuvalu, Uganda, Ukraine, United
Arab Emirates, United Kingdom, United States, Uruguay, Uzbekistan,
Vanuatu, Venezuela, Vietnam, Virgin Islands, U.S., Wallis and Futuna,
Western Sahara, Yemen, Zimbabwe.

Note that there may be bugs in the FallingRain database. Do not rely on this
module for navigation.

=head1 COPYRIGHT

Copyright (C) 2002-9, Leon Brocard

=head1 LICENSE

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.

=head1 AUTHOR

Leon Brocard, acme@astray.com. Based upon ideas and code by Nathan Bailey.


