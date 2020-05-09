#
# To install OpenFST Version 1.6.9
# and the related libraries
#

INSTALL_PATH=$(CURDIR)/local

OPENFST_VERSION=1.6.9
THRAX_VERSION=1.2.9
NGRAM_VERSION=1.3.4

OPENFST_PATH=$(CURDIR)/openfst-$(OPENFST_VERSION)
THRAX_PATH=$(CURDIR)/thrax-$(THRAX_VERSION)
NGRAM_PATH=$(CURDIR)/opengrm-ngram-$(NGRAM_VERSION)

CPPFLAGS=-I$(INSTALL_PATH)/include
LDFLAGS="-L$(INSTALL_PATH)/lib -L$(INSTALL_PATH)/lib/fst"
PATH=$(INSTALL_PATH)/bin:$(shell printenv PATH)
LD_LIBRARY_PATH=$(INSTALL_PATH)/lib:$(shell printenv LD_LIBRARY_PATH)

all: build_openfst build_thrax build_ngram

download:
	wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-$(OPENFST_VERSION).tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-$(THRAX_VERSION).tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/NGramDownload/opengrm-ngram-$(NGRAM_VERSION).tar.gz

build_openfst:$(shell basename $(OPENFST_PATH))
	cd $(OPENFST_PATH) && ./configure --prefix=$(INSTALL_PATH) \
	 --enable-compact-fsts --enable-const-fsts --enable-far \
	 --enable-looolahead-fsts --enable-pdt --enable-mpdt \
	 --enable-static --enable-bin --enable-grm --enable-ngram-fsts --with-pic
	make -j`nproc`  -C $(OPENFST_PATH)
	make check -C $(OPENFST_PATH)
	make install -C $(OPENFST_PATH)

build_thrax:$(shell basename $(THRAX_PATH))
	cd $(THRAX_PATH) && ./configure --prefix=$(INSTALL_PATH) \
	--enable-static --enable-bin --with-pic CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) 
	make -j`nproc` -C $(THRAX_PATH)
	make check -C $(THRAX_PATH)
	make install -C $(THRAX_PATH)

build_ngram:$(shell basename $(NGRAM_PATH))
	cd $(NGRAM_PATH) && CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) ./configure --prefix=$(INSTALL_PATH) 
	 --enable-static --with-pic
	make -j`nproc` -C $(NGRAM_PATH)
	PATH=$(PATH) LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) make check -C $(NGRAM_PATH) CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) 
	make install -C $(NGRAM_PATH)

clean:
	make clean -C $(OPENFST_PATH) ; make clean -C $(THRAX_PATH) ; make clean -C $(NGRAM_PATH)
	rm -rf $(INSTALL_PATH)
