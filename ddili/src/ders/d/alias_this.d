Ddoc

$(DERS_BOLUMU $(IX alias this) $(CH4 alias this))

$(P
Başka bağlamlarda başka anlamlara gelen $(C alias) ve $(C this) anahtar sözcükleri bir arada kullanıldıklarında farklı bir anlam kazanırlar. Bu yüzden, ikisi bir arada kullanıldığında tek bir anahtar sözcük olarak kabul edilmelidirler.
)

$(P
$(IX otomatik tür dönüşümü) $(IX tür dönüşümü, otomatik)  $(C alias this), bir yapının veya sınıfın otomatik tür dönüşümü yoluyla başka türler yerine geçmesini sağlar. Tür dönüşümü için başka bir seçenek $(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme bölümünde) gördüğümüz $(C opCast) işlecidir. Farkları, $(C opCast)'in açıkça yapılan tür dönüşümleri için, $(C alias this)'in ise otomatik tür dönüşümleri için kullanılmasıdır.
)

$(P
Bu iki sözcük birbirlerinden ayrı olarak yazılırlar; aralarına yapının veya sınıfın bir üyesi gelir:
)

---
    alias $(I üye_değişken_veya_işlev) this;
---

$(P
$(C alias this) yapının veya sınıfın türünü gerektiğinde belirtilen üyenin türüne otomatik olarak dönüştürmeyi sağlar. Dönüşüm sonucunda üretilen değer o üyenin değeridir.
)

$(P
Aşağıdaki $(C Kesir) örneği $(C alias this)'i bir $(I üye işlev) ile kullanıyor. Daha aşağıdaki $(C AraştırmaGörevlisi) örneğinde ise $(C alias this)'in $(I üye değişkenlerle) kullanımlarını göreceğiz.
)

$(P
$(C değeri) işlevinin dönüş değeri $(C double) olduğundan, aşağıdaki $(C alias this) bildirimi $(C Kesir) nesnelerinin $(C double) değerler yerine kullanılabilmelerini sağlar:
)

---
import std.stdio;

struct Kesir {
    long pay;
    long payda;

    $(HILITE double değeri()) const @property {
        return double(pay) / payda;
    }

    alias $(HILITE değeri) this;

    // ...
}

double hesap(double soldaki, double sağdaki) {
    return 2 * soldaki + sağdaki;
}

void main() {
    auto kesir = Kesir(1, 4);    // 1/4 anlamında
    writeln(hesap($(HILITE kesir), 0.75));
}
---

$(P
Yukarıdaki yapının nesneleri $(C double) türünde değer beklenen ifadelerde geçtiklerinde $(C değeri) işlevi çağrılır ve o işlevin döndürdüğü değer kullanılır. Yukarıdaki kodda aslında $(C double) bekleyen $(C hesap) işlevine bir $(C Kesir) nesnesi gönderilebilmiş ve o hesapta $(C değeri) işlevinin döndürdüğü 0.25 kullanılmıştır. Program, 2 * 0.25 + 0.75 hesabının sonucunu yazdırır:
)

$(SHELL
1.25
)

$(H5 $(IX çoklu kalıtım) $(IX kalıtım, çoklu) Çoklu kalıtım)

$(P
Sınıfların en fazla bir $(C class)'tan türetilebildiklerini daha önce $(LINK2 /ders/d/tureme.html, Türeme bölümünde) görmüştük. (Hatırlayacağınız gibi, $(C interface)'ten türeme konusundan böyle bir kısıtlama yoktur.) Nesne yönelimli programlama dillerinden bazıları birden fazla sınıftan türetmeye de izin verirler. Birden fazla sınıftan türetmeye $(I çoklu kalıtım) denir.
)

$(P
$(C alias this) sınıfların çoklu kalıtıma uygun olarak kullanılabilmelerini de sağlar. Birden fazla $(C alias this) bildirimi kullanıldığında o yapı veya sınıf o bildirimlerin sağladıkları bütün otomatik tür dönüşümlerinde kullanılabilir.
)

$(P
$(HILITE $(I Not: Bu bölümdeki kodların en son denendikleri derleyici olan dmd 2.071 yalnızca tek $(C alias this) bildirimine izin veriyordu.))
)

$(P
Aşağıdaki $(C AraştırmaGörevlisi) sınıfı kendi içinde $(C Öğrenci) ve $(C Öğretmen) türlerini üye değişkenler olarak tutuyor. Bu türün nesneleri $(C alias this) bildirimleri sayesinde hem öğretmen hem de öğrenci gereken yerlerde kullanılabilirler:
)

---
import std.stdio;

class Öğrenci {
    string isim;
    uint[] notlar;

    this(string isim) {
        this.isim = isim;
    }
}

class Öğretmen {
    string isim;
    string ders;

    this(string isim, string ders) {
        this.isim = isim;
        this.ders = ders;
    }
}

class AraştırmaGörevlisi {
    Öğrenci öğrenciKimliği;
    Öğretmen öğretmenKimliği;

    this(string isim, string ders) {
        this.öğrenciKimliği = new Öğrenci(isim);
        this.öğretmenKimliği = new Öğretmen(isim, ders);
    }

    /* Bu iki bildirim sayesinde bu tür hem Öğretmen hem de
     * Öğrenci olarak kullanılabilir.
     *
     * Not: dmd 2.071 birden fazla 'alias this' tanımını
     *      desteklemez. */
    alias $(HILITE öğretmenKimliği) this;
    $(CODE_COMMENT_OUT compiler limitation)alias $(HILITE öğrenciKimliği) this;
}

void dersSaati(Öğretmen öğretmen, Öğrenci[] öğrenciler)
in {
    assert(öğretmen !is null);
    assert(öğrenciler.length > 0);

} body {
    writef("%s öğretmen şu öğrencilere %s anlatıyor:",
           öğretmen.isim, öğretmen.ders);

    foreach (öğrenci; öğrenciler) {
        writef(" %s", öğrenci.isim);
    }

    writeln();
}

void main() {
    auto öğrenciler = [ new Öğrenci("Özlem"),
                        new Öğrenci("Özgür") ];

    // Hem Öğretmen hem de Öğrenci olabilen bir nesne:
    auto arkan = new AraştırmaGörevlisi("Arkan", "matematik");

    // 'arkan' bu kullanımda Öğretmen kimliğindedir:
    dersSaati($(HILITE arkan), öğrenciler);

    // Aşağıdaki kullanımda ise öğrencilerden birisidir:
    auto ayşeHoca = new Öğretmen("Ayşe", "fizik");
    $(CODE_COMMENT_OUT compiler limitation)dersSaati(ayşeHoca, öğrenciler ~ $(HILITE arkan));
}
---

$(P
Programın çıktısı aynı nesnenin otomatik olarak farklı türler yerine kullanılabildiğini gösteriyor:
)

$(SHELL
$(HILITE Arkan) öğretmen şu öğrencilere matematik anlatıyor: Özlem Özgür
Ayşe öğretmen şu öğrencilere fizik anlatıyor: Özlem Özgür $(HILITE Arkan)
)

Macros:
        SUBTITLE=alias this

        DESCRIPTION=Nesnelerin otomatik olarak başka tür olarak kullanılmalarını sağlayan 'alias this'.

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial alias takma isim alias this

SOZLER=
$(kalitim)

