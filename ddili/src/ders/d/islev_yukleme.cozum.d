Ddoc

$(COZUM_BOLUMU İşlev Yükleme)

$(P
Daha önce yazılan $(C bilgiVer) işlevlerinden yararlanan iki yüklemesi şöyle yazılabilir:
)

---
void bilgiVer(in Yemek yemek) {
    bilgiVer(yemek.zaman);
    write('-');
    bilgiVer(zamanEkle(yemek.zaman, GününSaati(1, 30)));

    write(" Yemek, Yer: ", yemek.adres);
}

void bilgiVer(in GünlükPlan plan) {
    bilgiVer(plan.sabahToplantısı);
    writeln();
    bilgiVer(plan.öğleYemeği);
    writeln();
    bilgiVer(plan.akşamToplantısı);
}
---

$(P
Bütün bu türleri kullanan programın tamamı:
)

---
import std.stdio;

struct GününSaati {
    int saat;
    int dakika;
}

void bilgiVer(in GününSaati zaman) {
    writef("%02s:%02s", zaman.saat, zaman.dakika);
}

GününSaati zamanEkle(in GününSaati başlangıç,
                     in GününSaati eklenecek) {
    GününSaati sonuç;

    sonuç.dakika = başlangıç.dakika + eklenecek.dakika;
    sonuç.saat = başlangıç.saat + eklenecek.saat;
    sonuç.saat += sonuç.dakika / 60;

    sonuç.dakika %= 60;
    sonuç.saat %= 24;

    return sonuç;
}

struct Toplantı {
    string     konu;
    int        katılımcıSayısı;
    GününSaati başlangıç;
    GününSaati bitiş;
}

void bilgiVer(in Toplantı toplantı) {
    bilgiVer(toplantı.başlangıç);
    write('-');
    bilgiVer(toplantı.bitiş);

    writef(" \"%s\" toplantısı (%s katılımcı)",
           toplantı.konu,
           toplantı.katılımcıSayısı);
}

struct Yemek {
    GününSaati zaman;
    string     adres;
}

void bilgiVer(in Yemek yemek) {
    bilgiVer(yemek.zaman);
    write('-');
    bilgiVer(zamanEkle(yemek.zaman, GününSaati(1, 30)));

    write(" Yemek, Yer: ", yemek.adres);
}

struct GünlükPlan {
    Toplantı sabahToplantısı;
    Yemek    öğleYemeği;
    Toplantı akşamToplantısı;
}

void bilgiVer(in GünlükPlan plan) {
    bilgiVer(plan.sabahToplantısı);
    writeln();
    bilgiVer(plan.öğleYemeği);
    writeln();
    bilgiVer(plan.akşamToplantısı);
}

void main() {
    immutable geziToplantısı = Toplantı("Bisiklet gezisi", 4,
                                        GününSaati(10, 30),
                                        GününSaati(11, 45));

    immutable öğleYemeği = Yemek(GününSaati(12, 30), "Taksim");

    immutable bütçeToplantısı = Toplantı("Bütçe", 8,
                                         GününSaati(15, 30),
                                         GününSaati(17, 30));

    immutable bugününPlanı = GünlükPlan(geziToplantısı,
                                        öğleYemeği,
                                        bütçeToplantısı);

    bilgiVer(bugününPlanı);
    writeln();
}
---

$(P
Yukarıdaki $(C main), nesneler tanımlamak yerine yalnızca yapı hazır değerleri ile şöyle de yazılabilir:
)

---
void $(CODE_DONT_TEST)main() {
    bilgiVer(GünlükPlan(Toplantı("Bisiklet gezisi", 4,
                                 GününSaati(10, 30),
                                 GününSaati(11, 45)),

                        Yemek(GününSaati(12, 30), "Taksim"),

                        Toplantı("Bütçe", 8,
                                 GününSaati(15, 30),
                                 GününSaati(17, 30))));
    writeln();
}
---


Macros:
        SUBTITLE=İşlev Yükleme

        DESCRIPTION=D'nin işlevlerin kullanışlılığını arttıran olanaklarından işlev yükleme konusunun problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev yükleme overloading problem çözüm
