Ddoc

$(DERS_BOLUMU $(IX struct) $(IX yapı) Yapılar)

$(P
Kitabın başında temel türlerin üst düzey kavramları ifade etmede yetersiz kalacaklarını söylemiştim. $(C int) türünden bir tamsayı örneğin iki olay arasında geçen süreyi dakika türünden ifade etmek için kullanılabilir; ama böyle bir değer her zaman tek başına kullanışlı olamaz. Değişkenler bazen başka değişkenlerle bir araya geldiklerinde anlam kazanırlar.
)

$(P
Yapılar temel türleri, başka yapıları, veya sınıfları bir araya getirerek yeni türler oluşturmaya yarayan olanaklardır. Yeni tür $(C struct) anahtar sözcüğü ile oluşturulur. $(C struct), "yapı" anlamına gelen "structure"ın kısaltmasıdır.
)

$(P
Bu bölümde yapılarla ilgili olarak anlatacağım çoğu bilgi, daha sonra göreceğimiz sınıfları anlamada da yardımcı olacak. Özellikle $(I bir araya getirerek yeni tür tanımlama) kavramı, yapılarda ve sınıflarda aynıdır.
)

$(P
Yapı kavramını anlamak için daha önce $(LINK2 /ders/d/assert.html, $(C assert) ve $(C enforce) bölümünde) gördüğümüz $(C zamanEkle) işlevine bakalım. Aşağıdaki tanım o bölümün problem çözümlerinde geçiyordu:
)

---
void zamanEkle(
        in int başlangıçSaati, in int başlangıçDakikası,
        in int eklenecekSaat, in int eklenecekDakika,
        out int sonuçSaati, out int sonuçDakikası) {
    sonuçDakikası = başlangıçDakikası + eklenecekDakika;
    sonuçSaati = başlangıçSaati + eklenecekSaat;
    sonuçSaati += sonuçDakikası / 60;

    sonuçDakikası %= 60;
    sonuçSaati %= 24;
}
---

$(P $(I Not: İşlevin $(C in), $(C out), ve $(C unittest) bloklarını fazla yer tutmamak için bu bölümde göstermiyorum.)
)

$(P
Her ne kadar o işlev altı tane parametre alıyor gibi görünse de, birbirleriyle ilgili olan parametreleri çifter çifter düşünürsek, aslında üç çift bilgi aldığını görürüz. O çiftlerden ilk ikisi giriş olarak, sonuncusu da çıkış olarak kullanılmaktadır.
)

$(H5 Tanımlanması)

$(P
$(C struct) birbirleriyle ilişkili değişkenleri bir araya getirerek yeni bir tür olarak kullanma olanağı verir:
)

---
$(CODE_NAME GününSaati)struct GününSaati {
    int saat;
    int dakika;
}
---

$(P
Yukarıdaki tanım, $(C saat) ve $(C dakika) isimli iki $(C int) değişkeni bir araya getiren ve ismi $(C GününSaati) olan yeni bir tür tanımlar. Yukarıdaki tanımdan sonra artık başka türler gibi kullanabileceğimiz $(C GününSaati) isminde yeni bir türümüz olur. Örnek olarak $(C int) türüne benzer kullanımını şöyle gösterebiliriz:
)

---
    int sayı;              // bir değişken
    sayı = başkaSayı;      // başkaSayı'nın değerini alması

    GününSaati zaman;      // bir nesne
    zaman = başkaZaman;    // başkaZaman'ın değerini alması
---

$(P
Yapı türleri şöyle tanımlanır:
)

---
struct $(I Türİsmi) {
    // ... türü oluşturan üyeler ve varsa özel işlevleri ...
}
---

$(P
Yapılar için özel işlevler de tanımlanabilir. Bunları daha sonraki bir bölümde anlatacağım. Bu bölümde yalnızca yapı üyelerini gösteriyorum.
)

$(P
Yapının bir araya getirdiği parçalara $(I üye) adı verilir. Bu tanıma göre, yukarıdaki $(C GününSaati) yapısının iki üyesi vardır: $(C saat) ve $(C dakika).
)

$(H6 $(C struct) tür tanımıdır, değişken tanımı değildir)

$(P
Burada bir uyarıda bulunmam gerekiyor: $(LINK2 /ders/d/isim_alani.html, İsim Alanı bölümünde) ve $(LINK2 /ders/d/yasam_surecleri.html, Yaşam Süreçleri bölümünde) anlatılanlar doğrultusunda; yapı tanımında kullanılan küme parantezlerine bakarak, o kapsam içindeki üyelerin yapının tanımlandığı an yaşamaya başladıklarını düşünebilirsiniz. Bu doğru değildir.
)

$(P
Yapı tanımı, değişken tanımlamaz:
)

---
struct GününSaati {
    int saat;      // ← Değişken tanımı değildir; daha sonra
                   //   bir yapı nesnesinin parçası olacaktır.

