Ddoc

$(DERS_BOLUMU $(IX şablon) $(IX template) Ayrıntılı Şablonlar)

$(P
Şablonların ne kadar kullanışlı olduklarını $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) görmüştük. Algoritmaların veya veri yapılarının tek tanımını yazarak birden çok türle çalışmalarını sağlayabiliyorduk.
)

$(P
O bölümde şablonların en çok karşılaşılan kullanımlarını göstermiştim. Bu bölümde şablon olanağını daha ayrıntılı olarak göreceğiz. Devam etmeden önce en azından o bölümün sonundaki özeti bir kere daha gözden geçirmenizi öneririm; o bölümde anlatılanları burada tekrarlamamaya çalışacağım.
)

$(P
Daha önce işlev, yapı, ve sınıf şablonlarını tanımıştık ve şablon parametrelerinin türler konusunda serbestlik getirdiklerini görmüştük. Bu bölümde; hem birlik ve arayüz şablonlarını da tanıyacağız; hem de şablon parametrelerinin değer, $(C this), $(C alias), ve çokuzlu çeşitleri olduğunu da göreceğiz.
)

$(H5 $(IX kestirme söz dizimi, şablon) Kestirme ve uzun söz dizimi)

$(P
C++ gibi başka dillerde de olduğu gibi D'nin şablonları çok güçlü olanaklardır. Buna rağmen, en çok yararlanılan kullanımlarının olabildiğince rahat ve anlaşılır olmasına çalışılmıştır. İşlev, yapı, veya sınıf şablonu tanımlamak; isminden sonra şablon parametre listesi eklemek kadar kolaydır:
)

---
T ikiKatı$(HILITE (T))(T değer) {
    return 2 * değer;
}

class Kesirli$(HILITE (T)) {
    T pay;
    T payda;

    // ...
}
---

$(P
Daha önce de görmüş olduğunuz yukarıdaki tanımlar, D'nin kestirme şablon tanımlarıdır.
)

$(P
Aslında şablonlar daha uzun olarak $(C template) anahtar sözcüğü ile tanımlanırlar. Yukarıdaki söz dizimleri, aşağıdaki tanımların kısa eşdeğerleridir:
)

---
template ikiKatı$(HILITE (T)) {
    T ikiKatı(T değer) {
        return 2 * değer;
    }
}

template Kesirli$(HILITE (T)) {
    class Kesirli {
        T pay;
        T payda;

        // ...
    }
}
---

$(P
Derleyicinin her zaman için uzun tanımı kullandığını, ve kestirme söz dizimini arka planda şu şekilde uzun tanıma dönüştürdüğünü düşünebiliriz:
)

$(OL
$(LI Tanımladığımız şablonu bir $(C template) kapsamı içine alır.)
$(LI O kapsama da aynı ismi verir.)
$(LI Şablon parametre listesini bizim tanımladığımız şablondan alır ve o kapsama verir.)
)

$(P
Kestirme tanım; biraz aşağıda göreceğimiz $(I tek tanım içeren şablon) olanağı ile ilgilidir.
)

$(H6 $(IX isim alanı, şablon) Şablon isim alanı)

$(P
$(C template) bloğu, aslında bir seferde birden çok şablon tanımlanmasına da olanak verir:
)

---
template ŞablonBloğu(T) {
    T birİşlev(T değer) {
        return değer / 3;
    }

    struct BirYapı {
        T üye;
    }
}
---

$(P
Yukarıdaki blokta bir işlev bir de yapı şablonu tanımlamaktadır. O şablonları örneğin $(C int) ve $(C double) türleri için, ve uzun isimleriyle şöyle kullanabiliriz:
)

---
    auto sonuç = $(HILITE ŞablonBloğu!int).birİşlev(42);
    writeln(sonuç);

    auto nesne = $(HILITE ŞablonBloğu!double).BirYapı(5.6);
    writeln(nesne.üye);
---

$(P
Şablonun belirli bir türle kullanımı bir $(I isim alanı) tanımlar. Bloğun içindeki isimler o isim alanı açıkça belirtilerek kullanılabilirler. Bu isimler fazla uzun olabileceklerinden onlara $(LINK2 /ders/d/alias.html, $(C alias) bölümünde) gördüğümüz $(C alias) anahtar sözcüğü ile kısa takma isimler verilebilir:
)

---
    alias KarakterYapısı = ŞablonBloğu!dchar.BirYapı;

// ...

    auto nesne = $(HILITE KarakterYapısı)('ğ');
    writeln(nesne.üye);
---

$(H6 $(IX aynı isimde tanım içeren şablon) $(IX eponymous) Aynı isimde tanım içeren $(C template) blokları)

