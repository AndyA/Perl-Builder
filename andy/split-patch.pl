#!/usr/bin/env perl

use strict;
use warnings;

while ( my $patch = shift ) {
  split_patch( $patch );
}

sub split_patch {
  my $patch = shift;
  ( my $test_patch = $patch ) =~ s{(^|/)perl}{$1test}
   or die "Can't make $patch into a test patch name\n";
  my $name_map = { test => $test_patch, non_test => $patch };

  my $stash = { test => [], non_test => [], spill => [] };
  my $sel = undef;
  open my $ip, '<', $patch or die "Can't read $patch ($!)\n";
  while ( defined( my $line = <$ip> ) ) {
    if ( $line =~ /^diff/ ) {
      $sel = 'spill';
    }
    elsif ( $line =~ /^---\s+(\S+)/ ) {
      my $file = $1;
      $sel = ( $file =~ /\.t$/ ? 'test' : 'non_test' );
      push @{ $stash->{$sel} }, splice @{ $stash->{spill} };
    }
    die "Huh?" unless defined $sel;
    push @{ $stash->{$sel} }, $line;
  }

  for my $type ( keys %$name_map ) {
    if ( @{ $stash->{$type} } ) {
      my $new_patch = $name_map->{$type};
      open my $op, '>', $new_patch
       or die "Can't write $new_patch ($!)\n";
      print $op join '', @{ $stash->{$type} };
    }
  }
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

__END__

diff -ru perl-5.7.3.orig/ext/DB_File/DB_File.xs perl-5.7.3/ext/DB_File/DB_File.xs
--- perl-5.7.3.orig/ext/DB_File/DB_File.xs	2008-09-17 23:12:49.000000000 +0100
+++ perl-5.7.3/ext/DB_File/DB_File.xs	2008-09-18 02:48:06.000000000 +0100
@@ -183,6 +183,10 @@
 #    define AT_LEAST_DB_3_2
 #endif
 
+#if DB_VERSION_MAJOR > 4 || (DB_VERSION_MAJOR == 4 && DB_VERSION_MINOR >= 1)
+#    define AT_LEAST_DB_4_1
+#endif
+
 /* map version 2 features & constants onto their version 1 equivalent */
 
 #ifdef DB_Prefix_t
@@ -1366,8 +1370,13 @@
             Flags |= DB_TRUNCATE ;
 #endif
 
+#ifdef AT_LEAST_DB_4_1
+        status = (RETVAL->dbp->open)(RETVAL->dbp, NULL, name, NULL, RETVAL->type, 
+	    			Flags, mode) ; 
+#else
         status = (RETVAL->dbp->open)(RETVAL->dbp, name, NULL, RETVAL->type, 
 	    			Flags, mode) ; 
+#endif
 	/* printf("open returned %d %s\n", status, db_strerror(status)) ; */
 
         if (status == 0)
diff -ru perl-5.7.3.orig/ext/DB_File/t/db-recno.t perl-5.7.3/ext/DB_File/t/db-recno.t
--- perl-5.7.3.orig/ext/DB_File/t/db-recno.t	2008-09-17 23:12:49.000000000 +0100
+++ perl-5.7.3/ext/DB_File/t/db-recno.t	2008-09-18 17:46:38.000000000 +0100
@@ -1,5 +1,8 @@
 #!./perl -w
 
+print "1..0 # SKIP Unknown\n";
+exit 0;
+
 BEGIN {
     unless(grep /blib/, @INC) {
         chdir 't' if -d 't';
diff -ru perl-5.7.3.orig/lib/Benchmark.t perl-5.7.3/lib/Benchmark.t
--- perl-5.7.3.orig/lib/Benchmark.t	2008-09-17 23:12:48.000000000 +0100
+++ perl-5.7.3/lib/Benchmark.t	2008-09-18 17:51:23.000000000 +0100
@@ -8,7 +8,8 @@
 use warnings;
 use strict;
 use vars qw($foo $bar $baz $ballast);
-use Test::More tests => 159;
+use Test::More skip_all => 'Unknown';
+#use Test::More tests => 159;
 
 use Benchmark qw(:all);
 
diff -ru perl-5.7.3.orig/lib/File/Find/t/find.t perl-5.7.3/lib/File/Find/t/find.t
--- perl-5.7.3.orig/lib/File/Find/t/find.t	2008-09-17 23:12:48.000000000 +0100
+++ perl-5.7.3/lib/File/Find/t/find.t	2008-09-18 17:46:49.000000000 +0100
@@ -1,5 +1,7 @@
 #!./perl
 
+print "1..0 # SKIP Unknown\n";
+exit 0;
 
 my %Expect_File = (); # what we expect for $_ 
 my %Expect_Name = (); # what we expect for $File::Find::name/fullname
diff -ru perl-5.7.3.orig/lib/File/Find/t/taint.t perl-5.7.3/lib/File/Find/t/taint.t
--- perl-5.7.3.orig/lib/File/Find/t/taint.t	2008-09-17 23:12:48.000000000 +0100
+++ perl-5.7.3/lib/File/Find/t/taint.t	2008-09-18 17:46:45.000000000 +0100
@@ -1,5 +1,7 @@
 #!./perl -T
 
+print "1..0 # SKIP Unknown\n";
+exit 0;
 
 my %Expect_File = (); # what we expect for $_
 my %Expect_Name = (); # what we expect for $File::Find::name/fullname
diff -ru perl-5.7.3.orig/makedepend.SH perl-5.7.3/makedepend.SH
--- perl-5.7.3.orig/makedepend.SH	2008-09-17 23:12:48.000000000 +0100
+++ perl-5.7.3/makedepend.SH	2008-09-18 02:38:29.000000000 +0100
@@ -18,10 +18,6 @@
 */*) cd `expr X$0 : 'X\(.*\)/'` ;;
 esac
 
-case "$osname" in
-amigaos) cat=/bin/cat ;; # must be absolute
-esac
-
 echo "Extracting makedepend (with variable substitutions)"
 rm -f makedepend
 $spitshell >makedepend <<!GROK!THIS!
@@ -33,6 +29,13 @@
 !GROK!THIS!
 $spitshell >>makedepend <<'!NO!SUBS!'
 
+if test -d .depending; then
+	echo "$0: Already running, exiting."
+	exit 0
+fi
+
+mkdir .depending
+
 # This script should be called with 
 #     sh ./makedepend MAKE=$(MAKE)
 case "$1" in 
@@ -62,6 +65,10 @@
 PATH=".$path_sep..$path_sep$PATH"
 export PATH
 
+case "$osname" in
+amigaos) cat=/bin/cat ;; # must be absolute
+esac
+
 $cat /dev/null >.deptmp
 $rm -f *.c.c c/*.c.c
 if test -f Makefile; then
@@ -116,7 +123,7 @@
     *.y) filebase=`basename $file .y` ;;
     esac
     case "$file" in
-    */*) finc="-I`echo $file | sed 's#/[^/]*$##`" ;;
+    */*) finc="-I`echo $file | sed 's#/[^/]*$##'`" ;;
     *)   finc= ;;
     esac
     $echo "Finding dependencies for $filebase$_o."
@@ -143,13 +150,16 @@
 	    -e 's|\.c\.c|.c|' $uwinfix | \
         $uniq | $sort | $uniq >> .deptmp
     else
-        $cppstdin $finc -I. $cppflags $cppminus <UU/$file.c 2>&1 |
+        $cppstdin $finc -I. $cppflags $cppminus <UU/$file.c >.cout 2>.cerr
         $sed \
 	    -e '1d' \
 	    -e '/^#.*<stdin>/d' \
             -e '/^#.*<builtin>/d' \
+            -e '/^#.*<built-in>/d' \
             -e '/^#.*<command line>/d' \
+            -e '/^#.*<command-line>/d' \
 	    -e '/^#.*"-"/d' \
+	    -e '/^#.*"\/.*\/"/d' \
 	    -e '/: file path prefix .* never used$/d' \
 	    -e 's#\.[0-9][0-9]*\.c#'"$file.c#" \
 	    -e 's/^[	 ]*#[	 ]*line/#/' \
@@ -157,7 +167,7 @@
 	    -e 's/^.*"\(.*\)".*$/'$filebase'\$(OBJ_EXT): \1/' \
 	    -e 's/^# *[0-9][0-9]* \(.*\)$/'$filebase'\$(OBJ_EXT): \1/' \
 	    -e 's|: \./|: |' \
-	    -e 's|\.c\.c|.c|' $uwinfix | \
+           -e 's|\.c\.c|.c|' $uwinfix .cout .cerr| \
         $uniq | $sort | $uniq >> .deptmp
     fi
 done
@@ -222,7 +232,8 @@
 $cp $mf.new $mf
 $rm $mf.new
 $echo "# WARNING: Put nothing here or make depend will gobble it up!" >> $mf
-$rm -rf .deptmp UU .shlist .clist .hlist .hsed
+$rm -rf .deptmp UU .shlist .clist .hlist .hsed .cout .cerr
+rmdir .depending
 
 !NO!SUBS!
 $eunicefix makedepend
diff -ru perl-5.7.3.orig/patchlevel.h perl-5.7.3/patchlevel.h
--- perl-5.7.3.orig/patchlevel.h	2008-09-17 23:12:48.000000000 +0100
+++ perl-5.7.3/patchlevel.h	2008-09-18 18:11:05.000000000 +0100
@@ -79,6 +79,7 @@
 #if !defined(PERL_PATCHLEVEL_H_IMPLICIT) && !defined(LOCAL_PATCH_COUNT)
 static	char	*local_patches[] = {
         NULL
+	, "Perl::Builder - config / build patches"
 	,NULL
 };
 
