Ddoc

$(DERS_BOLUMU $(IX union) $(IX birlik) Birlikler)

$(P
Birlikler, birden fazla üyenin aynı bellek alanını paylaşmalarını sağlarlar. D'ye C dilinden geçmiş olan alt düzey bir olanaktır.
)

$(P
İki fark dışında yapılarla aynı şekilde kullanılır:
)

$(UL

$(LI $(C struct) yerine $(C union) anahtar sözcüğü ile tanımlanır)

$(LI üyeleri aynı bellek alanını paylaşırlar; birbirlerinden bağımsız değillerdir)

)

$(P
Yapılar gibi, birliklerin de üye işlevleri bulunabilir.
)

$(P
$(IX -m32, derleyici seçeneği) Aşağıdaki örnek programlar derlendikleri ortamın 32 bit veya 64 bit olmasına bağlı olarak farklı sonuçlar üreteceklerdir. Bu yüzden, bu bölümdeki programları derlerken $(C -m32) derleyici seçeneğini kullanmanızı öneririm. Aksi taktirde sizin sonuçlarınız aşağıda gösterilenlerden farklı olabilir.
)

$(P
Şimdiye kadar çok karşılaştığımız yapı türlerinin kullandıkları bellek alanı bütün üyelerini barındıracak kadar büyüktü:
)

---
struct Yapı {
    int i;
    double d;
}

// ...

    writeln(Yapı.sizeof);
---

$(P
Dört baytlık $(C int)'ten ve sekiz baytlık $(C double)'dan oluşan o yapının büyüklüğü 12'dir:
)

$(SHELL_SMALL
12
)

$(P
Aynı şekilde tanımlanan bir birliğin büyüklüğü ise, üyeleri aynı bellek bölgesini paylaştıkları için, üyelerden en büyüğü için gereken yer kadardır:
)

---
$(HILITE union) Birlik {
    int i;
    double d;
}

// ...

    writeln(Birlik.sizeof);
---

$(P
Dört baytlık $(C int) ve sekiz baytlık $(C double) aynı alanı paylaştıkları için bu birliğin büyüklüğü en büyük üye için gereken yer kadardır:
)

$(SHELL_SMALL
8
)

$(P
Bunun bellek kazancı sağlayan bir olanak olduğunu düşünmeyin. Aynı bellek alanına birden fazla veri sığdırmak olanaksızdır. Birliklerin yararı, aynı bölgenin farklı zamanlarda farklı türden veriler için kullanılabilmesidir. Belirli bir anda ancak tek üyenin değerine güvenilebilir. Buna rağmen, her ortamda aynı şekilde çalışmasa da, birliklerin yararlarından birisi, geçerli olan verinin parçalarına diğer üyeler yoluyla erişilebilmesidir.
)

$(P
Aşağıdaki örneklerden birisi, geçerli üye dışındakilere erişimin $(C typeid)'den yararlanılarak nasıl engellenebileceğini göstermektedir.
)

$(P
Yukarıdaki birliği oluşturan sekiz baytın bellekte nasıl durduklarını ve üyeler için nasıl kullanıldıklarını şöyle gösterebiliriz:
)

$(MONO
       0      1      2      3      4      5      6      7
───┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬───
   │$(HILITE <───  int için 4 bayt  ───>)                            │
   │$(HILITE <───────────────  double için 8 bayt  ────────────────>)│
───┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴───
)

$(P
Ya sekiz baytın hepsi birden $(C double) üye için kullanılır, ya da ilk dört bayt $(C int) üye için kullanılır ve gerisine dokunulmaz.
)

$(P
Ben örnek olarak iki üye kullandım; birlikleri istediğiniz kadar üye ile tanımlayabilirsiniz. Üyelerin hepsi aynı alanı paylaşırlar.
)

$(P
Aynı bellek bölgesinin kullanılıyor olması ilginç sonuçlar doğurabilir. Örneğin, birliğin bir $(C int) ile ilklenmesi ama bir $(C double) olarak kullanılması, baştan kestirilemeyecek $(C double) değerleri verebilir:
)