    int dakika;    // ← Değişken tanımı değildir; daha sonra
                   //   bir yapı nesnesinin parçası olacaktır.
}
---

$(P
Yapı tanımı, daha sonradan yapı nesneleri oluşturulduğunda ne tür üye değişkenlerinin olacağını belirler. O üye değişkenler bu yapı türünden bir nesne oluşturulduğu zaman o nesnenin parçası olarak oluşturulurlar:
)

---
    GününSaati yatmaZamanı;   // içinde kendi saat ve dakika
                              // değişkenlerini barındırır

    GününSaati kalkmaZamanı;  // bu da kendi saat ve dakika
                              // değişkenlerini barındırır;
                              // bunun saat ve dakika
                              // değişkenleri öncekinden
                              // bağımsızdır
---

$(P
$(IX nesne, yapı) Yapı ve sınıf değişkenlerine $(I nesne) denir.
)

$(H6 Kodlama kolaylığı)

$(P
Saat ve dakika gibi iki bilgiyi böyle bir araya getirerek tek bir tür gibi kullanabilmek büyük kolaylık sağlar. Örneğin yukarıdaki işlev altı tane $(C int) yerine, asıl amacına çok daha uygun olacak şekilde üç tane $(C GününSaati) türünde parametre alabilir:
)

---
void zamanEkle(in GününSaati başlangıç,
               in GününSaati eklenecek,
               out GününSaati sonuç) {
    // ...
}
---

$(P $(I Not: Günün saatini belirten böyle iki değerin eklenmesi aslında normal bir işlem olarak kabul edilmemelidir. Örneğin kahvaltı zamanı olan 7:30'a öğle yemeği zamanı olan 12:00'yi eklemek doğal değildir. Burada aslında $(C Süre) diye yeni bir tür tanımlamak ve $(C GününSaati) nesnelerine $(C Süre) nesnelerini eklemek çok daha doğru olurdu. Ben bu bölümde yine de yalnızca $(C GününSaati) türünü kullanacağım.)
)

$(P
Hatırlayacağınız gibi, işlevler $(C return) deyimiyle tek bir değer döndürebilirler. $(C zamanEkle) ürettiği saat ve dakika değerlerini zaten bu yüzden iki tane $(C out) parametre olarak tanımlamak zorunda kalıyordu. Ürettiği iki tane sonucu tek bir değer olarak döndüremiyordu.
)

$(P
Yapılar bu kısıtlamayı da ortadan kaldırırlar: Birden fazla bilgiyi bir araya getirerek tek bir tür oluşturdukları için, işlevlerin dönüş türü olarak kullanılabilirler. Artık işlevden tek bir $(C GününSaati) nesnesi döndürebiliriz:
)

---
GününSaati zamanEkle(in GününSaati başlangıç,
                     in GününSaati eklenecek) {
    // ...
}
---

$(P
Böylece $(C zamanEkle) artık yan etki oluşturan değil, değer üreten bir işlev haline de gelmiş olur. $(LINK2 /ders/d/islevler.html, İşlevler bölümünden) hatırlayacağınız gibi; işlevlerin yan etki oluşturmak yerine değer üretmeleri tercih edilir.
)

$(P
Yapılar da yapı üyesi olabilirler. Örneğin $(C GününSaati) yapısından iki üyesi bulunan başka bir yapı şöyle tasarlanabilir:
)

---
struct Toplantı {
    string     konu;
    size_t     katılımcıSayısı;
    GününSaati başlangıç;
    GününSaati bitiş;
}
---

$(P
$(C Toplantı) yapısı da başka bir yapının üyesi olabilir. $(C Yemek) diye bir yapı olduğunu da varsayarsak:
)

---
struct GünlükPlan {
    Toplantı projeToplantısı;
    Yemek    öğleYemeği;
    Toplantı bütçeToplantısı;
}
---

$(H5 $(IX ., üye) Üye erişimi)

$(P
Yapı üyelerini de herhangi bir değişken gibi kullanabiliriz. Tek fark, üyelere erişmek için nesnenin isminden sonra önce erişim işleci olan $(I nokta), ondan sonra da üyenin isminin yazılmasıdır:
)

---
    başlangıç.saat = 10;
---

$(P
O satır, $(C başlangıç) nesnesinin $(C saat) üyesine $(C 10) değerini atar.
)

$(P
Yapılarla ilgili bu kadarlık bilgiyi kullanarak $(C zamanEkle) işlevini artık şu şekilde değiştirebiliriz:
)

---
$(CODE_NAME zamanEkle)GününSaati zamanEkle(in GününSaati başlangıç,
                     in GününSaati eklenecek) {
    GününSaati sonuç;

    sonuç.dakika = başlangıç.dakika + eklenecek.dakika;
    sonuç.saat = başlangıç.saat + eklenecek.saat;
    sonuç.saat += sonuç.dakika / 60;

    sonuç.dakika %= 60;
    sonuç.saat %= 24;

    return sonuç;
}
---

