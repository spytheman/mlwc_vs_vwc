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

On an i3, after everything, hyperfine shows:
```
Summary
  './vwc_prod    cinderella.txt' ran
    1.63 ± 0.10 times faster than './mlwc_llvm   cinderella.txt'
    1.94 ± 0.10 times faster than './mlwc_amd64  cinderella.txt'
    1.95 ± 0.11 times faster than './mlwc_native cinderella.txt'
    2.09 ± 0.12 times faster than './mlwc_c      cinderella.txt'
    2.16 ± 0.12 times faster than 'wc            cinderella.txt'
    4.72 ± 0.23 times faster than './vwc_dev     cinderella.txt'
```


Executable size comparisons:
```shell
ls -larS mlwc_* vwc_*
-rwxrwxr-x 1 delian delian  19800 Nov 29 21:53 vwc_prod
-rwxrwxr-x 1 delian delian 102472 Nov 29 21:53 vwc_dev
-rwxrwxr-x 1 delian delian 175304 Nov 29 21:53 mlwc_llvm
-rwxrwxr-x 1 delian delian 192840 Nov 29 21:53 mlwc_c
-rwxrwxr-x 1 delian delian 220464 Nov 29 21:53 mlwc_native
-rwxrwxr-x 1 delian delian 220464 Nov 29 21:53 mlwc_amd64
strip mlwc_* vwc_*
ls -larS mlwc_* vwc_*
-rwxrwxr-x 1 delian delian  14680 Nov 29 21:53 vwc_prod
-rwxrwxr-x 1 delian delian  84600 Nov 29 21:53 vwc_dev
-rwxrwxr-x 1 delian delian 156560 Nov 29 21:53 mlwc_llvm
-rwxrwxr-x 1 delian delian 162032 Nov 29 21:53 mlwc_native
-rwxrwxr-x 1 delian delian 162032 Nov 29 21:53 mlwc_amd64
-rwxrwxr-x 1 delian delian 168880 Nov 29 21:53 mlwc_c

```

Source size comparisons:
```shell
wc */* |sort -n
   5    9   98 v/Makefile
  31  123  758 v/wc.v
  34  194  932 ml/wc.sml
  70  326 1788 total
```



And lastly, but NOT in importance, compilation times:
```shell
time /opt/mlton/bin/mlton -codegen c      -output mlwc_c      ml/wc.sml
3.05user 0.56system 0:03.65elapsed 99%CPU (0avgtext+0avgdata 643476maxresident)k
0inputs+1384outputs (0major+464531minor)pagefaults 0swaps
time /opt/mlton/bin/mlton -codegen llvm   -output mlwc_llvm   ml/wc.sml
5.17user 0.58system 0:05.78elapsed 99%CPU (0avgtext+0avgdata 685068maxresident)k
0inputs+4240outputs (0major+475414minor)pagefaults 0swaps
time /opt/mlton/bin/mlton -codegen amd64  -output mlwc_amd64  ml/wc.sml
2.54user 0.58system 0:03.15elapsed 99%CPU (0avgtext+0avgdata 788872maxresident)k
0inputs+1200outputs (0major+489812minor)pagefaults 0swaps
time /opt/mlton/bin/mlton -codegen native -output mlwc_native ml/wc.sml
2.55user 0.56system 0:03.13elapsed 99%CPU (0avgtext+0avgdata 789016maxresident)k
0inputs+1200outputs (0major+489840minor)pagefaults 0swaps

time /v/nv/v -cc clang-7       -o vwc_dev  v/wc.v
0.28user 0.02system 0:00.32elapsed 95%CPU (0avgtext+0avgdata 59264maxresident)k
0inputs+640outputs (0major+10292minor)pagefaults 0swaps
time /v/nv/v -cc clang-7 -prod -o vwc_prod v/wc.v
1.13user 0.04system 0:01.18elapsed 99%CPU (0avgtext+0avgdata 61580maxresident)k
0inputs+592outputs (0major+13208minor)pagefaults 0swaps
```

