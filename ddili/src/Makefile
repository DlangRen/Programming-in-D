all:

CIKIS?=../public_html

TEST_DEFS?=

ANA:= \
  ddili.ddoc \

ORTAK:= \
  common.ddoc \
  dusey_navigasyon.ddoc \
  sozluk_body.ddoc \

REGULAR_ORTAK:= \
  $(ANA) \
  $(ORTAK) \
  regular.ddoc \

# En ust duzey ders sayfasi
DERS_ROOT_D:= \
  ders/index.d \

DERS_ROOT_LINK= \
  $(DERS_ROOT_D:%.d=/%.html) \

KAYNAKLAR= \
  404.d \
  AliCehreli_resume.d \
  copyright.d \
  iletisim.d \
  index.d \
  sozluk.d \
  \
  $(DERS_ROOT_D) \
  \
  kurulum/dmd.d \
  kurulum/emacs_d-mode.d \
  kurulum/gdc.d \
  kurulum/index.d \
  \
  makale/bellek.d \
  makale/d_dilimleri.d \
  makale/d_tipleri.d \
  makale/degismez.d \
  makale/dub_tanisma.d \
  makale/duzenli_ifadeler.d \
  makale/eleman_erisimi_uzerine.d \
  makale/index.d \
  makale/katma.d \
  makale/neden_d.d \
  makale/saflik.d \
  makale/shared.d \
  makale/tembel_hesap.d \
  \
  ornek_kod/index.d \
  \
  tanitim/dil_kutuphane.d \
  tanitim/fark_c.d \
  tanitim/fark_cpp.d \
  tanitim/fark_dizgi.d \
  tanitim/fark_karmasik.d \
  tanitim/fark_onislemci.d \
  tanitim/genel.d \
  tanitim/index.d \
  \
  sunum/index.d \
  sunum/merhaba_2012.d \
  sunum/sonrasi.d \
  sunum/ingilizce_sunumlar.d \

EK_DOSYALAR= \
  robots.txt \
  rss.xml \
  style.css \
  \
  image/book.png \
  image/bullet_black.png \
  image/cc_80x15.png \
  image/cc_88x31.png \
  image/d_harfi.jpg \
  image/d_source.png \
  image/email.png \
  image/favicon.png \
  image/forum.png \
  image/pdficon_small.gif \
  image/pencil.png \
  image/rss-icon.png \
  image/penguen.png \
  image/gulen.png \
  image/oyundongusu.jpg \
  image/sdlkoordinat.png \
  image/vektorler1.png \
  image/vektorler2.png \
  image/vektorler3.png \
  image/vektorler4.png \
  image/oyunlardahareket.png \
  \
  sunum/2012_ZaferCelenk_D_ile_Guvenli_Programlar.pdf \
  sunum/2012_SalihDincer_Diziler_Dilimler.pdf \
  sunum/2012_AliCehreli_Cpp11_D.pdf \
  sunum/2012_AliCehreli_D_Tanitim.pdf \
  sunum/2012_AliCehreli_Kosut_Islemler.pdf \
  \
  AliCehreli_resume.pdf \
  \
  ders/sdl/src/ders1.zip \
  kurulum/locale.properties \

SILINECEK_DOSYALAR= \
  $(SOZLUK_DOSYALARI) \
  $(TAR_FILE) \
  $(TEST_DDOC) \
  $(PDF_LOCAL_DDOC) \
  $(EBOOK_TRANSFER) \

SILINECEK_KLASORLER= \
  ../public_html_test \
  ../public_html \

# Dersler
include ders/d/Makefile.in
include ders/gtkd/Makefile.in
include ders/sdl/Makefile.in
include ders/d.en/Makefile.in
include ders/d.cn/Makefile.in
#include ders/d.de/Makefile.in


BUTUN_D_HTML=$(KAYNAKLAR:%.d=$(CIKIS)/%.html)
BUTUN_HTML=$(BUTUN_D_HTML)

validate_macro = grep -L -w $(2) $(1) || (echo $(1):1000: $(2) is not defined && false)

define validate_maybe_index_macro
if [ "$(strip $(2))" = "index.html" ]; then \
	$(call validate_macro, $(1), BREADCRUMBS); \
fi
endef

define validate_d
    $(call validate_macro, $(1), SUBTITLE)
    $(call validate_macro, $(1), DESCRIPTION)
    $(call validate_macro, $(1), KEYWORDS)
    $(call validate_maybe_index_macro, $(1), $(2))
endef

define validate_all_ddoc_expanded
  @grep -e '$$(' $(1); \
  case "$$?" in \
    0) echo $(1):0: Unexpanded ddoc macro; false ;; \
    *) true ;; \
  esac
endef

define validate_no_back_tick
  @grep -e '<pre[^<>]*inline' $(1); \
  case "$$?" in \
    0) echo $(1):0: Back tick in inline code; false ;; \
    *) true ;; \
  esac
