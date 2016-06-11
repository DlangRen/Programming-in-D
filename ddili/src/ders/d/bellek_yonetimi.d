Ddoc

$(DERS_BOLUMU $(IX bellek yönetimi) Bellek Yönetimi)

$(P
Şimdiye kadar yazdığımız programlarda hiç bellek yönetimiyle ilgilenmek zorunda kalmadık çünkü D bellek yönetimi gerektirmeyen bir dildir. O yüzden, burada anlatılanlara büyük olasılıkla hiç ihtiyaç duymayacaksınız. Buna rağmen, D gibi sistem dillerinde alt düzey bellek işlemleri ile ilgilenmek gerekebilir.
)

$(P
Bellek yönetimi çok kapsamlı bir konudur. Bu bölümde yalnızca çöp toplayıcıyı tanıyacağız, çöp toplayıcıdan nasıl bellek ayrıldığını ve belirli bellek bölgelerine değişkenlerin nasıl yerleştirildiklerini göreceğiz. Farklı bellek yönetimi yöntemlerini ve özellikle $(C std.allocator) modülünü kendiniz araştırmanızı öneririm. ($(C std.allocator) bu kitap yazıldığı sırada henüz deneysel aşamadaydı.)
)

$(P
Önceki bazı bölümlerde olduğu gibi, aşağıda kısaca yalnızca $(I değişken) yazdığım yerlerde yapı ve sınıf nesneleri de dahil olmak üzere her türden değişkeni kastediyorum.
)

$(H5 $(IX bellek) Bellek)

$(P
Bellek hem programın kendisini hem de kullandığı verileri barındırır. Bu yüzden diğer bilgisayar kaynaklarından daha önemlidir. Bu kaynak temelde işletim sistemine aittir. İşletim sistemi belleği ihtiyaçlar doğrultusunda programlara paylaştırır. Her programın kullanmakta olduğu bellek o programın belirli zamanlardaki ihtiyaçları doğrultusunda artabilir veya azalabilir. Belirli bir programın kullandığı bellek o program sonlandığında tekrar işletim sistemine geçer.
)

$(P
Bellek, değişken değerlerinin yazıldığı bir defter gibi düşünülebilir. Her değişken bellekte belirli bir yere yazılır. Her değişkenin değeri gerektikçe aynı yerden okunur ve kullanılır. Yaşamı sona eren değişkenlerin yerleri daha sonradan başka değişkenler için kullanılır.
)

$(P
$(IX &, adres) Bellekle ilgili deneyler yaparken değişkenlerin adres değerlerini veren $(C &) işlecinden yararlanabiliriz:
)

---
import std.stdio;

void main() {
    int i;
    int j;

    writeln("i: ", $(HILITE &)i);
    writeln("j: ", $(HILITE &)j);
}
---

$(P
$(I  Not: Adresler programın her çalıştırılışında büyük olasılıkla farklı olacaktır. Ek olarak, adres değerini edinmiş olmak, normalde bir mikro işlemci yazmacında yaşayacak olan bir değişkenin bile bellekte yaşamasına neden olur.)
)

$(P
Çıktısı:
)

$(SHELL
i: 7FFF2B633E2$(HILITE 8)
j: 7FFF2B633E2$(HILITE C)
)

$(P
Adreslerdeki tek fark olan son hanelere bakarak $(C i)'nin bellekte $(C j)'den hemen önce bulunduğunu görebiliyoruz: 8'e $(C int)'in büyüklüğü olan 4'ü eklersek on altılı sayı düzeninde C elde edilir.
)

$(H5 $(IX çöp toplayıcı) $(IX GC, çöp toplayıcı) Çöp toplayıcı)

$(P
D programlarındaki dinamik değişkenler çöp toplayıcıya ait olan bellek bölgelerinde yaşarlar. Yaşamları sona eren değişkenler çöp toplayıcının işlettiği bir algoritma ile sonlandırılırlar. Bu değişkenlerin yerleri tekrar kullanılmak üzere geri alınır. Bu işleme aşağıda bazen $(I çöp toplama), bazen de $(I temizlik) diyeceğim.
)

$(P
Çöp toplayıcının işlettiği algoritma çok kabaca şöyle açıklanabilir: Çağrı yığıtı da dahil olmak üzere $(I kök) olarak adlandırılan bölgeler taranır. O bölgelerdeki değişkenler yoluyla doğrudan veya dolaylı olarak erişilebilen bütün bellek bölgeleri belirlenir ve program tarafından herhangi bir yolla erişilebilen bütün bölgelerin hâlâ kullanımda olduklarına karar verilir. Kullanımda olmadıkları görülen diğer bellek bölgelerindeki değişkenlerin sonlandırıcıları işletilir ve o bellek bölgeleri sonradan başka değişkenler için kullanılmak üzere geri alınır. Kökler; her iş parçacığının çağrı yığıtından, bütün evrensel değişkenlerden, ve $(C GC.addRoot) veya $(C GC.addRange) ile tanıtılmış olan bölgelerden oluşur.
)

