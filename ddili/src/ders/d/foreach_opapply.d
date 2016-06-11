Ddoc

$(DERS_BOLUMU $(IX foreach, sınıf ve yapı) $(IX struct, foreach) $(IX class, foreach) Yapı ve Sınıflarda $(C foreach))

$(P
$(LINK2 /ders/d/foreach_dongusu.html, $(C foreach) Döngüsü bölümünden) hatırlayacağınız gibi, bu döngü uygulandığı türe göre değişik şekillerde işler. Nasıl kullanıldığına bağlı olarak farklı elemanlara erişim sağlar: dizilerde, sayaçlı veya sayaçsız olarak dizi elemanlarına; eşleme tablolarında, indeksli veya indekssiz olarak tablo elemanlarına; sayı aralıklarında, değerlere; kütüphane türlerinde, o türe özel bir şekilde, örneğin $(C File) için dosya satırlarına...
)

$(P
$(C foreach)'in nasıl işleyeceğini kendi türlerimiz için de belirleyebiliriz. Bunun için iki farklı yöntem kullanılabilir:
)

$(UL
$(LI Türün aralık algoritmalarıyla da kullanılmasına olanak veren $(I aralık işlevleri) tanımlamak)

$(LI Tür için $(C opApply) üye işlevleri tanımlamak)
)

$(P
Bu iki yöntemden $(C opApply) işlevleri önceliklidir: Tanımlanmışlarsa derleyici o üye işlevleri kullanır; tanımlanmamışlarsa $(I aralık işlevlerine) başvurur. Öte yandan, $(I aralık işlevleri) yöntemi çoğu durumda yeterli, daha basit, ve daha kullanışlıdır.
)

$(P
Bu yöntemlere geçmeden önce, $(C foreach)'in her türe uygun olamayacağını vurgulamak istiyorum. Bir nesne üzerinde $(C foreach) ile ilerlemek, ancak o tür herhangi bir şekilde bir $(I topluluk) olarak kabul edilebiliyorsa anlamlıdır.
)

$(P
Örneğin, $(C Öğrenci) gibi bir sınıfın $(C foreach) ile kullanılmasında ne tür değişkenlere erişileceği açık değildir. O yüzden $(C Öğrenci) sınıfının böyle bir konuda destek vermesi beklenmeyebilir. Öte yandan, başka bir bakış açısı ile, $(C foreach) döngüsünün $(C Öğrenci) nesnesinin notlarına erişmek için kullanılacağı da düşünülebilir.
)

$(P
Kendi türlerinizin $(C foreach) desteği verip vermeyeceklerine ve vereceklerse ne tür değişkenlere erişim sağlayacaklarına siz karar vermelisiniz.
)

$(H5 $(IX aralık, foreach) $(C foreach) desteğini aralık işlevleri ile sağlamak)

$(P
$(IX empty) $(IX front) $(IX popFront) $(C foreach)'in $(C for)'un daha kullanışlısı olduğunu biliyoruz. Şöyle bir $(C foreach) döngüsü olsun:
)

---
    foreach (eleman; aralık) {
        // ... ifadeler ...
    }
---

$(P
O döngü, derleyici tarafından arka planda bir $(C for) döngüsü olarak şöyle gerçekleştirilir:
)

---
    for ( ; /* bitmediği sürece */; /* başından daralt */) {

        auto eleman = /* aralığın başındaki */;

        // ... ifadeler ...
    }
---

$(P
$(C foreach)'in kendi türlerimizle de çalışabilmesi için yukarıdaki üç özel bölümde kullanılacak olan üç özel üye işlev tanımlamak gerekir. Bu üç işlev; döngünün sonunu belirlemek, sonrakine geçmek (aralığı baş tarafından daraltmak), ve en baştakine erişim sağlamak için kullanılır.
)

$(P
Bu üç üye işlevin isimleri sırasıyla $(C empty), $(C popFront), ve $(C front)'tur. Derleyicinin arka planda ürettiği kod bu üye işlevleri kullanır:
)

---
    for ( ; !aralık.empty(); aralık.popFront()) {

        auto eleman = aralık.front();

        // ... ifadeler ...
    }
---

$(P
Bu üç işlev aşağıdaki gibi işlemelidir:
)

$(UL

$(LI $(C .empty()): Aralık tükenmişse $(C true), değilse $(C false) döndürür)

$(LI $(C .popFront()): Bir sonrakine geçer (aralığı baş tarafından daraltır))

$(LI $(C .front()): Baştaki elemanı döndürür)

)

