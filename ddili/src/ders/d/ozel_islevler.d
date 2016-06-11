Ddoc

$(DERS_BOLUMU Kurucu ve Diğer Özel İşlevler)

$(P
Her ne kadar bu bölümde yalnızca yapıları kullanıyor olsak da bu temel işlemler daha sonra göreceğimiz sınıflar için de geçerlidir. Sınıflardaki farklılıklarını daha sonraki bölümlerde göstereceğim.
)

$(P
Yapıların üye işlevleri arasından dört tanesi nesnelerin temel işlemlerini belirledikleri için ayrıca önemlidir:
)

$(UL
$(LI Kurucu işlev $(C this))
$(LI Sonlandırıcı işlev $(C ~this))
$(LI Kopya sonrasını belirleyen $(C this(this)))
$(LI Atama işleci $(C opAssign))
)

$(P
Bu temel işlemlerin normalde yapılar için özel olarak tanımlanmaları gerekmez çünkü o işlemler zaten derleyici tarafından otomatik olarak halledilirler. Yine de bu işlevlerin özel olarak kendi isteğimiz doğrultusunda tanımlanmalarının gerektiği durumlar olabilir.
)

$(H5 $(IX kurucu) $(IX this, kurucu) Kurucu işlev)

$(P
Kurucu işlevin asıl görevi bir nesnenin üyelerine gerekli değerleri atayarak onu kullanılabilir duruma getirmektir.
)

$(P
Kurucu işlevleri şimdiye kadar hem bütün yapı örneklerinde hem de $(C File) gibi kütüphane türlerinde gördük. Türün ismi işlev çağrısı gibi kullanıldığında o türün kurucu işlevi çağrılır. Bunu aşağıdaki satırın sağ tarafında görüyoruz:
)

---
    auto dersBaşı = $(HILITE GününSaati)(8, 30);
---

$(P
Benzer biçimde, aşağıdaki satırın sağ tarafında da bir sınıf nesnesi kurulmaktadır:
)

---
    auto değişken = new $(HILITE BirSınıf());
---

$(P
Tür ismi işlev çağrısı gibi kullanılırken parantez içinde yazılanlar da kurucu işleve gönderilen parametre değerleri haline gelirler. Örneğin, yukarıdaki 8 ve 30 değerleri $(C GününSaati) kurucu işlevine gönderilen parametre değerleridir.
)

$(P
Şimdiye kadar gördüğümüz nesne kurma söz dizimlerine ek olarak; $(C const), $(C immutable), ve $(C shared) nesneler $(I tür kurucusu) söz dizimiyle de kurulabilirler. ($(C shared) anahtar sözcüğünü $(LINK2 /ders/d/es_zamanli_shared.html, ilerideki bir bölümde) göreceğiz.)
)

$(P
Örneğin, aşağıdaki üç değişken de $(C immutable) oldukları halde, $(C a) değişkeninin kurulma işlemi $(C b) ve $(C c) değişkenlerininkinden anlamsal olarak farklıdır:
)

---
    /* Yaygın söz dizimi; değişebilen bir türün immutable bir
     * değişkeni: */
    $(HILITE immutable) a = S(1);

    /* Tür kurucusu söz dizimi; immutable bir türün bir
     * değişkeni: */
    auto b = $(HILITE immutable(S))(2);

    /* 'b' ile aynı anlamda: */
    immutable c = $(HILITE immutable(S))(3);
---

$(H6 Söz dizimi)

$(P
Diğer işlevlerden farklı olarak, kurucu işlevlerin dönüş değerleri yoktur ve dönüş türü olarak $(C void) bile yazılmaz. Kurucu işlevin ismi $(C this) olmak zorundadır. "Bu" anlamına gelen "this"in "$(I bu) türden nesne kuran işlev" sözünden geldiğini düşünebilirsiniz:
)

---
struct BirYapı {
    // ...

    this(/* kurucu parametreleri */) {
        // ... nesneyi kuran işlemler ...
    }
}
---

$(P
Kurucu parametreleri nesneyi kullanıma hazırlamak için gereken bilgilerden oluşur.
)

$(H6 $(IX otomatik kurucu) $(IX varsayılan kurucu) Otomatik kurucu işlev)

$(P
Şimdiye kadar gördüğümüz bütün yapı örneklerinde derleyici tarafından sağlanan otomatik kurucu işlevden yararlandık. O kurucunun işi, parametre değerlerini sırayla üyelere atamaktır.
)

$(P
$(LINK2 /ders/d/yapilar.html, Yapılar bölümünden) hatırlayacağınız gibi, parametre listesinde sonda bulunan parametrelerin değerlerinin belirtilmesi gerekmez. Değerleri belirtilmeyen üyeler kendi türlerinin $(C .init) değerlerini alırlar. Yine aynı bölümden hatırlayacağınız gibi, üyelerin $(C .init) değerleri üye tanımı sırasında $(C =) işleciyle belirlenebilir:
)

---
struct Deneme {
    int üye $(HILITE = 42);
}
---

$(P
$(LINK2 /ders/d/parametre_serbestligi.html, Parametre Serbestliği bölümünde) gösterilen $(I varsayılan parametre değerleri) olanağını da hatırlarsak, otomatik kurucu işlevin derleyici tarafından aşağıdaki gibi oluşturulduğunu düşünebiliriz:
)

---
struct Deneme {
    char   karakter;
    int    tamsayı;
    double kesirli;

    /* Derleyicinin sağladığı kurucu işlevin eşdeğeri. (Not:
     * Bu işlev nesneyi Deneme() yazımıyla kurarken çağrılmaz;
     * açıklama amacıyla gösteriyorum.) */
    this(in char   karakter_parametre = char.init,
         in int    tamsayı_parametre  = int.init,
         in double kesirli_parametre  = double.init) {
        karakter = karakter_parametre;
        tamsayı  = tamsayı_parametre;
        kesirli  = kesirli_parametre;
    }
}
---

