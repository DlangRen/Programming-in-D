Ddoc

$(H4 D Diline Genel Bakış)

$(ESKI_KARSILASTIRMA)

$(P
Bu bölümde D'nin ilginç ve önemli olanaklarından bazılarını bulabilirsiniz. Bu listenin kaynağı Digital Mars'ın sitesindeki D tanıtım sayfasıdır.
)

$(H6 Sınıflar)

$(P
D'de nesne yönelimli programlamanın temelini sınıflar oluşturuyor. Bu konuda C++'dan oldukça köklü farkları var: Arayüz [interface] türetirken çoklu kalıtım, ama gerçekleştirme [implementation] türetirken tekli kalıtım... Bütün sıradüzenin en tepesinde $(CODE Object) temel arayüzü bulunuyor. Nesneler C ve C++'nın tersine $(I referans olarak) oluşturuluyorlar.
)

$(H6 İşleç yükleme [operator overloading])

$(P
İşleç yükleme konusunda aslında bir fark yok: Başka nesne yönelimli dillerde olduğu gibi D'de de işleçler her tür için özel olarak tanımlanabiliyor.
)

$(H6 Modüller)

$(P
Her kaynak dosya, içerisinde bulunduğu klasöre göre bir modülün parçası olarak kabul ediliyor. Bildirimleri derleyiciye tanıtmak için $(CODE #include) etmek yerine, modüller $(CODE import) ediliyorlar. Böylelikle ne başlık dosyalarına gerek kalıyor ne de programcılığın özüyle ilgisi olmayan $(CODE #ifndef) ve $(CODE #pragma once) gibi çözümlere...
)

$(H6 Bildirimler gereksiz)

$(P
C'de ve C++'da anahtar kelimeler dışındaki bütün isimlerin önceden bildirilmiş olmaları gerekir. $(CODE printf) bile $(CODE &lt;stdio.h&gt;) başlığı eklenmeden kullanılamaz. (Aslında bazı derleyiciler buna izin verirler ama standart değildir.) Bu yüzden programcılar sürekli olarak $(CODE .h) başlık dosyaları ile $(CODE .c) kod dosyalarını uyumlu tutmaya çabalarlar. Bu hem hataya açık hem de gereksiz bir külfettir. D'de ise bu iş derleyicinin görevidir:
)

---
import std.stdio;

void main()
{
    ismi_henüz_görülmemiş_bir_fonksiyon();
}

void ismi_henüz_görülmemiş_bir_fonksiyon()
{
    auto nesne = new İsmiHenüzGörülmemişBirSınıf;
    nesne.selam_ver();
}

class İsmiHenüzGörülmemişBirSınıf
{
    void selam_ver()
    {
        writeln("Merhaba!");
    }
}
---

$(H6 Şablonlar [templates])

$(P
Ne kadar güçlü olsalar da; C++'nın şablonları hem büyük uzmanlık gerektirir, hem de kullanımları bazı durumlarda çok sorunludur. C++ şablonlarının en büyük uzmanlarından birisi Andrei Alexandrescu'dur. Kendisi şablonlarla tasarımlarının ötesinde işler becermiş ve bunları $(I Modern C++ Design) kitabında tanıttığı Loki kütüphanesinde göstermiştir. C++'da gördüğü eksiklikleri D'ye taşımış ve şablonları D'de çok daha kullanışlı bir hale getirmiştir.
)

$(H6 Çağrışımlı diziler [associative arrays])

$(P
Başka dillerde de bulunan ve C++'da $(CODE std::map) ile sunulan çağrışımlı diziler D'de dilin iç olanaklarına dahil ve hızlı eşleme tablosu [hash table] olarak gerçekleştirilmişler.
)

$(H6 Gerçek anlamda $(CODE typedef)'ler)

$(P
C'de ve C++'da $(CODE typedef) yeni tür oluşturmaz, olan bir türe daha kullanışlı bir isim verir. D'de ise yeni bir tür oluşur. Sonuçta,
)

---
typedef int ÖğrenciNumarası;
---

$(P
ile oluşturulan $(CODE ÖğrenciNumarası) türü ile onun temel aldığı $(CODE int) farklıdırlar. Örneğin fonksiyonlar bu türler için ayrı ayrı yüklenebilirler:
)

---
int yazdır(int sayı);
int yazdır(ÖğrenciNumarası öğrenci);
---

$(H6 Belgeleme)

$(P
Kaynak kodlar geleneksel olarak; JavaDoc, Doxygen, vs. gibi araçlarla açıklama satırlarında belgelenir. Örneğin fonksiyon parametrelerinin ve dönüş değerlerinin ne anlama geldikleri ve nasıl kullanıldıkları, fonksiyonların başlarındaki $(CODE /**) ve $(CODE */) ile belirlenen açıklama bölümlerine yazılırlar. D'de belgeleme işi de derleyicinin görevidir; ayrıca program kullanmaya gerek yoktur. Dahası, belgeleme salt kod ile sınırlı değildir; okumakta olduğunuz bu sayfalar bile $(LINK2 http://dlang.org/ddoc.html, Ddoc) ile oluşturulmuşlardır.
)

$(H6 Kapsam fonksiyonları)

$(P
Fonksiyonlar başka fonksiyonların içinde tanımlanabilirler.
)

$(H6 Fonksiyon sabitleri [function literals])

$(P
Fonksiyonlar kullanıldıkları ifadeler içinde isimsiz olarak tanımlanabilirler. [Not: Fonksiyonlar zaten sabit oldukları halde burada $(I literal)'ı $(I string literal)'a benzeterek $(I sabit) olarak çeviriyorum.]
)

---
// Burada üçüncü parametre bir fonksiyon sabiti
foo(3, 10, (int sayı){ return sayı * sayı; } );

// Parametre almayan bir fonksiyon sabiti
bar(3, 10, { return 5; } );
---

$(H6 Kapamalar [closures])

$(P
Kapsam fonksiyonlarına ve sınıf üye fonksiyonlarına $(I kapama) ([delegate] de denir) olarak referans verebiliriz. Bu özellik türden bağımsız programlamayı kolaylaştırır ve daha güvenli hale getirir.
)

$(H6 Parametre türleri)

$(P
Parametreler kullanımlarına göre açıkça giriş, çıkış, veya giriş-çıkış olarak belirtilebilirler. C++'da parametrelerin kullanımları biraz anlaşmaya bağlıdır: giriş parametreleri $(I değer olarak) veya $(I $(CODE const) referans olarak) geçirilirler; çıkış ve giriş-çıkış parametreleri ise $(I işaretçi) veya $(I referans) olarak geçirilirler. Bu konu D'de açıktır.
)

$(H6 Diziler)

$(P
C dizilerinin C++'ya da taşınmış olan bir çok sorunu vardır:
)

$(UL
$(LI
C dizileri kendi uzunluklarından habersizdirler, çünkü dizi kavramı bir işaretçi ve onun kullanımıyla ilgili anlaşmalarla belirlenmiştir.
)

$(LI
C dizileri ikinci sınıf vatandaştırlar. Örneğin bir fonksiyona geçirilirken $(I ilk elemanlarını gösteren işaretçiye) dönüşürler. Bu dönüşüm sonucunda da, olası boyut bilgisi kaybedilmiş olur.
)

$(LI
C dizilerinin boyutları değiştirilemez.
)

$(LI
Uzunluk bilgisi taşımadıkları için dizi dışına taşma gibi yasal olan kullanımlar denetlenemez.
)

$(LI
Söz dizimi gereği dizi uzunluğu en sonda belirlendiği için, örneğin dizi işaretçilerinin tanımı çok gariptir:

---
int (*dizi_işaretçisi)[10];
---

D'de ise söz dizimi doğaldır:

---
int[10]* dizi_işaretçisi;  // 10 uzunlukta int dizisi
                           // işaretçisi

long[] fonksiyon(int x);   // long dizisi döndüren
                           // fonksiyon
---
)

)

$(P
D, dizilerin bu sorunlarını çözer.
)

$(H6 Dizgiler [strings])

$(P
Dizgiler programlama dilinden tam destek almayı gerektirecek kadar yaygın ve yararlı veri yapılarıdır. Modern dillerde olduğu gibi D'de de dizgiler C ve C++'dan farklı olarak doğrudan destek görürler.
)

$(H6 Otomatik bellek yönetimi)

$(P
D'de bellek yönetimi çöp toplamalıdır [garbage collected]. Bellek yönetimi konusundaki gözlemler, çöp toplama olanağının program geliştirmeyi çok çabuklaştırdığını ve çok daha kolaylaştırdığını gösteriyor. Ortaya çıkan program da çoğu durumda daha hızlı çalışıyor.
)

$(H6 Elle bellek yönetimi)

$(P
D çöp toplamalı olsa da, $(CODE new) ve $(CODE delete) işleçleri her sınıf için ayrı olarak yüklenebilir.
)

$(H6 RAII)

$(P
$(I Resource Acquisition Is Initialization)'ın kısaltması olan RAII, kaynakların bozucu fonksiyonlarda geri verilmesi yöntemidir. Hata atılan durumlarda bile kaynak sızıntılarını önler. D RAII'yi çöp toplamadan ayrı olarak ve ona ek olarak destekler.
)

$(H6 Etkin yapılar)

$(P
C'deki $(CODE struct) gibi alt düzey yapılar D'de de desteklenir. Bunlar hem C fonksiyonlarıyla etkileşmek için, hem de etkin veri yapıları oluşturmak için yararlıdırlar.
)

$(H6 Makine dili [assembly])

$(P
C'de ve C++'da olduğu gibi, D'de de gereken özel durumlarda doğrudan makine dilinde kod yazılabilir.
)

$(H6 Sözleşmeli programlama [contract programming])

$(P
Eiffel dilinin yaratıcısı Bertrand Meyer tarafından icat edilen sözleşmeli programlama, kodun doğruluğunu sağlama konusunda çok güçlü bir yöntemdir. Sözleşmeli programlama D'de fonksiyon giriş ve çıkış koşulları [precondition ve postcondition], sınıf değişmezleri, ve $(CODE assert)'lerden oluşur.
)

$(P
Örneğin $(CODE alan_) üyesinin değerinin her zaman için sıfırdan büyük olması beklenen bir $(CODE Üçgen) sınıfında bu $(I değişmezlik) kavramı $(CODE invariant) sözcüğü ile şöyle ifade edilebilir:
)

---
class Üçgen
{
    double alan_;
    /* ... */

    invariant()
    {
        /* Üçgen'in her üye fonksiyonunun her işletilişinden
         * sonra bu koşul denetlenecektir.  */
        assert(alan_ > 0.0);
    }
}
---

$(H6 Birim testleri [unit tests])

$(P
Birim testleri başka dillerde dilin dışında düzeneklerle halledilirler. Örneğin C++ için CppUnit, unittest++, vs. gibi bir birim test düzeneği genellikle $(CODE make) veya benzeri oluşturma sisteminin parçası olacak şekilde ayarlanırlar ve asıl programın dışında olarak çalıştırılırlar.
)

$(P
D birim testleri biraz daha ileri götürmüş ve dil olanağı haline getirmiştir. Testler örneğin sınıflara eklenirler, ve istenirse program başlamadan önce otomatik olarak çalıştırılırlar. Böylece sınıfların $(I değişmezlik) koşullarındaki tutarsızlıklar birim testleri tarafından en kısa sürede farkedilmiş olurlar.
)

$(H6 Hata ayıklama [debug] olanakları)

$(P
D'de hata ayıklama olanakları dilin parçasıdır. Hata ayıklayıcı kodlar makrolara gerek bırakmadan, derleyici düzeyinde etkin hale getirilebilirler. Böylece programın hem hata ayıklama sürümü [debug], hem de asıl sürümü [release] aynı kod tarafından oluşturulabilir.
)

$(H6 Hata atma [exceptions])

$(P
D, $(I try-catch)'den daha yararlı olduğu görülen $(I try-catch-finally) modelini kullanır. Böylece küçük kaynak temizlikleri için bile C++'da olduğu gibi ayrıca sınıf yazmak gerekmemiş olur.
)

$(H6 Çoklu iş parçacıkları [multi-threads])

$(P
D bu konuya dil düzeyinde çözüm getirir. Sınıf ve fonksiyon düzeyinde koruma sağlar. Örneğin $(CODE synchronized) olarak belirtilen fonksiyonların tek bir anda yalnızca tek bir iş parçacığı tarafından işletilmeleri dil tarafından sağlanır.
)

---
synchronized int fonksiyon()
{
    /* Bu kod belirli bir anda tek bir iş parçacığı
     * tarafından işletilir */
}
---


$(H6 Sağlam kodlama yöntemleri)

$(P
D, kod doğruluğunu ve güvenliğini arttıran bazı olanaklar getirir:
)

$(UL

$(LI
İşaretçilere duyulan ihtiyaç büyük ölçüde giderilmiştir: dinamik diziler, referans değişkenler, referans nesneler, vs.
)

$(LI
Çöp toplamalı bellek yönetimi
)

$(LI
Çoklu iş parçacıklarına dil desteği
)

$(LI
Kodda beklenmeyen değişiklikler yapan makrolar yok
)

$(LI
Makroların bazı görevlerinin yerine $(I iç fonksiyonlar) [inline functions].
)

$(LI
C ve C++'dakinin tersine, temel türlerin büyüklükleri açıkça belirtilebilir (o dillerde örneğin $(CODE int)'in kaç bit olduğu bile belli değildir)
)

$(LI
C ve C++'dakinin tersine, $(CODE char) türünün işaretiyle ilgili belirsizlik yoktur (o dillerde $(CODE char) üçüncü bir tür olarak ya $(CODE signed char)'ın ya da $(CODE unsigned char)'ın eşdeğeridir ama hangisinin eşdeğeri olduğu belirsizdir)
)

$(LI
Bildirimlerin başlıklarda ve kod dosyalarında ayrı ayrı ve tutarlı olarak yazılmaları gerekmez
)

$(LI
Hata ayıklayıcı kodu ekleyebilmek için ayrıştırma [parsing] desteği
)

)

$(H6 Derleme zamanı denetimleri)

$(UL

$(LI
Kuvvetli tür denetimi 
)

$(LI
Tek bir $(CODE ;) karakteri içeren boş $(CODE for) döngülerine izin verilmez
)

$(LI
Atamalar Bool değere dönüşmezler
)

$(LI
Eski ve geçersiz arayüz fonksiyonlarına izin verilmez
)

)

$(H6 Çalışma zamanı denetimleri)

$(UL

$(LI
$(CODE assert()) ifadeleri
)

$(LI
Dizi dışına taşmaya karşı denetim
)

$(LI
$(CODE switch) ifadelerinde yanlış $(CODE case) denetimi
)

$(LI
Bellek yetersizliği durumlarında atılan hata
)

$(LI
Fonksiyon giriş ve çıkış koşulları ve sınıf değişmezleri yoluyla sözleşmeli programlama desteği
)

)


$(H6 İşleç öncelikleri)

$(P
Bu konudaki sürprizleri ve hataları engellemek için D C'deki işleç önceliklerini kullanır.
)

$(H6 C fonksiyonlarına doğrudan destek)

$(P
D'ni C'ninkilere bire bir karşılık gelen veri yapıları da destekleridiği için, C kütüphane fonksiyonları hiçbir dönüşüm gerekmeden doğrudan çağrılabilirler.
)

$(H6 Bütün C türlerine destek)

$(P
C'deki $(CODE struct)'lar, $(CODE union)'lar, $(CODE enum)'lar, işaretçiler, C99'un getirdiği bütün türler desteklenir. Hatta $(CODE struct) üyelerinin bellek sıralanma düzenleri [alignment] bile belirlenebilir.
)

$(H6 İşletim sistemi hataları)

$(P
D'nin hata yakalama düzeneği işletim sistemi tarafından atılan hatalarla da uyumludur.
)

$(H6 Araç programlarla uyumluluk)

$(P
D standart program parçası [object file] formatında kod üretir. Bu sayede; hata ayıklayıcı, bağlayıcı, vs. mevcut araç programların D programları ile kullanılmaları da sağlanmış olur.
)

$(H6 Kod sürümleri)

$(P
D, bir program kodundan birden fazla sürüm üretilmesine destek verir. Böylelikle $(CODE #if)/$(CODE #endif) gibi yöntemlere gerek kalmamış olur.
)

$(H6 Emekliye ayrılan kod)

$(P
Çeşitli nedenlerle artık kullanılmaması gereken kodlar $(I eski) oldukları şeklinde işaretlenebilirler ve böylece yeni kodlarda kullanılmaları önlenebilir ama gerekirse eski programlarda kullanılmalarına izin verilebilir.
)




Macros:
        SUBTITLE=Genel Bakış

        DESCRIPTION=D programlama dilinin temel olanakları

        KEYWORDS=d programlama dili tanıtım genel bilgi
