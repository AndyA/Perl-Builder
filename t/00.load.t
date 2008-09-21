use Test::More tests => 4;

BEGIN {
  use_ok( 'Perl::Builder' );
  use_ok( 'Perl::Builder::Config' );
  use_ok( 'Perl::Builder::Version' );
  use_ok( 'Perl::Builder::Worker' );
}

diag( "Testing Perl::Builder $Perl::Builder::VERSION" );
