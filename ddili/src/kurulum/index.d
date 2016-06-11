Ddoc

$(H4 D Programlama Dili ile İlgili Programların Kurulması)

$(P
Burada D programları yazarken kullanılan programlardan bazılarının nasıl kurulduklarını bulacaksınız.
)

$(H5 Derleyiciler)

$(P
Bu yazının yazıldığı günlerde D derleyicisi olarak üç seçenek var. D'nin yeni olanakları hep öncelikle Digital Mars derleyicisi olan $(C dmd) üzerinde geliştirilmişlerdir. Bu yüzden $(C dmd)'nin daha yetenekli olduğunu düşünebiliriz.
)

$(P
Derleyicilerin hepsi ücretsiz, kullanımları tamamen serbest ve hepsi de yaygın ortamları destekliyor: Linux, Windows, ve Mac.
)

$(UL

$(LI $(B $(LINK2 /kurulum/dmd.html, Linux'ta $(CODE dmd)'nin kurulması)): $(CODE dmd), D dilinin yaratıcısı ve ana destekçisi olan Digital Mars firmasının derleyicisidir.
)

$(LI $(B $(LINK2 /kurulum/gdc.html, Linux'ta $(CODE gdc)'nin kurulması)): $(CODE gdc), çoğumuzun $(CODE gcc) ile yakından tanıdığı GNU'nun derleyicisidir. $(B Uyarı:) Ana $(C gcc) sürümü bu yazıyı yazdığım sırada D2 desteğini henüz içermiyor ama geliştirici sürümlerinde dilin 2.053 sürümü destekleniyor.
)

$(LI Halen geliştirilmekte olan $(LINK2 http://www.dsource.org/projects/ldc, $(CODE ldc)). $(B Uyarı:) Henüz D2'yi desteklemiyor.
)

)

$(H5 Geliştirme Ortamları)

$(P
Geliştirme ortamı seçenekleri için dlang.org sitesine bakabilirsiniz:
)

$(P
$(LINK http://wiki.dlang.org/IDEs)
)

$(P
$(LINK http://wiki.dlang.org/Editors)
)

$(H5 $(C dmd) derleyicisinin Windows'da Code::Blocks altında kurulması)

$(P
Kurulum adımlarını Ddili Forum'da $(LINK2 http://ddili.org/forum/thread/2, esatarslan52'nin açtığı bir konuda) bulabilirsiniz.
)

$(P
Code::Blocks projelerinde Türkçe harfler kullanabilmek için de forumdaki şu yazıdan yararlanabilirsiniz: $(LINK http://ddili.org/forum/post/8)
)

$(H5 Emacs $(CODE d-mode) Metin Düzenleme Modu)

$(P
Eğer hâlâ Emacs'ta ısrar eden bir programcıysanız D kaynak kodlarını yazmanızda yardımcı olması için $(LINK2 /kurulum/emacs_d-mode.html, d-mode'u kurmanızı) öneririm. Emacs'in iyi taraflarından birisi, dosyaları doğal olarak UTF-8 düzeninde kaydetmesidir.
)

Macros:
        SUBTITLE=Kurulum

        DESCRIPTION=D programlama dili derleyicilerinin ve araçlarının kurulmaları

        KEYWORDS=d programlama dili derleyici araç gereç program kur indir

        BREADCRUMBS=$(BREADCRUMBS_INDEX)
