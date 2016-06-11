Ddoc

$(DERS_BOLUMU $(IX işlev, iç) $(IX struct, iç) $(IX class, iç) $(IX iç tanım) İç İşlevler, Yapılar, ve Sınıflar)

$(P
İşlevler, yapılar, ve sınıflar iç kapsamlarda tanımlanabilirler. Bu hem isimlerin daha dar kapsamlarda geçerli olmalarını ve böylece bir anlamda o isimlerin sarmalanmalarını sağlar hem de $(LINK2 /ders/d/kapamalar.html, İşlev Göstergeleri, İsimsiz İşlevler, ve Temsilciler bölümünde) gördüğümüz kapamaların başka bir gerçekleştirmesidir.
)

$(P
Bir örnek olarak, aşağıdaki $(C dışİşlev()) işlevinin kapsamında bir işlev, bir yapı, ve bir de sınıf tanımlanmaktadır:
)

---
void dışİşlev(int parametre) {
    int yerel;

    $(HILITE void içİşlev()) {
        yerel = parametre * 2;
    }

    $(HILITE struct İçYapı) {
        void üyeİşlev() {
            yerel /= parametre;
        }
    }

    $(HILITE class İçSınıf) {
        void üyeİşlev() {
            yerel += parametre;
        }
    }

    // İşlev içindeki kullanımları:

    içİşlev();

    auto y = İçYapı();
    y.üyeİşlev();

    auto s = new İçSınıf();
    s.üyeİşlev();
}

void main() {
    dışİşlev(42);
}
---

$(P
Beklenebileceği gibi, iç tanımlar dış kapsamlarındaki değişkenlere erişebilirler. Örneğin, yukarıdaki koddaki iç tanımların üçü de $(C parametre) ve $(C yerel) adlı değişkenlere erişebilmektedir.
)

$(P
İşlev içinde tanımlanan değişkenlerde olduğu gibi, işlev içinde tanımlanan isimler de yalnızca tanımlandıkları kapsamda geçerlidir. Örneğin; $(C içİşlev()), $(C İçYapı), ve $(C İçSınıf) isimleri $(C main()) içinde kullanılamaz:
)

---
void main() {
    auto a = İçYapı();             $(DERLEME_HATASI)
    auto b = dışİşlev.İçYapı();    $(DERLEME_HATASI)
}
---

$(P
Ancak, isimleri kullanılamasalar da iç tanımlar başka kapsamlarda kullanılabilirler. Örneğin, bir çok Phobos algoritması görevini kendi içinde tanımladığı bir yapı aracılığıyla gerçekleştirir.
)

$(P
Bunun bir örneğini görmek için kendisine verilen dilimi bir baştan bir sondan tüketerek kullanan bir işlev tanımlayalım:
)

---
import std.stdio;
import std.array;

auto baştanSondan(T)(T[] dilim) {
    bool baştan_mı = true;

    $(HILITE struct BaştanSondanAralığı) {
        bool empty() @property const {
            return dilim.empty;
        }

        T front() @property const {
            return baştan_mı ? dilim.front : dilim.back;
        }

        void popFront() {
            if (baştan_mı) {
                dilim.popFront();
                baştan_mı = false;

            } else {
                dilim.popBack();
                baştan_mı = true;
            }
        }
    }

    return BaştanSondanAralığı();
}

void main() {
    auto a = baştanSondan([ 1, 2, 3, 4, 5 ]);
    writeln(a);
}
---

$(P
Her ne kadar ismine erişemese de, $(C main()) $(C baştanSondan()) işlevinin kurduğu ve döndürdüğü iç yapı nesnesini kullanabilir:
)

$(SHELL
[1, 5, 2, 4, 3]
)

