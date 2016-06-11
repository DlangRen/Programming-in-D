Ddoc

$(COZUM_BOLUMU Yapı ve Sınıflarda $(C foreach))

$(OL

$(LI Aralığın başı ve sonuna ek olarak adım miktarının da saklanması gerekir. $(C opApply) içindeki döngüdeki değer bu durumda $(C adım) kadar arttırılır:

---
struct Aralık {
    int baş;
    int son;
    $(HILITE int adım);

    int opApply(int delegate(ref int) işlemler) const {
        int sonuç;

        for (int sayı = baş; sayı != son; $(HILITE sayı += adım)) {
            sonuç = işlemler(sayı);
            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }
}

import std.stdio;

void main() {
    foreach (eleman; Aralık(0, 10, 2)) {
        write(eleman, ' ');
    }

    writeln();
}
---

)

$(LI

---
import std.stdio;
import std.string;

class Öğrenci {
    string isim;
    int numara;

    this(string isim, int numara) {
        this.isim = isim;
        this.numara = numara;
    }

    override string toString() {
        return format("%s(%s)", isim, numara);
    }
}

class Öğretmen {
    string isim;
    string ders;

    this(string isim, string ders) {
        this.isim = isim;
        this.ders = ders;
    }

    override string toString() {
        return format("%s dersine %s Öğretmen", ders, isim);
    }
}

class Okul {
private:

    Öğrenci[] öğrenciler;
    Öğretmen[] öğretmenler;

public:

    this(Öğrenci[] öğrenciler,
         Öğretmen[] öğretmenler) {
        this.öğrenciler = öğrenciler.dup;
        this.öğretmenler = öğretmenler.dup;
    }

    /* Parametresi Öğrenci olduğundan, bu 'delegate'i
     * kullanan opApply, foreach döngü değişkeninin Öğrenci
     * olduğu durumda çağrılır. */
    int opApply(int delegate(ref $(HILITE Öğrenci)) işlemler) {
        int sonuç;

        foreach (öğrenci; öğrenciler) {
            sonuç = işlemler(öğrenci);

            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }

    /* Benzer şekilde, bu opApply da foreach döngü değişkeni
     * Öğretmen olduğunda çağrılır. */
    int opApply(int delegate(ref $(HILITE Öğretmen)) işlemler) {
        int sonuç;

        foreach (öğretmen; öğretmenler) {
            sonuç = işlemler(öğretmen);

            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }
}

void girintiliYazdır(T)(T nesne) {
    writeln("  ", nesne);
}

void main() {
    auto okul = new Okul(
        [ new Öğrenci("Can", 1),
          new Öğrenci("Canan", 10),
          new Öğrenci("Cem", 42),
          new Öğrenci("Cemile", 100) ],

        [ new Öğretmen("Nazmiye", "Matematik"),
          new Öğretmen("Makbule", "Türkçe") ]);

    writeln("Öğrenci döngüsü");
    foreach ($(HILITE Öğrenci) öğrenci; okul) {
        girintiliYazdır(öğrenci);
    }

    writeln("Öğretmen döngüsü");
    foreach ($(HILITE Öğretmen) öğretmen; okul) {
        girintiliYazdır(öğretmen);
    }
}
---

$(P
Çıktısı:
)

$(SHELL
Öğrenci döngüsü
  Can(1)
  Canan(10)
  Cem(42)
  Cemile(100)
Öğretmen döngüsü
  Matematik dersine Nazmiye Öğretmen
  Türkçe dersine Makbule Öğretmen
)

$(P
İki işlevin dizi türleri dışında aynı olduklarını görüyoruz. Buradaki ortak işlemleri dizinin türüne göre değişen bir işlev şablonu olarak yazabilir ve iki $(C opApply)'dan bu ortak işlevi çağırabiliriz:
)

---
class Okul {
// ...

    int opApplyOrtak$(HILITE (T))(T[] dizi, int delegate(ref T) işlemler) {
        int sonuç;

        foreach (eleman; dizi) {
            sonuç = işlemler(eleman);

            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }

    int opApply(int delegate(ref Öğrenci) işlemler) {
        return opApplyOrtak(öğrenciler, işlemler);
    }

    int opApply(int delegate(ref Öğretmen) işlemler) {
        return opApplyOrtak(öğretmenler, işlemler);
    }
}
---

)

)

Macros:
        SUBTITLE=Yapı ve Sınıflarda foreach Problem Çözümleri

        DESCRIPTION=Yapı ve Sınıflarda foreach Problem Çözümleri

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial yapı sınıf foreach problem çözüm
