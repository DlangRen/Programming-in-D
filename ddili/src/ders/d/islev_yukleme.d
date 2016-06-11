Ddoc

$(DERS_BOLUMU $(IX işlev yükleme) $(IX yükleme, işlev) İşlev Yükleme)

$(P
Aynı isimde birden fazla işlev tanımlamaya $(I işlev yükleme) denir. İsimleri aynı olan bu işlevlerin ayırt edilebilmeleri için parametrelerinin birbirlerinden farklı olmaları gerekir.
)

$(P
Bu kullanımda "yükleme" sözcüğünün "aynı isme yeni görev yükleme" anlamına geldiğini düşünebilirsiniz.
)

$(P
Aşağıda aynı isimde ama parametreleri farklı işlevler görüyorsunuz:
)

---
import std.stdio;

void bilgiVer(in $(HILITE double) sayı) {
    writeln("Kesirli sayı: ", sayı);
}

void bilgiVer(in $(HILITE int) sayı) {
    writeln("Tamsayı     : ", sayı);
}

void bilgiVer(in $(HILITE char[]) dizgi) {
    writeln("Dizgi       : ", dizgi);
}

void main() {
    bilgiVer(1.2);
    bilgiVer(3);
    bilgiVer("merhaba");
}
---

$(P
İşlevlerin hepsinin de ismi $(C bilgiVer) olduğu halde, derleyici parametrenin türüne uygun olan işlevi seçer ve onun çağrılmasını sağlar. Örneğin $(C 1.2) hazır değerinin türü $(C double) olduğu için, onun kullanıldığı durumda o işlevler arasından $(C double) parametre alanı çağrılır.
)

$(P
Hangi işlevin çağrılacağı $(I derleme zamanında) seçilir. Bu seçim her zaman kolay veya açık olmayabilir. Örneğin şu kodda kullanılan $(C int) değer hem $(C real) hem de $(C double) türüne uyduğu için derleyici hangisini seçeceğine karar veremez:
)

---
real yediKatı(in real değer) {
    return 7 * değer;
}

double yediKatı(in double değer) {
    return 7 * değer;
}

void main() {
    int sayı = 5;
    auto sonuç = yediKatı(sayı);    $(DERLEME_HATASI)
}
---

$(P $(I Not: Normalde aynı işi yapan böyle iki işlevin yazılması gereksizdir. Tek işlev tanımının nasıl birden fazla tür için kullanılabileceğini daha sonra $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) göreceğiz.)
)

$(P
Öte yandan, bu işlevlerin $(C long) türünde parametre alan bir üçüncüsü tanımlansa derleme hatası ortadan kalkar çünkü yüklenen işlev seçimi konusunda $(C int) değerler $(C long) türüne kesirli türlerden $(I daha uyumludurlar):
)

---
long yediKatı(in long değer) {
    return 7 * değer;
}

// ...

    auto sonuç = yediKatı(sayı);    // şimdi derlenir
---

$(H5 Parametre uyum kuralları)

$(P
Aynı isimde birden fazla işlev bulunması, derleyicinin bir seçim yapmasını gerektirir. Yüklenen işlevler arasından, kullanılan parametrelere $(I daha çok uyan) işlev seçilir.
)

$(P
Bu seçim çoğu durumda kolay ve $(I beklendiği gibi) olur; ama hangi işlevin daha çok uyduğu konusu bazen çok karışıktır. Bu yüzden uyum kuralları geliştirilmiştir.
)

$(P
Parametreler için uyum konusunda dört durum vardır:
)