$(P
Bu işlevde kullanılan değişken isimlerinin artık çok daha kısa seçilebildiğine dikkat edin: nesnelere $(C başlangıç), $(C eklenecek), ve $(C sonuç) gibi kısa isimler verebiliyoruz. $(C başlangıçSaati) gibi bileşik isimler kullanmak yerine de nesnelerin üyelerine nokta ile $(C başlangıç.saat) şeklinde erişiyoruz.
)

$(P
O işlevi kullanan bir kod aşağıdaki şekilde yazılabilir. Bu program, 1 saat 15 dakika süren ve 8:30'da başlayan dersin bitiş zamanını 9:45 olarak hesaplar:
)

---
$(CODE_XREF GününSaati)$(CODE_XREF zamanEkle)void main() {
    GününSaati dersBaşı;
    dersBaşı.saat = 8;
    dersBaşı.dakika = 30;

    GününSaati dersSüresi;
    dersSüresi.saat = 1;
    dersSüresi.dakika = 15;

    immutable dersSonu = zamanEkle(dersBaşı, dersSüresi);

    writefln("Ders sonu: %s:%s",
             dersSonu.saat, dersSonu.dakika);
}
---

$(P
Çıktısı:
)

$(SHELL
Ders sonu: 9:45
)

$(P
Yukarıdaki $(C main)'i şimdiye kadar bildiklerimizi kullanarak yazdım. Biraz aşağıda bu işlemlerin çok daha kolay ve kısa olanlarını göstereceğim.
)

$(H5 $(IX kurma) Kurma)

$(P
Yukarıdaki $(C main)'in ilk üç satırı, $(C dersBaşı) nesnesinin kurulması ile ilgilidir; ondan sonraki üç satır da $(C dersSüresi) nesnesinin kurulmasıdır. O satırlarda  önce nesne tanımlanmakta, sonra saat ve dakika üyelerinin değerleri atanmaktadır.
)

$(P
Herhangi bir değişkenin veya nesnenin tutarlı bir şekilde kullanılabilmesi için mutlaka kurulması gerekir. Bu çok önemli ve yaygın bir işlem olduğu için, yapı nesneleri için kısa bir kurma söz dizimi vardır:
)

---
    GününSaati dersBaşı = GününSaati(8, 30);
    GününSaati dersSüresi = GününSaati(1, 15);
---

$(P
Nesneler bu şekilde kurulurken belirtilen değerler, yapının üyelerine yapı içinde tanımlandıkları sıra ile atanırlar: yapı içinde $(C saat) önce tanımlandığı için 8 değeri $(C dersBaşı.saat)'e, 30 değeri de $(C dersBaşı.dakika)'ya atanır.
)

$(P
$(LINK2 /ders/d/tur_donusumleri.html, Tür Dönüşümleri bölümünde) gördüğümüz gibi, kurma söz dizimi başka türlerle de kullanılabilir:
)

---
    auto u = ubyte(42);    // u'nun türü ubyte olur
    auto i = int(u);       // i'nin türü int olur
---

$(H6 $(C immutable) olarak kurabilme olanağı)

$(P
Nesneleri aynı anda hem tanımlamak hem de değerlerini verebilmek, onları $(C immutable) olarak işaretleme olanağı da sağlar:
)

---
    immutable dersBaşı = GününSaati(8, 30);
    immutable dersSüresi = GününSaati(1, 15);
---

$(P
Kurulduktan sonra artık hiç değişmeyecek oldukları durumlarda, bu nesnelerin sonraki satırlarda yanlışlıkla değiştirilmeleri böylece önlenmiş olur. Yukarıdaki programda ise nesneleri $(C immutable) olarak işaretleyemezdik, çünkü ondan sonra üyelerinin değerlerini atamamız mümkün olmazdı:
)

---
    $(HILITE immutable) GününSaati dersBaşı;
    dersBaşı.saat = 8;      $(DERLEME_HATASI)
    dersBaşı.dakika = 30;   $(DERLEME_HATASI)
---

$(P
Doğal olarak, $(C immutable) olarak işaretlendiği için değişemeyen $(C dersBaşı) nesnesinin üyelerini değiştirmek olanaksızdır.
)

$(H6 Sondaki üyelerin değerleri boş bırakılabilir)

$(P
Yapı nesneleri kurulurken $(I sondaki) üyelerin değerleri belirtilmeyebilir. Bu durumda sondaki üyeler yine de otomatik olarak kendi türlerinin $(C .init) değeri ile ilklenirler.
)

$(P
Bunu gösteren aşağıdaki programda $(C Deneme) türü gittikçe azalan sayıda parametre ile kuruluyor ve geri kalan parametrelerin de otomatik olarak ilklendikleri $(C assert) denetimleri ile gösteriliyor (programda kullanmak zorunda kaldığım $(C isNaN) işlevini programdan sonra açıklıyorum):
)

---
import std.math;

struct Deneme {
    char   karakter;
    int    tamsayı;
    double kesirli;
}

