Ddoc

$(DERS_BOLUMU $(IX interface) $(IX arayüz) Arayüzler)

$(P
Sınıf sıradüzenlerinde arayüz tanımlamak için $(C class) anahtar sözcüğü yerine $(C interface) kullanılır. $(C interface), bazı olanakları kısıtlanmış soyut sınıf gibidir:
)

$(UL

$(LI
Bildirdiği ama tanımını vermediği bütün üye işlevleri soyuttur; $(C abstract) anahtar sözcüğü bile gerekmez.
)

$(LI
Tanımını da verdiği üye işlevler içeriyorsa o işlevlerin $(C static) veya $(C final) olmaları şarttır. ($(C static) ve $(C final) işlevleri aşağıda açıklayacağım.)
)

$(LI
Eğer varsa, üye değişkenleri ancak $(C static) olabilirler.
)

$(LI
Arayüzler ancak başka arayüzlerlerden türeyebilirler.
)

)

$(P
Bu kısıtlamalarına rağmen arayüzlerin getirdikleri önemli bir yarar vardır: Her sınıf en fazla bir $(C class)'tan türeyebildiği halde $(C interface)'ten türemenin sınırı yoktur.
)

$(H5 Tanımlanması)

$(P
$(C class) yerine $(C interface) yazılarak tanımlanır:
)

---
$(HILITE interface) SesliAlet {
    // ...
}
---

$(P
$(C interface) o arayüzün gerektirdiği işlevleri bildirir ama tanımlarını vermez:
)

---
interface SesliAlet {
    string ses();     // Yalnızca bildirilir (tanımı verilmez)
}
---

$(P
O arayüz ile kullanılabilmeleri için, $(C interface)'ten türeyen sınıfların $(C interface)'in bildirdiği işlevleri tanımlamaları gerekir.
)

$(P
Arayüz işlevlerinin $(C in) ve $(C out) blokları bulunabilir:
)

---
interface I {
    int işlev(int i)
    $(HILITE in) {
        /* Bu işlevi çağıranların uyması gereken en ağır
         * koşullar. (Alt arayüzler ve sınıflar bu koşulları
         * hafifletebilirler.) */

    } $(HILITE out) {  // ((sonuç) parametresi de bulunabilir)
        /* Bu işlevin gerçekleştirmelerinin vermeleri gereken
         * garantiler. (Alt arayüzler ve sınıflar ek
         * garantiler de verebilirler.) */
    }
}
---

$(P
Sözleşmeli programlamanın türemedeki kullanımını daha sonra $(LINK2 /ders/d/invariant.html, Yapı ve Sınıflarda Sözleşmeli Programlama bölümünde) göreceğiz.
)

