Ddoc

$(DERS_BOLUMU $(IX Object) $(CH4 Object))

$(P
Açıkça başka bir sınıftan türetilmeyen sınıflar otomatik olarak $(C Object) adlı sınıftan türerler.
)

$(P
Sıradüzenin en üstündeki sınıf $(C Object)'ten otomatik olarak türer:
)

---
class Çalgı $(DEL : Object ) {       // ": Object" yazılmaz; otomatiktir
    // ...
}

class TelliÇalgı : Çalgı {    // dolaylı olarak Object'ten türer
    // ...
}
---

$(P
En üstteki sınıf $(C Object)'ten türediği için, altındaki bütün sınıflar da dolaylı olarak $(C Object)'ten türerler. Bu anlamda "her sınıf, $(C Object) türündendir".
)

$(P
Bu türeme sonucunda her sınıf $(C Object)'in bazı üye işlevlerini edinir:
)

$(UL
$(LI $(C toString): Nesnenin dizgi olarak ifadesi.)
$(LI $(C opEquals): Eşitlik karşılaştırması.)
$(LI $(C opCmp): Sıra karşılaştırması.)
$(LI $(C toHash): Eşleme tablosu indeks değeri.)
)

$(P
Bu işlevlerden son üçü sınıf nesnelerinin değerlerini ön plana çıkartmak ve onları eşleme tablolarında indeks türü olarak kullanmak için gereklidir.
)

$(P
Türeme yoluyla edinildikleri için bu işlevlerin türeyen tür için $(C override) anahtar sözcüğü ile tanımlanmaları gerekir.
)