void main() {
    // Bütün değerlerle
    auto d1 = Deneme('a', 1, 2.3);
    assert(d1.karakter == 'a');
    assert(d1.tamsayı == 1);
    assert(d1.kesirli == 2.3);

    // Sonuncusu eksik
    auto d2 = Deneme('a', 1);
    assert(d2.karakter == 'a');
    assert(d2.tamsayı == 1);
    assert($(HILITE isNaN(d2.kesirli)));

    // Son ikisi eksik
    auto d3 = Deneme('a');
    assert(d3.karakter == 'a');
    assert($(HILITE d3.tamsayı == int.init));
    assert($(HILITE isNaN(d3.kesirli)));

    // Hiçbirisi yok
    auto d4 = Deneme();
    assert($(HILITE d4.karakter == char.init));
    assert($(HILITE d4.tamsayı == int.init));
    assert($(HILITE isNaN(d4.kesirli)));

    // Yukarıdakiyle aynı şey
    Deneme d5;
    assert(d5.karakter == char.init);
    assert(d5.tamsayı == int.init);
    assert(isNaN(d5.kesirli));
}
---

$(P
$(LINK2 /ders/d/kesirli_sayilar.html, Kesirli Sayılar bölümünden) hatırlayacağınız gibi $(C double)'ın ilk değeri $(C double.nan)'dır ve bir değerin $(C .nan)'a eşit olup olmadığı $(C ==) işleci ile denetlenemez. O yüzden yukarıdaki programda $(C std.math.isNaN)'dan yararlanılmıştır.
)

$(H6 $(IX varsayılan değer, üye) Varsayılan üye değerlerinin belirlenmesi)

$(P
Üyelerin otomatik olarak ilkleniyor olmaları çok yararlı bir olanaktır. Üyelerin rasgele değerlerle kullanılmaları önlenmiş olur. Ancak, her üyenin kendi türünün $(C .init) değerini alması her duruma uygun değildir. Örneğin $(C char.init) değeri geçerli bir karakter bile değildir.
)

$(P
Bu yüzden üyelerin $(I otomatik olarak) alacakları değerler programcı tarafından belirlenebilir. Bu sayede örneğin yukarıda gördüğümüz ve hiçbir kullanışlılığı olmayan $(C double.nan) değeri yerine, çoğu zaman çok daha uygun olan 0.0 değerini kullanabiliriz.
)

$(P
Üyelerin aldıkları bu özel ilk değerlere $(I varsayılan değer) denir ve üye tanımından sonraki atama söz dizimiyle belirlenir:
)

---
struct Deneme {
    char   karakter $(HILITE = 'A');
    int    tamsayı  $(HILITE = 11);
    double kesirli  $(HILITE = 0.25);
}
---

$(P
Üye tanımı sırasında kullanılan bu yazım şeklinin bir atama işlemi olmadığına dikkat edin. Yukarıdaki kodun tek amacı, üyeler için hangi değerlerin varsayılacağını belirlemektir. Bu değerler, daha sonra nesne oluşturulurken gerekirse kullanılacaktır.
)

$(P
Nesne kurulurken değerleri özellikle belirtilmeyen üyeler o varsayılan değerleri alırlar. Örneğin aşağıdaki kullanımda nesnenin hiçbir üyesinin değeri verilmemektedir:
)

---
    Deneme d;  // hiçbir üye değeri belirtilmiyor
    writefln("%s,%s,%s", d.karakter, d.tamsayı, d.kesirli);
---

$(P
Bütün üyeler türün tanımında belirtilmiş olan ilk değerlere sahip olurlar:
)

$(SHELL
A,11,0.25
)

$(H6 $(IX {}, kurma) $(IX C söz dizimi, yapı kurucusu) $(C {}) karakterleriyle kurma)

$(P
Yukarıdaki kurma söz dizimi varken kullanmaya gerek olmasa da, bunu da bilmeniz gerekir. Yapı nesnelerini başka bir söz dizimiyle de kurabilirsiniz:
)

---
    GününSaati dersBaşı = { 8, 30 };
---

$(P
Belirlenen değerler bu kullanımda da üyelere sıra ile atanırlar; ve bu kullanımda da üye sayısından daha az değer verilebilir.
)

$(P
Bu söz dizimi D'ye C programlama dilinden geçmiştir:
)

---
    auto dersBaşı = GününSaati(8, 30);   // ← normal
    GününSaati dersSonu = { 9, 30 };     // ← C söz dizimi
---

$(P
$(IX isimli ilklendirici) Bu söz diziminin bir yararı, $(I isimli ilklendirici) olanağıdır. Verilen bir değerin hangi üye ile ilgili olduğu üyenin ismi ile belirtilebilir. Bu olanak, üyelerin yapı içindeki tanımlarından farklı sırada ilklenmelerine de izin verir:
)

---
    GününSaati g = { $(HILITE dakika:) 42, $(HILITE saat:) 7 };
---

$(H5 $(IX kopyalama, yapı) $(IX atama, yapı) Kopyalama ve Atama)