$(P
$(IX Voldemort) $(I Not: İsimlerinin $(I söylenemiyor) olması Harry Potter karakterlerinden Voldemort'u çağrıştırdığından bu çeşit türlere $(I Voldemort türü) denir.)
)

$(P
$(IX kapama) $(IX kapsam) Dikkat ederseniz, $(C baştanSondan()) işlevinin döndürdüğü iç yapının hiçbir üyesi bulunmamaktadır. O yapı görevini yalnızca işlev parametresi olan $(C dilim)'i ve yerel değişken olan $(C baştan_mı)'yı kullanarak gerçekleştirmektedir. Bu değişkenlerin normalde işlevden çıkılırken sonlanacak olan yaşamları iç yapı nesnesi yaşadığı sürece uzatılır. Bu; $(LINK2 /ders/d/kapamalar.html, İşlev Göstergeleri, İsimsiz İşlevler, ve Temsilciler bölümünde) gördüğümüz $(I kapsam saklama) kavramının aynısıdır: İşlevlerden döndürülen iç tanımlar tanımlandıkları kapsamların yaşam süreçlerini kendileri yaşadıkları sürece uzatırlar ve böylece fonksiyonel programlamadaki $(I kapama) kavramını oluştururlar.
)

$(H6 $(IX static, iç tanım) Kapama gerekmeyen durumlarda $(C static))

$(P
Tanımlandıkları kapsamı da barındırdıklarından iç tanımlar modül düzeyinde tanımlanmış olan benzerlerinden daha masraflıdır. Ek olarak, bu türlerin nesneleri işledikleri kapsamın hangisi olduğunu bildiren gizli bir $(I kapsam göstergesi) de barındırmak zorundadırlar. İç tanım nesneleri bu yüzden daha fazla yer de kaplarlar. Örneğin, aynı sayıda üye değişkene sahip oldukları halde aşağıdaki iki yapının boyutları farklıdır:
)

---
import std.stdio;

$(HILITE struct Dış) {
    int i;

    void işlev() {
    }
}

void foo() {
    $(HILITE struct İç) {
        int i;

        void işlev() {
        }
    }

    writefln("Dıştaki %s bayt, içteki %s bayt",
             Dış.sizeof, İç.sizeof);
}

void main() {
    foo();
}
---

$(P
Büyüklükler farklı ortamlarda farklı olabilir. Benim ortamımdaki çıktısı aşağıdaki gibi:
)

$(SHELL
Dıştaki $(HILITE 4) bayt, içteki $(HILITE 16) bayt
)

$(P
$(IX static class) $(IX static struct) İç tanımlar bazen yalnızca kodu olabildiğince yerel tanımlamak amacıyla kullanılırlar; kapsamdaki değişkenlere erişmeyle ve dolayısıyla kapama oluşturmayla ilgileri yoktur. Getirdikleri masraf böyle durumlarda gereksiz olacağından iç tanımların normal tanımlara eşdeğer olmaları istendiğinde $(C static) anahtar sözcüğü kullanılır. Bunun doğal sonucu olarak $(C static) iç tanımlar kapsamdaki değişkenlere erişemezler:
)

---
void dışİşlev(int parametre) {
    $(HILITE static) class İçSınıf {
        int i;

        this() {
            i = parametre;    $(DERLEME_HATASI)
        }
    }
}
---

$(P
$(IX .outer, void*) Bir iç sınıf nesnesinin kapsam göstergesi $(C .outer) niteliği ile $(C void*) türünde elde edilebilir. Örneğin, aynı kapsamda oluşturulan iki sınıf değişkeninin kapsam göstergeleri bekleneceği gibi aynıdır:
)

---
void foo() {
    class C {
    }

    auto a = new C();
    auto b = new C();

    assert(a$(HILITE .outer) is b$(HILITE .outer));
}
---

$(P
Sınıf içinde tanımlanan sınıflarda kapsam göstergesinin türü $(C void*) değil, dış sınıfın türüdür. Bunu biraz aşağıda göreceğiz.
)

$(H6 $(IX class, sınıf içinde) Sınıf içinde tanımlanan sınıflar)

$(P
Bir sınıf başka bir sınıf içinde tanımlandığında iç sınıfın kapsamı dış sınıf nesnesinin kendisidir.
)

$(P
$(IX .new) $(IX .outer, class) Bu çeşit iç sınıf nesneleri özel $(C this.new) söz dizimi ile oluşturulurlar. Dış kapsamı oluşturan nesneye gerektiğinde $(C this.outer) ile erişilebilir:
)

---
class Dış {
    int dışÜye;

    $(HILITE class İç) {
        int işlev() {
            /* İç sınıf dış sınıfın üyelerine erişebilir. */
            return dışÜye * 2;
        }

        Dış dışNesne() {
            /* İç nesne kendi kapsamı olan dış nesnesine
             * 'outer' anahtar sözcüğüyle erişebilir. Bu
             * örnekte yalnızca dönüş değeri olarak
             * kullanıyor.  */
            return $(HILITE this.outer);
        }
    }

    İç algoritma() {
        /* Dış kendisini kapsam olarak kullanacak olan bir İç
         * nesnesini özel 'this.new' söz dizimi ile kurar. */
        return $(HILITE this.new) İç();
    }
}

void main() {
    auto dış = new Dış();

    /* Dış'ın bir işlevinin bir İç nesnesi döndürmesi: */
    auto iç = dış.algoritma();

    /* Döndürülen nesnenin kullanılması: */
    iç.işlev();

    /* Doğal olarak 'iç'in kapsamı 'dış'tır: */
    assert(iç.dışNesne() is dış);
}
---

$(P
Bu örnekteki $(C this.new) ve $(C this.outer) söz dizimleri yerine $(C .new) ve $(C .outer) var olan değişkenlere de uygulanabilir:
)

---
    auto dış = new Dış();
    auto iç = $(HILITE dış.new) Dış.İç();
    auto dış2 = $(HILITE iç.outer);
---

$(H5 Özet)

$(UL

$(LI İç kapsamlarda tanımlanan işlevler, yapılar, ve sınıflar o kapsamlardaki isimlere doğrudan erişebilirler.)

$(LI İç tanımlar tanımlandıkları kapsamları canlı tutarak kapama oluştururlar.)

$(LI İç tanımlar normal tanımlardan daha masraflıdır. Bu masraf kapama gerekmeyen durumlarda $(C static) anahtar sözcüğü ile önlenir.)

$(LI Sınıf içinde tanımlanan sınıfın kapsamı, dışındaki sınıf nesnesidir. Sınıf içi sınıflar $(C this.new) veya $(C değişken.new) ile kurulurlar; kapsamlarına $(C this.outer) veya $(C değişken.outer) ile erişilir.)

)

Macros:
        SUBTITLE=İç İşlevler, Yapılar, ve Sınıflar

        DESCRIPTION=İşlevlerin, yapıların, ve sınıfların iç kapsamlarda tanımlanmaları.

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial işlev yapı sınıf iç

SOZLER=
$(gosterge)
$(ic_tanim)
$(kapama)
$(sarma)