$(P
Eğer çoğu yapıda olduğu gibi o kadarı yeterliyse, bizim ayrıca kurucu işlev tanımlamamız gerekmez. Bütün üyelere geçerli değerler verilmesi nesnenin kurulmuş olması için çoğu durumda yeterlidir.
)

$(H6 $(IX this, üye erişimi) Üyelere $(C this.) ile erişim)

$(P
Yukarıdaki kodda parametrelerle üyeler karışmasınlar diye parametrelerin sonlarına $(C _parametre) diye bir belirteç ekledim. Parametrelerin isimlerini de üyelerle aynı yapsaydım kod hatalı olurdu:
)

---
struct Deneme {
    char   karakter;
    int    tamsayı;
    double kesirli;

    this(in char   karakter = char.init,
         in int    tamsayı  = int.init,
         in double kesirli  = double.init) {
        // 'in' bir parametreyi kendisine atamaya çalışıyor!
        karakter = karakter;    $(DERLEME_HATASI)
        tamsayı  = tamsayı;
        kesirli  = kesirli;
    }
}
---

$(P
Bunun nedeni, işlev içinde $(C karakter) yazıldığında üyenin değil, parametrenin anlaşılmasıdır. Yukarıdaki parametreler $(C in) olarak işaretlendiklerinden sabit değerin değiştirilemeyeceğini bildiren derleme hatası alınır:
)

$(SHELL
Error: variable deneme.Deneme.this.karakter $(HILITE cannot modify const)
)

$(P
Bu konuda bir çözüm olarak $(C this.)'dan yararlanılır: üye işlevler içinde $(C this.), $(I bu nesnenin) anlamına gelir. Bu olanağı kullanınca, parametrelerin isimlerinin sonlarına artık $(C _parametre) gibi ekler yazmak da gerekmez:
)

---
    this(in char   karakter = char.init,
         in int    tamsayı  = int.init,
         in double kesirli  = double.init) {
        $(HILITE this.)karakter = karakter;
        $(HILITE this.)tamsayı  = tamsayı;
        $(HILITE this.)kesirli  = kesirli;
    }
---

$(P
$(C karakter) yazıldığında parametre, $(C this.karakter) yazıldığında da "bu nesnenin üyesi" anlaşılır ve kod artık istediğimizi yapacak biçimde derlenir ve çalışır.
)

$(H6 $(IX programcının tanımladığı kurucu) Programcı tarafından tanımlanan kurucu işlev)

$(P
Yukarıda derleyicinin otomatik olarak yazdığı kurucu işlevin perde arkasında nasıl çalıştığını anlattım. Daha önce de belirttiğim gibi, eğer yapının kurulması için bu kadarı yeterliyse ayrıca kurucu tanımlamak gerekmez. Çoğu duruma uygun olan kurucu perde arkasında zaten derleyici tarafından otomatik olarak yazılır ve çağrılır.
)

$(P
Bazen nesnenin kurulabilmesi için üyelere sırayla değer atamaktan daha karmaşık işlemler gerekebilir. Örnek olarak daha önce tanımlamış olduğumuz $(C Süre) yapısına bakalım:
)

---
struct Süre {
    int dakika;
}
---

$(P
Tek bir tamsayı üyesi bulunan bu yapı için derleyicinin sağladığı kurucu çoğu durumda yeterlidir:
)

---
    zaman.azalt(Süre(12));
---

$(P
Ancak, o kurucu yalnızca dakika miktarını aldığından bazı durumlarda programcıların hesaplar yapmaları gerekebilir:
)

---
    // 23 saat ve 18 dakika öncesi
    zaman.azalt(Süre(23 * 60 + 18));

    // 22 saat ve 20 dakika sonrası
    zaman.ekle(Süre(22 * 60 + 20));
---

$(P
Programcıları böyle hesaplardan kurtarmak için saat ve dakika miktarlarını iki ayrı parametre olarak alan bir $(C Süre) kurucusu düşünülebilir. Böylece toplam dakika hesabı kurucu içinde yapılır:
)

---
struct Süre {
    int dakika;

    this(int saat, int dakika) {
        this.dakika = saat * 60 + dakika;
    }
}
---

$(P
Saat ve dakika farklı iki parametre olduklarından, programcılar da hesabı artık kendileri yapmak zorunda kalmamış olurlar:
)

---
    // 23 saat ve 18 dakika öncesi
    zaman.azalt(Süre($(HILITE 23, 18)));

    // 22 saat ve 20 dakika sonrası
    zaman.ekle(Süre($(HILITE 22, 20)));
---

$(H6 Programcının kurucusu otomatik kurucunun bazı kullanımlarını geçersizleştirir)

$(P
Programcı tarafından tek bir kurucu işlevin bile tanımlanmış olması, derleyicinin oluşturduğu kurucu işlevin $(I varsayılan parametre değerleri) ile kullanımını geçersiz hale getirir. Örneğin $(C Süre)'nin tek parametre ile kurulması derleme hatasına neden olur:
)

---
    zaman.azalt(Süre(12));    $(DERLEME_HATASI)
---

$(P
O tek parametreli kullanım, programcının tanımlamış olduğu iki parametreli kurucuya uymamaktadır. Ek olarak, $(C Süre)'nin otomatik kurucusu o kullanımda artık geçersizdir.
)

$(P
Çözüm olarak kurucuyu $(I yükleyebilir) ve bir tane de tek parametreli kurucu tanımlayabiliriz:
)

---
struct Süre {
    int dakika;

    this(int saat, int dakika) {
        this.dakika = saat * 60 + dakika;
    }

    this(int dakika) {
        this.dakika = dakika;
    }
}
---

