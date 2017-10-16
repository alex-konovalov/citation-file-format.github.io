#!/bin/bash

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "This is a pull request, exiting."
  exit 0
fi

# enable error reporting to the console
set -e

# Build PDF
## Create local copy of index.md
#cp index.md pandoc-index.md

## Replace Liquid-style citations with Pandoc-style citations, keeping page numbers
#VERSION=$(grep -m 1 "version: " index.md | sed 's/version: //g')
#echo $VERSION
#ssed -R -i -e 's/ %}/\]/g' pandoc-index.md
#ssed -R -i -e 's/ -l(?= \d)/, p\./g' pandoc-index.md
#ssed -R -i -e 's/{% cite /\[@/g' pandoc-index.md
## Replace liquid version with real version string
#ssed -R -i -e 's,{{ page\.version }},'"$VERSION"',g' pandoc-index.md

## Build PDF from tmp file
#pandoc \
#	--latex-engine=xelatex \
#	--toc \
#	--toc-depth=4 \
#	--filter pandoc-citeproc \
#	--bibliography=./_bibliography/references.bib \
#	--csl=./_bibliography/ieee-with-url.csl \
#	--metadata date="`date '+%d %B %Y'`" \
#	--template=./template/default.latex \
#	-o cff-specifications.pdf \
#	pandoc-index.md

## Move PDF to final destination
#mv ./cff-specifications.pdf ./assets/pdf/cff-specifications.pdf

## Remove tmp file
#rm pandoc-index.md

# Build Jekyll
## cleanup "_site"
# rm -rf _site
# mkdir _site

## clone remote repo to "_site"
git clone https://${GITHUB_TOKEN}@github.com/citation-file-format/citation-file-format.github.io.git --branch src _site

## build with Jekyll into "_site"
gem install jekyll-paginate
gem install jekyll-sitemap
gem install jekyll-gist
gem install jekyll-feed
gem install jemoji
gem install jekyll-scholar
gem install liquefy

bundle exec jekyll build

## push
cd _site
git config user.email "travis-ci@sdruskat.net"
git config user.name "Travis CI"
git add --all
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin master
