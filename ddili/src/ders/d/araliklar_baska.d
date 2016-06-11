Ddoc

$(DERS_BOLUMU $(IX aralık) Başka Aralık Olanakları)

$(P
Bundan önceki bölümdeki çoğu aralık örneğinde $(C int) aralıkları kullandık. Aslında topluluklar, algoritmalar, ve aralıklar, hep şablonlar olarak gerçekleştirilirler. Biz de bir önceki bölümde $(C yazdır()) işlevini şablon olarak tanımladığımız için farklı $(C InputRange) aralıklarıyla kullanabilmiştik:
)

---
void yazdır$(HILITE (T))(T aralık) {
    // ...
}
---

$(P
$(C yazdır())'ın bir eksiği, şablon parametresinin bir $(C InputRange) olması gerektiği halde bunu bir şablon kısıtlaması ile belirtmiyor olmasıdır. (Şablon kısıtlamalarını $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar) bölümünde görmüştük.)
)

$(P
$(C std.range) modülü, hem şablon kısıtlamalarında hem de $(C static if) deyimlerinde yararlanılmak üzere çok sayıda yardımcı şablon içerir.
)

$(H5 Aralık çeşidi şablonları)

$(P
Bu şablonların "öyle midir" anlamına gelen $(C is) ile başlayanları, belirli bir türün o aralık çeşidinden olup olmadığını belirtir. Örneğin $(C isInputRange!T), "$(C T) bir $(C InputRange) midir" sorusunu yanıtlar. Aralık çeşidini sorgulayan şablonlar şunlardır:
)

$(UL
$(LI $(IX isInputRange) $(C isInputRange))
$(LI $(IX isForwardRange) $(C isForwardRange))
$(LI $(IX isBidirectionalRange) $(C isBidirectionalRange))
$(LI $(IX isRandomAccessRange) $(C isRandomAccessRange))
$(LI $(IX isOutputRange) $(C isOutputRange))
)

$(P
$(C yazdır()) işlevinin şablon kısıtlaması $(C isInputRange)'den yararlanarak şöyle yazılır:
)

---
void yazdır(T)(T aralık)
        if ($(HILITE isInputRange!T)) {
    // ...
}
---

$(P
Bunlar arasından $(C isOutputRange), diğerlerinden farklı olarak iki şablon parametresi alır: Birincisi desteklenmesi gereken aralık türünü, ikincisi ise desteklenmesi gereken eleman türünü belirler. Örneğin aralığın $(C double) türü ile uyumlu olan bir çıkış aralığı olması gerektiği şöyle belirtilir:
)

---
void birİşlev(T)(T aralık)
        if (isOutputRange!($(HILITE T, double))) {
    // ...
}
---

$(P
O kısıtlamayı $(I $(C T) bir $(C OutputRange) ise ve $(C double) türü ile kullanılabiliyorsa) diye okuyabiliriz.
)

$(P
$(C static if) ile birlikte kullanıldıklarında bu şablonlar kendi yazdığımız aralıkların ne derece yetenekli olabileceklerini de belirlerler. Örneğin asıl aralık $(C ForwardRange) olduğunda $(C save()) işlevine de sahip olacağından, kendi yazdığımız özel aralık türünün de $(C save()) işlevini sunmasını o işlevden yararlanarak sağlayabiliriz.
)

$(P
Bunu görmek için kendisine verilen aralıktaki değerlerin ters işaretlilerini üreten bir aralığı önce bir $(C InputRange) olarak tasarlayalım:
)

---
import std.range;

struct Tersi(T)
        if (isInputRange!T) {
    T aralık;

    @property bool empty() {
        return aralık.empty;
    }

    @property auto front() {
        return $(HILITE -aralık.front);
    }

    void popFront() {
        aralık.popFront();
    }
}
---

