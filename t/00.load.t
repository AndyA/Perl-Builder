use Test::More tests => 2;

BEGIN {
  use_ok( 'Perl::Builder' );
  use_ok( 'Perl::Builder::Version' );
}

diag( "Testing Perl::Builder $Perl::Builder::VERSION" );
