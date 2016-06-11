Ddoc

$(DERS_BOLUMU $(IX fiber) Fiberler)

$(P
$(IX coroutine) $(IX yeşil iş parçacığı) $(IX iş parçacığı, yeşil) Fiber, tek iş parçacığının birden fazla görev yürütmesini sağlayan bir $(I işlem birimidir). Koşut işlemlerde ve eş zamanlı programlamada normalde yararlanılan iş parçacıklarıyla karşılaştırıldığında bir fiberin duraksatılması ve tekrar başlatılması çok daha hızlıdır. Fiberler $(I ortak işlevlere) $(ASIL coroutines) ve $(I yeşil iş parçacıklarına) $(ASIL green threads) çok benzerler ve bu terimler bazen aynı anlamda kullanılır.
)

$(P
Fiberler temelde iş parçacıklarının birden fazla çağrı yığıtı kullanmalarını sağlarlar. Bu yüzden, fiberlerin yararını tam olarak görebilmek için önce $(I çağrı yığıtının) getirdiği kolaylığı anlamak gerekir.
)

$(H5 $(IX çağrı yığıtı) $(IX program yığıtı) Çağrı yığıtı)

$(P
$(IX yerel durum) Bir işlevin parametreleri, $(C static) olmayan yerel değişkenleri, dönüş değeri, geçici ifadeleri, ve işletilmesi sırasında gereken başka her türlü bilgi o işlevin $(I yerel durumudur) $(ASIL local state). Yerel durumu oluşturan değişkenler için kullanılan alan her işlev çağrısında otomatik olarak ayrılır ve bu değişkenler otomatik olarak ilklenirler.
)

$(P
$(IX yığıt çerçevesi) Her çağrı için ayrılan bu alan o çağrının $(I çerçevesi) olarak adlandırılır. İşlevler başka işlevleri çağırdıkça bu çerçeveler kavramsal olarak yığıt biçiminde $(I üst üste) yerleştirilirler. Belirli bir andaki bütün etkin işlev çağrılarının çerçevelerinden oluşan alana o işlevleri işletmekte olan iş parçacığının $(I çağrı yığıtı) denir.
)

$(P
Örneğin, aşağıdaki programın ana iş parçacığında $(C main)'in $(C foo)'yu çağırmasının ardından $(C foo)'nun da $(C bar)'ı çağırdığı durumda toplam üç etkin işlev çağrısı vardır:
)

---
void main() {
    int a;
    int b;

    int c = $(HILITE foo)(a, b);
}

int foo(int x, int y) {
    $(HILITE bar)(x + y);
    return 42;
}

void bar(int parametre) {
    string[] dizi;
    // ...
}
---

$(P
O çağrılar sonucunda $(C bar)'ın işletilmesi sırasında çağrı yığıtı üç çerçeveden oluşur:
)

$(MONO
Çağrı yığıtı işlev çağrıları
derinleştikçe yukarıya doğru büyür.
                               ▲  ▲
                               │  │
Çağrı yığıtının tepesi → ┌───────────────┐
                         │ int parametre │ ← bar'ın çerçevesi
                         │ string[] dizi │
                         ├───────────────┤
                         │ int x         │
                         │ int y         │ ← foo'nun çerçevesi
                         │ dönüş değeri  │
                         ├───────────────┤
                         │ int a         │
                         │ int b         │ ← main'in çerçevesi
  Çağrı yığıtının dibi → └───────────────┘
)

$(P
İşlevlerin başka işlevleri çağırarak daha derine dallanmalarına ve bu işlevlerden üst düzeylere dönülmelerine bağlı olarak çağrı yığıtının büyüklüğü buna uygun olarak artar veya azalır. Örneğin, $(C bar)'dan dönüldüğünde artık çerçevesine gerek kalmadığından o alan ilerideki başka bir çağrı için kullanılmak üzere boş kalır:
)

$(MONO
$(LIGHT_GRAY                          ┌───────────────┐)
$(LIGHT_GRAY                          │ int parametre │)
$(LIGHT_GRAY                          │ string[] dizi │)
Çağrı yığıtının tepesi → ├───────────────┤
                         │ int x         │
                         │ int y         │ ← foo'nun çerçevesi
                         │ dönüş değeri  │
                         ├───────────────┤
                         │ int a         │
                         │ int b         │ ← main'in çerçevesi
  Çağrı yığıtının dibi → └───────────────┘
)

$(P
Bu kitapta yazdığımız her programda üzerinde durmasak da hep çağrı yığıtından yararlandık. Özyinelemeli işlevlerin basit olabilmelerinin nedeni de çağrı yığıtıdır.
)

$(H6 $(IX özyineleme) Özyineleme)

$(P
Özyineleme, bir işlevin doğrudan veya dolaylı olarak kendisini çağırması durumudur. Özyineleme, aralarında $(I böl ve fethet) $(ASIL divide-and-conquer) diye tanımlananlar da bulunan bazı algoritmaları büyük ölçüde kolaylaştırır.
)

$(P
Bunun bir örneğini görmek için bir dilimin elemanlarının toplamını döndüren aşağıdaki işleve bakalım. Bu işlev görevini yerine getirirken yine kendisini, ama farklı parametre değerleriyle çağırmaktadır. Her çağrı, parametre olarak alınan dilimin bir eksik elemanlısını kullanmaktadır. Bu özyineleme dilim boş kalana kadar devam eder. Belirli bir ana kadar hesaplanmış olan toplam değer ise işlevin ikinci parametresi olarak geçirilmektedir:
)

---
import std.array;

int topla(int[] dilim, int anlıkToplam = 0) {
    if (dilim.empty) {
        /* Ekleyecek eleman yok. Bu ana kadar hesaplanmış olan
         * toplamı döndürelim. */
        return anlıkToplam;
    }

    /* Baştaki elemanın değerini bu andaki toplama ekleyelim
     * ve kendimizi dilimin geri kalanı ile çağıralım. */
    return $(HILITE topla)(dilim[1..$], anlıkToplam + dilim.front);
}

void main() {
    assert(topla([1, 2, 3]) == 6);
}
---

$(P
$(IX sum, std.algorithm) $(I Not: Yukarıdaki işlev yalnızca gösterim amacıyla yazılmıştır. Bir aralıktaki elemanların toplamı gerektiğinde $(C std.algorithm.sum) işlevini kullanmanızı öneririm. O işlev kesirli sayıları toplarken özel algoritmalardan yararlanır ve daha doğru sonuçlar üretir.)
)

