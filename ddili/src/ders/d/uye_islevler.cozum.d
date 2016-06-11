Ddoc

$(COZUM_BOLUMU Üye İşlevler)

$(OL

$(LI
Azaltan işlev, eksi değerler nedeniyle daha karmaşık oluyor:

---
struct GününSaati {
    // ...

    void azalt(in Süre süre) {
        int azalanDakika = süre.dakika % 60;
        int azalanSaat = süre.dakika / 60;

        dakika -= azalanDakika;

        if (dakika < 0) {
            dakika += 60;
            ++azalanSaat;
        }

        saat -= azalanSaat;

        if (saat < 0) {
            saat = 24 - (-saat % 24);
        }
    }

    // ...
}
---

)

$(LI
$(C toString)'in programı çok daha kısa ve kullanışlı hale getirdiğini göreceksiniz. Karşılaştırma amacıyla, $(LINK2 /ders/d/islev_yukleme.cozum.html, programın önceki halinde) $(C Toplantı) nesnesini yazdıran işlevi tekrar göstermek istiyorum:

---
void bilgiVer(in Toplantı toplantı) {
    bilgiVer(toplantı.başlangıç);
    write('-');
    bilgiVer(toplantı.bitiş);

    writef(" \"%s\" toplantısı (%s katılımcı)",
           toplantı.konu,
           toplantı.katılımcıSayısı);
}
---

$(P
Aşağıdaki programdaki $(C Toplantı.toString) ise kısaca şöyle yazılabiliyor:
)

---
    string toString() {
        return format("%s-%s \"%s\" toplantısı (%s katılımcı)",
                      başlangıç, bitiş, konu, katılımcıSayısı);
    }
---

$(P
Programın tamamı:
)

---
import std.stdio;
import std.string;

struct Süre {
    int dakika;
}

struct GününSaati {
    int saat;
    int dakika;

    string toString() {
        return format("%02s:%02s", saat, dakika);
    }

    void ekle(in Süre süre) {
        dakika += süre.dakika;

        saat += dakika / 60;
        dakika %= 60;
        saat %= 24;
    }
}

struct Toplantı {
    string     konu;
    int        katılımcıSayısı;
    GününSaati başlangıç;
    GününSaati bitiş;

    string toString() {
        return format("%s-%s \"%s\" toplantısı (%s katılımcı)",
                      başlangıç, bitiş, konu, katılımcıSayısı);
    }
}

struct Yemek {
    GününSaati zaman;
    string     adres;

    string toString() {
        GününSaati bitiş = zaman;
        bitiş.ekle(Süre(90));

        return format("%s-%s Yemek, Yer: %s",
                      zaman, bitiş, adres);
    }
}

struct GünlükPlan {
    Toplantı sabahToplantısı;
    Yemek    öğleYemeği;
    Toplantı akşamToplantısı;

    string toString() {
        return format("%s\n%s\n%s",
                      sabahToplantısı,
                      öğleYemeği,
                      akşamToplantısı);
    }
}

void main() {
    auto geziToplantısı = Toplantı("Bisiklet gezisi", 4,
                                   GününSaati(10, 30),
                                   GününSaati(11, 45));

    auto öğleYemeği = Yemek(GününSaati(12, 30), "Taksim");

    auto bütçeToplantısı = Toplantı("Bütçe", 8,
                                    GününSaati(15, 30),
                                    GününSaati(17, 30));

    auto bugününPlanı = GünlükPlan(geziToplantısı,
                                   öğleYemeği,
                                   bütçeToplantısı);

    writeln(bugününPlanı);
    writeln();
}
---

$(P
Programın çıktısı da eski halinin aynısı:
)

$(SHELL
10:30-11:45 "Bisiklet gezisi" toplantısı (4 katılımcı)
12:30-14:00 Yemek, Yer: Taksim
15:30-17:30 "Bütçe" toplantısı (8 katılımcı)
)

)

)

Macros:
        SUBTITLE=Üye İşlevler

        DESCRIPTION=D dili yapılarının ve sınıflarının üye işlevleri, ve toString problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial yapı yapılar struct üye işlev üye fonksiyon toString problem çözüm
