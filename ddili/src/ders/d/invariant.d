Ddoc

$(DERS_BOLUMU $(IX sözleşmeli programlama) Yapı ve Sınıflarda Sözleşmeli Programlama)

$(P
Sözleşmeli programlama, kod hatalarını azaltmaya yarayan çok etkili bir olanaktır. D'nin sözleşmeli programlama olanaklarından ikisini $(LINK2 /ders/d/sozlesmeli.html, Sözleşmeli Programlama bölümünde) görmüştük. $(C in) ve $(C out) blokları, işlevlerin giriş ve çıkış garantilerini denetlemek için kullanılıyordu.
)

$(P
$(I Not:
O bölümdeki "in bloğu mu enforce mu" başlığı altındaki ilkeleri gözetmeniz önemlidir. Bu bölümdeki örnekler nesnelerin ve parametrelerin tutarlılıkları ile ilgili sorunların programcı hatalarına bağlı olduğu durumlarla ilgilidir. Diğer durumlarda işlevin kodlarından $(C enforce)'u çağırmanız doğru olur.)
)

$(P
Hatırlamak amacıyla, üçgen alanını Heron formülünü kullanarak kenar uzunluklarından hesaplayan bir işlev yazalım. Üçgenin alanının doğru olarak hesaplanabilmesi için üç kenar uzunluğunun da sıfır veya daha büyük olması gerekir. Ek olarak, bir üçgenin hiçbir kenarının diğer ikisinin toplamından uzun olmaması da gerekir.
)

$(P
O giriş koşulları sağlandığında, üçgenin alanı da sıfır veya daha büyük olacaktır. Bu koşulları ve bu garantiyi sağlayan bir işlev şöyle yazılabilir:
)

---
private import std.math;

double üçgenAlanı(in double a, in double b, in double c)
in {
    // Kenarlar sıfırdan küçük olamaz
    assert(a >= 0);
    assert(b >= 0);
    assert(c >= 0);

    // Hiçbir kenar diğer ikisinin toplamından uzun olamaz
    assert(a <= (b + c));
    assert(b <= (a + c));
    assert(c <= (a + b));

} out (sonuç) {
    assert(sonuç >= 0);

} body {
    immutable yarıÇevre = (a + b + c) / 2;

    return sqrt(yarıÇevre
                * (yarıÇevre - a)
                * (yarıÇevre - b)
                * (yarıÇevre - c));
}
---

$(H5 $(IX in, sözleşme) $(IX out, sözleşme) $(IX giriş koşulu) $(IX çıkış garantisi) Üye işlevlerin $(C in) ve $(C out) blokları)

$(P
$(C in) ve $(C out) blokları üye işlevlerle de kullanılabilir ve aynı biçimde işlevin giriş koşullarını ve çıkış garantisini denetler.
)

$(P
Yukarıdaki alan hesabı işlevini bir üye işlev olarak yazalım:
)

---
import std.stdio;
import std.math;

struct Üçgen {
private:

    double a;
    double b;
    double c;

public:

    double alan() const @property
    $(HILITE out (sonuç)) {
        assert(sonuç >= 0);

    } body {
        const double yarıÇevre = (a + b + c) / 2;
        return sqrt(yarıÇevre
                    * (yarıÇevre - a)
                    * (yarıÇevre - b)
                    * (yarıÇevre - c));
    }
}

void main() {
    auto üçDörtBeşÜçgeni = Üçgen(3, 4, 5);
    writeln(üçDörtBeşÜçgeni.alan);
}
---

$(P
Üçgenin kenarları zaten yapının üye değişkenleri oldukları için bu işlevin parametreleri yok. O yüzden bu işlevin $(C in) bloğunu yazmadım. Üye değişkenlerin tutarlılıkları için aşağıdaki bilgileri kullanmanız gerekir.
)

$(H5 Nesnelerin geçerliliği için $(C in) ve $(C out) blokları)

$(P
Yukarıdaki üye işlev parametre almadığı için $(C in) bloğunu yazmadık. İşlevdeki hesabı da nesnenin üyelerini kullanarak yaptık. Yani bir anlamda üyelerin geçerli değerlere sahip olduklarını varsaydık. Bu varsayımın doğru olmasını sağlamanın bir yolu, sınıfın kurucu işlevine $(C in) bloğu eklemektir. Böylece kurucunun aldığı parametrelerin geçerli olduklarını en baştan nesne kurulurken denetleyebiliriz:
)

---
struct Üçgen {
// ...

    this(in double a, in double b, in double c)
    $(HILITE in) {
        // Kenarlar sıfırdan küçük olamaz
        assert(a >= 0);
        assert(b >= 0);
        assert(c >= 0);

        // Hiçbir kenar diğer ikisinin toplamından uzun olamaz
        assert(a <= (b + c));
        assert(b <= (a + c));
        assert(c <= (a + b));

    } body {
        this.a = a;
        this.b = b;
        this.c = c;
    }

// ...
}
---

$(P
Üçgen nesnelerinin geçersiz değerlerle oluşturulmaları en başından engellenmiş olur. Artık programın geçersiz değerlerle kurulmuş olan bir üçgen nesnesi kullanması olanaksızdır:
)

---
    auto eksiKenarUzunluklu = Üçgen(-1, 1, 1);
    auto birKenarıFazlaUzun = Üçgen(1, 1, 10);
---

$(P
Kurucu işlevin $(C in) bloğu, yukarıdaki geçersiz nesnelerin oluşturulmalarına izin vermez:
)

$(SHELL
core.exception.AssertError@deneme.d: Assertion failure
)

$(P
Bu sefer de $(C out) bloğunu yazmadığıma dikkat edin. Eğer gerekirse, daha karmaşık türlerde kurucu işlevin $(C out) bloğu da yazılabilir. O da nesnenin üyeleri kurulduktan sonra gerekebilecek denetimler için kullanılabilir.
)

$(H5 $(IX invariant) Nesnelerin tutarlılığı için $(C invariant) blokları)

$(P
Kurucuya eklenen $(C in) ve $(C out) blokları nesnenin yaşamının geçerli değerlerle başlayacağını, üyelere eklenen $(C in) ve $(C out) blokları da işlevlerin doğru işlediklerini garanti eder.
)

$(P
Ancak, bu denetimler nesnenin üyelerinin $(I her zaman için) geçerli veya tutarlı olacaklarını garanti etmeye elverişli değillerdir. Nesnenin üyeleri, üye işlevler içinde programcı hataları sonucunda tutarsız değerler edinebilirler.
)

$(P
Nesnenin tutarlılığını tarif eden koşullara "mutlak değişmez" denir. Örneğin, bir müşteri takip sınıfında her siparişe karşılık bir fatura bulunacağını varsayarsak, fatura adedinin sipariş adedinden fazla olamayacağı bu sınıfın bir mutlak değişmezidir. Eğer bu koşulun geçerli olmadığı bir müşteri takip nesnesi varsa, o nesnenin tutarlı durumda olduğunu söyleyemeyiz.
)

$(P
Bunun bir örneği olarak $(LINK2 /ders/d/sarma.html, Sarma ve Erişim Hakları bölümünde) kullandığımız $(C Okul) sınıfını ele alalım:
)

---
class Okul {
private:

    Öğrenci[] öğrenciler;
    int kızToplamı;
    int erkekToplamı;

// ...
}
---

$(P
Bu sınıftan olan nesnelerin tutarlı olarak kabul edilmeleri için, üç üyesi arasındaki bir mutlak değişmezin sağlanması gerekir. Öğrenci dizisinin uzunluğu, her zaman için kız öğrencilerin toplamı ile erkek öğrencilerin toplamına eşit olmalıdır:
)

---
    assert(öğrenciler.length == (kızToplamı + erkekToplamı));
---

$(P
O koşulun bozulmuş olması, bu sınıf kodlarında yapılan bir hatanın göstergesidir.
)

$(P
Yapı ve sınıf nesnelerinin tutarlılıkları o türün $(C invariant) bloklarında denetlenir. Bir veya daha fazla olabilen bu bloklar yapı veya sınıf tanımı içine yazılırlar ve sınıf nesnelerinin tutarlılık koşullarını belirlerler. $(C in) ve $(C out) bloklarında olduğu gibi, burada da $(C assert) denetimleri kullanılır:
)

---
class Okul {
private:

    Öğrenci[] öğrenciler;
    int kızToplamı;
    int erkekToplamı;

    $(HILITE invariant()) {
        assert(öğrenciler.length == (kızToplamı + erkekToplamı));
    }

// ...
}
---

$(P
$(C invariant) bloklarındaki kodlar aşağıdaki zamanlarda otomatik olarak işletilir, ve bu sayede programın yanlış verilerle devam etmesi önlenmiş olur:
)

$(UL

$(LI Kurucu işlev sonunda: Böylece nesnenin yaşamına tutarlı olarak başladığı garanti edilir.)

$(LI Sonlandırıcı işlev çağrılmadan önce: Böylece sonlandırma işlemlerinin tutarlı üyeler üzerinde yapılacakları garanti edilir.)

$(LI $(C public) bir işlev işletilmeden önce ve sonra: Böylece üye işlevlerdeki kodların nesneyi bozmadıkları garanti edilir.

$(P
$(IX export) $(I Not: Burada $(C public) işlevler için söylenen, $(C export) işlevler için de geçerlidir. ($(C export) işlevleri kısaca "dinamik kütüphalerin sundukları işlevler" olarak tanımlayabiliriz.))
)

)

)

$(P
$(C invariant) bloklarındaki denetimlerin başarısız olmaları da $(C in) ve $(C out) bloklarında olduğu gibi $(C AssertError) atılmasına neden olur. Bu sayede programın tutarsız nesnelerle devam etmesi önlenmiş olur.
)

$(P
$(IX -release, derleyici seçeneği) $(C in) ve $(C out) bloklarında olduğu gibi, $(C invariant) blokları da $(C -release) seçeneği ile iptal edilebilir:
)

$(SHELL
dmd deneme.d -w -release
)

$(H5 $(IX sözleşmeli programlama, kalıtım) $(IX kalıtım, sözleşmeli programlama) $(IX türeme, sözleşmeli programlama) $(IX giriş koşulu, türeme) $(IX çıkış garantisi, türeme) $(IX in, türeme) $(IX out, türeme) Sözleşmeli programlama ve türeme)

$(P
Arayüz ve sınıf üye işlevlerinin $(C in) ve $(C out) blokları olabilir. Böylece hem alt sınıflarının güvenebilecekleri giriş koşulları hem de kullanıcılarının güvenebilecekleri çıkış garantileri tanımlamış olurlar. Üye işlevlerin alt sınıflardaki tanımları da $(C in) ve $(C out) blokları içerebilirler. Alt sınıflardaki $(C in) blokları giriş koşullarını hafifletebilirler ve $(C out) blokları da ek çıkış garantileri verebilirler.
)

$(P
Normalde bir arayüzle etkileşecek biçimde $(I soyutlanmış) olarak yazıldığından kullanıcı kodunun çoğu durumda alt sınıflardan haberi yoktur. Kullanıcı kodu bir arayüzün sözleşmesine uygun olarak yazıldığından, bir alt sınıfın bu sözleşmenin giriş koşullarını ağırlaştırması da doğru olmaz. O yüzden alt sınıflar giriş koşullarını ancak hafifletebilirler.
)

$(P
$(C in) blokları üst sınıftan alt sınıfa doğru otomatik olarak işletilir. $(I Herhangi bir) $(C in) bloğunun başarılı olması (bütün $(C assert)'lerin doğru çıkması), giriş koşullarının sağlanmış olduğu anlamına gelir ve işlev çağrısı başarıyla devam eder. (Aşağıda anlatılacağı gibi, bunun bir etkisi, giriş koşullarının istenmeden etkisizleştirilebilmeleridir.)
)

$(P
Benzer biçimde, alt sınıflar $(C out) blokları da tanımlayabilirler. Çıkış garantileri bir işlevin verdiği garantileri tanımladığından alt sınıf üye işlevi üst sınıfın garantilerini de sağlamak zorundadır. Alt sınıf ek garantiler de getirebilir.
)

$(P
$(C out) blokları üst sınıftan alt sınıfa doğru otomatik olarak işletilir. Bir işlevin çıkış garantilerinin sağlanmış olması için $(I bütün) $(C out) bloklarının başarıyla işletilmeleri gerekir.
)

$(P
Bu kuralları gösteren aşağıdaki yapay program bir $(C interface) ve ondan türeyen bir $(C class) tanımlamaktadır. Buradaki alt sınıf hem daha az koşul gerektirmekte hem de daha fazla garanti vermektedir:
)

---
interface Arayüz {
    int[] işlev(int[] a, int[] b)
    $(HILITE in) {
        writeln("Arayüz.işlev.in");

        /* Bu arayüz işlevi parametrelerinin aynı uzunlukta
         * olmalarını gerektirmektedir. */
        assert(a.length == b.length);

    } $(HILITE out) (sonuç) {
        writeln("Arayüz.işlev.out");

        /* Bu arayüz işlevi dönüş değerinin çift sayıda
         * elemandan oluşacağını garanti etmektedir.
         * (Not: Boş dilimin çift sayıda elemanı olduğu kabul
         * edilir.) */
        assert((sonuç.length % 2) == 0);
    }
}

class Sınıf : Arayüz {
    int[] işlev(int[] a, int[] b)
    $(HILITE in) {
        writeln("Sınıf.işlev.in");

        /* Bu sınıf işlevi üst türdeki giriş koşullarını
         * hafifletmektedir: Birisi boş olmak kaydıyla
         * parametrelerin uzunluklarının eşit olmaları
         * gerekmemektedir. */
        assert((a.length == b.length) ||
               (a.length == 0) ||
               (b.length == 0));

    } $(HILITE out) (sonuç) {
        writeln("Sınıf.işlev.out");

        /* Bu sınıf ek garantiler vermektedir: Sonuç boş
         * olmayacaktır ve ilk ve sonuncu elemanların
         * değerleri eşit olacaktır. */
        assert((sonuç.length != 0) &&
               (sonuç[0] == sonuç[$ - 1]));

    } body {
        writeln("Sınıf.işlev.body");

        /* Bu yalnızca 'in' ve 'out' bloklarının işleyişini
         * gösteren yapay bir gerçekleştirme. */

        int[] sonuç;

        if (a.length == 0) {
            a = b;
        }

        if (b.length == 0) {
            b = a;
        }

        foreach (i; 0 .. a.length) {
            sonuç ~= a[i];
            sonuç ~= b[i];
        }

        sonuç[0] = sonuç[$ - 1] = 42;

        return sonuç;
    }
}

import std.stdio;

void main() {
    auto c = new Sınıf();

    /* Aşağıdaki çağrı Arayüz'ün gerektirdiği koşulu
     * sağlamadığı halde kabul edilir çünkü Sınıf'ın giriş
     * koşulunu sağlamaktadır. */
    writeln(c.işlev([1, 2, 3], $(HILITE [])));
}
---

$(P
$(C Sınıf.işlev)'in $(C in) bloğu $(C Arayüz.işlev)'in giriş koşulu sağlanmadığı için işletilmiştir:
)

$(SHELL
Arayüz.işlev.in
Sınıf.işlev.in    $(SHELL_NOTE Arayüz.işlev.in başarılı olsa bu işletilmezdi)
Sınıf.işlev.body
Arayüz.işlev.out
Sınıf.işlev.out
[42, 1, 2, 2, 3, 42]
)

$(H6 Giriş koşullarının istenmeden etkisizleştirilmeleri)

$(P
$(C in) bloğu olmayan bir işlev hiçbir giriş koşulu gerektirmiyor demektir. Bunun bir etkisi olarak, üst sınıfta giriş koşulu bulunan alt sınıf işlevleri kendileri giriş koşulu tanımlamazlarsa üst sınıftaki giriş koşullarını etkisiz hale getirmiş olurlar. (Yukarıda anlatıldığı gibi, üye işlevin tanımlarından birisinin $(C in) bloğunun başarılı olması giriş koşullarının sağlanmış olduğu anlamına gelir.)
)

$(P
Bu yüzden, genel bir kural olarak, üst sınıfta $(C in) bloğu bulunan bir üye işlevin alt sınıfta da $(C in) bloğu bulunmalıdır. Örneğin, alt sınıf işlevine her zaman için başarısız olan bir $(C in) bloğu eklenebilir.
)

$(P
Bunu görmek için üst sınıfının giriş koşulunu etkisiz hale getiren bir alt sınıfa bakalım:
)

---
class Protokol {
// ...

    void hesapla(double d)
    in {
        assert($(HILITE d > 42));

    } body {
        // ...
    }
}

class ÖzelProtokol : Protokol {
    /* 'in' bloğu bulunmadığından, bu işlev
     * 'Protokol.hesapla'nın giriş koşulunu belki de
     * istemeden etkisizleştirir. */
    override void hesapla(double d) {
        // ...
    }
}

void main() {
    auto ö = new ÖzelProtokol();
    ö.hesapla($(HILITE 10));    /* HATA: Parametre değeri olan 10 üst
                       * sınıfın giriş koşulunu sağlamadığı
                       * halde bu çağrı başarılı olur. */
}
---

$(P
Bir çözüm, $(C ÖzelProtokol.hesapla)'ya her zaman için başarısız olan bir giriş koşulu eklemektir:
)

---
class ÖzelProtokol : Protokol {
    override void hesapla(double d)
    in {
        $(HILITE assert(false));

    } body {
        // ...
    }
}
---

$(P
Bu sefer üst sınıfın giriş koşulu etkili olacak ve yanlış parametre değeri yakalanacaktır:
)

$(SHELL
core.exception.AssertError@deneme.d: Assertion failure
)

$(H5 Özet)

$(UL

$(LI
$(C in) ve $(C out) bloklarını üye işlevlerle de kullanabilirsiniz; kurucu işleve ekleyerek nesnelerin geçersiz parametrelerle kurulmalarını önleyebilirsiniz.
)

$(LI
Nesnelerin yaşamları boyunca her zaman için tutarlı olmalarını garantilemek için $(C invariant) bloklarını kullanabilirsiniz.
)

$(LI
Alt türlerin üye işlevlerinin de $(C in) blokları olabilir. Alt sınıfların giriş koşulları üst sınıftakilerden daha ağır olmamalıdır. ($(I $(C in) bloğunun olmaması "hiç giriş koşulu gerektirmemek" anlamına gelir.))
)

$(LI
Alt türlerin üye işlevlerinin de $(C out) blokları olabilir. Alt sınıf işlevleri kendi garantilerinden başka üst sınıfların garantilerini de sağlamak zorundadırlar.
)

)

Macros:
        SUBTITLE=Yapı ve Sınıflarda Sözleşmeli Programlama

        DESCRIPTION=D yapılarının ve sınıflarının sözleşmeli programlama olanaklarından olan ve nesnelerin tutarlılıklarını denetleyen invariant anahtar sözcüğü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar yapı struct kullanıcı türleri sözleşmeli programlama design by contract in out invariant mutlak değişmez

SOZLER=
$(acikca_elle_yapilan)
$(mutlak_degismez)
$(otomatik)
$(sozlesmeli_programlama)
