Ddoc

$(DERS_BOLUMU $(IX üye işlev) $(IX işlev, üye) Üye İşlevler)

$(P
Bu bölümde her ne kadar yapıları kullanıyor olsak da buradaki bilgilerin çoğu daha sonra göreceğimiz sınıflar için de geçerlidir.
)

$(P
Bu bölümde yapıların ve sınıfların üye işlevlerini tanıyacağız, ve bunların içerisinden özel olarak, nesneleri $(C string) türüne dönüştürmede kullanılan $(C toString) üye işlevini göreceğiz.
)

$(P
Bir yapının tanımlandığı çoğu durumda, o yapıyı kullanan bir grup işlev de onunla birlikte tanımlanır. Bunun örneklerini önceki bölümlerde $(C zamanEkle) ve $(C bilgiVer) işlevlerinde gördük. O işlevler bir anlamda $(C GününSaati) yapısı ile birlikte $(I sunulan) ve o yapının $(I arayüzünü) oluşturan işlevlerdir.)

$(P
Hatırlarsanız; $(C zamanEkle) ve $(C bilgiVer) işlevlerinin ilk parametresi, $(I üzerinde işlem yaptıkları) nesneyi belirliyordu. Şimdiye kadar tanımladığımız bütün diğer işlevler gibi, onlar da bağımsız olarak, tek başlarına, ve modül kapsamında tanımlanmışlardı.
)

$(P
Bir yapının arayüzünü oluşturan işlevler çok karşılaşılan bir kavram olduğu için; o işlevler yapının içinde, yapının üye işlevleri olarak da tanımlanabilirler.
)

$(H5 Üye işlev)

$(P
Bir yapının veya sınıfın küme parantezlerinin içinde tanımlanan işlevlere $(I üye işlev) denir:
)

---
struct BirYapı {
    void $(I üye_işlev)(/* parametreleri */) {
        // ... işlevin tanımı ...
    }

    // ... yapının üyeleri ve diğer işlevleri ...
}
---

$(P
Üye işlevlere yapının diğer üyelerinde olduğu gibi nesne isminden sonraki nokta karakteri ve ardından yazılan işlev ismi ile erişilir:
)

---
    $(I nesne.üye_işlev(parametreleri));
---

$(P
Üye işlevleri aslında daha önce de kullandık; örneğin standart giriş ve çıkış işlemlerinde $(C stdin) ve $(C stdout) nesnelerini açıkça yazabiliyorduk:
)

---
    stdin.readf(" %s", &numara);
    stdout.writeln(numara);
---

$(P
O satırlardaki $(C readf) ve $(C writeln) üye işlevlerdir.
)

$(P
İlk örneğimiz olarak $(C GününSaati) yapısını yazdıran $(C bilgiVer) işlevini bir üye işlev olarak tanımlayalım. O işlevi daha önce serbest olarak şöyle tanımlamıştık:
)

---
void bilgiVer(in GününSaati zaman) {
    writef("%02s:%02s", zaman.saat, zaman.dakika);
}
---

$(P
Üye işlev olarak yapının içinde tanımlanırken bazı değişiklikler gerekir:
)

---
struct GününSaati {
    int saat;
    int dakika;

    void bilgiVer() {
        writef("%02s:%02s", saat, dakika);
    }
}
---

$(P
Daha önce yapı dışında serbest olarak tanımlanmış olan $(C bilgiVer) işlevi ile bu üye işlev arasında iki fark vardır:
)

$(UL
$(LI Üye işlev yazdırdığı nesneyi parametre olarak almaz)
$(LI O yüzden üyelere $(C zaman.saat) ve $(C zaman.dakika) diye değil, $(C saat) ve $(C dakika) diye erişir)
)

$(P
Bunun nedeni, üye işlevlerin zaten her zaman için bir nesne üzerinde çağrılıyor olmalarıdır:
)

---
    auto zaman = GününSaati(10, 30);
    $(HILITE zaman.)bilgiVer();
---

$(P
Orada, $(C bilgiVer) işlevi $(C zaman) nesnesini yazdıracak şekilde çağrılmaktadır. Üye işlevin tanımı içinde noktasız olarak yazılan $(C saat) ve $(C dakika), $(C zaman) nesnesinin üyeleridir; ve sırasıyla $(C zaman.saat) ve $(C zaman.dakika) üyelerini temsil ederler.
)

