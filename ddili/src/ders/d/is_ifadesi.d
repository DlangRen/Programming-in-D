Ddoc

$(DERS_BOLUMU $(IX is, ifade) $(CH4 is) İfadesi)

$(P
Bu ifade, daha önce $(LINK2 /ders/d/null_ve_is.html, $(CH4 null) değeri ve $(CH4 is) işleci bölümünde) gördüğümüz $(C is) işlecinden anlam ve yazım açısından farklıdır:
)

---
    a is b            // daha önce gördüğümüz is işleci
    is (/* ... */)    // is ifadesi
---

$(P
Bu bölümün konusu olan $(C is) ifadesi derleme zamanında işletilir ve parantez içindeki ifadeye bağlı olan bir değer üretir. Ürettiği değerin türü $(C int)'tir; koşul geçerli olduğunda 1, geçersiz olduğunda 0 değerini alır.
)

$(P
$(C is)'in aldığı koşul bir mantıksal ifade değildir ama $(C is)'in kendi değeri bir mantıksal ifadede kullanılmaya elverişlidir. Örneğin $(C if) deyimiyle, ve derleme zamanında işletildiği için daha da uygun olarak $(C static if) deyimiyle kullanılabilir.
)

$(P
Aldığı koşul türlerle ilgilidir ve bir kaç özel biçimden birisi olarak yazılmak zorundadır. En çok şablon parametrelerini denetlemede ve şablon parametre türleriyle ilgili bilgi toplamada yararlıdır.
)

$(H5 $(C is ($(I Tür))))

$(P
$(C Tür)'ün $(I anlamsal) olarak geçerli bir tür olup olmadığını denetler.
)

$(P
$(C is)'in bu kullanımı için bu noktada tek başına örnekler bulmak oldukça zor. Bunun yararını daha sonraki bölümlerde şablon parametreleri ile kullanırken göreceğiz.
)

---
    static if (is (int)) {
        writeln("geçerli");

    } else {
        writeln("geçersiz");
    }
---

$(P
Yukarıdaki koşulda kullanılan $(C int), geçerli bir türdür:
)

$(SHELL_SMALL
geçerli
)

$(P
Başka bir örnek olarak, eşleme tablosu indeks türü olarak $(C void) kullanmak geçersiz olduğu için bu örnekte $(C else) bloğu işletilir:
)

---
    static if (is (string[void])) {
        writeln("geçerli");

    } else {
        writeln("geçersiz");
    }
---

$(SHELL_SMALL
geçersiz
)


$(H5 $(C is ($(I Tür Takmaİsim))))

$(P
Yukarıdaki ile aynı şekilde çalışır. Ek olarak, koşul geçerli olduğunda $(C Takmaİsim)'i türün yeni takma ismi olarak tanımlar:
)

---
    static if (is (int Yeniİsim)) {
        writeln("geçerli");
        Yeniİsim değişken = 42; // int ve Yeniİsim aynı anlamda

    } else {
        writeln("geçersiz");
    }
---

$(P
Takma ismin bu şekilde $(C is) ifadesinin içinde tanımlanabilmesi, daha sonra göreceğimiz karmaşık $(C is) ifadelerinde yararlıdır.
)

$(H5 $(C is ($(I Tür) : $(I ÖzelTür))))

$(P
$(C Tür)'ün belirtilen özel türe otomatik olarak dönüşüp dönüşemediğini denetler.
)

$(P
$(LINK2 /ders/d/tur_donusumleri.html, Tür Dönüşümleri bölümünde) gördüğümüz temel tür dönüşümlerini, veya $(LINK2 /ders/d/tureme.html, Türeme bölümünde) gördüğümüz "bu alt sınıf, o üst sınıfın türündendir" ilişkilerini denetlemede kullanılır.
)

---
import std.stdio;

interface Saat {
    void zamanıOku();
}

class ÇalarSaat : Saat {
    override void zamanıOku() {
        writeln("10:00");
    }
}

void birİşlev(T)(T nesne) {
    static if ($(HILITE is (T : Saat))) {
        // Eğer buraya geldiysek, şablon parametresi olan T
        // Saat yerine kullanılabilen bir türdür
        writeln("bu bir Saat; zamanı söyleyebiliriz");
        nesne.zamanıOku();

    } else {
        writeln("bu bir Saat değil");
    }
}

void main() {
    auto değişken = new ÇalarSaat;
    birİşlev(değişken);
    birİşlev(42);
}
---

$(P
O kod, $(C birİşlev) şablonu $(C Saat)'e dönüşebilen bir tür ile çağrıldığında $(C nesne)'nin $(C zamanıOku) işlevini de çağırmaktadır. Tür $(C int) olduğunda ise $(C else) bloğu derlenmektedir:
)

