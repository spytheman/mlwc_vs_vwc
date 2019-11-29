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

Interpret the results however you like ;-)

On my machine after everything is benchmarked:
-------------------------------------------------------------------
Summary
  './vwc_prod    cinderella.txt' ran
    1.63 ± 0.10 times faster than './mlwc_llvm   cinderella.txt'
    1.94 ± 0.10 times faster than './mlwc_amd64  cinderella.txt'
    1.95 ± 0.11 times faster than './mlwc_native cinderella.txt'
    2.09 ± 0.12 times faster than './mlwc_c      cinderella.txt'
    2.16 ± 0.12 times faster than 'wc            cinderella.txt'
    4.72 ± 0.23 times faster than './vwc_dev     cinderella.txt'