$(P
Yapılar değer türleridir. Bundan; $(LINK2 /ders/d/deger_referans.html, Değerler ve Referanslar bölümünde) açıklandığı gibi, her yapı nesnesinin kendisine ait değeri olduğunu anlarız. Kurulduklarında kendi değerlerini edinirler; atandıklarında da yalnızca kendi değerleri değişir.
)

---
    auto seninYemekSaatin = GününSaati(12, 0);
    auto benimYemekSaatim = seninYemekSaatin;

    // Yalnızca benim yemek saatim 12:05 olur:
    benimYemekSaatim.dakika += 5;

    // ... senin yemek saatin değişmez:
    assert(seninYemekSaatin.dakika == 0);
---

$(P
Kopyalama sırasında bir nesnenin bütün üyeleri sırayla diğer üyeye kopyalanır. Benzer şekilde, atama işlemi de bütün üyelerin sırayla atanmaları anlamına gelir.
)

$(P
Bu konuda referans türünden olan üyelere özellikle dikkat etmek gerekir.
)

$(H6 $(IX referans türü, üye) Referans türünden olan üyelere dikkat!)

$(P
Burada çok önemli bir konuyu hatırlatmak gerekiyor: Referans türünden olan değişkenler kopyalandıklarında veya atandıklarında asıl nesne değişmez, ona erişim sağlayan referans değişir, ve sonuçta asıl nesneye birden fazla referans tarafından erişim sağlanmış olur.
)

$(P
Bunun yapı üyeleri açısından önemi, iki farklı yapı nesnesinin üyelerinin aynı asıl nesneye erişim sağlıyor olacaklarıdır. Bunu görmek için referans türünden bir üyesi olan bir yapıya bakalım. Bir öğrencinin numarasını ve notlarını içeren şöyle bir yapı tanımlanmış olsun:
)

---
struct Öğrenci {
    int numara;
    int[] notlar;
}
---

$(P
O türden bir nesnenin başka bir nesnenin değeriyle kurulduğu şu koda bakalım:
)

---
    // Birinci öğrenciyi kuralım:
    auto öğrenci1 = Öğrenci(1, [ 70, 90, 85 ]);

    // İkinci öğrenciyi birincinin kopyası olarak kuralım ...
    auto öğrenci2 = öğrenci1;

    // ... ve sonra numarasını değiştirelim:
    öğrenci2.numara = 2;

    // DİKKAT: İki öğrenci bu noktada aynı notları paylaşmaktadırlar!

    // İlk öğrencinin notunda bir değişiklik yaptığımızda ...
    öğrenci1.notlar[0] += 5;

    // ... ikinci öğrencinin notunun da değiştiğini görürüz:
    writeln(öğrenci2.notlar[0]);
---

$(P
$(C öğrenci2) nesnesi kurulduğu zaman, üyeleri sırayla $(C öğrenci1)'in üyelerinin değerlerini alır. $(C int) bir değer türü olduğu için, her iki $(C Öğrenci) nesnesinin ayrı $(C numara) değeri olur.
)

$(P
Her iki $(C Öğrenci) nesnesinin birbirlerinden bağımsız olan $(C notlar) üyeleri de vardır. Ancak, dizi dilimleri referans türleri olduklarından, her ne kadar $(C notlar) üyeleri bağımsız olsalar da, aslında aynı asıl dizinin elemanlarına erişim sağlarlar. Sonuçta, bir nesnenin $(C notlar) üyesinde yapılan değişiklik diğerini de etkiler.
)

$(P
Yukarıdaki kodun çıktısı, iki öğrenci nesnesinin aynı asıl notları paylaştıklarını gösterir:
)

$(SHELL
75
)

$(P
Belki de burada hiç kopyalama işlemini kullanmadan, ikinci nesneyi kendi numarasıyla ve birincinin notlarının $(I kopyasıyla) kurmak daha doğru olur:
)

---
    // İkinci öğrenciyi birincinin notlarının kopyası ile
    // kuruyoruz
    auto öğrenci2 = Öğrenci(2, öğrenci1.notlar$(HILITE .dup));

    // İlk öğrencinin notunda bir değişiklik yaptığımızda ...
    öğrenci1.notlar[0] += 5;

    // ... ikinci öğrencinin notu bu sefer değişmez:
    writeln(öğrenci2.notlar[0]);
---

$(P
Dizilerin $(C .dup) niteliği ile kopyalandığı için bu sefer her nesnenin ayrı notları olur. Şimdiki çıktı, ikinci öğrencinin notunun etkilenmediğini gösterir:
)

$(SHELL
70
)

$(P
$(I Not: İstenen durumlarda referans türünden üyelerin otomatik olarak kopyalanmaları da sağlanabilir. Bunu daha sonra yapı işlevlerini anlatırken göstereceğim.)
)

$(H5 $(IX hazır değer, yapı) Yapı hazır değerleri)