$(H5 $(C interface)'ten türetme)

$(P
Türeme söz dizimi $(C class)'tan farklı değildir:
)

---
class Keman : $(HILITE SesliAlet) {
    string ses() {
        return "♩♪♪";
    }
}

class Çan : $(HILITE SesliAlet) {
    string ses() {
        return "çın";
    }
}
---

$(P
Üst sınıflarda da olduğu gibi, parametre olarak $(C interface) alan işlevler onları asıl türlerini bilmeden kullanabilirler. Örneğin, işlemleri sırasında bir $(C SesliAlet) kullanan aşağıdaki işlev hangi tür bir sesli alet olduğunu bilmeden onun $(C ses) işlevinden yararlanabilir:
)

---
void sesliAletKullan(SesliAlet alet) {
    // ... bazı işlemler ...
    writeln($(HILITE alet.ses()));
    // ... başka işlemler ...
}
---

$(P
Sınıflarda da olduğu gibi, o işlev $(C SesliAlet) arayüzünden türeyen her sınıf ile çağrılabilir:
)

---
    sesliAletKullan(new Keman);
    sesliAletKullan(new Çan);
---

$(P
Her aletin kendi asıl türünün tanımladığı $(C ses) işlevi çağrılır ve sonuçta sırasıyla $(C Keman.ses) ve $(C Çan.ses) üye işlevlerinin çıktıları görülür:
)

$(SHELL
♩♪♪
çın
)

$(H5 Birden fazla $(C interface)'ten türetme)

$(P
Bir sınıf ancak tek bir $(C class)'tan türetilebilir. $(C interface)'ten türemede ise böyle bir kısıtlama yoktur.
)

$(P
Örnek olarak, haberleşme aletlerini temsil eden aşağıdaki arayüzü ele alalım:
)

---
interface HaberleşmeAleti {
    void konuş(string mesaj);
    string dinle();
}
---

$(P
$(C Telefon) sınıfını hem bir sesli alet, hem de bir haberleşme aleti olarak kullanabilmek için onu bu iki arayüzden birden türeterek tanımlayabiliriz:
)

---
class Telefon : $(HILITE SesliAlet, HaberleşmeAleti) {
    // ...
}
---

$(P
O tanım şu iki ilişkiyi birden sağlar: "telefon bir sesli alettir" ve "telefon bir haberleşme aletidir".
)

$(P
$(C Telefon) sınıfının nesnelerinin oluşturulabilmesi için bu iki arayüzün gerektirdiği bütün işlevleri tanımlamış olması gerekir:
)

---
class Telefon : SesliAlet, HaberleşmeAleti {
    string ses() {                     // SesliAlet için
        return "zırrr zırrr";
    }

    void konuş(string mesaj) {         // HaberleşmeAleti için
        // ... mesajı hatta ilet ...
    }

    string dinle() {                   // HaberleşmeAleti için
        string hattaDuyulanSes;
        // ... sesi hattan oku ...
        return hattaDuyulanSes;
    }
}
---

$(P
Programın gerekleri doğrultusunda sınırsız sayıda $(C interface)'ten türetilebilir.
)

$(H5 $(C interface)'ten ve  $(C class)'tan türetme)

$(P
Bir sınıf, bir veya daha fazla $(C interface)'ten türetilmenin yanında, bir adet olduğu sürece aynı zamanda bir sınıftan da türetilebilir:
)

---
$(HILITE class) Saat {
    // ... kendi gerçekleştirmesi ...
}

class ÇalarSaat : $(HILITE Saat), SesliAlet {
    string ses() {
        return "bi bi biip";
    }
}
---

$(P
$(C ÇalarSaat), $(C Saat)'in bütün üyelerini ve üye işlevlerini türeme yoluyla edinmektedir. Bunun yanında, $(C SesliAlet) arayüzünün gerektirdiği $(C ses) işlevini tanımlamak zorundadır.
)

$(H5 $(C interface)'ten $(C interface) türetme)

$(P
Arayüzden türetilen bir arayüz, alt sınıfların tanımlamaları gereken işlevlerin sayısını arttırmış olur:
)

---
interface MüzikAleti : SesliAlet {
    void akortEt();
}
---

$(P
Yukarıdaki tanıma göre, bir $(C MüzikAleti) olabilmek için hem $(C SesliAlet)'in gerektirdiği $(C ses) işlevinin, hem de $(C MüzikAleti)'nin gerektirdiği $(C akortEt) işlevinin tanımlanması gerekir.
)

$(P
Örneğin, yukarıdaki $(C Keman) sınıfı doğrudan $(C SesliAlet) arayüzünden türetilmek yerine aradaki $(C MüzikAleti)'nden türetilse, $(C akortEt) işlevini de tanımlaması gerekir:
)

---
class Keman : MüzikAleti {
    string ses() {            // SesliAlet için
        return "♩♪♪";
    }

    void akortEt() {          // MüzikAleti için
        // ... akort işlemleri ...
    }
}
---

$(H5 $(IX static, üye işlev) $(C static) üye işlevler)

$(P
$(C static) üye işlevler yapılar, sınıflar, ve arayüzler için tanımlanabilir. Önceki bölümleri gereğinden fazla karmaşıklaştırmamak için bu olanağı bu bölüme bıraktım.
)

$(P
Hatırlayacağınız gibi, normal üye işlevler her zaman için bir nesne üzerinde çağrılırlar. Üye işlev içinde kullanılan üyeler hep o nesnenin üyeleridir:
)

---
struct Yapı {
    int i;

    void değiştir(int değer) {
        $(HILITE i) = değer;
    }
}

void main() {
    auto nesne0 = Yapı();
    auto nesne1 = Yapı();

    nesne0.değiştir(10);    // nesne0.i değişir
    nesne1.değiştir(10);    // nesne1.i değişir
}
---

$(P
Ek olarak, üyeler üye işlev içindeyken "bu nesne" anlamına gelen $(C this) ile de belirtilebilirler:
)

---
    void değiştir(int değer) {
        this.i = değer;    // üsttekinin eşdeğeri
    }
---

$(P
$(C static) üye işlevler ise hiçbir nesne üzerinde işlemezler; üye işlev içindeyken $(C this) anahtar sözcüğünün karşılık geldiği bir nesne yoktur. O yüzden, $(C static) üye işlev içindeyken hiçbir $(I normal üye değişken) geçerli değildir:
)

---
struct Yapı {
    int i;

    $(HILITE static) void ortakİşlev(int değer) {
        i = değer;         $(DERLEME_HATASI)
        this.i = değer;    $(DERLEME_HATASI)
    }
}
---

$(P
$(C static) işlevler ancak türlerin ortak üyeleri olan $(C static) üyeleri kullanabilirler.
)

$(P
$(LINK2 /ders/d/yapilar.html, Yapılar bölümünde) gördüğümüz $(C Nokta) türünü $(C static) üye işlevi olacak biçimde tekrar tanımlayalım. Hatırlarsanız, $(C Nokta) türünün her nesnesine farklı bir numara veriliyordu. Numaralar bu sefer $(C static) bir üye işlev tarafından belirleniyor:
)

---
import std.stdio;

struct Nokta {
    size_t numara;    // Nesnenin kendi numarası
    int satır;
    int sütun;

    // Bundan sonra oluşturulacak olan nesnenin numarası
    $(HILITE static) size_t sonrakiNumara;

    this(int satır, int sütun) {
        this.satır = satır;
        this.sütun = sütun;
        this.numara = yeniNumaraBelirle();
    }

    $(HILITE static) size_t yeniNumaraBelirle() {
        immutable yeniNumara = sonrakiNumara;
        ++sonrakiNumara;
        return yeniNumara;
    }
}

void main() {
    auto üstteki = Nokta(7, 0);
    auto ortadaki = Nokta(8, 0);
    auto alttaki =  Nokta(9, 0);

    writeln(üstteki.numara);
    writeln(ortadaki.numara);
    writeln(alttaki.numara);
}
---

$(P
$(C static) $(C yeniNumaraBelirle) işlevi, türün ortak değişkeni olan $(C sonrakiNumara)'yı kullanabilir. Sonuçta her nesnenin farklı bir numarası olur:
)

$(SHELL
0
1
2
)

$(P
Yukarıda bir yapı üzerinde gösterdiğim $(C static) üye işlevler sınıflarla ve arayüzlerle de kullanılabilir.
)

$(H5 $(IX final) $(C final) üye işlevler)

$(P
$(C final) üye işlevler sınıflar ve arayüzler için tanımlanabilir. (Yapılarda türeme olmadığı için yapılarla ilgili bir olanak değildir.) Önceki bölümleri gereğinden fazla karmaşıklaştırmamak için bu olanağı bu bölüme bıraktım.
)

$(P
"Son" anlamına gelen $(C final) anahtar sözcüğü bir üye işlevin tanımının daha alttaki sınıflar tarafından değiştirilemeyeceğini bildirir; bir anlamda, algoritmanın son tanımı bu sınıf veya arayüz tarafından verilmektedir. Bir algoritmanın ana hatlarının üst sınıf veya arayüz tarafından belirlendiği ve ayrıntılarının alt sınıflara bırakıldığı durumlarda yararlıdır.
)

$(P
Bunun örneğini bir $(C Oyun) arayüzünde görelim. Bir oyunun nasıl oynatıldığının ana hatları bu arayüzün $(C oynat) işlevi tarafından belirlenmektedir:
)

---
$(CODE_NAME Oyun)interface Oyun {
    $(HILITE final) void oynat() {
        string isim = oyunİsmi();
        writefln("%s oyunu başlıyor", isim);

        oyuncularıTanı();
        hazırlan();
        başlat();
        sonlandır();

        writefln("%s oyunu bitti", isim);
    }

    string oyunİsmi();
    void oyuncularıTanı();
    void hazırlan();
    void başlat();
    void sonlandır();
}
---

$(P
$(C final) işlevin tanımladığı adımların alt sınıflar tarafından değiştirilmesi mümkün değildir. Alt sınıflar ancak aynı arayüz tarafından şart koşulmuş olan beş işlevi tanımlayabilirler ve böylece algoritmayı tamamlamış olurlar:
)

---
$(CODE_XREF Oyun)import std.stdio;
import std.string;
import std.random;
import std.conv;

class ZarToplamıOyunu : Oyun {
    string oyuncu;
    size_t adet;
    size_t toplam;

    string oyunİsmi() {
        return "Zar Toplamı";
    }

    void oyuncularıTanı() {
        write("İsminiz nedir? ");
        oyuncu = strip(readln());
    }

    void hazırlan() {
        write("Kaç kere zar atılsın? ");
        readf(" %s", &adet);
        toplam = 0;
    }

    void başlat() {
        foreach (i; 0 .. adet) {
            immutable zar = uniform(1, 7);
            writefln("%s: %s", i, zar);
            toplam += zar;
        }
    }

    void sonlandır() {
        writefln("Oyuncu: %s, Zar toplamı: %s, Ortalama: %s",
                 oyuncu, toplam, to!double(toplam) / adet);
    }
}

void kullan(Oyun oyun) {
    oyun.oynat();
}

void main() {
    kullan(new ZarToplamıOyunu());
}
---

$(P
Yukarıda bir arayüz üzerinde gösterdiğim $(C final) üye işlevler sınıflarla da kullanılabilir.
)

$(H5 Nasıl kullanmalı)

$(P
$(C interface) çok kullanılan bir olanaktır. Hemen hemen bütün sıradüzenlerin en üstünde bir veya daha fazla $(C interface) bulunur. En sık karşılaşılan sıradüzenlerden birisi, tek bir $(C interface)'ten türeyen basit gerçekleştirme sınıflarından oluşan sıradüzendir:
)

$(MONO
                  $(I MüzikAleti
                 (interface))
                /   |   \     \
          Kemençe  Saz  Kaval  ...
)

$(P
Çok daha karmaşık sıradüzenlerle de karşılaşılır ama bu basit yapı çoğu programın ihtiyacı için yeterlidir.
)

$(P
Bazı alt sınıfların ortak gerçekleştirmelerinin bir ara sınıfta tanımlandığı durumlarla da sık karşılaşılır. Alt sınıflar bu ortak sınıftan türerler. Aşağıdaki sıradüzende $(C TelliMüzikAleti) ve $(C NefesliMüzikAleti) sınıfları kendi alt türlerinin ortak üyelerini içeriyor olabilirler:
)

$(MONO
                 $(I MüzikAleti
                (interface))
                /         \
     TelliMüzikAleti    NefesliMüzikAleti
       /   |  \          /    |   \
 Kemençe  Saz  ...    Kaval  Ney   ...
)

$(P
O ortak sınıflardan türeyen alt sınıflar da kendi daha özel tanımlarını içerebilirler.
)

$(H5 $(IX soyutlama) Soyutlama)

$(P
Arayüzler programların alt bölümlerini birbirlerinden bağımsızlaştırmaya yararlar. Buna $(I soyutlama) denir. Örneğin, müzik aletleri kullanan bir programın büyük bir bölümü yalnızca $(C MüzikAleti) arayüzünden haberi olacak biçimde ve yalnızca onu kullanarak yazılabilir.
)

$(P
$(C Müzisyen) gibi bir sınıf asıl türünü bilmeden bir $(C MüzikAleti) içerebilir:
)

---
class Müzisyen {
    MüzikAleti alet;
    // ...
}
---

$(P
Birden fazla müzik aletini bir araya getiren türler o aletlerin asıl türlerini bilmek zorunda değillerdir:
)

---
    MüzikAleti[] orkestradakiAletler;
---

$(P
Programın çoğu işlevi yalnızca bu arayüzü kullanarak yazılabilir:
)

---
bool akortGerekiyor_mu(MüzikAleti alet) {
    bool karar;
    // ...
    return karar;
}

void güzelÇal(MüzikAleti alet) {
    if (akortGerekiyor_mu(alet)) {
        alet.akortEt();
    }

    writeln(alet.ses());
}
---

$(P
Bu şekilde bir $(I soyutlama) kullanarak programın bölümlerinin birbirlerinden bağımsız hale getirilmeleri, alt sınıflarda ileride gerekebilecek kod düzenlemelerinin serbestçe yapılabilmesini sağlar. Alt sınıfların gerçekleştirmeleri bu arayüzün $(I arkasında) oldukları için, bu arayüzü kullanan kodlar o değişikliklerden etkilenmemiş olurlar.
)

$(H5 Örnek)

$(P
$(C SesliAlet), $(C MüzikAleti), ve $(C HaberleşmeAleti) arayüzlerini içeren bir program şöyle yazılabilir:
)

---
import std.stdio;

/* Bu arayüz 'ses' işlevini gerektirir. */
interface SesliAlet {
    string ses();
}

/* Bu sınıfın yalnızca 'ses' işlevini tanımlaması gerekir. */
class Çan : SesliAlet {
    string ses() {
        return "çın";
    }
}

/* Bu arayüz 'ses' işlevine ek olarak 'akortEt' işlevini de
 * gerektirir. */
interface MüzikAleti : SesliAlet {
    void akortEt();
}

/* Bu sınıfın 'ses' ve 'akortEt' işlevlerini tanımlaması
 * gerekir. */
class Keman : MüzikAleti {
    string ses() {
        return "♩♪♪";
    }

    void akortEt() {
        // ... kemanın akort işlemleri ...
    }
}

/* Bu arayüz 'konuş' ve 'dinle' işlevlerini gerektirir. */
interface HaberleşmeAleti {
    void konuş(string mesaj);
    string dinle();
}

/* Bu sınıfın 'ses', 'konuş', ve 'dinle' işlevlerini
 * tanımlaması gerekir. */
class Telefon : SesliAlet, HaberleşmeAleti {
    string ses() {
        return "zırrr zırrr";
    }

    void konuş(string mesaj) {
        // ... mesajın hatta iletilmesi ...
    }

    string dinle() {
        string hattaDuyulanSes;
        // ... sesin hattan okunması ...
        return hattaDuyulanSes;
    }
}

class Saat {
    // ... Saat'in gerçekleştirilmesi ...
}

/* Bu sınıfın yalnızca 'ses' işlevini tanımlaması gerekir. */
class ÇalarSaat : Saat, SesliAlet {
    string ses() {
        return "bi bi biip";
    }

    // ... ÇalarSaat'in gerçekleştirilmesi ...
}

void main() {
    SesliAlet[] aletler;

    aletler ~= new Çan;
    aletler ~= new Keman;
    aletler ~= new Telefon;
    aletler ~= new ÇalarSaat;

    foreach (alet; aletler) {
        writeln(alet.ses());
    }
}
---

$(P
$(C main)'in içindeki $(C aletler) bir $(C SesliAlet) dizisi olduğu için, o diziye $(C SesliAlet)'ten türeyen her tür eklenebiliyor. Sonuçta programın çıktısı bütün aletlerin ürettikleri sesleri içerir:
)

$(SHELL
çın
♩♪♪
zırrr zırrr
bi bi biip
)

$(H5 Özet)

$(UL

$(LI $(C interface) bir arayüz tanımlar; bütün işlevleri soyut olan bir sınıf gibidir. Gerçekleştirme olarak yalnızca $(C static) üye değişkenleri ve $(C static) ve $(C final) üye işlevleri olabilir.)

$(LI Bir sınıfın nesnelerinin oluşturulabilmesi için, türetildiği bütün arayüzlerin bütün işlevlerinin tanımlanmış olmaları gerekir.)

$(LI Tek $(C class)'tan türetebilme kısıtlaması $(C interface)'lerde yoktur; sınıflar ve arayüzler sınırsız sayıda $(C interface)'ten türetilebilirler.)

$(LI Sık karşılaşılan bir sıradüzen, üstte bir arayüz ($(C interface)) ve alttaki gerçekleştirmeleridir ($(C class)).)
)

Macros:
        SUBTITLE=Arayüzler

        DESCRIPTION=D dilinin arayüz türeme olanağı olan 'interface' anahtar sözcüğü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar kullanıcı türleri türeme arayüz türemesi interface

SOZLER=
$(alt_sinif)
$(arayuz)
$(bildirim)
$(gerceklestirme)
$(siraduzen)
$(soyut)
$(ust_sinif)