$(P
$(C topla)'nın yukarıdaki gibi $(C [1, 2, 3]) dilimiyle çağrıldığını düşünürsek, özyinelemenin son adımında çağrı yığıtı aşağıdaki çerçevelerden oluşacaktır. Her parametrenin değerini $(C ==) işlecinden sonra gösteriyorum. Çağrı sırasına uygun olması için çerçeveleri aşağıdan yukarıya doğru okumanızı öneririm:
)

$(MONO
    ┌──────────────────────────┐
    │ dilim       == []        │ ← topla'nın son çağrılışı
    │ anlıkToplam == 6         │
    ├──────────────────────────┤
    │ dilim       == [3]       │ ← topla'nın üçüncü çağrılışı
    │ anlıkToplam == 3         │
    ├──────────────────────────┤
    │ dilim       == [2, 3]    │ ← topla'nın ikinci çağrılışı
    │ anlıkToplam == 1         │
    ├──────────────────────────┤
    │ dilim       == [1, 2, 3] │ ← topla'nın ilk çağrılışı
    │ anlıkToplam == 0         │
    ├──────────────────────────┤
    │             ...          │ ← main'in çerçevesi
    └──────────────────────────┘
)

$(P
$(I Not: Eğer özyinelemeli işlev $(C topla)'da olduğu gibi kendisini çağırmasının sonucunu döndürüyorsa, derleyiciler "kuyruk özyinelemesi" denen bir eniyileştirme $(ASIL tail-call optimization) yönteminden yararlanırlar ve her çağrı için ayrı çerçeve kullanımını önlerler.)
)

$(P
Birden fazla iş parçacığı kullanılan durumda her iş parçacığı diğerlerinden bağımsızca kendi görevini yürüttüğünden, her iş parçacığı için ayrı çağrı yığıtı vardır.
)

$(P
Bir fiberin gücü, kendisi iş parçacığı olmadığı halde kendi çağrı yığıtına sahip olmasından kaynaklanır. Fiberler, normalde tek çağrı yığıtına sahip olan iş parçacıklarının birden fazla çağrı yığıtı kullanabilmelerini sağlarlar. Tek çağrı yığıtı ancak tek görevin durumunu saklayabildiğinden birden fazla çağrı yığıtı bir iş parçacığının birden fazla görev yürütmesini sağlar.
)

$(H5 Kullanım)

$(P
Fiberlerin genel kullanımı aşağıdaki işlemlerden oluşur. Bunların örneklerini biraz aşağıda göreceğiz.
)

$(UL

$(LI $(IX fiber işlevi) Bir fiberin işleyişi, çağrılabilen herhangi bir $(I birimden) (işlev göstergesi, temsilci, vs.) başlar. Bu başlangıç çağrısı parametre almaz ve değer döndürmez. Örneğin, fiberin başlangıcının türü $(C void function()) olabilir:

---
void fiberİşlevi() {
    // ...
}
---

)

$(LI $(IX Fiber, core.thread) Bir fiber temelde $(C core.thread.Fiber) sınıfının bir nesnesi olarak kurulur:

---
import core.thread;

// ...

    auto fiber = new Fiber($(HILITE &)fiberİşlevi);
---

$(P
Gerektiğinde $(C Fiber) sınıfından türemiş olan bir sınıf da kullanılabilir. Bu durumda başlangıç işlevi üst sınıfın kurucusuna parametre olarak geçirilir:
)

---
class ÖzelFiber : $(HILITE Fiber) {
    this() {
        super($(HILITE &)başlangıç);
    }

    void başlangıç() {
        // ...
    }
}

// ...

    auto fiber = new ÖzelFiber();
---

)

$(LI $(IX call, Fiber) Bir fiber $(C call()) üye işlevi ile başlatılır:

---
    fiber.call();
---

$(P
İş parçacıklarının tersine, fiber işlerken onu çağıran kod durur.
)

)

$(LI $(IX yield, Fiber) Bir fiber kendisini $(C Fiber.yield()) ile duraksatır:

---
void fiberİşlevi() {
    // ...

        Fiber.yield();

    // ...
}
---

$(P
Fiber duraksadığında onu çağıran kod kaldığı yerden tekrar işlemeye başlar.
)

)

$(LI $(IX .state, Fiber) Bir fiberin çalışma durumu $(C .state) niteliği ile öğrenilir:

---
    if (fiber.state == Fiber.State.TERM) {
        // ...
    }
---

$(P
$(IX State, Fiber) $(C Fiber.State) aşağıdaki değerlerden oluşan bir $(C enum) türüdür:
)

$(UL

$(LI $(IX HOLD, Fiber.State) $(C HOLD): Fiber duraksamış (yani, başlatılabilir) durumdadır.)

$(LI $(IX EXEC, Fiber.State) $(C EXEC): Fiber işlemektedir.)

$(LI $(IX TERM, Fiber.State) $(IX reset, Fiber) $(C TERM): Fiber işlemini tamamlamış durumdadır. Yeniden başlatılması isteniyorsa önce $(C reset()) üye işlevinin çağrılması gerekir.)

)

)

)

$(H5 Fiberlerin aralıklara yararı)

$(P
Hemen hemen her aralık en son nerede kaldığı bilgisini saklamak üzere üye değişkenlerden yararlanır. Bu bilgi, aralık nesnesi $(C popFront) ile $(I ilerletilirken) kullanılır. Hem $(LINK2 /ders/d/araliklar.html, Aralıklar bölümünde) hem de daha sonraki bölümlerde gördüğümüz çoğu aralığın da üye değişkenleri bulunuyordu.
)

$(P
Örneğin, daha önce tanımlamış olduğumuz $(C FibonacciSerisi), serinin iki sonraki sayısını hesaplamak için iki üye değişkenden yararlanıyordu:
)

---
struct FibonacciSerisi {
    int $(HILITE baştaki) = 0;
    int $(HILITE sonraki) = 1;

    enum empty = false;

    @property int front() const {
        return baştaki;
    }

    void popFront() {
        const ikiSonraki = baştaki + sonraki;
        baştaki = sonraki;
        sonraki = ikiSonraki;
    }
}
---

$(P
İlerleme durumu için böyle değişkenler tanımlamak $(C FibonacciSerisi) gibi bazı aralıklar için basit olsa da, ikili ağaç gibi bazı özyinelemeli veri yapılarında şaşırtıcı derecede güçtür. Şaşırtıcılığın nedeni, aynı algoritmaların özyinelemeli olarak yazıldıklarında ise çok basit olmalarıdır.
)

$(P
Örneğin, özyinelemeli olarak tanımlanmış olan aşağıdaki $(C ekle) ve $(C yazdır) işlevleri hiç değişken tanımlamaları gerekmeden ve ağaçtaki eleman sayısından bağımsız olarak çok basitçe yazılabilmişlerdir. Özyinelemeli çağrıları işaretli olarak gösteriyorum. (Dikkat ederseniz, $(C ekle)'nin özyinelemesi $(C ekleVeyaİlkle) üzerindendir.)
)

---
import std.stdio;
import std.string;
import std.conv;
import std.random;
import std.range;
import std.algorithm;

/* İkili ağacın düğümlerini temsil eder. Aşağıdaki Ağaç
 * yapısının gerçekleştirilmesinde kullanılmak üzere
 * tanımlanmıştır. */
struct Düğüm {
    int eleman;
    Düğüm * sol;    // Sol alt ağaç
    Düğüm * sağ;    // Sağ alt ağaç

    void $(HILITE ekle)(int eleman) {
        if (eleman < this.eleman) {
            /* Küçük elemanlar sol alt ağaca */
            ekleVeyaİlkle(sol, eleman);

        } else if (eleman > this.eleman) {
            /* Büyük elemanlar sağ alt ağaca */
            ekleVeyaİlkle(sağ, eleman);

        } else {
            throw new Exception(format("%s mevcut", eleman));
        }
    }

    void $(HILITE yazdır)() const {
        /* Önce sol alt ağacı yazdırıyoruz. */
        if (sol) {
            sol.$(HILITE yazdır)();
            write(' ');
        }

        /* Sonra bu düğümün elemanını yazdırıyoruz. */
        write(eleman);

        /* En sonunda da sağ alt ağacı yazdırıyoruz. */
        if (sağ) {
            write(' ');
            sağ.$(HILITE yazdır)();
        }
    }
}

/* Elemanı belirtilen alt ağaca ekler. Eğer 'null' ise düğümü
 * ilkler. */
void ekleVeyaİlkle(ref Düğüm * düğüm, int eleman) {
    if (!düğüm) {
        /* Bu alt ağacı ilk elemanıyla ilkliyoruz. */
        düğüm = new Düğüm(eleman);

    } else {
        düğüm.$(HILITE ekle)(eleman);
    }
}

/* Ağaç veri yapısını temsil eder. 'kök' üyesi 'null' ise ağaç
 * boş demektir. */
struct Ağaç {
    Düğüm * kök;

    /* Elemanı bu ağaca ekler. */
    void ekle(int eleman) {
        ekleVeyaİlkle(kök, eleman);
    }

    /* Elemanları sıralı olarak yazdırır. */
    void yazdır() const {
        if (kök) {
            kök.yazdır();
        }
    }
}

/* '10 * n' sayı arasından rasgele seçilmiş olan 'n' sayı ile
 * bir ağaç oluşturur. */
Ağaç rasgeleAğaç(size_t n) {
    /* '10 * n' sayı arasından 'n' tane seç. */
    auto sayılar = iota((n * 10).to!int)
                   .randomSample(n, Random(unpredictableSeed))
                   .array;

    /* 'n' sayıyı karıştır. */
    randomShuffle(sayılar);

    /* Ağacı o sayılarla doldur. */
    auto ağaç = Ağaç();
    sayılar.each!(e => ağaç.ekle(e));

    return ağaç;
}

void main() {
    auto ağaç = rasgeleAğaç(10);
    ağaç.yazdır();
}
---

$(P
$(I Not: Yukarıdaki program aşağıdaki Phobos olanaklarından da yararlanmaktadır:)
)

$(UL

$(LI
$(IX iota, std.range) $(C std.range.iota), verilen değer aralığındaki elemanları tembel olarak üretir. (İlk eleman belirtilmediğinde $(C .init) değeri varsayılır.) Örneğin, $(C iota(10)) 0 ile 9 arasındaki değerlerden oluşan bir $(C int) aralığıdır.
)

$(LI
$(IX each, std.algorithm) $(IX map ve each) $(C std.algorithm.each), $(C std.algorithm.map)'e çok benzer. $(C map) her elemana karşılık yeni bir sonuç ürettiği halde $(C each) her elemana karşılık yan etki üretir. Ek olarak, $(C map) tembeldir ama $(C each) heveslidir.
)

$(LI
$(IX randomSample, std.random) $(C std.random.randomSample), verilen aralıktan sıralarını değiştirmeden rasgele elemanlar seçer.
)

$(LI
$(IX randomShuffle, std.random) $(C std.random.randomShuffle), bir aralıktaki elemanların sıralarını rasgele değiştirir.
)

)

$(P
Her toplulukta olduğu gibi, aralık algoritmalarıyla kullanılabilmesi için bu ağaç topluluğunun da bir aralık arayüzü sunmasını isteriz. Bunu $(C opSlice) üye işlevini tanımlayarak gerçekleştirebileceğimizi biliyoruz:
)

---
struct Ağaç {
// ...

    /* Ağacın elemanlarına sıralı erişim sağlar. */
    struct SıralıAralık {
        $(HILITE ... Gerçekleştirmesi nasıl olmalıdır? ...)
    }

    SıralıAralık opSlice() const {
        return SıralıAralık(kök);
    }
}
---

$(P
Yukarıda tanımlanan $(C yazdır) üye işlevi de temelde elemanlara sırayla eriştiği halde, bir ağacın elemanlarına erişim sağlayan bir $(C InputRange) tanımlamak göründüğünden çok daha güç bir iştir. Ben burada $(C SıralıAralık) yapısını tanımlamaya çalışmayacağım. Ağaç erişicilerinin nasıl gerçekleştirildiklerini kendiniz araştırmanızı ve geliştirmeye çalışmanızı öneririm. (Bazı erişici gerçekleştirmeleri $(C sol) ve $(C sağ) üyelerine ek olarak üstteki $(ASIL parent) düğümü gösteren $(C Node*) türünde bir üye daha olmasını gerektirirler.)
)

$(P
$(C yazdır) gibi özyinelemeli ağaç algoritmalarının o kadar basit yazılabilmelerinin nedeni çağrı yığıtıdır. Çağrı yığıtı, belirli bir andaki elemanın hangisi olduğunun yanında o elemana hangi alt ağaçlar izlenerek erişildiği (hangi düğümlerde sola veya sağa dönüldüğü) bilgisini de otomatik olarak saklar.
)

$(P
Örneğin, özyinelemeli $(C sol.yazdır()) çağrısından soldaki elemanlar yazdırılıp dönüldüğünde, şu anda işlemekte olan $(C yazdır) işlevi sırada boşluk karakteri olduğunu zaten bilir:
)

---
    void yazdır() const {
        if (sol) {
            sol.yazdır();
            write(' '); // ← Çağrı yığıtına göre sıra bundadır
        }

        // ...
    }
---

$(P
Fiberler özellikle çağrı yığıtının büyük kolaylık sağladığı bu gibi durumlarda yararlıdır.
)

$(P
Fiberlerin sağladığı kolaylık Fibonacci serisi gibi basit türler üzerinde gösterilemese de, fiber işlemlerini özellikle böyle basit bir yapı üzerinde tanıtmak istiyorum. Daha aşağıda bir ikili ağaç aralığı da tanımlayacağız.
)

---
import core.thread;

/* Elemanları üretir ve 'ref' parametresine atar. */
void fibonacciSerisi($(HILITE ref) int baştaki) {                 // (1)
    baştaki = 0;    // Not: 'baştaki' parametrenin kendisidir
    int sonraki = 1;

    while (true) {
        $(HILITE Fiber.yield());                                  // (2)
        /* Bir sonraki call() çağrısı tam bu noktadan
         * devam eder. */                               // (3)

        const ikiSonraki = baştaki + sonraki;
        baştaki = sonraki;
        sonraki = ikiSonraki;
    }
}

void main() {
    int baştaki;                                        // (1)
                         // (4)
    Fiber fiber = new Fiber(() => fibonacciSerisi(baştaki));

    foreach (_; 0 .. 10) {
        fiber$(HILITE .call());                                   // (5)

        import std.stdio;
        writef("%s ", baştaki);
    }
}
---

$(OL

$(LI Yukarıdaki fiber işlevi parametre olarak $(C int) türünde bir değişken referansı almakta ve ürettiği elemanları kendisini çağırana bu parametre aracılığıyla iletmektedir. (Bu parametre $(C ref) yerine $(C out) olarak da tanımlanabilir.))

$(LI Fiber, yeni eleman hazır olduğunda kendisini $(C Fiber.yield()) ile duraksatır.)

$(LI Bir sonraki $(C call()) çağrısı, fiberi en son duraksatmış olan $(C Fiber.yield())'in hemen sonrasından devam ettirir. (İlk $(C call()) ise fiber işlevini başlatır.))

$(LI Fiber işlevleri parametre almadıklarından $(C fibonacciSerisi()) doğrudan kullanılamaz. O yüzden, $(C Fiber) nesnesi kurulurken parametresiz bir $(LINK2 /ders/d/kapamalar.html, isimsiz işlev) kullanılmıştır.)

$(LI Çağıran, fiberi $(C call()) üye işlevi ile başlatır ve devam ettirir.)

)

$(P
Sonuçta, $(C main) eleman değerlerini $(C baştaki) değişkeni üzerinden elde eder ve yazdırır:
)

$(SHELL
0 1 1 2 3 5 8 13 21 34 
)

$(H6 $(IX Generator, std.concurrency) Fiberlerin $(C std.concurrency.Generator) ile aralık olarak kullanılmaları)

$(P
Fibonacci serisinin yukarıdaki fiber gerçekleştirmesinin bazı yetersizlikleri vardır:
)

$(UL

$(LI Bu seri, aralık arayüzü sunmadığından mevcut aralık algoritmalarıyla kullanılamaz.)

$(LI $(C ref) çeşidinden bir parametrenin değiştirilmesi yerine elemanların çağırana $(I kopyalandıkları) bir tasarım tercih edilmelidir.)

$(LI Fiberi böyle $(I alt düzey) olanaklarıyla açıkça kurmak ve kullanmak yerine kullanım kolaylığı getiren başka çözümler tasarlanabilir.)

)

$(P
$(C std.concurrency.Generator) sınıfı bu yetersizliklerin hepsini giderir. Aşağıdaki $(C fibonacciSerisi)'nin nasıl basit bir işlev olarak yazılabildiğine dikkat edin. Tek farkı, işlevden tek eleman döndürmek yerine $(C yield) ile birden fazla eleman üretmesidir. (Bu örnekte sonsuz sayıda eleman üretilmektedir.)
)

$(P
$(IX yield, std.concurrency) Ek olarak, aşağıdaki $(C yield) daha önce kullandığımız $(C Fiber.yield) üye işlevi değil, $(C std.concurrency) modülündeki $(C yield) işlevidir.
)

---
import std.stdio;
import std.range;
import std.concurrency;

/* Bu alias std.range.Generator ile olan bir isim çakışmasını
 * gidermek içindir. */
alias FiberAralığı = std.concurrency.Generator;

void fibonacciSerisi() {
    int baştaki = 0;
    int sonraki = 1;

    while (true) {
        $(HILITE yield(baştaki));

        const ikiSonraki = baştaki + sonraki;
        baştaki = sonraki;
        sonraki = ikiSonraki;
    }
}

void main() {
    auto seri = new $(HILITE FiberAralığı!int)(&fibonacciSerisi);
    writefln("%(%s %)", seri.take(10));
}
---

$(P
Sonuçta, bir fiber işlevinin ürettiği elemanlar kolayca bir $(C InputRange) aralığı olarak kullanılabilmektedir:
)

$(SHELL
0 1 1 2 3 5 8 13 21 34
)

$(P
Ağaç elemanlarına $(C InputRange) arayüzü vermek için de $(C Generator)'dan yararlanılabilir. Dahası, $(C InputRange) arayüzü bulunan bir ağacın $(C yazdır) işlevine de artık gerek kalmaz. Aşağıdaki $(C düğümleri) işlevinin $(C sonrakiDüğüm)'ü çağıran bir isimsiz işlev oluşturduğuna ve $(C Generator)'a o isimsiz işlevi verdiğine dikkat edin:
)

---
import std.concurrency;

alias FiberAralığı = std.concurrency.Generator;

struct Düğüm {
// ...

    /* Not: Gerekmeyen yazdır() işlevi çıkartılmıştır. */

    auto opSlice() const {
        return düğümleri(&this);
    }
}

/* Bu fiber işlevi eleman değerine göre sıralı olarak bir
 * sonraki düğümü üretir. */
void sonrakiDüğüm(const(Düğüm) * düğüm) {
    if (!düğüm) {
        /* Bu düğümün kendisinde veya altında eleman yok */
        return;
    }

    sonrakiDüğüm(düğüm.sol);    // Önce soldaki elemanlar
    $(HILITE yield(düğüm));               // Şimdi bu eleman
    sonrakiDüğüm(düğüm.sağ);    // Sonra sağdaki elemanlar
}

/* Ağacın düğümlerinden oluşan bir InputRange döndürür. */
auto düğümleri(const(Düğüm) * düğüm) {
    return new FiberAralığı!(const(Düğüm)*)(
        () => sonrakiDüğüm(düğüm));
}

// ...

struct Ağaç {
// ...

    /* Not: Gerekmeyen yazdır() işlevi çıkartılmıştır. */

    auto opSlice() const {
        /* Düğümlerden eleman değerlerine dönüşüm. */
        return düğümleri(this).map!(d => d.eleman);
    }
}

/* Ağacın düğümlerinden oluşan bir InputRange döndürür. Ağaçta
 * eleman bulunmadığında (yani, 'kök' 'null' olduğunda) boş
 * aralık döndürür. */
auto düğümleri(const(Ağaç) ağaç) {
    alias AralıkTürü = typeof(düğümleri(ağaç.kök));

    return (ağaç.kök
            ? düğümleri(ağaç.kök)
            : new AralıkTürü(() {}));    // ← Boş aralık
}
---

$(P
Artık $(C Ağaç) nesneleri $(C []) işleciyle dilimlenebilirler ve $(C InputRange) olarak kullanılabilirler:
)

---
    writefln("%(%s %)", ağaç$(HILITE []));
---

$(H5 $(IX zaman uyumsuz giriş/çıkış, fiber) Fiberlerin zaman uyumsuz giriş/çıkış işlemlerinde kullanılmaları)

$(P
Fiberlerin çağrı yığıtları zaman uyumsuz giriş/çıkış işlemlerini de kolaylaştırır.
)

$(P
Bunun bir örneğini görmek için kullanıcıların sırayla $(I isim), $(I e-posta), ve $(I yaş) bilgilerini girerek kayıt oldukları bir servis düşünelim. Bu örneği bir internet sitesinin $(I üye kayıt iş akışına $(ASIL flow)) benzetebiliriz. Örneği kısa tutmak için bir internet sunucusu yerine kullanıcılarla komut satırı üzerinden etkileşen bir program yazalım. Bu etkileşim girilen bilgilerin işaretli olarak gösterildikleri aşağıdaki protokolü kullanıyor olsun:
)

$(UL
$(LI $(HILITE $(C merhaba)): Bir kullanıcı bağlansın ve kendi akışının numarasını edinsin.)
$(LI $(HILITE $(C $(I numara veri))): Belirtilen numaralı akışın kullanıcısı bir sonraki veriyi girsin. Örneğin, $(C 42) numaralı akışın bir sonraki verisi $(I isim) ise ve kullanıcısının adı Ayşe ise, giriş $(C 42&nbsp;Ayşe) olsun.)
$(LI $(HILITE $(C son)): Program sonlansın.)
)

$(P
Örneğin, Ayşe ve Barış adlı iki kullanıcının etkileşimleri aşağıdaki gibi olabilir. Kullanıcıların girdikleri veriler işaretli olarak gösterilmiştir. Her kullanıcı bağlandıktan sonra $(I isim), $(I e-posta), ve $(I yaş) bilgisini girmektedir:
)

$(SHELL
> $(HILITE merhaba)                   $(SHELL_NOTE Ayşe bağlanır)
0 numaralı akış başladı.
> $(HILITE 0 Ayşe)
> $(HILITE 0 ayse@example.com)
> $(HILITE 0 20)                      $(SHELL_NOTE Ayşe kaydını tamamlar)
Akış 0 tamamlandı.
'Ayşe' eklendi.
> $(HILITE merhaba)                   $(SHELL_NOTE Barış bağlanır)
1 numaralı akış başladı.
> $(HILITE 1 Barış)
> $(HILITE 1 baris@example.com)
> $(HILITE 1 30)                      $(SHELL_NOTE Barış kaydını tamamlar)
Akış 1 tamamlandı.
'Barış' eklendi.
> $(HILITE son)
Güle güle.
Kullanıcılar:
  Kullanıcı("Ayşe", "ayse@example.com", 20)
  Kullanıcı("Barış", "baris@example.com", 30)
)

$(P
Bu programı $(C merhaba) komutunu bekleyen ve kullanıcı verileri için bir işlev çağıran bir tasarımla gerçekleştirebiliriz:
)

---
    if (giriş == "merhaba") {
        yeniKullanıcıKaydet();  $(CODE_NOTE_WRONG UYARI: Giriş tıkayan tasarım)
    }
---

$(P
Eğer program eş zamanlı programlama yöntemleri kullanmıyorsa, yukarıdaki gibi bir tasarım $(I girişi tıkayacaktır) $(ASIL block) çünkü bağlanan kullanıcının verileri tamamlanmadan program başka kullanıcı kabul edemez. Verilerini dakika mertebesinde giren kullanıcılar fazla yüklü olmayan bir sunucuyu bile kullanışsız hale getirecektir.
)

$(P
Böyle bir servisin tıkanmadan işlemesini (yani, birden fazla kullanıcının kayıt işlemlerinin aynı anda sürdürülebilmesini) sağlayan çeşitli tasarımlar düşünülebilir:
)

$(UL

$(LI Görevlerin açıkça yönetilmesi: Ana iş parçacığı her bağlanan kullanıcı için $(C spawn) ile farklı bir iş parçacığı oluşturabilir ve bilgileri o iş parçacığına mesajlar halinde iletebilir. Bu çözümde veri geçerliliğinin $(C synchronized) gibi yöntemlerle korunması gerekebilir. Ek olarak, aşağıda $(I işbirlikli çoklu görev) bölümünde açıklanacağı gibi, iş parçacıkları fiberlerden genelde daha yavaş işlerler.)

$(LI Akış durumunun açıkça yönetilmesi: Program birden fazla akış kabul edebilir ve her akışın durumunu açıkça yönetebilir. Örneğin, Ayşe henüz yalnızca ismini girmişse, onun akışının durum bilgisi bir sonraki verinin e-posta olduğunu belirtir.)

)

$(P
Her kayıt akışı için ayrı fiber kullanan bir yöntem de düşünülebilir. Bunun yararı, akışın doğrusal olarak ve kullanıcı protokolüne tam uygun olarak yazılabilmesidir: önce isim, sonra e-posta, ve son olarak yaş. Aşağıdaki $(C başlangıç) işlevinin akışın durumunu saklamak için değişken tanımlamak zorunda kalmadığına dikkat edin. Her $(C call) çağrısı bir önceki $(C Fiber.yield)'in kaldığı yerden devam eder; bir sonra işletilecek olan işlem, çağrı yığıtı tarafından üstü kapalı olarak saklanmaktadır.
)

$(P
Önceki örneklerden farklı olarak, aşağıdaki programdaki fiber, $(C Fiber)'in alt sınıfı olarak tanımlanmıştır:
)

---
import std.stdio;
import std.string;
import std.format;
import std.exception;
import std.conv;
import std.array;
import core.thread;

struct Kullanıcı {
    string isim;
    string eposta;
    uint yaş;
}

/* Bu alt sınıf kullanıcı kayıt akışını temsil eder. */
class KayıtAkışı : Fiber {
    /* Bu akış için en son okunmuş olan veri. */
    string veri_;

    /* Kullanıcı nesnesi kurmak için gereken bilgi. */
    string isim;
    string eposta;
    uint yaş;

    this() {
        /* Fiberin başlangıç noktası olarak 'başlangıç' üye
         * işlevini belirtiyoruz. */
        super(&başlangıç);
    }

    void başlangıç() {
        /* İlk girilen veri isimdir. */
        isim = veri_;
        $(HILITE Fiber.yield());

        /* İkinci girilen veri e-postadır. */
        eposta = veri_;
        $(HILITE Fiber.yield());

        /* Sonuncu veri yaştır. */
        yaş = veri_.to!uint;

        /* Bu noktada Kullanıcı nesnesi oluşturacak bütün
         * veriyi toplamış bulunuyoruz. 'Fiber.yield()' ile
         * duraksamak yerine artık işlevin sonlanmasını
         * istiyoruz. (Burada açıkça 'return' deyimi de
         * olabilirdi.) Bunun sonucunda bu fiberin durumu
         * Fiber.State.TERM değerini alır. */
    }

    /* Bu nitelik işlevi çağıranın veri girmesi içindir. */
    @property void veri(string yeniVeri) {
        veri_ = yeniVeri;
    }

    /* Bu nitelik işlevi kurulan nesneyi çağırana vermek
     * içindir. */
    @property Kullanıcı kullanıcı() const {
        return Kullanıcı(isim, eposta, yaş);
    }
}

/* Belirli bir akış için girişten okunmuş olan veriyi temsil
 * eder. */
struct AkışVerisi {
    size_t numara;
    string yeniVeri;
}

/* Belirtilen satırdan akış verisi okur. */
AkışVerisi akışVerisiOku(string satır) {
    size_t numara;
    string yeniVeri;

    const adet =
        formattedRead(satır, " %s %s", &numara, &yeniVeri);

    enforce(adet == 2,
            format("Geçersiz veri: '%s'.", satır));

    return AkışVerisi(numara, yeniVeri);
}

void main() {
    Kullanıcı[] kullanıcılar;
    KayıtAkışı[] akışlar;

    bool bitti_mi = false;

    while (!bitti_mi) {
        write("> ");
        string satır = readln.strip;

        switch (satır) {
        case "merhaba":
            /* Yeni bağlanan kullanıcı için yeni akış
             * oluşturalım. */
            akışlar ~= new KayıtAkışı();

            writefln("%s numaralı akış başladı.",
                     akışlar.length - 1);
            break;

        case "son":
            /* Programdan çıkalım. */
            bitti_mi = true;
            break;

        default:
            /* Girilen satırı akış verisi olarak kullanmaya
             * çalışalım. */
            try {
                auto kullanıcı = veriİşle(satır, akışlar);

                if (!kullanıcı.isim.empty) {
                    kullanıcılar ~= kullanıcı;
                    writefln("'%s' eklendi.", kullanıcı.isim);
                }

            } catch (Exception hata) {
                writefln("Hata: %s", hata.msg);
            }
            break;
        }
    }

    writeln("Güle güle.");
    writefln("Kullanıcılar:\n%(  %s\n%)", kullanıcılar);
}

/* Girilen verinin ait olduğu fiberi belirler, yeni verisini
 * bildirir, ve o fiberin işleyişini kaldığı yerden devam
 * ettirir. Eğer girilen son veri üzerine akış sonlanmışsa,
 * üyeleri geçerli değerlerden oluşan bir Kullanıcı nesnesi
 * döndürür. */
Kullanıcı veriİşle(string satır, KayıtAkışı[] akışlar) {
    const akışVerisi = akışVerisiOku(satır);
    const numara = akışVerisi.numara;

    enforce(numara < akışlar.length,
            format("Geçersiz numara: %s.", numara));

    auto akış = akışlar[numara];

    enforce(akış.state == Fiber.State.HOLD,
            format("Akış %s işletilebilir durumda değil.",
                   numara));

    /* Akışa yeni verisini bildir. */
    akış.veri = akışVerisi.yeniVeri;

    /* Akışı kaldığı yerden devam ettir. */
    akış$(HILITE .call());

    Kullanıcı kullanıcı;

    if (akış.state == Fiber.State.TERM) {
        writefln("Akış %s tamamlandı.", numara);

        /* Dönüş değerine yeni oluşturulan kullanıcıyı ata. */
        kullanıcı = akış.kullanıcı;

        /* Sonrası için fikir: 'akışlar' dizisinin artık işi
         * bitmiş olan bu elemanı yeni bağlanacak olan
         * kullanıcılar için kullanılabilir. Ancak, önce
         * 'akış.reset()' ile tekrar başlatılabilir duruma
         * getirilmesi gerekir. */
    }

    return kullanıcı;
}
---

$(P
$(C main) işlevi girişten satırlar okur, onları ayrıştırır, ve veriyi işlenmek üzere ilgili akışa bildirir. Her akışın durumu kendi çağrı yığıtı tarafından otomatik olarak bilinmektedir. Yeni kullanıcılar bilgileri tamamlandıkça sisteme eklenirler.
)

$(P
Yukarıdaki programı çalıştırdığınızda kullanıcıların bilgi girme hızlarından bağımsız olarak sistemin her zaman için yeni kullanıcı kabul ettiğini göreceksiniz. Aşağıdaki örnekte Ayşe'nin etkileşimi işaretlenmiştir:
)

$(SHELL
> $(HILITE merhaba)                   $(SHELL_NOTE Ayşe bağlanır)
0 numaralı akış başladı.
> $(HILITE 0 Ayşe)
> merhaba                   $(SHELL_NOTE Barış bağlanır)
1 numaralı akış başladı.
> merhaba                   $(SHELL_NOTE Can bağlanır)
2 numaralı akış başladı.
> $(HILITE 0 ayse@example.com)
> 1 Barış
> 2 Can
> 2 can@example.com
> 2 40                      $(SHELL_NOTE Can kaydını tamamlar)
Akış 2 tamamlandı.
'Can' eklendi.
> 1 baris@example.com
> 1 30                      $(SHELL_NOTE Barış kaydını tamamlar)
Akış 1 tamamlandı.
'Barış' eklendi.
> $(HILITE 0 20)                      $(SHELL_NOTE Ayşe kaydını tamamlar)
Akış 0 tamamlandı.
'Ayşe' eklendi.
> son
Güle güle.
Kullanıcılar:
  Kullanıcı("Can", "can@example.com", 40)
  Kullanıcı("Barış", "baris@example.com", 30)
  Kullanıcı("Ayşe", "ayse@example.com", 20)
)

$(P
Önce Ayşe, sonra Barış, ve en son Can bağlandıkları halde kayıt işlemlerini farklı sürelerde tamamlamışlardır. Sonuçta $(C kullanıcılar) dizisinin elemanları tamamlanan akış sırasına göre eklenmiştir.
)

$(P
Fiberlerin bu programa bir yararı, $(C KayıtAkışı.başlangıç) işlevinin kullanıcı giriş hızlarından bağımsız olarak basitçe yazılabilmiş olmasıdır. Ek olarak, başka akışlardan bağımsız olarak her zaman için yeni kullanıcı kabul edilebilmektedir.
)

$(P
$(IX vibe.d) $(LINK2 http://vibed.org, vibe.d) gibi çok sayıdaki $(I zaman uyumsuz giriş/çıkış çatısı) da fiberler üzerine kurulu tasarımlardan yararlanır.
)

$(H5 $(IX hata atma, fiber) Fiberler ve hata yönetimi)

$(P
$(LINK2 /ders/d/hatalar.html, Hata Yönetimi bölümünde) "alt düzey bir işlevden atılan bir hatanın teker teker o işlevi çağıran üst düzey işlevlere geçtiğini" görmüştük. Hiçbir düzeyde yakalanmayan bir hatanın ise "$(C main)'den de çıkılmasına ve programın sonlanmasına" neden olduğunu görmüştük. O bölümde hiç çağrı yığıtından bahsedilmemiş olsa da hata atma düzeneği de çağrı yığıtından yararlanır.
)

$(P
$(IX yığıt çözülmesi) Bu bölümün ilk örneğinden devam edersek, $(C bar) içinde bir hata atıldığında çağrı yığıtından önce $(C bar)'ın çerçevesi çıkartılır, ondan sonra $(C foo)'nunki, ve en sonunda da $(C main)'inki. İşlevler sonlanırken çerçevelerinin çağrı yığıtından çıkartılması sırasında o işlevlerin yerel değişkenlerinin sonlandırıcı işlevleri de işletilir. İşlevlerden hata atılması üzerine çıkılması ve sonlandırıcıların işletilmesine $(I yığıt çözülmesi) denir.
)

$(P
Fiberlerin kendi çağrı yığıtları olduğundan, atılan hata da fiberin kendi çağrı yığıtını etkiler, fiberi çağıran kodun çağrı yığıtını değil. Hata yakalanmadığında ise fiber işlevinden de çıkılmış olur ve fiberin durumu $(C Fiber.State.TERM) değerini alır.
)

$(P
$(IX yieldAndThrow, Fiber) Bu, bazı durumlarda tam da istenen davranış olabileceği gibi, bazen fiberin kaldığı yeri kaybetmeden hata durumunu bildirmesi istenebilir. $(C Fiber.yieldAndThrow), fiberin kendisini duraksatmasını ve hemen ardından çağıranın kapsamında bir hata atmasını sağlar.
)

$(P
Bundan nasıl yararlanılabileceğini görmek için yukarıdaki kayıt programına geçersiz yaş bilgisi verelim:
)

$(SHELL
> merhaba
0 numaralı akış başladı.
> 0 Ayşe
> 0 ayse@example.com
> 0 $(HILITE selam)                $(SHELL_NOTE_WRONG kullanıcı geçersiz yaş bilgisi girer)
Hata: Unexpected 's' when converting from type string to type uint
> 0 $(HILITE 20)                   $(SHELL_NOTE hatasını düzeltmeye çalışır)
Hata: Akış 0 işletilebilir durumda değil. $(SHELL_NOTE ama fiber sonlanmıştır)
)

$(P
Fiberin sonlanması nedeniyle bütün kullanıcı akışının kaybedilmesi yerine, fiber atılan dönüşüm hatasını yakalayabilir ve kendisini çağırana $(C yieldAndThrow) ile bildirebilir. Bunun için yaş bilgisinin dönüştürüldüğü aşağıdaki satırın değiştirilmesi gerekir:
)

---
        yaş = veri_.to!uint;
---

$(P
O satırın sonsuz döngüdeki bir $(C try-catch) deyimi içine alınması, $(C uint)'e dönüştürülebilecek veri gelene kadar fiberi canlı tutacaktır:
)

---
        while (true) {
            try {
                yaş = veri_.to!uint;
                break;  // ← Dönüştürüldü; döngüden çıkalım

            } catch (ConvException hata) {
                Fiber.yieldAndThrow(hata);
            }
        }
---

$(P
Bu sefer, geçerli veri gelene kadar döngü içinde kalınır:
)

$(SHELL
> merhaba
0 numaralı akış başladı.
> 0 Ayşe
> 0 ayse@example.com
> 0 $(HILITE selam)                $(SHELL_NOTE_WRONG kullanıcı geçersiz yaş bilgisi girer)
Hata: Unexpected 's' when converting from type string to type uint
> 0 $(HILITE dünya)                $(SHELL_NOTE_WRONG tekrar geçersiz yaş bilgisi girer)
Hata: Unexpected 'd' when converting from type string to type uint
> 0 $(HILITE 20)                   $(SHELL_NOTE sonunda doğru bilgi girer)
Akış 0 tamamlandı.
'Ayşe' eklendi.
> son
Güle güle.
Kullanıcılar:
  Kullanıcı("Ayşe", "ayse@example.com", 20)
)

$(P
Programın çıktısında görüldüğü gibi, artık akış hata nedeniyle sonlanmaz ve kullanıcı sisteme eklenmiş olur.
)

$(H5 $(IX çoklu görev) $(IX iş parçacığı performansı) İşbirlikli çoklu görevler)

$(P
İşletim sisteminin sunduğu çoklu görev olanağı iş parçacıklarını belirsiz zamanlarda duraksatmaya ve tekrar başlatmaya dayanır. Fiberler ise kendilerini istedikleri zaman duraksatırlar ve çağıranları tarafından tekrar başlatılırlar. Bu ayrıma göre, işletim sisteminin sunduğu çoklu görev sistemine $(I geçişli çoklu görev), fiberlerin sunduğuna ise $(I işbirlikli çoklu görev) denir.
)

$(P
$(IX bağlam değiştirme) Geçişli çoklu görev sistemlerinde işletim sistemi başlattığı her iş parçacığına belirli bir süre ayırır. O süre dolduğunda iş parçacığı duraksatılır ve başka bir iş parçacığına $(I geçilir). Bir iş parçacığından başkasına geçmeye $(I bağlam değiştirme) denir. Bağlam değiştirme göreceli olarak masraflı bir işlemdir.
)

$(P
Sistemler genelde çok sayıda iş parçacığı işlettiklerinden bağlam değiştirme hem kaçınılmazdır hem de programların kesintisiz işlemeleri açısından istenen bir durumdur. Ancak, bazı iş parçacıkları ayrılan süreleri daha dolmadan kendilerini duraksatma gereği duyarlar. Bu durum, bir iş parçacığının başka bir iş parçacığından veya bir cihazdan veri beklediği zamanlarda oluşabilir. Bir iş parçacığı kendisini durdurduğunda işletim sistemi başka bir iş parçacığına geçmek için yeniden bağlam değiştirmek zorundadır. Sonuçta, mikro işlemcinin iş gerçekleştirmek amacıyla ayırdığı sürenin bir bölümü bağlam değiştirmek için harcanmıştır.
)

$(P
Fiberlerde ise fiber ve onu çağıran kod aynı iş parçacığı üzerinde işletilirler. (Fiber ve çağıranının aynı anda işletilmemelerinin nedeni budur.) Bunun bir yararı, ikisi arasındaki geçişlerde bağlam değiştirme masrafının bulunmamasıdır. (Yine de işlev çağırma masrafı kadar küçük olan bir masraf vardır.)
)

$(P
İşbirlikli çoklu görevlerin başka bir yararı, fiberle çağıranı arasında iletilen verinin mikro işlemcinin önbelleğinde bulunma olasılığının daha yüksek olmasıdır. Önbelleğe erişmek sistem belleğine erişmekten yüzlerce kat hızlı olduğundan, fiberler iş parçacıklarından çok daha hızlı işleyebilirler.
)

$(P
Dahası, fiber ve çağıranı aynı anda işlemediklerinden, veri erişiminde $(I yarış hali) de söz konusu değildir. Dolayısıyla, $(C synchronized) gibi olanaklar kullanılması da gerekmez. Ancak, programcı yine de fiberin gereğinden erken duraksatılmadığından emin olmalıdır. Örneğin, aşağıdaki $(C işlev()) çağrısı sırasında $(C Fiber.yield) çağrılmamalıdır çünkü $(C paylaşılanVeri)'nin değeri o sırada henüz ikiye katlanmamıştır:
)

---
void fiberİşlevi() {
    // ...

        işlev();              $(CODE_NOTE fiberi duraksatmamalıdır)
        paylaşılanVeri *= 2;
        Fiber.yield();        $(CODE_NOTE istenen duraksatma noktası)

    // ...
}
---

$(P
$(IX M:N, iş parçacıkları) Fiberlerin bariz bir yetersizliği, fiber ve çağıranının tek çekirdek üzerinde işliyor olmalarıdır. Mikro işlemcinin boşta bekleyen çekirdekleri olduğunda bu durum kaynak savurganlığı anlamına gelir. Bunun önüne geçmek için $(I M:N iş parçacığı modeli) $(ASIL M:N threading model) gibi çeşitli yöntemlere başvurulabilir. Bu yöntemleri kendiniz araştırmanızı öneririm.
)

$(H5 Özet)

$(UL

$(LI Çağrı yığıtı işlev yerel durumu için kullanılan alanın çok hızlıca ayrılmasını sağlar ve aralarında özyinelemelilerin de bulunduğu bazı algoritmaları çok basitleştirir.)

$(LI Fiberler normalde tek çağrı yığıtına sahip olan iş parçacıklarının birden fazla çağrı yığıtı kullanmalarını sağlarlar.)

$(LI Fiber ve çağıranı aynı iş parçacığı üzerinde işletilirler (aynı anda değil).)

$(LI Fiber kendisini $(C yield) ile duraksatır ve çağıranı tarafından $(C call) ile tekrar başlatılır.)

$(LI $(C Generator) fiberi $(C InputRange) olarak sunar.)

$(LI Fiberler çağrı yığıtına dayanan algoritmaları basitleştirirler.)

$(LI Fiberler zaman uyumsuz giriş/çıkış işlemlerini basitleştirirler.)

$(LI Fiberler $(I geçişli çoklu görev) sistemlerinden farklı artıları ve eksileri bulunan $(I işbirlikli çoklu görev) sistemleridirler.)

)

macros:
        SUBTITLE=Fiberler

        DESCRIPTION=İş parçacıklarının birden fazla çağrı yığıtı aracılığıyla işbirlikli çoklu görev yürütmeleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial fiber işbirlikli çoklu görev

SOZLER=
$(baglam_degistirme)
$(cagri_yigiti)
$(cerceve)
$(coklu_gorev)
$(erisici)
$(gecisli_coklu_gorev)
$(gorev)
$(hevesli)
$(is_parcacigi)
$(isbirlikli_coklu_gorev)
$(mikro_islemci_cekirdegi)
$(ortak_islev)
$(onbellek)
$(ozyineleme)
$(tembel_degerlendirme)
$(yaris_hali)
$(yigit_cozulmesi)
$(zaman_uyumsuz)