$(P
$(I Not: $(C front)'un dönüş türü olarak $(C auto) yerine biraz aşağıda göreceğimiz $(C ElementType!T) de yazılabilir.)
)

$(P
Bu aralığın tek özelliği, $(C front) işlevinde asıl aralığın başındaki değerin ters işaretlisini döndürmesidir.
)

$(P
Çoğu aralık türünde olduğu gibi, kullanım kolaylığı açısından bir de yardımcı işlev yazalım:
)

---
Tersi!T tersi(T)(T aralık) {
    return Tersi!T(aralık);
}
---

$(P
Bu aralık örneğin bir önceki bölümde gördüğümüz $(C FibonacciSerisi) aralığıyla birlikte kullanılmaya hazırdır:
)

---
struct FibonacciSerisi {
    int baştaki = 0;
    int sonraki = 1;

    enum empty = false;

    @property int front() const {
        return baştaki;
    }

    void popFront() {
        const ikiSonraki = baştaki + sonraki;
        baştaki = sonraki;
        sonraki = ikiSonraki;
    }

    @property FibonacciSerisi save() const {
        return this;
    }
}

// ...

    writeln(FibonacciSerisi().take(5).$(HILITE tersi));
---

$(P
Çıktısı, aralığın ilk 5 elemanının ters işaretlilerini içerir:
)

$(SHELL
[0, -1, -1, -2, -3]
)

$(P
Doğal olarak, $(C Tersi) bu tanımıyla yalnızca bir $(C InputRange) olarak kullanılabilir ve örneğin $(C ForwardRange) gerektiren $(C cycle()) gibi algoritmalara gönderilemez:
)

---
    writeln(FibonacciSerisi()
            .take(5)
            .tersi
            .cycle         $(DERLEME_HATASI)
            .take(10));
---

$(P
Oysa, asıl aralık $(C FibonacciSerisi) gibi bir $(C ForwardRange) olduğunda $(C Tersi)'nin de $(C save()) işlevini sunamaması için bir neden yoktur. Bu durum derleme zamanında $(C static if) ile denetlenir ve ek işlevler asıl aralığın yetenekleri doğrultusunda tanımlanırlar. Bu durumda, asıl aralığın bir kopyası ile kurulmuş olan yeni bir $(C Tersi) nesnesi döndürmek yeterlidir:
)

---
struct Tersi(T)
        if (isInputRange!T) {
// ...

    $(HILITE static if) (isForwardRange!T) {
        Tersi save() {
            return Tersi(aralık.save());
        }
    }
}
---

$(P
Yukarıdaki ek işlev sayesinde $(C Tersi!FibonacciSerisi) de artık bir $(C ForwardRange) olarak kabul edilir ve yukarıdaki $(C cycle()) satırı artık derlenir:
)

---
    writeln(FibonacciSerisi()
            .take(5)
            .tersi
            .cycle         // ← artık derlenir
            .take(10));
---

$(P
Çıktısı, $(I Fibonacci serisinin ilk 5 elemanının ters işaretlilerinin sürekli olarak tekrarlanmasından oluşan aralığın ilk 10 elemanıdır):
)

$(SHELL
[0, -1, -1, -2, -3, 0, -1, -1, -2, -3]
)

$(P
$(C Tersi) aralığının duruma göre $(C BidirectionalRange) ve $(C RandomAccessRange) olabilmesi de aynı yöntemle sağlanır:
)

---
struct Tersi(T)
        if (isInputRange!T) {
// ...

    static if (isBidirectionalRange!T) {
        @property auto back() {
            return -aralık.back;
        }

        void popBack() {
            aralık.popBack();
        }
    }

    static if (isRandomAccessRange!T) {
        auto opIndex(size_t sıraNumarası) {
            return -aralık[sıraNumarası];
        }
    }
}
---

$(P
Böylece örneğin dizilerle kullanıldığında elemanlara $(C []) işleci ile erişilebilir:
)

---
    auto d = [ 1.5, 2.75 ];
    auto e = tersi(d);
    writeln(e$(HILITE [1]));
---

$(P
Çıktısı:
)

$(SHELL
-2.75
)

$(H5 $(IX ElementType) $(IX ElementEncodingType) $(C ElementType) ve $(C ElementEncodingType))

$(P
$(C ElementType), aralıktaki elemanların türünü bildiren bir şablondur. $(C ElementType!T), "$(C T) aralığının eleman türü" anlamına gelir.
)

$(P
Örneğin, belirli türden iki aralık alan ve bunlardan birincisinin elemanlarının türü ile uyumlu olan bir çıkış aralığı gerektiren bir işlevin şablon kısıtlaması şöyle belirtilebilir:
)

---
void işle(G1, G2, Ç)(G1 giriş1, G2 giriş2, Ç çıkış)
        if (isInputRange!G1 &&
            isForwardRange!G2 &&
            isOutputRange!(Ç, $(HILITE ElementType!G1))) {
    // ...
}
---

$(P
Yukarıdaki şablon kısıtlamasını şöyle açıklayabiliriz: $(C G1) bir $(C InputRange) ve $(C G2) bir $(C ForwardRange) olmalıdır; ek olarak, $(C Ç) de $(C G1)'in elemanlarının türü ile kullanılabilen bir $(C OutputRange) olmalıdır.
)

$(P
$(IX dchar, dizgi aralığı) Dizgiler aralık olarak kullanıldıklarında elemanlarına harf harf erişildiği için dizgi aralıklarının eleman türü her zaman için $(C dchar)'dır. Bu yüzden dizgilerin UTF kodlama türü $(C ElementType) ile belirlenemez. UTF kodlama türünü belirlemek için $(C ElementEncodingType) kullanılır. Örneğin bir $(C wchar) dizgisinin $(C ElementType)'ı $(C dchar), $(C ElementEncodingType)'ı da $(C wchar)'dır.
)

$(H5 Başka aralık nitelikleri)

$(P
$(C std.range) modülü aralıklarla ilgili başka şablon olanakları da sunar. Bunlar da şablon kısıtlamalarında ve $(C static if) deyimlerinde kullanılırlar.
)

$(UL

$(LI $(IX isInfinite) $(C isInfinite): Aralık sonsuzsa $(C true) üretir.)

$(LI $(IX hasLength) $(C hasLength): Aralığın $(C length) niteliği varsa $(C true) üretir.)

$(LI $(IX hasSlicing) $(C hasSlicing): Aralığın $(C a[x..y]) biçiminde dilimi alınabiliyorsa $(C true) üretir.)

$(LI $(IX hasAssignableElements) $(C hasAssignableElements): Aralığın elemanlarına değer atanabiliyorsa $(C true) üretir.)

$(LI $(IX hasSwappableElements) $(C hasSwappableElements): Aralığın elemanları $(C std.algorithm.swap) ile değiş tokuş edilebiliyorsa $(C true) üretir.)

$(LI $(IX hasMobileElements) $(IX move, std.algorithm) $(C hasMobileElements): Aralığın elemanları $(C std.algorithm.move) ile aktarılabiliyorsa $(C true) üretir.

$(P
$(IX moveFront) $(IX moveBack) $(IX moveAt) Bu, aralık çeşidine bağlı olarak baştaki elemanı aktaran $(C moveFront())'un, sondaki elemanı aktaran $(C moveBack())'in, veya rastgele bir elemanı aktaran $(C moveAt())'in mevcut olduğunu belirtir. Aktarma işlemi kopyalama işleminden daha hızlı olduğundan $(C hasMobileElements) niteliğinin sonucuna bağlı olarak bazı işlemler $(C move()) ile daha hızlı gerçekleştirilebilirler.
)

)

$(LI $(IX hasLvalueElements) $(IX sol değer) $(C hasLvalueElements): Aralığın elemanları $(I sol değer) olarak kullanılabiliyorsa $(C true) üretir. Bu kavramı, $(I aralığın elemanları gerçekte var olan elemanlara referans iseler) diye düşünebilirsiniz.

$(P
Örneğin $(C hasLvalueElements!FibonacciSerisi)'nin değeri $(C false)'tur çünkü $(C FibonacciSerisi) aralığının elemanları gerçekte var olan elemanlar değillerdir; hesaplanarak oluşturulurlar. Benzer şekilde $(C hasLvalueElements!(Tersi!(int[])))'in değeri de $(C false)'tur çünkü o aralığın da gerçek elemanları yoktur. Öte yandan, $(C hasLvalueElements!(int[]))'in değeri $(C true)'dur çünkü dilimler gerçekte var olan elemanlara erişim sağlarlar.
)

)

)

$(P
Örneğin $(C empty), $(C isInfinite!T)'nin değerine bağlı olarak farklı biçimde tanımlanabilir. Böylece, asıl aralık sonsuz olduğunda $(C Tersi!T)'nin de derleme zamanında sonsuz olması sağlanmış olur:
)

---
struct Tersi(T)
        if (isInputRange!T) {
// ...

    static if (isInfinite!T) {
        // Tersi!T de sonsuz olur
        enum empty = false;

    } else {
        @property bool empty() {
            return aralık.empty;
        }
    }

// ...
}

static assert( isInfinite!(Tersi!FibonacciSerisi));
static assert(!isInfinite!(int[]));
---

$(H5 $(IX çok şekillilik, çalışma zamanı) $(IX inputRangeObject) $(IX outputRangeObject) Çalışma zamanı çok şekilliliği için $(C inputRangeObject()) ve $(C outputRangeObject()))

$(P
Aralıklar, şablonların getirdiği $(I derleme zamanı çok şekilliliğine) sahiptirler. Biz de bir önceki ve bu bölümdeki çoğu örnekte bu olanaktan yararlandık. ($(I Not: Derleme zamanı çok şekilliliği ile çalışma zamanı çok şekilliliğinin farklarını $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar bölümündeki) "Derleme zamanı çok şekilliliği" başlığında görmüştük.))
)

