#!/bin/bash

# Prerequisite:
# brew cask install kindle-previewer
# brew install pandoc
# ln -s /Applications/Kindle\ Previewer\ 3.app/Contents/MacOS/lib/fc/bin/kindlegen /usr/local/bin/

if [ $# != 1 ]
then
  echo "Error: Please input markdown file path."
  exit 1
fi

markdown_filepath=$1
title=${markdown_filepath##*/}  # basename
title=${title%.*}  # remove suffix name
epub_filename="${title}.epub"

# echo $markdown_filepath
# echo $title
# echo $epub_filename
# ls "$markdown_filepath"

# 文件名、路径变量一定要加 “” 包起来，因为可能存在空格
pandoc -s "$markdown_filepath" -t epub --metadata title="${title}" -o "$epub_filename"

kindlegen "$epub_filename"

/bin/rm -f "$epub_filename"

echo "Succuss: ${title}.mobi"
