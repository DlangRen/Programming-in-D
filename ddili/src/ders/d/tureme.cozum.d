Ddoc

$(COZUM_BOLUMU Türeme)

$(OL

$(LI Üst sınıfın $(C abstract) olarak belirttiği $(C sesÇıkart) işlevi alt sınıflar tarafından $(C override) anahtar sözcüğü ile tanımlanır.

$(P
Bu problemde $(C Tren) sınıfını gözardı edersek yalnızca $(C Vagon.sesÇıkart) ve $(C Lokomotif.sesÇıkart) işlevleri yeterlidir:
)

---
import std.stdio;

class DemirYoluAracı {
    void ilerle(in size_t kilometre) {
        writefln("Araç %s kilometre ilerliyor:", kilometre);

        foreach (i; 0 .. kilometre / 100) {
            writefln("  %s", sesÇıkart());
        }
    }

    abstract string sesÇıkart();
}

class Vagon : DemirYoluAracı {
    $(HILITE override) string sesÇıkart() const {
        return "takıtak tukutak";
    }

    // ...
}

class YolcuVagonu : Vagon {
    // ...
}

class YükVagonu : Vagon {
    // ...
}

class Lokomotif : DemirYoluAracı {
    $(HILITE override) string sesÇıkart() {
        return "çuf çuf";
    }
}

void main() {
    auto vagon1 = new YolcuVagonu;
    vagon1.ilerle(100);

    auto vagon2 = new YükVagonu;
    vagon2.ilerle(200);

    auto lokomotif = new Lokomotif;
    lokomotif.ilerle(300);
}
---

)

$(LI
Aşağıdaki program $(C Tren)'in sesini onu oluşturan parçaların bir birleşimi olarak üretmektedir:

---
import std.stdio;

class DemirYoluAracı {
    void ilerle(in size_t kilometre) {
        writefln("Araç %s kilometre ilerliyor:", kilometre);

        foreach (i; 0 .. kilometre / 100) {
            writefln("  %s", sesÇıkart());
        }
    }

    abstract string sesÇıkart();
}

class Vagon : DemirYoluAracı {
    override string sesÇıkart() const {
        return "takıtak tukutak";
    }

    abstract void bindir();
    abstract void indir();
}

class YolcuVagonu : Vagon {
    override void bindir() {
        writeln("Yolcular biniyor");
    }

    override void indir() {
        writeln("Yolcular iniyor");
    }
}

class YükVagonu : Vagon {
    override void bindir() {
        writeln("Mal yükleniyor");
    }

    override void indir() {
        writeln("Mal boşalıyor");
    }
}

class Lokomotif : DemirYoluAracı {
    override string sesÇıkart() {
        return "çuf çuf";
    }
}

class Tren : DemirYoluAracı {
    Lokomotif lokomotif;
    Vagon[] vagonlar;

    this(Lokomotif lokomotif) {
        this.lokomotif = lokomotif;
    }

    void vagonEkle(Vagon[] vagonlar...) {
        this.vagonlar ~= vagonlar;
    }

    $(HILITE override) string sesÇıkart() {
        string sonuç = lokomotif.sesÇıkart();

        foreach (vagon; vagonlar) {
            sonuç ~= ", " ~ vagon.sesÇıkart();
        }

        return sonuç;
    }

    void istasyondanAyrıl(string istasyon) {
        foreach (vagon; vagonlar) {
            vagon.bindir();
        }

        writefln("%s garından ayrılıyoruz", istasyon);
    }

    void istasyonaGel(string istasyon) {
        writefln("%s garına geldik", istasyon);

        foreach (vagon; vagonlar) {
            vagon.indir();
        }
    }
}

void main() {
    auto lokomotif = new Lokomotif;
    auto tren = new Tren(lokomotif);

    tren.vagonEkle(new YolcuVagonu, new YükVagonu);

    tren.istasyondanAyrıl("Ankara");
    tren.ilerle(500);
    tren.istasyonaGel("Haydarpaşa");
}
---

$(P
Çıktısı:
)

$(SHELL
Yolcular biniyor
Mal yükleniyor
Ankara garından ayrılıyoruz
Araç 500 kilometre ilerliyor:
  çuf çuf, takıtak tukutak, takıtak tukutak  $(SHELL_NOTE Tren.sesÇıkart'ın sonucu)
  çuf çuf, takıtak tukutak, takıtak tukutak
  çuf çuf, takıtak tukutak, takıtak tukutak
  çuf çuf, takıtak tukutak, takıtak tukutak
  çuf çuf, takıtak tukutak, takıtak tukutak
Haydarpaşa garına geldik
Yolcular iniyor
Mal boşalıyor
)

)

)


Macros:
        SUBTITLE=Türeme Problem Çözümleri

        DESCRIPTION=Türeme Problem Çözümleri

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial türeme problem çözüm