$(P
O üye işlev çağrısı, daha önceden serbest olarak yazılmış olan $(C bilgiVer)'in şu şekilde çağrıldığı durumla eşdeğerdir:
)

---
    zaman.bilgiVer();    // üye işlev
    bilgiVer(zaman);     // serbest işlev (önceki tanım)
---

$(P
Üye işlev her çağrıldığında, üzerinde çağrıldığı nesnenin üyelerine erişir:
)

---
    auto sabah = GününSaati(10, 0);
    auto akşam = GününSaati(22, 0);

    $(HILITE sabah).bilgiVer();
    write('-');
    $(HILITE akşam).bilgiVer();
    writeln();
---

$(P
$(C bilgiVer), $(C sabah) üzerinde çağrıldığında $(C sabah)'ın değerini, $(C akşam) üzerinde çağrıldığında da $(C akşam)'ın değerini yazdırır:
)

$(SHELL
10:00-22:00
)

$(H6 $(IX toString) Nesneyi $(C string) olarak ifade eden $(C toString))

$(P
Bir önceki bölümde $(C bilgiVer) işlevinin eksikliklerinden söz etmiştim. Rahatsız edici bir diğer eksikliğini burada göstermek istiyorum: Her ne kadar zamanı okunaklı bir düzende çıktıya gönderiyor olsa da, genel çıktı düzeni açısından $(C '-') karakterini yazdırmayı ve satırın sonlandırılmasını kendimiz ayrıca halletmek zorunda kalıyoruz.
)

$(P
Oysa, nesnelerin diğer türler gibi kullanışlı olabilmeleri için örneğin şu şekilde yazabilmemiz çok yararlı olurdu:
)

---
    writefln("%s-%s", sabah, akşam);
---

$(P
Öyle yazabilseydik; daha önceki 4 satırı böyle tek satıra indirgemiş olmanın yanında, nesneleri $(C stdout)'tan başka akımlara da, örneğin bir dosyaya da aynı şekilde yazdırabilirdik:
)

---
    auto dosya = File("zaman_bilgisi", "w");
    dosya.writefln("%s-%s", sabah, akşam);
---

$(P
Yapıların $(C toString) ismindeki üye işlevleri özeldir ve nesneleri $(C string) türüne dönüştürmek için kullanılır. Bunun doğru olarak çalışabilmesi için, ismi "string'e dönüştür"den gelen bu işlev o nesneyi ifade eden bir $(C string) döndürmelidir.
)

$(P
Bu işlevin içeriğini sonraya bırakalım, ve önce yapı içinde nasıl tanımlandığına bakalım:
)

---
import std.stdio;

struct GününSaati {
    int saat;
    int dakika;

    string toString() {
        return "deneme";
    }
}

void main() {
    auto sabah = GününSaati(10, 0);
    auto akşam = GününSaati(22, 0);

    writefln("%s-%s", sabah, akşam);
}
---

$(P
Nesneleri dizgi olarak kullanabilen kütüphane işlevleri onların $(C toString) işlevlerini çağırırlar ve döndürülen dizgiyi kendi amaçlarına uygun biçimde kullanırlar.
)

$(P
Bu örnekte henüz anlamlı bir dizgi üretmediğimiz için çıktı da şimdilik anlamsız oluyor:
)

$(SHELL
deneme-deneme
)

$(P
Ayrıca $(C bilgiVer)'i artık emekliye ayırmakta olduğumuza da dikkat edin; $(C toString)'in tanımını tamamlayınca ona ihtiyacımız kalmayacak.
)

$(P
$(C toString) işlevini yazmanın en kolay yolu, $(C std.string) modülünde tanımlanmış olan $(C format) işlevini kullanmaktır. Bu işlev, çıktı düzeni için kullandığımız bütün olanaklara sahiptir ve örneğin $(C writef) ile aynı şekilde çalışır. Tek farkı, ürettiği sonucu bir akıma göndermek yerine, bir $(C string) olarak döndürmesidir.
)