$(P
Şablon bloğunun ismi ile aynı isimde tanım içeren şablon blokları içerdikleri o tanımın yerine geçerler. Bu, şimdiye kadarki şablonlarda kullandığımız kestirme söz dizimini sağlayan olanaktır. ($(I Not: Bu olanağa İngilizce'de) eponymous templates $(I denir.))
)

$(P
Örnek olarak, büyüklüğü 20 bayttan fazla olan türlerin $(I büyük) olarak kabul edildiği bir program olsun. Bir türün büyük olup olmadığının kararı şöyle bir şablonun içindeki bir $(C bool) değişken ile belirlenebilir:
)

---
template büyük_mü(T) {
    enum büyük_mü = T.sizeof > 20;
}
---

$(P
Dikkat ederseniz, hem şablonun hem de içindeki tanımın isimleri aynıdır. Öyle olduğunda bu uzun şablon tanımının isim alanı ve içindeki tanım açıkça $(C büyük_mü!int.büyük_mü) diye yazılmaz, kısaca yalnızca şablonun isim alanı yazılır:
)

---
    writeln($(HILITE büyük_mü!int));
---

$(P
Yukarıdaki işaretli bölüm, şablon içindeki aynı isimli $(C bool) yerine geçer. Yukarıdaki kod çıktıya $(C false) yazar çünkü $(C büyük_mü!int), şablon içindeki $(C bool) türündeki değişkendir ve $(C int)'in uzunluğu 4 bayt olduğundan o $(C bool) değişkenin değeri $(C false)'tur.
)

$(P
Yukarıdaki aynı isimde tanım içeren şablon, kısa söz dizimiyle de tanımlanabilir:
)

---
enum büyük_mü$(HILITE (T)) = T.sizeof > 20;
---

$(P
Aynı isimde tanım içeren şablonların yaygın bir kullanımı, türlere takma isimler vermektir. Örneğin, aşağıdaki şablon verilen türlerden büyük olanına eşdeğer olan bir $(C alias) tanımlamaktadır:
)

---
$(CODE_NAME Büyüğü)template Büyüğü(A, B) {
    static if (A.sizeof < B.sizeof) {
        alias Büyüğü = B;

    } else {
        alias Büyüğü = A;
    }
}
---

$(P
Sekiz bayttan oluşan $(C long) türü dört bayttan oluşan $(C int) türünden daha büyük olduğundan $(C Büyüğü!(int, long)), $(C long)'un eşdeğeri olur. Bu çeşit şablonlar $(C A) ve $(C B) gibi türlerin kendilerinin şablon parametreleri oldukları durumlarda özellikle yararlıdırlar:
)

---
$(CODE_XREF Büyüğü)// ...

/* Bu işlevin dönüş türü, şablon parametrelerinden büyük
 * olanıdır: Ya A ya da B. */
auto hesapla(A, B)(A a, B b) {
    $(HILITE Büyüğü!(A, B)) sonuç;
    // ...
    return sonuç;
}

void main() {
    auto h = hesapla(1, 2$(HILITE L));
    static assert(is (typeof(h) == $(HILITE long)));
}
---

$(H5 Şablon çeşitleri)

$(H6 İşlev, sınıf, ve yapı şablonları)

$(P
Bu alt başlığı bütünlük amacıyla yazdım.
)

$(P
Yukarıda da görüldüğü gibi, bu tür şablonlarla hem $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) hem de daha sonraki örneklerde çok karşılaştık.
)

$(H6 $(IX üye işlev şablonu) Üye işlev şablonları)

$(P
Yapı ve sınıf üye işlevleri de şablon olabilir. Örneğin, aşağıdaki $(C ekle()) üye işlev şablonu, içindeki işlemlerle uyumlu olduğu sürece her türden değişkeni kabul eder (bu örnekteki tek şart, o değişkenin $(C to!string) ile kullanılabilmesidir):
)

---
class Toplayıcı {
    string içerik;

    void ekle$(HILITE (T))(auto ref const T değer) {
        import std.conv;
        içerik ~= değer.to!string;
    }
}
---

$(P
Ancak, şablonların teoride sonsuz farklı kullanımı olabileceğinden, $(LINK2 /ders/d/tureme.html, sanal işlev) olamazlar çünkü derleyici şablonun hangi kullanımlarının sınıfın arayüzüne dahil edileceğine karar veremez. (Sanal işlev olamadıklarından $(C abstract) anahtar sözcüğü ile de tanımlanamazlar.)
)

$(P
Örneğin, aşağıdaki alt sınıfın $(C ekle()) şablonu üst sınıftaki aynı isimli işlevin yeni tanımını veriyormuş gibi görünse de aslında isim gizlemeye neden olur (isim gizlemeyi $(LINK2 /ders/d/alias.html, alias bölümünde) görmüştük):
)

---
class Toplayıcı {
    string içerik;

    void ekle(T)(auto ref const T değer) {
        import std.conv;
        içerik ~= değer.to!string;
    }
}

class KümeParantezliToplayıcı : Toplayıcı {
    /* Bu şablon üst sınıftakinin yeni tanımı değildir; üst
     * sınıftaki 'ekle' ismini gizlemektedir. */
    void ekle(T)(auto ref const T değer) {
        import std.string;
        super.ekle(format("{%s}", değer));
    }
}

void toplayıcıyıDoldur($(HILITE Toplayıcı) toplayıcı) {
    /* Aşağıdaki işlev çağrıları sanal değildir. Buradaki
     * 'toplayıcı' parametresinin türü 'Toplayıcı' olduğundan
     * her iki çağrı da Toplayıcı.ekle şablonuna
     * devredilirler. */

    toplayıcı.ekle(42);
    toplayıcı.ekle("merhaba");
}

void main() {
    auto toplayıcı = new $(HILITE KümeParantezliToplayıcı)();
    toplayıcıyıDoldur(toplayıcı);

    import std.stdio;
    writeln(toplayıcı.içerik);
}
---

$(P
Sonuçta, asıl nesnenin türü $(C KümeParantezliToplayıcı) olduğu halde, $(C toplayıcıyıDoldur()) işlevinin içindeki bütün çağrılar parametresinin türü olan $(C Toplayıcı)'ya sevk edilir. İçerik $(C KümeParantezliToplayıcı.ekle()) işlevinin yerleştirdiği küme parantezlerini içermemektedir:
)

$(SHELL
42merhaba    $(SHELL_NOTE KümeParantezliToplayıcı'nın işi değil)
)

$(H6 $(IX birlik şablonu) $(IX union şablonu) Birlik şablonları)

$(P
Birlik şablonları, yapı şablonları ile aynı şekilde tanımlanırlar. Birlik şablonları için de kestirme şablon söz dizimi kullanılabilir.
)

$(P
Bir örnek olarak, $(LINK2 /ders/d/birlikler.html, Birlikler bölümünde) tanımladığımız $(C IpAdresi) birliğinin daha genel ve daha kullanışlı olanını tasarlamaya çalışalım. O bölümdeki birlik; değer olarak $(C uint) türünü kullanıyordu. O değerin parçalarına erişmek için kullanılan dizinin elemanlarının türü de $(C ubyte) idi:
)

---
union IpAdresi {
    uint değer;
    ubyte[4] baytlar;
}
---

$(P
O birlik, hem IPv4 adresi değeri tutuyordu, hem de o değerin parçalarına ayrı ayrı erişme olanağı veriyordu.
)

$(P
Aynı kavramı daha genel isimler de kullanarak bir şablon halinde şöyle tanımlayabiliriz:
)

---
union ParçalıDeğer$(HILITE (AsılTür, ParçaTürü)) {
    AsılTür değer;
    ParçaTürü[/* gereken eleman adedi */] parçalar;
}
---

$(P
Bu birlik şablonu, asıl değerin ve alt parçalarının türünü serbestçe tanımlama olanağı verir. Asıl tür ve parça türü, birbirlerinden bağımsız olarak seçilebilirler.
)

$(P
Burada gereken bir işlem, parça dizisinin uzunluğunun kullanılan türlere bağlı olarak hesaplanmasıdır. $(C IpAdresi) birliğinde, $(C uint)'in dört adet $(C ubyte) parçası olduğunu bildiğimiz için sabit olarak 4 yazabilmiştik. Bu şablonda ise dizinin uzunluğu, kullanılan türlere göre otomatik olarak hesaplanmalıdır.
)

$(P
Türlerin bayt olarak uzunluklarının $(C .sizeof) niteliğinden öğrenilebildiğini biliyoruz. Kaç parça gerektiği bilgisini $(C .sizeof) niteliğinden yararlanan ve kısa söz dizimine olanak veren bir şablon içinde hesaplayabiliriz:
)

---
$(CODE_NAME elemanAdedi)template elemanAdedi(AsılTür, ParçaTürü) {
    enum elemanAdedi = (AsılTür.sizeof + (ParçaTürü.sizeof - 1))
                       / ParçaTürü.sizeof;
}
---

$(P $(I Not: O hesaptaki $(C (ParçaTürü.sizeof - 1)) ifadesi, türlerin uzunluklarının birbirlerine tam olarak bölünemediği durumlarda gerekir. Asıl türün 5 bayt, parça türünün 2 bayt olduğunu düşünün. Aslında 3 parça gerektiği halde o ifade eklenmediğinde 5/2 hesabının sonucu tamsayı kırpılması nedeniyle 2 çıkar.)
)

$(P
Artık parça dizisinin eleman adedi olarak o şablonun değerini kullanabiliriz ve böylece birliğin tanımı tamamlanmış olur:
)

---
$(CODE_NAME ParçalıDeğer)$(CODE_XREF elemanAdedi)union ParçalıDeğer(AsılTür, ParçaTürü) {
    AsılTür değer;
    ParçaTürü[elemanAdedi!(AsılTür, ParçaTürü)] parçalar;
}
---

$(P
Daha önce tanımladığımız $(C IpAdresi) birliğinin eşdeğeri olarak bu şablonu kullanmak istesek, türleri $(C IpAdresi)'nde olduğu gibi sırasıyla $(C uint) ve $(C ubyte) olarak belirtmemiz gerekir:
)

---
$(CODE_XREF ParçalıDeğer)import std.stdio;

void main() {
    auto adres = ParçalıDeğer!$(HILITE (uint, ubyte))(0xc0a80102);

    foreach (eleman; adres.parçalar) {
        write(eleman, ' ');
    }
}
---

$(P
$(LINK2 /ders/d/birlikler.html, Birlikler bölümünde) gördüğümüz çıktının aynısını elde ederiz:
)

$(SHELL_SMALL
2 1 168 192
)

$(P
Bu şablonun getirdiği esnekliği görmek için IPv4 adresinin parçalarını iki adet $(C ushort) olarak edinmek istediğimizi düşünelim. Bu sefer, $(C ParçalıDeğer) şablonunun $(C ParçaTürü) parametresi olarak $(C ushort) yazmak yeterlidir:
)

---
    auto adres = ParçalıDeğer!(uint, $(HILITE ushort))(0xc0a80102);
---

$(P
Alışık olmadığımız bir düzende olsa da, bu seferki çıktı iki $(C ushort)'tan oluşmaktadır:
)

$(SHELL_SMALL
258 49320
)

$(H6 $(IX arayüz şablonu) $(IX interface şablonu) Arayüz şablonları)

$(P
Arayüz şablonları arayüzde kullanılan türler, değerler, vs. konusunda serbestlik getirirler. Arayüz şablonlarında da kestirme tanım kullanılabilir.
)

$(P
Örnek olarak, renkli nesnelerin arayüzünü tanımlayan ama renk olarak hangi türün kullanılacağını serbest bırakan bir arayüz tasarlayalım:
)

---
interface RenkliNesne(RenkTürü) {
    void renklendir(RenkTürü renk);
}
---

$(P
O arayüz, kendisinden türeyen sınıfların $(C renklendir) işlevini tanımlamalarını gerektirir; ama renk olarak ne tür kullanılacağı konusunu serbest bırakır.
)

$(P
Bir sitedeki bir çerçeveyi temsil eden bir sınıf; renk olarak kırmızı, yeşil, ve maviden oluşan üçlü bir yapı kullanabilir:
)

---
struct KırmızıYeşilMavi {
    ubyte kırmızı;
    ubyte yeşil;
    ubyte mavi;
}

class SiteÇerçevesi : RenkliNesne$(HILITE !KırmızıYeşilMavi) {
    void renklendir(KırmızıYeşilMavi renk) {
        // ...
    }
}
---

$(P
Öte yandan, renk olarak ışığın frekansını kullanmak isteyen bir sınıf, renk için frekans değerine uygun olan başka bir türden yararlanabilir:
)

---
alias Frekans = double;

class Lamba : RenkliNesne$(HILITE !Frekans) {
    void renklendir(Frekans renk) {
        // ...
    }
}
---

$(P
Yine $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünden) hatırlayacağınız gibi, "her şablon gerçekleştirmesi farklı bir türdür". Buna göre, $(C RenkliNesne!KırmızıYeşilMavi) ve $(C RenkliNesne!Frekans) arayüzleri, farklı arayüzlerdir. Bu yüzden, onlardan türeyen sınıflar da birbirlerinden bağımsız sıradüzenlerin parçalarıdırlar; $(C SiteÇerçevesi) ve $(C Lamba), birbirlerinden bağımsızdır.
)

$(H5 $(IX parametre, şablon) Şablon parametre çeşitleri)

$(P
Şimdiye kadar gördüğümüz şablonlar, hep türler konusunda serbestlik getiriyorlardı.
)

$(P
Yukarıdaki örneklerde de kullandığımız $(C T) ve $(C RenkTürü) gibi şablon parametreleri, hep türleri temsil ediyorlardı. Örneğin $(C T)'nin anlamı, şablonun kod içindeki kullanımına bağlı olarak $(C int), $(C double), $(C Öğrenci), vs. gibi bir tür olabiliyordu.
)

$(P
Şablon parametreleri; değer, $(C this), $(C alias), ve çokuzlu da olabilirler.
)

$(H6 $(IX tür şablon parametresi) Tür parametreleri)

$(P
Bu alt başlığı bütünlük amacıyla yazdım.
)

$(P
Şimdiye kadar gördüğümüz bütün şablon parametreleri zaten hep tür parametreleriydi.
)

$(H6 $(IX değer şablon parametresi) Değer parametreleri)

$(P
Şablon parametresi olarak değerler de kullanılabilir. Bu, şablonun tanımı ile ilgili bir değerin serbest bırakılmasını sağlar.
)

$(P
Şablonlar derleme zamanı olanakları olduklarından, değer olarak kullanılan şablon parametresinin derleme zamanında hesaplanabilmesi şarttır. Bu yüzden, programın çalışması sırasında hesaplanan, örneğin girişten okunan bir değer kullanılamaz.
)

$(P
Bir örnek olarak, belirli sayıda köşeden oluşan şekilleri temsil eden yapılar tanımlayalım:
)

---
struct Üçgen {
    Nokta[3] köşeler;
// ...
}

struct Dörtgen {
    Nokta[4] köşeler;
// ...
}

struct Beşgen {
    Nokta[5] köşeler;
// ...
}
---

$(P
Örnek kısa olsun diye başka üyelerini göstermedim. Normalde, o türlerin başka üyelerinin ve işlevlerinin de bulunduğunu ve hepsinde tamamen aynı şekilde tanımlandıklarını varsayalım. Sonuçta, dizi uzunluğunu belirleyen $(I değer) dışında, o yapıların tanımları aynı olsun.
)

$(P
Değer şablon parametreleri böyle durumlarda yararlıdır. Yukarıdaki tanımlar yerine tek yapı şablonu tanımlanabilir. Yeni tanım genel amaçlı olduğu için, ismini de o şekillerin genel ismi olan $(I poligon) koyarak şöyle tanımlayabiliriz:
)

---
struct Poligon$(HILITE (size_t köşeAdedi)) {
    Nokta[köşeAdedi] köşeler;
// ...
}
---

$(P
O yapı şablonu parametre olarak $(C size_t) türünde ve $(C köşeAdedi) isminde bir şablon parametresi almaktadır. O parametre değeri yapının tanımında herhangi bir yerde kullanılabilir.
)

$(P
Artık o şablonu istediğimiz sayıda köşesi olan poligonları ifade etmek için kullanabiliriz:
)

---
    auto yüzKöşeli = Poligon!100();
---

$(P
Yine $(C alias)'tan yararlanarak kullanışlı isimler verebiliriz:
)

---
alias Üçgen = Poligon!3;
alias Dörtgen = Poligon!4;
alias Beşgen = Poligon!5;

// ...

    auto üçgen = Üçgen();
    auto dörtgen = Dörtgen();
    auto beşgen = Beşgen();
---

$(P
Yukarıdaki $(I değer) şablon parametresinin türü $(C size_t) idi. Değer derleme zamanında bilindiği sürece değer türü olarak bütün temel türler, yapılar, diziler, dizgiler, vs. kullanılabilir.
)

---
struct S {
    int i;
}

// Türü S yapısı olan değer şablon parametresi
void foo($(HILITE S s))() {
    // ...
}

void main() {
    // İşlev şablonunun S(42) hazır değeriyle kullanılması
    foo!(S(42))();
}
---

$(P
Başka bir örnek olarak, basit XML elemanları oluşturmakta kullanılan bir sınıf şablonu tasarlayalım. Bu basit XML tanımı, çok basitçe şu çıktıyı üretmek için kullanılsın:
)

$(UL
$(LI Önce $(C &lt;)&nbsp;$(C &gt;) karakterleri arasında elemanın ismi: $(C &lt;isim&gt;))
$(LI Sonra elemanın değeri)
$(LI En sonunda da $(C &lt;/)&nbsp;$(C &gt;) karakterleri arasında yine elemanın ismi: $(C &lt;/isim&gt;))
)

$(P
Örneğin değeri 42 olan bir elemanın $(C &lt;isim&gt;42&lt;/isim&gt;) şeklinde görünmesini isteyelim.
)

$(P
Eleman isimlerini bir sınıf şablonunun $(C string) türündeki bir değer parametresi olarak belirleyebiliriz:
)

---
$(CODE_NAME XmlElemanı)import std.string;

class XmlElemanı$(HILITE (string isim)) {
    double değer;

    this(double değer) {
        this.değer = değer;
    }

    override string toString() const {
        return format("<%s>%s</%s>", isim, değer, isim);
    }
}
---

$(P
Bu örnekteki şablon parametresi, şablonda kullanılan bir türle değil, bir $(C string) $(I değeriyle) ilgilidir. O $(C string)'in değeri de şablon içinde gereken her yerde kullanılabilir.
)

$(P
$(C alias)'tan yararlanarak kullanışlı tür isimleri de tanımlayarak:
)

---
$(CODE_XREF XmlElemanı)alias Konum = XmlElemanı!"konum";
alias Sıcaklık = XmlElemanı!"sıcaklık";
alias Ağırlık = XmlElemanı!"ağırlık";

void main() {
    Object[] elemanlar;

    elemanlar ~= new Konum(1);
    elemanlar ~= new Sıcaklık(23);
    elemanlar ~= new Ağırlık(78);

    writeln(elemanlar);
}
---

$(P
$(I Not: Ben bu örnekte kısa olsun diye ve nasıl olsa bütün sınıf sıradüzenlerinin en üstünde bulunduğu için bir $(C Object) dizisi kullandım. O sınıf şablonu aslında daha uygun bir arayüz sınıfından da türetilebilirdi.)
)

$(P
Yukarıdaki kodun çıktısı:
)

$(SHELL_SMALL
[&lt;konum&gt;1&lt;/konum&gt;, &lt;sıcaklık&gt;23&lt;/sıcaklık&gt;, &lt;ağırlık&gt;78&lt;/ağırlık&gt;]
)

$(P
Değer parametrelerinin de varsayılan değerleri olabilir. Örneğin, herhangi boyutlu bir uzaydaki noktaları temsil eden bir yapı tasarlayalım. Noktaların koordinat değerleri için kullanılan tür ve uzayın kaç boyutlu olduğu, şablon parametreleri ile belirlensin:
)

---
struct Konum(T, size_t boyut $(HILITE = 3)) {
    T[boyut] koordinatlar;
}
---

$(P
$(C boyut) parametresinin varsayılan bir değerinin bulunması, bu şablonun o parametre belirtilmeden de kullanılabilmesini sağlar:
)

---
    Konum!double merkez;    // üç boyutlu uzayda bir nokta
---

$(P
Gerektiğinde farklı bir değer de belirtilebilir:
)

---
    Konum!(int, 2) nokta;   // iki boyutlu düzlemde bir nokta
---

$(P
$(LINK2 /ders/d/parametre_serbestligi.html, Parametre Serbestliği bölümünde) $(I özel anahtar sözcüklerin) varsayılan parametre değeri olarak kullanıldıklarında farklı etkileri olduğunu görmüştük.
)

$(P
Benzer biçimde, varsayılan şablon parametre değeri olarak kullanıldıklarında şablonun tanımlandığı yerle değil, şablonun kullanıldığı yerle ilgili bilgi verirler:
)

---
import std.stdio;

void işlev(T,
           string işlevİsmi = $(HILITE __FUNCTION__),
           string dosya = $(HILITE __FILE__),
           size_t satır = $(HILITE __LINE__))(T parametre) {
    writefln("%s dosyasının %s numaralı satırındaki %s " ~
             "işlevi tarafından kullanılıyor.",
             dosya, satır, işlevİsmi);
}

void main() {
    işlev(42);    $(CODE_NOTE $(HILITE satır 15))
}
---

$(P
Yukarıdaki özel anahtar sözcükler şablonun tanımında geçtikleri halde şablonu kullanmakta olan $(C main()) işlevine işaret ederler:
)

$(SHELL
deneme.d dosyasının $(HILITE 15 numaralı satırındaki) deneme.$(HILITE main)
işlevi tarafından kullanılıyor.
)

$(P
$(C __FUNCTION__) anahtar sözcüğünü aşağıdaki işleç yükleme örneğinde de kullanacağız.
)

$(H6 $(IX this, şablon parametresi) Üye işlevler için $(C this) şablon parametreleri)

$(P
Üye işlevler de şablon olarak tanımlanabilirler. Üye işlev şablonlarının da tür ve değer parametreleri bulunabilir, ve normal işlev şablonlarından beklendiği gibi çalışırlar.
)

$(P
Ek olarak, üye işlev şablonlarının parametreleri $(C this) anahtar sözcüğü ile de tanımlanabilir. Bu durumda, o anahtar sözcükten sonra yazılan isim, o nesnenin $(C this) referansının türü haline gelir. ($(I Not: Burada, çoğunlukla kurucu işlevler içinde gördüğümüz $(C this.üye = değer) kullanımındaki $(C this) referansından, yani) nesnenin kendisini ifade eden $(I referanstan bahsediyoruz.))
)

---
struct BirYapı(T) {
    void birİşlev$(HILITE (this KendiTürüm))() const {
        writeln("Bu nesnenin türü: ", KendiTürüm.stringof);
    }
}
---

$(P
$(C KendiTürüm) şablon parametresi o üye işlevin işlemekte olduğu nesnenin asıl türüdür:
)

---
    auto m = BirYapı!int();
    auto c = const(BirYapı!int)();
    auto i = immutable(BirYapı!int)();

    m.birİşlev();
    c.birİşlev();
    i.birİşlev();
---

$(P
Çıktısı:
)

$(SHELL_SMALL
Bu nesnenin türü: BirYapı!int
Bu nesnenin türü: const(BirYapı!int)
Bu nesnenin türü: immutable(BirYapı!int)
)

$(P
Görüldüğü gibi, $(C KendiTürüm) hem $(C T)'nin bu kullanımda $(C int) olan karşılığını hem de $(C const) ve $(C immutable) gibi tür belirteçlerini içerir.
)

$(P
$(C this) şablon parametresi, şablon olmayan yapıların veya sınıfların üye işlevlerinde de kullanılabilir.
)

$(P
$(C this) şablon parametreleri özellikle iki bölüm sonra göreceğimiz $(I şablon katmalarında) yararlıdır. O bölümde bir örneğini göreceğiz.
)

$(H6 $(IX alias şablon parametresi) $(C alias) parametreleri)

$(P
$(C alias) şablon parametrelerine karşılık olarak D programlarında geçebilen bütün yasal isimler veya ifadeler kullanılabilir. Bu isimler yerel isimler, modül isimleri, başka şablon isimleri, vs. olabilirler. Tek koşul, o parametrenin şablon içindeki kullanımının o parametreye uygun olmasıdır.
)

$(P
Bu olanak, $(C filter) ve $(C map) gibi şablonların da işlemleri dışarıdan almalarını sağlayan olanaktır.
)

$(P
Örnek olarak, hangi yerel değişkeni değiştireceği kendisine bir $(C alias) parametre olarak bildirilen bir yapıya bakalım:
)

---
struct BirYapı($(HILITE alias değişken)) {
    void birİşlev(int değer) {
        değişken = değer;
    }
}
---

$(P
O yapının üye işlevi, $(C değişken) isminde bir değişkene bir atama yapmaktadır. O değişkenin programdaki hangi değişken olduğu; bu şablon tanımlandığı zaman değil, şablon kullanıldığı zaman belirlenir:
)

---
    int x = 1;
    int y = 2;

    auto nesne = BirYapı!$(HILITE x)();
    nesne.birİşlev(10);
    writeln("x: ", x, ", y: ", y);
---

$(P
Yapı şablonunun yukarıdaki kullanımında yerel $(C x) değişkeni belirtildiği için, $(C birİşlev) içindeki atama onu etkiler:
)

$(SHELL_SMALL
x: $(HILITE 10), y: 2
)

$(P
Öte yandan, $(C BirYapı!y) biçimindeki kullanımda $(C değişken) değişkeni $(C y) yerine geçerdi.
)

$(P
Başka bir örnek olarak, $(C filter) ve $(C map) gibi $(C alias) parametresini işlev olarak kullanan bir işlev şablonuna bakalım:
)

---
void çağıran(alias işlev)() {
    write("çağırıyorum: ");
    $(HILITE işlev());
}
---

$(P
$(C ()) parantezlerinden anlaşıldığı gibi, $(C çağıran) ismindeki işlev şablonu, kendisine verilen parametreyi bir işlev olarak kullanmaktadır. Ayrıca, parantezlerin içinin boş olmasından anlaşıldığı gibi, o işlev parametre göndermeden çağrılmaktadır.
)

$(P
Parametre almadıkları için o kullanıma uyan iki de işlev bulunduğunu varsayalım:
)

---
void birinci() {
    writeln("birinci");
}

void ikinci() {
    writeln("ikinci");
}
---

$(P
O işlevler, $(C çağıran) şablonu içindeki kullanıma uydukları için o şablonun $(C alias) parametresinin değeri olabilirler:
)

---
    çağıran!birinci();
    çağıran!ikinci();
---

$(P
Belirtilen işlevin çağrıldığını görürüz:
)

$(SHELL_SMALL
çağırıyorum: birinci
çağırıyorum: ikinci
)

$(P
$(C alias) şablon parametrelerini her çeşit şablonla kullanabilirsiniz. Önemli olan, o parametrenin şablon içindeki kullanıma uymasıdır. Örneğin, yukarıdaki $(C alias) parametresi yerine bir değişken kullanılması derleme hatasına neden olacaktır:
)

---
    int değişken;
    çağıran!değişken();        $(DERLEME_HATASI)
---

$(P
Aldığımız hata, $(C ()) karakterlerinden önce bir işlev beklendiğini, $(C int) türündeki $(C değişken)'in uygun olmadığını belirtir:
)

$(SHELL_SMALL
Error: $(HILITE function expected before ()), not değişken of type int
)

$(P
Her ne kadar işaretlediğim satır nedeniyle olsa da, derleme hatası aslında $(C çağıran) işlevinin içindeki $(C işlev()) satırı için verilir. Derleyicinin gözünde hatalı olan; şablona gönderilen parametre değil, o parametrenin şablondaki kullanılışıdır. Uygunsuz şablon parametrelerini önlemenin bir yolu, $(I şablon kısıtlamaları) tanımlamaktır. Bunu aşağıda göreceğiz.
)

$(P
Öte yandan, bir işlev gibi çağrılabilen her olanak bu örnekteki $(C alias) parametresi yerine kullanılabilir. Aşağıda hem $(C opCall()) işlecini yüklemiş olan bir sınıf ile hem de bir isimsiz işlev ile kullanımını görüyoruz:
)

---
class Sınıf {
    void opCall() {
        writeln("Sınıf.opCall çağrıldı.");
    }
}

// ...

    auto nesne = new Sınıf();
    çağıran!$(HILITE nesne)();

    çağıran!($(HILITE {) writeln("İsimsiz işlev çağrıldı."); $(HILITE }))();
---

$(P
Çıktısı:
)

$(SHELL
çağırıyorum: Sınıf.opCall çağrıldı.
çağırıyorum: İsimsiz işlev çağrıldı.
)

$(P
$(C alias) parametreleri de özellenebilirler. Ancak, özelleme söz dizimi diğer parametre çeşitlerinden farklıdır; özellenen tür $(C alias) ile parametre ismi arasına yazılır:
)

---
import std.stdio;

void foo(alias değişken)() {
    writefln("Genel tanım %s türündeki '%s' değişkeni için işliyor.",
             typeof(değişken).stringof, değişken.stringof);
}

void foo(alias $(HILITE int) i)() {
    writefln("int özellemesi '%s' değişkeni için işliyor.",
             i.stringof);
}

void foo(alias $(HILITE double) d)() {
    writefln("double özellemesi '%s' değişkeni için işliyor.",
             d.stringof);
}

void main() {
    string isim;
    foo!isim();

    int adet;
    foo!adet();

    double uzunluk;
    foo!uzunluk();
}
---

$(P
Asıl değişkenlerin isimlerinin de şablon içinde görülebildiklerine ayrıca dikkat edin:
)

$(SHELL
Genel tanım string türündeki 'isim' değişkeni için işliyor.
int özellemesi 'adet' değişkeni için işliyor.
double özellemesi 'uzunluk' değişkeni için işliyor.
)

$(H6 $(IX çokuzlu şablon parametresi) Çokuzlu parametreleri)

$(P
İşlevlerin belirsiz sayıda parametre alabildiklerini biliyoruz. Örneğin, $(C writeln) işlevini istediğimiz sayıda parametre ile çağırabiliriz. Bu tür işlevlerin nasıl tanımlandıklarını $(LINK2 /ders/d/parametre_serbestligi.html, Parametre Serbestliği bölümünde) görmüştük.
)

$(P
$(IX ..., şablon parametresi) $(IX belirsiz sayıda şablon parametresi) Aynı serbestlik şablon parametrelerinde de bulunur. Şablon parametrelerinin sayısını ve çeşitlerini serbest bırakmak şablon parametre listesinin en sonuna bir çokuzlu ismi ve $(C ...) karakterleri yazmak kadar basittir. İsmi belirtilen çokuzlu, şablon parametre değerlerini ifade eden bir $(C AliasSeq) gibi kullanılabilir.
)

$(P
Bunu parametreleri hakkında bilgi veren basit bir işlev şablonunda görelim:
)

---
$(CODE_NAME bilgiVer)void bilgiVer($(HILITE T...))(T parametreler) {
    // ...
}
---

$(P
Şablon parametresi olan $(C T...), $(C bilgiVer) işlev şablonunun belirsiz sayıda parametre ile çağrılabilmesini sağlar. Hem $(C T) hem de $(C parametreler) çokuzludur:
)

$(UL
$(LI $(C T), işlev parametre değerlerinin türlerinden oluşan çokuzludur.)
$(LI $(C parametreler), işlev parametre değerlerinden oluşan çokuzludur.)
)

$(P
İşlevin üç farklı türden parametre ile çağrıldığı duruma bakalım:
)

---
$(CODE_XREF bilgiVer)import std.stdio;

// ...

void main() {
    bilgiVer($(HILITE 1, "abc", 2.3));
}
---

$(P
Aşağıda $(C parametreler)'in $(C foreach) ile kullanımını görüyoruz:
)

---
void bilgiVer(T...)(T parametreler) {
    // 'parametreler' bir AliasSeq gibi kullanılır:
    foreach (i, parametre; $(HILITE parametreler)) {
        writefln("%s: %s türünde %s",
                 i, typeof(parametre).stringof, parametre);
    }
}
---

$(P
Çıktısı:
)

$(SHELL_SMALL
0: int türünde 1
1: string türünde abc
2: double türünde 2.3
)

$(P
Parametrelerin türleri $(C typeof(parametre)) yerine $(C T[i]) ile de edinilebilir.
)

$(P
İşlev şablonu parametre türlerinin derleyici tarafından çıkarsanabildiklerini biliyorsunuz. Yukarıdaki $(C bilgiVer()) çağrısı sırasında parametre değerlerine bakılarak onların türlerinin sırasıyla $(C int), $(C string), ve $(C double) oldukları derleyici tarafından çıkarsanmıştır.
)

$(P
Bazı durumlarda ise şablon parametrelerinin açıkça belirtilmeleri gerekebilir. Örneğin, $(C std.conv.to) şablonu hedef türünü açıkça belirtilmesi gereken bir şablon parametresi olarak alır:
)

---
    to!$(HILITE string)(42);
---

$(P
Şablon parametreleri açıkça belirtildiğinde o parametreler değer, tür, veya başka çeşitlerden karışık olabilirler. Öyle durumlarda her şablon parametresinin tür veya başka çeşitten olup olmadığının belirlenmesi ve şablon kodlarının buna uygun olarak yazılması gerekebilir. Şablon çeşitlerini ayırt etmenin yolu, parametreleri yine $(C AliasSeq) gibi kullanmaktır.
)

$(P
Bunun örneğini görmek için yapı tanımı üreten bir işlev tasarlayalım. Bu işlev belirtilen türlerde ve isimlerde üyeleri olan yapı tanımı içeren kaynak kod üretsin ve $(C string) olarak döndürsün. İlk olarak yapının ismi verildikten sonra üyelerin tür ve isimleri çiftler halinde belirtilsinler:
)

---
import std.stdio;

void $(CODE_DONT_TEST)main() {
    writeln(yapıTanımla!("Öğrenci",
                         string, "isim",
                         int, "numara",
                         int[], "notlar")());
}
---

$(P
Yukarıdaki programın çıktısı aşağıdaki kaynak kod olmalıdır:
)

$(SHELL
struct Öğrenci {
    string isim;
    int numara;
    int[] notlar;
}
)

$(P
$(I Not: $(C yapıTanımla) gibi kod üreten işlevlerin yararlarını $(LINK2 /ders/d/katmalar.html, daha sonraki bir bölümdeki) $(C mixin) anahtar sözcüğünü öğrenirken göreceğiz.)
)

$(P
O sonucu üreten şablon aşağıdaki gibi tanımlanabilir. Koddaki denetimlerde $(C is) ifadesinden de yararlanıldığına dikkat edin. Hatırlarsanız, $(C is&nbsp;(parametre)) ifadesi $(C parametre) geçerli bir tür olduğunda $(C true) üretiyordu:
)

---
import std.string;

string yapıTanımla(string isim, $(HILITE Üyeler)...)() {
    /* Üyeler tür ve isim olarak çiftler halinde
     * belirtilmelidir. Önce bunu denetleyelim. */
    static assert(($(HILITE Üyeler).length % 2) == 0,
                  "Üyeler çiftler halinde belirtilmedilir.");

    /* Önce yapı tanımının ilk satırını oluşturuyoruz. */
    string sonuç = "struct " ~ isim ~ "\n{\n";

    foreach (i, parametre; $(HILITE Üyeler)) {
        static if (i % 2) {
            /* Tek numaralı parametreler üye isimlerini
             * belirliyorlar. Onları hemen burada kullanmak
             * yerine aşağıdaki 'else' bölümünde Üyeler[i+1]
             * söz dizimiyle kullanacağız.
             *
             * Yine de üye isimlerinin string olarak
             * belirtildiklerini burada denetleyelim. */
            static assert(is (typeof(parametre) == string),
                          "Üye ismi " ~ parametre.stringof ~
                          " string değil.");

        } else {
            /* Bu durumda 'parametre' üyenin türünü
             * belirtiyor. Öncelikle bu parametrenin gerçekten
             * bir tür olduğunu denetleyelim. */
            static assert(is (parametre),
                          parametre.stringof ~ " tür değil.");

            /* Tür ve üye isimlerini kullanarak satırı
             * oluşturuyoruz.
             *
             * Not: Burada Üyeler[i] yerine 'parametre' de
             * yazabilirdik. */
            sonuç ~= format("    %s %s;\n",
                            $(HILITE Üyeler[i]).stringof, $(HILITE Üyeler[i+1]));
        }
    }

    /* Yapı tanımının kapama parantezi. */
    sonuç ~= "}";

    return sonuç;
}

import std.stdio;

void main() {
    writeln(yapıTanımla!("Öğrenci",
                         string, "isim",
                         int, "numara",
                         int[], "notlar")());
}
---

$(H5 $(IX typeof(this)) $(IX typeof(super)) $(IX typeof(return))$(C typeof(this)), $(C typeof(super)), ve $(C typeof(return)))

$(P
Şablonların genel tanımlar ve genel algoritmalar olmalarının bir etkisi, bazı tür isimlerinin yazımlarının güç veya olanaksız olmasıdır. Aşağıdaki üç özel $(C typeof) çeşidi böyle durumlarda yararlıdır. Her ne kadar bu bölümde tanıtılıyor olsalar da, bu olanaklar şablon olmayan kodlarda da geçerlidirler.
)

$(UL

$(LI $(C typeof(this)), yapının veya sınıfın $(C this) referansının türünü (yani, kendi tam türünü) verir. Bu olanak yapı veya sınıfın tanımı içinde olmak koşuluyla üye işlevler dışında da kullanılabilir.

---
struct Liste(T) {
    // T int olduğunda 'sonraki'nin türü Liste!int'tir
    typeof(this) *sonraki;
    // ...
}
---

)

$(LI $(C typeof(super)) bir sınıfın üst sınıfının türünü (yani, $(C super) referansının türünü) verir.

---
class ListeOrtak(T) {
    // ...
}

class Liste(T) : ListeOrtak!T {
    // T int olduğunda 'sonraki'nin türü ListeOrtak!int'tir
    typeof(super) *sonraki;
    // ...
}
---

)

$(LI $(C typeof(return)) bir işlevin dönüş türünü o işlev içerisindeyken verir.

$(P
Örneğin, yukarıdaki $(C hesapla()) işlevinin dönüş türünü $(C auto) yerine daha açıklayıcı olmak için $(C Büyüğü!(A, B)) olarak tanımlayabiliriz. (Daha açık olmanın bir yararı, işlev açıklamalarının en azından bir bölümünün gereksiz hale gelmesidir.)
)

---
$(HILITE Büyüğü!(A, B)) hesapla(A, B)(A a, B b) {
    // ...
}
---

$(P
$(C typeof(return)), dönüş türünün işlevin içinde tekrarlanmasını önler:
)

---
Büyüğü!(A, B) hesapla(A, B)(A a, B b) {
    $(HILITE typeof(return)) sonuç;    // Ya A ya da B
    // ...
    return sonuç;
}
---

)

)

$(H5 Şablon özellemeleri)

$(P
Özellemeleri de $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) görmüştük. Aşağıdaki $(I meta programlama) başlığında da özelleme örnekleri göreceksiniz.
)