$(P
Nasıl 10 gibi hazır değerleri hiç değişken tanımlamak zorunda kalmadan işlemlerde kullanabiliyorsak, yapı nesnelerini de isimleri olmayan $(I hazır değerler) olarak kullanabiliriz.
)

$(P
Yapı hazır değerlerini oluşturmak için yine kurma söz dizimi kullanılır ve yapı nesnesi gereken her yerde kullanılabilir.
)

---
    GününSaati(8, 30) // ← hazır değer
---

$(P
Yukarıdaki $(C main) işlevini şimdiye kadar öğrendiklerimizi kullanarak şöyle yazabiliriz:
)

---
$(CODE_XREF GününSaati)$(CODE_XREF zamanEkle)void main() {
    immutable dersBaşı = GününSaati(8, 30);
    immutable dersSüresi = GününSaati(1, 15);

    immutable dersSonu = zamanEkle(dersBaşı, dersSüresi);

    writefln("Ders sonu: %s:%s",
             dersSonu.saat, dersSonu.dakika);
}
---

$(P
Dikkat ederseniz, o programda $(C dersBaşı) ve $(C dersSüresi) nesnelerinin açıkça belirtilmelerine gerek yoktur. Onlar yalnızca $(C dersSonu) nesnesini hesaplamak için kullanılan aslında geçici nesnelerdir. O nesneleri açıkça tanımlamak yerine, $(C zamanEkle) işlevine şu şekilde $(I hazır değer) olarak da gönderebiliriz:
)

---
$(CODE_XREF GününSaati)$(CODE_XREF zamanEkle)void main() {
    immutable dersSonu = zamanEkle(GününSaati(8, 30),
                                   GününSaati(1, 15));

    writefln("Ders sonu: %s:%s",
             dersSonu.saat, dersSonu.dakika);
}
---

$(H5 $(IX static, üye) $(C static) üyeler)

$(P
Çoğu durumda her yapı nesnesinin kendi üyelerine sahip olmasını isteriz. Bazı durumlarda ise belirli bir yapı türünden olan bütün nesnelerin tek bir değişkeni paylaşmaları uygun olabilir. Bu, o yapı türü için akılda tutulması gereken genel bir bilgi bulunduğunda gerekebilir.
)

$(P
Bütün nesnelerin tek bir üyeyi paylaşmalarının bir örneği olarak, her bir nesne için farklı bir tanıtıcı numara olduğu bir durum düşünelim:
)

---
struct Nokta {
    // Her nesnenin kendi tanıtıcı numarası
    size_t numara;

    int satır;
    int sütun;
}
---

$(P
Her nesneye farklı bir numara verebilmek için $(C sonrakiNumara) gibi bir değişken barındırmak, ve her nesne için o sayıyı bir arttırmak gerekir:
)

---
Nokta NoktaOluştur(int satır, int sütun) {
    size_t numara = sonrakiNumara;
    ++sonrakiNumara;

    return Nokta(numara, satır, sütun);
}
---

$(P
Burada karar verilmesi gereken şey, her nesnenin oluşturulması sırasında ortak olarak kullanılan $(C sonrakiNumara) bilgisinin nerede tanımlanacağıdır. $(C static) üyeler işte bu gibi durumlarda kullanışlıdırlar.
)

