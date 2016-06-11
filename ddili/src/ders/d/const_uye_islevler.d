Ddoc

$(DERS_BOLUMU $(CH4 const ref) Parametreler ve $(CH4 const) Üye İşlevler)

$(P
Bu bölümde üye işlevlerin $(C immutable) nesnelerle de kullanılabilmeleri için nasıl $(C const) olarak işaretlenmeleri gerektiğini göreceğiz. Bu bölümde her ne kadar yalnızca yapıları kullanıyor olsak da $(C const) üye işlevler sınıflar için de aynen geçerlidir.
)

$(H5 $(C immutable) nesneler)

$(P
Şimdiye kadarki bazı örneklerde $(C immutable) değişkenler ve nesneler tanımlamış ve $(C immutable) anahtar sözcüğünün nesnelerin değiştirilemez olmalarını sağladığını görmüştük:
)

---
    immutable okumaSaati = GününSaati(15, 0);
---

$(P
$(C okumaSaati) değiştirilemez:
)

---
    okumaSaati = GününSaati(16, 0);     $(DERLEME_HATASI)
    okumaSaati.dakika += 10;            $(DERLEME_HATASI)
---

$(P
Derleyici $(C immutable) nesneye yeni bir değer atanmasına veya bir üyesinin değiştirilmesine izin vermez. Zaten $(C immutable) olarak işaretlemenin amacı da budur: Bazı nesnelerin değerlerinin değişmemesi program doğruluğu açısından önemli olabilir.
)

$(H5 $(C const) olmayan $(C ref) parametreler)

$(P
Bu kavramı daha önce $(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri bölümünde) görmüştük. $(C ref) parametrelerin işlev içinde değiştirilmemeleri yönünde bir kısıtlama yoktur. $(C ref) bir parametresini değiştirmiyor bile olsa, bunun garantisini vermediği için böyle bir işleve $(C immutable) nesne gönderilemez:
)

---
// süre'yi değiştirmediği halde const olarak işaretlenmemiş
int toplamSaniye(ref Süre süre) {
    return 60 * süre.dakika;
}
// ...
    $(HILITE immutable) ısınmaSüresi = Süre(3);
    toplamSaniye(ısınmaSüresi);          $(DERLEME_HATASI)
---

$(P
Derleyici $(C immutable) olan $(C ısınmaSüresi) nesnesinin $(C toplamSaniye) işlevine gönderilmesine izin vermez, çünkü $(C toplamSaniye) işlevi parametresinde değişiklik yapmayacağı garantisini vermemektedir.
)

$(H5 $(IX const ref) $(IX ref const) $(IX parametre, const ref) $(C const ref) parametreler)

$(P
$(C const ref) olarak işaretlenen bir parametre, $(I o işlev içinde değiştirilmeyecek) demektir:
)

---
int toplamSaniye(const ref Süre süre) {
    return 60 * süre.dakika;
}
// ...
    immutable ısınmaSüresi = Süre(3);
    toplamSaniye(ısınmaSüresi);          // ← şimdi derlenir
---

$(P
Parametresini $(C const) olarak işaretleyen işlev $(I o parametrede değişiklik yapmayacağı) garantisini vermiş olduğu için işleve $(C immutable) değişkenler de gönderilebilir.
)

$(P
Derleyici $(C const) parametrenin değiştirilmesine izin vermez:
)

---
int toplamSaniye(const ref Süre süre) {
    süre.dakika = 7;       $(DERLEME_HATASI)
// ...
}
---

$(P
$(IX in ref) $(IX ref in) $(IX parametre, in ref) $(C const ref) yerine $(C in ref) de kullanılabilir. $(LINK2 /ders/d/islev_parametreleri.html, İlerideki bir bölümde) göreceğimiz gibi, $(C in) parametrenin yalnızca giriş bilgisi olarak kullanıldığını ve bu yüzden değiştirilemeyeceğini bildirir:
)

---
int toplamSaniye($(HILITE in ref) Süre süre) {
    // ...
}
---

$(H5 $(C const) olmayan üye işlevler)

$(P
Nesneleri değiştirmenin başka bir yolu üye işlevlerdir. Bunu daha önce $(C GününSaati.ekle) işlevinde görmüştük. O üye işlev, üzerinde çağrıldığı nesneyi ona bir $(C Süre) ekleyerek değiştiriyordu:
)

---
struct GününSaati {
// ...
    void ekle(in Süre süre) {
        dakika += süre.dakika;

        saat += dakika / 60;
        dakika %= 60;
        saat %= 24;
    }
// ...
}
// ...
    auto başlangıç = GününSaati(5, 30);
    başlangıç.ekle(Süre(30));          // başlangıç değişir
---

$(H5 $(IX const, üye işlev) $(C const) üye işlevler)

$(P
Bazı üye işlevler ise üzerinde çağrıldıkları nesnede değişiklik yapmazlar:
)

---
struct GününSaati {
// ...
    string toString() {
        return format("%02s:%02s", saat, dakika);
    }
// ...
}
---

$(P
$(C toString)'in tek işi nesneyi $(C string) olarak ifade etmektir ve zaten o kadar olmalıdır; nesnenin kendisini değiştirmez.
)

$(P
Üye işlevlerin nesnede bir değişiklik yapmayacakları garantisi parametre listesinden sonra yazılan $(C const) sözcüğü ile verilir:
)