$(P
Tür parametrelerinde olduğu gibi, başka çeşit şablon parametreleri de özellenebilir. Aşağıdaki şablonun hem genel hem de 0 değeri için özel tanımı görülüyor:
)

---
void birİşlev(int birDeğer)() {
    // ... genel tanımı ...
}

void birİşlev(int birDeğer $(HILITE : 0))() {
    // ... sıfıra özel tanımı ...
}
---

$(H5 $(IX meta programlama) Meta programlama)

$(P
Kod üretme ile ilgili olduklarından şablonlar diğer D olanaklarından daha üst düzey programlama araçları olarak kabul edilirler. Şablonlar bir anlamda kod oluşturan kodlardır. Kodların daha üst düzey kodlarla oluşturulmaları kavramına $(I meta programlama) denir.
)

$(P
Şablonların derleme zamanı olanakları olmaları normalde çalışma zamanında yapılan işlemlerin derleme zamanına taşınmalarına olanak verir. ($(I Not: Aynı amaçla) Derleme Zamanında İşlev İşletme (CTFE) $(I olanağı da kullanılabilir. Bu konuyu daha sonraki bir bölümde göreceğiz.))
)

$(P
$(IX özyineleme) Şablonların bu amaçla derleme zamanında $(I işletilmeleri), çoğunlukla özyineleme üzerine kuruludur.
)