$(SHELL_SMALL
bu bir Saat; zamanı söyleyebiliriz     $(SHELL_NOTE ÇalarSaat için)
10:00                                  $(SHELL_NOTE ÇalarSaat için)
bu bir Saat değil                      $(SHELL_NOTE int için)
)

$(H5 $(C is ($(I Tür Takmaİsim) : $(I ÖzelTür))))

$(P
Yukarıdakiyle aynı şekilde çalışır. Ek olarak, koşul geçerli olduğunda $(C Takmaİsim)'i koşulu sağlayan türün yeni takma ismi olarak tanımlar.
)

$(H5 $(C is ($(I Tür) == $(I ÖzelTür))))

$(P
$(C Tür)'ün belirtilen özel türün $(I aynısı) olup olmadığını, veya $(I aynı belirtece sahip) olup olmadığını denetler.
)

$(H6 $(I Aynı tür) anlamında)

$(P
Yukarıdaki örnek kodu değiştirsek ve $(C :) yerine $(C ==) kullansak, bu sefer $(C ÇalarSaat) için de geçersiz olacaktır:
)

---
    static if (is (T $(HILITE ==) Saat)) {
        writeln("bu bir Saat; zamanı söyleyebiliriz");
        nesne.zamanıOku();

    } else {
        writeln("bu bir Saat değil");
    }
---

$(P
$(C ÇalarSaat) $(C Saat)'ten türediği için bir $(C Saat)'tir, ama $(C Saat)'in aynısı değildir. O yüzden koşul hem $(C ÇalarSaat) için, hem de $(C int) için geçersizdir:
)

$(SHELL_SMALL
bu bir Saat değil
bu bir Saat değil
)

$(H6 $(I Aynı belirtece sahip) anlamında)

$(P
$(C ÖzelTür) yerine bir belirteç kullanıldığında türün o belirtece uyup uymadığını denetler. Bu kullanımda belirteç olarak aşağıdaki anahtar sözcükler kullanılabilir (bu sözcüklerden bazılarını daha sonraki bölümlerde göreceğiz):
)

$(UL
$(LI $(IX struct, is ifadesi) $(C struct))
$(LI $(IX union, is ifadesi) $(C union))
$(LI $(IX class, is ifadesi) $(C class))
$(LI $(IX interface, is ifadesi) $(C interface))
$(LI $(IX enum, is ifadesi) $(C enum))
$(LI $(IX function, is ifadesi) $(C function))
$(LI $(IX delegate, is ifadesi) $(C delegate))
$(LI $(IX const, is ifadesi) $(C const))
$(LI $(IX immutable, is ifadesi) $(C immutable))
$(LI $(IX shared, is ifadesi) $(C shared))
)

---
void birİşlev(T)(T nesne) {
    static if (is (T == class)) {
        writeln("bu bir sınıf türü");

    } else static if (is (T == enum)) {
        writeln("bu bir enum");

    } else static if (is (T == const)) {
        writeln("bu 'const' bir tür");

    } else {
        writeln("bu başka bir tür");
    }
}
---

$(P
İşlev şablonları çağrıldıkları türe göre değişik davranacak şekilde kodlanabilirler. Koşulun değişik bloklarının etkinleştiğini göstermek için şöyle deneyebiliriz:
)

---
    auto değişken = new ÇalarSaat;
    birİşlev(değişken);

    // (enum HaftaGünleri biraz aşağıda tanımlanıyor)
    birİşlev(HaftaGünleri.Pazartesi);

    const double sayı = 1.2;
    birİşlev(sayı);

    birİşlev(42);
---

$(P
Çıktısı:
)

$(SHELL_SMALL
bu bir sınıf türü
bu bir enum
bu 'const' bir tür
bu başka bir tür
)

$(H5 $(C is ($(I Tür isim) == $(I Belirteç))))