$(P
O şekilde işleyen böyle üç üye işleve sahip olması, türün $(C foreach) ile kullanılabilmesi için yeterlidir.
)

$(H6 Örnek)

$(P
Belirli aralıkta değerler üreten bir yapı tasarlayalım. Aralığın başını ve sonunu belirleyen değerler, nesne kurulurken belirlensinler. Geleneklere uygun olarak, son değer aralığın $(I dışında) kabul edilsin. Bir anlamda, D'nin $(C baş..son) şeklinde yazılan aralıklarının eşdeğeri olarak çalışan bir tür tanımlayalım:
)

---
struct Aralık {
    int baş;
    int son;

    invariant() {
        // baş'ın hiçbir zaman son'dan büyük olmaması gerekir
        assert(baş <= son);
    }

    bool empty() const {
        // baş, son'a eşit olduğunda aralık tükenmiş demektir
        return baş == son;
    }

    void popFront() {
        // Bir sonrakine geçmek, baş'ı bir arttırmaktır. Bu
        // işlem, bir anlamda aralığı baş tarafından kısaltır.
        ++baş;
    }

    int front() const {
        // Aralığın başındaki değer, baş'ın kendisidir
        return baş;
    }
}
---

$(P
$(I Not: Ben güvenlik olarak yalnızca $(C invariant) bloğundan yararlandım. Ona ek olarak, $(C popFront) ve $(C front) işlevleri için $(C in) blokları da düşünülebilirdi; o işlevlerin doğru olarak çalışabilmesi için ayrıca aralığın boş olmaması gerekir.)
)

$(P
O yapının nesnelerini artık $(C foreach) ile şöyle kullanabiliriz:
)

---
    foreach (eleman; Aralık(3, 7)) {
        write(eleman, ' ');
    }
---

$(P
$(C foreach), o üç işlevden yararlanarak aralıktaki değerleri sonuna kadar, yani $(C empty)'nin dönüş değeri $(C true) olana kadar kullanır:
)

$(SHELL_SMALL
3 4 5 6 
)

$(H6 $(IX retro, std.range) Ters sırada ilerlemek için $(C std.range.retro))

$(P
$(IX save) $(IX back) $(IX popBack) $(C std.range) modülü aralıklarla ilgili çeşitli olanaklar sunar. Bunlar arasından $(C retro), kendisine verilen aralığı ters sırada kullanır. Türün $(C retro) ile kullanılabilmesi için bu amaca yönelik iki üye işlev daha gerekir:
)

$(UL

$(LI $(C .popBack()): Bir öncekine geçer (aralığı son tarafından daraltır))

$(LI $(C .back()): Sondaki elemanı döndürür)

)

$(P
Ancak, $(C retro)'nun o iki işlevi kullanabilmesi için bir işlevin daha tanımlanmış olması gerekir:
)

$(UL
$(LI $(C .save()): Aralığın şu andaki durumunun kopyasını döndürür)
)

$(P
Bu üye işlevler hakkında daha ayrıntılı bilgiyi daha sonra $(LINK2 /ders/d/araliklar.html, Aralıklar bölümünde) göreceğiz.
)

$(P
Bu üç işlevi $(C Aralık) yapısı için şöyle tanımlayabiliriz:
)

---
struct Aralık {
// ...

    void popBack() {
        // Bir öncekine geçmek, son'u bir azaltmaktır. Bu
        // işlem, bir anlamda aralığı son tarafından kısaltır.
        --son;
    }

    int back() const {
        // Aralığın sonundaki değer, son'dan bir önceki
        // değerdir; çünkü gelenek olarak aralığın sonu,
        // aralığa dahil değildir.
        return son - 1;
    }

    Aralık save() const @property {
        // Aralık nesnesinin şu andaki durumu bir kopyası
        // döndürülerek sağlanabilir.
        return this;
    }
}
---

$(P
Bu türün nesneleri $(C retro) ile kullanılmaya hazırdır:
)

---
import std.range;

// ...

    foreach (eleman; Aralık(3, 7)$(HILITE .retro)) {
        write(eleman, ' ');
    }
---


$(P
Kodun çıktısından anlaşıldığı gibi, $(C retro) yukarıdaki üye işlevlerden yararlanarak bu aralığı ters sırada kullanır:
)