$(P
Programcı tarafından tanımlanan kurucu, nesnelerin $(C {&nbsp;}) karakterleriyle kurulmaları olanağını da ortadan kaldırır:
)

---
    Süre süre = { 5 };    $(DERLEME_HATASI)
---

$(P
Buna rağmen, hiç parametre yazılmadan kurulum her zaman için geçerlidir:
)

---
    auto s = Süre();         // derlenir
---

$(P
Bunun nedeni, her türün $(C .init) değerinin derleme zamanında bilinmesinin D'de şart olmasıdır. Yukarıdaki $(C s)'nin değeri $(C Süre) türünün ilk değerine eşittir:
)

---
    assert(s == Süre.init);
---

$(H6 $(IX static opCall) $(IX opCall, static)  Varsayılan kurucu yerine $(C static opCall))

$(P
Her türün ilk değerinin derleme zamanında bilinmesinin gerekli olması varsayılan kurucunun programcı tarafından tanımlanmasını olanaksız hale getirir.
)

$(P
Her nesne kurulduğunda çıktıya bir satır yazdırmaya çalışan aşağıdaki kurucuya bakalım: 
)

---
struct Deneme {
    this() {    $(DERLEME_HATASI)
        writeln("Deneme nesnesi kuruluyor");
    }
}
---

$(P
Derleyici bunun mümkün olmadığını bildirir:
)

$(SHELL
Error: constructor deneme.Deneme.this default constructor for
structs only allowed with @disable and no body
)

$(P $(I Not: Varsayılan kurucunun sınıflar için tanımlanabildiğini ileride göreceğiz.
))

$(P
Bu kısıtlamaya rağmen yapı nesnelerinin parametresiz olarak nasıl kurulacakları $(C static opCall) ile belirlenebilir. Bunun yapının $(C .init) değerine bir etkisi yoktur: $(C static opCall) yalnızca nesnelerin parametresiz olarak kurulmalarını sağlar.
)

$(P
Bunun mümkün olması için $(C static opCall) işlecinin o yapının türünden bir nesne oluşturması ve döndürmesi gerekir:
)

---
import std.stdio;

struct Deneme {
    $(HILITE static) Deneme $(HILITE opCall)() {
        writeln("Deneme nesnesi kuruluyor");
        Deneme deneme;
        return deneme;
    }
}

void main() {
    auto deneme = $(HILITE Deneme());
}
---

$(P
$(C main) içindeki $(C Deneme()) çağrısı $(C static opCall)'u işletir:
)

$(SHELL
Deneme nesnesi kuruluyor
)

$(P
$(I Not: $(C static opCall)'un içindeyken $(C Deneme()) yazılmaması gerektiğine dikkat edin. O yazım da $(C static opCall)'u çağıracağından $(C static opCall)'dan hiç çıkılamaz:
)
)

---
    static Deneme opCall() {
        writeln("Deneme nesnesi kuruluyor");
        return $(HILITE Deneme());    // ← Yine 'static opCall'u çağırır
    }
---

$(P
Çıktısı:
)

$(SHELL
Deneme nesnesi kuruluyor
Deneme nesnesi kuruluyor
Deneme nesnesi kuruluyor
...    $(SHELL_NOTE sürekli olarak tekrarlanır)
)

$(H6 Başka kurucu işlevleri çağırmak)

$(P
Kurucu işlevler başka kurucu işlevleri çağırabilirler ve böylece olası kod tekrarlarının önüne geçilmiş olur. $(C Süre) gibi basit bir yapı bunun yararını anlatmak için uygun olmasa da bu olanağın kullanımını aşağıdaki gibi iki kurucu ile gösterebiliriz:
)

---
    this(int saat, int dakika) {
        this.dakika = saat * 60 + dakika;
    }

    this(int dakika) {
        this(0, dakika);  // diğer kurucuyu çağırıyor
    }
---

$(P
Yalnızca dakika alan kurucu diğer kurucuyu saat değeri yerine 0 göndererek çağırmaktadır.
)

$(P
$(B Uyarı:) Yukarıdaki $(C Süre) kurucularında bir tasarım hatası bulunduğunu söyleyebiliriz. Nesneler tek parametre ile kurulduklarında ne istendiği açık değildir:
)

---
    auto yolSüresi = Süre(10);    // 10 saat mi, 10 dakika mı?
---

$(P
$(C Süre)'nin belgelerine veya tanımına bakarak "10 dakika" dendiğini anlayabiliriz. Öte yandan, iki parametre alan kurucuda ilk parametrenin $(I saat) olması bir tutarsızlık oluşturmaktadır.
)

$(P
Böyle tasarımlar karışıklıklara neden olacaklarından kaçınılmaları gerekir.
)

$(H6 $(IX kurucu nitelendiricisi) $(IX nitelendirici, kurucu) Kurucu nitelendiricileri)

$(P
$(I Değişebilen), $(C const), $(C immutable), ve $(C shared) nesneler normalde aynı kurucu ile kurulur:
)

---
import std.stdio;

struct S {
    this(int i) {
        writeln("Bir nesne kuruluyor");
    }
}

void main() {
    auto d = S(1);
    const c = S(2);
    immutable i = S(3);
    shared s = S(4);
}
---

$(P
Yukarıda sağ taraftaki ifadelerde kurulmakta olan nesneler anlamsal olarak $(I değişebilen) türdendir. Aralarındaki fark, değişkenlerin tür nitelendiricileridir. Bu yüzden, bütün nesneler aynı kurucu ile kurulur:
)

$(SHELL
Bir nesne kuruluyor
Bir nesne kuruluyor
Bir nesne kuruluyor
Bir nesne kuruluyor
)