$(P
Bunun bir örneğini görmek için 0'dan başlayarak belirli bir sayıya kadar olan bütün sayıların toplamını hesaplayan normal bir işlev düşünelim. Bu işlev, parametre olarak örneğin 4 aldığında 0+1+2+3+4'ün toplamını döndürsün:
)

---
int topla(int sonDeğer) {
    int sonuç = 0;

    foreach (değer; 0 .. sonDeğer + 1) {
        sonuç += değer;
    }

    return sonuç;
}
---

$(P
Aynı işlevi özyinelemeli olarak da yazabiliriz:
)

---
int topla(int sonDeğer) {
    return (sonDeğer == 0
            ? sonDeğer
            : sonDeğer + $(HILITE topla)(sonDeğer - 1));
}
---

$(P
Özyinelemeli işlev kendi düzeyindeki değeri bir önceki hesaba eklemektedir. İşlevde 0 değerinin özel olarak kullanıldığını görüyorsunuz; özyineleme onun sayesinde sonlanmaktadır.
)

$(P
İşlevlerin normalde çalışma zamanı olanakları olduklarını biliyoruz. $(C topla)'yı çalışma zamanında gerektikçe çağırabilir ve sonucunu kullanabiliriz:
)

---
    writeln(topla(4));
---

$(P
Aynı sonucun yalnızca derleme zamanında gerektiği durumlarda ise, o hesap bir işlev şablonuyla da gerçekleştirilebilir. Yapılması gereken; değerin işlev parametresi olarak değil, şablon parametresi olarak kullanılmasıdır:
)

