#
# To install OpenFST Version 1.6.9
# and the related libraries
#

INSTALL_PATH=$(CURDIR)/local

OPENFST_PATH=$(CURDIR)/openfst-1.6.9
THRAX_PATH=$(CURDIR)/thrax-1.2.9
NGRAM_PATH=$(CURDIR)/opengrm-ngram-1.3.4

PATH=$(INSTALL_PATH)/bin:$(shell printenv PATH)
CPPFLAGS=-I$(INSTALL_PATH)/include
LDFLAGS="-L$(INSTALL_PATH)/lib -L$(INSTALL_PATH)/lib/fst"

all: build_openfst build_thrax build_ngram

download:
	wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.9.tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.9.tar.gz
	wget http://www.openfst.org/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.4.tar.gz

build_openfst:$(INSTALL_PATH)/lib/libfst.a
	cd $(OPENFST_PATH) && ./configure --prefix=$(INSTALL_PATH) \
	 --enable-compact-fsts --enable-const-fsts --enable-far \
	 --enable-looolahead-fsts --enable-pdt --enable-mpdt \
	 --enable-static --enable-bin --enable-grm --enable-ngram-fsts --with-pic
	make -j`nproc`  -C $(OPENFST_PATH)
	make check -C $(OPENFST_PATH)
	make install -C $(OPENFST_PATH)

build_thrax:
	cd $(THRAX_PATH) && CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) ./configure --prefix=$(INSTALL_PATH) \
	--enable-static --enable-bin --with-pic 
	make -j`nproc` -C $(THRAX_PATH)
	make check -C $(THRAX_PATH)
	make install -C $(THRAX_PATH)

build_ngram:
	cd $(NGRAM_PATH) && CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) ./configure --prefix=$(INSTALL_PATH) 
	 --enable-static --with-pic
	make -j`nproc` -C $(NGRAM_PATH)
	PATH=$(PATH) CPPFLAGS=$(CPPFLAGS) LDFLAGS=$(LDFLAGS) make check -C $(NGRAM_PATH)
	make install -C $(NGRAM_PATH)

clean:
	make clean -C $(OPENFST_PATH) ; make clean -C $(THRAX_PATH) ; make clean -C $(NGRAM_PATH)
	rm -rf $(INSTALL_PATH)
