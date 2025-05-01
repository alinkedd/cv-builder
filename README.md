# CV Builder

## Prerequisites

- linux, bash, git
- latexmk (and all required packages for the specific latex project)
- pdftk

## Preparations

Copy and change variables:

```sh
cp vars.example.sh vars.sh
```

Add `certificates.pdf` to `artifacts` folder to attach it to the resulting document:

## Templates

Supported latex templates:
- alinkedd/moderncv

## Build 

```sh
./make.sh
```