#!/bin/sh

build=build
patches=../patches

cd $build
for orig in *.orig ; do
  dir=`echo $orig | sed 's/.orig$//'`
  name=`basename $dir`
  patch=$patches/$name.patch
  echo Extracting patches for $name
  diff -r --unified=0 $orig $dir | egrep -v '^Only in ' > $patch
  [ -s $patch ] || rm -f $patch
done

# vim:ts=2:sw=2:sts=2:et:ft=sh