$(P
Kurulmakta olan nesnenin nitelendiricisine bağlı olarak bazen bazı üyelerinin farklı kurulmaları veya hiç kurulmamaları istenebilir veya gerekebilir. Örneğin, $(C immutable) bir nesnenin hiçbir üyesinin o nesnenin yaşamı boyunca değişmesi söz konusu olmadığından, nesnenin değişebilen bazı nesnelerinin hiç ilklenmemeleri program hızı açısından yararlı olabilir.
)

$(P
$(I Nitelendirilmiş kurucular) farklı niteliklere sahip nesnelerin kurulmaları için farklı tanımlanabilirler:
)

---
import std.stdio;

struct S {
    this(int i) {
        writeln("Bir nesne kuruluyor");
    }

    this(int i) $(HILITE const) {
        writeln("const bir nesne kuruluyor");
    }

    this(int i) $(HILITE immutable) {
        writeln("immutable bir nesne kuruluyor");
    }

    /* 'shared' anahtar sözcüğünü ilerideki bir bölümde
     * göreceğiz. */
    this(int i) $(HILITE shared) {
        writeln("shared bir nesne kuruluyor");
    }
}

void main() {
    auto d = S(1);
    const c = S(2);
    immutable i = S(3);
    shared s = S(4);
}
---

$(P
Ancak, yukarıda da belirtildiği gibi, sağ taraftaki ifadeler anlamsal olarak $(I değişebilen) olduklarından, yukarıdaki nesneler yine de $(I değişebilen) nesne kurucusu ile kurulurlar:
)

$(SHELL
Bir nesne kuruluyor
Bir nesne kuruluyor    $(SHELL_NOTE_WRONG const kurucu DEĞİL)
Bir nesne kuruluyor    $(SHELL_NOTE_WRONG immutable kurucu DEĞİL)
Bir nesne kuruluyor    $(SHELL_NOTE_WRONG shared kurucu DEĞİL)
)

$(P
$(IX tür kurucusu) Nitelendirilmiş kuruculardan yararlanabilmek için $(I tür kurucusu) söz dizimini kullanmak gerekir. ($(I Tür kurucusu) terimi nesne kurucularıyla karıştırılmamalıdır; tür kurucusu türlerle ilgilidir, nesnelerle değil.) Bu söz dizimi, bir nitelendiriciyi ve var olan bir türü birleştirerek farklı bir tür oluşturur. Örneğin, $(C immutable(S)) türü, $(C immutable) ile $(C S)'nin birleşmesinden oluşur:
)

---
    auto d = S(1);
    auto c = $(HILITE const(S))(2);
    auto i = $(HILITE immutable(S))(3);
    auto s = $(HILITE shared(S))(4);
---

$(P
Sağ taraftaki ifadelerdeki nesneler bu sefer farklıdır: $(I değişebilen), $(C const), $(C immutable), ve $(C shared). Dolayısıyla, her nesne kendi türüne uyan kurucu ile kurulur:
)

$(SHELL
Bir nesne kuruluyor
$(HILITE const) bir nesne kuruluyor
$(HILITE immutable) bir nesne kuruluyor
$(HILITE shared) bir nesne kuruluyor
)

$(P
Ek olarak, yukarıdaki nesneler $(C auto) ile kurulduklarından; türleri $(I değişebilen), $(C const), $(C immutable), ve $(C shared) olarak çıkarsanır.
)

$(H6 Kurucu parametresinin değişmezliği)

$(P
$(LINK2 /ders/d/const_ve_immutable.html, Değişmezlik bölümünde) referans türünden olan işlev parametrelerinin $(C const) olarak mı yoksa $(C immutable) olarak mı işaretlenmelerinin daha uygun olduğunun kararının güç olabildiğini görmüştük. Bu güçlük kurucu parametreleri için de geçerlidir. Ancak, kurucu parametrelerinin $(C immutable) olarak seçilmeleri bazı durumlarda $(C const)'tan daha uygundur.
)

$(P
Bunun nedeni, kurucu parametrelerinin daha sonradan kullanılmak üzere sıklıkla nesne içerisinde saklanmalarıdır. $(C immutable) olmadığı zaman, parametrenin kurucu çağrıldığındaki değeriyle daha sonradan kullanıldığındaki değeri farklı olabilir.
)

$(P
Bunun örneği olarak öğrencinin notlarını yazacağı dosyanın ismini parametre olarak alan bir kurucuya bakalım. $(LINK2 /ders/d/const_ve_immutable.html, Değişmezlik bölümündeki) ilkeler doğrultusunda ve daha kullanışlı olabilmek amacıyla parametresi $(C const&nbsp;char[]) olarak tanımlanmış olsun:
)

---
import std.stdio;

struct Öğrenci {
    $(HILITE const char[]) kayıtDosyası;
    size_t[] notlar;

    this($(HILITE const char[]) kayıtDosyası) {
        this.kayıtDosyası = kayıtDosyası;
    }

    void notlarıKaydet() {
        auto dosya = File(kayıtDosyası.idup, "w");
        dosya.writeln("Öğrencinin notları:");
        dosya.writeln(notlar);
    }

    // ...
}

void main() {
    char[] dosyaİsmi;
    dosyaİsmi ~= "ogrenci_notlari";

    auto öğrenci = Öğrenci(dosyaİsmi);

    // ...

    /* dosyaİsmi sonradan değiştiriliyor olsun (bu örnekte
     * bütün harfleri 'A' oluyor): */
    $(HILITE dosyaİsmi[] = 'A');

    // ...

    /* Notlar yanlış dosyaya kaydedilecektir: */
    öğrenci.notlarıKaydet();
}
---

$(P
Yukarıdaki program öğrencinin notlarını $(STRING "ogrenci_notlari") dosyasına değil, ismi bütünüyle A harflerinden oluşan bir dosyaya yazar. O yüzden $(I referans türünden olan) üyelerin ve parametrelerin  $(C immutable) olarak tanımlanmalarının daha uygun oldukları düşünülebilir. Bunun dizgilerde $(C string) ile kolayca sağlanabildiğini biliyoruz. Yapının yalnızca değişen satırlarını gösteriyorum:
)