---
// Uyarı: Bu kod yanlıştır
int topla($(HILITE int sonDeğer))() {
    return (sonDeğer == 0
            ? sonDeğer
            : sonDeğer + topla$(HILITE !(sonDeğer - 1))());
}
---

$(P
Bu şablon da hesap sırasında kendisinden yararlanmaktadır. Kendisini, $(C sonDeğer)'in bir eksiği ile kullanmakta ve hesabı yine özyinelemeli olarak elde etmeye çalışmaktadır. Ne yazık ki o kod yazıldığı şekilde çalışamaz.
)

$(P
Derleyici, $(C ?:) işlecini çalışma zamanında işleteceği için, yukarıdaki özyineleme derleme zamanında sonlanamaz:
)

---
    writeln(topla!4());    $(DERLEME_HATASI)
---

$(P
Derleyici, aynı şablonun sonsuz kere dallandığını anlar ve bir hata ile sonlanır:
)

$(SHELL_SMALL
Error: template instance deneme.topla!($(HILITE -296)) recursive expansion
)

$(P
Şablon parametresi olarak verdiğimiz 4'ten geriye doğru -296'ya kadar saydığına bakılırsa, derleyici şablonların özyineleme sayısını 300 ile sınırlamaktadır.
)

$(P
Meta programlamada özyinelemeyi kırmanın yolu, şablon özellemeleri kullanmaktır. Bu durumda, aynı şablonu 0 değeri için özelleyebilir ve özyinelemenin kırılmasını bu sayede sağlayabiliriz:
)

---
$(CODE_NAME topla)// Genel tanım
int topla(int sonDeğer)() {
    return sonDeğer + topla!(sonDeğer - 1)();
}

// Sıfır değeri için özellemesi
int topla(int sonDeğer $(HILITE : 0))() {
    return 0;
}
---

$(P
Derleyici, $(C sonDeğer)'in sıfırdan farklı değerleri için hep genel tanımı kullanır ve en sonunda 0 değeri için özel tanıma geçer. O tanım da basitçe 0 değerini döndürdüğü için özyineleme sonlanmış olur.
)

$(P
O işlev şablonunu şöyle bir programla deneyebiliriz:
)

---
$(CODE_XREF topla)import std.stdio;

void main() {
    writeln(topla!4());
}
---

$(P
Şimdi hatasız olarak derlenecek ve 4+3+2+1+0'ın toplamını üretecektir:
)

$(SHELL_SMALL
10
)

$(P
Burada dikkatinizi çekmek istediğim önemli nokta, $(C topla!4()) işlevinin bütünüyle derleme zamanında işletiliyor olmasıdır. Sonuçta derleyicinin ürettiği kod, $(C writeln)'e doğrudan 10 hazır değerini göndermenin eşdeğeridir:
)

---
    writeln(10);         // topla!4()'lü kodun eşdeğeri
---

$(P
Derleyicinin ürettiği kod, 10 hazır değerini doğrudan programa yazmak kadar hızlı ve basittir. O 10 hazır değeri, yine de 4+3+2+1+0 hesabının sonucu olarak bulunmaktadır; ancak o hesap, şablonların özyinelemeli olarak kullanılmalarının sonucunda derleme zamanında işletilmektedir.
)

$(P
Burada görüldüğü gibi, meta programlamanın yararlarından birisi, şablonların derleme zamanında işletilmelerinden yararlanarak normalde çalışma zamanında yapılmasına alıştığımız hesapların derleme zamanına taşınabilmesidir.
)

$(P
Yukarıda da söylediğim gibi, daha sonraki bir bölümde göstereceğim CTFE olanağı bazı meta programlama yöntemlerini D'de gereksiz hale getirir.
)


$(H5 $(IX çok şekillilik, derleme zamanı) $(IX derleme zamanı çok şekilliliği) Derleme zamanı çok şekilliliği)

$(P
Bu kavram, İngilizce'de "compile time polymorphism" olarak geçer.
)

$(P
Nesne yönelimli programlamada çok şekilliliğin sınıf türetme ile sağlandığını biliyorsunuz. Örneğin bir işlev parametresinin bir arayüz olması, o parametre yerine o arayüzden türemiş her sınıfın kullanılabileceği anlamına gelir.
)

$(P
Daha önce gördüğümüz bir örneği hatırlayalım:
)

---
import std.stdio;

interface SesliAlet {
    string ses();
}

class Keman : SesliAlet {
    string ses() {
        return "♩♪♪";
    }
}

class Çan : SesliAlet {
    string ses() {
        return "çın";
    }
}

void sesliAletKullan($(HILITE SesliAlet alet)) {
    // ... bazı işlemler ...
    writeln(alet.ses());
    // ... başka işlemler ...
}

void main() {
    sesliAletKullan(new Keman);
    sesliAletKullan(new Çan);
}
---

$(P
Yukarıdaki $(C sesliAletKullan) işlevi çok şekillilikten yararlanmaktadır. Parametresi $(C SesliAlet) olduğu için, ondan türemiş olan bütün türlerle kullanılabilir.
)

$(P
Yukarıdaki son cümlede geçen $(I bütün türlerle kullanılabilme) kavramını şablonlardan da tanıyoruz. Böyle düşününce, şablonların da bir çeşit çok şekillilik sunduklarını görürüz. Şablonlar bütünüyle derleyicinin derleme zamanındaki kod üretmesiyle ilgili olduklarından, şablonların sundukları çok şekilliliğe $(I derleme zamanı çok şekilliliği) denir.
)

$(P
Doğrusu, her iki çok şekillilik de $(I bütün) türlerle kullanılamaz. Her ikisinde de türlerin uymaları gereken bazı koşullar vardır.
)

$(P
Çalışma zamanı çok şekilliliği, belirli bir arayüzden türeme ile kısıtlıdır.
)

