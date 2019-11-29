# mlwc_vs_vwc
This repo contains a silly comparison of SML and V re-implementations of a subset of the functionality of the classic unix tool wc.

# Usage:

You need to have:
1) latest v: https://github.com/vlang/v
2) working C99 compiler, say clang
3) latest mlton: https://sourceforge.net/projects/mlton/
4) working time, strip, ls, rm, echo
5) working hyperfine too.

When you have all these, clone this repo, cd into your clone, and type:
`V=/path_to_your_v VCC=/path_to_C99_compiler MLTON=/path_to_mlton  make`

Interpret the results however you like :-)