$(P
Derleme zamanı çok şekilliliğinin bir etkisi, şablonun her farklı kullanımının farklı bir şablon türü oluşturmasıdır. Örneğin $(C take()) algoritmasının döndürdüğü özel aralık nesnesinin türü $(C take())'e gönderilen aralık türüne göre değişir:
)

---
    writeln(typeof([11, 22].tersi.take(1)).stringof);
    writeln(typeof(FibonacciSerisi().take(1)).stringof);
---

$(P
Çıktısı:
)

$(SHELL
Take!(Tersi!(int[]))
Take!(FibonacciSerisi)
)

$(P
Bunun doğal sonucu, farklı türlere sahip olan aralık nesnelerinin uyumsuz oldukları için birbirlerine atanamamalarıdır. Bu uyumsuzluk iki $(C InputRange) nesnesi arasında daha açık olarak da gösterilebilir:
)

---
    auto aralık = [11, 22].tersi;
    // ... sonraki bir zamanda ...
    aralık = FibonacciSerisi();    $(DERLEME_HATASI)
---

$(P
Bekleneceği gibi, derleme hatası $(C FibonacciSerisi) türünün $(C Tersi!(int[])) türüne otomatik olarak dönüştürülemeyeceğini bildirir:
)

$(SHELL
Error: cannot implicitly convert expression (FibonacciSerisi(0,1))
of type $(HILITE FibonacciSerisi) to $(HILITE Tersi!(int[]))
)