---
struct Öğrenci {
    $(HILITE string) kayıtDosyası;
    // ...
    this($(HILITE string) kayıtDosyası) {
        // ...
    }
    // ...
}
---

$(P
Kullanıcılar nesneleri artık $(C immutable) dizgilerle kurmak zorundadırlar ve kayıtların yazıldığı dosya konusundaki karışıklık böylece giderilmiş olur.
)

$(H6 $(IX tür dönüşümü, kurucu) Tek parametreli kurucu yoluyla tür dönüşümü)

$(P
Tek parametre alan kurucu işlevlerin aslında tür dönüşümü sağladıkları düşünülebilir: Kurucu işlevin parametresinin türünden yola çıkarak yapının türünde bir nesne üretilmektedir. Örneğin, aşağıdaki yapının kurucusu verilen bir $(C string)'e karşılık bir $(C Öğrenci) üretmektedir:
)

---
struct Öğrenci {
    string isim;

    this(string isim) {
        this.isim = isim;
    }
}
---

$(P
Bu $(I dönüşüm) özellikleri nedeniyle kurucu işlevler $(C to) ve $(C cast) tarafından da dönüşüm amacıyla kullanılırlar. Bunun bir örneğini görmek için aşağıdaki $(C selamVer) işlevine bakalım. O işlev bir $(C Öğrenci) beklediği halde ona $(C string) gönderilmesi doğal olarak derleme hatasına yol açar:
)

---
void selamVer(Öğrenci öğrenci) {
    writeln("Merhaba ", öğrenci.isim);
}
// ...
    selamVer("Eray");    $(DERLEME_HATASI)
---

$(P
Öte yandan, aşağıdaki üç satır da derlenir ve $(C selamVer) işlevi üçünde de geçici bir $(C Öğrenci) nesnesi ile çağrılır:
)

---
import std.conv;
// ...
    selamVer(Öğrenci("Eray"));
    selamVer(to!Öğrenci("Ercan"));
    selamVer(cast(Öğrenci)"Erdost");
---

$(H6 $(IX @disable, kurucu) Varsayılan kurucunun etkisizleştirilmesi)

$(P
$(C @disable) olarak işaretlenen işlevler kullanılamaz.
)

$(P
Bazı durumlarda üyeler için varsayılan mantıklı ilk değerler bulunmayabilir ve nesnelerin kesinlikle özel bir kurucu ile kurulmaları gerekebilir. Örneğin, aşağıdaki türün dosya isminin boş olmaması gerekiyor olabilir:
)

---
struct Arşiv {
    string dosyaİsmi;
}
---

$(P
Ne yazık ki, derleyicinin oluşturduğu kurucu $(C dosyaİsmi)'ni boş olarak ilkleyecektir:
)

---
    auto arşiv = Arşiv();    $(CODE_NOTE dosyaİsmi üyesi boş)
---

$(P
Böyle bir durumu önlemenin yolu, varsayılan kurucuyu tanımını vermeden $(C @disable) olarak bildirmek ve böylece var olan diğer kuruculardan birisinin kullanılmasını şart koşmaktır:
)

---
struct Arşiv {
    string dosyaİsmi;

    $(HILITE @disable this();)            $(CODE_NOTE kullanılamaz)

    this(string dosyaİsmi) {    $(CODE_NOTE kullanılabilir)
        // ...
    }
}

// ...

    auto arşiv = Arşiv();       $(DERLEME_HATASI)
---

$(P
Bu sefer derleyici $(C this())'in kullanılamayacağını bildirir:
)

$(SHELL
Error: constructor deneme.Arşiv.this is $(HILITE not callable) because
it is annotated with @disable
)

$(P
$(C Arşiv) nesneleri ya başka bir kurucu ile ya da doğrudan $(C .init) değeriyle kurulmak zorundadır:
)

---
    auto a = Arşiv("kayitlar");    $(CODE_NOTE derlenir)
    auto b = Arşiv.init;           $(CODE_NOTE derlenir)
---

$(H5 $(IX sonlandırıcı) $(IX ~this) Sonlandırıcı işlev)

$(P
Nesnenin yaşam süreci sona ererken gereken işlemler sonlandırıcı işlev tarafından işletilir.
)

$(P
Derleyicinin sunduğu otomatik sonlandırıcı sıra ile bütün üyelerin kendi sonlandırıcılarını çağırır. Kurucu işlevde de olduğu gibi, çoğu yapı türünde bu kadarı zaten yeterlidir.
)

$(P
Bazı durumlarda ise nesnenin sonlanmasıyla ilgili bazı özel işlemler gerekebilir. Örneğin, nesnenin sahiplenmiş olduğu bir işletim sistemi kaynağının geri verilmesi gerekiyordur; başka bir nesnenin bir üye işlevi çağrılacaktır; başka bir bilgisayar üzerinde çalışmakta olan bir programa onunla olan bağlantının kesilmekte olduğu bildirilecektir; vs.
)

$(P
Sonlandırıcı işlevin ismi $(C ~this)'tir ve kurucuda olduğu gibi onun da dönüş türü yoktur.
)

$(H6 Sonlandırıcı işlev yapılarda otomatik olarak işletilir)

$(P
Sonlandırıcı işlev yapı nesnesinin geçerliliği bittiği an işletilir. (Yapılardan farklı olarak, sonlandırıcı işlev sınıflarda hemen işletilmez.)
)

$(P
$(LINK2 /ders/d/yasam_surecleri.html, Yaşam Süreçleri bölümünden) hatırlayacağınız gibi, nesnelerin yaşam süreçleri tanımlandıkları kapsamdan çıkılırken sona erer. Bir yapı nesnesinin yaşamının sona erdiği durumlar şunlardır:
)

