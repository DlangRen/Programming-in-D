Ddoc

$(DERS_BOLUMU $(IX UFCS) $(IX işlev çağırma ortak söz dizimi) $(IX ortak söz dizimi, işlev çağırma) İşlev Çağırma Ortak Söz Dizimi (UFCS))

$(P
UFCS "universal function call syntax"in kısaltmasıdır. Normal işlevlerin üye işlevler gibi çağrılabilmelerini sağlar. Derleyicinin otomatik olarak sağladığı bu olanak çok kısa olarak iki ifade ile anlatılabilir:
)

---
    değişken.işlev($(I parametre_değerleri))
---

$(P
Yukarıdaki gibi bir ifade ile karşılaşıldığında eğer $(C değişken)'in o parametrelere uyan $(C işlev) isminde bir üye işlevi yoksa, derleyici hata vermeden önce bir de aşağıdaki normal işlev çağrısını dener:
)

---
    işlev(değişken, $(I parametre_değerleri))
---

$(P
Eğer derlenebiliyorsa o ifade kabul edilir ve aslında normal bir işlev olan $(C işlev) sanki bir üye işlevmiş gibi çağrılmış olur.
)

$(P
Belirli bir yapı veya sınıf türünü yakından ilgilendiren işlevlerin o türün üye işlevleri olarak tanımlandıklarını biliyoruz. Her normal işlev özel üyelere erişemediğinden üye işlevler sarma kavramı için gereklidir. Örneğin, $(C private) olarak işaretlenmiş olan üyelere ancak o türün kendi üye işlevleri ve o türü içeren modül tarafından erişilebilir.
)

$(P
Deposundaki benzin miktarını da bildiren bir $(C Araba) türü olsun:
)

---
$(CODE_NAME Araba)class Araba {
    enum ekonomi = 12.5;           // litre başına km (ortalama)
    private double kalanBenzin;    // litre

    this(double kalanBenzin) {
        this.kalanBenzin = kalanBenzin;
    }

    double benzin() const {
        return kalanBenzin;
    }

    // ...
}
---

$(P
Üye işlevler ne kadar yararlı ve gerekli olsalar da, belirli bir tür üzerindeki olası bütün işlemlerin üye işlevler olarak tanımlanmaları beklenmemelidir çünkü bazı işlemler ancak belirli programlarda anlamlıdırlar veya yararlıdırlar. Örneğin, arabanın belirli bir mesafeyi gidip gidemeyeceğini bildiren işlevin üye işlev olarak değil, normal işlev olarak tanımlanması daha uygun olabilir:
)

---
$(CODE_NAME gidebilir_mi)bool gidebilir_mi(Araba araba, double mesafe) {
    return (araba.benzin() * araba.ekonomi) >= mesafe;
}
---

$(P
Doğal olarak, bu işlemin serbest işlev olarak tanımlanmış olması işlev çağrısı söz diziminde farklılık doğurur. Değişkenin ismi aşağıdaki iki kullanımda farklı yerlerde geçmektedir:
)

---
$(CODE_XREF Araba)$(CODE_XREF gidebilir_mi)void main() {
    auto araba = new Araba(5);

    auto kalanBenzin = $(HILITE araba).benzin(); // Üye işlev söz dizimi

    if (gidebilir_mi($(HILITE araba), 100)) {    // Normal işlev söz dizimi
        // ...
    }
}
---

$(P
UFCS, söz dizimindeki bu farklılığı ortadan kaldırır; normal işlevlerin de üye işlevler gibi çağrılabilmelerini sağlar:
)

---
    if ($(HILITE araba).gidebilir_mi(100)) { // Normal işlev, üye işlev söz dizimi ile
        // ...
    }
---

$(P
Bu olanak hazır değerler dahil olmak üzere temel türlerle de kullanılabilir:
)

---
int yarısı(int değer) {
    return değer / 2;
}

void main() {
    assert(42.yarısı() == 21);
}
---