$(SHELL_SMALL
6 5 4 3 
)

$(H5 $(IX opApply) $(IX opApplyReverse) $(C foreach) desteğini $(C opApply) ve $(C opApplyReverse) işlevleri ile sağlamak)

$(P
$(IX foreach_reverse) Bu başlık altında $(C opApply) için anlatılanlar $(C opApplyReverse) için de geçerlidir. $(C opApplyReverse), nesnenin $(C foreach_reverse) döngüsüyle kullanımını belirler.
)

$(P
Yukarıdaki üye işlevler, nesneyi sanki bir aralıkmış gibi kullanmayı sağlarlar. O yöntem, nesnelerin $(C foreach) ile tek bir şekilde kullanılmaları durumuna daha uygundur. Örneğin $(C Öğrenciler) gibi bir türün nesnelerinin, öğrencilere $(C foreach) ile teker teker erişim sağlaması, o yöntemle kolayca gerçekleştirilebilir.
)

$(P
Öte yandan, bazen bir nesne üzerinde farklı şekillerde ilerlemek istenebilir. Bunun örneklerini eşleme tablolarından biliyoruz: Döngü değişkenlerinin tanımına bağlı olarak ya yalnızca elemanlara, ya da hem elemanlara hem de indekslere erişilebiliyordu:
)

---
    string[string] ingilizcedenTürkçeye;

    // ...

    foreach (türkçesi; ingilizcedenTürkçeye) {
        // ... yalnızca elemanlar ...
    }

    foreach (ingilizcesi, türkçesi; ingilizcedenTürkçeye) {
        // ... indeksler ve elemanlar ...
    }
---

$(P
$(C opApply) işlevleri, kendi türlerimizi de $(C foreach) ile birden fazla şekilde kullanma olanağı sağlarlar. $(C opApply)'ın nasıl tanımlanması gerektiğini görmeden önce $(C opApply)'ın nasıl çağrıldığını anlamamız gerekiyor.
)

$(P
Programın işleyişi, $(C foreach)'in kapsamına yazılan işlemler ile $(C opApply) işlevinin işlemleri arasında, belirli bir $(I anlaşmaya) uygun olarak gider gelir. Önce $(C opApply)'ın içi işletilir; $(C opApply) kendi işi sırasında $(C foreach)'in işlemlerini çağırır; ve bu karşılıklı gidiş geliş döngü sonuna kadar devam eder.
)

$(P
Bu $(I anlaşmayı) açıklamadan önce $(C foreach) döngüsünün yapısını tekrar hatırlatmak istiyorum:
)

---
// Programcının yazdığı döngü:

    foreach (/* döngü değişkenleri */; nesne) {
        // ... işlemler ...
    }
---

$(P
$(IX temsilci, foreach) Eğer döngü değişkenlerine uyan bir $(C opApply) işlevi tanımlanmışsa; derleyici, döngü değişkenlerini ve döngü kapsamını kullanarak bir $(I temsilci) oluşturur ve nesnenin $(C opApply) işlevini o temsilci ile çağırır.
)

$(P
Buna göre, yukarıdaki döngü derleyici tarafından arka planda aşağıdaki koda dönüştürülür. Temsilciyi oluşturan kapsam parantezlerini sarı ile işaretliyorum:
)

---
// Derleyicinin arka planda kullandığı kod:

    nesne.opApply(delegate int(/* döngü değişkenleri */) $(HILITE {)
        // ... işlemler ...
        return sonlandı_mı;
    $(HILITE }));
---

$(P
Yani, $(C foreach) döngüsü ortadan kalkar; onun yerine nesnenin $(C opApply) işlevi derleyicinin oluşturduğu bir temsilci ile çağrılır. Derleyicinin oluşturduğu bir temsilcinin kullanılıyor olması $(C opApply) işlevinin yazımı konusunda bazı zorunluluklar getirir.
)

$(P
Bu dönüşümü ve uyulması gereken zorunlulukları şu maddelerle açıklayabiliriz:
)

