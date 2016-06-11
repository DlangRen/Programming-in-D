Ddoc

$(DERS_BOLUMU $(IX kullanıcı niteliği) $(IX UDA) Kullanıcı Nitelikleri (UDA))

$(P
Programdaki her tanıma (yapı türü, sınıf türü, değişken, vs.) nitelikler atanabilir ve bu nitelikler derleme zamanında sorgulanarak programın farklı derlenmesi sağlanabilir. Kullanıcı nitelikleri bütünüyle derleme zamanında etkili olan bir olanaktır.
)

$(P
$(IX @) Nitelikler $(C @) işareti ile belirtilirler ve o niteliğin atanmakta olduğu tanımdan önce yazılırlar. Örneğin, aşağıdaki kod $(C isim) değişkenine $(C ŞifreliKayıt) niteliğini atar:
)

---
    $(HILITE @ŞifreliKayıt) string isim;
---

$(P
Birden fazla nitelik ayrı ayrı belirtilebilecekleri gibi, hepsi birden parantez içinde de belirtilebilirler. Örneğin, aşağıdaki iki satırdaki nitelikler aynı anlamdadır:
)

---
    @ŞifreliKayıt @RenkliÇıktı string soyad;    $(CODE_NOTE ayrı ayrı)
    @$(HILITE $(PARANTEZ_AC))ŞifreliKayıt, RenkliÇıktı$(HILITE $(PARANTEZ_KAPA)) string adres;  $(CODE_NOTE ikisi birden)
---

$(P
Nitelikler yalnızca tür isminden oluşabildikleri gibi, nesne veya temel tür değeri de olabilirler. Ancak, anlamları genelde açık olmadığından $(C 42) gibi hazır değerlerin nitelik olarak kullanılması önerilmez:
)

---
$(CODE_NAME ŞifreliKayıt)struct ŞifreliKayıt {
}

enum Renk { siyah, mavi, kırmızı }

struct RenkliÇıktı {
    Renk renk;
}

void main() {
    @ŞifreliKayıt           int a;    $(CODE_NOTE tür ismi)
    @ŞifreliKayıt()         int b;    $(CODE_NOTE nesne)
    @RenkliÇıktı(Renk.mavi) int c;    $(CODE_NOTE nesne)
    @(42)                   int d;    $(CODE_NOTE hazır değer (önerilmez))
}
---

$(P
Yukarıdaki $(C a) ve $(C b) değişkenlerinin nitelikleri farklı çeşittendir: $(C a) değişkeni $(C ŞifreliKayıt) türünün kendisi ile, $(C b) değişkeni ise bir $(C ŞifreliKayıt) $(I nesnesi) ile nitelendirilmiştir. Bu, niteliklerin derleme zamanında sorgulanmaları açısından önemli bir farktır. Bu farkı aşağıdaki örnek programda göreceğiz.
)

$(P
$(IX __traits) $(IX getAttributes) Niteliklerin ne anlama geldikleri bütünüyle programın ihtiyaçlarına bağlıdır. Nitelikler $(C __traits(getAttributes)) ile derleme zamanında elde edilirler, çeşitli derleme zamanı olanağı ile sorgulanırlar, ve programın uygun biçimde derlenmesi için kullanılırlar.
)

$(P
Aşağıdaki kod belirli bir yapı üyesinin (örneğin, $(C Kişi.isim)) niteliklerinin $(C __traits(getAttributes)) ile nasıl elde edildiğini gösteriyor:
)

---
$(CODE_NAME Kişi)import std.stdio;

// ...

struct Kişi {
    @ŞifreliKayıt @RenkliÇıktı(Renk.mavi) string isim;
    string soyad;
    @RenkliÇıktı(Renk.kırmızı) string adres;
}

void $(CODE_DONT_TEST)main() {
    foreach (nitelik; __traits($(HILITE getAttributes), Kişi.isim)) {
        writeln(nitelik.stringof);
    }
}
---

$(P
Program, $(C Kişi.isim) üyesinin niteliklerini yazdırır:
)

$(SHELL
ŞifreliKayıt
RenkliÇıktı(cast(Renk)1)
)