endef

SOZLUK_DOSYALARI=sozluk.ddoc sozluk_body.ddoc ders/d/sozluk.d

$(SOZLUK_DOSYALARI): sozluk.txt Makefile sozlukmaker
	./sozlukmaker turkish
	cp sozluk.d ders/d/sozluk.d

%.d.last_modified.ddoc: %.d Makefile
	echo LAST_MODIFIED=$$(TZ=GMT date -R --date="`git log -n1 --date=rfc $< | sed -n -e 's/Date:   //p'`" | sed -n -e 's/+0000/GMT/p') > $@

$(CIKIS)/%.html: %.d $(REGULAR_ORTAK) Makefile %.d.last_modified.ddoc
	@$(call validate_d, $<, $(strip $(@F)))
	dmd $(REGULAR_ORTAK) $(TEST_DEFS) $<.last_modified.ddoc $(<D)/breadcrumbs.ddoc $< -Df$@

KOPYALANANLAR:=$(EK_DOSYALAR:%=$(CIKIS)/%)

$(CIKIS)/%: %
	mkdir -p $(@D)
	cp -r $< $(@D)

BUTUN_DOSYALAR:=$(BUTUN_HTML) $(KOPYALANANLAR)

ANCHORGEN_SRC:=anchorgen.d alphabet.d

anchorgen: $(ANCHORGEN_SRC) Makefile
	dmd $(ANCHORGEN_SRC) -of$@

SILINECEK_DOSYALAR+=anchorgen anchorgen.o

codetester: codetester.d Makefile
	dmd codetester.d -O -de -w -of$@

SILINECEK_DOSYALAR+=codetester codetester.o

SOZLUKMAKER_SRC:= sozlukmaker.d alphabet.d

sozlukmaker: $(SOZLUKMAKER_SRC) Makefile
	dmd $(SOZLUKMAKER_SRC) -de -w -of$@

SILINECEK_DOSYALAR+=sozlukmaker sozlukmaker.o

EBOOKSANITIZER_SRC:= ebooksanitizer.d

ebooksanitizer: $(EBOOKSANITIZER_SRC) Makefile
	dmd $(EBOOKSANITIZER_SRC) -de -w -of$@

SILINECEK_DOSYALAR+=ebooksanitizer


AliCehreli_resume.pdf: ../public_html_test/AliCehreli_resume.html
	prince ../public_html_test/AliCehreli_resume.html \
            --no-artificial-fonts --disallow-modify \
            --style=pdf_fonts.css --style=./style.css \
            --style=ders/d.en/pdf.derse_ozel.css \
            --output=$@ --media=print

SILINECEK_DOSYALAR+=AliCehreli_resume.pdf

.PHONY:butun_dosyalar
butun_dosyalar:$(BUTUN_DOSYALAR)

TAR_FILE:=../public_html.tar.gz

# Contains the files that are necessary for ebook generation
EBOOK_TRANSFER:=../ebook_transfer.tar.gz

$(TAR_FILE): $(BUTUN_DOSYALAR)
	tar zcv $^ > $@

FILES_FOR_EBOOK+= \
    image/by-nc-sa.png \
    fonts/* \
    META-INF/* \
    ebook_font_manifest \
    README.ebook \

.PHONY: all
all: test screen print ebook

.PHONY: screen
screen: $(TAR_FILE)

TEST_DDOC:=test.ddoc
PDF_LOCAL_DDOC:=pdf_local.ddoc

.PHONY: $(TEST_DDOC)
$(TEST_DDOC):
	echo ROOT_DIR=`pwd`/../public_html_test > $@
	echo GOOGLE_TRANSLATE=[Google Translate] >> $@

$(PDF_LOCAL_DDOC): Makefile
	echo ROOT_DIR=`pwd` > $@
	echo GOOGLE_TRANSLATE=[Google Translate] >> $@

.PHONY: test
test: $(TEST_DDOC)
	$(MAKE) CIKIS=../public_html_test TEST_DEFS=$(TEST_DDOC) butun_dosyalar

.PHONY: clean_files
clean_files:
	@rm -f $(SILINECEK_DOSYALAR)
	@find . -type f -name "*.last_modified.ddoc" -exec rm {} \;

.PHONY: clean_dirs
clean_dirs:
	@WHAT_TO_DELETE="$(SILINECEK_KLASORLER)" && [[ !  -z  $$WHAT_TO_DELETE ]]
	@rm -rf $(SILINECEK_KLASORLER)

.PHONY: clean
clean: clean_files clean_dirs

.PHONY: print
print: $(PDF_FILES_FOR_PRINT)

$(EBOOK_TRANSFER): $(FILES_FOR_EBOOK)
	tar zcv $^ > $@

.PHONY: ebook
ebook: $(EBOOK_TRANSFER)