$(P
Bazı çöp toplayıcılar kullanımda olan bütün değişkenleri bellekte yan yana dursunlar diye başka yerlere taşıyabilirler. Programın tutarlılığı bozulmasın diye de o değişkenleri gösteren bütün göstergelerin değerlerini otomatik olarak değiştirirler. (D'nin bu kitabın yazıldığı sırada kullandığı çöp toplayıcısı nesne taşıyan çeşitten değildi.)
)

$(P
Hangi bellek bölgelerinde gösterge bulunduğunun ve hangilerinde bulunmadığının hesabını tutan çöp toplayıcılarına $(I hassas) $(ASIL precise) denir. Bunun aksine, her bellek bölgesindeki değerlerin gösterge olduklarını varsayan çöp toplayıcılarına ise $(I korunumlu) $(ASIL conservative) denir. Bu kitabın yazıldığı sırada kullanılan D çöp toplayıcısının yarı korunumlu olduğunu söyleyebiliriz: yalnızca gösterge içeren bellek bölgelerini, ama o bölgelerin tamamını tarar. Bunun bir etkisi, bazı bellek bölgelerinin hiç toplanmayarak $(I bellek sızıntısı) oluşturabilmesidir. $(I Yalancı göstergelerin) neden olduğu bu durumdan kaçınmak için artık kullanılmadığı bilinen bellek bölgelerinin programcı tarafından açıkça geri verilmesi önerilir.
)

$(P
Temizlik işlemlerinin hangi sırada işletildikleri belirsizdir. Örneğin, nesnelerin referans türündeki (göstergeler dahil) üyeleri kendilerini barındıran nesneden daha önce sonlanmış olabilirler. Bu yüzden, yaşamları çöp toplayıcıya ait olan ve kendileri referans türünden olan üyelerin sonlandırıcı işlevler içinde kullanılmaları hatalıdır. Bu kavram sonlanma sıralarının tam olarak belirli olduğu C++ gibi bazı dillerden farklıdır.
)

$(P
Temizlik işlemleri boş yerin azalmaya başlaması gibi nedenlerle ve önceden kestirilemeyecek zamanlarda işletilebilir. Temizlik işlemleri devam ederken yeni yer ayrılması çöp toplama düzeneğinde karışıklık yaratabileceğinden programa ait olan bütün iş parçacıkları temizlik sırasında kısa süreliğine durdurulabilirler. Bu işlem sırasında programın tutukluk yaptığı hissedilebilir.
)

$(P
Programcının çöp toplayıcının işine karışması çoğu durumda gerekmese de temizlik işlemlerinin hemen işletilmeleri veya ertelenmeleri gibi bazı işlemler $(C core.memory) modülünün olanakları ile sağlanabilir.
)

$(H6 $(IX GC.enable) $(IX GC.disable) $(IX GC.collect) Temizlik başlatmak ve ertelemek)

$(P
Programın tutukluk yapmadan çalışması gereken yerlerde temizlik işlemlerinin ertelenmesi mümkündür. $(C GC.disable) temizlik işlemlerini erteler, $(C GC.enable) da tekrar etkinleştirir:
)

---
    GC.disable();

// ... tutukluk hissedilmeden işlemesi gereken işlemler ...

    GC.enable();
---

$(P
Ancak, temizlik işlemlerinin kesinlikle işletilmeyecekleri garantili değildir: Çöp toplayıcı belleğin çok azaldığını farkettiği durumlarda boş yer bulmak için yine de işletebilir.
)

$(P
Temizlik işlemleri programın tutukluk yapmasının sorun oluşturmadığının bilindiği bir zamanda programcı tarafından $(C GC.collect()) ile başlatılabilir:
)

---
import core.memory;

// ...

    GC.collect();        // temizlik başlatır
---

$(P
Normalde, çöp toplayıcı boş kalan bellek bölgelerini işletim sistemine geri vermez ve ileride oluşturulacak olan değişkenler için elinde tutmaya devam eder. Bunun bir sorun oluşturduğunun bilindiği programlarda boş bellek bölgeleri $(C GC.minimize()) ile işletim sistemine geri verilebilir:
)

---
    GC.minimize();
---

$(H5 Bellekten yer ayırmak)

$(P
Bellekten herhangi bir amaç için bellek bölgesi ayrılabilir. Böyle bir bölge örneğin üzerinde değişkenler kurmak için kullanılabilir.
)

$(P
Belirli sayıda bayttan oluşan bir bellek bölgesi sabit uzunluklu bir dizi olarak ayrılabilir:
)

---
    ubyte[100] yer;                     // 100 baytlık yer
---

$(P
$(IX ilklenmeyen dizi) $(IX dizi, ilklenmeyen) $(IX = void) Yukarıdaki dizi 100 baytlık bellek bölgesi olarak kullanılmaya hazırdır. Bazen bu bölgenin $(C uybte) gibi bir türle ilgisi olması yerine $(I hiçbir türden) olması istenebilir. Bunun için eleman türü olarak $(C void) seçilir ve $(C void) türü herhangi bir değer alamadığından böyle dizilerin özel olarak $(C =void) ile ilklenmeleri gerekir:
)

---
    void[100] yer = void;               // 100 baytlık yer
---

$(P
$(IX GC.calloc) Bu bölümde bellek ayırmak için yalnızca $(C core.memory) modülündeki $(C GC.calloc) işlevini kullanacağız. Aynı modüldeki diğer bellek ayırma işlevlerini kendiniz araştırmak isteyebilirsiniz. Ek olarak, C standart kütüphanesinin olanaklarını içeren $(C std.c.stdlib) modülündeki $(C calloc()) ve diğer işlevler de kullanılabilir.
)

$(P
$(C GC.calloc) bellekten kaç bayt istendiğini parametre olarak alır ve ayırdığı bellek bölgesinin başlangıç adresini döndürür:
)

---
import core.memory;
// ...
    void * yer = GC.calloc(100);        // 100 baytlık yer
---

$(P
$(IX void*) $(C void*) ile gösterilen bir bölgenin hangi tür için kullanılacağı o türün göstergesine dönüştürülerek belirlenebilir:
)

---
    int * intYeri = $(HILITE cast(int*))yer;
---

$(P
Ancak, o ara adım çoğunlukla atlanır ve $(C GC.calloc)'un döndürdüğü adres istenen türe doğrudan dönüştürülür:
)

---
    int * intYeri = cast(int*)GC.calloc(100);
---

$(P
Öylesine seçmiş olduğum 100 gibi hazır değerler kullanmak yerine örneğin türün uzunluğu ile nesne adedi çarpılabilir:
)

---
    // 25 int için yer
    int * yer = cast(int*)GC.calloc($(HILITE int.sizeof * 25));
---

$(P
$(IX classInstanceSize) $(IX .sizeof, class) Sınıf nesnelerinin uzunluğu konusunda önemli bir fark vardır: $(C .sizeof) sınıf nesnesinin değil, sınıf değişkeninin uzunluğudur. Sınıf nesnesinin uzunluğu $(C __traits(classInstanceSize)) ile öğrenilir:
)

---
    // 10 Sınıf nesnesi için yer
    Sınıf * yer =
        cast(Sınıf*)GC.calloc(
            $(HILITE __traits(classInstanceSize, Sınıf)) * 10);
---

$(P
$(IX OutOfMemoryError) İstenen büyüklükte bellek ayrılamadığı zaman $(C core.exception.OutOfMemoryError) türünde bir hata atılır:
)

---
    void * yer = GC.calloc(10_000_000_000);
---

$(P
O kadar bellek ayrılamayan durumdaki çıktısı:
)

$(SHELL
core.exception.OutOfMemoryError
)

$(P
$(IX GC.free) Ayrılan bellek işi bittiğinde $(C GC.free) ile geri verilebilir:
)

---
    GC.free(yer);
---

$(P
Ancak, açıkça çağrılan $(C free()), sonlandırıcıları işletmez. Sonlanmaları gereken nesnelerin bellek geri verilmeden önce $(C destroy()) ile teker teker sonlandırılmaları gerekir. Çöp toplayıcı $(C struct) ve $(C class) nesnelerini sonlandırma kararını verirken çeşitli etkenleri gözden geçirir. Bu yüzden, sonlandırıcının kesinlikle çağrılması gereken bir durumda en iyisi nesneyi $(C new) işleci ile kurmaktır. O zaman $(C GC.free()) sonlandırıcıyı işletir.
)

$(P
$(IX GC.realloc) Daha önce çöp toplayıcıdan alınmış olan bir bellek bölgesinin $(I uzatılması) mümkündür. $(C GC.realloc()), daha önce edinilmiş olan adres değerini ve istenen yeni uzunluğu parametre olarak alır ve yeni uzunlukta bir yer döndürür. Aşağıdaki kod önceden 100 bayt olarak ayrılmış olan bellek bölgesini 200 bayta uzatıyor:
)

---
    void * eskiYer = GC.calloc(100);
// ...
    void * yeniYer = $(HILITE GC.realloc)(eskiYer, 200);
---

$(P
$(C realloc()) gerçekten gerekmedikçe yeni yer ayırmaz:
)

$(UL

$(LI Eski yerin hemen sonrası yeni uzunluğu karşılayacak kadar boşsa orayı da eski yere ekleyerek bir anlamda eski belleği uzatır.)

$(LI Eski yerin hemen sonrası boş değilse veya yeni büyüklük için yeterli değilse, istenen miktarı karşılayacak yeni bir bellek bölgesi ayırır ve eski belleğin içeriğini oraya kopyalar.)

$(LI Eski yer olarak $(C null) gönderilebilir; o durumda yalnızca yeni bir yer ayırır.)

$(LI Yeni uzunluk olarak eski uzunluktan daha küçük bir değer gönderilebilir; o durumda yalnızca bellek bölgesinin geri kalanı çöp toplayıcıya geri verilmiş olur.)

$(LI Yeni uzunluk 0 ise eski bellek $(C free()) çağrılmış gibi geri verilir.)

)

$(P
$(C GC.realloc) C kütüphanesindeki aynı isimli işlevden gelmiştir. Görevi hem fazla çeşitli hem de fazla karmaşık olduğundan hatalı tasarlanmış bir işlev olarak kabul edilir. $(C GC.realloc)'un şaşırtıcı özelliklerinden birisi, asıl bellek $(C GC.calloc) ile ayrılmış bile olsa uzatılan bölümün sıfırlanmamasıdır. Bu yüzden, belleğin sıfırlanmasının önemli olduğu durumlarda aşağıdaki gibi bir işlevden yararlanılabilir ($(C bellekNitelikleri) parametresinin anlamını biraz aşağıda göreceğiz):
)

---
$(CODE_NAME boşOlarakUzat)import core.memory;

/* GC.realloc gibi işler. Ondan farklı olarak, belleğin
 * uzatıldığı durumda eklenen baytları sıfırlar. */
void * boşOlarakUzat(
        void * yer,
        size_t eskiUzunluk,
        size_t yeniUzunluk,
        GC.BlkAttr bellekNitelikleri = GC.BlkAttr.NONE,
        const TypeInfo türBilgisi = null) {
    /* Asıl işi GC.realloc'a yaptırıyoruz. */
    yer = GC.realloc(yer, yeniUzunluk,
                     bellekNitelikleri, türBilgisi);

    /* Eğer varsa, yeni eklenen bölümü sıfırlıyoruz. */
    if (yeniUzunluk > eskiUzunluk) {
        import std.c.string;

        auto eklenenYer = yer + eskiUzunluk;
        auto eklenenUzunluk = yeniUzunluk - eskiUzunluk;

        memset(eklenenYer, 0, eklenenUzunluk);
    }

    return yer;
}
---

$(P
$(IX memset, std.c.string) $(C std.c.string) modülünde tanımlı olan $(C memset()) belirtilen adresteki belirtilen sayıdaki bayta belirtilen değeri atar. Örneğin, yukarıdaki çağrı $(C eklenenYer)'deki $(C eklenenUzunluk) adet baytı $(C 0) yapar.
)

$(P
$(C boşOlarakUzat()) işlevini aşağıdaki bir örnekte kullanacağız.
)

$(P
$(IX GC.extend) $(C GC.realloc) ile benzer amaçla kullanılan $(C GC.extend)'in davranışı çok daha basittir çünkü yalnızca yukarıdaki ilk maddeyi uygular: Eski yerin hemen sonrası yeni uzunluğu karşılayamıyorsa hiçbir işlem yapmaz ve bu durumu 0 döndürerek bildirir.
)

$(H6 $(IX bellek bölgesi niteliği) $(IX BlkAttr) Ayrılan belleğin temizlik işlemlerinin belirlenmesi)

$(P
Çöp toplayıcı algoritmasında geçen kavramlar ve adımlar bir $(C enum) türü olan $(C BlkAttr)'ın değerleri ile her bellek bölgesi için ayrı ayrı ayarlanabilir. $(C BlkAttr), $(C GC.calloc) ve diğer bellek ayırma işlevlerine parametre olarak gönderilebilir ve bellek bölgelerinin niteliklerini belirlemek için kullanılır. $(C BlkAttr) türünün değerleri şunlardır:
)

$(UL

$(LI $(C NONE): Sıfır değeri; hiçbir niteliğin belirtilmediğini belirler.)

$(LI $(C FINALIZE): Bölgedeki nesnelerin temizlik sırasında çöp toplayıcı tarafından sonlandırılmaları gerektiğini belirler.

$(P
Normalde, çöp toplayıcı kendisinden ayrılmış olan bellekteki nesnelerin yaşam süreçlerinin artık programcının sorumluluğuna girdiğini düşünür ve bu bölgelerdeki nesnelerin sonlandırıcılarını işletmez. $(C GC.BlkAttr.FINALIZE) değeri, çöp toplayıcının sonlandırıcıları yine de işletmesinin istendiğini belirtir:
)

---
        Sınıf * yer =
            cast(Sınıf*)GC.calloc(
                __traits(classInstanceSize, Sınıf) * 10,
                GC.BlkAttr.FINALIZE);
---

$(P
$(C FINALIZE), çöp toplayıcının bellek bloğuna yazdığı kendi özel ayarlarıyla ilgili bir belirteçtir. O yüzden, bu belirtecin normalde programcı tarafından değil, çöp toplayıcı tarafından kullanılması önerilir.
)

)

$(LI $(C NO_SCAN): Bölgenin çöp toplayıcı tarafından taran$(I ma)ması gerektiğini belirler.

$(P
Ayrılan bölgedeki bayt değerleri tesadüfen ilgisiz başka değişkenlerin adreslerine karşılık gelebilirler. Öyle bir durumda çöp toplayıcı hâlâ kullanımda olduklarını sanacağından, aslında yaşamları sona ermiş bile olsa o başka değişkenleri sonlandırmaz.
)

$(P
Başka değişken referansları taşımadığı bilinen bellek bölgelerinin taranması $(C GC.BlkAttr.NO_SCAN) niteliği ile engellenir:
)

---
    int * intYeri =
        cast(int*)GC.calloc(100, GC.BlkAttr.NO_SCAN);
---

$(P
Yukarıdaki bellek bölgesine yerleştirilecek olan $(C int) değerlerinin tesadüfen başka değişkenlerin adreslerine eşit olmaları böylece artık sorun oluşturmaz.
)

)

$(LI $(C NO_MOVE): Bölgedeki nesnelerin başka bölgelere taşın$(I ma)maları gerektiğini belirler.)

$(LI $(C APPENDABLE): Bu, D $(I çalışma ortamına) ait olan ve dizilere daha hızlı eleman eklenmesini sağlayan bir belirteçtir. Programcı tarafından kullanılmaz.)

$(LI $(C NO_INTERIOR): Bu bölgenin $(I iç tarafındaki) değişkenleri gösteren gösterge bulunmadığını belirtir (olası göstergeler bölgenin yalnızca ilk adresini gösterirler). Bu, $(I yalancı gösterge) olasılığını düşürmeye yarayan bir belirteçtir.)

)

$(P
$(IX |) Bu değerler $(LINK2 /ders/d/bit_islemleri.html, Bit İşlemleri bölümünde) gördüğümüz işleçlerle birlikte kullanılabilecek biçimde seçilmişlerdir. Örneğin, iki değer $(C |) işleci ile aşağıdaki gibi birleştirilebilir:
)

---
    const bellekAyarları =
        GC.BlkAttr.NO_SCAN $(HILITE |) GC.BlkAttr.NO_INTERIOR;
---

$(P
Doğal olarak, çöp toplayıcı yalnızca kendi ayırdığı bellek bölgelerini tanır ve temizlik işlemleri sırasında yalnızca o bölgeleri tarar. Örneğin, $(C std.c.stdlib.calloc) ile ayrılmış olan bellek bölgelerinden çöp toplayıcının normalde haberi olmaz.
)

$(P
$(IX GC.addRange) $(IX GC.removeRange) $(IX GC.addRoot) Kendisinden alınmamış olan bir bölgenin çöp toplayıcının yönetimine geçirilmesi için $(C GC.addRange()) işlevi kullanılır. Bunun karşıtı olarak, bellek geri verilmeden önce de $(C GC.removeRange())'in çağrılması gerekir.
)

$(P
Bazı durumlarda çöp toplayıcı kendisinden ayrılmış olan bir bölgeyi gösteren hiçbir referans bulamayabilir. Örneğin, ayrılan belleğin tek referansı bir C kütüphanesi içinde tutuluyor olabilir. Böyle bir durumda çöp toplayıcı o bölgenin kullanımda olmadığını düşünecektir.
)

$(P
$(C GC.addRoot()), belirli bir bölgeyi çöp toplayıcıya tanıtır ve oradan dolaylı olarak erişilebilen bütün nesneleri de yönetmesini sağlar. Bunun karşıtı olarak, bellek geri verilmeden önce de $(C GC.removeRoot()) işlevinin çağrılması gerekir.
)

$(H6 Bellek uzatma örneği)

$(P
$(C realloc())'un kullanımını göstermek için dizi gibi işleyen çok basit bir yapı tasarlayalım. Çok kısıtlı olan bu yapıda yalnızca eleman ekleme ve elemana erişme olanakları bulunsun. D dizilerinde olduğu gibi bu yapının da sığası olsun. Aşağıdaki yapı sığayı gerektikçe yukarıda tanımladığımız ve kendisi $(C GC.realloc)'tan yararlanan $(C boşOlarakUzat()) ile arttırıyor:
)

---
$(CODE_NAME Dizi)$(CODE_XREF boşOlarakUzat)struct Dizi(T) {
    T * yer;          // Elemanların bulunduğu yer
    size_t sığa;      // Toplam kaç elemanlık yer olduğu
    size_t uzunluk;   // Eklenmiş olan eleman adedi

    /* Belirtilen numaralı elemanı döndürür */
    T eleman(size_t numara) {
        import std.string;
        enforce(numara < uzunluk,
                format("%s numara yasal değil", numara));

        return *(yer + numara);
    }

    /* Elemanı dizinin sonuna ekler */
    void ekle(T eleman) {
        writefln("%s numaralı eleman ekleniyor", uzunluk);

        if (uzunluk == sığa) {
            /* Yeni eleman için yer yok; sığayı arttırmak
             * gerekiyor. */
            size_t yeniSığa = sığa + (sığa / 2) + 1;
            sığaArttır(yeniSığa);
        }

        /* Elemanı en sona yerleştiriyoruz */
        *(yer + uzunluk) = eleman;
        ++uzunluk;
    }

    void sığaArttır(size_t yeniSığa) {
        writefln("Sığa artıyor: %s -> %s",
                 sığa, yeniSığa);

        auto eskiUzunluk = sığa * T.sizeof;
        auto yeniUzunluk = yeniSığa * T.sizeof;

        /* Bu bölgeye yerleştirilen bayt değerlerinin
         * tesadüfen başka değişkenlerin göstergeleri
         * sanılmalarını önlemek için NO_SCAN belirtecini
         * kullanıyoruz. */
        yer = cast(T*)$(HILITE boşOlarakUzat)(
            yer, eskiUzunluk, yeniUzunluk, GC.BlkAttr.NO_SCAN);

        sığa = yeniSığa;
    }
}
---

$(P
Bu dizinin sığasi her seferinde yaklaşık olarak %50 oranında arttırılıyor. Örneğin, 100 elemanlık yer tükendiğinde yeni sığa 151 oluyor. ($(I Yeni sığa hesaplanırken eklenen 1 değeri, başlangıç durumunda sıfır olan sığa için özel bir işlem gerekmesini önlemek içindir. Öyle olmasaydı, sıfırın %50 fazlası da sıfır olacağından sığa hiç artamazdı.))
)

$(P
Bu yapıyı $(C double) türünde elemanlarla şöyle deneyebiliriz:
)

---
$(CODE_XREF Dizi)import std.stdio;
import core.memory;
import std.exception;

// ...

void main() {
    auto dizi = Dizi!double();

    size_t adet = 10;

    foreach (i; 0 .. adet) {
        double elemanDeğeri = i * 1.1;
        dizi.ekle(elemanDeğeri);
    }

    writeln("Bütün elemanlar:");

    foreach (i; 0 .. adet) {
        write(dizi.eleman(i), ' ');
    }

    writeln();
}
---

$(P
Çıktısı:
)

$(SHELL
0 numaralı eleman ekleniyor
Sığa artıyor: 0 -> 1
1 numaralı eleman ekleniyor
Sığa artıyor: 1 -> 2
2 numaralı eleman ekleniyor
Sığa artıyor: 2 -> 4
3 numaralı eleman ekleniyor
4 numaralı eleman ekleniyor
Sığa artıyor: 4 -> 7
5 numaralı eleman ekleniyor
6 numaralı eleman ekleniyor
7 numaralı eleman ekleniyor
Sığa artıyor: 7 -> 11
8 numaralı eleman ekleniyor
9 numaralı eleman ekleniyor
Bütün elemanlar:
0 1.1 2.2 3.3 4.4 5.5 6.6 7.7 8.8 9.9 
)

$(H5 $(IX hizalama) Hizalama birimi)

$(P
Değişkenler normalde kendi türlerine özgü bir değerin katı olan adreslerde bulunurlar. Bu değere o türün $(I hizalama birimi) denir. Örneğin, $(C int) türünün hizalama birimi 4'tür çünkü $(C int) değişkenler ancak dördün katı olan adreslerde (4, 8, 12, vs.) bulunabilirler.
)

$(P
Hizalama, hem mikro işlemci işlemlerinin hızlı olması için istenen hem de mikro işlemcinin nesne adresleyebilmesi için gereken bir kavramdır. Ek olarak, bazı değişkenler yalnızca kendi türlerinin hizalama birimine uyan adreslerde iseler kullanılabilirler.
)

$(H6 $(IX .alignof) Türlerin $(C .alignof) niteliği)

$(P
$(IX classInstanceAlignment) Bir türün $(C .alignof) niteliği o türün $(I varsayılan) hizalama birimini döndürür. Ancak, sınıflarda $(C .alignof) sınıf nesnesinin değil, sınıf değişkeninin hizalama birimidir. Sınıf nesnesinin hizalama birimi için $(C std.traits.classInstanceAlignment) kullanılmalıdır.
)

$(P
Aşağıdaki program çeşitli türün hizalama birimini yazdırıyor.
)

---
import std.stdio;
import std.meta;
import std.traits;

struct BoşYapı {
}

struct Yapı {
    char c;
    double d;
}

class BoşSınıf {
}

class Sınıf {
    char karakter;
}

void main() {
    alias Türler = AliasSeq!(char, short, int, long,
                             double, real,
                             string, int[int], int*,
                             BoşYapı, Yapı, BoşSınıf, Sınıf);

    writeln(" Uzunluk  Hizalama  Tür\n",
            "========================");

    foreach (Tür; Türler) {
        static if (is (Tür == class)) {
            size_t uzunluk = __traits(classInstanceSize, Tür);
            size_t hizalama = $(HILITE classInstanceAlignment!Tür);

        } else {
            size_t uzunluk = Tür.sizeof;
            size_t hizalama = $(HILITE Tür.alignof);
        }

        writefln("%6s%9s     %s",
                 uzunluk, hizalama, Tür.stringof);
    }
}
---

$(P
Bu programın çıktısı farklı ortamlarda farklı olabilir:
)

$(SHELL
 Uzunluk  Hizalama  Tür
========================
     1        1     char
     2        2     short
     4        4     int
     8        8     long
     8        8     double
    16       16     real
    16        8     string
     8        8     int[int]
     8        8     int*
     1        1     BoşYapı
    16        8     Yapı
    16        8     BoşSınıf
    17        8     Sınıf
)

$(P
Biraz aşağıda nesnelerin belirli adreslerde de kurulabildiklerini göreceğiz. Bunun güvenle yapılabilmesi için hizalama birimlerinin gözetilmeleri gerekir.
)

$(P
Bunun örneğini görmek için yukarıdaki 17 bayt uzunluğundaki $(C Sınıf) türünün iki nesnesinin bellekte $(I yan yana) nasıl durabileceklerine bakalım. Her ne kadar yasal bir adres olmasa da, örneği kolaylaştırmak için birinci nesnenin 0 adresinde bulunduğunu varsayalım. Bu nesneyi oluşturan baytlar 0'dan 16'ya kadar olan adreslerdedir:
)

$(MONO
     $(HILITE 0)    1           16
  ┌────┬────┬─ ... ─┬────┬─ ...
  │$(HILITE <───birinci nesne────>)│
  └────┴────┴─ ... ─┴────┴─ ...
)

$(P
$(IX doldurma baytı) Bir sonraki boş yerin adresi 17 olduğu halde o adres değeri $(C Sınıf)'ın hizalama birimi olan 8'in katı olmadığından ikinci nesne orada kurulamaz. İkinci nesnenin 8'in katı olan bir sonraki adrese, yani 24 adresine yerleştirilmesi gerekir. Aradaki kullanılmayan baytlara $(I doldurma) baytları denir:
)

$(P
)

$(MONO
     $(HILITE 0)    1           16   17           23   $(HILITE 24)   25           30
  ┌────┬────┬─ ... ─┬────┬────┬─ ... ─┬────┬────┬────┬─ ... ─┬────┬─ ...
  │$(HILITE <───birinci nesne────>)│ <──$(I doldurma)───> │$(HILITE <────ikinci nesne────>)│
  └────┴────┴─ ... ─┴────┴────┴─ ... ─┴────┴────┴────┴─ ... ─┴────┴─ ...
)

$(P
Bir nesnenin belirli bir aday adresten sonra yasal olarak kurulabileceği ilk adresi elde etmek için şu hesap kullanılabilir:
)

---
    (adayAdres + hizalamaBirimi - 1)
    / hizalamaBirimi
    * hizalamaBirimi
---

$(P
Yukarıdaki hesabın doğru olarak işlemesi için bölme işleminden kalanın gözardı edilmesi şarttır. O yüzden o hesapta tamsayı türleri kullanılır.
)

$(P
Aşağıda $(C emplace())'in örneklerini gösterirken yukarıdaki hesabı uygulayan şu işlevden yararlanacağız:
)

---
$(CODE_NAME hizalıAdres)T * hizalıAdres(T)(T * adayAdres) {
    import std.traits;

    static if (is (T == class)) {
        const hizalama = classInstanceAlignment!T;

    } else {
        const hizalama = T.alignof;
    }

    const sonuç = (cast(size_t)adayAdres + hizalama - 1)
                  / hizalama * hizalama;
    return cast(T*)sonuç;
}
---

$(P
Yukarıdaki işlev nesnenin türünü şablon parametresinden otomatik olarak çıkarsamaktadır. Onun $(C void*) adresleri ile işleyen yüklemesini de şöyle yazabiliriz:
)

---
$(CODE_NAME hizalıAdres_void)void * hizalıAdres(T)(void * adayAdres) {
    return hizalıAdres(cast(T*)adayAdres);
}
---

$(P
Bu işlev de aşağıda $(C emplace()) ile $(I sınıf) nesneleri oluştururken yararlı olacak.
)

$(P
Son olarak, yukarıdaki işlevden yararlanan yardımcı bir işlev daha tanımlayalım. Bu işlev, nesnenin boşluklarla birlikte kaç bayt yer tuttuğunu döndürür:
)

---
$(CODE_NAME boşlukluUzunluk)size_t boşlukluUzunluk(T)() {
    static if (is (T == class)) {
        size_t uzunluk = __traits(classInstanceSize, T);

    } else {
        size_t uzunluk = T.sizeof;
    }

    return cast(size_t)hizalıAdres(cast(T*)uzunluk);
}
---

$(H6 $(IX .offsetof) $(C .offsetof) niteliği)

$(P
Hizalama üye değişkenlerle de ilgili olan bir kavramdır. Üyeleri kendi türlerinin hizalama birimlerine uydurmak için üyeler arasına da doldurma baytları yerleştirilir. Örneğin, aşağıdaki yapının büyüklüğü bekleneceği gibi 6 değil, 12'dir:
)

---
struct A {
    byte b;     // 1 bayt
    int i;      // 4 bayt
    ubyte u;    // 1 bayt
}

static assert($(HILITE A.sizeof == 12));    // 1 + 4 + 1'den daha fazla
---

$(P
Bunun nedeni, hem $(C int) üye dördün katı olan bir adrese denk gelsin diye ondan önceye yerleştirilen, hem de bütün yapı nesnesi yapı türünün hizalama birimine uysun diye en sona yerleştirilen doldurma baytlarıdır.
)

$(P
$(C .offsetof) niteliği bir üyenin nesnenin başlangıç adresinden kaç bayt sonra olduğunu bildirir. Aşağıdaki işlev belirli bir türün bellekteki yerleşimini doldurma baytlarını $(C .offsetof) ile belirleyerek yazdırır:
)

---
$(CODE_NAME nesneYerleşiminiYazdır)void nesneYerleşiminiYazdır(T)()
        if (is (T == struct) || is (T == union)) {
    import std.stdio;
    import std.string;

    writefln("=== '%s' nesnelerinin yerleşimi" ~
             " (.sizeof: %s, .alignof: %s) ===",
             T.stringof, T.sizeof, T.alignof);

    /* Tek satır bilgi yazar. */
    void satırYazdır(size_t uzaklık, string bilgi) {
        writefln("%4s: %s", uzaklık, bilgi);
    }

    /* Doldurma varsa miktarını yazdırır. */
    void doldurmaBilgisiYazdır(size_t beklenenUzaklık,
                               size_t gözlemlenenUzaklık) {
        if (beklenenUzaklık < gözlemlenenUzaklık) {
            /* Gözlemlenen uzaklık beklenenden fazlaysa
             * doldurma baytı var demektir. */

            const doldurmaMiktarı =
                gözlemlenenUzaklık - beklenenUzaklık;

            satırYazdır(beklenenUzaklık,
                        format("... %s bayt DOLDURMA",
                               doldurmaMiktarı));
        }
    }

    /* Bir sonraki üyenin doldurma olmayan durumda nerede
     * olacağı bilgisini tutar. */
    size_t doldurmasızUzaklık = 0;

    /* Not: __traits(allMembers) bir türün üyelerinin
     * isimlerinden oluşan bir 'string' topluluğudur. */
    foreach (üyeİsmi; __traits(allMembers, T)) {
        mixin (format("alias üye = %s.%s;",
                      T.stringof, üyeİsmi));

        const uzaklık = üye$(HILITE .offsetof);
        doldurmaBilgisiYazdır(doldurmasızUzaklık, uzaklık);

        const türİsmi = typeof(üye).stringof;
        satırYazdır(uzaklık, format("%s %s", türİsmi, üyeİsmi));

        doldurmasızUzaklık = uzaklık + üye.sizeof;
    }

    doldurmaBilgisiYazdır(doldurmasızUzaklık, T.sizeof);
}
---

$(P
Aşağıdaki program, büyüklüğü yukarıda 12 bayt olarak bildirilen $(C A) yapısının yerleşimini yazdırır:
)

---
$(CODE_XREF nesneYerleşiminiYazdır)struct A {
    byte b;
    int i;
    ubyte u;
}

void main() {
    nesneYerleşiminiYazdır!A();
}
---

$(P
Programın çıktısı 6 doldurma baytının nesnenin nerelerinde olduğunu gösteriyor. Çıktıda soldaki sütun nesnenin başından olan uzaklığı göstermektedir:
)

$(SHELL
=== 'A' nesnelerinin yerleşimi (.sizeof: $(HILITE 12), .alignof: 4) ===
   0: byte b
   1: ... 3 bayt DOLDURMA
   4: int i
   8: ubyte u
   9: ... 3 bayt DOLDURMA
)

$(P
Doldurma baytlarını olabildiğince azaltmanın bir yolu, üyeleri yapı içinde büyükten küçüğe doğru sıralamaktır. Örneğin, $(C int) üyeyi diğerlerinden önceye alınca yapının büyüklüğü azalır:
)

---
$(CODE_XREF nesneYerleşiminiYazdır)struct B {
    $(HILITE int i;)    // Üye listesinin başına getirildi
    byte b;
    ubyte u;
}

void main() {
    nesneYerleşiminiYazdır!B();
}
---

$(P
Bu sefer yalnızca en sonda 2 doldurma baytı bulunduğundan yapının büyüklüğü 8'e inmiştir:
)

$(SHELL
=== 'B' nesnelerinin yerleşimi (.sizeof: $(HILITE 8), .alignof: 4) ===
   0: int i
   4: byte b
   5: ubyte u
   6: ... 2 bayt DOLDURMA
)

$(H6 $(IX align) $(C align) niteliği)

$(P
$(C align) niteliği değişkenlerin, kullanıcı türlerinin, ve üyelerin hizalama birimlerini belirler. Parantez içinde belirtilen değer hizalama birimidir. Her tanımın hizalama birimi ayrı ayrı belirlenebilir. Örneğin, aşağıdaki tanımda $(C S) nesnelerinin hizalama birimi 2, ve özellikle $(C i) üyesinin hizalama birimi 1 olur (hizalama birimi 1, hiç doldurma baytı olmayacak demektir):
)

---
$(CODE_XREF nesneYerleşiminiYazdır)$(HILITE align (2))               // 'S' nesnelerinin hizalama birimi
struct S {
    byte b;
    $(HILITE align (1)) int i;    // 'i' üyesinin hizalama birimi
    ubyte u;
}

void main() {
    nesneYerleşiminiYazdır!S();
}
---

$(P
$(C int) üyenin hizalama birimi 1 olduğunda onun öncesinde hiç doldurma baytına gerek kalmaz ve yapının büyüklüğü üyelerinin büyüklüğü olan 6'ya eşit olur:
)

$(SHELL
=== 'S' nesnelerinin yerleşimi (.sizeof: $(HILITE 6), .alignof: 4) ===
   0: byte b
   1: int i
   5: ubyte u
)

$(P
Ancak, varsayılan hizalama birimleri gözardı edildiğinde programın hızında önemli derecede yavaşlama görülebilir. Ek olarak, yanlış hizalanmış olan değişkenler bazı mikro işlemcilerde programın çökmesine neden olabilirler.
)

$(P
$(C align) ile değişkenlerin hizalamaları da belirlenebilir:
)

---
    $(HILITE align (32)) double d;    // Bu değişkenin hizalama birimi
---

$(P
Ancak, çöp toplayıcı $(C new) ile ayrılmış olan nesnelerin hizalama birimlerinin $(C size_t) türünün uzunluğunun bir tam katı olduğunu varsayar. Çöp toplayıcıya ait olan değişkenlerin hizalama birimlerinin buna uymaması tanımsız davranışa neden olur. Örneğin, $(C size_t) 8 bayt ise $(C new) ile ayrılmış olan nesnelerin hizalama birimleri 8'in katı olmalıdır.
)

$(H5 $(IX emplace, nesne kurma) $(IX kurma, emplace) $(IX emplace) Değişkenleri belirli bir yerde kurmak)

$(P
$(IX new) $(C new) ifadesi üç işlem gerçekleştirir:
)

$(OL

$(LI Bellekten nesnenin sığacağı kadar yer ayırır. Bu bellek bölgesi henüz hiçbir nesneyle ilgili değildir.
)

$(LI Nesnenin kurucu işlevini o bellek bölgesi üzerinde işletir. Nesne ancak bu işlemden sonra o bölgeye $(I yerleştirilmiş) olur.
)

$(LI Nesne daha sonradan sonlandırılırken kullanılmak üzere bellek bölgesi belirteçlerini ayarlar.
)

)

$(P
Bu işlemlerden birincisinin $(C GC.calloc) ve başka işlevlerle gerçekleştirilebildiğini yukarıda gördük. Bir sistem dili olan D, normalde otomatik olarak işletilen ikinci adımın da programcı tarafından belirlenmesine olanak verir.
)

$(P
Nesnelerin belirli bir adreste kurulması için "yerleştir" anlamına gelen $(C std.conv.emplace) kullanılır.
)

$(H6 $(IX emplace, struct) Yapı nesnelerini belirli bir yerde kurmak)

$(P
$(C emplace()), nesnenin kurulacağı adresi parametre olarak alır ve o adreste bir nesne kurar. Eğer varsa, nesnenin kurucu işlevinin parametreleri bu adresten sonra bildirilir:
)

---
import std.conv;
// ...
    emplace($(I adres), /* ... kurucu parametreleri ... */);
---

$(P
Yapı nesneleri kurarken türün ayrıca belirtilmesi gerekmez; $(C emplace()) hangi türden nesne kuracağını kendisine verilen göstergenin türünden anlar. Örneğin, aşağıdaki $(C emplace()) çağrısında $(C öğrenciAdresi)'nin türü bir $(C Öğrenci*) olduğundan $(C emplace()) o adreste bir $(C Öğrenci) nesnesi kurar:
)

---
        Öğrenci * öğrenciAdresi = hizalıAdres(adayAdres);
// ...
        emplace(öğrenciAdresi, isim, numara);
---

$(P
Yukarıdaki işlevlerden yararlanan aşağıdaki program bütün nesneleri alabilecek büyüklükte bir bölge ayırıyor ve nesneleri o bölge içindeki hizalı adreslerde kuruyor:
)

---
$(CODE_XREF boşlukluUzunluk)$(CODE_XREF hizalıAdres)import std.stdio;
import std.string;
import core.memory;
import std.conv;

// ...

struct Öğrenci {
    string isim;
    int numara;

    string toString() {
        return format("%s(%s)", isim, numara);
    }
}

void main() {
    /* Önce bu türle ilgili bilgi yazdırıyoruz. */
    writefln("Öğrenci.sizeof: %#x (%s) bayt",
             Öğrenci.sizeof, Öğrenci.sizeof);
    writefln("Öğrenci.alignof: %#x (%s) bayt",
             Öğrenci.alignof, Öğrenci.alignof);

    string[] isimler = [ "Deniz", "Pınar", "Irmak" ];
    auto toplamBayt =
        boşlukluUzunluk!Öğrenci() * isimler.length;

    /* Bütün Öğrenci nesnelerine yetecek kadar yer ayırıyoruz.
     *
     * UYARI! Bu dilimin eriştirdiği nesneler henüz
     * kurulmamışlardır. */
    Öğrenci[] öğrenciler =
        (cast(Öğrenci*)GC.calloc(toplamBayt))
            [0 .. isimler.length];

    foreach (int i, isim; isimler) {
        Öğrenci * adayAdres = öğrenciler.ptr + i;
        Öğrenci * öğrenciAdresi = hizalıAdres(adayAdres);
        writefln("adres %s: %s", i, öğrenciAdresi);

        auto numara = 100 + i;
        $(HILITE emplace)(öğrenciAdresi, isim, numara);
    }

    /* Bütün elemanları kurulmuş olduğundan bir Öğrenci dilimi
     * olarak kullanmakta artık bir sakınca yoktur. */
    writeln(öğrenciler);
}
---

$(P
Yukarıdaki program $(C Öğrenci) türünün uzunluğunu, hizalama birimini, ve her öğrencinin kurulduğu adresi de yazdırıyor:
)

$(SHELL
Öğrenci.sizeof: 0x18 (24) bayt
Öğrenci.alignof: 0x8 (8) bayt
adres 0: 7FCF0B0F2F00
adres 1: 7FCF0B0F2F18
adres 2: 7FCF0B0F2F30
[Deniz(100), Pınar(101), Irmak(102)]
)

$(H6 $(IX emplace, class) Sınıf nesnelerini belirli bir yerde kurmak)

$(P
Sınıf değişkenlerinin nesnenin tam türünden olması gerekmez. Örneğin, $(C Hayvan) değişkenleri $(C Kedi) nesnelerine de erişim sağlayabilirler. Bu yüzden $(C emplace()), kuracağı nesnenin türünü kendisine verilen göstergenin türünden anlayamaz ve asıl türün $(C emplace())'e şablon parametresi olarak bildirilmesini gerektirir. ($(I Not: Ek olarak, sınıf göstergesi nesnenin değil, değişkenin adresi olduğundan türün açıkça belirtilmesi nesne mi yoksa değişken mi yerleştirileceği seçimini de programcıya bırakmış olur.))
)

$(P
$(IX void[]) Sınıf nesnelerinin kurulacağı yer $(C void[]) türünde bir dilim olarak belirtilir. Bunlara göre sınıf nesneleri kurarken şu söz dizimi kullanılır:
)

---
    Tür değişken =
        emplace!$(I Tür)($(I voidDilimi),
                         /* ... kurucu parametreleri ... */);
---

$(P
$(C emplace()), belirtilen yerde bir nesne kurar ve o nesneye erişim sağlayan bir sınıf $(I değişkeni) döndürür.
)

$(P
Bunları denemek için bir $(C Hayvan) sıradüzeninden yararlanalım. Bu sıradüzene ait olan nesneleri $(C GC.calloc) ile ayrılmış olan bir belleğe yan yana yerleştireceğiz. Alt sınıfları özellikle farklı uzunlukta seçerek her nesnenin yerinin bir öncekinin uzunluğuna bağlı olarak nasıl hesaplanabileceğini göreceğiz.
)

---
$(CODE_NAME Hayvan)interface Hayvan {
    string şarkıSöyle();
}

class Kedi : Hayvan {
    string şarkıSöyle() {
        return "miyav";
    }
}

class Papağan : Hayvan {
    string[] sözler;

    this(string[] sözler) {
        this.sözler = sözler;
    }

    string şarkıSöyle() {
        /* std.algorithm.joiner, belirtilen aralıktaki
         * elemanları belirtilen ayraçla birleştirir. */
        return sözler.joiner(", ").to!string;
    }
}
---

$(P
Nesnelerin yerleştirilecekleri bölgeyi $(C GC.calloc) ile ayıracağız:
)

---
    auto sığa = 10_000;
    void * boşYer = GC.calloc(sığa);
---

$(P
Normalde, nesneler kuruldukça o bölgenin tükenmediğinden de emin olunması gerekir. Örneği kısa tutmak için bu konuyu gözardı edelim ve kurulacak olan iki nesnenin on bin bayta sığacaklarını varsayalım.
)

$(P
O bölgede önce bir $(C Kedi) nesnesi sonra da bir $(C Papağan) nesnesi kuracağız:
)

---
    Kedi kedi = emplace!Kedi(kediYeri);
// ...
    Papağan papağan =
        emplace!Papağan(papağanYeri, [ "merrba", "aloo" ]);
---

$(P
Dikkat ederseniz $(C Papağan)'ın kurucusunun gerektirdiği parametreler nesnenin yerinden sonra belirtiliyorlar.
)

$(P
$(C emplace()) çağrılarının döndürdükleri değişkenler bir $(C Hayvan) dizisine eklenecekler ve daha sonra bir $(C foreach) döngüsünde kullanılacaklar:
)

---
    Hayvan[] hayvanlar;
// ...
    hayvanlar ~= kedi;
// ...
    hayvanlar ~= papağan;

    foreach (hayvan; hayvanlar) {
        writeln(hayvan.şarkıSöyle());
    }
---

$(P
Diğer açıklamaları programın içine yazıyorum:
)

---
$(CODE_XREF Hayvan)$(CODE_XREF hizalıAdres)$(CODE_XREF hizalıAdres_void)import std.stdio;
import std.algorithm;
import std.conv;
import core.memory;

// ...

void main() {
    /* Bu bir Hayvan değişkeni dizisidir; Hayvan nesnesi
     * dizisi değildir. */
    Hayvan[] hayvanlar;

    /* On bin baytın bu örnekte yeterli olduğunu varsayalım.
     * Normalde nesnelerin buraya gerçekten sığacaklarının da
     * denetlenmesi gerekir. */
    auto sığa = 10_000;
    void * boşYer = GC.calloc(sığa);

    /* İlk önce bir Kedi nesnesi yerleştireceğiz. */
    void * kediAdayAdresi = boşYer;
    void * kediAdresi = hizalıAdres!Kedi(kediAdayAdresi);
    writeln("Kedi adresi   : ", kediAdresi);

    /* Sınıflarda emplace()'e void[] verildiğinden adresten
     * dilim elde etmek gerekiyor. */
    size_t kediUzunluğu = __traits(classInstanceSize, Kedi);
    void[] kediYeri = kediAdresi[0..kediUzunluğu];

    /* Kedi'yi o yerde kuruyoruz ve döndürülen değişkeni
     * diziye ekliyoruz. */
    Kedi kedi = $(HILITE emplace!Kedi)(kediYeri);
    hayvanlar ~= kedi;

    /* Papağan'ı Kedi nesnesinden sonraki ilk uygun adreste
     * kuracağız. */
    void * papağanAdayAdresi = kediAdresi + kediUzunluğu;
    void * papağanAdresi =
        hizalıAdres!Papağan(papağanAdayAdresi);
    writeln("Papağan adresi: ", papağanAdresi);

    size_t papağanUzunluğu =
        __traits(classInstanceSize, Papağan);
    void[] papağanYeri = papağanAdresi[0..papağanUzunluğu];

    Papağan papağan =
        $(HILITE emplace!Papağan)(papağanYeri, [ "merrba", "aloo" ]);
    hayvanlar ~= papağan;

    /* Nesneleri kullanıyoruz. */
    foreach (hayvan; hayvanlar) {
        writeln(hayvan.şarkıSöyle());
    }
}
---

$(P
Çıktısı:
)

$(SHELL
Kedi adresi   : 7F869469E000
Papağan adresi: 7F869469E018
miyav
merrba, aloo
)

$(P
Programın adımlarını açıkça gösterebilmek için bütün işlemleri $(C main) içinde ve belirli türlere bağlı olarak yazdım. O işlemlerin iyi yazılmış bir programda $(C yeniNesne(T)) gibi bir şablon içinde bulunmalarını bekleriz.
)

$(H5 Nesneyi belirli bir zamanda sonlandırmak)

$(P
$(C new) işlecinin tersi, sonlandırıcı işlevin işletilmesi ve nesne için ayrılmış olan belleğin çöp toplayıcı tarafından geri alınmasıdır. Bu işlemler normalde belirsiz bir zamanda otomatik olarak işletilir.
)

$(P
Bazı durumlarda sonlandırıcı işlevin programcının istediği bir zamanda işletilmesi gerekebilir. Örneğin, açmış olduğu bir dosyayı sonlandırıcı işlevinde kapatan bir nesnenin sonlandırıcısının hemen işletilmesi gerekebilir.
)

$(P
$(IX destroy) Buradaki kullanımında "ortadan kaldır" anlamına gelen $(C destroy()), nesnenin sonlandırıcı işlevinin hemen işletilmesini sağlar:
)

---
    destroy(değişken);
---

$(P
$(IX .init) Sonlandırıcı işlevi işlettikten sonra $(C destroy()) değişkene türünün $(C .init) değerini atar. Sınıf değişkenlerinin ilk değeri $(C null) olduğundan nesne o noktadan sonra kullanılamaz. $(C destroy()) yalnızca sonlandırıcı işlevi işletir; belleğin gerçekten ne zaman geri verileceği yine de çöp toplayıcının kararına kalmıştır.
)

$(P
$(B Uyarı:) $(I Yapı) göstergesiyle kullanıldığında $(C destroy())'a göstergenin kendisi değil, gösterdiği nesne verilmelidir. Yoksa nesnenin sonlandırıcısı çağrılmaz, göstergenin kendisi $(C null) değerini alır:
)

---
import std.stdio;

struct S {
    int i;

    this(int i) {
        this.i = i;
        writefln("%s değerli nesne kuruluyor", i);
    }

    ~this() {
        writefln("%s değerli nesne sonlanıyor", i);
    }
}

void main() {
    auto g = new S(42);

    writeln("destroy()'dan önce");
    destroy($(HILITE g));                        // ← YANLIŞ KULLANIM
    writeln("destroy()'dan sonra");

    writefln("g: %s", g);

    writeln("main'den çıkılıyor");
}
---

$(P
$(C destroy())'a gösterge verildiğinde sonlandırılan (yani, türünün $(C .init) değeri verilen) göstergenin kendisidir:
)

$(SHELL
42 değerli nesne kuruluyor
destroy()'dan önce
destroy()'dan sonra    $(SHELL_NOTE_WRONG Bu satırdan önce nesne sonlanmamıştır)
g: null                $(SHELL_NOTE_WRONG Onun yerine gösterge null olmuştur)
main'den çıkılıyor
42 değerli nesne sonlanıyor
)

$(P
Bu yüzden, yapı göstergesiyle kullanıldığında $(C destroy())'a gösterilen nesne verilmelidir:
)

---
    destroy($(HILITE *g));                       // ← Doğru kullanım
---

$(P
Sonlandırıcı işlevin bu sefer doğru noktada işletildiğini ve göstergenin değerinin $(C null) olmadığını görüyoruz:
)

$(SHELL
42 değerli nesne kuruluyor
destroy()'dan önce
42 değerli nesne sonlanıyor    $(SHELL_NOTE Nesne doğru noktada sonlanmıştır)
destroy()'dan sonra
g: 7FC5EB4EE200                $(SHELL_NOTE Gösterge null olmamıştır)
main'den çıkılıyor
0 değerli nesne sonlanıyor     $(SHELL_NOTE Bir kere de S.init değeriyle)
)

$(P
Son satır, artık $(C S.init) değerine sahip olan nesnenin sonlandırıcısı bir kez de kapsamdan çıkılırken işletilirken yazdırılmıştır.
)

$(H5 $(IX kurma, isimle) Nesneyi çalışma zamanında ismiyle kurmak)

$(P
$(IX factory) $(IX Object) $(C Object) sınıfının $(C factory()) isimli üye işlevi türün ismini parametre olarak alır, o türden bir nesne kurar, ve adresini döndürür. $(C factory()), türün kurucusu için parametre almaz; bu yüzden türün parametresiz olarak kurulabilmesi şarttır:
)

---
$(HILITE module deneme;)

import std.stdio;

interface Hayvan {
    string ses();
}

class Kedi : Hayvan {
    string ses() {
        return "miyav";
    }
}

class Köpek : Hayvan {
    string ses() {
        return "hav";
    }
}

void main() {
    string[] kurulacaklar = [ "Kedi", "Köpek", "Kedi" ];

    Hayvan[] hayvanlar;

    foreach (türİsmi; kurulacaklar) {
        /* "Sözde değişken" __MODULE__, her zaman için içinde
         * bulunulan modülün ismidir ve bir string olarak
         * derleme zamanında kullanılabilir. */
        const tamİsim = __MODULE__ ~ '.' ~ türİsmi;
        writefln("%s kuruluyor", tamİsim);
        hayvanlar ~= cast(Hayvan)$(HILITE Object.factory)(tamİsim);
    }

    foreach (hayvan; hayvanlar) {
        writeln(hayvan.ses());
    }
}
---

$(P
O programda hiç $(C new) kullanılmadığı halde üç adet $(C Hayvan) nesnesi oluşturulmuş ve $(C hayvanlar) dizisine eklenmiştir:
)

$(SHELL
deneme.Kedi kuruluyor
deneme.Köpek kuruluyor
deneme.Kedi kuruluyor
miyav
hav
miyav
)

$(P
$(C Object.factory())'ye türün tam isminin verilmesi gerekir. O yüzden yukarıdaki tür isimleri $(STRING "Kedi") ve $(STRING "Köpek") gibi kısa olarak değil, modülün ismi ile birlikte $(STRING "deneme.Kedi") ve $(STRING "deneme.Köpek") olarak belirtiliyorlar.
)

$(P
$(C factory)'nin dönüş türü $(C Object)'tir; bu türün yukarıdaki $(C cast(Hayvan)) kullanımında gördüğümüz gibi doğru türe açıkça dönüştürülmesi gerekir.
)

$(H5 Özet)

$(UL
$(LI Çöp toplayıcı belleği belirsiz zamanlarda tarar, artık kullanılmayan nesneleri belirler, onları sonlandırır, ve yerlerini geri alır.)

$(LI Çöp toplayıcının temizlik işlemleri $(C GC.collect), $(C GC.disable), $(C GC.enable), $(C GC.minimize), vs. ile bir ölçüye kadar yönetilebilir.)

$(LI Çöp toplayıcıdan yer ayırmak için $(C GC.calloc) (ve başka işlevler), ayrılmış olan belleği uzatmak için $(C GC.realloc), geri vermek için de $(C GC.free) kullanılır.)

$(LI Çöp toplayıcıdan ayrılan belleğin $(C GC.BlkAttr.NO_SCAN), $(C GC.BlkAttr.NO_INTERIOR), vs. olarak işaretlenmesi gerekebilir.)

$(LI $(C .alignof) türün varsayılan hizalama birimini verir. Sınıf $(I nesneleri) için $(C classInstanceAlignment) kullanılır.)

$(LI $(C .offsetof) bir üyenin nesnenin başlangıç adresinden kaç bayt sonra olduğunu bildirir.)

$(LI $(C align) niteliği değişkenlerin, kullanıcı türlerinin, ve üyelerin hizalama birimlerini belirler.)

$(LI $(C emplace) yapı nesnesi kurarken gösterge, sınıf nesnesi kurarken $(C void[]) alır.)

$(LI $(C destroy) nesnenin sonlandırıcısını işletir. ($(C destroy)'a yapı göstergesi değil, gösterilen yapı nesnesi verilmelidir.))

$(LI $(C Object.factory) uzun ismiyle belirtilen türde nesne kurar.)

)

macros:
        SUBTITLE=Bellek Yönetimi

        DESCRIPTION=Bellek, ve derleyici veya programcı tarafından kullanılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial bellek new destroy clear

SOZLER=
$(bellek_sizintisi)
$(cagri_yigiti)
$(calisma_ortami)
$(cikarsama)
$(cokme)
$(cop_toplayici)
$(doldurma_bayti)
$(evrensel)
$(hizalama)
$(isletim_dizisi)
$(kapsam)
$(mikro_islemci)
$(siga)
$(sonlandirma)
$(statik)
$(tanimsiz_davranis)
$(yasam_sureci)
$(yazmac)
