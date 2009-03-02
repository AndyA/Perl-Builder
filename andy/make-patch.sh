#!/bin/sh

orig=$1
dir=$2
patches=../patches

name=`basename $dir`
patch=$patches/$name/perl.patch
echo Extracting patches for $name
diff -ru $orig $dir | egrep -v '^Only in ' > $patch
[ -s $patch ] || rm -f $patch

# vim:ts=2:sw=2:sts=2:et:ft=sh