$(P $(I Not: $(C Object)'ten edinilen başka üyeler de vardır. Bu bölümde yalnızca bu dört işlevini göreceğiz.)
)

$(H5 $(IX typeid) $(IX TypeInfo) $(C typeid) ve $(C TypeInfo))

$(P
$(C Object) sınıfı, $(C std) pakedinin parçası olmayan $(LINK2 http://dlang.org/phobos/object.html, $(C object)) modülünde tanımlanmıştır. Bu modül türler hakkında bilgi taşıyan $(C TypeInfo) sınıfını da tanımlar. Programın çalışması sırasında her farklı tür için farklı bir $(C TypeInfo) nesnesi vardır. $(C typeid) $(I ifadesi) belirli bir türe karşılık gelen $(C TypeInfo) nesnesine erişim sağlar. Biraz aşağıda göreceğimiz gibi, $(C TypeInfo) sınıfı türlerin eşit olup olmadıklarını belirlemek yanında türlerin özel işlevlerine (çoğu bu kitapta gösterilmeyecek olan $(C toHash), $(C postblit), vs.) de erişim sağlar.
)

$(P
$(C TypeInfo) her zaman için çalışma zamanındaki asıl tür ile ilgilidir. Örneğin, aşağıdaki $(C Kemençe) ve $(C Saz) doğrudan $(C TelliÇalgı) sınıfından ve dolaylı olarak $(C Çalgı) sınıfından türemiş olsalar da ikisinin $(C TypeInfo) nesneleri farklıdır:
)

---
class Çalgı {
}

class TelliÇalgı : Çalgı {
}

class Kemençe : TelliÇalgı {
}

class Saz : TelliÇalgı {
}

void main() {
    TypeInfo k = $(HILITE typeid)(Kemençe);
    TypeInfo s = $(HILITE typeid)(Saz);
    assert(k != s);    $(CODE_NOTE türler aynı değil)
}
---

$(P
Yukarıdaki kullanımlarda $(C typeid)'ye $(I türün kendisi) verilmektedir ($(C Kemençe) gibi). $(C typeid) diğer kullanımında $(I ifade) alır ve o ifadenin değerinin türü ile ilgili olan $(C TypeInfo) nesnesini döndürür. Örneğin, aşağıdaki işlev birbirleriyle ilgili olsalar da farklı türden olan iki parametre almaktadır:
)

---
import std.stdio;

// ...

void foo($(HILITE Çalgı) ç, $(HILITE TelliÇalgı) t) {
    const aynı_mı = (typeid(ç) == typeid(t));

    writefln("Türleri %s.", aynı_mı ? "aynı" : "aynı değil");
}

// ...

    auto a = new $(HILITE Kemençe)();
    auto b = new $(HILITE Kemençe)();
    foo(a, b);
---

$(P
Yukarıdaki $(C foo) çağrısı için gönderilen asıl parametre değerlerinin ikisi de $(C Kemençe) türünden olduklarından $(C foo) onların aynı türden olduklarını belirler:
)

$(SHELL
Türleri aynı.
)

$(P
Kendilerine verilen ifadeleri işletmeyen $(C .sizeof) ve $(C typeof)'un aksine, $(C typeid) verilen ifadeyi işletmek zorundadır:
)

---
import std.stdio;

int foo(string bilgi) {
    writefln("'%s' sırasında çağrıldı.", bilgi);
    return 0;
}

void main() {
    const s = foo("sizeof")$(HILITE .sizeof);     // foo() çağrılmaz
    alias T = $(HILITE typeof)(foo("typeof"));    // foo() çağrılmaz
    auto ti = $(HILITE typeid)(foo("typeid"));    // foo() çağrılır
}
---

$(P
Programın çıktısında görüldüğü gibi, yalnızca $(C typeid)'nin ifadesi işletilmiştir:
)

$(SHELL
'typeid' sırasında çağrıldı.
)

$(P
Bu farkın nedeni, bazı ifadelerin asıl türlerinin ancak o ifadeler işletildikten sonra bilinebilmesidir. Örneğin, aşağıdaki işlevin asıl dönüş türü aldığı parametre değerine bağlı olarak her çağrıda ya $(C Kemençe) ya da $(C Saz) olacaktır:
)

---
Çalgı foo(int i) {
    return ($(HILITE i) % 2) ? new Kemençe() : new Saz();
}
---

$(H5 $(IX toString) $(C toString))

$(P
Yapılarda olduğu gibi, $(C toString) sınıf nesnelerinin dizgi olarak kullanılmalarını sağlar:
)

---
    const saat = new Saat(20, 30, 0);
    writeln(saat);         // saat.toString()'i çağırır
---

$(P
Sınıfın $(C Object)'ten kalıtım yoluyla edindiği $(C toString) işlevi fazla kullanışlı değildir; döndürdüğü $(C string) yalnızca türün ismini içerir:
)

$(SHELL
deneme.Saat
)

$(P
Sınıfın isminden önceki bölüm, yani yukarıdaki $(C deneme), o sınıfı içeren modülün ismini belirtir. Ona bakarak, $(C Saat) sınıfının $(C deneme.d) isimli bir kaynak dosya içinde tanımlandığını anlayabiliriz.
)

$(P
Önceki bölümde olduğu gibi, anlamlı bir $(C string) üretmesi için bu işlev hemen hemen her zaman için özel olarak tanımlanır:
)

---
import std.string;

class Saat {
    override string toString() const {
        return format("%02s:%02s:%02s", saat, dakika, saniye);
    }

    // ...
}

class ÇalarSaat : Saat {
    override string toString() const {
        return format("%s ♫%02s:%02s", super.toString(),
                      alarmSaati, alarmDakikası);
    }

    // ...
}

// ...

    auto başucuSaati = new ÇalarSaat(20, 30, 0, 7, 0);
    writeln(başucuSaati);
---

$(P
Çıktısı:
)

$(SHELL
20:30:00 ♫07:00
)

$(H5 $(IX opEquals) $(C opEquals))

$(P
$(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme bölümünde) gördüğümüz gibi, bu üye işlev $(C ==) işlecinin tanımını belirler (ve dolaylı olarak $(C !=) işlecinin tanımını). İşlevin dönüş değeri nesneler eşitlerse $(C true), değillerse $(C false) olmalıdır.
)

$(P
$(B Uyarı:) Bu işlevin $(C opCmp) ile tutarlı olması gerekir; $(C true) döndürdüğü durumda $(C opCmp) da sıfır döndürmelidir.
)

$(P
Yapıların aksine, derleyici $(C a&nbsp;==&nbsp;b) gibi bir ifadeyi otomatik olarak $(C a.opEquals(b)) ifadesine dönüştürmez. İki sınıf nesnesi karşılaştırıldıklarında aşağıdaki dört adımlık algoritma uygulanır:
)

---
bool opEquals(Object a, Object b) {
    if (a is b) return true;                          // (1)
    if (a is null || b is null) return false;         // (2)
    if (typeid(a) == typeid(b)) return a.opEquals(b); // (3)
    return a.opEquals(b) && b.opEquals(a);            // (4)
}
---

$(OL

$(LI İki değişken de aynı nesneye erişim sağlıyorlarsa (veya ikisi de $(C null) iseler) eşittirler.)

$(LI Yalnızca birisi $(C null) ise eşit değildirler.)

$(LI Her iki nesne de aynı türden iseler ve o türün $(C opEquals) işlevi tanımlanmışsa  $(C a.opEquals(b)) işletilir.)

$(LI Aksi taktirde, eşit olarak kabul edilebilmeleri için eğer tanımlanmışlarsa hem $(C a.opEquals(b))'nin hem de $(C b.opEquals(a))'nın $(C true) üretmeleri gerekir.)

)

$(P
Dolayısıyla, $(C opEquals) programcı tarafından özellikle tanımlanmamışsa o sınıfın nesnelerinin değerlerine bakılmaz; iki sınıf değişkeninin aynı nesneye erişim sağlayıp sağlamadıklarına bakılır:
)

---
    auto değişken0 = new Saat(6, 7, 8);
    auto değişken1 = new Saat(6, 7, 8);

    assert(değişken0 != değişken1); // eşit değiller
                                    // (çünkü farklı nesneler)
---

$(P
Yukarıdaki koddaki iki nesne aynı parametre değerleriyle kuruldukları halde, $(C new) ile ayrı ayrı kurulmuş oldukları için iki farklı nesnedir. Bu yüzden, onlara erişim sağlayan $(C değişken0) ve $(C değişken1) değişkenleri $(C Object)'in gözünde $(I eşit değillerdir).
)

$(P
Öte yandan, aynı nesneye erişim sağladıkları için şu iki değişken $(I eşittir):
)

---
    auto ortak0 = new Saat(9, 10, 11);
    auto ortak1 = ortak0;

    assert(ortak0 == ortak1);       // eşitler
                                    // (çünkü aynı nesne)
---

$(P
Bazen nesneleri böyle kimliklerine göre değil, değerlerine göre karşılaştırmak isteriz. Örneğin $(C değişken0)'ın ve $(C değişken1)'in erişim sağladıkları nesnelerin değerlerinin eşit olmalarına bakarak, $(C ==) işlecinin $(C true) üretmesini bekleyebiliriz.
)

$(P
Yapılardan farklı olarak, ve $(C Object)'ten kalıtımla edinildiği için, $(C opEquals) işlevinin parametresi $(C Object)'tir. O yüzden, bu işlevi kendi sınıfımız için tanımlarken parametresini $(C Object) olarak yazmamız gerekir:
)

---
class Saat {
    override bool opEquals($(HILITE Object o)) const {
        // ...
    }

    // ...
}
---

$(P
Kendimiz $(C Object) olarak doğrudan kullanmayacağımız için bu parametrenin ismini kullanışsız olarak $(C o) diye seçmekte bir sakınca görmüyorum. İlk ve çoğu durumda da tek işimiz, onu bir tür dönüşümünde kullanmak olacak.
)

$(P
$(C opEquals)'a parametre olarak gelen nesne, kod içinde $(C ==) işlecinin sağ tarafında yazılan nesnedir. Örneğin şu iki satır birbirinin eşdeğeridir:
)

---
    değişken0 == değişken1;    // o, değişken1'i temsil eder
---

$(P
Bu işleçteki amaç bu sınıftan iki nesneyi karşılaştırmak olduğu için, işlevi tanımlarken yapılması gereken ilk şey, parametre olarak gelen $(C Object)'in türünü kendi sınıfımızın türüne dönüştürmektir. Sağdaki nesneyi değiştirmek gibi bir niyetimiz de olmadığı için, tür dönüşümünde $(C const) belirtecini kullanmak da uygun olur:
)

---
    override bool opEquals(Object o) const {
        const sağdaki = cast(const Saat)o;

        // ...
    }
---

$(P
Hatırlayacağınız gibi, tür dönüşümü için $(C std.conv.to) işlevi de kullanılabilir:
)

---
import std.conv;
// ...
        const sağdaki = to!(const Saat)(o);
---

$(P
Yukarıdaki tür dönüşümü işlemi ya $(C sağdaki)'nin türünü bu şekilde $(C const&nbsp;Saat) olarak belirler ya da dönüşüm uyumsuzsa $(C null) üretir.
)

$(P
Burada karar verilmesi gereken önemli bir konu, sağdaki nesnenin türünün bu nesnenin türü ile aynı olmadığında ne olacağıdır. Sağdaki nesnenin tür dönüşümü sonucunda $(C null) üretmesi, sağdaki nesnenin aslında bu türe dönüştürülemediği anlamına gelir.
)

$(P
Ben nesnelerin eşit kabul edilebilmeleri için bu dönüşümün başarılı olması gerektiğini varsayacağım. Bu yüzden eşitlik karşılaştırmalarında öncelikle $(C sağdaki)'nin $(C null) olmadığına bakacağım. Zaten $(C null) olduğu durumda $(C sağdaki)'nin üyelerine erişmek hatalıdır:
)

---
class Saat {
    int saat;
    int dakika;
    int saniye;

    override bool opEquals(Object o) const {
        const sağdaki = cast(const Saat)o;

        return ($(HILITE sağdaki) &&
                (saat == sağdaki.saat) &&
                (dakika == sağdaki.dakika) &&
                (saniye == sağdaki.saniye));
    }

    // ...
}
---

$(P
İşlevin bu tanımı sayesinde, $(C ==) işleci $(C Saat) nesnelerini artık değerlerine göre karşılaştırır:
)

---
    auto değişken0 = new Saat(6, 7, 8);
    auto değişken1 = new Saat(6, 7, 8);

    assert(değişken0 == değişken1); // artık eşitler
                                    // (çünkü değerleri aynı)
---

$(P
$(C opEquals)'ı tanımlarken, eğer varsa ve nesnelerin eşit kabul edilmeleri için gerekliyse, üst sınıfın üyelerini de unutmamak gerekir. Örneğin alt sınıf olan $(C ÇalarSaat)'in nesnelerini karşılaştırırken, $(C Saat)'ten kalıtımla edindiği parçaları da karşılaştırmak anlamlı olur:
)

---
class ÇalarSaat : Saat {
    int alarmSaati;
    int alarmDakikası;

    override bool opEquals(Object o) const {
        const sağdaki = cast(const ÇalarSaat)o;

        return (sağdaki &&
                (alarmSaati == sağdaki.alarmSaati) &&
                (alarmDakikası == sağdaki.alarmDakikası) &&
                $(HILITE super.opEquals(o)));
    }

    // ...
}
---

$(P
Oradaki ifade $(C super)'in $(C opEquals) işlevini çağırır ve eşitlik kararında onun da sonucunu kullanmış olur. Onun yerine daha kısaca $(C super&nbsp;==&nbsp;o) da yazılabilir. Ancak, öyle yazıldığında yukarıdaki dört adımlı algoritma tekrar işletileceğinden kod biraz daha yavaş olabilir.
)

$(H5 $(IX opCmp) $(C opCmp))

$(P
Sınıf nesnelerini sıralamak için kullanılır. $(C <), $(C <=), $(C >), ve $(C >=) işleçlerinin tanımı için perde arkasında bu işlev kullanılır.
)

$(P
Bu işlevin dönüş değerini $(C <) işleci üzerinde düşünebilirsiniz: Soldaki nesne önce olduğunda eksi bir değer, sağdaki nesne önce olduğunda artı bir değer, ikisi eşit olduklarında sıfır döndürmelidir.
)

$(P
$(B Uyarı:) Bu işlevin $(C opEquals) ile tutarlı olması gerekir; sıfır döndürdüğü durumda $(C opEquals) da $(C true) döndürmelidir.
)

$(P
$(C toString)'in ve $(C opEquals)'un aksine, bu işlevin $(C Object) sınıfından kalıtımla edinilen bir davranışı yoktur. Tanımlanmadan kullanılırsa hata atılır:
)

---
    auto değişken0 = new Saat(6, 7, 8);
    auto değişken1 = new Saat(6, 7, 8);

    assert(değişken0 <= değişken1);     $(CODE_NOTE Hata atılır)
---

$(SHELL
object.Exception: need opCmp for class deneme.Saat
)

$(P
Yukarıda $(C opEquals) için söylenenler bu işlev için de geçerlidir: Sağdaki nesnenin türünün bu nesnenin türüne eşit olmadığı durumda hangisinin daha önce sıralanması gerektiği konusuna bir şekilde karar vermek gerekir.
)

$(P
Bunun en kolayı bu kararı derleyiciye bırakmaktır, çünkü derleyici türler arasında zaten genel bir sıralama belirler. Türler aynı olmadıklarında bu sıralamadan yararlanmanın yolu, $(C typeid)'lerinin $(C opCmp) işlevinden yararlanmaktır:
)

---
class Saat {
    int saat;
    int dakika;
    int saniye;

    override int opCmp(Object o) const {
        /* Türler aynı olmadıklarında türlerin genel
         * sıralamasından yararlanıyoruz. */
        if (typeid(this) != typeid(o)) {
            return typeid(this).opCmp(typeid(o));
        }

        const sağdaki = cast(const Saat)o;
        /* sağdaki'nin null olup olmadığına bakmaya gerek yok
         * çünkü buraya gelinmişse 'o' ile aynı türdendir. */

        if (saat != sağdaki.saat) {
            return saat - sağdaki.saat;

        } else if (dakika != sağdaki.dakika) {
            return dakika - sağdaki.dakika;

        } else {
            return saniye - sağdaki.saniye;
        }
    }

    // ...
}
---

$(P
Yukarıdaki tanım, nesneleri sıralama amacıyla karşılaştırırken öncelikle türlerinin uyumlu olup olmadıklarına bakıyor. Eğer uyumlu iseler saat bilgisini dikkate alıyor; saatler eşitlerse dakikalara, onlar da eşitlerse saniyelere bakıyor.
)

$(P
Ne yazık ki, bu işlevin bu gibi karşılaştırmalarda daha güzel veya daha etkin bir yazımı yoktur. Eğer daha uygun bulursanız, if-else-if zinciri yerine onun eşdeğeri olan üçlü işleci de kullanabilirsiniz:
)

---
    override int opCmp(Object o) const {
        if (typeid(this) != typeid(o)) {
            return typeid(this).opCmp(typeid(o));
        }

        const sağdaki = cast(const Saat)o;

        return (saat != sağdaki.saat
                ? saat - sağdaki.saat
                : (dakika != sağdaki.dakika
                   ? dakika - sağdaki.dakika
                   : saniye - sağdaki.saniye));
    }
---

$(P
Bu işlevi bir alt sınıf için tanımlarken ve karşılaştırmada önemi varsa, üst sınıfını da unutmamak gerekir. Örneğin, aşağıdaki $(C ÇalarSaat.opCmp) sıralama kararında öncelikle üst sınıfından yararlanıyor:
)

---
class ÇalarSaat : Saat {
    override int opCmp(Object o) const {
        const sağdaki = cast(const ÇalarSaat)o;

        const int üstSonuç = $(HILITE super.opCmp(o));

        if (üstSonuç != 0) {
            return üstSonuç;

        } else if (alarmSaati != sağdaki.alarmSaati) {
            return alarmSaati - sağdaki.alarmSaati;

        } else {
            return alarmDakikası - sağdaki.alarmDakikası;
        }
    }

    // ...
}
---

$(P
Üst sınıfın sıfırdan farklı bir değer döndürmesi durumunda, iki nesnenin sıraları ile ilgili yeterli bilgi edinilmiştir; ve o değer döndürülür. Yukarıdaki kodda, alt sınıfın üyelerine ancak üst sınıf parçaları eşit çıktığında bakılmaktadır.
)

$(P
Artık bu türün nesneleri sıralama karşılaştırmalarında kullanılabilir:
)

---
    auto çs0 = new ÇalarSaat(8, 0, 0, 6, 30);
    auto çs1 = new ÇalarSaat(8, 0, 0, 6, 31);

    assert(çs0 < çs1);
---

$(P
O kodda diğer bütün üyeleri eşit olduğu için, $(C çs0) ve $(C çs1)'in nasıl sıralanacaklarını en son bakılan alarm dakikası belirler.
)

$(P
Bu işlev yalnızca kendi yazdığımız kodlarda kullanılmak için değildir. Programda kullandığımız kütüphaneler ve dil olanakları da bu işlevi çağırabilir. Örneğin bir dizi içindeki nesnelerin $(C sort) ile sıralanmalarında, veya sınıfın bir eşleme tablosunda indeks türü olarak kullanılmasında da perde arkasında bu işlevden yararlanılır.
)

$(H6 Dizgi türünden olan üyeler için $(C opCmp))

$(P
Dizgi türündeki üyeler için $(C opCmp) işlevini eksi, sıfır, veya artı döndürecek şekilde uzun uzun şöyle yazabilirsiniz:
)

---
import std.exception;

class Öğrenci {
    string isim;

    override int opCmp(Object o) const {
        const sağdaki = cast(Öğrenci)o;
        enforce(sağdaki);

        if (isim < sağdaki.isim) {
            return -1;

        } else if (isim > sağdaki.isim) {
            return 1;

        } else {
            return 0;
        }
    }

    // ...
}
---

$(P
Onun yerine, $(C std.algorithm) modülünde tanımlanmış olan ve aynı karşılaştırmayı daha hızlı olarak gerçekleştiren $(C cmp) işlevini de kullanabilirsiniz:
)

---
import std.algorithm;

class Öğrenci {
    string isim;

    override int opCmp(Object o) const {
        const sağdaki = cast(Öğrenci)o;
        enforce(sağdaki);

        return cmp(isim, sağdaki.isim);
    }

    // ...
}
---

$(P
Bu türün, kendisiyle uyumsuz olan türlerle sıra karşılaştırılmasında kullanılmasına izin vermediğine dikkat edin. Bu denetimi $(C Object)'ten $(C Öğrenci)'ye tür dönüşümünün başarılı olmasına $(C enforce) ile bakarak sağlıyor.
)

$(H5 $(IX toHash) $(C toHash))

$(P
Bu işlev, sınıfın eşleme tablolarında indeks türü olarak kullanılabilmesini sağlar. Eşleme tablosunun eleman türü olarak kullanıldığı durumda bir etkisi yoktur.
)

$(P
$(B Uyarı:) Yalnızca bu işlevi tanımlamak yetmez. Bu işlevin eşleme tablolarında doğru olarak kullanılabilmesi için $(C opEquals) ve $(C opCmp) işlevlerinin de birbirleriyle tutarlı olarak tanımlanmış olmaları gerekir.
)

$(H6 $(IX eşleme tablosu) Eşleme tablosu indeks değerleri)

$(P
Eşleme tabloları eleman erişimini çok hızlı şekilde gerçekleştiren veri yapılarıdır. Üstelik bunu, tabloda ne kadar eleman bulunduğundan bağımsız olarak yapabilirler. ($(I Not: Her şeyin olduğu gibi bu hızın da bir bedeli vardır: elemanları sırasız olarak tutmak zorundadırlar, ve kesinlikle gereken miktardan daha fazla bellek kullanıyor olabilirler.))
)

$(P
Eşleme tablolarının bu hızı, indeks olarak kullanılan türü önce $(I hash) denen bir tamsayı değere çevirmelerinden kaynaklanır. Bu tamsayıyı kendilerine ait bir dizinin indeksi olarak kullanırlar.
)

$(P
Bu yöntemin hızdan başka bir yararı, tamsayıya dönüştürülebilen her türün eşleme tablosu indeks türü olarak kullanılabilmesidir.
)

$(P
$(C toHash), sınıf nesnelerinin bu amaç için indeks değerleri döndürmelerini sağlar.
)

$(P
Bu sayede, pek mantıklı olmasa da, $(C Saat) türünü bile indeks olarak kullanabiliriz:
)

---
    string[$(HILITE Saat)] zamanİsimleri;

    zamanİsimleri[new Saat(12, 0, 0)] = "öğleni gösteren saat";
---

$(P
$(C Object)'ten kalıtım yoluyla edinilen $(C toHash) işlevi, farklı nesneler için farklı indeks değerleri üretecek şekilde tanımlanmıştır. Bu, $(C opEquals)'un farklı nesnelerin eşit olmadıklarını kabul etmesine benzer.
)

$(P
Yukarıdaki kod $(C Saat) sınıfı için özel bir $(C toHash) işlevi tanımlanmamış olsa bile derlenir; ama istediğimiz gibi çalışmaz. Yukarıdaki tabloya eklenmiş olan $(C Saat) nesnesi ile aynı değere sahip olan, ama ondan farklı bir $(C Saat) nesnesi ile erişmek istesek; doğal olarak tablodaki "öğleni gösteren saat" değerini bulmayı bekleriz:
)

---
    if (new Saat(12, 0, 0) in zamanİsimleri) {
        writeln("var");

    } else {
        writeln("yok");
    }
---

$(P
Ne yazık ki, oradaki $(C in) işleci $(C false) döndürür; yani bu nesnenin tabloda bulunmadığını belirtir:
)

$(SHELL
yok
)

$(P
Bunun nedeni, yerleştirilirken kullanılan nesne ile erişirken kullanılan nesnenin $(C new) ile ayrı ayrı oluşturulmuş olmalarıdır; yani ikisi farklı nesnelerdir.
)

$(P
Dolayısıyla; $(C Object)'ten kalıtımla edinilen $(C toHash), eşleme tablolarında indeks değeri olarak kullanılmaya çoğu durumda elverişli değildir. $(C toHash)'i, bir tamsayı indeks döndürecek şekilde bizim yazmamız gerekir.
)

$(H6 $(C toHash) için seçilecek üyeler)

$(P
İndeks değeri, nesnenin üyeleri kullanılarak hesaplanır. Ancak, her üye bu indeks hesabına uygun değildir.
)

$(P
Bunun için seçilecek üyeler, nesneyi diğer nesnelerden ayırt etmeye yarayan üyeler olmalıdır. Örneğin $(C Öğrenci) gibi bir sınıfın $(C isim) ve $(C soyad) üyelerinin ikisi birden nesneleri ayırt etmek için kullanılabilir; çünkü bu iki üyenin her nesnede farklı olduğunu düşünebiliriz. (İsim benzerliklerini gözardı ediyorum.)
)

$(P
Öte yandan, $(C Öğrenci) sınıfının $(C notlar) dizisi uygun değildir; çünkü hem birden fazla nesnede aynı not değerleri bulunabilir; hem de aynı öğrencinin notları zamanla değişebilir.
)

$(H6 İndeks değerinin hesaplanması)

$(P
İndeks değerinin hesabı eşleme tablosunun hızını doğrudan etkiler. Üstelik, her hesap her çeşit veri üzerinde aynı derece etkili değildir. Uygun hesaplama yöntemleri bu kitabın kapsamı dışında kaldığı için bu konunun ayrıntısına girmeyeceğim ve genel bir ilke vermekle yetineceğim: Genel olarak, değerlerinin farklı oldukları kabul edilen nesnelerin farklı indeks değerlerinin olması etkinlik açısından iyidir. Farklı değerli nesnelerin aynı indeks değerini üretmeleri hata değildir; performans açısından istenmeyen bir durumdur.
)

$(P
$(C Saat) nesnelerinin farklı kabul edilebilmeleri için bütün üyelerinin değerlerinin önemli olduğunu düşünebiliriz. Bu yüzden, indeks değeri olarak o üç üyeden yararlanılarak elde edilen bir tamsayı değer kullanılabilir. Eğer indeks değeri olarak gece yarısından kaç saniye ötede olunduğu kullanılırsa, herhangi bir üyesi değişik olan iki nesnenin indeks değerlerinin farklı olacağı garanti edilmiş olur:
)

---
class Saat {
    int saat;
    int dakika;
    int saniye;

    override size_t toHash() const {
        // Saatte 3600 ve dakikada 60 saniye bulunduğu için:
        return (3600 * saat) + (60 * dakika) + saniye;
    }

    // ...
}
---

$(P
Eşleme tablolarında indeks türü olarak $(C Saat) kullanıldığında artık programcı tarafından tanımlanmış olan bu $(C toHash) kullanılır. Bunun sonucunda, yukarıdaki kodda $(C new) ile farklı olarak kurulmuş olan iki nesnenin saat, dakika, ve saniye değerleri aynı olduğundan eşleme tablosunda aynı indeks değeri üretilir.
)

$(P
Programın çıktısı artık beklenen sonucu verir:
)

$(SHELL
var
)

$(P
Önceki işlevlerde olduğu gibi, üst sınıfı unutmamak gerekebilir. Örneğin, $(C ÇalarSaat)'in $(C toHash) işlevi $(C Saat)'inkinden şöyle yararlanabilir:
)

---
class ÇalarSaat : Saat {
    int alarmSaati;
    int alarmDakikası;

    override size_t toHash() const {
        return $(HILITE super.toHash()) + alarmSaati + alarmDakikası;
    }

    // ...
}
---

$(P
$(I Not: Yukarıdaki hesabı bir örnek olarak kabul edin. Tamsayı değerleri toplayarak üretilen indeks değerleri genelde eşleme tablosu performansı açısından iyi değildir.)
)

$(P
D; kesirli sayılar, diziler, ve yapı türleri için çoğu duruma uygun olan indeks değeri algoritmaları kullanır. Bu algoritmalardan programcı da yararlanabilir.
)

$(P
$(IX getHash) Kulağa karmaşık geldiği halde aslında çok kısaca yapmamız gereken; önce $(C typeid)'yi üye ile, sonra da $(C typeid)'nin döndürdüğü nesnenin $(C getHash) üye işlevini üyenin adresi ile çağırmaktır. Hepsinin dönüş değeri, o üyeye uygun bir indeks değeridir. Bu; kesirli sayılar, diziler ve yapılar için hep aynı şekilde yazılır.
)

$(P
Öğrencinin ismini bir $(C string) üyesinde tutan ve eşleme tabloları için indeks değeri olarak bundan yararlanmak isteyen bir sınıfın $(C toHash) işlevi şöyle yazılabilir:
)

---
class Öğrenci {
    string isim;

    override size_t toHash() const {
        return typeid(isim).getHash(&isim);
    }

    // ...
}
---

$(H6 Yapılar için $(C toHash))

$(P
Yapılar değer türleri olduklarından onların indeks değerleri zaten otomatik olarak ve etkin bir algoritmayla hesaplanır. O algoritma nesnenin bütün üyelerini dikkate alır.
)

$(P
Eğer herhangi bir nedenle, örneğin bir öğrenci yapısının not bilgisini dışarıda bırakacak şekilde kendiniz yazmak isterseniz; $(C toHash)'i yapılar için de tanımlayabilirsiniz.
)

$(PROBLEM_COK

$(PROBLEM
Elimizde renkli noktaları ifade eden bir sınıf olsun:

---
enum Renk { mavi, yeşil, kırmızı }

class Nokta {
    int x;
    int y;
    Renk renk;

    this(int x, int y, Renk renk) {
        this.x = x;
        this.y = y;
        this.renk = renk;
    }
}
---

$(P
Bu sınıfın $(C opEquals) işlevini rengi gözardı edecek şekilde yazın. Şu iki nokta, renkleri farklı olduğu halde eşit çıksınlar. Yani $(C assert) denetimi doğru çıksın:
)

---
    // Renkleri farklı
    auto maviNokta = new Nokta(1, 2, Renk.mavi);
    auto yeşilNokta = new Nokta(1, 2, Renk.yeşil);

    // Yine de eşitler
    assert(maviNokta == yeşilNokta);
---

)

$(PROBLEM
Aynı sınıf için $(C opCmp) işlevini öncelikle $(C x)'e sonra $(C y)'ye bakacak şekilde yazın. Aşağıdaki $(C assert) denetimleri doğru çıksın:

---
    auto kırmızıNokta1 = new Nokta(-1, 10, Renk.kırmızı);
    auto kırmızıNokta2 = new Nokta(-2, 10, Renk.kırmızı);
    auto kırmızıNokta3 = new Nokta(-2,  7, Renk.kırmızı);

    assert(kırmızıNokta1 < maviNokta);
    assert(kırmızıNokta3 < kırmızıNokta2);

    /* Mavi renk daha önce olduğu halde, renk gözardı
     * edildiğinden maviNokta yeşilNokta'dan daha önce
     * olmamalıdır. */
    assert(!(maviNokta < yeşilNokta));
---

$(P
Bu sınıfın $(C opCmp) işlevini de yukarıda $(C Öğrenci) sınıfında olduğu gibi uyumsuz türlerin karşılaştırılmalarını desteklemeyecek biçimde gerçekleştirebilirsiniz.
)

)

$(PROBLEM
Üç noktayı bir araya getiren başka bir sınıf olsun:

---
class ÜçgenBölge {
    Nokta[3] noktalar;

    this(Nokta bir, Nokta iki, Nokta üç) {
        noktalar = [ bir, iki, üç ];
    }
}
---

$(P
O sınıf için $(C toHash) işlevini bütün noktalarını kullanacak biçimde yazın. Yine aşağıdaki $(C assert)'ler doğru çıksın:
)

---
    /* bölge1 ve bölge2, değerleri aynı olan farklı noktalarla
     * kuruluyorlar. (Hatırlatma: maviNokta ve yeşilNokta
     * değer olarak eşit kabul ediliyorlardı.) */
    auto bölge1 =
        new ÜçgenBölge(maviNokta, yeşilNokta, kırmızıNokta1);
    auto bölge2 =
        new ÜçgenBölge(yeşilNokta, maviNokta, kırmızıNokta1);

    // Yine de eşitler
    assert(bölge1 == bölge2);

    // Bir eşleme tablosu
    double[ÜçgenBölge] bölgeler;

    // bölge1 ile indeksleniyor
    bölgeler[bölge1] = 1.25;

    // bölge2 ile de aynı veriye erişiliyor
    assert(bölge2 in bölgeler);
    assert(bölgeler[bölge2] == 1.25);
---

$(P
$(C toHash) tanımlandığında $(C opEquals) ve $(C opCmp) işlevlerinin de tanımlanmaları gerektiğini unutmayın.
)

)

)


Macros:
        SUBTITLE=Object

        DESCRIPTION=D dilinde her sınıfın otomatik olarak türediği üst sınıf, Object

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar kullanıcı türleri Object üst sınıf

SOZLER=
$(cokme)
$(degisken)
$(esleme_tablosu)
$(ifade)
$(indeks)
$(islec)
$(nesne)
$(siraduzen)
$(ust_sinif)
$(uye_islev)