$(P
Derleme zamanı çok şekilliliği ise şablon içindeki kullanıma uyma ile kısıtlıdır. Şablon parametresi, şablon içindeki kullanımda derleme hatasına neden olmuyorsa, o şablonla kullanılabilir. ($(I Not: Eğer tanımlanmışsa, şablon kısıtlamalarına da uyması gerekir. Şablon kısıtlamalarını biraz aşağıda anlatacağım.))
)

$(P
Örneğin, yukarıdaki $(C sesliAletKullan) işlevi bir şablon olarak yazıldığında, $(C ses) üye işlevi bulunan bütün türlerle kullanılabilir:
)

---
void sesliAletKullan$(HILITE (T))(T alet) {
    // ... bazı işlemler ...
    writeln(alet.ses());
    // ... başka işlemler ...
}

class Araba {
    string ses() {
        return "düt düt";
    }
}

// ...

    sesliAletKullan(new Keman);
    sesliAletKullan(new Çan);
    sesliAletKullan(new Araba);
---

$(P
Yukarıdaki şablon, diğerleriyle kalıtım ilişkisi bulunmayan $(C Araba) türü ile de kullanılabilmiştir.
)

$(P
$(IX ördek tipleme) Derleme zamanı çok şekilliliği $(I ördek tipleme) olarak da bilinir. Ördek tipleme, asıl türü değil, davranışı ön plana çıkartan mizahi bir terimdir.
)

$(H5 $(IX kod şişmesi) Kod şişmesi)

$(P
Şablonlar kod üretme ile ilgilidirler. Derleyici, şablonun farklı parametrelerle her kullanımı için farklı kod üretir.
)

$(P
Örneğin yukarıda en son yazdığımız $(C sesliAletKullan) işlev şablonu, programda kullanıldığı her tür için ayrı ayrı üretilir ve derlenir. Programda yüz farklı tür ile çağrıldığını düşünürsek; derleyici o işlev şablonunun tanımını, her tür için ayrı ayrı, toplam yüz kere oluşturacaktır.
)

$(P
Programın boyutunun büyümesine neden olduğu için bu etkiye $(I kod şişmesi) (code bloat) denir. Çoğu programda sorun oluşturmasa da, şablonların bu özelliğinin akılda tutulması gerekir.
)

$(P
Öte yandan, $(C sesliAletKullan) işlevinin ilk yazdığımız $(C SesliAlet) alan tanımında, yani şablon olmayan tanımında, böyle bir kod tekrarı yoktur. Derleyici, o işlevi bir kere derler ve her $(C SesliAlet) türü için aynı işlevi çağırır. İşlev tek olduğu halde her hayvanın kendisine özel olarak davranabilmesi, derleyici tarafından işlev göstergeleriyle sağlanır. Derleyici her tür için farklı bir işlev göstergesi kullanır ve böylece her tür için farklı üye işlev çağrılır. Çalışma zamanında çok küçük bir hız kaybına yol açsa da, işlev göstergeleri kullanmanın çoğu programda önemi yoktur ve zaten bu çözümü sunan en hızlı gerçekleştirmedir.
)

$(P
Burada sözünü ettiğim hız etkilerini tasarımlarınızda fazla ön planda tutmayın. Program boyutunun artması da, çalışma zamanında fazladan işlemler yapılması da hızı düşürecektir. Belirli bir programda hangisinin etkisinin daha fazla olduğuna ancak o program denenerek karar verilebilir.
)

$(H5 $(IX kısıtlama, şablon) $(IX şablon kısıtlaması) Şablon kısıtlamaları)

$(P
Şablonların her tür ve değerdeki şablon parametresi ile çağrılabiliyor olmalarının getirdiği bir sorun vardır. Uyumsuz bir parametre kullanıldığında, bu uyumsuzluk ancak şablonun kendi kodları derlenirken farkedilebilir. Bu yüzden, derleme hatasında belirtilen satır numarası, şablon bloğuna işaret eder.
)

$(P
Yukarıdaki $(C sesliAletKullan) şablonunu $(C ses) isminde üye işlevi bulunmayan bir türle çağıralım:
)

---
class Fincan {
    // ... ses() işlevi yok ...
}

// ...

    sesliAletKullan(new Fincan);   // ← uyumsuz bir tür
---

$(P
Oradaki hata, şablonun uyumsuz bir türle çağrılıyor olmasıdır. Oysa derleme hatası, şablon içindeki kullanıma işaret eder:
)

---
void sesliAletKullan(T)(T alet) {
    // ... bazı işlemler ...
    writeln(alet.ses());          $(DERLEME_HATASI)
    // ... başka işlemler ...
}
---

$(P
Bunun bir sakıncası, belki de bir kütüphane modülünde tanımlı olan bir şablona işaret edilmesinin, hatanın o kütüphanede olduğu yanılgısını uyandırabileceğidir. Daha önemlisi, asıl hatanın hangi satırda olduğunun hiç bildirilmiyor olmasıdır.
)

$(P
Böyle bir sorunun arayüzlerde bulunmadığına dikkat edin. Parametre olarak arayüz alacak şekilde yazılmış olan bir işlev, ancak o arayüzden türemiş olan türlerle çağrılabilir. Türeyen her tür arayüzün işlevlerini gerçekleştirmek zorunda olduğu için, işlevin uyumsuz bir türle çağrılması olanaksızdır. O durumda derleme hatası, işlevi uygunsuz türle çağıran satıra işaret eder.
)

$(P
Şablonların yalnızca belirli koşulları sağlayan türlerle kullanılmaları şablon kısıtlamaları ile sağlanır. Şablon kısıtlamaları, şablon bloğunun hemen öncesine yazılan $(C if) deyiminin içindeki mantıksal ifadelerdir:
)

---
void birŞablon(T)()
        if (/* ... kısıtlama koşulu ... */) {
    // ... şablonun tanımı ...
}
---

$(P
Derleyici bu şablon tanımını ancak kısıtlama koşulu $(C true) olduğunda göze alır. Koşulun $(C false) olduğu durumda ise bu şablon tanımını gözardı eder.
)

$(P
Şablonlar derleme zamanı olanakları olduklarından şablon kısıtlamaları da derleme zamanında işletilirler. Bu yüzden, $(LINK2 /ders/d/is_ifadesi.html, $(C is) İfadesi bölümünde) gördüğümüz ve derleme zamanında işletildiğini öğrendiğimiz $(C is) ifadesi ile de çok kullanılırlar. Bunun örneklerini aşağıda göstereceğim.
)

$(H6 $(IX tek üyeli çokuzlu parametre yöntemi) $(IX çokuzlu şablon parametresi, tek üye) Tek üyeli çokuzlu parametre yöntemi)

$(P
Bazen tek şablon parametresi gerekebilir ama o parametrenin tür, değer, veya $(C alias) çeşidinden olabilmesi istenir. Bunu sağlamanın bir yolu, çokuzlu çeşidinde parametre kullanmak ama çokuzlunun uzunluğunu bir şablon kısıtlaması ile tek olarak belirlemektir:
)

---
template birŞablon(T...)
        $(HILITE if (T.length == 1)) {
    static if (is ($(HILITE T[0]))) {
        // Şablonun tek parametresi bir türmüş
        enum bool birŞablon = /* ... */;

    } else {
        // Şablonun tek parametresi tür değilmiş
        enum bool birŞablon = /* ... */;
    }
}
---

$(P
Daha ileride göreceğimiz $(C std.traits) modülündeki bazı şablonlar bu yöntemden yararlanır.
)

$(H6 $(IX isimli şablon kısıtlaması) İsimli kısıtlama yöntemi)

$(P
Şablon kısıtlamaları bazı durumlarda yukarıdakinden çok daha karmaşık olabilirler. Bunun üstesinden gelmenin bir yolu, benim $(I isimli kısıtlama) olarak adlandırdığım bir yöntemdir. Bu yöntem D'nin dört olanağından yararlanarak kısıtlamaya anlaşılır bir isim verir. Bu dört olanak; isimsiz işlev, $(C typeof), $(C is) ifadesi, ve tek tanım içeren şablonlardır.
)

$(P
Bu yöntemi burada daha çok bir kalıp olarak göstereceğim ve her ayrıntısına girmemeye çalışacağım.
)

$(P
Parametresini belirli şekilde kullanan bir işlev şablonu olsun:
)

---
void kullan(T)(T nesne) {
    // ...
    nesne.hazırlan();
    // ...
    nesne.uç(42);
    // ...
    nesne.kon();
    // ...
}
---

$(P
Şablon içindeki kullanımından anlaşıldığı gibi, bu şablonun kullanıldığı türlerin $(C hazırlan), $(C uç), ve $(C kon) isminde üç üye işlevinin bulunması gerekir (UFCS olanağı sayesinde normal işlevler de olabilirler.) O işlevlerden $(C uç)'un ayrıca $(C int) türünde bir de parametresi olmalıdır.
)

$(P
Bu kısıtlamayı $(C is) ve $(C typeof) ifadelerinden yararlanarak şöyle yazabiliriz:
)

---
void kullan(T)(T nesne)
        if (is (typeof(nesne.hazırlan())) &&
            is (typeof(nesne.uç(1))) &&
            is (typeof(nesne.kon()))) {
    // ...
}
---

$(P
O koşulun anlamını aşağıda daha ayrıntılı olarak göreceğiz. Şimdilik $(C is&nbsp;(typeof(nesne.hazırlan()))) kullanımını bir kalıp olarak $(I eğer o tür $(C nesne.hazırlan()) çağrısını destekliyorsa) anlamında kabul edebilirsiniz. İşleve $(C is&nbsp;(typeof(nesne.uç(1)))) biçiminde parametre verildiğinde ise, $(I o işlev $(C int) türünde parametre de alıyorsa) diye kabul edebilirsiniz.
)

$(P
Yukarıdaki gibi bir kısıtlama istendiği gibi çalışıyor olsa da, her zaman için tam açık olmayabilir. Onun yerine, o şablon kısıtlamasının ne anlama geldiğini daha iyi açıklayan bir isim verilebilir:
)

---
void kullan(T)(T nesne)
        if (uçabilir_mi!T) {     // ← isimli kısıtlama
    // ...
}
---

$(P
Bu kısıtlama bir öncekinden daha açıktır. Bu şablonun $(I uçabilen) türlerle çalıştığını okunaklı bir şekilde belgeler.
)

$(P
Yukarıdaki gibi isimli kısıtlamalar şu kalıba uygun olarak tanımlanırlar:
)

---
template uçabilir_mi(T) {
    enum uçabilir_mi = is (typeof(
    {
        T uçan;
        uçan.hazırlan();   // uçmaya hazırlanabilmeli
        uçan.uç(1);        // belirli mesafe uçabilmeli
        uçan.kon();        // istendiğinde konabilmeli
    }()));
}
---