---
    auto birlik = Birlik(42);    // int üyenin ilklenmesi
    writeln(birlik.d);           // double üyenin kullanılması
---

$(P
$(C int) üyeyi oluşturan dört baytın 42 değerini taşıyacak şekilde kurulmaları, $(C double) üyenin değerini de etkiler:
)

$(SHELL_SMALL
4.9547e-270
)

$(P
Mikro işlemcinin bayt sıralarına bağlı olarak $(C int) üyeyi oluşturan dört bayt bellekte 0|0|0|42, 42|0|0|0, veya daha başka bir düzende bulunabilir. Bu yüzden yukarıdaki $(C double) üyenin değeri başka ortamlarda daha farklı da olabilir.
)

$(H5 $(IX isimsiz birlik) İsimsiz birlikler)

$(P
İsimsiz birlikler, içinde bulundukları bir yapının hangi üyelerinin paylaşımlı olarak kullanıldıklarını belirlerler:
)

---
struct BirYapı {
    int birinci;

    union {
        int ikinci;
        int üçüncü;
    }
}

// ...

    writeln(BirYapı.sizeof);
---

$(P
Yukarıdaki yapının son iki üyesi aynı alanı paylaşırlar ve bu yüzden yapı, toplam iki $(C int)'in büyüklüğü kadar yer tutar. Birlik üyesi olmayan $(C birinci) için gereken 4 bayt, ve $(C ikinci) ile $(C üçüncü)'nün paylaştıkları 4 bayt:
)

$(SHELL_SMALL
8
)

$(H5 Başka bir türün baytlarını ayrıştırmak)

$(P
Birlikler, türleri oluşturan baytlara teker teker erişmek için kullanılabilirler. Örneğin aslında 32 bitten oluşan IPv4 adreslerinin 4 bölümünü elde etmek için bu 32 biti paylaşan 4 baytlık bir dizi kullanılabilir. Adres değerini oluşturan üye ve dört bayt bir birlik olarak şöyle bir araya getirilebilir:
)

---
$(CODE_NAME IpAdresi)union IpAdresi {
    uint değer;
    ubyte[4] baytlar;
}
---

$(P
O birliği oluşturan iki üye, aynı belleği şu şekilde paylaşırlar:
)

$(MONO
          0            1            2            3
───┬────────────┬────────────┬────────────┬────────────┬───
   │$(HILITE <───────  IPv4 adresini oluşturan 32 bit  ────────>)│
   │ baytlar[0] │ baytlar[1] │ baytlar[2] │ baytlar[3] │
───┴────────────┴────────────┴────────────┴────────────┴───
)

$(P
Bu birlik, daha önceki bölümlerde 192.168.1.2 adresinin değeri olarak karşılaştığımız 0xc0a80102 ile ilklendiğinde, $(C baytlar) dizisinin elemanları teker teker adresin dört bölümüne karşılık gelirler:
)

---
$(CODE_XREF IpAdresi)void main() {
    auto adres = IpAdresi(0xc0a80102);
    writeln(adres$(HILITE .baytlar));
}
---

$(P
Adresin bölümleri, bu programı denediğim ortamda alışık olunduğundan ters sırada çıkmaktadır:
)

$(SHELL_SMALL
[2, 1, 168, 192]
)

$(P
Bu, programı çalıştıran mikro işlemcinin küçük soncul olduğunu gösterir. Başka ortamlarda başka sırada da çıkabilir.
)

$(P
Bu örnekte özellikle belirtmek istediğim, birlik üyelerinin değerlerinin belirsiz olabilecekleridir. Birlikler, ancak ve ancak tek bir üyeleri ile kullanıldıklarında beklendiği gibi çalışırlar. Hangi üyesi ile kurulmuşsa, birlik nesnesinin yaşamı boyunca o üyesi ile kullanılması gerekir. O üye dışındaki üyelere erişildiğinde ne tür değerlerle karşılaşılacağı ortamdan ortama farklılık gösterebilir.
)