$(UL
$(LI Nesnenin tanımlandığı kapsamdan normal olarak veya atılan bir hata ile çıkılırken:

---
    if (birKoşul) {
        auto süre = Süre(7);
        // ...

    }  // ← Sonlandırıcı işlev 'süre' için burada işletilir
---

)

$(LI İsimsiz bir nesne o nesnenin tanımlandığı ifadenin en sonunda sonlanır:

---
    zaman.ekle(Süre(5));  // ← Süre(5) hazır değeri bu
                          //   ifadenin sonunda sonlanır
---

)

$(LI Bir nesnenin yapı türündeki bütün üyeleri de asıl nesne ile birlikte sonlanırlar.

)

)

$(H6 Sonlandırıcı örneği)

$(P
Sonlandırıcı örneği olarak XML düzeni oluşturmaya yarayan bir yapı tasarlayalım. XML elemanları açılı parantezlerlerle belirtilirler, ve verilerden ve başka XML elemanlarından oluşurlar. XML elemanlarının nitelikleri de olabilir; onları bu örnekte dikkate almayacağız.
)

$(P
Burada amacımız, $(C &lt;isim&gt;) şeklinde açılan bir XML elemanının doğru olarak ve mutlaka $(C &lt;/isim&gt;) şeklinde kapatılmasını sağlamak olacak:
)

$(MONO
  &lt;ders1&gt;   ← dıştaki XML elemanının açılması
    &lt;not&gt;   ← içteki XML elemanının açılması
      57    ← veri
    &lt;/not&gt;  ← içtekinin kapatılması
  &lt;/ders1&gt;  ← dıştakinin kapatılması
)

$(P
Bunu sağlayacak bir yapıyı iki üye ile tasarlayabiliriz. Bu üyeler XML elemanının ismini ve çıkışta ne kadar girintiyle yazdırılacağını temsil edebilirler:
)

---
struct XmlElemanı {
    string isim;
    string girinti;
}
---

$(P
Eğer XML elemanını açma işini kurucu işleve ve kapama işini de sonlandırıcı işleve yaptırırsak, nesnelerin yaşam süreçlerini ayarlayarak istediğimiz çıktıyı elde edebiliriz. Örneğin çıktıya nesne kurulduğunda $(C &lt;eleman&gt;), sonlandırıldığında da $(C &lt;/eleman&gt;) yazdırabiliriz.
)

$(P
Kurucuyu bu amaca göre şöyle yazabiliriz:
)

---
    this(in string isim, in int düzey) {
        this.isim = isim;
        this.girinti = girintiDizgisi(düzey);

        writeln(girinti, '<', isim, '>');
    }
---

$(P
Kurucunun son satırı XML elemanının açılmasını sağlamaktadır. $(C girintiDizgisi), o düzeyin girintisini belirleyen ve boşluklardan oluşan bir $(C string) üretir:
)

---
import std.array;
// ...
string girintiDizgisi(in int girintiAdımı) {
    return replicate(" ", girintiAdımı * 2);
}
---

$(P
Yararlandığı $(C replicate) işlevi, kendisine verilen dizgiyi belirtilen sayıda uç uca ekleyerek yeni bir dizgi üreten bir işlevdir; $(C std.array) modülünde tanımlıdır. Bu durumda yalnızca boşluk karakterlerinden oluşuyor ve satır başlarındaki girintileri oluşturmak için kullanılıyor.
)

$(P
Sonlandırıcı işlevi de XML elemanını kapatmak için benzer biçimde yazabiliriz:
)

---
    ~this() {
        writeln(girinti, "</", isim, '>');
    }
---

$(P
O yapıyı kullanan bir deneme programı aşağıdaki gibi yazılabilir:
)

---
import std.conv;
import std.random;
import std.array;

string girintiDizgisi(in int girintiAdımı) {
    return replicate(" ", girintiAdımı * 2);
}

struct XmlElemanı {
    string isim;
    string girinti;

    this(in string isim, in int düzey) {
        this.isim = isim;
        this.girinti = girintiDizgisi(düzey);

        writeln(girinti, '<', isim, '>');
    }

    ~this() {
        writeln(girinti, "</", isim, '>');
    }
}

void main() {
    immutable dersler = XmlElemanı("dersler", 0);

    foreach (dersNumarası; 0 .. 2) {
        immutable ders =
            XmlElemanı("ders" ~ to!string(dersNumarası), 1);

        foreach (i; 0 .. 3) {
            immutable not = XmlElemanı("not", 2);
            immutable rasgeleNot = uniform(50, 101);

            writeln(girintiDizgisi(3), rasgeleNot);
        }
    }
}
---

$(P
$(C XmlElemanı) nesnelerinin üç kapsamda oluşturulduklarına dikkat edin. Bu programdaki XML elemanlarının açılıp kapanmaları bütünüyle o nesnelerin kurucu ve sonlandırıcı işlevleri tarafından oluşturulmaktadır.
)

$(SHELL
&lt;dersler&gt;
  &lt;ders0&gt;
    &lt;not&gt;
      72
    &lt;/not&gt;
    &lt;not&gt;
      97
    &lt;/not&gt;
    &lt;not&gt;
      90
    &lt;/not&gt;
  &lt;/ders0&gt;
  &lt;ders1&gt;
    &lt;not&gt;
      77
    &lt;/not&gt;
    &lt;not&gt;
      87
    &lt;/not&gt;
    &lt;not&gt;
      56
    &lt;/not&gt;
  &lt;/ders1&gt;
&lt;/dersler&gt;
)

$(P
Çıktıda örnek olarak $(C &lt;dersler&gt;) elemanına bakalım: $(C main) içinde ilk olarak $(C dersler) nesnesi kurulduğu için ilk olarak onun kurucusunun çıktısını görüyoruz; ve $(C main)'den çıkılırken sonlandırıldığı için de en son onun sonlandırıcısının çıktısını görüyoruz.
)