$(P
Kullanıcı niteliklerinden yararlanırken aşağıdaki $(C __traits) ifadeleri de kullanışlıdır:
)

$(UL

$(LI $(IX allMembers) $(C __traits(allMembers)) bir türün (veya modülün) bütün üyelerini $(C string) türünde döndürür.
)

$(LI $(IX getMember) $(C __traits(getMember)) üyelere erişirken kullanılabilen bir $(I isim) $(ASIL symbol) üretir. İlk parametresi bir tür veya değişken ismi, ikinci parametresi ise bir dizgidir. Birinci parametresi ile ikinci parametresini bir nokta ile birleştirir ve yeni bir isim üretir. Örneğin, $(C __traits(getMember, Kişi, $(STRING "isim"))), $(C Kişi.isim)'i oluşturur.
)

)

---
$(CODE_XREF ŞifreliKayıt)$(CODE_XREF Kişi)import std.string;

// ...

void main() {
    foreach (üyeİsmi; __traits($(HILITE allMembers), Kişi)) {
        writef("%5s üyesinin nitelikleri:", üyeİsmi);

        foreach (nitelik;
                 __traits(getAttributes,
                          __traits($(HILITE getMember), Kişi, üyeİsmi))) {
            writef(" %s", nitelik.stringof);
        }

        writeln();
    }
}
---

$(P
Program, bütün üyelerin niteliklerini yazdırır:
)

$(SHELL
 isim üyesinin nitelikleri: ŞifreliKayıt RenkliÇıktı(cast(Renk)1)
soyad üyesinin nitelikleri:
adres üyesinin nitelikleri: RenkliÇıktı(cast(Renk)2)
)

$(P
$(IX hasUDA, std.traits) Kullanıcı nitelikleri konusunda yararlı olan bir başka araç belirli bir $(I ismin) belirli bir niteliğe sahip olup olmadığını bildiren $(C std.traits.hasUDA) şablonudur; değeri, nitelik bulunduğunda $(C true), bulunmadığında ise $(C false) olur. $(C Kişi.isim)'in $(C ŞifreliKayıt) niteliği bulunduğandan aşağıdaki $(C static assert) denetimi başarılı olur:
)

---
import std.traits;

// ...

static assert(hasUDA!(Kişi.isim, ŞifreliKayıt));
---

$(P
$(C hasUDA) bir nitelik türü ile kullanılabileceği gibi, o türün belirli bir değeri ile de kullanılabilir. Aşağıdaki $(C static assert) denetimlerinin ikisi de başarılı olur:
)

---
static assert(hasUDA!(Kişi.isim, $(HILITE RenkliÇıktı)));
static assert(hasUDA!(Kişi.isim, $(HILITE RenkliÇıktı(Renk.mavi))));
---

$(H5 Örnek)

$(P
Niteliklerin derleme zamanında nasıl sorgulanabildiklerini görmek için bir işlev şablonu tasarlayalım. Bu şablon kendisine verilen yapı nesnesinin bütün üyelerini niteliklerine uygun olarak XML düzeninde yazdırsın
)

---
void xmlOlarakYazdır(T)(T nesne) {
// ...

    foreach (üyeİsmi; __traits($(HILITE allMembers), T)) {           // (1)
        string değer =
            __traits($(HILITE getMember), nesne, üyeİsmi).to!string; // (2)

        static if ($(HILITE hasUDA)!(__traits(getMember, T, üyeİsmi),// (3)
                                   ŞifreliKayıt)) {
            değer = değer.şifrelisi.to!string;
        }

        writefln(`  <%1$s renk="%2$s">%3$s</%1$s>`, üyeİsmi,
                 $(HILITE renkNiteliği)!(T, üyeİsmi), değer);        // (4)
    }
}
---

$(P
Bu şablonun işaretli bölümleri şöyle açıklanabilir:
)