$(P
$(C toString)'in de zaten bir $(C string) döndürmesi gerektiği için, $(C format)'ın döndürdüğü değeri olduğu gibi döndürebilir:
)

---
import std.string;
// ...
struct GününSaati {
// ...
    string toString() {
        return $(HILITE format)("%02s:%02s", saat, dakika);
    }
}
---

$(P
$(C toString)'in yalnızca bu nesneyi $(C string)'e dönüştürdüğüne dikkat edin. Çıktının geri kalanı, $(C writefln) çağrısı tarafından halledilmektedir. $(C writefln), $(C "%s") düzen bilgilerine karşılık olarak $(C toString)'i otomatik olarak iki nesne için ayrı ayrı çağırır, aralarına $(C '-') karakterini yerleştirir, ve en sonunda da satırı sonlandırır:
)

$(SHELL
10:00-22:00
)

$(P
Görüldüğü gibi, burada anlatılan $(C toString) işlevi parametre almamaktadır. $(C toString)'in parametre olarak $(C delegate) alan bir tanımı daha vardır. O tanımını daha ilerideki $(LINK2 /ders/d/kapamalar.html, İşlev Göstergeleri, İsimsiz İşlevler, ve Temsilciler bölümünde) göreceğiz.
)

$(H6 Örnek: $(C ekle) üye işlevi)

$(P
Bu sefer de $(C GününSaati) nesnelerine zaman ekleyen bir üye işlev tanımlayalım.
)

$(P
Ama ona geçmeden önce, önceki bölümlerde yaptığımız bir yanlışı gidermek istiyorum. $(LINK2 /ders/d/yapilar.html, Yapılar bölümünde) tanımladığımız $(C zamanEkle) işlevinin, $(C GününSaati) nesnelerini toplamasının normal bir işlem olmadığını görmüş, ama yine de o şekilde kullanmıştık:
)

---
GününSaati zamanEkle(in GününSaati başlangıç,
                     in GününSaati eklenecek) {    // anlamsız
    // ...
}
---

$(P
Gün içindeki iki zamanı birbirine eklemek doğal bir işlem değildir. Örneğin yola çıkma zamanına sinemaya varma zamanını ekleyemeyiz. Gün içindeki bir zamana eklenmesi normal olan, bir $(I süredir.) Örneğin yola çıkma zamanına $(I yol süresini) ekleyerek sinemaya varış zamanını buluruz.
)

$(P
Öte yandan, gün içindeki iki zamanın birbirlerinden çıkartılmaları normal bir işlem olarak görülebilir. O işlemin sonucu da örneğin $(C Süre) türünden olmalıdır.
)

$(P
Bu bakış açısı ile, dakika duyarlığıyla çalışan bir $(C Süre) yapısını ve onu kullanan $(C zamanEkle) işlevini şöyle yazabiliriz:
)

---
struct Süre {
    int dakika;
}

GününSaati zamanEkle(in GününSaati başlangıç, in Süre süre) {
    // başlangıç'ın kopyasıyla başlıyoruz
    GününSaati sonuç = başlangıç;

    // Süreyi ekliyoruz
    sonuç.dakika += süre.dakika;

    // Taşmaları ayarlıyoruz
    sonuç.saat += sonuç.dakika / 60;
    sonuç.dakika %= 60;
    sonuç.saat %= 24;

    return sonuç;
}

unittest {
    // Basit bir test
    assert(zamanEkle(GününSaati(10, 30), Süre(10))
           == GününSaati(10, 40));

    // Gece yarısı testi
    assert(zamanEkle(GününSaati(23, 9), Süre(51))
           == GününSaati(0, 0));

    // Sonraki güne taşma testi
    assert(zamanEkle(GününSaati(17, 45), Süre(8 * 60))
           == GününSaati(1, 45));
}
---

$(P
Şimdi aynı işlevi bir üye işlev olarak tanımlayalım. Üye işlev zaten bir nesne üzerinde çalışacağı için $(C GününSaati) parametresine gerek kalmaz ve parametre olarak yalnızca süreyi geçirmek yeter:
)

---
struct Süre {
    int dakika;
}

struct GününSaati {
    int saat;
    int dakika;

