#!/usr/bin/env bash

source vars.sh

target="build/$COMPANY_NAME"
src="templates/$TEMPLATE"
vars=$(grep -oP '^export\s+\K\w+' vars.sh)
current_dir=$(pwd)

## Add template

if [ ! -d "./$src" ]; then
  git clone "git@github.com:$TEMPLATE.git" "./$src"
fi


## Clean previous specific build

if [ -d "./$target" ]; then rm -rf "./$target"; fi
mkdir "$target"


## Prepare files

# TODO: to make photo and signature names dynamic
if [ -s "./artifacts/picture.jpg" ]; then cp "./artifacts/picture.jpg" "./$src/picture.jpg"; fi
if [ -s "./artifacts/signature.png" ]; then cp "./artifacts/signature.png" "./$src/signature.png"; fi
cp "./$src/pre.template.tex" "./$src/template.tex"
if [ -s "./artifacts/$EMAIL" ]; then cp "./artifacts/$EMAIL" "./$target/email.txt"; fi

for var in $vars; do
    val="${!var}"
    sed -i "s|\${$var}|${val/[&]/\\\\\&}|g" "./$src/template.tex" "./$target/email.txt"
done


## Build the template (cv and/or cover letter)

# TODO: find out if template could be built outside the template directory
cd "./$src"
echo $PWD
latexmk -pdf -outdir="$current_dir/$target" ./template.tex
cd $current_dir


## Merge with certificates if presented

if [ -d "./artifacts/certificates.pdf" ]
then
  pdftk "./$target/template.pdf" ./artifacts/certificates.pdf \
    cat output "./$target/$DOCUMENT_NAME.pdf"
else
  cp "./$target/template.pdf" "./$target/$DOCUMENT_NAME.pdf"
fi


# TODO: think of using mail client and default generation of email
# Open the URL
# open https://navigator.web.de/mail?sid=4cabaf722d9e919beb51889360d052de2505521f66bf73e05e9e347bdde39eb9ceffdba4a5e8fa4f1476a6126a360297
