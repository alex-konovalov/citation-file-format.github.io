#!/bin/bash

# enable error reporting to the console
set -e

# Build Jekyll
echo "Build Jekyll site"
bundle exec jekyll build

# Set up and build custom pandoc (for fix of https://github.com/jgm/pandoc/issues/3529)
# git clone https://github.com/jgm/pandoc.git
# cd pandoc
# git checkout 181d737
# stack setup
# stack install --flag pandoc:embed_data_files
# cd ..

# Run the Python script that converts all specifications.md files to PDF
pip3 install pypandoc
pip3 install frontmatter
python3 --version
python3 build-pdfs.py

## push
# cd _site
# git config user.email "travis-ci@sdruskat.net"
# git config user.name "Travis CI"
# git add --all
# git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
# git push --force origin master