$(P
Bir sonraki bölümde göreceğimiz gibi, işlev çağrısı sırasında parametre değeri kullanılmadığında o işlev parantezsiz olarak da çağrılabilir. Bu olanaktan da yararlanıldığında yukarıdaki ifade daha da kısalır. Sonuçta, aşağıdaki satırların üçü de aynı anlamdadır:
)

---
    sonuç = yarısı(değer);
    sonuç = değer.yarısı();
    sonuç = değer.yarısı;
---

$(P
$(IX zincirleme, işlev çağrısı) $(IX işlev çağrısı zincirleme) UFCS özellikle işlevlerin $(I zincirleme olarak) çağrıldığı durumlarda yararlıdır. Bunu $(C int) dizileri ile işleyen üç işlev üzerinde görelim:
)

---
$(CODE_NAME islevler)// Bütün elemanların 'bölen' ile bölünmüşlerini döndürür
int[] bölümleri(int[] dilim, int bölen) {
    int[] sonuç;
    sonuç.reserve(dilim.length);

    foreach (değer; dilim) {
        sonuç ~= değer / bölen;
    }

    return sonuç;
}

// Bütün elemanların 'çarpan' ile çarpılmışlarını döndürür
int[] çarpımları(int[] dilim, int çarpan) {
    int[] sonuç;
    sonuç.reserve(dilim.length);

    foreach (değer; dilim) {
        sonuç ~= değer * çarpan;
    }

    return sonuç;
}

// Elemanların çift olanlarını döndürür
int[] çiftleri(int[] dilim) {
    int[] sonuç;
    sonuç.reserve(dilim.length);

    foreach (değer; dilim) {
        if (!(değer % 2)) {
            sonuç ~= değer;
        }
    }

    return sonuç;
}
---

$(P
UFCS'ten yararlanılmadığı zaman bu üç işlevi zincirleme olarak çağırmanın bir yolu aşağıdaki gibidir:
)

---
$(CODE_XREF islevler)import std.stdio;

// ...

void main() {
    auto sayılar = [ 1, 2, 3, 4, 5 ];
    writeln(çiftleri(bölümleri(çarpımları(sayılar, 10), 3)));
}
---

$(P
Sayılar önce 10 ile çarpılmakta, sonra 3 ile bölünmekte, ve sonucun çift olanları kullanılmaktadır:
)

$(SHELL
[6, 10, 16]
)

$(P
Yukarıdaki ifadenin bir sorunu, $(C çarpımları) ile $(C 10)'un ve $(C bölümleri) ile $(C 3)'ün birbirleriyle ilgili olmalarına rağmen ifadede birbirlerinden uzakta yazılmak zorunda olmalarıdır. UFCS bu sorunu ortadan kaldırır ve işlem sıralarına uyan daha doğal bir söz dizimi getirir:
)

---
    writeln(sayılar.çarpımları(10).bölümleri(3).çiftleri);
---

$(P
Bazı programcılar $(C writeln) gibi çağrılarda da UFCS'ten yararlanırlar:
)

---
    sayılar.çarpımları(10).bölümleri(3).çiftleri.writeln;
---

$(P
Ek bir bilgi olarak, yukarıdaki bütün program $(C map) ve $(C filter)'dan yararlanılarak da yazılabilir:
)

---
import std.stdio;
import std.algorithm;

void main() {
    auto sayılar = [ 1, 2, 3, 4, 5 ];

    writeln(sayılar
            .map!(a => a * 10)
            .map!(a => a / 3)
            .filter!(a => !(a % 2)));
}
---

$(P
Bunu sağlayan $(LINK2 /ders/d/sablonlar.html, şablon), $(LINK2 /ders/d/araliklar.html, aralık), ve $(LINK2 /ders/d/katmalar.html, isimsiz işlev) olanaklarını daha sonraki bölümlerde göreceğiz.
)

Macros:
        SUBTITLE=İşlev Çağırma Ortak Söz Dizimi (UFCS)

        DESCRIPTION=Normal işlevleri üye işlev söz dizimi ile çağırma olanağı.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial

SOZLER=
$(aralik)
$(islev)
$(sarma)
$(sablon)
$(uye_islev)