$(OL

$(LI Türün bütün üyeleri $(C __traits(allMembers)) ile elde ediliyor.)

$(LI Her üyenin değeri biraz aşağıda kullanılmak üzere $(C string) türünde elde ediliyor. Örneğin, $(C üyeİsmi) $(STRING "isim") olduğunda atama işlecinin sağ tarafı $(C nesne.isim.to!string) ifadesidir.)

$(LI Her üyenin $(C ŞifreliKayıt) niteliğinin olup olmadığı $(C hasUDA) ile sorgulanıyor ve bu niteliğe sahip olan üyelerin değerleri şifreleniyor.)

$(LI Biraz aşağıda göreceğimiz $(C renkNiteliği()) şablonu ile her üyenin renk niteliği elde ediliyor.)

)

$(P
$(C renkNiteliği()) işlev şablonu aşağıdaki gibi gerçekleştirilebilir:
)

---
Renk renkNiteliği(T, string üye)() {
    foreach (nitelik; __traits(getAttributes,
                               __traits(getMember, T, üye))) {
        static if (is ($(HILITE typeof(nitelik)) == RenkliÇıktı)) {
            return nitelik.renk;
        }
    }

    return Renk.siyah;
}
---

$(P
Bütün bu olanaklar derleme zamanında işlediğinde $(C xmlOlarakYazdır()) şablonu $(C Kişi) türü için aşağıdaki işlevin eşdeğeri olarak oluşturulur ve derlenir:
)

---
/* xmlOlarakYazdır!Kişi işlevinin eşdeğeri */
void xmlOlarakYazdır_Kişi(Kişi nesne) {
// ...

    {
        string değer = nesne.$(HILITE isim).to!string;
        $(HILITE değer = değer.şifrelisi.to!string;)
        writefln(`  <%1$s renk="%2$s">%3$s</%1$s>`,
                 "isim", Renk.mavi, değer);
    }
    {
        string değer = nesne.$(HILITE soyad).to!string;
        writefln(`  <%1$s renk="%2$s">%3$s</%1$s>`,
                 "soyad", Renk.siyah, değer);
    }
    {
        string değer = nesne.$(HILITE adres).to!string;
        writefln(`  <%1$s renk="%2$s">%3$s</%1$s>`,
                 "adres", Renk.kırmızı, değer);
    }
}
---

$(P
Programda başka açıklamalar da bulunuyor:
)

---
import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.traits;

/* Nitelediği tanımın şifreleneceğini belirler. */
struct ŞifreliKayıt {
}

enum Renk { siyah, mavi, kırmızı }

/* Nitelediği tanımın rengini belirler. Belirtilmediği zaman
 * siyah renk varsayılır. */
struct RenkliÇıktı {
    Renk renk;
}

struct Kişi {
    /* Bu üyenin şifreleneceği ve mavi renkle yazdırılacağı
     * belirtiliyor. */
    @ŞifreliKayıt @RenkliÇıktı(Renk.mavi) string isim;

    /* Bu üye için herhangi bir nitelik belirtilmiyor. */
    string soyad;

    /* Bu üyenin kırmızı renkle yazdırılacağı belirtiliyor. */
    @RenkliÇıktı(Renk.kırmızı) string adres;
}

/* Belirtilen üyenin varsa renk niteliğinin değerini, yoksa
 * Renk.siyah değerini döndürür. */
Renk renkNiteliği(T, string üye)() {
    auto sonuç = Renk.siyah;

    foreach (nitelik; __traits(getAttributes,
                               __traits(getMember, T, üye))) {
        static if (is (typeof(nitelik) == RenkliÇıktı)) {
            sonuç = nitelik.renk;
        }
    }

    return sonuç;
}

/* Verilen dizginin Sezar şifresi ile şifrelenmişini
 * döndürür. (Uyarı: Sezar şifresi çok güçsüz bir şifreleme
 * algoritmasıdır.) */
auto şifrelisi(string değer) {
    return değer.map!(a => dchar(a + 1));
}

unittest {
    assert("abcdefghij".şifrelisi.equal("bcdefghijk"));
}

/* Belirtilen nesneyi niteliklerine uygun olarak XML düzeninde
 * yazdırır. */
