Ddoc

$(DERS_BOLUMU $(IX foreach) $(IX döngü, foreach) $(CH4 foreach) Döngüsü)

$(P
$(C foreach) D'nin en kullanışlı deyimlerinden birisidir. "Her birisi için" anlamına gelir. Belirli işlemleri bir topluluktaki (veya bir aralıktaki) elemanların her birisi ile yapmayı sağlar.
)



$(P
Topluluk elemanlarının tümüyle yapılan işlemler programcılıkta çok yaygındır. $(LINK2 /ders/d/for_dongusu.html, $(C for) döngüsünün) bir dizinin bütün elemanlarına erişmek için nasıl kullanıldığını görmüştük:
)

---
    for (int i = 0; i != dizi.length; ++i) {
        writeln(dizi[i]);
    }
---

$(P
Bu iş için gereken adımları şöyle özetleyebiliriz:
)

$(UL
$(LI İsmi geleneksel olarak $(C i) olan bir sayaç tanımlamak (aslında biz önceki örneklerde hep $(C sayaç) dedik))
$(LI Döngüyü topluluğun $(C .length) niteliğine kadar ilerletmek)
$(LI $(C i)'yi arttırmak)
$(LI Elemana erişmek)
)

$(P
Bu adımlar ayrı ayrı elle yapılmak yerine $(C foreach) ile çok daha basit olarak şöyle ifade edilir:
)

---
    foreach (eleman; dizi) {
        writeln(eleman);
    }
---

$(P
$(C foreach)'in güçlü yanlarından birisi, eşleme tabloları ile de aynı biçimde kullanılabilmesidir. $(C for) döngüsünde ise, örneğin bir eşleme tablosunun bütün elemanlarına erişmek için tablo'nun $(C .values) niteliği çağrılır:
)

---
    auto elemanlar = tablo$(HILITE .values);
    for (int i = 0; i != elemanlar.length; ++i) {
        writeln(elemanlar[i]);
    }
---

$(P
$(C foreach) eşleme tabloları için özel bir kullanım gerektirmez; eşleme tabloları da dizilerle aynı biçimde kullanılır:
)

---
    foreach (eleman; tablo) {
        writeln(eleman);
    }
---

$(H5 Söz dizimi)

$(P
$(C foreach) üç bölümden oluşur:
)

---
    foreach ($(I isimler); $(I topluluk_veya_aralık)) {
        $(I işlem_bloğu)
    }
---

$(UL
$(LI $(B $(I topluluk_veya_aralık)): döngünün işletileceği elemanları belirler
)

$(LI $(B $(I işlem_bloğu)): her elemanla yapılacak işlemleri belirler
)

$(LI $(B $(I isimler)): erişilen elemanın ve varsa başka nesnelerin isimlerini belirler; seçilen isimler programcıya bağlı olsa da, bunların anlamı ve adedi topluluk çeşidine göre değişir
)
)

$(H5 $(C continue) ve $(C break))

$(P
Bu anahtar sözcüklerin ikisi de burada da aynı anlama gelirler: $(C continue) döngünün erkenden ilerletilmesini, $(C break) de döngünün sonlandırılmasını bildirir.
)

$(H5 Dizilerle kullanımı)

$(P
$(I isimler) bölümüne yazılan tek isim, dizinin elemanını ifade eder:
)

---
    foreach (eleman; dizi) {
        writeln(eleman);
    }
---

$(P
Eğer iki isim yazılırsa birincisi otomatik bir sayaçtır, ikincisi yine elemanı ifade eder:
)

---
    foreach (sayaç, eleman; dizi) {
        writeln(sayaç, ": ", eleman);
    }
---

$(P
Sayacın değeri $(C foreach) tarafından otomatik olarak arttırılır. Sayaç değişkeninin ismi programcıya kalmış olsa da isim olarak $(C i) de çok yaygındır.
)

$(H5 $(IX stride, std.range) Dizgilerle kullanımı ve $(C std.range.stride))

$(P
Dizilerle aynı şekilde kullanılır. Tek isim yazılırsa dizginin karakterini ifade eder, çift isim yazılırsa sayaç ve karakterdir:
)

---
    foreach (karakter; "merhaba") {
        writeln(karakter);
    }

    foreach (sayaç, karakter; "merhaba") {
        writeln(sayaç, ": ", karakter);
    }
---

$(P
$(C char) ve $(C wchar) türlerinin Unicode karakterlerini barındırmaya genel olarak uygun olmadıklarını hatırlayın. $(C foreach) bu türlerle kullanıldığında karakterlere değil, kod birimlerine erişilir:
)

---
    foreach (sayaç, kod; "abcçd") {
        writeln(sayaç, ": ", kod);
    }
---

$(P
Örneğin ç'yi oluşturan kodlara ayrı ayrı erişilir:
)

$(SHELL
0: a
1: b
2: c
3: 
4: �
5: d
)

$(P
UTF kodlamasından bağımsız olarak her tür dizginin $(C foreach) ile $(I karakter karakter) erişilmesini sağlayan olanak, $(C std.range) modülündeki $(C stride)'dır. $(C stride) "adım" anlamına gelir ve karakterlerin kaçar kaçar atlanacağı bilgisini de alır:
)

---
import std.range;

// ...

    foreach (harf; stride("abcçd", 1)) {
        writeln(harf);
    }
---

$(P
$(C stride) kullanıldığında UTF kodlarına değil Unicode karakterlerine erişilir:
)

$(SHELL
a
b
c
ç
d
)

$(P
Bu kodda neden sayaç kullanılamadığını biraz aşağıda açıklayacağım.
)

$(H5 Eşleme tablolarıyla kullanımı)

$(P
Tek isim yazılırsa eleman değerini, iki isim yazılırsa indeks ve eleman değerini ifade eder:
)

---
    foreach (eleman; tablo) {
        writeln(eleman);
    }

    foreach (indeks, eleman; tablo) {
        writeln(indeks, ": ", eleman);
    }
---

$(P
$(I Not: Eşleme tablolarında indeksin de herhangi bir türden olabileceğini hatırlayın. O yüzden bu döngüde $(C sayaç) yazmadım.)
)

$(P
$(IX .byKey, foreach) $(IX .byValue, foreach) $(IX .byKeyValue, foreach) Eşleme tabloları indekslerini ve elemanlarını $(I aralıklar) olarak da sunabilirler. Aralıkları daha $(LINK2 /ders/d/araliklar.html, ilerideki bir bölümde) göreceğiz. Eşleme tablolarının $(C .byKey), $(C .byValue), ve $(C .byKeyValue) nitelikleri $(C foreach) döngülerinden başka ortamlarda da kullanılabilen hızlı aralık nesneleri döndürürler.
)

$(P
$(C .byValue), $(C foreach) döngülerinde yukarıdaki elemanlı döngü ile karşılaştırıldığında fazla bir yarar sağlamaz. $(C .byKey) ise bir eşleme tablosunun $(I yalnızca) indeksleri üzerinde ilerlemenin en hızlı yoludur:
)

---
    foreach (indeks; tablo$(HILITE .byKey)) {
        writeln(indeks);
    }
---

$(P
$(C .byKeyValue) $(LINK2 /ders/d/cokuzlular.html, çokuzlu) gibi kullanılan bir değişken döndürür. İndeks ve eleman değerleri o değişkenin $(C .key) ve $(C .value) nitelikleri ile elde edilir:
)

---
    foreach (eleman; tablo$(HILITE .byKeyValue)) {
        writefln("%s indeksinin değeri: %s",
                 eleman$(HILITE .key), eleman$(HILITE .value));
    }
---

$(H5 $(IX sayı aralığı) $(IX .., sayı aralığı) Sayı aralıklarıyla kullanımı)

$(P
Sayı aralıklarını $(LINK2 /ders/d/dilimler.html, Başka Dizi Olanakları bölümünde) görmüştük. $(C foreach)'in $(I topluluk_veya_aralık) bölümüne bir sayı aralığı da yazılabilir:
)

---
    foreach (sayı; 10..15) {
        writeln(sayı);
    }
---

$(P
Hatırlarsanız; yukarıdaki kullanımda 10 aralığa dahildir, 15 değildir.
)

$(H5 Yapılarla, sınıflarla, ve aralıklarla kullanımı)

$(P
$(C foreach), bu desteği veren yapı, sınıf, ve aralık nesneleriyle de kullanılabilir. Nasıl kullanıldığı hakkında burada genel bir şey söylemek olanaksızdır, çünkü tamamen o tür tarafından belirlenir. $(C foreach)'in nasıl işlediğini ancak söz konusu yapının, sınıfın, veya aralığın belgesinden öğrenebiliriz.
)

$(P
Yapılar ve sınıflar $(C foreach) desteğini ya $(C opApply()) isimli üye işlevleri ya da $(I aralık (range) üye işlevleri) aracılığıyla verirler; aralıklar ise bu iş için aralık üye işlevleri tanımlarlar. Bu olanakları daha sonraki bölümlerde göreceğiz.
)

$(H5 $(IX sayaç, foreach) Sayaç yalnızca dizilerde otomatiktir)

$(P
Sayaç olanağı yalnızca dizilerde bulunur. $(C foreach) dizilerden başka türlerle kullanıldığında ve sayaç gerektiğinde, açıkça değişken tanımlanabilir ve arttırılabilir:
)

---
    size_t sayaç = 0;
    foreach (eleman; topluluk) {
        // ...
        ++sayaç;
    }
---

$(P
Böyle bir değişken, sayacın döngünün her ilerletilişinde değil, belirli bir koşul sağlandığında arttırılması gerektiğinde de yararlı olur. Örneğin aşağıdaki döngü yalnızca 10'a tam olarak bölünen sayıları sayar:
)

---
import std.stdio;

void main() {
    auto dizi = [ 1, 0, 15, 10, 3, 5, 20, 30 ];

    size_t sayaç = 0;
    foreach (sayı; dizi) {
        if ((sayı % 10) == 0) {
            $(HILITE ++sayaç);
            write(sayaç);

        } else {
            write(' ');
        }

        writeln(": ", sayı);
    }
}
---

$(P
Çıktısı:
)

$(SHELL
 : 1
1: 0
 : 15
2: 10
 : 3
 : 5
3: 20
4: 30
)

$(H5 Elemanın kopyası, kendisi değil)

$(P
$(C foreach) döngüsü; normalde elemanın kendisine değil, bir kopyasına erişim sağlar. Topluluk elemanlarının yanlışlıkla değiştirilmelerini önlemek amacıyla böyle tasarlandığını düşünebilirsiniz.
)

$(P
Bir dizinin elemanlarının her birisini iki katına çıkartmaya çalışan şu koda bakalım:
)

---
import std.stdio;

void main() {
    double[] sayılar = [ 1.2, 3.4, 5.6 ];

    writefln("Önce : %s", sayılar);

    foreach (sayı; sayılar) {
        sayı *= 2;
    }

    writefln("Sonra: %s", sayılar);
}
---

$(P
Programın çıktısı, $(C foreach) kapsamında $(C sayı)'ya yapılan atamanın etkisi olmadığını gösteriyor:
)

$(SHELL
Önce : 1.2 3.4 5.6
Sonra: 1.2 3.4 5.6
)

$(P
$(IX ref, foreach) Bunun nedeni, $(C sayı)'nın dizi elemanının kendisi değil, onun bir kopyası olmasıdır. Dizi elemanının kendisinin ifade edilmesi istendiğinde, isim bir $(I referans) olarak tanımlanır:
)

---
    foreach ($(HILITE ref) sayı; sayılar) {
        sayı *= 2;
    }
---

$(P
Yeni çıktıda görüldüğü gibi, $(C ref) anahtar sözcüğü dizideki asıl elemanın etkilenmesini sağlamıştır:
)

$(SHELL
Önce : 1.2 3.4 5.6
Sonra: 2.4 6.8 11.2
)

$(P
Oradaki $(C ref) anahtar sözcüğü, $(C sayı)'yı asıl elemanın bir $(I takma ismi) olarak tanımlar. $(C sayı)'da yapılan değişiklik artık elemanın kendisini etkilemektedir.
)

$(H5 Topluluğun kendisi değiştirilmemelidir)

$(P
Topluluk elemanlarını $(C ref) olarak tanımlanmış olan değişkenler aracılığıyla değiştirmekte bir sakınca yoktur. Ancak, $(C foreach) döngüsü kapsamında topluluğun kendi yapısını etkileyecek hiçbir işlem yapılmamalıdır. Örneğin diziden eleman silinmemeli veya diziye eleman eklenmemelidir.
)

$(P
Bu tür işlemler topluluğun yapısını değiştireceklerinden, ilerlemekte olan $(C foreach) döngüsünün işini bozarlar. O noktadan sonra programın davranışının ne olacağı bilinemez.
)

$(H5 $(IX foreach_reverse) $(IX döngü, foreach_reverse) Ters sırada ilerlemek için $(C foreach_reverse))

$(P
$(C foreach_reverse) $(C foreach) ile aynı biçimde işler ama aralığı ters sırada ilerler:
)

---
    auto elemanlar = [ 1, 2, 3 ];

    foreach_reverse (eleman; elemanlar) {
        writefln("%s ", eleman);
    }
---

$(P
Çıktısı:
)

$(SHELL
3 
2 
1 
)

$(P
$(C foreach_reverse)'ün kullanımı yaygın değildir. Çoğunlukla onun yerine daha sonra göreceğimiz $(C retro()) isimli aralık işlevi kullanılır.
)

$(PROBLEM_TEK

$(P
Eşleme tablolarının indeks değerleri ile eleman değerlerini $(I eşlediklerini) görmüştük. Bu tek yönlüdür: indeks verildiğinde eleman değerini elde ederiz, ama eleman değeri verildiğinde indeks değerini elde edemeyiz.
)

$(P
Elinizde hazırda şöyle bir eşleme tablosu olsun:
)

---
    string[int] isimle = [ 1:"bir", 7:"yedi", 20:"yirmi" ];
---

$(P
O tablodan ve tek bir $(C foreach) döngüsünden yararlanarak, $(C rakamla) isminde başka bir eşleme tablosu oluşturun. Bu yeni tablo, $(C isimle) tablosunun tersi olarak çalışsın: isime karşılık rakam elde edebilelim. Örneğin
)

---
    writeln(rakamla["yirmi"]);
---

$(P
yazdığımızda çıktı şöyle olsun:
)

$(SHELL
20
)

)



Macros:
        SUBTITLE=foreach Döngüsü

        DESCRIPTION=D dilinin foreach döngüsünün tanıtılması

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial foreach döngüsü döngü

SOZLER=
$(aralik)
$(blok)
$(deyim)
$(dilim)
$(dongu)
$(eleman)
$(nesne)
$(referans)
$(sinif)
$(soz_dizimi)
$(topluluk)
$(uye_islev)
$(yapi)