$(P
$(IX super, is ifadesi)
$(IX return, is ifadesi)
$(IX __parameters, is ifadesi)
Yukarıdaki ile aynı şekilde çalışır. Ek olarak, koşul geçerli olduğunda $(C isim)'i duruma göre farklı anlamlarda tanımlar. $(C isim), yukarıdaki takma isimli kullanımlardaki gibi doğrudan türün takma ismi olabileceği gibi, belirtece bağlı olarak başka bir bilgi de olabilir:
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr>	<th style="padding-left:1em; padding-right:1em;" scope="col">$(C Belirteç)</th>
<th scope="col">$(C isim)'in anlamı</th>

</tr>

<tr>	<td>$(C struct)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

<tr>	<td>$(C union)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

<tr>	<td>$(C class)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

<tr>	<td>$(C interface)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

<tr>	<td>$(C super)</td>
<td>üst tür ve arayüzlerden oluşan $(I çokuzlu)</td>
</tr>

<tr>	<td>$(C enum)</td>
<td>$(C enum)'un gerçekleştirildiği $(I temel tür)</td>
</tr>

<tr>	<td>$(C function)</td>
<td>işlev parametrelerinden oluşan $(I çokuzlu)</td>
</tr>

<tr>	<td>$(C delegate)</td>
<td>$(C delegate)'in $(I türü)</td>
</tr>

<tr>	<td>$(C return)</td>
<td>işlevin, $(C delegate)'in, veya işlev göstergesinin dönüş $(I türü)</td>
</tr>

<tr>	<td>$(C __parameters)</td>
<td>işlevin, $(C delegate)'in, veya işlev göstergesinin parametrelerinden oluşan $(I çokuzlu)</td>
</tr>

<tr>	<td>$(C const)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

<tr>	<td>$(C immutable)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

<tr>	<td>$(C shared)</td>
<td><i>koşulu sağlayan tür</i></td>
</tr>

</table>

$(P
Bu olanağın nasıl çalıştığını göstermek için önce bazı türler tanımlayalım:
)

---
struct Nokta {
    // ...
}

interface Saat {
    // ...
}

class ÇalarSaat : Saat {
    // ...
}

enum HaftaGünleri {
    Pazartesi, Salı, Çarşamba, Perşembe, Cuma,
    Cumartesi, Pazar
}

char foo(double kesirli, int tamsayı, Saat saat) {
    return 'a';
}
---

$(P
$(C is) ifadesinin bu değişik türlerle kullanımlarını göstermek için aşağıdaki gibi bir işlev şablonu yazılabilir. İşlevin çağrıldığı türlerin, nesnelerin, ve $(C isim)'in ne anlamlara geldiklerini açıklama satırları olarak yazdım:
)

---
void birİşlev(T)(T nesne) {
    static if (is (T YerelTür == struct)) {
        writefln("\n--- struct ---");
        // T ve YerelTür aynı anlamdadır; 'nesne', bu işleve
        // gelen yapı nesnesidir

        writeln("Yeni bir ", YerelTür.stringof,
                " nesnesini kopyalayarak oluşturuyorum");
        YerelTür yeniNesne = nesne;
    }

    static if (is (T üstTürler == super)) {
        writeln("\n--- super ---");
        // 'üstTürler' çokuzlusu bütün üst türleri içerir;
        // 'nesne', bu işleve gelen sınıf nesnesidir

        writeln(T.stringof, " sınıfının ", üstTürler.length,
                " adet üst türü var");

        writeln("hepsi birden: ", üstTürler.stringof);
        writeln("en üstteki: ", üstTürler[0].stringof);
    }

    static if (is (T AsılTür == enum)) {
        writeln("\n--- enum ---");
        // 'AsılTür', enum değerlerini gerçekleştirmek için
        // kullanılan asıl türdür; 'nesne', bu işleve gelen
        // enum değeridir

        writeln(T.stringof, " enum türü, perde arkasında ",
                AsılTür.stringof,
                " olarak gerçekleştirilmiştir");
    }

    static if (is (T DönüşTürü == return)) {
        writeln("\n--- return ---");
        // 'DönüşTürü', işlevin dönüş türüdür; bu işleve
        // parametre olarak gelen 'nesne', bir işlev
        // göstergesidir

        writeln("Bu, dönüş türü ", DönüşTürü.stringof,
                " olan bir işlev:");
        writeln("  ", T.stringof);
        write("çağırıyoruz... ");

        // Not: İşlev göstergeleri işlev gibi çağrılabilirler
        DönüşTürü sonuç = nesne(1.5, 42, new ÇalarSaat);
        writeln("ve sonuç: ", sonuç);
    }
}
---

$(P
O işlevi yukarıdaki farklı türlerle şöyle çağırabiliriz:
)

---
    // Yapı nesnesiyle
    birİşlev(Nokta());

    // Sınıf nesnesiyle
    birİşlev(new ÇalarSaat);

    // enum değerle
    birİşlev(HaftaGünleri.Pazartesi);

    // İşlev göstergesiyle
    birİşlev(&foo);
---

$(P
Çıktısı:
)

$(SHELL_SMALL
--- struct ---
Yeni bir Nokta nesnesini kopyalayarak oluşturuyorum

--- super ---
ÇalarSaat sınıfının 2 adet üst türü var
hepsi birden: (in Object, in Saat)
en üstteki: Object

--- enum ---
HaftaGünleri enum türü, perde arkasında int olarak
gerçekleştirilmiştir

--- return ---
Bu, dönüş türü char olan bir işlev:
  char function(double kesirli, int tamsayı, Saat saat)
çağırıyoruz... ve sonuç: a
)

$(H5 $(C is (/* ... */ $(I Belirteç), $(I ŞablonParametreListesi))))

$(P
Şablon parametre listesi içeren $(C is) ifadesinin dört farklı kullanımı vardır:
)

$(UL

$(LI $(C is ($(I Tür) : $(I Belirteç), $(I ŞablonParametreListesi))))

$(LI $(C is ($(I Tür) == $(I Belirteç), $(I ŞablonParametreListesi))))

$(LI $(C is ($(I Tür isim) : $(I Belirteç), $(I ŞablonParametreListesi))))

$(LI $(C is ($(I Tür isim) == $(I Belirteç), $(I ŞablonParametreListesi))))

)

$(P
Bu dört kullanım çok daha karmaşık ifadeler yazmaya olanak verir.
)

$(P
$(C isim), $(C Belirteç), $(C :), ve $(C ==) hep yukarıdaki  kullanımlarıyla aynı anlamdadırlar.
)

$(P
$(C ŞablonParametreListesi) ise hem koşulun parçası olarak işlem görür hem de bütün koşul sağlandığında otomatik olarak uygun tür isimleri tanımlamaya yarar. Şablonların tür çıkarsama olanağı ile aynı biçimde işler.
)

$(P
Örnek olarak, indeks değeri $(C string) olan eşleme tabloları kullanıldığında özel işlemler yapılması gereksin. Yalnızca böyle türlere uymaya çalışan bir $(C is) ifadesi şöyle yazılabilir:
)

---
    static if (is (T == Değer[İndeks],    // (1)
                   Değer,                 // (2)
                   İndeks : string)) {    // (3)
---

$(P
O koşulu üç bölüm olarak açıklayabiliriz. Bunların son ikisi $(C ŞablonParametreListesi)'ni oluşturmaktadır:
)

$(OL
$(LI $(C T), $(C Değer[İndeks]) yazımına uygunsa)
$(LI $(C Değer) herhangi bir tür ise)
$(LI $(C İndeks) bir $(C string) ise (şablon özellemesi söz dizimi))
)

$(P
$(C Belirteç) olarak $(C Değer[İndeks]) kullanılmış olması şablon parametresi olan $(C T)'nin bir eşleme tablosu türü olmasını gerektirir. $(C Değer) için hiçbir koşul belirtilmemiş olması onun herhangi bir tür olmasının yeterli olduğu anlamına gelir. Ek olarak, eşleme tablosunun indeks türünün de özellikle $(C string) olması gerekmektedir. Dolayısıyla, yukarıdaki $(C is) ifadesi, "$(C T), indeks türü $(C string) olan bir eşleme tablosu ise" anlamına gelmektedir.
)

$(P
Bu $(C is) ifadesini kullanan ve dört farklı türle çağrılan bir örnek şöyle yazılabilir:
)

---
import std.stdio;

void birİşlev(T)(T nesne) {
    writeln("\n--- ", T.stringof, " ile çağrıldık ---");

    static if (is (T == Değer[İndeks],
                   Değer,
                   İndeks : string)) {

        writeln("Evet, koşul sağlandı.");

        writeln("değer türü : ", Değer.stringof);
        writeln("indeks türü: ", İndeks.stringof);

    } else {
        writeln("Hayır, koşul sağlanmadı.");
    }
}

void main() {
    int sayı;
    birİşlev(sayı);

    int[string] intTablosu;
    birİşlev(intTablosu);

    double[string] doubleTablosu;
    birİşlev(doubleTablosu);

    dchar[long] dcharTablosu;
    birİşlev(dcharTablosu);
}
---

$(P
Koşul, yalnızca indeks türü $(C string) olan eşleme tabloları için sağlanmaktadır:
)

$(SHELL_SMALL
--- int ile çağrıldık ---
Hayır, koşul sağlanmadı.

--- int[string] ile çağrıldık ---
Evet, koşul sağlandı.
değer türü : int
indeks türü: string

--- double[string] ile çağrıldık ---
Evet, koşul sağlandı.
değer türü : double
indeks türü: string

--- dchar[long] ile çağrıldık ---
Hayır, koşul sağlanmadı.
)

Macros:
        SUBTITLE=is İfadesi

        DESCRIPTION=İç gözlem olanaklarından olan is ifadesi

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial koşullu derleme is ifadesi

SOZLER=
$(statik)