$(OL

$(LI $(C foreach)'in işlemleri temsilciyi oluşturan işlemler haline gelirler. Bu temsilci $(C opApply) tarafından çağrılmalıdır.)

$(LI Döngü değişkenleri temsilcinin parametreleri haline gelirler. Bu parametrelerin $(C opApply)'ın tanımında $(C ref) olarak işaretlenmeleri gerekir.)

$(LI Temsilcinin dönüş türü $(C int)'tir. Buna uygun olarak, temsilcinin sonuna derleyici tarafından bir $(C return) satırı eklenir. $(C return)'ün döndürdüğü bilgi, döngünün $(C break) veya $(C return) ile sonlanıp sonlanmadığını anlamak için kullanılır. Eğer sıfır ise döngü devam etmelidir; sıfırdan farklı ise döngü sonlanmalıdır.)

$(LI Asıl döngü $(C opApply)'ın içinde programcı tarafından gerçekleştirilir.)

$(LI $(C opApply), temsilcinin döndürmüş olduğu $(C sonlandı_mı) değerini döndürmelidir.)

)

$(P
$(C Aralık) yapısını bu anlaşmaya uygun olarak aşağıdaki gibi tanımlayabiliriz. Yukarıdaki maddeleri, ilgili oldukları yerlerde açıklama satırları olarak belirtiyorum:
)

---
struct Aralık {
    int baş;
    int son;

                         //    (2)      (1)
    int opApply(int delegate(ref int) işlemler) const {
        int sonuç = 0;

        for (int sayı = baş; sayı != son; ++sayı) {  // (4)
            sonuç = işlemler(sayı);  // (1)

            if (sonuç) {
                break;               // (3)
            }
        }

        return sonuç;                // (5)
    }
}
---

$(P
Bu yapıyı da $(C foreach) ile aynı şekilde kullanabiliriz:
)

---
    foreach (eleman; Aralık(3, 7)) {
        write(eleman, ' ');
    }
---

$(P
Çıktısı, aralık işlevleri kullanıldığı zamanki çıktının aynısı olacaktır:
)

$(SHELL_SMALL
3 4 5 6 
)

$(H6 Farklı biçimlerde ilerlemek için $(C opApply)'ın yüklenmesi)

$(P
Nesne üzerinde farklı şekillerde ilerleyebilmek, $(C opApply)'ın değişik türlerdeki temsilcilerle yüklenmesi ile sağlanır. Derleyici, $(C foreach) değişkenlerinin uyduğu bir $(C opApply) yüklemesi bulur ve onu çağırır.
)

$(P
Örneğin, $(C Aralık) nesnelerinin iki $(C foreach) değişkeni ile de kullanılabilmelerini isteyelim:
)

---
    foreach ($(HILITE birinci, ikinci); Aralık(0, 15)) {
        writef("%s,%s ", birinci, ikinci);
    }
---

$(P
O kullanım, eşleme tablolarının hem indekslerine hem de elemanlarına $(C foreach) ile erişildiği duruma benzer.
)

$(P
Bu örnekte, $(C Aralık) yukarıdaki gibi iki değişkenle kullanıldığında art arda iki değere erişiliyor olsun; ve döngünün her ilerletilişinde değerler beşer beşer artsın. Yani yukarıdaki döngünün çıktısı şöyle olsun:
)

$(SHELL_SMALL
0,1 5,6 10,11 
)

$(P
Bunu sağlamak için iki değişkenli bir temsilci ile çalışan yeni bir $(C opApply) tanımlamak gerekir. O temsilci $(C opApply) tarafından ve bu kullanıma uygun olan iki değerle çağrılmalıdır:
)

---
    int opApply(int delegate($(HILITE ref int, ref int)) işlemler) const {
        int sonuç = 0;

        for (int i = baş; (i + 1) < son; i += 5) {
            int birinci = i;
            int ikinci = i + 1;

            sonuç = işlemler($(HILITE birinci, ikinci));

            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }
---

$(P
İki değişkenli döngü kullanıldığında üretilen temsilci bu $(C opApply) yüklemesine uyduğu için, derleyici bu tanımı kullanır.
)

$(P
Tür için anlamlı olduğu sürece başka $(C opApply) işlevleri de tanımlanabilir.
)

$(P
Hangi $(C opApply) işlevinin seçileceği döngü değişkenlerinin adedi yanında, türleri ile de belirlenebilir. Değişkenlerin türleri $(C foreach) döngüsünde açıkça yazılabilir ve böylece ne tür elemanlar üzerinde ilerlenmek istendiği açıkça belirtilebilir.
)

$(P
Buna göre, $(C foreach) döngüsünün hem öğrencilere hem de öğretmenlere erişmek için kullanılabileceği bir $(C Okul) sınıfı şöyle tanımlanabilir:
)

---
class Okul {
    int opApply(int delegate(ref $(HILITE Öğrenci)) işlemler) const {
        // ...
    }

    int opApply(int delegate(ref $(HILITE Öğretmen)) işlemler) const {
        // ...
    }
}
---

$(P
Bu $(C Okul) türünü kullanan programlar, hangi elemanlar üzerinde ilerleneceğini döngü değişkenini açık olarak yazarak seçebilirler:
)

---
    foreach ($(HILITE Öğrenci) öğrenci; okul) {
        // ...
    }

    foreach ($(HILITE Öğretmen) öğretmen; okul) {
        // ...
    }
---

$(P
Derleyici, değişkenin türüne uyan bir temsilci üretecek ve o temsilciye uyan $(C opApply) işlevini çağıracaktır.
)

$(H5 $(IX döngü sayacı) $(IX sayaç, döngü) Döngü sayacı)

$(P
$(C foreach)'in dizilerle kullanımında kolaylık sağlayan döngü sayacı bütün türler için otomatik değildir. İstendiğinde kendi türlerimiz için açıkça programlamamız gerekir.
)

$(H6 $(IX enumerate, std.range) Aralık işlevleriyle döngü sayacı)

$(P
Eğer $(C foreach) aralık işlevleriyle sağlanmışsa sayaç elde etmenin en kolay yolu $(C std.range) modülünde tanımlı olan ve "numaralandır" anlamına gelen $(C enumerate)'ten yararlanmaktır:
)

---
import std.range;

// ...

    foreach ($(HILITE i), eleman; Aralık(42, 47)$(HILITE .enumerate)) {
        writefln("%s: %s", i, eleman);
    }
---

$(P
$(C enumerate) sıfırdan başlayan sayılar üretir ve bu sayıları asıl aralığın elemanları ile eşleştirir. (Sıfırdan farklı başlangıç değeri de seçilebilir.) Sonuçta, sayaç ve asıl aralıktaki değerler $(C foreach)'in iki döngü değişkeni olarak elde edilirler:
)

$(SHELL_SMALL
0: 42
1: 43
2: 44
3: 45
4: 46
)

$(H6 $(C opApply) ile döngü sayacı)

$(P
$(C foreach) desteğinin $(C opApply) ile sağlandığı durumda ise sayaç değişkeninin $(C size_t) türünde ek bir değişken olarak tanımlanması gerekir. Bunu göstermek için noktalardan oluşan ve kendi rengine sahip olan bir poligon yapısı tasarlayalım.
)

$(P
Bu yapının noktalarını sunan $(I sayaçsız) bir $(C opApply) yukarıdakilere benzer biçimde şöyle tanımlanabilir:
)

---
import std.stdio;

enum Renk { mavi, yeşil, kırmızı }

struct Nokta {
    int x;
    int y;
}

struct Poligon {
    Renk renk;
    Nokta[] noktalar;

    int $(HILITE opApply)(int delegate(ref const(Nokta)) işlemler) const {
        int sonuç = 0;

        foreach (nokta; noktalar) {
            sonuç = işlemler(nokta);

            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }
}

void main() {
    auto poligon = Poligon(Renk.mavi,
                           [ Nokta(0, 0), Nokta(1, 1) ] );

    foreach (nokta; poligon) {
        writeln(nokta);
    }
}
---

$(P
$(C opApply)'ın tanımında da $(C foreach)'ten yararlanıldığına dikkat edin. $(C main) içinde $(C poligon) nesnesi üzerinde işleyen $(C foreach), poligonun $(C noktalar) üyesi üzerinde işletilen bir $(C foreach)'ten yararlanmış olur.
)

$(P
$(C delegate)'in parametresinin $(C ref const(Nokta)) olduğuna dikkat edin. Bu, bu $(C opApply)'ın elemanların $(C foreach) içinde değiştirilmelerine izin vermediği anlamına gelir. Elemanların değiştirilmelerine izin verilmesi için hem $(C opApply)'ın hem de parametresinin $(C const) belirteci olmadan tanımlanmaları gerekir.
)

$(P
Çıktısı:
)

$(SHELL
const(Nokta)(0, 0)
const(Nokta)(1, 1)
)

$(P
$(C Poligon) türünü bu tanımı ile sayaçlı olarak kullanmaya çalıştığımızda bu kullanım $(C opApply) yüklemesine uymayacağından doğal olarak bir derleme hatasıyla karşılaşırız:
)

---
    foreach ($(HILITE sayaç), nokta; poligon) {    $(DERLEME_HATASI)
        writefln("%s: %s", sayaç, nokta);
    }
---

$(P
Derleme hatası $(C foreach) değişkenlerinin anlaşılamadıklarını bildirir:
)

$(SHELL
Error: cannot uniquely infer foreach argument types
)

$(P
Böyle bir kullanımı destekleyen bir $(C opApply) yüklemesi, $(C opApply)'ın aldığı temsilcinin $(C size_t) ve $(C Nokta) türlerinde iki parametre alması ile sağlanmalıdır:
)

---
    int opApply(int delegate($(HILITE ref size_t),
                             ref const(Nokta)) işlemler) const {
        int sonuç = 0;

        foreach ($(HILITE sayaç), nokta; noktalar) {
            sonuç = işlemler($(HILITE sayaç), nokta);

            if (sonuç) {
                break;
            }
        }

        return sonuç;
    }
---

$(P
Program $(C foreach)'in son kullanımını bu $(C opApply) yüklemesine uydurur ve artık derlenir:
)

$(SHELL
0: const(Nokta)(0, 0)
1: const(Nokta)(1, 1)
)

$(P
Bu $(C opApply)'ın tanımında $(C noktalar) üyesi üzerinde işleyen $(C foreach) döngüsünün otomatik sayacından yararlanıldığına dikkat edin. ($(I Temsilci parametresi $(C ref size_t) olarak tanımlanmış olduğu halde, $(C main) içindeki $(C foreach) döngüsü $(C noktalar) üzerinde ilerleyen otomatik sayacı değiştiremez.))
)

$(P
Gerektiğinde sayaç değişkeni açıkça tanımlanabilir ve arttırılabilir. Örneğin, aşağıdaki $(C opApply) bu sefer bir $(C while) döngüsünden yararlandığı için sayacı kendisi tanımlıyor ve arttırıyor:
)

---
    int opApply(int delegate(ref size_t,
                             ref Eleman) işlemler) const {
        int sonuç = 0;
        bool devam_mı = true;

        $(HILITE size_t sayaç = 0;)
        while (devam_mı) {
            // ...

            sonuç = işlemler(sayaç, sıradakiEleman);

            if (sonuç) {
                break;
            }

            ++sayaç;
        }

        return sonuç;
    }
---

$(H5 Uyarı: $(C foreach)'in işleyişi sırasında topluluk değişmemelidir)

$(P
Hangi yöntemle olursa olsun, $(C foreach) desteği veren bir tür, döngünün işleyişi sırasında sunduğu $(I topluluk) kavramında bir değişiklik yapmamalıdır: döngünün işleyişi sırasında yeni elemanlar eklememeli ve var olan elemanları silmemelidir. (Var olan elemanların değiştirilmelerinde bir sakınca yoktur.)
)

$(P
Bu kurala uyulmaması tanımsız davranıştır.
)

$(PROBLEM_COK

$(PROBLEM
Yukarıdaki $(C Aralık) gibi çalışan, ama aralıktaki değerleri birer birer değil, belirtilen adım kadar ilerleten bir yapı tanımlayın. Adım bilgisini kurucu işlevinin üçüncü parametresi olarak alsın:

---
    foreach (sayı; Aralık(0, 10, $(HILITE 2))) {
        write(sayı, ' ');
    }
---

$(P
Sıfırdan 10'a kadar ikişer ikişer ilerlemesi beklenen o $(C Aralık) nesnesinin çıktısı şöyle olsun:
)

$(SHELL_SMALL
0 2 4 6 8 
)

)

$(PROBLEM
Yazı içinde geçen $(C Okul) sınıfını, $(C foreach)'in döngü değişkenlerine göre öğrencilere veya öğretmenlere erişim sağlayacak şekilde yazın.
)

)

Macros:
        SUBTITLE=Yapı ve Sınıflarda foreach

        DESCRIPTION=D'nin foreach döngüsünün işleyişinin yapılar ve sınıflar için o türlere uygun olacak şekilde belirlenmesi

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial foreach foreach_reverse struct class yapı sınıf opApply opApplyReverse empty popFront front popBack back

SOZLER=
$(aralik)
$(kapsam)
$(tanimsiz_davranis)
$(temsilci)
$(topluluk)
$(yukleme)
