Ddoc

$(COZUM_BOLUMU Göstergeler)

$(OL

$(LI Parametre türleri yalnızca $(C int) olduğunda işleve $(C main()) içindeki değişkenlerin kopyalarının gönderildiklerini biliyorsunuz. $(C main()) içindeki değişkenlerin referanslarını edinmenin bir yolu, parametreleri $(C ref&nbsp;int) olarak tanımlamaktır.

$(P
Diğer bir yol, o değişkenlere erişim sağlayan göstergeler göndermektir. Programın değişen yerlerini sarı ile işaretliyorum:
)

---
void değişTokuş(int $(HILITE *) birinci, int $(HILITE *) ikinci) {
    int geçici = $(HILITE *)birinci;
    $(HILITE *)birinci = $(HILITE *)ikinci;
    $(HILITE *)ikinci = geçici;
}

void main() {
    int i = 1;
    int j = 2;

    değişTokuş($(HILITE &)i, $(HILITE &)j);

    assert(i == 2);
    assert(j == 1);
}
---

)

$(LI Hem $(C Düğüm) hem de $(C Liste) $(C int) türüne bağlı olarak yazılmışlardı. Bu iki yapıyı şablona dönüştürmenin yolu, tanımlanırken isimlerinden sonra $(C (T)) eklemek ve tanımlarındaki $(C int)'leri $(C T) ile değiştirmektir. Değişen yerlerini sarıyla işaretliyorum:

---
$(CODE_NAME Liste)struct Düğüm$(HILITE (T)) {
    $(HILITE T) eleman;
    Düğüm * sonraki;

    string toString() const {
        string sonuç = to!string(eleman);

        if (sonraki) {
            sonuç ~= " -> " ~ to!string(*sonraki);
        }

        return sonuç;
    }
}

struct Liste$(HILITE (T)) {
    Düğüm$(HILITE !T) * baş;

    void başınaEkle($(HILITE T) eleman) {
        baş = new Düğüm$(HILITE !T)(eleman, baş);
    }

    string toString() const {
        return format("(%s)", baş ? to!string(*baş) : "");
    }
}
---

$(P
$(C Liste)'yi artık $(C int)'ten başka türlerle de deneyebiliriz:
)

---
$(CODE_XREF Liste)import std.stdio;
import std.conv;
import std.string;

// ...

struct Nokta {
    double x;
    double y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}

void main() {
    $(HILITE Liste!Nokta) noktalar;

    noktalar.başınaEkle(Nokta(1.1, 2.2));
    noktalar.başınaEkle(Nokta(3.3, 4.4));
    noktalar.başınaEkle(Nokta(5.5, 6.6));

    writeln(noktalar);
}
---

$(P
Çıktısı:
)

$(SHELL
((5.5,6.6) -> (3.3,4.4) -> (1.1,2.2))
)

)

$(LI Bu durumda sondaki düğümü gösteren bir üyeye daha ihtiyacımız olacak. Açıklamaları programın içine yerleştirdim:

---
struct Liste(T) {
    Düğüm!T * baş;
    $(HILITE Düğüm!T * son);

    void sonunaEkle(T eleman) {
        /* Sona eklenen elemandan sonra düğüm bulunmadığından
         * 'sonraki' düğüm olarak 'null' gönderiyoruz. */
        auto yeniDüğüm = new Düğüm!T(eleman, null);

        if (!baş) {
            /* Liste boşmuş. Şimdi 'baş' bu düğümdür. */
            baş = yeniDüğüm;
        }

        if (son) {
            /* Şu andaki 'son'dan sonraya bu düğümü
             * yerleştiriyoruz. */
            son.sonraki = yeniDüğüm;
        }

        /* Bu düğüm yeni 'son' oluyor. */
        son = yeniDüğüm;
    }

    void başınaEkle(T eleman) {
        auto yeniDüğüm = new Düğüm!T(eleman, baş);

        /* Bu düğüm yeni 'baş' oluyor. */
        baş = yeniDüğüm;

        if (!son) {
            /* Liste boşmuş. Şimdi 'son' bu düğümdür. */
            son = yeniDüğüm;
        }
    }

    string toString() const {
        return format("(%s)", baş ? to!string(*baş) : "");
    }
}
---

$(P
$(C başınaEkle()) işlevi aslında daha kısa olarak da yazılabilir:
)

---
    void başınaEkle(T eleman) {
        baş = new Düğüm!T(eleman, baş);

        if (!son) {
            son = baş;
        }
    }
---

$(P
Yukarıdaki $(C Nokta) nesnelerinin tek değerli olanlarını başa, çift değerli olanlarını sona ekleyen bir deneme:
)

---
void $(CODE_DONT_TEST)main() {
    Liste!Nokta noktalar;

    foreach (i; 1 .. 7) {
        if (i % 2) {
            noktalar.başınaEkle(Nokta(i, i));

        } else {
            noktalar.sonunaEkle(Nokta(i, i));
        }
    }

    writeln(noktalar);
}
---

$(P
Çıktısı:
)

$(SHELL
((5,5) -> (3,3) -> (1,1) -> (2,2) -> (4,4) -> (6,6))
)

)

)

Macros:
        SUBTITLE=Göstergeler Problem Çözümleri

        DESCRIPTION=Göstergeler Problem Çözümleri

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial gösterge problem çözüm