$(P
O bilgi bir yapı üyesi olarak tanımlanır ve $(C static) olarak işaretlenir. Diğer üyelerin aksine, böyle üyelerden her iş parçacığında yalnızca bir adet oluşturulur. (Çoğu program yalnızca $(C main())'in işlediği tek iş parçacığından oluşur.):
)

---
import std.stdio;

struct Nokta {
    // Her nesnenin kendi tanıtıcı numarası
    size_t numara;

    int satır;
    int sütun;

    // Bundan sonra oluşturulacak olan nesnenin numarası
    $(HILITE static size_t sonrakiNumara;)
}

Nokta NoktaOluştur(int satır, int sütun) {
    size_t numara = $(HILITE Nokta.)sonrakiNumara;
    ++$(HILITE Nokta.)sonrakiNumara;

    return Nokta(numara, satır, sütun);
}

void main() {
    auto üstteki = NoktaOluştur(7, 0);
    auto ortadaki = NoktaOluştur(8, 0);
    auto alttaki =  NoktaOluştur(9, 0);

    writeln(üstteki.numara);
    writeln(ortadaki.numara);
    writeln(alttaki.numara);
}
---

$(P
$(C sonrakiNumara) her seferinde bir arttırıldığı için her nesnenin farklı numarası olur:
)

$(SHELL
0
1
2
)

$(P
$(C static) üyeler bütün türe ait olduklarından onlara erişmek için bir nesne olması gerekmez. O üyeye türün ismi kullanılarak erişilebileceği gibi, o türün bir nesnesi üzerinden de erişilebilir:
)

---
    ++Nokta.sonrakiNumara;
    ++$(HILITE alttaki).sonrakiNumara;     // üst satırın eşdeğeri
---

$(P
İş parçacığı başına tek değişken yerine bütün programda tek değişken gerektiğinde o değişkenin $(C shared static) olarak tanımlanması gerekir. $(C shared) anahtar sözcüğünü daha sonraki bir bölümde göreceğiz.
)

$(H6 $(IX static this) $(IX static ~this) $(IX this, static) $(IX ~this, static) İlk işlemler için $(C static&nbsp;this()), son işlemler için $(C static&nbsp;~this()))

$(P
Yukarıda $(C sonrakiNumara) üyesini özel bir değerle ilklemedik ve otomatik ilk değeri olan sıfırdan yararlandık. Gerektiğinde özel bir değerle de ilkleyebilirdik:
)

---
    static size_t sonrakiNumara $(HILITE = 1000);
---

$(P
O yöntem ancak ilk değer derleme zamanında bilindiğinde kullanılabilir. Ek olarak, bazı durumlarda yapının kullanımına geçmeden önce bazı ilkleme kodlarının işletilmesi de gerekebilir. Bu gibi ilkleme kodları yapının $(C static&nbsp;this()) kapsamına yazılırlar.
)

$(P
Örneğin, aşağıdaki kod nesne numaralarını hep sıfırdan başlatmak yerine eğer mevcutsa özel bir ayar dosyasından okuyor:
)

---
import std.file;

struct Nokta {
// ...

    enum sonNumaraDosyası = "Nokta_son_numara_dosyasi";

    $(HILITE static this()) {
        if (exists(sonNumaraDosyası)) {
            auto dosya = File(sonNumaraDosyası, "r");
            dosya.readf(" %s", &sonrakiNumara);
        }
    }
}
---

$(P
Bir yapının özel $(C static this()) kapsamındaki kodlar her iş parçacığında ayrı ayrı işletilir. Bu kodlar o yapı o iş parçacığında kullanılmaya başlanmadan önce otomatik olarak işletilir. İş parçacıklarının sayısından bağımsız olarak bütün programda tek kere işletilmesi gereken kodlar ise (örneğin, $(C immutable) değişkenlerin ilklenmeleri) $(C shared static this()) işlevlerinde tanımlanmalıdırlar. Bunları daha sonraki $(LINK2 /ders/d/es_zamanli_shared.html, Veri Paylaşarak Eş Zamanlı Programlama bölümünde) göreceğiz.
)

$(P
Benzer biçimde, $(C static ~this()) yapı türünün belirli bir iş parçacığındaki son işlemleri için, $(C shared static ~this()) de bütün programdaki son işlemleri içindir.
)

$(P
Örneğin, aşağıdaki $(C static ~this()) yukarıdaki $(C static this()) tarafından okunabilsin diye son numarayı ayar dosyasına kaydetmektedir:
)

---
struct Nokta {
// ...

    $(HILITE static ~this()) {
        auto dosya = File(sonNumaraDosyası, "w");
        dosya.writeln(sonrakiNumara);
    }
}
---

$(P
Böylece, program nesne numaralarını artık hep kaldığı yerden başlatacaktır. Örneğin, ikinci kere çalıştırıldığında programın çıktısı aşağıdaki gibidir:
)

$(SHELL
3
4
5
)

$(PROBLEM_COK

$(PROBLEM
Tek bir oyun kağıdını temsil eden ve ismi $(C OyunKağıdı) olan bir yapı tasarlayın. Bu yapının kağıt rengi ve kağıt değeri için iki üyesi olduğu düşünülebilir.

$(P
Renk için bir $(C enum) değer kullanabileceğiniz gibi; doğrudan ♠, ♡, ♢, ve ♣ karakterlerini de kullanabilirsiniz.
)

$(P
Kağıt değeri olarak da bir $(C int) veya bir $(C dchar) üye kullanabilirsiniz. $(C int) seçerseniz 1'den 13'e kadar değerlerden belki de 1, 11, 12, ve 13 değerlerini sırasıyla as, vale, kız ve papaz için düşünebilirsiniz.
)

$(P
Daha başka çözümler de bulunabilir. Örneğin kağıt değerini de bir $(C enum) olarak tanımlayabilirsiniz.
)

$(P
Bu yapının nesnelerinin nasıl kurulacakları, üyeler için seçtiğiniz türlere bağlı olacak. Örneğin eğer her iki üyeyi de $(C dchar) türünde tasarladıysanız, şöyle kurulabilirler:
)

---
    auto kağıt = OyunKağıdı('♣', '2');
---

)

$(PROBLEM
Bir $(C OyunKağıdı) nesnesi alan ve o nesneyi çıkışa yazdıran $(C oyunKağıdıYazdır) isminde bir işlev tanımlayın:

---
struct OyunKağıdı {
    // ... burasını siz yazın ...
}

void oyunKağıdıYazdır(in OyunKağıdı kağıt) {
    // ... burasını siz yazın ...
}

void main() {
    auto kağıt = OyunKağıdı(/* ... */);
    oyunKağıdıYazdır(kağıt);
}
---

$(P
Örneğin sinek ikiliyi çıktıya şu şekilde yazdırsın:
)

$(SHELL
♣2
)

$(P
Kupa asını da şu şekilde:
)

$(SHELL
♡A
)

$(P
O işlevin içeriği, doğal olarak yapıyı nasıl tasarladığınıza bağlı olacaktır.
)

)

$(PROBLEM

İsmi $(C yeniDeste) olan bir işlev yazın. Elli iki farklı oyun kağıdını temsil eden $(C OyunKağıdı)[] türünde bir dilim döndürsün:

---
OyunKağıdı[] yeniDeste()
out (sonuç) {
    assert(sonuç.length == 52);

} body {
    // ... burasını siz yazın ...
}
---

$(P
Bu işlev örneğin şöyle kullanılabilsin:
)

---
    OyunKağıdı[] deste = yeniDeste();

    foreach (kağıt; deste) {
        oyunKağıdıYazdır(kağıt);
        write(' ');
    }

    writeln();
---

$(P
Eğer destedeki her kağıt gerçekten farklı olmuşsa, şuna benzer bir çıktı olmalıdır:
)

$(SHELL
♠2 ♠3 ♠4 ♠5 ♠6 ♠7 ♠8 ♠9 ♠0 ♠J ♠Q ♠K ♠A ♡2 ♡3 ♡4
♡5 ♡6 ♡7 ♡8 ♡9 ♡0 ♡J ♡Q ♡K ♡A ♢2 ♢3 ♢4 ♢5 ♢6 ♢7
♢8 ♢9 ♢0 ♢J ♢Q ♢K ♢A ♣2 ♣3 ♣4 ♣5 ♣6 ♣7 ♣8 ♣9 ♣0
♣J ♣Q ♣K ♣A
)

)

$(PROBLEM
Desteyi karıştıran bir işlev yazın. $(LINK2 http://dlang.org/phobos/std_random.html, $(C std.random) modülünde) tanımlı olan $(C uniform) işlevini kullanarak rasgele seçtiği iki kağıdın yerini değiştirsin. Bu işlemi kaç kere tekrarlayacağını da parametre olarak alsın:

---
void karıştır(OyunKağıdı[] deste, in int değişTokuşAdedi) {
    // ... burasını siz yazın
}
---

$(P
Şu şekilde çağrılabilsin:
)

---
    OyunKağıdı[] deste = yeniDeste();
    karıştır(deste, 1);

    foreach (kağıt; deste) {
        oyunKağıdıYazdır(kağıt);
        write(' ');
    }

    writeln();
---

$(P
$(C değişTokuşAdedi) ile belirtilen değer kadar değiş tokuş işlemi gerçekleştirsin. Örneğin 1 ile çağrıldığında şuna benzer bir çıktı versin:
)

$(SHELL
♠2 ♠3 ♠4 ♠5 ♠6 ♠7 ♠8 ♠9 ♠0 ♠J ♠Q ♠K ♠A ♡2 ♡3 ♡4
♡5 ♡6 ♡7 ♡8 $(HILITE ♣4) ♡0 ♡J ♡Q ♡K ♡A ♢2 ♢3 ♢4 ♢5 ♢6 ♢7
♢8 ♢9 ♢0 ♢J ♢Q ♢K ♢A ♣2 ♣3 $(HILITE ♡9) ♣5 ♣6 ♣7 ♣8 ♣9 ♣0
♣J ♣Q ♣K ♣A
)

$(P
$(C değişTokuşAdedi) olarak daha yüksek bir değer verdiğinizde deste iyice karışmış olmalıdır:
)

---
    karıştır(deste, $(HILITE 100));
---

$(SHELL
♠4 ♣7 ♢9 ♢6 ♡2 ♠6 ♣6 ♢A ♣5 ♢8 ♢3 ♡Q ♢J ♣K ♣8 ♣4
♡J ♣Q ♠Q ♠9 ♢0 ♡A ♠A ♡9 ♠7 ♡3 ♢K ♢2 ♡0 ♠J ♢7 ♡7
♠8 ♡4 ♣J ♢4 ♣0 ♡6 ♢5 ♡5 ♡K ♠3 ♢Q ♠2 ♠5 ♣2 ♡8 ♣A
♠K ♣9 ♠0 ♣3
)

$(P
$(I Not: Deste karıştırmak için daha etkin bir yöntemi çözüm programında açıklıyorum.)
)

)

)

Macros:
        SUBTITLE=Yapılar

        DESCRIPTION=D dilinin kullanıcı türleri tanımlaya yarayan olanağı 'struct'

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial yapı yapılar struct kullanıcı türleri

SOZLER=
$(donus_degeri)
$(ilklemek)
$(isimli_ilklendirici)
$(is_parcacigi)
$(kapsam)
$(kurma)
$(nesne)
$(referans)
$(sabit)
$(uye)
$(varsayilan)
$(yan_etki)
$(yapi)