$(P
O yöntemde kullanılan D olanaklarını ve birbirleriyle nasıl etkileştiklerini çok kısaca göstermek istiyorum:
)

---
template uçabilir_mi(T) {
    //      (6)        (5)  (4)
    enum uçabilir_mi = is (typeof(
    $(HILITE {) // (1)
        T uçan;          // (2)
        uçan.hazırlan();
        uçan.uç(1);
        uçan.kon();
 // (3)
    $(HILITE })()));
}
---

$(OL

$(LI $(B İsimsiz işlev:) İsimsiz işlevleri $(LINK2 /ders/d/kapamalar.html, İşlev Göstergeleri, İsimsiz İşlevler, ve Temsilciler bölümünde) görmüştük. Yukarıda sarıyla işaretlenmiş olan blok parantezleri isimsiz bir işlev tanımlar.
)

$(LI $(B İşlev bloğu:) İşlev bloğu, kısıtlaması tanımlanmakta olan türü asıl şablonda kullanıldığı gibi kullanır. Yukarıdaki blokta önce bu türden bir nesne oluşturulmakta ve o türün sahip olması gereken üç üye işlevi çağrılmaktadır. ($(I Not: Bu kodlar $(C typeof) tarafından kullanılırlar ama hiçbir zaman işletilmezler.))
)

$(LI $(B İşlevin işletilmesi:) Bir işlevin sonuna yazılan $(C ()) parantezleri normalde o işlevi işletir. Ancak, yukarıdaki işletme bir $(C typeof) içinde olduğundan bu işlev hiçbir zaman işletilmez. (Bu, bir sonraki maddede açıklanıyor.))

$(LI $(IX typeof) $(B $(C typeof) ifadesi:) $(C typeof), şimdiye kadarki örneklerde çok kullandığımız gibi, kendisine verilen ifadenin türünü üretir.

$(P
$(C typeof)'un önemli bir özelliği, türünü ürettiği ifadeyi işletmemesidir. $(C typeof), bir ifadenin $(I eğer işletilse) ne türden bir değer üreteceğini bildirir:
)

---
    int i = 42;
    typeof(++i) j;    // 'int j;' yazmakla aynı anlamdadır

    assert(i == 42);  // ++i işletilmemiştir
---

$(P
Yukarıdaki $(C assert)'ten de anlaşıldığı gibi, $(C ++i) ifadesi işletilmemiştir. $(C typeof), yalnızca o ifadenin türünü üretmiş ve böylece $(C j) de $(C int) olarak tanımlanmıştır.
)

$(P
Eğer $(C typeof)'a verilen ifadenin geçerli bir türü yoksa, $(C typeof) $(C void) bile olmayan geçersiz bir tür döndürür.
)

$(P
Eğer $(C uçabilir_mi) şablonuna gönderilen tür, o isimsiz işlev içindeki kodlarda gösterildiği gibi derlenebiliyorsa, $(C typeof) geçerli bir tür üretir. Eğer o tür işlev içindeki kodlardaki gibi derlenemiyorsa, $(C typeof) geçersiz bir tür döndürür.
)

)

$(LI $(B $(C is) ifadesi:) $(LINK2 /ders/d/is_ifadesi.html, $(C is) İfadesi bölümünde) $(C is) ifadesinin birden fazla kullanımını görmüştük. Buradaki $(C is&nbsp;($(I Tür))) şeklindeki kullanımı, kendisine verilen türün anlamlı olduğu durumda $(C true) değerini üretir:

---
    int i;
    writeln(is (typeof(i)));                  // true
    writeln(is (typeof(varOlmayanBirİsim)));  // false
---

$(P
Yukarıdaki ikinci ifadede bilinmeyen bir isim kullanıldığı halde derleyici hata vermez. Programın çıktısı ikinci satır için $(C false) değerini içerir:
)

$(SHELL_SMALL
true
false
)

$(P
Bunun nedeni, $(C typeof)'un ikinci kullanım için geçersiz bir tür üretmiş olmasıdır.
)

)

$(LI $(B Tek tanım içeren şablon:) Daha yukarıda anlatıldığı gibi, $(C uçabilir_mi) şablonunun içinde tek tanım bulunduğundan ve o tanımın ismi şablonun ismiyle aynı olduğundan; $(C uçabilir_mi) şablonu, içerdiği $(C uçabilir_mi) $(C enum) sabit değeri yerine geçer.
)

)

$(P
Sonuçta, yukarıdaki $(C kullan) işlev şablonu bütün bu olanaklar sayesinde isimli bir kısıtlama edinmiş olur:
)

---
void kullan(T)(T nesne)
        if (uçabilir_mi!T) {
    // ...
}
---

$(P
O şablonu birisi uyumlu, diğeri uyumsuz iki türle çağırmayı deneyelim:
)

---
// Şablondaki kullanıma uyan bir tür
class ModelUçak {
    void hazırlan() {
    }

    void uç(int mesafe) {
    }

    void kon() {
    }
}

// Şablondaki kullanıma uymayan bir tür
class Güvercin {
    void uç(int mesafe) {
    }
}

// ...

    kullan(new ModelUçak);      // ← derlenir
    kullan(new Güvercin);       $(DERLEME_HATASI)
---

$(P
İsimli veya isimsiz, bir şablon kısıtlaması tanımlanmış olduğundan, bu derleme hatası artık şablonun içine değil şablonun uyumsuz türle kullanıldığı satıra işaret eder.
)

$(H5 $(IX yükleme, işleç) $(IX çok boyutlu işleç yükleme) $(IX işleç yükleme, çok boyutlu) Şablonların çok boyutlu işleç yüklemedeki kullanımı)

$(P
$(C opDollar), $(C opIndex), ve $(C opSlice) işlevlerinin eleman erişimi ve dilimleme amacıyla kullanıldıklarını $(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme bölümünde) görmüştük. Bu işlevler o bölümdeki gibi $(I tek boyutlu) kullanımlarında aşağıdaki görevleri üstlenirler:
)

$(UL

$(LI $(C opDollar): Topluluktaki eleman adedini döndürür.)

$(LI $(C opSlice): Topluluğun ya bütün elemanlarını ya da bir bölümünü ifade eden aralık nesnesi döndürür.)

$(LI $(C opIndex): Belirtilen elemana erişim sağlar.)

)

$(P
O işlevlerin şablon olarak yüklenebilen çeşitleri de vardır. Bu işlev şablonlarının anlamları yukarıdakilerden farklıdır. Özellikle $(C opSlice)'ın görevinin $(C opIndex) tarafından üstlenilmiş olduğuna dikkat edin:
)

$(UL

$(LI $(IX opDollar şablonu) $(C opDollar) şablonu: Topluluğun belirli bir boyutunun uzunluğunu döndürür. Hangi boyutun uzunluğunun döndürüleceği şablon parametresinden anlaşılır:

---
    size_t opDollar$(HILITE (size_t boyut))() const {
        // ...
    }
---

)

$(LI $(IX opSlice şablonu) $(C opSlice) şablonu: Dilimi belirleyen sayı aralığı bilgisini döndürür. (Örneğin, $(C dizi[baş..son]) yazımındaki $(C baş) ve $(C son) değerleri.) Bu bilgi $(C Tuple!(size_t, size_t)) veya eşdeğeri bir tür olarak döndürülebilir. Aralığın hangi boyutla ilgili olduğu şablon parametresinden anlaşılır:

---
    Tuple!(size_t, size_t) opSlice$(HILITE (size_t boyut))(size_t baş,
                                                 size_t son) {
        return tuple(baş, son);
    }
---

)

$(LI $(IX opIndex şablonu) $(C opIndex) şablonu: Belirtilen alt topluluğu ifade eden bir aralık döndürür. Aralığın sınırları şablonun çokuzlu parametrelerinden anlaşılır:

---
    Aralık opIndex$(HILITE (A...))(A parametreler) {
        // ...
    }
---

)

)

$(P
$(IX opIndexAssign şablonu) $(IX opIndexOpAssign şablonu) $(C opIndexAssign) ve $(C opIndexOpAssign)'ın da şablon çeşitleri vardır. Bunlar da belirli bir alt topluluktaki elemanlar üzerinde işlerler.
)

$(P
Çok boyutlu işleçleri tanımlayan türler aşağıdaki gibi çok boyutlu erişim ve dilimleme söz dizimlerinde kullanılabilirler:
)

---
            // İndekslerle belirlenen alt topluluktaki
            // elemanların değerlerini 42 yapar:
            m[a, b..c, $-1, d..e] = 42;
//            ↑   ↑     ↑    ↑
// boyutlar:  0   1     2    3
---

$(P
Öyle bir ifade görüldüğünde önce $(C $) karakterleri için $(C opDollar) ve konum aralıkları için $(C opSlice) perde arkasında otomatik olarak çağrılır. Elde edilen uzunluk ve aralık bilgileri yine otomatik olarak $(C opIndexAssign)'a parametre olarak geçirilir. Sonuçta, yukarıdaki ifade yerine aşağıdaki ifade işletilmiş olur (boyut değerleri sarı ile işaretli):
)

---
    // Üsttekinin eşdeğeri:
    m.opIndexAssign(
        42,                    $(CODE_NOTE atanan değer)
        a,                     $(CODE_NOTE sıfırıncı boyutun parametresi)
        m.opSlice!$(HILITE 1)(b, c),     $(CODE_NOTE birinci boyutun parametresi)
        m.opDollar!$(HILITE 2)() - 1,    $(CODE_NOTE ikinci boyutun parametresi)
        m.opSlice!$(HILITE 3)(d, e));    $(CODE_NOTE üçüncü boyutun parametresi)
---

$(P
Sonuçta, $(C opIndexAssign) işlemde kullanacağı alt aralığı çokuzlu şablon parametrelerinin türlerine ve değerlerine bakarak belirler.
)

$(H6 İşleç yükleme örneği)

$(P
Aşağıdaki $(C Matris) türü bu işleçlerin nasıl tanımlandıklarının bir örneğini içeriyor.
)

$(P
Bu örnek çok daha hızlı işleyecek biçimde de gerçekleştirilebilir. Örneğin, aşağıdaki kodun tek elemana $(C m[i, j]) biçiminde erişirken bile $(I tek elemanlı bir alt matris) oluşturması gereksiz kabul edilebilir.
)

$(P
Ek olarak, işlev başlarındaki $(C writeln(__FUNCTION__)) ifadelerinin kodun işlevselliğiyle bir ilgisi bulunmuyor. Onlar yalnızca perde arkasında hangi işlevlerin hangi sırada çağrıldıklarını göstermek amacıyla eklenmişlerdir.
)

$(P
Boyut değerlerini denetlemek için şablon kısıtlamalarından yararlanıldığına da dikkat edin.
)