---
struct GününSaati {
// ...
    string toString() $(HILITE const) {
        return format("%02s:%02s", saat, dakika);
    }
}
---

$(P
O $(C const), nesnenin o işlev içinde değiştirilmeyeceği anlamına gelir.
)

$(P
Böylece $(C toString) üye işlevi $(C immutable) nesneler üzerinde de çağrılabilir. Aksi halde nesnenin değiştirilmeyeceğinin garantisi bulunmadığından, $(C immutable) nesneler üzerinde çağrılamama gibi yapay bir kısıtlamayla karşı karşıya kalınırdı:
)

---
struct GününSaati {
// ...
    // const olarak işaretlenmemiş (yanlış tasarım)
    string toString() {
        return format("%02s:%02s", saat, dakika);
    }
}
// ...
    $(HILITE immutable) başlangıç = GününSaati(5, 30);
    writeln(başlangıç);    // GününSaati.toString() çağrılmaz!
---

$(P
Çıktısı beklenendiği gibi $(C 05:30) değil, derleyicinin çağırdığı genel bir işlevin çıktısıdır:
)

$(SHELL
immutable(GününSaati)(5, 30)
)

$(P
$(C toString) $(C immutable) bir nesne üzerinde açıkça çağrıldığında ise bir derleme hatası oluşur:
)

---
    auto dizgiOlarak = başlangıç.toString(); $(DERLEME_HATASI)
---

$(P
Bu açıdan bakıldığında şimdiye kadarki bölümlerde gördüğümüz $(C toString) üye işlevleri yanlış tasarlanmışlardır; aslında onların da $(C const) olarak işaretlenmeleri gerekirdi.
)

$(P $(I Not: İşlevin nesnede değişiklik yapmayacağını garanti eden $(C const) anahtar sözcüğü aslında işlevin tanımından önce de yazılabilir:)
)

---
    // üsttekiyle aynı anlamda
    $(HILITE const) string toString() {
        return format("%02s:%02s", saat, dakika);
    }
---

$(P
$(I Öyle yazıldığında dönüş türüne aitmiş gibi yanlış bir anlam verebildiği için $(C const) anahtar sözcüğünü bu biçimde değil, daha yukarıda gösterildiği gibi parametre listesinden sonra yazmanızı öneririm.)
)


$(H5 $(IX inout, üye işlev) $(C inout) üye işlevler)

$(P
$(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri bölümünde) gördüğümüz gibi, $(C inout) parametrenin değişmezlik bilgisini işlevin çıkış türüne aktarır.
)

$(P
Benzer biçimde, $(C inout) olarak tanımlanmış olan bir üye işlev de $(I nesnenin) değişmezlik bilgisini işlevin çıkış türüne aktarır:
)

---
import std.stdio;

struct Topluluk {
    int[] elemanlar;

    $(HILITE inout)(int)[] başTarafı(size_t n) $(HILITE inout) {
        return elemanlar[0 .. n];
    }
}

void main() {
    {
        // immutable bir Topluluk nesnesi
        auto topluluk = $(HILITE immutable)(Topluluk)([ 1, 2, 3 ]);
        auto dilim = topluluk.başTarafı(2);
        writeln(typeof(dilim).stringof);
    }
    {
        // const bir Topluluk nesnesi
        auto topluluk = $(HILITE const)(Topluluk)([ 1, 2, 3 ]);
        auto dilim = topluluk.başTarafı(2);
        writeln(typeof(dilim).stringof);
    }
    {
        // Değişebilen bir Topluluk nesnesi
        auto topluluk = Topluluk([ 1, 2, 3 ]);
        auto dilim = topluluk.başTarafı(2);
        writeln(typeof(dilim).stringof);
    }
}
---

$(P
Farklı değişmezliğe sahip üç nesnenin döndürdüğü üç dilim o nesnelerin değişmezliklerine sahiptir:
)

$(SHELL
$(HILITE immutable)(int)[]
$(HILITE const)(int)[]
int[]
)

$(P
$(C const) ve $(C immutable) nesneler üzerinde de çağrılabilmeleri gerektiğinden $(C inout) üye işlevler derleyici tarafından $(C const) olarak derlenirler.
)

$(H5 Ne zaman kullanmalı)

$(UL

$(LI
İşlev içinde değiştirilmeyecek olan parametreleri $(C const) olarak işaretleyin. Böylece o işlevlere $(C immutable) değişkenler de gönderilebilir.
)

$(LI
$(C toString) gibi nesnede değişiklik yapmayan üye işlevleri her zaman için $(C const) olarak işaretleyin:

---
struct GününSaati {
// ...
    string toString() $(HILITE const) {
        return format("%02s:%02s", saat, dakika);
    }
}
---

$(P
Böylece yapının ve sınıfın kullanışlılığı gereksizce kısıtlanmamış olur. Bundan sonraki bölümlerdeki kodları buna uygun olarak tasarlayacağız.
)

)

)

Macros:
        SUBTITLE=const ref Parametreler ve const Üye İşlevler

        DESCRIPTION=D dilinde const ref parametreler; ve yapıların ve sınıfların üye işlevlerinin const nesnelerle de çalışabilmek için const olarak işaretlenmeleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial yapı yapılar struct const üye işlev üye fonksiyon const ref parametre

SOZLER=
$(degismez)
$(referans)
$(sabit)
$(sinif)
$(uye_islev)
$(yapi)
