Ddoc

$(H4 D Diliyle İlgili Makaleler)

$(UL

$(LI $(LINK2 /makale/dub_tanisma.html, DUB ile Tanışalım - Zafer Çelenk)

$(P
Bu yazı proje ve paket yönetim programı olan DUB'ı tanıtır.
)
)

$(LI $(LINK2 /makale/saflik.html, D'nin Saflık Kavramı - David Nadlinger)

$(P
Bu yazı D'deki saflık $(ASIL purity) kavramını ve $(C pure) anahtar sözcüğünün diğer dil olanaklarıyla etkileşimini anlatır.
)

)

$(LI $(LINK2 /makale/d_tipleri.html, D Dilindeki Tipleri Anlamak - Zafer Çelenk)

$(P
Bu yazı D'nin temel tiplerini ve onların bitlerle nasıl gerçekleştirildiklerini anlatır.
)
)

$(LI $(LINK2 /makale/d_dilimleri.html, D Dilimleri - Steven Schveighoffer)

$(P
Bu yazı D'nin en kullanışlı olanaklarından olan dilimleri tanıtır ve performanslarının ve güvenliliklerinin perde arkasında nasıl sağlandığını anlatır.
)

$(P
$(LINK2 http://www.dsource.org/projects/dcollections/wiki/ArrayArticle, Yazının aslı), Digital Mars firmasının Haziran 2011 tarihli makale yarışmasının adayları arasındadır.
)
)

$(LI
$(LINK2 /makale/eleman_erisimi_uzerine.html, Eleman Erişimi Üzerine - Andrei Alexandrescu)

$(P D dilinin tasarlayıcılarından olan Andrei Alexandrescu bu yazısında toplulukların algoritmalardan soyutlanmalarını sağlayan erişicileri (iterator) tanıtıyor, eksikliklerine değiniyor, ve erişici kavramından daha güçlü olduğunu gösterdiği aralık (range) kavramını öneriyor.
)

$(P
$(LINK2 http://www.informit.com/articles/printerfriendly.aspx?p=1407357, Yazının aslı) informIT'te 9 Kasım 2009'da yayınlanmıştır.
)

$(P
Bu yazıda ortaya atılan fikirler daha sonradan D'nin standart kütüphanesi olan Phobos'ta da bazı isim değişiklikleriyle uygulanmıştır:
)

$(UL
$(LI OnePassRange $(C InputRange) ismiyle)
$(LI $(C ForwardRange) aynı isimle)
$(LI DoubleEndedRange $(C BidirectionalRange) ismiyle)
$(LI $(C RandomAccessRange) aynı isimle)
$(LI ve yazıda çok az değinilen $(C OutputRange).)
)

)

$(LI $(LINK2 /makale/neden_d.html, Neden D - Andrei Alexandrescu)

$(P C++'nın en büyük ustalarından birisi olan Andrei Alexandrescu, şimdilerde enerjisini Walter Bright tarafından tasarlanmış olan D programlama dilini geliştirme üzerine yönlendirmiş durumda... Alexandrescu, çeşitli nedenlerle C++'ya eklenemeyen çoğu dil olanağının D'ye eklenmesine yardım ederek, bir anlamda D'yi $(I C++'nın olmayı başaramadığı dil) haline getiriyor.
)

$(P
Kendisine özgü heyecanlı tarzını içeren bu yazısında Alexandrescu, D dilinin neden önemli olduğunu ve belki de sizin için de uygun bir dil olabileceğini göstermeye çalışıyor.
)

$(P
Bu yazının İngilizce aslı ilk olarak $(LINK2 http://www.accu.org, ACCU)'nun yayın organlarından CVu'nun Mayıs 2009 sayısında yayınlanmıştır. Bütün hakları yazarı Andrei Alexandrescu'ya aittir.
)

$(P Haziran 2009'da Ali Çehreli tarafından çevrilen yazının İngilizce aslı, Türkçe çevirisinden kısa bir süre sonra $(LINK2 http://www.ddj.com/, Doctor Dobbs Journal)'ın sitesinde de yayınlanmıştır: $(LINK2 http://www.ddj.com/hpc-high-performance-computing/217801225, İngilizce aslı)
)

)

$(LI
$(LINK2 /makale/tembel_hesap.html, Fonksiyon Argümanlarında Tembel Değerlendirmeler - Walter Bright)

$(P
D'nin yaratıcısı olan Walter Bright bu yazısında tembel değerlendirmelerin gücünü gösteriyor ve bu olanağın açtığı kod kolaylıklarının örneklerini veriyor.
)
)

$(LI
$(LINK2 /makale/katma.html, Dizgi Katmaları [mixin])

$(P
Derleme zamanında oluşturulan dizgilerin nasıl koda dönüştürüldüklerini gösteren kısa bir yazı.
)
)

$(LI
$(LINK2 /makale/degismez.html, $(CODE const) ve $(CODE immutable) Kavramları)

$(P
D'deki değişmezlik kavramlarının tanıtılmaları ve $(CODE const) ve $(CODE immutable) anahtar sözcüklerinin kullanımları.
)
)

$(LI
$(LINK2 /makale/bellek.html, Bellek Yönetimi)

$(P
Her ciddi program bellek ayırma ve geri verme işlemleriyle ilgilenmek zorundadır. Programların karmaşıklıkları, boyutları, ve hızları arttıkça bu işlemlerin önemi de artar. D'de bellek yönetimi için kullanılan yöntemler...
)
)

$(LI
$(LINK2 /makale/duzenli_ifadeler.html, Düzenli İfadeler [Regular Expressions])

$(P
Düzenli ifadeler, metinlerin belirli bir $(I desene) uyanlarını bulmaya ve eşleştirmeye yarayan çok güçlü araçlardır. Düzenli ifadelerin D'de Ruby'deki kadar güçlü olduklarını ve ondan ne farklılıklar gösterdiğini bulacaksınız.
)

)

$(LI
$(LINK2 /makale/shared.html, $(C shared)'e Geçiş)

$(P
D2'de evrensel değişkenler artık normalde iş parçacıklarına özel alana (thread local storage (TLS)) yerleştiriliyorlar. Bu yazıda bununla ilgili bilgiler; ve özellikle $(C immutable), $(C shared), ve $(C __gshared) anahtar sözcüklerinin bu konudaki etkilerini göreceksiniz.
)

)

)

Macros:
        SUBTITLE=Makaleler

        DESCRIPTION=D programlama diliyle ilgili ilginç ve önemli makaleler

        KEYWORDS=d programlama dili makale belge tanıtım

       BREADCRUMBS=$(BREADCRUMBS_INDEX)