$(UL
$(LI uyumsuzluk)
$(LI otomatik tür dönüşümü yoluyla uyum)
$(LI $(C const)'a dönüştürerek uyum)
$(LI tam uyum)
)

$(P
Derleyici, yüklenmiş olan işlevlerden hangisini çağıracağına karar vermek için işlevleri gözden geçirir. Her işlevin parametrelerine teker teker bakar ve her parametrenin yukarıdaki dört uyum durumundan hangisinde olduğunu belirler. Bütün parametreler içindeki en az uyum, bu işlevin de uyumu olarak kabul edilir.
)

$(P
Bu şekilde bütün işlevlerin uyum durumları belirlendikten sonra; eğer varsa, en çok uyan işlev seçilir.
)

$(P
Eğer birden fazla işlev aynı derecede uymuşsa, onlardan hangisinin seçileceğine daha da karışık başka kurallar yoluyla karar verilir.
)

$(P
Ben burada bu kuralların daha derinine inmeyeceğim; çünkü eğer bu kadar karışık kurallarla yüz yüze kalmışsanız, aslında programınızın tasarımında değişiklik yapma zamanı gelmiş demektir. Belki de işlev şablonlarını kullanmak daha doğru olacaktır. Hatta belki de aynı isimde işlev tanımlamak yerine, daha açıklayıcı isimler kullanarak hangisini çağırmak istediğinizi açıkça belirtmek bütün karışıklığı ortadan kaldıracaktır: $(C yediKatı_real) ve $(C yediKatı_double) gibi...
)

$(H5 Yapılar için işlev yükleme)

$(P
İşlev yükleme, yapılarda ve sınıflarda çok yararlıdır; üstelik o türlerde işlev seçimi konusunda uyum sorunları da çok daha azdır. Yukarıdaki $(C bilgiVer) işlevini $(LINK2 /ders/d/yapilar.html, Yapılar bölümünde) kullandığımız bazı türler için yükleyelim:
)

---
struct GününSaati {
    int saat;
    int dakika;
}

void bilgiVer(in GününSaati zaman) {
    writef("%02s:%02s", zaman.saat, zaman.dakika);
}
---

$(P
O tanım sayesinde artık $(C GününSaati) nesnelerini de $(C bilgiVer) işlevine gönderebiliriz. Böylece programımızda her tür nesneyi aynı isimle yazdırabileceğimiz alışılmış bir yöntemimiz olur:
)

---
    auto kahvaltıZamanı = GününSaati(7, 0);
    bilgiVer(kahvaltıZamanı);
---

$(P
Temel türlerde olduğu gibi, artık $(C GününSaati) nesneleri de kendilerine özgü çıktı düzenleri ile yazdırılmış olurlar:
)

$(SHELL
07:00
)

$(P
$(C bilgiVer) işlevini yapılar bölümünde değinilen $(C Toplantı) yapısı için de yükleyelim:
)

---
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
---

$(P
Gördüğünüz gibi; $(C bilgiVer)'in $(C GününSaati) için yüklenmiş olanı, $(C Toplantı)'yı yazdıran işlev tarafından kullanılmaktadır. Artık $(C Toplantı) nesnelerini de alıştığımız isimdeki işlevle yazdırabiliriz:
)

---
    auto geziToplantısı =
        Toplantı("Bisikletle gezilecek yerler", 3,
                 GününSaati(9, 0), GününSaati(9, 10));
    bilgiVer(geziToplantısı);
---

$(P
Çıktısı:
)

$(SHELL
09:00-09:10 "Bisikletle gezilecek yerler" toplantısı (3 katılımcı)
)

$(H5 Eksiklikler)

$(P
Yukarıdaki $(C bilgiVer) işlevi her ne kadar kullanım kolaylığı getirse de, bu yöntemin bazı eksiklikleri vardır:
)

$(UL

$(LI
$(C bilgiVer) işlevi yalnızca $(C stdout)'a yazdığı için fazla kullanışlı değildir. Oysa örneğin $(C File) türünden bir dosyaya da yazabiliyor olsa, kullanışlılığı artardı. Bunu sağlamanın yolu, çıktının yazdırılacağı akımı da işleve bir parametre olarak vermektir:

---
void bilgiVer(File akım, in GününSaati zaman) {
    akım.writef("%02s:%02s", zaman.saat, zaman.dakika);
}
---

$(P
O sayede $(C GününSaati) nesnelerini istersek $(C stdout)'a, istersek de bir dosyaya yazdırabiliriz:
)

---
    bilgiVer($(HILITE stdout), kahvaltıZamanı);

    auto dosya = File("bir_dosya", "w");
    bilgiVer($(HILITE dosya), kahvaltıZamanı);
---

$(P
$(I Not: $(C stdin), $(C stdout), ve $(C stderr) nesnelerinin türleri de aslında $(C File)'dır.)
)

)

$(LI
Daha önemlisi, $(C bilgiVer) gibi bir işlev, yapı nesnelerini temel türler kadar rahatça kullanabilmemiz için yeterli değildir. Temel türlerden alışık olduğumuz rahatlık yoktur:

---
    writeln(kahvaltıZamanı);  // Kullanışsız: Genel düzende yazar
---

$(P
O kod çalıştırıldığında $(C GününSaati) türünün ismi ve üyelerinin değerleri programa uygun biçimde değil, genel bir düzende yazdırılır:
)

$(SHELL
GününSaati(7, 0)
)

$(P
Bunun yerine, yapı nesnesinin değerini örneğin $(STRING "12:34") biçiminde bir $(C string)'e dönüştürebilen bir işlev olması çok daha yararlı olur. Yapı nesnelerinin de otomatik olarak $(C string)'e dönüştürülebileceklerini bundan sonraki bölümde göstereceğim.
)

)

)

$(PROBLEM_TEK

$(P
$(C bilgiVer) işlevini şu iki yapı için de yükleyin:
)

---
struct Yemek {
    GününSaati zaman;
    string     adres;
}

struct GünlükPlan {
    Toplantı sabahToplantısı;
    Yemek    öğleYemeği;
    Toplantı akşamToplantısı;
}
---

$(P
$(C Yemek) yapısı yalnızca başlangıç zamanını barındırdığı için; onun bitiş zamanını başlangıç zamanından bir buçuk saat sonrası olarak belirleyin. Bu işlem için yapılar bölümünde tanımladığımız $(C zamanEkle) işlevi yararlı olabilir:
)

---
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
---

$(P
Yemek bitiş zamanları o işlev yardımıyla hesaplanınca $(C GünlükPlan) nesneleri çıkışa şuna benzer şekilde yazdırılabilirler:
)

$(SHELL
10:30-11:45 "Bisiklet gezisi" toplantısı (4 katılımcı)
12:30-14:00 Yemek, Yer: Taksim
15:30-17:30 "Bütçe" toplantısı (8 katılımcı)
)

)


Macros:
        SUBTITLE=İşlev Yükleme

        DESCRIPTION=D'nin işlevlerin kullanışlılığını arttıran olanaklarından işlev yükleme olanağı [overloading]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev yükleme overloading

SOZLER=
$(acikca_elle_yapilan)
$(otomatik)
$(tur_donusumu)
$(yukleme)
