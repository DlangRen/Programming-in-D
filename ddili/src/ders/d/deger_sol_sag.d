Ddoc

$(DERS_BOLUMU $(IX sol değer) $(IX sağ değer) Sol Değerler ve Sağ Değerler)

$(P
$(IX ifade, sol değer ve sağ değer) Her ifadenin değeri ya $(I sol değerdir) ya da $(I sağ değerdir). Bu iki kavramı ayırt etmenin kolay bir yolu, dizi ve eşleme tablosu elemanları dahil olmak üzere bütün değişkenlerin sol değer, hazır değerler dahil olmak üzere bütün geçici değerlerin de sağ değer olduklarını kabul etmektir.
)

$(P
Örneğin, aşağıdaki $(C writeln()) çağrılarından birincisinin bütün parametreleri sol değerdir, ikincisindekiler ise sağ değerdir:
)

---
import std.stdio;

void main() {
    int i;
    immutable(int) imm;
    auto dizi = [ 1 ];
    auto tablo = [ 10 : "on" ];

    /* Aşağıdaki parametre değerlerinin hepsi sol değerdir. */

    writeln(i,             // değişken
            imm,           // immutable değişken
            dizi,          // dizi
            dizi[0],       // dizi elemanı
            tablo[10]);    // eşleme tablosu elemanı
                           // vs.

    enum mesaj = "merhaba";

    /* Aşağıdaki parametre değerlerinin hepsi sağ değerdir. */

    writeln(42,             // hazır değer
            mesaj,          // enum sabiti (manifest constant)
            i + 1,          // geçici değer
            hesapla(i));    // işlevin dönüş değeri
                            // vs.
}

int hesapla(int i) {
    return i * 2;
}
---

$(H5 Sağ değerlerin yetersizlikleri)

$(P
Sol değerlerle karşılaştırıldıklarında sağ değerler aşağıdaki üç konuda yetersizdir.
)

$(H6 Sağ değerlerin adresleri yoktur)

$(P
Sol değerlerin bellekte yerleri olabilir, sağ değerlerin olamaz.
)

$(P
Örneğin, aşağıdaki programdaki $(C a&nbsp;+&nbsp;b) sağ değerinin adresi alınamaz:
)

---
import std.stdio;

void main() {
    int a;
    int b;

    readf(" %s", &a);          $(CODE_NOTE derlenir)
    readf(" %s", &(a + b));    $(DERLEME_HATASI)
}
---

$(SHELL
Error: a + b $(HILITE is not an lvalue)
)

$(H6 Sağ değerlere yeni değer atanamaz)

$(P
Değişmez olmadıkları sürece sol değerlere yeni değer atanabilir, sağ değerlere atanamaz.
)

---
    a = 1;          $(CODE_NOTE derlenir)
    (a + b) = 2;    $(DERLEME_HATASI)
---

$(SHELL
Error: a + b $(HILITE is not an lvalue)
)

$(H6 Sağ değerler işlevlere referans olarak geçirilemezler)

$(P
Sol değerler referans olarak geçirilebilirler, sağ değerler geçirilemezler.
)

---
void onArttır($(HILITE ref int) değer) {
    değer += 10;
}

// ...

    onArttır(a);        $(CODE_NOTE derlenir)
    onArttır(a + b);    $(DERLEME_HATASI)
---

$(SHELL
Error: function deneme.onArttır (ref int değer)
$(HILITE is not callable) using argument types (int)
)

$(P
Bu kısıtlamanın temel nedeni, işlevlerin referans türündeki parametrelerini sonradan kullanmak üzere bir kenara kaydedebilecekleri, oysa sağ değerlerin yaşamlarının sonradan kullanılmaya çalışıldıklarında çoktan sonlanmış olacağıdır.
)

$(P
C++ gibi bazı dillerden farklı olarak, D'de sağ değerler referansı $(C const) olarak alan işlevlere de geçirilemezler:
)

---
void yazdır($(HILITE ref const(int)) değer) {
    writeln(değer);
}

// ...

    yazdır(a);        $(CODE_NOTE derlenir)
    yazdır(a + b);    $(DERLEME_HATASI)
---

$(SHELL
Error: function deneme.yazdır (ref const(int) değer)
$(HILITE is not callable) using argument types (int)
)

$(H5 $(IX auto ref, parametre) $(IX parametre, auto ref) Hem sol değer hem sağ değer alabilen $(C auto&nbsp;ref) parametreler)

$(P
Önceki bölümde gördüğümüz gibi, $(LINK2 /ders/d/sablonlar.html, işlev şablonlarının) $(C auto ref) parametreleri hem sol değer hem sağ değer alabilirler.
)

$(P
$(C auto ref), bir sol değer ile çağrıldığında $(I referans olarak) geçirme anlamına gelir; sağ değer ile çağrıldığında ise $(I kopyalayarak) geçirme anlamına gelir. Derleyicinin bu farklı iki durum için farklı kod üretebilmesi için işlevin bir şablon olması gerekir.
)

$(P
Şablonları daha sonra göreceğiz. Şimdilik aşağıda işaretli olarak gösterilen boş parantezlerin $(C onArttır)'ı bir $(I işlev şablonu) haline getirdiğini kabul edin.
)

---
void onArttır$(HILITE ())($(HILITE auto ref) int değer) {
    /* UYARI: Asıl parametre bir sağ değer ise buradaki
     * 'değer' adlı parametre çağıran taraftaki değerin
     * kopyasıdır. O yüzden, parametrede yapılan aşağıdaki
     * değişiklik çağıran tarafta gözlemlenemez. */

    değer += 10;
}

void main() {
    int a;
    int b;

    onArttır(a);        $(CODE_NOTE sol değer; referans olarak geçirilir)
    onArttır(a + b);    $(CODE_NOTE sağ değer; kopyalanarak geçirilir)
}
---

$(P
Yukarıdaki kod açıklamasında da belirtildiği gibi, parametrede yapılan değişiklik işlevi çağıran tarafta görülemeyebilir. O yüzden, $(C auto ref) genellikle parametrenin değişmediği durumlarda $(C auto ref const) olarak kullanılır.
)

$(H5 Terimler)

$(P
"Sol değer" ve "sağ değer" anlamına gelen "lvalue" ve "rvalue" ne yazık ki bu iki çeşit değeri yeterince ifade edemez. Başlarındaki $(I l) ve $(I r) harfleri "sol" anlamındaki "left"ten ve "sağ" anlamındaki "right"tan gelir. Bu sözcükler atama işlecinin sol ve sağ tarafını ifade ederler:
)

$(UL

$(LI
Değişmez olmadıkları sürece, sol değerler atama işlecinin sol tarafındaki ifade olarak kullanılabilirler.
)

$(LI
Sağ değerler atama işlecinin sol tarafındaki ifade olarak kullanılamazlar.
)

)

$(P
Bu terimlerin açık olmamalarının bir nedeni, hem sol değerlerin hem de sağ değerlerin aslında atama işlecinin her iki tarafında da yer alabilmeleridir:
)

---
    /* Bir sağ değer olan 'a + b' solda,
     * bir sol değer olan 'a' sağda: */
    array[a + b] = a;
---

Macros:
        SUBTITLE=Sol Değerler ve Sağ Değerler

        DESCRIPTION=Sol değerler, sağ değerler, ve aralarındaki farklar.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sol sağ lvalue rvalue

SOZLER=
$(atama)
$(ifade)
$(sag_deger)
$(sol_deger)
