use strict;
use warnings;

use Archive::Tar;
use HTTP::Request;
use LWP::UserAgent;
use MetaCPAN::Script::Release;
use Test::More;

#use Test::RequiresInternet ( 'https://metacpan.org/' => 443 );

my $ua = LWP::UserAgent->new(
    parse_head => 0,
    env_proxy  => 1,
    agent      => 'metacpan',
    timeout    => 30,
);

my $URL
    = 'https://cpan.metacpan.org/authors/id/S/SH/SHULL/karma-0.7.0.tar.gz';
my $tarball;
my $req = HTTP::Request->new( GET => $URL );
my $res = $ua->request( $req, $tarball );

my $arch = Archive::Tar->new;
$arch->read($tarball);
my $next = Archive::Tar->iter($tarball);
while ( my $file = $next->() ) {
    if ( -p $file->name ) {
        my $skip = is_broken_file( $file->name );
        ok( $skip eq 1, 'The file is a broken pipe' );
    }
}

done_testing();