void xmlOlarakYazdır(T)(T nesne) {
    writefln("<%s>", T.stringof);
    scope(exit) writefln("</%s>", T.stringof);

    foreach (üyeİsmi; __traits(allMembers, T)) {
        string değer =
            __traits(getMember, nesne, üyeİsmi).to!string;

        static if (hasUDA!(__traits(getMember, T, üyeİsmi),
                           ŞifreliKayıt)) {
            değer = değer.şifrelisi.to!string;
        }

        writefln(`  <%1$s renk="%2$s">%3$s</%1$s>`,
                 üyeİsmi, renkNiteliği!(T, üyeİsmi), değer);
    }
}

void main() {
    auto kişiler = [ Kişi("Doğu", "Doğan", "Diyarbakır"),
                     Kişi("Batı", "Batan", "Balıkesir") ];

    foreach (kişi; kişiler) {
        xmlOlarakYazdır(kişi);
    }
}
---

$(P
Programın çıktısı bütün üyelerin kendi renk niteliklerine sahip olduklarını ve $(C isim) üyesinin de şifrelendiğini gösteriyor:
)

$(SHELL
&lt;Kişi&gt;
  &lt;isim renk="mavi"&gt;EpĠv&lt;/isim&gt;               $(SHELL_NOTE mavi ve şifreli)
  &lt;soyad renk="siyah"&gt;Doğan&lt;/soyad&gt;
  &lt;adres renk="kırmızı"&gt;Diyarbakır&lt;/adres&gt;    $(SHELL_NOTE kırmızı)
&lt;/Kişi&gt;
&lt;Kişi&gt;
  &lt;isim renk="mavi"&gt;CbuĲ&lt;/isim&gt;               $(SHELL_NOTE mavi ve şifreli)
  &lt;soyad renk="siyah"&gt;Batan&lt;/soyad&gt;
  &lt;adres renk="kırmızı"&gt;Balıkesir&lt;/adres&gt;     $(SHELL_NOTE kırmızı)
&lt;/Kişi&gt;
)

$(H5 Kullanıcı niteliklerinin yararı)

$(P
Kullanıcı niteliklerinin yararı, niteliklerin programın başka bir yerinde değişiklik gerekmeden değiştirilebilmesidir. Örneğin, bütün üyelerin şifreli olarak yazdırılması için $(C Kişi) yapısının aşağıdaki gibi değiştirilmesi yeterlidir:
)

---
struct Kişi {
    $(HILITE @ŞifreliKayıt) {
        string isim;
        string soyad;
        string adres;
    }
}

// ...

    xmlOlarakYazdır(Kişi("Güney", "Gün", "Giresun"));
---

$(P
Çıktısı:
)

$(SHELL
&lt;Kişi&gt;
  &lt;isim renk="siyah"&gt;Hýofz&lt;/isim&gt;        $(SHELL_NOTE şifreli)
  &lt;soyad renk="siyah"&gt;Hýo&lt;/soyad&gt;        $(SHELL_NOTE şifreli)
  &lt;adres renk="siyah"&gt;Hjsftvo&lt;/adres&gt;    $(SHELL_NOTE şifreli)
&lt;/Kişi&gt;
)

$(P
Hatta, $(C xmlOlarakYazdır()) ve yararlandığı nitelikler başka türlerle de kullanılabilir:
)

---
struct Veri {
    $(HILITE @RenkliÇıktı(Renk.mavi)) string mesaj;
}

// ...

    xmlOlarakYazdır(Veri("merhaba dünya"));
---

$(P
Çıktısı:
)

$(SHELL
&lt;Veri&gt;
  &lt;mesaj renk="mavi"&gt;merhaba dünya&lt;/mesaj&gt;    $(SHELL_NOTE mavi)
&lt;/Veri&gt;
)

$(H5 Özet)

$(UL

$(LI Programda kullanılan bütün tanımlara nitelikler atanabilir.)

$(LI Nitelikler tür isimlerinden veya değerlerden oluşabilir.)

$(LI Nitelikler derleme zamanında $(C hasUDA) ve $(C __traits(getAttributes)) ile sorgulanarak programın farklı derlenmesi sağlanabilir.)

)

macros:
        SUBTITLE=Kullanıcı Nitelikleri (UDA)

        DESCRIPTION=Türlere programcı tarafından eklenen nitelikler.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial nitelikler uda

SOZLER=
$(nitelik)