$(P
$(IX bswap, std.bitop) $(IX endian, std.system) Bu bölümle ilgisi olmasa da, $(C core.bitop) modülünün $(C bswap) işlevinin bu konuda yararlı olabileceğini belirtmek istiyorum. $(C bswap), kendisine verilen $(C uint)'in baytları ters sırada olanını döndürür. $(C std.system) modülündeki $(C endian) değerinden de yararlanırsak, küçük soncul bir ortamda olduğumuzu şöyle belirleyebilir ve yukarıdaki IPv4 adresini oluşturan baytları tersine çevirebiliriz:
)

---
import std.system;
import core.bitop;

// ...

    if (endian == Endian.littleEndian) {
        adres.değer = bswap(adres.değer);
    }
---

$(P
$(C Endian.littleEndian) değeri sistemin küçük soncul olduğunu, $(C Endian.BigEndian) değeri de büyük soncul olduğunu belirtir. Yukarıdaki dönüşüm sonucunda IPv4 adresinin bölümleri alışık olunan sırada çıkacaktır:
)

$(SHELL_SMALL
[192, 168, 1, 2]
)

$(P
Bunu yalnızca birliklerle ilgili bir kullanım örneği olarak gösterdim. Normalde IPv4 adresleriyle böyle doğrudan ilgilenmek yerine, o iş için kullanılan bir kütüphanenin olanaklarından yararlanmak daha doğru olur.
)

$(H5 Örnekler)

$(H6 Haberleşme protokolü)

$(P
Bazı protokollerde, örneğin ağ protokollerinde, bazı baytların anlamı başka bir üye tarafından belirleniyor olabilir. Ağ pakedinin daha sonraki bir bölümü, o üyenin değerine göre farklı bir şekilde kullanılıyor olabilir:
)

---
struct Adres {
    // ...
}

struct BirProtokol {
    // ...
}

struct BaşkaProtokol {
    // ...
}

enum ProtokolTürü { birTür, başkaTür }

struct AğPakedi {
    Adres hedef;
    Adres kaynak;
    ProtokolTürü $(HILITE tür);

    $(HILITE union) {
        BirProtokol birProtokol;
        BaşkaProtokol başkaProtokol;
    }

    ubyte[] geriKalanı;
}
---

$(P
Yukarıdaki $(C AğPakedi) yapısında hangi protokol üyesinin geçerli olduğu $(C tür)'ün değerinden anlaşılabilir, programın geri kalanı da yapıyı o değere göre kullanır.
)

$(H6 $(IX korumalı birlik) Korumalı birlik)

$(P
Korumalı birlik, $(C union) kullanımını güvenli hale getiren bir veri yapısıdır. $(C union)'ın aksine, yalnızca belirli bir anda geçerli olan üyeye erişilmesine izin verir.
)

$(P
Aşağıdaki, yalnızca $(C int) ve $(C double) türlerini kullanan basit bir korumalı birlik örneğidir. Veri saklamak için kullandığı $(C union) üyesine ek olarak bir de o birliğin hangi üyesinin geçerli olduğunu bildiren bir $(LINK2 /ders/d/object.html, $(C TypeInfo)) üyesi vardır.
)

---
$(CODE_NAME Korumalı)import std.stdio;
import std.exception;

struct Korumalı {
private:

    TypeInfo geçerliTür_;

    union {
        int i_;
        double d_;
    }

public:

    this(int değer) {
        // Bu atama, aşağıdaki nitelik işlevini çağırır
        i = değer;
    }

    // 'int' üyeyi değiştirir
    @property void i(int değer) {
        i_ = değer;
        geçerliTür_ $(HILITE = typeid(int));
    }

    // 'int' veriyi döndürür
    @property int i() const {
        enforce(geçerliTür_ $(HILITE == typeid(int)),
                "Veri 'int' değil.");
        return i_;
    }