$(H5 $(IX postblit) $(IX this(this)) $(IX kopya sonrası) Kopya sonrası işlevi)

$(P
Kopyalama, var olan bir nesnenin kopyası olarak yeni bir nesne oluşturmaktır.
)

$(P
Yapılarda kopyalama işinin ilk aşamasını derleyici gerçekleştirir. Yeni nesnenin bütün üyelerini var olan nesnenin üyelerinden sırayla kopyalar:
)

---
    auto dönüşSüresi = gidişSüresi;   // kopyalama
---

$(P
Bu işlemi $(I atama) işlemi ile karıştırmayın. Yukarıda sol taraftaki $(C auto), $(C dönüşSüresi) isminde yeni bir nesne kurulduğunu gösterir. $(C auto), oradaki tür ismi yerine geçmektedir.
)

$(P
Atama olması için $(C dönüşSüresi)'nin daha önceden tanımlanmış bir nesne olması gerekirdi:
)

---
    dönüşSüresi = gidişSüresi;  // atama (aşağıda anlatılıyor)
---

$(P
Kopyalama ile ilgili olarak gereken olası özel işlemler otomatik kopyalama işlemi sonlandıktan sonra gerçekleştirilirler.
)

$(P
Kurma ile ilgili olduğu için kopya sonrası işlevinin ismi de $(C this)'tir. Diğer kuruculardan ayırt edilebilmesi için parametre listesine özel olarak $(C this) yazılır:
)

---
    this(this) {
        // ...
    }
---

$(P
$(LINK2 /ders/d/yapilar.html, Yapılar bölümünde) basit bir $(C Öğrenci) yapısı kullanmış ve onun nesnelerinin kopyalanmaları ile ilgili bir sorundan söz etmiştik:
)

---
struct Öğrenci {
    int numara;
    int[] notlar;
}
---

$(P
O yapının $(C notlar) üyesi dinamik dizi olduğu için bir referans türüdür. Bu, bir $(C Öğrenci) nesnesinin bir başkasına kopyalanması durumunda ikisinin $(C notlar) üyelerinin aynı $(I asıl) elemanlara erişim sağlamalarına neden olur. Bu yüzden, birinin notlarında yapılan değişiklik diğerinde de görülür:
)

---
    auto öğrenci1 = Öğrenci(1, [ 70, 90, 85 ]);

    auto öğrenci2 = öğrenci1;   // kopyalama
    öğrenci2.numara = 2;

    öğrenci1.notlar[0] += 5;    // ikincinin notu da değişir:
    assert($(HILITE öğrenci2).notlar[0] == $(HILITE 75));
---

$(P
Bunun önüne geçmek için ikinci öğrencinin $(C notlar) üyesinin yalnızca o nesneye ait bir dizi olması sağlanmalıdır. Bunu kopya sonrası işlevinde gerçekleştirebiliriz:
)

---
struct Öğrenci {
    int numara;
    int[] notlar;

    this(this) {
        notlar = notlar.dup;
    }
}
---

$(P
$(C this(this)) işlevine girildiğinde bütün üyelerin çoktan asıl nesnenin kopyaları olarak otomatik olarak kurulduklarını hatırlayın. İşleve girildiğindeki $(C notlar), asıl nesnenin $(C notlar)'ı ile aynı diziye erişim sağlamaktadır. Yukarıdaki tek satırda yapılan ise, $(C notlar)'ın erişim sağladığı asıl dizinin bir kopyasını almak ve onu yine bu nesnenin $(C notlar)'ına atamaktır. Böylece bu nesnenin $(C notlar)'ı yeni bir diziye erişim sağlamaya başlar.
)

$(P
Birinci öğrencinin notlarında yapılan değişiklik artık ikinci öğrencinin notlarını etkilemez:
)

---
    öğrenci1.notlar[0] += 5;
    assert($(HILITE öğrenci2).notlar[0] == $(HILITE 70));
---

$(H6 $(IX @disable, kopya sonrası) Kopya sonrası işlevinin etkisizleştirilmesi)

$(P
Kopya sonrası işlevi de $(C @disable) ile etkisizleştirilebilir. Böyle bir türün nesneleri otomatik olarak kopyalanamazlar:
)

---
struct Arşiv {
// ...

    $(HILITE @disable this(this);)
}

// ...

    auto a = Arşiv("kayitlar");
    auto b = a;                    $(DERLEME_HATASI)
---

$(P
Derleyici $(C Arşiv) nesnelerinin kopyalanamayacağını bildirir:
)

$(SHELL
Error: struct deneme.Arşiv is $(HILITE not copyable) because it is
annotated with @disable
)

$(H5 $(IX atama işleci) $(IX =) $(IX opAssign) Atama işleci)

$(P
Atama, zaten var olan bir nesneye yeni bir değer vermek anlamına gelir:
)

---
    dönüşSüresi = gidişSüresi;       // atama
---

$(P
Atama temel işlemler arasında diğerlerinden biraz daha karmaşıktır çünkü atama işlemi aslında iki parçadan oluşur:
)

$(UL
$(LI Soldaki nesnenin sonlandırılması)
$(LI Sağdaki nesnenin soldaki nesneye kopyalanması)
)

$(P
Ancak, o iki işlemin yukarıdaki sırada işletilmelerinin önemli bir sakıncası vardır: Nesnenin başarıyla kopyalanacağından emin olunmadan önce sonlandırılması hataya açıktır. Yoksa, nesnenin kopyalanması aşamasında bir hata atılsa elimizde sonlandırılmış ama tam kopyalanamamış bir nesne kalır.
)

$(P
Derleyicinin sunduğu otomatik atama işleci bu yüzden güvenli hareket eder ve perde arkasında aşağıdaki işlemleri gerçekleştirir:
)

