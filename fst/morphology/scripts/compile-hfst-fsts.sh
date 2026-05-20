#!/bin/sh

# compile-hfst-fsts.sh

# Script to compile core FSTs from LEXC and XFSCRIPT source code
# Output: HFST

echo 'Concatenating LEXC source files into: lexicon.lexc.' ;

cat \
./defs/multichars.lexc \
./defs/root.lexc \
./affixes/prefixes.lexc \
./affixes/prestems.lexc \
./stems/verb_stems.lexc \
./affixes/verb_suffixes.lexc \
./stems/noun_indep_stems.lexc \
./stems/noun_dep_stems.lexc \
./affixes/noun_suffixes.lexc \
./stems/pronouns.lexc \
./stems/demonstratives.lexc \
./stems/numerals.lexc \
./stems/particles.lexc \
> lexicon.lexc

echo 'Compiling HFSTs.' ;

hfst-xfst -F scripts/hfst_compile.xfscript

echo 'Creating HFSTOLs.' ;

hfst-fst2fst -w -i fst/analyser-gt-norm.hfst -o fst/analyser-gt-norm.hfstol
hfst-fst2fst -w -i fst/analyser-gt-desc.hfst -o fst/analyser-gt-desc.hfstol
hfst-fst2fst -w -i fst/generator-gt-norm.hfst -o fst/generator-gt-norm.hfstol
hfst-fst2fst -w -i fst/generator-gt-norm-bound.hfst -o fst/generator-gt-norm-bound.hfstol

echo 'Finished.';

