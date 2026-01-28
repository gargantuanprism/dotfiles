#!/bin/bash

base_dir=/tank/music/explo/explo
htagcli=$HOME/Downloads/htagcli
album_artist=Explo

for dir in $(fdfind -td . $base_dir); do
  echo $dir
  album=$(basename $dir)
  cmd="$htagcli set --album $album --albumartist Explo $dir*"
  $cmd
done

