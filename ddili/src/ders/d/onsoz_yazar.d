Ddoc

$(DIV_CLASS preface,

$(DERS_BOLUMU_CLASS preface, Yazarın Önsözü)

$(P
D, en alt düzeylerden en üst düzeylere kadar bütün güçlü programlama kavramlarını destekleyen ve özellikle bellek güvenliğini, program doğruluğunu, ve kolay kullanımı ön plana çıkartan $(I çok paradigmalı) bir programlama dilidir.
)

$(P
Bu kitabın temel amacı yeni başlamış olan okuyuculara programcılığı D dilini kullanarak öğretmektir. Her ne kadar başka dillerde kazanılmış olan deneyimler yararlı olsa da, bu kitap programcılığa en temel kavramlardan başlar.
)

$(P
Bu kitabı izleyebilmek için D programlarınızı yazacak, derleyecek, ve çalıştıracak bir ortama ihtiyacınız olacak. Bu $(I geliştirme ortamında) en azından bir derleyici ve bir metin düzenleyici bulunması şarttır. Derleyici kurulumunu ve programların nasıl derlendiklerini bir sonraki bölümde göreceğiz.
)

$(P
Her bölüm olabildiğince az sayıda kavramı hep daha önceki bölümlerde öğrenilen bilgiler üzerine kurulu olarak anlatmaya çalışıyor. Bu yüzden kitabı başından sonuna doğru hiç bölüm atlamadan okumanızı öneririm. Bu kitap her ne kadar yeni başlayanlar için yazılmış olsa da D dilinin hemen hemen tamamını içerir. Deneyimli okuyucular dizin bölümünden yararlanarak kitabı bir D referansı olarak da kullanabilirler.
)

$(P
Bazı bölümlerin sonunda o zamana kadar öğrendiğiniz bilgileri kullanarak programlayabileceğiniz küçük problemler ve kendi çözümlerinizle karşılaştırabilmeniz için çözümler de bulunuyor.
)

$(P
Kitabın sonunda (ve HTML sürümünün her sayfasında) kitapta kullanılan Türkçe terimlerin İngilizcelerini içeren bir sözlük bulunuyor.
)

$(P
Programcılık yeni araçlar, yöntemler, ve kavramlar öğrenmeyi gerektiren çok doyurucu bir uğraştır. D programcılığından en az benim kadar hoşlanacağınızı umuyorum. Programlama dilleri başkalarıyla paylaşıldığında hem daha kolay öğrenilir hem de çok daha zevklidir. Çeşitli $(LINK2 http://ddili.org/forum/, D forumlarını) izlemenizi ve o forumlara katkıda bulunmanızı öneririm.
)

$(P
Bu kitap $(LINK2 http://ddili.org/ders/d.en/, İngilizce)'ye ve $(LINK2 http://dlang.unix.cat/programmer-en-d/, Fransızca)'ya da çevrilmiştir.
)

$(H5_FRONTMATTER Teşekkür)

$(P
Bu kitabın gelişiminde büyük katkıları bulunan aşağıdaki kişilere teşekkür ederim.
)

$(P
Mert Ataol, Zafer Çelenk, Salih Dinçer, Can Alpay Çiftçi, Faruk Erdem Öncel, Muhammet Aydın (Mengü Kağan), Ergin Güney, Jordi Sayol, David Herberth, Andre Tampubolon, Gour-Gadadhara Dasa, Raphaël Jakse, Andrej Mitrović, Johannes Pfau, Jerome Sniatecki, Jason Adams, Ali H. Çalışkan, Paul Jurczak, Brian Rogoff, Михаил Страшун (Mihails Strasuns), Joseph Rushton Wakeling, Tove, Hugo Florentino, Satya Pothamsetti, Luís Marques, Christoph Wendler, Daniel Nielsen, Ketmar Dark, Pavel Lukin, Jonas Fiala, Norman Hardy, Rich Morin, Douglas Foster, Paul Robinson, Sean Garratt, Stéphane Goujet, Shammah Chancellor, Steven Schveighoffer, Robbin Carlson, Bubnenkov Dmitry Ivanovich, Bastiaan Veelo, Olivier Pisano, Dave Yost, Tomasz Miazek-Mioduszewski, Gerard Vreeswijk, Justin Whear, Gerald Jansen, Sylvain Gault, Shriramana Sharma, Jay Norwood, Henri Menke, ve Chen Lejia.
)

$(P
Özellikle Luís Marques kitabın İngilizce çevirisinin her bölümü üzerinde ayrıntılı düzenlemeler yaptı ve önerilerde bulundu. Bu kitap bir miktar da olsa yararlı olmayı başarabilmişse bunu Luís'in usta düzenlemelerine borçluyum.
)

$(P
Bu kitabın yazım sürecinde heyecanımı canlı tutan bütün D topluluğuna teşekkür ederim. D dili, bearophile ve Kenji Hara gibi yorulmak bilmeyen kişilerden oluşan harika bir topluluğa sahiptir.
)

$(P
Ebru, Damla, ve Derin, sabrınız ve desteğiniz için çok teşekkür ederim. İyi ki varsınız.
$(BR)
$(BR)
Ali Çehreli$(BR)
Mountain View, $(I Nisan 2016)
)

)

Macros:
    SUBTITLE = Yazarın Önsözü
    DESCRIPTION=
    KEYWORDS=

SOZLER=
$(cok_paradigmali)
$(derleyici)
$(gelistirme_ortami)
$(metin_duzenleyici)