    string toString() {
        return format("%02s:%02s", saat, dakika);
    }

    void $(HILITE ekle)(in Süre süre) {
        dakika += süre.dakika;

        saat += dakika / 60;
        dakika %= 60;
        saat %= 24;
    }

    unittest {
        auto zaman = GününSaati(10, 30);

        // Basit bir test
        zaman$(HILITE .ekle)(Süre(10));
        assert(zaman == GününSaati(10, 40));

        // 15 saat sonra bir sonraki güne taşmalı
        zaman$(HILITE .ekle)(Süre(15 * 60));
        assert(zaman == GününSaati(1, 40));

        // 22 saat ve 20 dakika sonra gece yarısı olmalı
        zaman$(HILITE .ekle)(Süre(22 * 60 + 20));
        assert(zaman == GününSaati(0, 0));
    }
}
---

$(P
$(C ekle), nesnenin zamanını belirtilen süre kadar ilerletir. Daha sonraki bölümlerde göreceğimiz $(I işleç yükleme) olanağı sayesinde bu konuda biraz daha kolaylık kazanacağız. Örneğin $(C +=) işlecini yükleyerek yapı nesnelerini de temel türler gibi kullanabileceğiz:
)

---
    zaman += Süre(10);      // bunu daha sonra öğreneceğiz
---

$(P
Ayrıca gördüğünüz gibi, üye işlevler için de $(C unittest) blokları yazılabilir. O blokların yapı tanımını kalabalıklaştırdığını düşünüyorsanız, bloğu bütünüyle yapının dışında da tanımlayabilirsiniz:
)

---
struct GününSaati {
    // ... yapı tanımı ...
}

unittest {
    // ... yapı testleri ...
}
---

$(P
Bunun nedeni, $(C unittest) bloklarının aslında belirli bir noktada tanımlanmalarının gerekmemesidir. Denetledikleri kodlarla bir arada bulunmaları daha doğal olsa da, onları uygun bulduğunuz başka yerlerde de tanımlayabilirsiniz.
)

$(PROBLEM_COK

$(PROBLEM
$(C GününSaati) yapısına nesnelerin değerini $(C Süre) kadar azaltan bir üye işlev ekleyin. $(C ekle) işlevinde olduğu gibi, süre azaltıldığında bir önceki güne taşsın. Örneğin 00:05'ten 10 dakika azaltınca 23:55 olsun.

$(P
Başka bir deyişle, $(C azalt) işlevini şu birim testlerini geçecek biçimde gerçekleştirin:
)

---
struct GününSaati {
    // ...

    void azalt(in Süre süre) {
        // ... burasını siz yazın ...
    }

    unittest {
        auto zaman = GününSaati(10, 30);

        // Basit bir test
        zaman.azalt(Süre(12));
        assert(zaman == GününSaati(10, 18));

        // 3 gün ve 11 saat önce
        zaman.azalt(Süre(3 * 24 * 60 + 11 * 60));
        assert(zaman == GününSaati(23, 18));

        // 23 saat ve 18 dakika önce gece yarısı olmalı
        zaman.azalt(Süre(23 * 60 + 18));
        assert(zaman == GününSaati(0, 0));

        // 1 dakika öncesi
        zaman.azalt(Süre(1));
        assert(zaman == GününSaati(23, 59));
    }
}
---

)

$(PROBLEM
Daha önce $(LINK2 /ders/d/islev_yukleme.cozum.html, İşlev Yükleme bölümünün çözümünde) kullanılan diğer bütün $(C bilgiVer) işlevlerinin yerine $(C Toplantı), $(C Yemek), ve $(C GünlükPlan) yapıları için $(C toString) üye işlevlerini tanımlayın.

$(P
Çok daha kullanışlı olmalarının yanında, her birisinin tek satırda yazılabildiğini göreceksiniz.
)

)

)

Macros:
        SUBTITLE=Üye İşlevler

        DESCRIPTION=D dili yapılarının ve sınıflarının üye işlevleri, ve toString

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial yapı yapılar struct üye işlev üye fonksiyon toString

SOZLER=
$(arayuz)
$(islec)
$(phobos)
$(uye_islev)
$(yapi)
$(yukleme)
