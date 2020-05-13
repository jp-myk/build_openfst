#
# To install OpenFST Version 1,6,9 
# and the related libraries
#

INSTALL_PATH=$(CURDIR)/local
OPENFST_VERSION=1.6.9
THRAX_VERSION=1.2.9
NGRAM_VERSION=1.3.4
PYNINI_VERSION=0.0.4

OPENFST_PATH=$(CURDIR)/openfst-$(OPENFST_VERSION)
THRAX_PATH=$(CURDIR)/thrax-$(THRAX_VERSION)
NGRAM_PATH=$(CURDIR)/opengrm-ngram-$(NGRAM_VERSION)

GCCVERSION=$(shell expr `g++ -dumpversion | cut -f1` \>= 7)
ifeq "$(GCCVERSION)" "1"
	OPENFST_VERSION=1.7.7
	THRAX_VERSION=1.3.3
	NGRAM_VERSION=1.3.10
	PYNINI_VERSION=2.1.1
	NGRAM_PATH=$(CURDIR)/ngram-$(NGRAM_VERSION)
endif

CPPFLAGS=-I$(INSTALL_PATH)/include
LDFLAGS="-L$(INSTALL_PATH)/lib -L$(INSTALL_PATH)/lib/fst"
PATH=$(INSTALL_PATH)/bin:$(shell printenv PATH)
LD_LIBRARY_PATH=$(INSTALL_PATH)/lib:$(shell printenv LD_LIBRARY_PATH)

all: build_openfst build_thrax build_ngram

download:
	wget http://www.openfst.org/twiki/pub/FST/FstDownload/$(shell basename $(OPENFST_PATH)).tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/ThraxDownload/$(shell basename $(THRAX_PATH)).tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/NGramDownload/$(shell basename $(NGRAM_PATH)).tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/PyniniDownload/$(shell basename $(PYNINI_PATH)).tar.gz

build_openfst:$(shell basename $(OPENFST_PATH))
	cd $(OPENFST_PATH) && ./configure --prefix=$(INSTALL_PATH) \
	 --enable-compact-fsts --enable-const-fsts --enable-far \
	 --enable-looolahead-fsts --enable-pdt --enable-mpdt \
	 --enable-static --enable-bin --enable-grm --enable-ngram-fsts --with-pic
	make  -C $(OPENFST_PATH)
	make check -C $(OPENFST_PATH)
	make install -C $(OPENFST_PATH)

build_thrax:$(shell basename $(THRAX_PATH))
	cd $(THRAX_PATH) && ./configure --prefix=$(INSTALL_PATH) \
	--enable-static --enable-bin --with-pic CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) 
	make -C $(THRAX_PATH)
	make check -C $(THRAX_PATH)
	make install -C $(THRAX_PATH)

build_ngram:$(shell basename $(NGRAM_PATH))
	cd $(NGRAM_PATH) && CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) ./configure --prefix=$(INSTALL_PATH) 
	 --enable-static --with-pic
	make -C $(NGRAM_PATH)
	PATH=$(PATH) LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) make check -C $(NGRAM_PATH) CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) 
	make install -C $(NGRAM_PATH)

clean:
	make clean -C $(OPENFST_PATH) ; make clean -C $(THRAX_PATH) ; make clean -C $(NGRAM_PATH)
	rm -rf $(INSTALL_PATH)