$(OL

$(LI Sağdaki nesneyi geçici bir nesneye kopyalar.

$(P
Atama işleminin parçası olan asıl kopyalama işlemi bu adımdır. Henüz soldaki nesnede hiçbir değişiklik yapılmamış olduğundan kopyalama sırasında hata atılsa bile kaybedilen bir şey olmaz.
)

)

$(LI Soldaki nesneyi sonlandırır.

$(P
Atama işleminin diğer parçası bu adımdır.
)

)

$(LI Geçici nesneyi soldaki nesneye aktarır.

$(P
Bu adım ve sonrasında kopya sonrası işlevi veya sonlandırıcı işletilmez. Soldaki nesne ve geçici nesne birbirlerinin yerine kullanılabilir durumda olan iki nesnedir.
)

)

)

$(P
Yalnızca perde arkasındaki bu işlemler süresince geçerli olan geçici nesne yok olduğunda geriye yalnızca sağdaki nesne ve onun kopyası olan soldaki nesne kalır.
)

$(P
Derleyicinin sunduğu otomatik atama işleci hemen hemen her durumda yeterlidir. Eğer herhangi bir nedenle kendiniz tanımlamak isterseniz, atılabilecek olan hatalara karşı dikkatli olmak gerektiğini unutmayın.
)

$(P
Söz dizimi şu şekildedir:
)

$(UL
$(LI İsmi $(C opAssign)'dır)
$(LI Parametre türü yapının kendi türüdür)
$(LI Dönüş türü yapının kendi türüdür)
$(LI İşlevden $(C return this) ile çıkılır)
)

$(P
Ben burada basit $(C Süre) yapısı üzerinde ve çıktıya bir mesaj yazdıracak şekilde tanımlayacağım:
)

---
struct Süre {
    int dakika;

    $(HILITE Süre) opAssign($(HILITE Süre) sağdaki) {
        writefln(
            "dakika, %s değerinden %s değerine değişiyor",
            this.dakika, sağdaki.dakika);

        this.dakika = sağdaki.dakika;

        $(HILITE return this;)
    }
}
// ...
    auto süre = Süre(100);
    süre = Süre(200);          // atama
---

$(P
Çıktısı:
)

$(SHELL
dakika, 100 değerinden 200 değerine değişiyor
)

$(H6 Başka türlerden atamak)

$(P
Bazı durumlarda nesnelere kendi türlerinden farklı türlerin değerlerini de atamak isteyebiliriz. Örneğin atama işlecinin sağ tarafında her zaman için $(C Süre) türü kullanmak yerine, doğrudan bir tamsayı değer kullanmak isteyebiliriz:
)

---
    süre = 300;
---

$(P
Bunu, parametre olarak $(C int) alan bir atama işleci daha tanımlayarak sağlayabiliriz:
)

---
struct Süre {
    int dakika;

    Süre opAssign(Süre sağdaki) {
        writefln(
            "dakika, %s değerinden %s değerine değişiyor",
            this.dakika, sağdaki.dakika);

        this.dakika = sağdaki.dakika;

        return this;
    }

    Süre opAssign($(HILITE int dakika)) {
        writeln(
            "dakika, bir tamsayı değer ile değiştiriliyor");

        this.dakika = dakika;

        return this;
    }
}
// ...
    süre = Süre(200);
    süre = $(HILITE 300);
---

$(P
Çıktısı:
)

$(SHELL
dakika, 100 değerinden 200 değerine değişiyor
dakika, bir tamsayı değer ile değiştiriliyor
)

$(H6 Uyarı)

$(P
Farklı türleri bu şekilde birbirlerine eşitleyebilmek veya daha genel olarak birbirlerinin yerine kullanabilmek, kolaylık getirdiği kadar karışıklıklara ve hatalara da neden olabilir.
)

$(P
Atama işlecini farklı türlerden parametre alacak şekilde tanımlamanın yararlı olduğunu düşündüğünüz zamanlarda bunun gerçekten gerekli olup olmadığını iyice tartmanızı öneririm. Kimi zaman yararlıdır, kimi zaman gereksiz ve sorunludur.
)

$(H5 Özet)

$(UL

$(LI Kurucu işlev ($(C this)) nesneleri kullanıma hazırlar. Derleyicinin otomatik olarak tanımladığı kurucu çoğu durumda yeterlidir.)

$(LI Varsayılan kurucunun davranışı yapılarda değiştirilemez. Gerektiğinde onun yerine $(C static opCall) tanımlanır.)

$(LI Tek parametreli kurucular $(C to) ve $(C cast) tarafından tür dönüşümü sırasında kullanılırlar.)

$(LI Sonlandırıcı işlev ($(C ~this)) nesnenin yaşamı sona ererken işletilmesi gereken işlemleri içerir.)

$(LI Kopya sonrası işlevi ($(C this(this))) derleyicinin otomatik olarak gerçekleştirdiği kopyadan sonra gereken düzeltmeleri içerir.)

$(LI Atama işlevi ($(C opAssign)) var olan nesnelerin başka nesnelerden atanmaları sırasında işletilir.)

)

Macros:
        SUBTITLE=Kurucu ve Diğer Özel İşlevler

        DESCRIPTION=D dili yapılarının ve sınıflarının özel işlevleri olan kurucu, sonlandırıcı, kopyalayıcı, ve atama işleci

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial yapı yapılar struct sınıf sınıflar class üye işlev üye fonksiyon kurucu sonlandırıcı bozucu kopyalayıcı atama işleci işleç this this(this)

SOZLER=
$(atama)
$(cikarsama)
$(islec)
$(kapsam)
$(kopya_sonrasi)
$(kopyalama)
$(kurma)
$(kurucu_islev)
$(sonlandirici_islev)
$(sonlandirma)
$(tur_nitelendirici)
$(varsayilan)
