Ddoc

$(COZUM_BOLUMU Birim Testleri)

$(P
Programı önce bu haliyle başlatıyor ve hata atıldığından emin oluyoruz:
)

$(SHELL
$ dmd deneme.d -ofdeneme -w -unittest
$ ./deneme
$(DARK_GRAY core.exception.AssertError@deneme(11): unittest failure)
)

$(P
Böylece testlerin çalıştığından eminiz; bizi ileride yapılabilecek hatalara karşı koruyacaklar. Bu durumdaki hata mesajındaki satır numarasına (11) bakarak, birim testlerinden ilkinin başarısız olduğunu görüyoruz.
)

$(P
Şimdi, göstermek amacıyla bilerek hatalı bir gerçekleştirmesini deneyelim. Bu gerçekleştirme, özel harfe hiç dikkat etmez ve girilen dizinin aynısını döndürür:
)

---
dstring harfBaşa(dstring dizgi, in dchar harf) {
    dstring sonuç;

    foreach (eleman; dizgi) {
        sonuç ~= eleman;
    }

    return sonuç;
}

unittest {
    immutable dizgi = "merhaba"d;

    assert(harfBaşa(dizgi, 'm') == "merhaba");
    assert(harfBaşa(dizgi, 'e') == "emrhaba");
    assert(harfBaşa(dizgi, 'a') == "aamerhb");
}

void main() {
}
---

$(P
Bu sefer birinci $(C assert) denetimi $(I tesadüfen) başarılı olur, ama ikincisi hata atar:
)

$(SHELL
$ ./deneme
$(DARK_GRAY core.exception.AssertError@deneme($(HILITE 17)): unittest failure)
)

$(P
Tesadüfün nedeni, o hatalı gerçekleştirmede "merhaba" girildiği zaman yine "merhaba" döndürülmesi ve birim testinin beklentisine uymasıdır. Tekrar deneyelim:
)

---
dstring harfBaşa(dstring dizgi, in dchar harf) {
    dstring başTaraf;
    dstring sonTaraf;

    foreach (eleman; dizgi) {
        if (eleman == harf) {
            başTaraf ~= eleman;

        } else {
            sonTaraf ~= eleman;
        }
    }

    return başTaraf ~ sonTaraf;
}

unittest {
    immutable dizgi = "merhaba"d;

    assert(harfBaşa(dizgi, 'm') == "merhaba");
    assert(harfBaşa(dizgi, 'e') == "emrhaba");
    assert(harfBaşa(dizgi, 'a') == "aamerhb");
}

void main() {
}
---

$(P
Şimdi testlerin tümü geçer:
)

$(SHELL
$ ./deneme
$
)

$(P
Artık bu noktadan sonra güvendeyiz; işlevi, testlerine güvenerek istediğimiz gibi değiştirebiliriz. Aşağıda iki farklı gerçekleştirmesini daha görüyorsunuz. Bunların ikisi de aynı testlerden geçerler.
)

$(UL

$(LI
$(C std.algorithm) modülündeki $(C partition) işlevini kullanan bir gerçekleştirme:

---
import std.algorithm;

dstring harfBaşa(dstring dizgi, in dchar harf) {
    dchar[] sonuç = dizgi.dup;
    partition!(e => e == harf, SwapStrategy.stable)(sonuç);

    return sonuç.idup;
}

unittest {
    immutable dizgi = "merhaba"d;

    assert(harfBaşa(dizgi, 'm') == "merhaba");
    assert(harfBaşa(dizgi, 'e') == "emrhaba");
    assert(harfBaşa(dizgi, 'a') == "aamerhb");
}

void main() {
}
---

$(P
$(I Not: Yukarıdaki programda kullanılan ve isimsiz işlev oluşturmaya yarayan $(C =>) söz dizimini daha sonraki bölümlerde göreceğiz.)
)

)

$(LI
Önce özel harften kaç tane bulunduğunu sayan bir gerçekleştirme... Bu, sonucun baş tarafını daha sonra $(C tekrarlıDizi) isimli başka bir işleve yaptırıyor. Sağlam programcılık gereği, o işlevin de kendi birim testleri yazılmış:

---
dstring tekrarlıDizi(int adet, dchar harf) {
    dstring dizi;

    foreach (i; 0..adet) {
        dizi ~= harf;
    }

    return dizi;
}

unittest {
    assert(tekrarlıDizi(3, 'z') == "zzz");
    assert(tekrarlıDizi(10, 'ğ') == "ğğğğğğğğğğ");
}

dstring harfBaşa(dstring dizgi, in dchar harf) {
    int özelHarfAdedi;
    dstring sonTaraf;

    foreach (eleman; dizgi) {
        if (eleman == harf) {
            ++özelHarfAdedi;

        } else {
            sonTaraf ~= eleman;
        }
    }

    return tekrarlıDizi(özelHarfAdedi, harf) ~ sonTaraf;
}

unittest {
    immutable dizgi = "merhaba"d;

    assert(harfBaşa(dizgi, 'm') == "merhaba");
    assert(harfBaşa(dizgi, 'e') == "emrhaba");
    assert(harfBaşa(dizgi, 'a') == "aamerhb");
}

void main() {
}
---

)

)

Macros:
        SUBTITLE=Birim Testleri

        DESCRIPTION=D dilinin kod güvenilirliğini arttıran olanağı 'birim testleri' [unit tests] problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial birim test testler unit test unittest problem çözüm