    this(double değer) {
        // Bu atama, aşağıdaki nitelik işlevini çağırır
        d = değer;
    }

    // 'double' üyeyi değiştirir
    @property void d(double değer) {
        d_ = değer;
        geçerliTür_ $(HILITE = typeid(double));
    }

    // 'double' veriyi döndürür
    @property double d() const {
        enforce(geçerliTür_ $(HILITE == typeid(double)),
                "Veri 'double' değil." );
        return d_;
    }

    // Geçerli verinin türünü bildirir
    @property const(TypeInfo) tür() const {
        return geçerliTür_;
    }
}

unittest {
    // 'int' veriyle başlayalım
    auto k = Korumalı(42);

    // Geçerli tür 'int' olarak bildirilmelidir
    assert(k.tür == typeid(int));

    // 'int' veri okunabilmelidir
    assert(k.i == 42);

    // 'double' veri okunamamalıdır
    assertThrown(k.d);

    // 'int' yerine 'double' veri kullanalım
    k.d = 1.5;

    // Geçerli tür 'double' olarak bildirilmelidir
    assert(k.tür == typeid(double));

    // Bu sefer 'double' veri okunabilmelidir ...
    assert(k.d == 1.5);

    // ... ve 'int' veri okunamamalıdır
    assertThrown(k.i);
}
---

$(P
$(IX Variant, std.variant) $(IX Algebraic, std.variant) Bunu basit bir örnek olarak kabul edin. Kendi programlarınızda $(C std.variant) modülünde tanımlı olan $(C Algebraic) ve $(C Variant) türlerini kullanmanızı öneririm. Ek olarak, bu örnek $(LINK2 /ders/d/sablonlar.html, şablonlar) ve $(LINK2 /ders/d/katmalar.html, katmalar) gibi diğer D olanaklarından yararlanabilir ve en azından kod tekrarının önüne geçebilirdi.
)

$(P
Dikkat ederseniz, içinde tuttuğu verinin türünden bağımsız olarak $(C Korumalı) diye tek tür bulunmaktadır. (Öte yandan, şablon kullanan bir gerçekleştirme verinin türünü bir şablon parametresi olarak alabilir ve bunun sonucunda şablonun her farklı parametre değeri için kullanımının farklı bir tür olmasına neden olabilirdi.) $(C Korumalı), bunun sayesinde dizi elemanı türü olarak kullanılabilir ve bunun sonucunda da farklı türden verilerin aynı dizide bir araya getirilmeleri sağlanmış olur. Ancak, kullanıcılar yine de veriye erişmeden önce hangi verinin geçerli olduğundan emin olmak zorundadırlar. Örneğin, aşağıdaki işlev bunun için $(C Korumalı) türünün $(C tür) niteliğinden yararlanmaktadır:
)

---
$(CODE_XREF Korumalı)void main() {
    Korumalı[] dizi = [ Korumalı(1), Korumalı(2.5) ];

    foreach (değer; dizi) {
        if (değer.tür $(HILITE == typeid(int))) {
            writeln("'int' veri kullanıyoruz   : ", değer$(HILITE .i));

        } else if (değer.tür $(HILITE == typeid(double)))  {
            writeln("'double' veri kullanıyoruz: ", değer$(HILITE .d));

        } else {
            assert(0);
        }
    }
}
---

$(SHELL
'int' veri kullanıyoruz   : 1
'double' veri kullanıyoruz: 2.5
)

Macros:
        SUBTITLE=Birlikler

        DESCRIPTION=D'nin farklı türden değişkenleri aynı bellek bölgesinde depolamaya olanak veren birlik (union) olanağı

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial birlik union

SOZLER=
$(alt_duzey)
$(bayt_sirasi)
$(birlik)
$(buyuk_soncul)
$(korumali_birlik)
$(kucuk_soncul)
$(veri_yapilari)
$(yapi)