---
import std.stdio;
import std.format;
import std.string;

/* İki boyutlu bir int dizisi gibi işler. */
struct Matris {
private:

    int[][] satırlar;

    /* İndekslerle belirlenen satır ve sütun aralığı bilgisini
     * bir araya getirir. */
    struct Aralık {
        size_t baş;
        size_t son;
    }

    /* Satır ve sütun aralıklarıyla belirlenen alt matrisi
     * döndürür. */
    Matris altMatris(Aralık satırAralığı, Aralık sütunAralığı) {
        writeln(__FUNCTION__);

        int[][] dilimler;

        foreach (satır; satırlar[satırAralığı.baş ..
                                 satırAralığı.son]) {

            dilimler ~= satır[sütunAralığı.baş ..
                              sütunAralığı.son];
        }

        return Matris(dilimler);
    }

public:

    this(size_t yükseklik, size_t genişlik) {
        writeln(__FUNCTION__);

        satırlar = new int[][](yükseklik, genişlik);
    }

    this(int[][] satırlar) {
        writeln(__FUNCTION__);

        this.satırlar = satırlar;
    }

    void toString(void delegate(const(char)[]) hedef) const {
        formattedWrite(hedef, "%(%(%5s %)\n%)", satırlar);
    }

    /* Belirtilen değeri matrisin bütün elemanlarına atar. */
    Matris opAssign(int değer) {
        writeln(__FUNCTION__);

        foreach (satır; satırlar) {
            satır[] = değer;
        }

        return this;
    }

    /* Belirtilen işleci ve değeri her elemana uygular ve
     * sonucu o elemana atar. */
    Matris opOpAssign(string işleç)(int değer) {
        writeln(__FUNCTION__);

        foreach (satır; satırlar) {
            mixin ("satır[] " ~ işleç ~ "= değer;");
        }

        return this;
    }

    /* Belirtilen boyutun uzunluğunu döndürür. */
    size_t opDollar(size_t boyut)() const
            if (boyut <= 1) {
        writeln(__FUNCTION__);

        static if (boyut == 0) {
            /* Sıfırıncı boyutun uzunluğu isteniyor;
             * 'satırlar' dizisinin uzunluğudur. */
            return satırlar.length;

        } else {
            /* Birinci boyutun uzunluğu isteniyor; 'satırlar'
             * dizisinin elemanlarının uzunluğudur. */
            return satırlar.length ? satırlar[0].length : 0;
        }
    }

    /* 'baş' ve 'son' ile belirlenen aralığı ifade eden bir
     * nesne döndürür.
     *
     * Not: Bu gerçekleştirmede 'boyut' parametresi
     * kullanılmıyor olsa da, bu bilgi başka bir tür için
     * yararlı olabilir. */
    Aralık opSlice(size_t boyut)(size_t baş, size_t son)
            if (boyut <= 1) {
        writeln(__FUNCTION__);

        return Aralık(baş, son);
    }

    /* Parametrelerle belirlenen alt matrisi döndürür. */
    Matris opIndex(A...)(A parametreler)
            if (A.length <= 2) {
        writeln(__FUNCTION__);

        /* Bütün elemanları temsil eden aralıklarla
         * başlıyoruz. Böylece opIndex'in parametresiz
         * kullanımında bütün elemanlar kapsanırlar. */
        Aralık[2] aralıklar = [ Aralık(0, opDollar!0),
                                Aralık(0, opDollar!1) ];

        foreach (boyut, p; parametreler) {
            static if (is (typeof(p) == Aralık)) {
                /* Bu boyut için 'matris[baş..son]' gibi
                 * aralık belirtilmiş; parametreyi olduğu gibi
                 * aralık olarak kullanabiliriz. */
                aralıklar[boyut] = p;

            } else static if (is (typeof(p) : size_t)) {
                /* Bu boyut için 'matris[i]' gibi tek konum
                 * değeri belirtilmiş; kullanmadan önce tek
                 * uzunluklu aralık oluşturmak gerekiyor. */
                aralıklar[boyut] = Aralık(p, p + 1);

            } else {
                /* Bu işlevin başka bir türle çağrılmasını
                 * beklemiyoruz. */
                static assert(
                    false, format("Geçersiz indeks türü: %s",
                                  typeof(p).stringof));
            }
        }

        /* 'parametreler'in karşılık geldiği alt matrisi
         * döndürüyoruz. */
        return altMatris(aralıklar[0], aralıklar[1]);
    }

    /* Belirtilen değeri belirtilen elemanlara atar. */
    Matris opIndexAssign(A...)(int değer, A parametreler)
            if (A.length <= 2) {
        writeln(__FUNCTION__);

        Matris altMatris = opIndex(parametreler);
        return altMatris = değer;
    }

    /* Belirtilen işleci ve değeri belirtilen elemanlara
     * uygular ve sonuçları yine aynı elemanlara atar. */
    Matris opIndexOpAssign(string işleç, A...)(int değer,
                                               A parametreler)
            if (A.length <= 2) {
        writeln(__FUNCTION__);

        Matris altMatris = opIndex(parametreler);
        mixin ("return altMatris " ~ işleç ~ "= değer;");
    }
}

/* Dizgi halinde belirtilen ifadeyi işletir ve hem işlemin
 * sonucunu hem de matrisin yeni durumunu yazdırır. */
void işlet(string ifade)(Matris m) {
    writefln("\n--- %s ---", ifade);
    mixin ("auto sonuç = " ~ ifade ~ ";");
    writefln("sonuç:\n%s", sonuç);
    writefln("m:\n%s", m);
}

void main() {
    enum yükseklik = 10;
    enum genişlik = 8;

    auto m = Matris(yükseklik, genişlik);

    int sayaç = 0;
    foreach (satır; 0 .. yükseklik) {
        foreach (sütun; 0 .. genişlik) {
            writefln("%s / %s ilkleniyor",
                     sayaç + 1, yükseklik * genişlik);

            m[satır, sütun] = sayaç;
            ++sayaç;
        }
    }

    writeln(m);

    işlet!("m[1, 1] = 42")(m);
    işlet!("m[0, 1 .. $] = 43")(m);
    işlet!("m[0 .. $, 3] = 44")(m);
    işlet!("m[$-4 .. $-1, $-4 .. $-1] = 7")(m);

    işlet!("m[1, 1] *= 2")(m);
    işlet!("m[0, 1 .. $] *= 4")(m);
    işlet!("m[0 .. $, 0] *= 10")(m);
    işlet!("m[$-4 .. $-2, $-4 .. $-2] -= 666")(m);

    işlet!("m[1, 1]")(m);
    işlet!("m[2, 0 .. $]")(m);
    işlet!("m[0 .. $, 2]")(m);
    işlet!("m[0 .. $ / 2, 0 .. $ / 2]")(m);

    işlet!("++m[1..3, 1..3]")(m);
    işlet!("--m[2..5, 2..5]")(m);

    işlet!("m[]")(m);
    işlet!("m[] = 20")(m);
    işlet!("m[] /= 4")(m);
    işlet!("(m[] += 5) /= 10")(m);
}
---

$(H5 Özet)

$(P
Önceki şablonlar bölümünün sonunda şunları hatırlatmıştım:
)

$(UL

$(LI Şablonlar kodun kalıp halinde tarif edilmesini ve derleyici tarafından gereken her tür için otomatik olarak üretilmesini sağlayan olanaktır.)

$(LI Şablonlar bütünüyle derleme zamanında işleyen bir olanaktır.)

$(LI Tanımlarken isimlerinden sonra şablon parametresi de belirtmek; işlevlerin, yapıların, ve sınıfların şablon haline gelmeleri için yeterlidir.)

$(LI Şablon parametreleri ünlem işaretinden sonra açıkça belirtilebilirler. Tek parametre için parantez kullanmaya gerek yoktur.)

$(LI Şablonun farklı türlerle her kullanımı farklı bir türdür.)

$(LI Şablon parametreleri yalnızca işlev şablonlarında çıkarsanabilirler.)

$(LI Şablonlar $(C :) karakterinden sonra belirtilen tür için özellenebilirler.)

$(LI Varsayılan şablon parametre türleri $(C =) karakterinden sonra belirtilebilir.)

)

$(P
Bu bölümde de şu kavramları gördük:
)

$(UL

$(LI Şablonlar kestirme veya uzun söz dizimleriyle tanımlanabilirler.)

$(LI Şablon kapsamı bir isim alanı belirler.)

$(LI İçinde bir tanımla aynı isime sahip olan şablon o tanım yerine geçer.)

$(LI İşlev, sınıf, yapı, birlik, ve arayüz şablonları tanımlanabildiği gibi, bu tanımlar şablon kapsamı içinde karışık olarak bulunabilirler.)

$(LI Şablon parametrelerinin tür, değer, $(C this), $(C alias), ve çokuzlu çeşitleri vardır.)

$(LI Şablonlar parametrelerinin herhangi bir kullanımı için özellenebilirler.)

$(LI $(C typeof(this)), $(C typeof(super)), ve $(C typeof(return)) tür yazımlarında kolaylık sağlarlar.)

$(LI Meta programlama, işlemlerin derleme zamanında yapılmalarını sağlar.)

$(LI Şablonlar $(I derleme zamanı çok şekilliliği) olanaklarıdır.)

$(LI Şablonun her farklı parametreli kullanımı için ayrı kod üretilmesi $(I kod şişmesine) neden olabilir.)

$(LI Olası derleme hatalarının şablonun yanlış kullanıldığı satıra işaret edebilmesi için şablon kısıtlamaları tanımlanabilir.)

$(LI İsimli kısıtlama yöntemi kısıtlamalara okunaklı isimler vermeye yarar.)

$(LI $(C opDollar), $(C opSlice), $(C opIndex), $(C opIndexAssign), ve $(C opIndexOpAssign) işlevlerinin şablon çeşitleri çok boyutlu eleman erişimine ve dilimlemeye olanak sağlar.)

)

macros:
        SUBTITLE=Ayrıntılı Şablonlar

        DESCRIPTION=Derleyicinin belirli bir kalıba uygun olarak kod üretmesini sağlayan şablon (template) olanağı; D'nin 'türden bağımsız programlama'ya getirdiği çözüm

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial şablon şablonlar template türden bağımsız programlama generic programming işlev şablonu yapı şablonu sınıf şablonu alias

SOZLER=
$(arayuz)
$(birlik)
$(blok)
$(ctfe)
$(cokuzlu)
$(hazir_deger)
$(isim_alani)
$(kapsam)
$(kisitlama)
$(ordek_tipleme)
$(ozelleme)
$(ozyineleme)
$(siraduzen)
$(sablon)