$(P
Buna rağmen, her ne kadar türleri uyumsuz olsalar da aslında her ikisi de $(C int) aralığı olan bu aralık nesnelerinin birbirlerinin yerine kullanılabilmelerini bekleyebiliriz. Çünkü kullanım açısından bakıldığında, bütün işleri $(C int) türünden elemanlara eriştirmek olduğundan, o elemanların hangi düzenek yoluyla üretildikleri veya eriştirildikleri önemli olmamalıdır.
)

$(P
Phobos, bu sorunu $(C inputRangeObject()) ve $(C outputRangeObject()) işlevleriyle giderir. $(C inputRangeObject()), aralıkları $(I belirli türden elemanlara sahip belirli çeşit aralık) tanımıyla kullandırmaya yarar. Aralık nesnelerini türlerinden bağımsız olarak, örneğin $(I elemanları $(C int) olan $(C InputRange) aralığı) genel tanımı ile kullanabiliriz.
)

$(P
$(C inputRangeObject()) bütün erişim aralıklarını destekleyecek kadar esnektir. Bu yüzden nesnelerin tanımı $(C auto) ile yapılamaz; aralık nesnesinin nasıl kullanılacağının açıkça belirtilmesi gerekir:
)

---
    // "int giriş aralığı" anlamında
    $(HILITE InputRange!int) aralık = [11, 22].tersi.$(HILITE inputRangeObject);

    // ... sonraki bir zamanda ...

    // Bu atama artık derlenir
    aralık = FibonacciSerisi().$(HILITE inputRangeObject);
---

$(P
$(C inputRangeObject())'in döndürdüğü nesnelerin ikisi de $(C InputRange!int) olarak kullanılabilmektedir.
)

$(P
Aralığın örneğin $(I $(C int) elemanlı bir $(C ForwardRange)) olarak kullanılacağı durumda ise açıkça $(C ForwardRange!int) yazmak gerekir:
)

---
    $(HILITE ForwardRange!int) aralık = [11, 22].tersi.inputRangeObject;

    auto kopyası = aralık.$(HILITE save);

    aralık = FibonacciSerisi().inputRangeObject;
    writeln(aralık.$(HILITE save).take(10));
---

$(P
Nesnelerin $(C ForwardRange) olarak kullanılabildiklerini göstermek için $(C save()) işlevlerini çağırarak kullandım.
)

$(P
$(C outputRangeObject()) de $(C OutputRange) aralıkları ile kullanılır ve onları $(I belirli tür elemanlarla kullanılabilen $(C OutputRange) aralığı) genel tanımına uydurur.
)

$(H5 Özet)

$(UL

$(LI $(C std.range) modülü şablon kısıtlamalarında yararlı olan bazı şablonlar içerir.)

$(LI $(C std.range) modülündeki şablonlar, tanımladığımız aralıkların başka aralıkların yeteneklerinin el verdiği ölçüde yetenekli olabilmelerini sağlarlar.)

$(LI $(C inputRangeObject()) ve $(C outputRangeObject()), farklı türden aralık nesnelerinin $(I elemanları belirli türden olan belirli çeşitten aralık) genel tanımına uymalarını sağlarlar.)
)

macros:
        SUBTITLE=Başka Aralık Olanakları

        DESCRIPTION=Aralıklarla kullanılmaya elverişli yardımcı şablonlar

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial aralık range isOutputRange isInputRange isForwardRange isBidirectionalRange isRandomAccessRange ElementType ElementEncodingType isInfinite hasLength hasSlicing hasAssignableElements hasSwappableElements hasMobileElements hasLvalueElements inputRangeObject outputRangeObject

SOZLER=
$(aralik)
$(cok_sekillilik)
$(otomatik)
$(phobos)
$(sol_deger)
$(tasima)
