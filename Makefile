LANG=C
VFLAGS=
V ?= /v/nv/v
VCC ?= clang-7
MLTON ?= /opt/mlton/bin/mlton

build: mlwc_all vwc_all

mlwc_all: mlwc_c mlwc_llvm mlwc_amd64 mlwc_native
mlwc_c: ml/wc.sml
	time $(MLTON) -codegen c -output mlwc_c ml/wc.sml
mlwc_llvm: ml/wc.sml
	time $(MLTON) -codegen llvm -output mlwc_llvm ml/wc.sml
mlwc_amd64: ml/wc.sml
	time $(MLTON) -codegen amd64 -output mlwc_amd64 ml/wc.sml
mlwc_native: ml/wc.sml
	time $(MLTON) -codegen native -output mlwc_native ml/wc.sml

vwc_all: vwc_dev vwc_prod
vwc_dev: v/wc.v
	time $(V) -cc $(VCC) -o vwc_dev v/wc.v
vwc_prod: v/wc.v
	time $(V) -cc $(VCC) -prod -o vwc_prod v/wc.v

benchmark: showversions sourcestats clean build binstats run_once
	hyperfine --warmup 10 \
    './vwc_dev     cinderella.txt' \
    './vwc_prod    cinderella.txt' \
    './mlwc_c      cinderella.txt' \
    './mlwc_llvm   cinderella.txt' \
    './mlwc_amd64  cinderella.txt' \
    './mlwc_native cinderella.txt' \
    'wc cinderella.txt'

run_once:
	wc            cinderella.txt
	./vwc_dev     cinderella.txt
	./vwc_prod    cinderella.txt
	./mlwc_c      cinderella.txt
	./mlwc_llvm   cinderella.txt
	./mlwc_amd64  cinderella.txt
	./mlwc_native cinderella.txt

showversions:
	$(MLTON)
	$(V) --version

sourcestats:
	wc */* |sort -n

binstats:
	ls -larS mlwc_* vwc_*
	strip mlwc_* vwc_*
	ls -larS mlwc_* vwc_*

clean:
	rm -rf mlwc_* vwc_*
