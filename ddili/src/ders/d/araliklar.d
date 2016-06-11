Ddoc

$(DERS_BOLUMU $(IX aralık) Aralıklar)

$(P
Aralıklar, topluluk elemanlarına erişim işlemini soyutlarlar. Bu soyutlama, çok sayıdaki veri yapısının çok sayıdaki algoritma ile uyumlu olarak kullanılmasını sağlar. Veri yapılarının nasıl gerçekleştirilmiş oldukları önemsizleşir, elemanlarına nasıl erişildiği ön plana çıkar.
)

$(P
Aralıklar, türlerin belirli isimdeki işlevleri sunmaları ilkesi üzerine kurulu olan aslında çok basit bir kavramdır. Bu kavramla daha önce $(LINK2 /ders/d/foreach_opapply.html, Yapı ve Sınıflarda $(C foreach) bölümünde) de karşılaşmıştık: $(C empty), $(C front) ve $(C popFront()) üye işlevlerini tanımlayan her tür, $(C foreach) döngüsü ile kullanılabiliyordu. O üç işlev, $(C InputRange) aralık çeşidinin gerektirdiği işlevlerdir.
)

$(P
Aralıklarla ilgili kavramları en basit aralık çeşidi olan $(C InputRange) ile göstereceğim. Diğer aralıkların farkları, başka işlevler de gerektirmeleridir.
)

$(P
Daha ileri gitmeden önce aralıklarla doğrudan ilgili olan topluluk ve algoritma tanımlarını hatırlatmak istiyorum.
)

$(P
$(IX topluluk) $(IX veri yapısı) $(B Topluluk (veri yapısı):) Topluluk, neredeyse bütün programlarda karşılaşılan çok yararlı bir kavramdır. Değişkenler belirli amaçlarla bir araya getirilirler ve sonradan bir topluluğun elemanları olarak kullanılırlar. D'deki topluluklar; diziler, eşleme tabloları, ve $(C std.container) modülünde tanımlanmış olan topluluk türleridir. Her topluluk belirli bir $(I veri yapısı) olarak gerçekleştirilir. Örneğin eşleme tabloları bir $(I hash table) veri yapısı gerçekleştirmesidir.
)

$(P
Her veri yapısı türü, elemanları o veri yapısına özel biçimde barındırır ve elemanlara o veri yapısına özel biçimde eriştirir. Örneğin dizi veri yapısında elemanlar yan yana dururlar ve sıra numarası ile erişilirler; bağlı liste yapısında elemanlar düğümlerde saklanırlar ve bu düğümler aracılığıyla erişilirler; ikili ağaç veri yapısında düğümler kendilerinden sıralamada önceki ve sonraki elemanlara farklı dallar yoluyla erişim sağlarlar; vs.
)

$(P
Ben bu bölümde $(I topluluk) ve $(I veri yapısı) deyimlerini aynı anlamda kullanacağım.
)

$(P
$(IX algoritma) $(B Algoritma (işlev):) Veri yapılarının belirli amaçlarla ve belirli adımlar halinde işlenmelerine algoritma denir. Örneğin $(I sıralı arama) algoritması, aranan değeri topluluktaki bütün elemanları başından sonuna kadar ilerleyerek arayan bir algoritmadır; $(I ikili arama) algoritması, her adımda elemanların yarısını eleyerek arayan bir algoritmadır; vs.
)

$(P
Ben bu bölümde $(I algoritma) ve $(I işlev) deyimlerini aynı anlamda kullanacağım.
)

$(P
Aşağıdaki çoğu örnekte eleman türü olarak $(C int), topluluk türü olarak da $(C int[]) kullanacağım. Aslında aralıkların gücü şablonlarla birlikte kullanıldıklarında ortaya çıkar. Aralıkların birbirlerine uydurduğu çoğu topluluk ve çoğu algoritma şablondur. Bunların örneklerini bir sonraki bölüme bırakacağım.
)

$(H5 Tarihçe)

$(P
Algoritmalarla veri yapılarını birbirlerinden başarıyla soyutlayan bir kütüphane, C++ dilinin standart kütüphanesinin de bir parçası olan STL'dir (Standard Template Library). STL bu soyutlamayı C++'ın şablon olanağından yararlanarak gerçekleştirdiği $(I erişici) (iterator) kavramı ile sağlar.
)

$(P
Çok güçlü bir soyutlama olmasına rağmen erişici kavramının bazı zayıflıkları da vardır. Aralıklar, erişicilerin bu zayıflıklarını gidermeye yönelik olarak Andrei Alexandrescu tarafından tasarlanmıştır. Phobos, aralıkları kullanan ilk ve bilinen tek kütüphanedir.
)

$(P
Andrei Alexandrescu, $(LINK2 http://ddili.org/makale/eleman_erisimi_uzerine.html, Eleman Erişimi Üzerine) isimli makalesinde aralıkları tanıtır ve aralıkların erişicilerden neden daha üstün olduklarını gösterir.
)

$(H5 Aralıklar D'de kaçınılmazdır)

$(P
Aralıklar D'ye özgü bir kavramdır. Dilimler en işlevsel aralık çeşidi olan $(C RandomAccessRange)'e uyarlar ve Phobos, aralıklarla ilgili çok sayıda olanak içerir. Çoğu programda kendi aralık türlerimizi veya aralık işlevlerimizi yazmamız gerekmez. Buna rağmen aralıkların Phobos'ta nasıl kullanıldığını bilmek önemlidir.
)

$(P
Phobos'taki çok sayıda algoritma, kullanımları sırasında farkedilmese bile aslında geçici aralık nesneleri döndürürler. Örneğin elemanların 10'dan büyük olanlarını seçmek için kullanılan aşağıdaki $(C filter()) dizi değil, aralık nesnesi döndürür:
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] sayılar = [ 1, 20, 7, 11 ];
    writeln(sayılar.filter!(sayı => sayı > 10));
}
---

$(P
$(C writeln), $(C filter())'ın döndürmüş olduğu aralık nesnesini gerektikçe tembel olarak kullanır. Sonuçta, belirtilen kıstasa uyan elemanlar yazdırılırlar:
)

$(SHELL
[20, 11]
)

$(P
O sonuca bakarak $(C filter())'ın $(C int) dizisi döndürdüğü düşünülebilir; ancak bu doğru değildir. Döndürülen nesne bir dizi olmadığı için örneğin aşağıdaki satır derlenemez:
)

---
    int[] seçilenler = sayılar.filter!(sayı => sayı > 10); $(DERLEME_HATASI)
---

$(P
Döndürülen nesnenin türünü hata mesajında görüyoruz:
)

$(SHELL
Error: cannot implicitly convert expression (filter(sayılar))
of type $(HILITE FilterResult!(__lambda2, int[])) to int[]
)

$(P
$(I Not: O tür sizin denediğiniz Phobos sürümünde farklı olabilir.)
)

$(P
O geçici aralık nesnesinin istendiğinde bir diziye de dönüştürülebileceğini aşağıda göstereceğim.
)

$(H5 Algoritmaların geleneksel gerçekleştirmeleri)

$(P
Geleneksel olarak algoritmalar işlemekte oldukları veri yapılarının nasıl gerçekleştirildiklerini bilmek zorundadırlar. Örneğin bir bağlı listenin elemanlarını sırayla çıkışa yazdıran aşağıdaki işlev, kullandığı bağlı listenin düğümlerinin $(C eleman) ve $(C sonraki) isminde iki üyesi bulunduğunu bilmek zorundadır:
)
---
struct Düğüm {
    int eleman;
    Düğüm * sonraki;
}

void yazdır(const(Düğüm) * liste) {
    for ( ; liste; liste = liste.$(HILITE sonraki)) {
        write(' ', liste.$(HILITE eleman));
    }
}
---

$(P
Benzer şekilde, bir diziyi yazdıran işlev de dizilerin $(C length) isminde niteliklerinin bulunduğunu ve elemanlarına $(C []) işleci ile erişildiğini bilmek zorundadır:
)

---
void yazdır(const int[] dizi) {
    for (int i = 0; i != dizi.$(HILITE length); ++i) {
        write(' ', dizi$(HILITE [i]));
    }
}
---

$(P
$(I Not: Dizilerde ilerlerken $(C foreach)'in daha uygun olduğunu biliyoruz. Amacım algoritmaların geleneksel olarak veri yapılarına doğrudan bağlı olduklarını göstermek olduğu için, $(C for)'un gerçekten gerektiği bir durum olduğunu kabul edelim.)
)

$(P
Algoritmaların veri yapılarına bu biçimde bağlı olmaları, onların her veri yapısı için özel olarak yazılmalarını gerektirir. Örneğin; dizi, bağlı liste, eşleme tablosu, ikili ağaç, yığın, vs. gibi veri yapılarının her birisi için ara(), sırala(), ortakOlanlarınıBul(), değiştir(), vs. gibi algoritmaların ayrı ayrı yazılmaları gerekir. Bunun sonucunda da A adet algoritmanın V adet veri yapısı ile kullanılabilmesi için gereken işlev sayısı A çarpı V'dir. (Not: Her algoritma her veri yapısı ile kullanılamadığı için gerçekte bu sayı daha düşüktür. Örneğin eşleme tabloları sıralanamazlar.)
)

$(P
Öte yandan, aralıklar veri yapılarıyla algoritmaları birbirlerinden soyutladıkları için yalnızca A adet algoritma ve V adet veri yapısı yazmak yeterli olur. Yeni yazılan bir veri yapısı, onun sunduğu aralık çeşidini destekleyen bütün algoritmalarla kullanılmaya hazırdır; yeni yazılan bir algoritma da onun gerektirdiği aralık çeşidine uyan bütün veri yapıları ile işlemeye hazırdır.
)

$(H5 Phobos aralıkları)

$(P
Bu bölümün konusu olan aralıklar, $(C baş..son) biçiminde yazılan sayı aralıklarından farklıdır. Sayı aralıklarını $(C foreach) döngüsündeki ve dilimlerdeki kullanımlarından tanıyoruz:
)

---
    int[] dilim = dizi[$(HILITE 5..10)];   // sayı aralığı,
                                 // Phobos aralığı DEĞİL

    foreach (sayı; $(HILITE 3..7)) {       // sayı aralığı,
                                 // Phobos aralığı DEĞİL
---

$(P
Ben bu bölümde $(I aralık) yazdığım yerlerde Phobos aralıklarını kastedeceğim.
)

$(P
Aralıklar bir $(I aralık sıradüzeni) oluştururlar. Bu sıradüzen en basit aralık olan $(C InputRange) ile başlar. Diğer aralıklar, temel aldıkları aralığın gerektirdiği işlevlere ek olarak başka işlevler de gerektirirler. Aralık çeşitleri, en temelden en işlevsele doğru ve gerektirdikleri işlevlerle birlikte şunlardır:
)

$(UL

$(LI $(C InputRange), $(I giriş aralığı): $(C empty), $(C front) ve $(C popFront()) işlevleri)

$(LI $(C ForwardRange), $(I ilerleme aralığı): ek olarak $(C save) işlevi)

$(LI $(C BidirectionalRange), $(I çift uçlu aralık): ek olarak $(C back) ve $(C popBack()) işlevleri)

$(LI $(C RandomAccessRange), $(I rastgele erişimli aralık): ek olarak $(C []) işleci (sonlu veya sonsuz olmasına göre başka koşullar da gerektirir))

)

$(P
Bu sıradüzeni aşağıdaki gibi gösterebiliriz. $(C RandomAccessRange), sonlu ve sonsuz olarak iki çeşittir:
)

$(MONO
                    InputRange
                  $(ASIL giriş aralığı)
                        ↑
                   ForwardRange
                $(ASIL ilerleme aralığı)
                   ↗         ↖
     BidirectionalRange     RandomAccessRange (sonsuz)
     $(ASIL çift uçlu aralık)     $(ASIL rastgele erişimli aralık)
             ↑
  RandomAccessRange (sonlu)
  $(ASIL rastgele erişimli aralık)
)

$(P
Yukarıdaki aralıklar eleman erişimine yönelik aralıklardır. Onlara ek olarak eleman $(I çıkışı) ile ilgili olan bir aralık daha vardır:
)

$(UL
$(LI $(C OutputRange), $(I çıkış aralığı): $(C put(aralık, eleman)) işlemini desteklemek)
)

$(P
Bu beş aralık, algoritmaların veri yapılarından soyutlanmaları için yeterlidir.
)

$(H6 Aralığı daraltarak ilerlemek)

$(P
Şimdiye kadar çoğu örnekte kullandığımız ilerleme yönteminde aralığın kendi durumunda değişiklik olmaz. Örneğin bir dilimde $(C foreach) veya $(C for) ile ilerlendiğinde dilimin kendisi değişmez:
)

---
    int[] dilim = [ 10, 11, 12 ];

    for (int i = 0; i != dilim.length; ++i) {
        write(' ', dilim[i]);
    }

    assert(dilim.length == 3);    // uzunluğu değişmez
---

$(P
Burada, salt ilerleme işleminin dilimde bir değişiklik oluşturmadığını belirtmek istiyorum.
)

$(P
Farklı bir bakış açısı getiren bir yöntem, aralığı başından daraltarak ilerlemektir. Bu yöntemde aralığın hep ilk elemanına erişilir. İlerleme, her seferinde baştaki eleman çıkartılarak sağlanır:
)

---
    for ( ; dilim.length; dilim = dilim[1..$]) {
        write(' ', $(HILITE dilim[0]));     // hep ilk elemana erişilir
    }
---

$(P
Yukarıdaki döngünün $(I ilerlemesi), $(C dilim&nbsp;=&nbsp;dilim[1..$]) ifadesinin baştaki elemanı dilimden çıkartması ile sağlanmaktadır. Dilim, o ifadenin etkisiyle aşağıdaki aşamalardan geçerek daralır ve sonunda boşalır:
)

$(MONO
[ 10, 11, 12 ]
    [ 11, 12 ]
        [ 12 ]
           [ ]
)

$(P
İşte Phobos aralıklarındaki ilerleme kavramı, aralığı bu şekilde başından daraltma düşüncesi üzerine kuruludur. ($(C BidirectionalRange) ve sonlu $(C RandomAccessRange) aralıkları son taraftan da daralabilirler.)
)

$(P
O örneği yalnızca bu tür ilerleme kavramını göstermek için verdim; $(C for) döngülerinin o şekilde yazılması normal kabul edilmemelidir.
)

$(P
Salt ilerlemiş olmak için elemanların dilimden bu şekilde çıkartılmaları çoğu durumda istenmeyeceğinden; asıl topluluğun kendisi değil, yalnızca ilerlemek için oluşturulan başka bir aralık tüketilir. Bu örnekteki asıl dilimi korumak için örneğin başka bir dilimden yararlanılabilir:
)

---
    int[] dilim = [ 10, 11, 12 ];
    int[] dilim2 = dilim;

    for ( ; dilim2.length; $(HILITE dilim2 = dilim2[1..$])) {
        write(' ', dilim2[0]);
    }

    assert(dilim2.length == 0);   // ← dilim2 boşalır
    assert(dilim.length == 3);    // ← dilim değişmez
---

$(P
Phobos işlevleri de asıl topluluğun değişmemesi için özel aralık nesneleri döndürürler.
)

$(H5 $(IX InputRange) $(IX giriş aralığı) $(C InputRange), $(I giriş aralığı))

$(P
Bu çeşit aralık, yukarıdaki geleneksel $(C yazdır()) işlevlerinde de olduğu gibi elemanların art arda erişildikleri aralık çeşidini ifade eder. Bu erişim hep ileri yöndedir; tekrar başa dönülemez. Buna rağmen, çok sayıda algoritma yalnızca $(C InputRange) kullanarak yazılabilir; çünkü çoğu algoritma yalnızca $(I ileri yönde ilerleme) üzerine kuruludur. Programların standart girişlerinde olduğu gibi, okundukça elemanların tüketildikleri akımlar da bu tür aralık tanımına girerler.
)

$(P
$(C InputRange) aralıklarının gerektirdiği üç işlevi bütünlük amacıyla bir kere daha hatırlatıyorum:
)

$(UL

$(LI $(IX empty) $(C empty): "boş mu" anlamına gelir ve aralığın sonuna gelinip gelinmediğini bildirir; aralık boş kabul edildiğinde $(C true), değilse $(C false) döndürmelidir)

$(LI $(IX front) $(C front): "öndeki" anlamına gelir ve aralığın başındaki elemana erişim sağlar)

$(LI $(IX popFront) $(C popFront()): "öndekini çıkart" anlamına gelir ve aralığın başındaki elemanı çıkartarak aralığı baş tarafından daraltır)

)

$(P
$(I Not: $(C empty) ve $(C front) işlevlerini nitelik olarak kullanılmaya uygun oldukları için parantezsiz, $(C popFront()) işlevini ise yan etkisi olan bir işlev olduğu için parametre listesi ile yazmaya karar verdim.)
)

$(P
$(C yazdır()) işlevini bir kere de bu üç işlevden yararlanacak şekilde gerçekleştirelim:
)

---
void yazdır(T)(T aralık) {
    for ( ; !aralık$(HILITE .empty); aralık$(HILITE .popFront())) {
        write(' ', aralık$(HILITE .front));
    }

    writeln();
}
---

$(P
Aralığın elemanlarının türü konusunda bir kısıtlama getirmiş olmamak için işlevi ayrıca şablon olarak tanımladığıma dikkat edin. $(C yazdır()) böylece topluluğun asıl türünden de bağımsız hale gelir ve $(C InputRange)'in gerektirdiği üç işlevi sunan her toplulukla kullanılabilir.
)

$(H6 Bir $(C InputRange) örneği)

$(P
Daha önce de karşılaşmış olduğumuz $(C Okul) türünü $(C InputRange) tanımına uygun olarak tekrar tasarlayalım. $(C Okul)'u bir $(C Öğrenci) topluluğu olarak düşünelim ve onu elemanlarının türü $(C Öğrenci) olan bir aralık olarak tanımlamaya çalışalım.
)

$(P
Örneği kısa tutmuş olmak için bazı önemli konularla ilgilenmeyeceğim:
)

$(UL

$(LI yalnızca bu bölümü ilgilendiren üyeleri yazacağım)

$(LI bütün türleri yapı olarak tasarlayacağım)

$(LI $(C private), $(C public), $(C const) gibi aslında yararlı olan belirteçler kullanmayacağım)

$(LI sözleşmeli programlama veya birim testi olanaklarından yararlanmayacağım)

)

---
import std.string;

struct Öğrenci {
    string isim;
    int numara;

    string toString() const {
        return format("%s(%s)", isim, numara);
    }
}

struct Okul {
    Öğrenci[] öğrenciler;
}

void main() {
    auto okul = Okul( [ Öğrenci("Ebru", 1),
                        Öğrenci("Derya", 2) ,
                        Öğrenci("Damla", 3) ] );
}
---

$(P
$(C Okul) türünü bir $(C InputRange) olarak kullanabilmek için, $(C InputRange)'in gerektirdiği üç üye işlevi tanımlamamız gerekiyor.
)

$(P
$(C empty) işlevinin aralık boş olduğunda $(C true) döndürmesini sağlamak için doğrudan $(C öğrenciler) dizisinin uzunluğunu kullanabiliriz. Dizinin uzunluğu 0 olduğunda aralık da boş kabul edilmelidir:
)

---
struct Okul {
    // ...

    @property bool empty() const {
        return öğrenciler.length == 0;
    }
}
---

$(P
Programda kullanırken $(C okul.empty) biçiminde parantezsiz olarak  yazabilmek için işlevi $(C @property) belirteci ile tanımladım.
)

$(P
$(C front) işlevinin aralıktaki ilk elemanı döndürmesi, dizinin ilk elemanı döndürülerek sağlanabilir:
)

---
struct Okul {
    // ...

    @property ref Öğrenci front() {
        return öğrenciler[0];
    }
}
---

$(P
$(I Not: Dizideki asıl elemana erişim sağlamış olmak için $(C ref) dönüş türü kullandığımıza dikkat edin. Öyle yazmasaydık, $(C Öğrenci) bir yapı türü olduğu için ilk elemanın kopyası döndürülürdü.)
)

$(P
$(C popFront()) işlevinin aralığı başından daraltması, $(C öğrenciler) dizisini başında daraltarak sağlanabilir:
)

---
struct Okul {
    // ...

    void popFront() {
        öğrenciler = öğrenciler[1 .. $];
    }
}
---

$(P
$(I Not: Yukarıda da değindiğim gibi, salt ilerlemiş olmak için aralıktan öğrenci çıkartılıyor olması çoğu duruma uygun değildir. Bu sorunu daha sonra özel bir aralık türü yardımıyla gidereceğiz.)
)

$(P
Bu üç işlev $(C Okul) türünün $(C InputRange) olarak kullanılması için yeterlidir. $(C Okul) nesnelerini artık başka hiçbir şey gerekmeden örneğin $(C yazdır()) şablonuna gönderebiliriz:
)

---
    yazdır(okul);
---

$(P
$(C yazdır()), $(C InputRange) tanımına uyan $(C Okul)'u aralık işlevleri aracılığıyla kullanır. Sonuçta aralığın elemanları teker teker çıkışa yazdırılırlar:
)

$(SHELL
 Ebru(1) Derya(2) Damla(3)
)

$(P
$(IX dilim, InputRange olarak) Böylece kendi yazdığımız bir türü $(C InputRange) tanımına uydurmuş ve $(C InputRange)'lerle işleyen bir işleve gönderebilmiş olduk. $(C Okul), Phobos veya başka kütüphanelerin $(C InputRange) alan algoritmalarıyla da kullanılmaya hazırdır. Bunu biraz aşağıda göreceğiz.
)

$(H6 Dilimleri aralık olarak kullanabilmek için $(C std.array) modülü)

$(P
En sık kullanılan topluluk çeşidi olan dilimler, en işlevsel aralık çeşidi olan $(C RandomAccessRange) olarak kullanılabilirler. Bunun için $(C std.array) modülünün eklenmesi yeterlidir.
)

$(P
$(C std.array) modülü; $(C empty), $(C front), $(C popFront()) ve diğer aralık işlevlerini dilimler için özel olarak tanımlar. Böylece dilimler örneğin $(C yazdır()) işlevine gönderilmeye hazırdırlar:
)

---
import $(HILITE std.array);

// ...

    yazdır([ 1, 2, 3, 4 ]);
---

$(P
$(I Not: Biraz aşağıda göreceğimiz $(C std.range) modülü eklendiğinde $(C std.array)'in ayrıca eklenmesine gerek yoktur.)
)

$(P
Sabit uzunluklu dizilerden eleman çıkartılması mümkün olmadığından $(C popFront()) onlar için tanımlanamaz. Bu yüzden sabit uzunluklu diziler kendileri aralık olarak kullanılamazlar:
)

---
void yazdır(T)(T aralık) {
    for ( ; !aralık.empty; aralık.popFront()) { $(DERLEME_HATASI)
        write(' ', aralık.front);
    }

    writeln();
}

void main() {
    int[$(HILITE 4)] dizi = [ 1, 2, 3, 4 ];
    yazdır(dizi);
}
---

$(P
$(I Not: Derleme hatasının $(C yazdır())'ın çağrıldığı satırda oluşması hatanın kaynağını göstermesi açısından daha yararlı olurdu. Bunun için $(C yazdır())'a bir sonraki bölümde göreceğimiz $(C isInputRange)'den yararlanan bir şablon kısıtlaması eklenebilir.)
)

---
void yazdır(T)(T aralık)
        if (isInputRange!T) {    $(CODE_NOTE şablon kısıtlaması)
    // ...
}
// ...
    yazdır(dizi);    $(DERLEME_HATASI)
---

$(P
Sabit uzunluklu bir dizinin elemanlarına aralık işlevleriyle erişmek yine de mümkündür. Yapılması gereken, dizinin kendisini değil, bütün diziye erişim sağlayan bir dilim kullanmaktır:
)

---
    yazdır(dizi$(HILITE []));    // şimdi derlenir
---

$(P
Her dilimin aralık olarak kullanılabilmesinin aksine, aralıklar dizi olarak kullanılamazlar. Aralık elemanlarından dizi oluşturmak gerektiğinde elemanlar teker teker açıkça kopyalanmalıdır. Bunun için $(C std.array.array) işlevi kullanılabilir. $(C array()), $(C InputRange) aralığını başından sonuna kadar ilerler, her elemanı kopyalar, ve yeni bir dizi döndürür:
)

---
import std.array;

// ...

    // Not: UFCS'ten de yararlanılıyor
    auto öğrencilerinKopyaları = okul.$(HILITE array);
    writeln(öğrencilerinKopyaları);
---

$(P
Çıktısı:
)

$(SHELL
[Ebru(1), Derya(2), Damla(3)]
)

$(P
$(IX string, InputRange olarak) $(IX dchar, dizgi aralığı) Kodda UFCS'ten de yararlanıldığına dikkat edin. UFCS kodun yazımı ile işleyişini birbirine uygun hale getirdiğinden özellikle aralık algoritmalarında çok yararlanılan bir olanaktır.
)

$(H6 Dizgilerin $(C dchar) aralığına dönüşmeleri)

$(P
Tanım gereği olarak zaten $(I karakter dizisi) olan dizgiler de $(C std.array) modülü sayesinde hemen hemen bütün aralık çeşitleri olarak kullanılabilirler. Bunun istisnaları, $(C char) ve $(C wchar) dizgilerinin $(C RandomAccessRange) tanımına giremiyor olmalarıdır.
)

$(P
Ancak, $(C std.array) modülünün dizgilere özel önemli bir yararı daha vardır: Dizgilerde ileri veya geri yönde ilerlendiğinde elemanlara UTF kod birimleri olarak değil, Unicode karakterleri olarak erişilir. Bunun anlamı, ne tür dizgi olursa olsun dizgi elemanlarının $(I harf harf) ilerlenmesidir.
)

$(P
Aşağıdaki dizgilerde $(C char)'a sığmadıklarını bildiğimiz ç ve ğ harflerinden başka $(C wchar)'a sığmayan $(I çift çizgili matematik A harfi) (𝔸) de bulunuyor. Bu ortamda desteklenmiyorsa bir soru işareti olarak görünüyor olabilir:
)

---
import std.array;

// ...

    yazdır("abcçdefgğ𝔸"c);
    yazdır("abcçdefgğ𝔸"w);
    yazdır("abcçdefgğ𝔸"d);
---

$(P
Buna rağmen, programın çıktısı çoğu durumda zaten istemiş olacağımız gibidir:
)

$(XXX 𝔸 harfi doğru çıksın diye SHELL yerine MONO_NOBOLDkullanıyoruz.)
$(MONO_NOBOLD
 a b c ç d e f g ğ 𝔸
 a b c ç d e f g ğ 𝔸
 a b c ç d e f g ğ 𝔸
)

$(P
Bu çıktının $(LINK2 /ders/d/karakterler.html, Karakterler) ve $(LINK2 /ders/d/dizgiler.html, Dizgiler) bölümlerinde gördüğümüz davranışlara uymadığına dikkat edin. Hatırlarsanız, $(C char) ve $(C wchar) dizgilerinin elemanları UTF kod birimleridir.
)

$(P
Yukarıdaki çıktılarda kod birimleri yerine Unicode karakterlerinin belirmesinin nedeni, aralık olarak kullanıldıklarında dizgilerin elemanlarının otomatik olarak Unicode karakterlerine dönüştürülmeleridir. Aşağıda göreceğimiz gibi, Unicode karakteri olarak beliren $(C dchar) değerleri dizgilerin asıl elemanları değil, onlardan oluşturulan $(LINK2 /ders/d/deger_sol_sag.html, $(I sağ değerlerdir)).
)

$(P
Bunu hatırlamak için dizgilerin elemanlarını tek tek indeksleyerek yazdıralım:
)

---
void $(HILITE elemanlarınıYazdır)(T)(T dizgi) {
    for (int i = 0; i != dizgi.length; ++i) {
        write(' ', dizgi$(HILITE [i]));
    }

    writeln();
}

// ...

    elemanlarınıYazdır("abcçdefgğ𝔸"c);
    elemanlarınıYazdır("abcçdefgğ𝔸"w);
    elemanlarınıYazdır("abcçdefgğ𝔸"d);
---

$(P
Doğrudan dizgi elemanlarına erişildiğinde Unicode harflerine değil, UTF kod birimlerine erişilmiş olunur:
)

$(XXX 𝔸 harfi doğru çıksın diye SHELL yerine MONO_NOBOLD kullanıyoruz.)
$(MONO_NOBOLD
 a b c � � d e f g � � � � � �
 a b c ç d e f g ğ ��� ���
 a b c ç d e f g ğ 𝔸
)


$(P
$(IX representation, std.string) Bu otomatik dönüşüm her duruma uygun değildir. Örneğin, bir dizginin ilk elemanına atamaya çalışan aşağıdaki program derlenemez çünkü $(C .front)'un dönüş değeri bir $(LINK2 /ders/d/deger_sol_sag.html, $(I sağ değerdir)):
)

---
import std.array;

void main() {
    char[] s = "merhaba".dup;
    s.front = 'M';                   $(DERLEME_HATASI)
}
---

$(SHELL
Error: front(s) is $(HILITE not an lvalue)
)

$(P
Bir aralık algoritması dizginin asıl elemanlarını değiştirmek istediğinde (ve bu değişikliğin dizginin UTF kodlamasını bozmayacağı bir durumda), $(C std.string.represention) çağrılarak dizgi bir $(C ubyte) aralığı olarak kullanılabilir:
)

---
import std.array;
import std.string;

void main() {
    char[] s = "merhaba".dup;
    s$(HILITE .representation).front = 'M';    // derlenir
    assert(s == "Merhaba");
}
---

$(P
$(C representation); $(C char), $(C wchar), ve $(C dchar) dizgilerinin asıl elemanlarını sırasıyla $(C ubyte), $(C ushort), ve $(C uint) aralıkları olarak sunar.
)

$(H6 Kendi elemanları bulunmayan aralıklar)

$(P
Yukarıda aralık örneği olarak kullandığımız dizilerde ve $(C Okul) nesnelerinde hep gerçek elemanlar bulunuyordu. Örneğin $(C Okul.front), var olan bir $(C Öğrenci) nesnesine referans döndürüyordu.
)

$(P
Aralıkların bir üstünlüğü, bu konuda da esneklik getirmeleridir: $(C front)'un döndürdüğü elemanın bir topluluğun gerçek bir elemanı olması gerekmez. O $(I sözde eleman), örneğin $(C popFront()) her çağrıldığında hesaplanarak oluşturulabilir ve $(C front) her çağrıldığında döndürülebilir.
)

$(P
Gerçek elemanları bulunmayan bir aralık örneğiyle aslında biraz yukarıda da karşılaştık: Dizgiler aralık olarak kullanıldıklarında UTF kod birimlerine değil, Unicode karakterlerine erişildiğini gördük. Oysa; $(C char) ve $(C wchar) Unicode karakteri ifade edemeyeceklerinden, aralık olarak kullandığımızda elde edilen Unicode karakterleri o dizgilerin gerçek elemanları olamazlar. $(C front)'un döndürdüğü karakter, dizgideki UTF kod birimlerinin bir araya getirilmelerinden $(I oluşturulan) bir $(C dchar)'dır:
)

---
import std.array;

void main() {
    dchar harf = "şu".front; // front'un döndürdüğü dchar,
                             // ş'yi oluşturan iki char'ın
                             // bileşimidir
}
---

$(P
Dizginin eleman türü $(C char) olduğu halde yukarıdaki $(C front)'un dönüş türü $(C dchar)'dır. O $(C dchar), dizgi içindeki iki UTF kod biriminden oluşmuştur ama kendisi dizginin elemanı değil, onlardan oluşan bir $(LINK2 /ders/d/deger_sol_sag.html, $(I sağ değerdir)).
)

$(P
Buna benzer olarak, bazı aralıkların ise hiç elemanları yoktur; böyle aralıklar yalnızca başka aralıkların elemanlarına erişim sağlamak için kullanılırlar. Bu, yukarıda $(C Okul) aralığında ilerlerken karşılaştığımız eleman kaybedilmesi sorununu da ortadan kaldırır. Bunun için örneğin $(C Okul) türünün kendisi değil, tek amacı okuldaki öğrencilere erişim sağlamak olan özel bir tür $(C InputRange) olarak tanımlanır.
)

$(P
Daha önce $(C Okul) içinde tanımlamış olduğumuz bütün aralık işlevlerini yeni $(C ÖğrenciAralığı) türüne taşıyalım. Dikkat ederseniz bu değişiklik sonrasında $(C Okul) artık kendisi bir aralık olarak kabul edilemez:
)

---
struct Okul {
    Öğrenci[] öğrenciler;
}

struct ÖğrenciAralığı {
    Öğrenci[] öğrenciler;

    this(Okul okul) {
        $(HILITE this.öğrenciler = okul.öğrenciler);
    }

    @property bool empty() const {
        return öğrenciler.length == 0;
    }

    @property ref Öğrenci front() {
        return öğrenciler[0];
    }

    void popFront() {
        öğrenciler = öğrenciler[1 .. $];
    }
}
---

$(P
Yeni aralık, kendisine verilen $(C Okul)'un öğrencilerini gösteren bir dilim oluşturur ve $(C popFront()) içinde o dilimi tüketir. Bunun sonucunda da asıl dizi değişmemiş olur:
)

---
    auto okul = Okul( [ Öğrenci("Ebru", 1),
                        Öğrenci("Derya", 2) ,
                        Öğrenci("Damla", 3) ] );

    yazdır($(HILITE ÖğrenciAralığı)(okul));

    assert(okul.öğrenciler.length == 3); // asıl dizi değişmez
---

$(P
$(I Not: Bütün işlerini doğrudan üyesi olan dilime yaptırdığı için $(C ÖğrenciAralığı)'nın iyi bir örnek olmadığını düşünebiliriz. Çünkü nasıl olsa $(C Okul.öğrenciler) dizisinin bir dilimini kendimiz de doğrudan kullanabilirdik. Öte yandan, $(C öğrenciler) dizisi $(C Okul)'un özel bir üyesi de olabilirdi ve $(C ÖğrenciAralığı) en azından o özel üyeye erişim sağlamak için yararlı olabilirdi.)
)

$(H6 $(IX sonsuz aralık) Sonsuz aralıklar)

$(P
Kendi elemanları bulunmayan aralıkların başka bir yararı, sonsuz uzunlukta aralıklar oluşturabilmektir.
)

$(P
Bir aralığın hiç sonlanmaması, $(C empty) işlevinin her zaman için $(C false) değerinde olması ile sağlanır. Her zaman için $(C false) değerinde olan $(C empty)'nin işlev olması da gerekmeyeceğinden bir $(C enum) değer olarak tanımlanır:
)

---
    enum empty = false;                   // ← sonsuz aralık
---

$(P
Başka bir seçenek, değişmez bir $(C static) üye kullanmaktır:
)

---
    static immutable bool empty = false;  // üsttekiyle aynı
---

$(P
Bunun bir örneğini görmek için Fibonacci serisini üreten bir aralık düşünelim. Aşağıdaki aralık, yalnızca iki adet $(C int) üyesi bulunmasına rağmen sonsuz uzunluktaki Fibonacci serisi olarak kullanılabilir:
)

---
$(CODE_NAME FibonacciSerisi_InputRange)$(CODE_COMMENT_OUT)struct FibonacciSerisi
$(CODE_COMMENT_OUT){
    int baştaki = 0;
    int sonraki = 1;

    enum empty = false;  // ← sonsuz aralık

    @property int front() const {
        return baştaki;
    }

    void popFront() {
        const ikiSonraki = baştaki + sonraki;
        baştaki = sonraki;
        sonraki = ikiSonraki;
    }
$(CODE_COMMENT_OUT)}
---

$(P
$(I Not: Her ne kadar sonsuz olsa da, sayı türü olarak $(C int) kullandığı için $(C int.max)'tan daha büyük değerlere gelindiğinde $(C FibonacciSerisi) yanlış çalışır.)
)

$(P
$(C FibonacciSerisi) nesneleri için $(C empty)'nin değeri hep $(C false) olduğundan, parametre olarak gönderildiğinde $(C yazdır())'ın içindeki $(C for) döngüsü hiç sonlanmaz:
)

---
    yazdır(FibonacciSerisi());    // hiç sonlanmaz
---

$(P
Sonsuz aralıklar ancak sonuna kadar ilerlemenin gerekmediği durumlarda kullanılabilirler. $(C FibonacciSerisi)'nin yalnızca belirli adet elemanının nasıl kullanılabildiğini aşağıda göreceğiz.
)

$(H6 $(IX aralık döndüren işlev) Aralık döndüren işlevler)

$(P
Bir $(C ÖğrenciAralığı) nesnesini yukarıda açıkça $(C ÖğrenciAralığı(okul)) yazarak oluşturmuş ve kullanmıştık.
)

$(P
Bazı durumlarda ise $(C ÖğrenciAralığı) gibi türleri açıkça yazmak yerine, o türün nesnelerini döndüren işlevlerden yararlanılır. Örneğin bütün işi bir $(C ÖğrenciAralığı) nesnesi döndürmek olan aşağıdaki işlev, kodlamayı kolaylaştırabilir:
)

---
ÖğrenciAralığı öğrencileri(ref Okul okul) {
    return ÖğrenciAralığı(okul);
}

// ...

    // Not: Burada da UFCS'ten yararlanılıyor
    yazdır(okul.$(HILITE öğrencileri));
---

$(P
Böylece kullanıcılar bazı durumlarda çok karmaşık olabilen özel aralık türlerinin isimlerini ve şablon parametrelerini bilmek ve açıkça yazmak yerine, onları döndüren işlevlerin kısa isimlerini hatırlayabilirler.
)

$(P
$(IX take, std.range) Bunun bir örneğini çok basit olan $(C std.range.take) işlevinde görebiliriz. "Al" anlamına gelen $(C take()), kendisine verilen bir aralığın başındaki belirli adet elemana teker teker erişim sağlar. Aslında bu işlem $(C take()) işlevi tarafından değil, onun döndürmüş olduğu özel bir aralık türü tarafından gerçekleştirilir. Yine de biz $(C take())'i kullanırken bunu bilmek zorunda değilizdir:
)

---
import std.range;

// ...

    auto okul = Okul( [ Öğrenci("Ebru", 1),
                        Öğrenci("Derya", 2) ,
                        Öğrenci("Damla", 3) ] );

    yazdır(okul.öğrencileri.$(HILITE take(2)));
---

$(P
Yukarıdaki kullanımda $(C take()), $(C okul) nesnesinin başındaki 2 elemana erişim sağlayacak olan geçici bir aralık nesnesi döndürür. $(C yazdır()) da $(C take())'in döndürmüş olduğu bu geçici aralık nesnesini kullanır:
)

$(SHELL
 Ebru(1) Derya(2)
)

$(P
Yukarıdaki işlemin sonucunda $(C okul) nesnesinde hiçbir değişiklik olmaz; onun hâlâ 3 elemanı vardır:
)

---
    yazdır(okul.öğrencileri.take(2));
    assert(okul.öğrenciler.length == 3);
---

$(P
$(C take()) gibi işlevlerin kendi amaçları için döndürdükleri aralıkların türleri çoğu durumda bizi ilgilendirmez. Onların isimleriyle bazen hata mesajlarında karşılaşabiliriz; veya daha önce de yararlanmış olduğumuz $(C typeof) ve $(C stringof) ile kendimiz de yazdırabiliriz:
)

---
    writeln(typeof(okul.öğrencileri.take(2)).stringof);
---

$(P
Çıktısı, $(C take())'in döndürdüğü türün $(C Take) isminde bir şablon olduğunu gösteriyor:
)

$(SHELL
Take!(ÖğrenciAralığı)
)

$(H6 $(IX std.range) $(IX std.algorithm) $(C std.range) ve $(C std.algorithm) modülleri)

$(P
Kendi türlerimizi aralık olarak tanımlamanın çok büyük bir yararı; onları yalnızca kendi işlevlerimizle değil, Phobos ve başka kütüphanelerin aralık algoritmalarıyla da kullanabilmemizdir.
)

$(P
$(C std.range) modülünde özellikle aralıklarla ilgili olan çok sayıda olanak bulunur. $(C std.algorithm) modülü ise başka dillerin kütüphanelerinde de bulunan çok sayıda tanınmış algoritma içerir.
)

$(P
$(IX swapFront, std.algorithm) Bir örnek olarak $(C std.algorithm.swapFront) algoritmasını $(C Okul) türü ile kullanalım. "Öndekini değiş tokuş et" anlamına gelen $(C swapFront), kendisine verilen iki $(C InputRange) aralığının ilk elemanlarını değiş tokuş eder.
)

$(P

)

---
import std.algorithm;

// ...

    auto türkOkulu = Okul( [ Öğrenci("Ebru", 1),
                             Öğrenci("Derya", 2) ,
                             Öğrenci("Damla", 3) ] );

    auto amerikanOkulu = Okul( [ Öğrenci("Mary", 10),
                                 Öğrenci("Jane", 20) ] );

    $(HILITE swapFront)(türkOkulu.öğrencileri,
              amerikanOkulu.öğrencileri);

    yazdır(türkOkulu.öğrencileri);
    yazdır(amerikanOkulu.öğrencileri);
---

$(P
İki okuldaki ilk öğrenciler değişmiştir:
)

$(SHELL
 $(HILITE Mary(10)) Derya(2) Damla(3)
 $(HILITE Ebru(1)) Jane(20)
)

$(P
$(IX filter, std.algorithm) Başka bir örnek olarak $(C std.algorithm.filter) algoritmasına bakalım. $(C filter()), elemanların belirli bir kıstasa uymayanlarını elemekle görevli olan özel bir aralık döndürür. Bu işlem sırasında asıl aralıkta hiçbir değişiklik olmaz.
)

$(P
$(IX kıstas) $(C filter())'a verilen kıstas çok genel olarak $(I uyanlar için $(C true), uymayanlar için $(C false)) üreten bir ifadedir. $(C filter())'a şablon parametresi olarak verilen kıstası bildirmenin bir kaç yolu vardır. Bir yol, daha önce de karşılaştığımız gibi isimsiz bir işlev kullanmaktır. Kısa olması için $(C ö) olarak adlandırdığım parametre aralıktaki her öğrenciyi temsil eder:
)

---
    okul.öğrencileri.filter!(ö => ö.numara % 2)
---

$(P
Yukarıdaki ifadedeki kıstas, $(C okul.öğrencileri) aralığındaki elemanların numarası tek olanlarını seçer.
)

$(P
$(C take()) işlevinde olduğu gibi, $(C filter()) da özel bir aralık nesnesi döndürür. Böylece, döndürülen aralık nesnesini de doğrudan başka işlevlere gönderebiliriz. Örneğin, seçilmiş olan elemanları üretecek olan aralık nesnesi $(C yazdır())'a gönderilebilir:
)

---
    yazdır(okul.öğrencileri.filter!(ö => ö.numara % 2));
---

$(P
O kodu sağdan sola doğru okuyarak şöyle açıklayabiliriz: $(I $(C okul.öğrencileri) aralığındaki elemanların tek numaralı olanlarını seçen bir aralık oluştur ve $(C yazdır()) işlevine gönder).
)

$(P
Çıktısı yalnızca tek numaralı öğrencilerden oluşur:
)

$(SHELL
 Ebru(1) Damla(3)
)

$(P
Seçilecek olan elemanlar için $(C true) üretmesi koşuluyla, kıstas $(C filter())'a bir işlev olarak da bildirilebilir:
)

---
import std.array;

// ...

    bool başHarfiD_mi(Öğrenci öğrenci) {
        return öğrenci.isim.front == 'D';
    }

    yazdır(okul.öğrencileri.filter!başHarfiD_mi);
---

$(P
Yukarıdaki örnekteki kıstas işlevi, aldığı $(C Öğrenci) nesnesinin baş harfi D olanları için $(C true), diğerleri için $(C false) döndürmektedir.
)

$(P
$(I Not: O ifadede baş harf için $(C öğrenci.isim[0]) yazmadığıma dikkat edin. Öyle yazsaydım baş harfini değil, ilk UTF-8 kod birimini elde ederdim. Yukarıda da belirttiğim gibi; $(C front), $(C isim)'i bir aralık olarak kullanır ve her zaman için ilk Unicode karakterini, yani ilk harfini döndürür.)
)

$(P
O kodun sonucunda da baş harfi D olan öğrenciler seçilir ve yazdırılır:
)

$(SHELL
 Derya(2) Damla(3)
)

$(P
$(IX generate, std.range) $(C std.range) modülündeki $(C generate), bir işlevin döndürdüğü değerlerin bir $(C InputRange)'in elemanlarıymış gibi kullanılmalarını sağlar. İşlev gibi çağrılabilen herhangi bir değişken (işlev göstergesi, isimsiz işlev, vs.) alır ve kavramsal olarak o işlevin döndürdüğü değerlerden oluşan bir $(C InputRange) nesnesi döndürür.
)

$(P
Döndürülen aralık nesnesi sonsuzdur. Bu nesnenin $(C front) niteliğine her erişildiğinde asıl işlev işletilir ve onun döndürdüğü değer, aralığın $(I elemanı) olarak sunulur. Bu nesnenin $(C popFront) işlevi ise hiç iş yapmaz.
)

$(P
Örneğin, aşağıdaki $(C zarAtıcı) nesnesi sonsuz bir aralık olarak kullanılabilmektedir:
)

---
import std.stdio;
import std.range;
import std.random;

void main() {
    auto zarAtıcı = $(HILITE generate)!(() => uniform(0, 6));
    writeln(zarAtıcı.take(10));
}
---

$(SHELL
[1, 0, 3, 5, 5, 1, 5, 1, 0, 4]
)

$(H6 $(IX tembel aralık) Tembellik)

$(P
Aralık döndüren işlevlerin başka bir yararı, o aralıkların tembel olarak kullanılabilmeleridir. Bu hem program hızı ve bellek kullanımı açısından çok yararlıdır, hem de sonsuz aralıkların var olabilmeleri zaten bütünüyle tembellik olanağı sayesindedir.
)

$(P
Tembel aralıklar işlerini gerektikçe ve parça parça gerçekleştirirler. Bunun bir örneğini $(C FibonacciSerisi) aralığında görüyoruz: Elemanlar ancak gerektikçe $(C popFront()) işlevinde teker teker hesaplanırlar. $(C FibonacciSerisi) eğer tembel yerine hevesli bir aralık olsaydı, yani kullanılmadan önce bütün aralığı üretmeye çalışsaydı, sonsuza kadar işlemeye devam ederdi. Ürettiği elemanları saklaması da gerekeceği için sonsuz sayıdaki elemana da yer bulamazdı.
)

$(P
Hevesli aralıkların başka bir sakıncası, sonlu sayıda bile olsalar belki de hiç kullanılmayacak olan elemanlar için bile gereksizce yer harcayacak olmalarıdır.
)

$(P
Phobos'taki çoğu algoritma gibi $(C take()) ve $(C filter()) da tembellikten yararlanırlar. Örneğin $(C FibonacciSerisi)'ni $(C take())'e vererek bu sonsuz aralığın belirli sayıdaki elemanını kullanabiliriz:
)

---
    yazdır(FibonacciSerisi().take(10));
---

$(P
Çıktısı yalnızca ilk 10 sayıyı içerir:
)

$(SHELL
 0 1 1 2 3 5 8 13 21 34
)

$(H5 $(IX ForwardRange) $(IX ilerleme aralığı) $(C ForwardRange), $(I ilerleme aralığı))

$(P
$(C InputRange), elemanları çıkartıldıkça tükenen aralık kavramını ifade ediyordu.
)

$(P
Bazı aralıklar ise $(C InputRange) gibi işleyebilmelerinin yanında, aralığın belirli bir durumunu hatırlama yeteneğine de sahiptirler. $(C FibonacciSerisi) nesneleri bunu sağlayabilirler, çünkü $(C FibonacciSerisi) nesneleri serbestçe kopyalanabilirler ve bu kopyalar birbirlerinden bağımsız aralıklar olarak yaşamlarına devam edebilirler.
)

$(P
$(IX save) $(C ForwardRange) aralıkları, aralığın belirli bir andaki kopyasını döndüren $(C save) işlevini de sunan aralıklardır. $(C save)'in döndürdüğü kopyanın asıl aralıktan bağımsız olarak kullanılabilmesi şarttır. Örneğin bir kopya üzerinde ilerlemek diğer kopyayı ilerletmemelidir.
)

$(P
$(C std.array) modülünün eklenmiş olması dilimleri de otomatik olarak $(C ForwardRange) tanımına sokar.
)

$(P
$(C save) işlevini $(C FibonacciSerisi) için gerçekleştirmek istediğimizde nesnenin bir kopyasını döndürmek yeterlidir:
)

---
$(CODE_NAME FibonacciSerisi)struct FibonacciSerisi {
// ...

    @property FibonacciSerisi save() const {
        return this;
    }
$(CODE_XREF FibonacciSerisi_InputRange)}
---

$(P
Döndürülen kopya, bu nesnenin kopyalandığı yerden devam edecek olan bağımsız bir aralıktır.
)

$(P
$(IX popFrontN, std.range) $(C save)'in döndürdüğü nesnenin asıl aralıktan bağımsız olduğunu aşağıdaki gibi bir program yardımıyla görebiliriz. Programda yararlandığım $(C std.range.popFrontN()), kendisine verilen aralığın başından belirtilen sayıda eleman çıkartır. $(C bilgiVer()) işlevi de çıkışı kısa tutmak için  yalnızca ilk beş elemanı gösteriyor:
)

---
$(CODE_XREF FibonacciSerisi)import std.range;

// ...

void bilgiVer(T)(const dchar[] başlık, const ref T aralık) {
    writefln("%40s: %s", başlık, aralık.take(5));
}

void main() {
    auto aralık = FibonacciSerisi();
    bilgiVer("Başlangıçtaki aralık", aralık);

    aralık.popFrontN(2);
    bilgiVer("İki eleman çıkartıldıktan sonra", aralık);

    auto kopyası = $(HILITE aralık.save);
    bilgiVer("Kopyası", kopyası);

    aralık.popFrontN(3);
    bilgiVer("Üç eleman daha çıkartıldıktan sonra", aralık);
    bilgiVer("Kopyası", kopyası);
}
---

$(P
O kodun çıktısı, $(C aralıktan)'tan eleman çıkartılmış olmasının $(C kopyası)'nı etkilemediğini gösterir.:
)

$(SHELL
                    Başlangıçtaki aralık: [0, 1, 1, 2, 3]
         İki eleman çıkartıldıktan sonra: [1, 2, 3, 5, 8]
                                 $(HILITE Kopyası: [1, 2, 3, 5, 8])
     Üç eleman daha çıkartıldıktan sonra: [5, 8, 13, 21, 34]
                                 $(HILITE Kopyası: [1, 2, 3, 5, 8])
)

$(P
$(C bilgiVer()) içinde aralıkları doğrudan $(C writefln)'e gönderdiğime ayrıca dikkat edin. Kendi yazdığımız $(C yazdır()) işlevinde olduğu gibi, $(C stdio) modülünün çıkış işlevleri de $(C InputRange) aralıklarını kullanabilirler. Bundan sonraki örneklerde $(C yazdır()) yerine $(C stdio)'nun çıkış işlevlerini kullanacağım.
)

$(P
$(IX cycle, std.range) $(C ForwardRange) aralıklarıyla işleyen bir algoritma örneği olarak $(C std.range.cycle)'a bakabiliriz. $(C cycle()), kendisine verilen aralığı sürekli olarak tekrarlar. Başından tekrarlayabilmesi için aralığın ilk durumunu saklaması gerekeceğinden, bu aralığın bir $(C ForwardRange) olması şarttır.
)

$(P
Artık bir $(C ForwardRange) de kabul edilen $(C FibonacciSerisi) nesnelerini $(C cycle()) işlevine gönderebiliriz:
)

---
    writeln(FibonacciSerisi().take(5).cycle.take(20));
---

$(P
Hem $(C cycle())'a verilen aralığın hem de $(C cycle())'ın döndürdüğü aralığın sonlu olmaları için iki noktada $(C take())'ten yararlanıldığına dikkat edin. Çıktısı, $(I $(C FibonacciSerisi) aralığının ilk beş elemanının tekrarlanmasından oluşan aralığın ilk yirmi elemanıdır):
)

$(SHELL
[0, 1, 1, 2, 3, 0, 1, 1, 2, 3, 0, 1, 1, 2, 3, 0, 1, 1, 2, 3]
)

$(P
Kodun anlaşılmasını kolaylaştırmak için ara değişkenler de tanımlanabilir. Yukarıdaki tek satırlık kodun bir eşdeğeri şudur:
)

---
    auto seri                      = FibonacciSerisi();
    auto başTarafı                 = seri.take(5);
    auto tekrarlanmışı             = başTarafı.cycle;
    auto tekrarlanmışınınBaşTarafı = tekrarlanmışı.take(20);

    writeln(tekrarlanmışınınBaşTarafı);
---

$(P
Tembelliğin yararını burada bir kere daha hatırlatmak istiyorum: İlk dört satırda yalnızca asıl işlemleri gerçekleştirecek olan geçici aralık nesneleri oluşturulur. Bütün ifadenin üretmiş olduğu sayılar, $(C FibonacciSerisi.popFront()) işlevi içinde ve ancak gerektikçe hesaplanırlar.
)

$(P
$(I Not: $(C ForwardRange) olarak $(C FibonacciSerisi) türünü kullanacağımızı söylediğimiz halde $(C cycle())'a $(C FibonacciSerisi.take(5)) ifadesini verdik. $(C take())'in döndürdüğü aralığın türü parametresine uyar: parametre olarak $(C ForwardRange) verildiğinde döndürdüğü aralık da $(C ForwardRange) türündedir. Bunu sağlayan $(C isForwardRange) olanağını bir sonraki bölümde göstereceğim.)
)

$(H5 $(IX BidirectionalRange) $(IX çift uçlu aralık) $(C BidirectionalRange), $(I çift uçlu aralık))

$(P
$(IX back) $(IX popBack) $(C BidirectionalRange) aralıkları, $(C ForwardRange) işlevlerine ek olarak iki işlev daha sunarlar. $(C back), $(C front)'un benzeri olarak aralığın sonundaki elemanı döndürür. $(C popBack()) de $(C popFront())'un benzeri olarak aralığı sonundan daraltır.
)

$(P
$(C std.array) modülü eklendiğinde dilimler $(C BidirectionalRange) tanımına da girerler.
)

$(P
$(IX retro, std.range) Örnek olarak $(C BidirectionalRange) aralığı gerektiren $(C std.range.retro) işlevini göstermek istiyorum. $(C retro()), kendisine verilen aralığın $(C front)'unu $(C back)'ine, $(C popFront())'unu da $(C popBack())'ine bağlayarak aralıktaki elemanlara ters sırada erişilmesini sağlar:
)

---
    writeln([ 1, 2, 3 ].retro);
---

$(P
Çıktısı:
)

$(SHELL
[3, 2, 1]
)

$(P
$(C retro())'nun döndürdüğü özel aralığın bir benzerini çok basit olarak aşağıdaki gibi tanımlayabiliriz. Yalnızca $(C int) dizileriyle işlediği için çok kısıtlı olsa da aralıkların gücünü göstermeye yetiyor:
)

---
import std.array;
import std.stdio;

struct TersSırada {
    int[] aralık;

    this(int[] aralık) {
        this.aralık = aralık;
    }

    @property bool empty() const {
        return aralık.empty;
    }

    @property int $(HILITE front)() const {
        return aralık.$(HILITE back);  // ← ters
    }

    @property int back() const {
        return aralık.front; // ← ters
    }

    void popFront() {
        aralık.popBack();    // ← ters
    }

    void popBack() {
        aralık.popFront();   // ← ters
    }
}

void main() {
    writeln(TersSırada([ 1, 2, 3]));
}
---

$(P
Aralığı $(I ters sırada) kullandığı için $(C retro()) ile aynı sonuç elde edilir:
)

$(SHELL
[3, 2, 1]
)

$(H5 $(IX RandomAccessRange) $(IX rastgele erişimli aralık) $(C RandomAccessRange), $(I rastgele erişimli aralık))

$(P
$(IX opIndex) $(C RandomAccessRange), belirli sıradaki elemanlarına $(C []) işleci ile erişilebilen aralıkları ifade eder. $(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme bölümünden) hatırlayacağınız gibi, $(C []) işleci $(C opIndex()) üye işlevi ile tanımlanır.
)

$(P
$(C std.array) modülü genel olarak dilimleri de $(C RandomAccessRange) tanımına sokar. Ancak; UTF-8 ve UFT-16 kodlamaları harflere sıra numarasıyla erişimi desteklemedikleri için, $(C char) ve $(C wchar) dizgileri harf erişimi açısından $(C RandomAccessRange) aralığı olarak kullanılamazlar. Öte yandan, UTF-32 kodlamasında kodlarla harfler bire bir karşılık geldiklerinden, $(C dchar) dizgileri harf erişiminde $(C RandomAccessRange) olarak kullanılabilirler.
)

$(P
$(IX sabit zamanda erişim) Her türün $(C opIndex()) işlevini kendisine en uygun biçimde tanımlayacağı doğaldır. Ancak, bilgisayar biliminin algoritma karmaşıklıkları ile ilgili olarak bu konuda bir beklentisi vardır: Rastgele erişim, $(I sabit zamanda) gerçekleşmelidir. Sabit zamanda erişim, erişim için gereken işlemlerin aralıktaki eleman adedinden bağımsız olması anlamına gelir. Aralıkta ne kadar eleman olursa olsun, hiçbirisinin erişimi aralığın uzunluğuna bağlı olmamalıdır.
)

$(P
$(C RandomAccessRange) tanımına girebilmek için ek olarak aşağıdaki koşullardan $(I birisinin) daha sağlanmış olması gerekir:
)

$(UL
$(LI sonsuz bir $(C ForwardRange) olmak)
)

$(P
veya
)

$(UL
$(LI $(IX length, BidirectionalRange) $(C length) niteliğini de sunan bir $(C BidirectionalRange) olmak)
)

$(H6 Sonsuz $(C RandomAccessRange))

$(P
Önce $(I sonsuz $(C ForwardRange)) tanımı üzerine kurulu olan bir $(C RandomAccessRange) örneğine bakalım. Bu tanıma girebilmek için gereken işlevler şunlardır:
)

$(UL
$(LI $(C InputRange)'in gerektirdiği $(C empty), $(C front) ve $(C popFront()))
$(LI $(C ForwardRange)'in gerektirdiği $(C save))
$(LI $(C RandomAccessRange)'in gerektirdiği $(C opIndex()))
$(LI sonsuz olabilmek için $(C empty)'nin değerinin derleme zamanında $(C false) olarak belirlenmiş olması)
)

$(P
$(C FibonacciSerisi)'nin en son tanımı onu bir $(C ForwardRange) yapmaya yetiyordu. Ancak, $(C opIndex()) işlevi $(C FibonacciSerisi) için sabit zamanda işleyecek şekilde gerçekleştirilemez; çünkü belirli bir elemana erişebilmek için o elemandan önceki elemanların da hesaplanmaları gerekir. Bunun anlamı; N'inci sıradaki elemanın hesaplanması için ondan önceki N-1 elemanın hesaplanması gerektiği, bu yüzden de işlem adedinin N'ye bağlı olduğudur.
)

$(P
$(C opIndex()) işlevinin sabit zamanda işletilebildiği bir örnek olarak tamsayıların karelerinden oluşan sonsuz bir aralık tanımlayalım. Böyle bir aralık sonsuz olduğu halde bütün elemanlarının değerlerine sabit zamanda erişilebilir:
)

---
class KareAralığı {
    int baştaki;

    this(int baştaki = 0) {
        this.baştaki = baştaki;
    }

    enum empty = false;

    @property int front() const {
        return opIndex(0);
    }

    void popFront() {
        ++baştaki;
    }

    @property KareAralığı save() const {
        return new KareAralığı(baştaki);
    }

    int opIndex(size_t sıraNumarası) const {
        /* Bu işlev sabit zamanda işler */
        immutable tamsayıDeğeri = baştaki + cast(int)sıraNumarası;
        return tamsayıDeğeri * tamsayıDeğeri;
    }
}
---

$(P
$(I Not: $(C KareAralığı)'nın bir $(C struct) olarak tanımlanması daha uygun olurdu.)
)

$(P
Hiçbir eleman için yer ayrılmadığı halde bu aralığın bütün elemanlarına $(C []) işleci ile erişilebilir:
)

---
    auto kareler = new KareAralığı();

    writeln(kareler$(HILITE [5]));
    writeln(kareler$(HILITE [10]));
---

$(P
Çıktısı 5 ve 10 sıra numaralı elemanları içerir:
)

$(SHELL
25
100
)

$(P
Sıfırıncı eleman her zaman için aralığın ilk elemanını temsil etmelidir. Bunu denemek için yine $(C popFrontN())'den yararlanabiliriz:
)

---
    kareler.popFrontN(5);
    writeln(kareler$(HILITE [0]));
---

$(P
Aralığın ilk 5 elemanı sırasıyla 0, 1, 2, 3 ve 4'ün kareleri olan 0, 1, 4, 9 ve 16'dır. Onlar çıkartıldıktan sonraki ilk eleman artık bir sonraki sayının karesi olan 25'tir:
)

$(SHELL
25
)

$(P
$(C KareAralığı) en işlevsel aralık olan $(C RandomAccessRange) olarak tanımlandığı için diğer aralık çeşitleri olarak da kullanılabilir. Örneğin $(C InputRange) olarak:
)

---
    bool sonİkiHaneAynı_mı(int sayı) {
        /* Doğru olabilmesi için en az iki rakamı bulunmalı */
        if (sayı < 10) {
            return false;
        }

        /* Son iki hanesi 11'e tam olarak bölünmeli */
        immutable sonİkiHane = sayı % 100;
        return (sonİkiHane % 11) == 0;
    }

    writeln(kareler.take(50).filter!sonİkiHaneAynı_mı);
---

$(P
Çıktısı, ilk 50 elemanın son iki hanesi aynı olanlarını içerir:
)

$(SHELL
[100, 144, 400, 900, 1444, 1600]
)

$(H6 Sonlu $(C RandomAccessRange))

$(P
Şimdi de $(I sonlu uzunluklu $(C BidirectionalRange)) tanımı üzerine kurulu olan bir $(C RandomAccessRange) örneğine bakalım. Bu çeşit bir aralık olarak kabul edilmek için gereken işlevler şunlardır:
)

$(UL
$(LI $(C InputRange)'in gerektirdiği $(C empty), $(C front) ve $(C popFront()))
$(LI $(C ForwardRange)'in gerektirdiği $(C save))
$(LI $(C BidirectionalRange)'in gerektirdiği $(C back) ve $(C popBack()))
$(LI $(C RandomAccessRange)'in gerektirdiği $(C opIndex()))
$(LI aralığın uzunluğunu bildiren $(C length))
)

$(P
$(IX chain, std.range) Bu örnekte, kendisine verilen bütün aralıklardaki bütün elemanları sanki tek bir aralığın elemanlarıymış gibi sunan $(C std.range.chain)'in bir benzerini tasarlayalım. $(C chain()) her tür elemanla ve farklı aralıklarla işleyebilir. Bu örneği kısa tutabilmek için biz yalnızca $(C int) dizileriyle işleyecek şekilde tanımlayacağız.
)

$(P
Önce adına $(C BirArada) diyeceğimiz bu türün nasıl kullanılacağını göstermek istiyorum:
)

---
    auto aralık = BirArada([ 1, 2, 3 ],
                           [ 101, 102, 103]);
    writeln(aralık[4]);
---

$(P
İki farklı diziyle ilklenen $(C aralık), $(C [ 1, 2, 3, 101, 102, 103 ]) elemanlarından oluşan tek bir diziymiş gibi kullanılacak. Örneğin dizilerin ikisinde de 4 numaralı eleman bulunmadığı halde diziler art arda düşünüldüklerinde 102, 4 numaralı eleman olarak kabul edilecek:
)

$(SHELL
102
)

$(P
Bütün aralık nesnesi yazdırıldığında da elemanlar tek bir dizi gibi görünecekler:
)

---
    writeln(aralık);
---

$(P
Çıktısı:
)

$(SHELL
[1, 2, 3, 101, 102, 103]
)

$(P
$(C BirArada) türünün bir yararı, bu işlemler gerçekleştirilirken elemanların yeni bir diziye kopyalanmayacak olmalarıdır. Bütün elemanlar kendi dizilerinde durmaya devam edecekler.
)

$(P
Belirsiz sayıda dilim ile ilklenecek olan bu aralık, $(LINK2 /ders/d/parametre_serbestligi.html, Parametre Serbestliği bölümünde) gördüğümüz $(I belirsiz sayıda parametre) olanağından yararlanabilir:
)

---
struct BirArada {
    const(int)[][] aralıklar;

    this(const(int)[][] aralıklar$(HILITE ...)) {
        this.aralıklar = aralıklar.dup;

        başıTemizle();
        sonuTemizle();
    }

// ...
}
---

$(P
Bu yapının elemanlarda değişiklik yapmayacağının bir göstergesi olarak eleman türünün $(C const(int)) olarak tanımlandığına dikkat edin. Öte yandan, ilerleme kavramını sağlayabilmek için dilimlerin kendileri $(C popFront()) tarafından değiştirilmek zorundadır.
)

$(P
Kurucu içinde çağrıldığını gördüğümüz $(C başıTemizle()) ve $(C sonuTemizle()) işlevleri, aralıkların baştaki ve sondaki boş olanlarını çıkartmak için kullanılıyorlar. Aralığa zaten bir katkıları bulunmayan boş aralıkların işlemleri karmaşıklaştırmaları böylece önlenmiş olacak:
)

---
struct BirArada {
// ...

    private void başıTemizle() {
        while (!aralıklar.empty && aralıklar.front.empty) {
            aralıklar.popFront();
        }
    }

    private void sonuTemizle() {
        while (!aralıklar.empty && aralıklar.back.empty) {
            aralıklar.popBack();
        }
    }
}
---

$(P
O işlevleri daha sonra $(C popFront()) ve $(C popBack()) içinden de çağıracağız.
)

$(P
$(C başıTemizle()) ve $(C sonuTemizle()) işlevlerinin başta ve sonda boş aralık bırakmayacaklarını bildiğimizden, tek bir alt aralığın bile kalmış olması bütün aralığın henüz tükenmediği anlamına gelir:
)

---
struct BirArada {
// ...

    @property bool empty() const {
        return aralıklar.empty;
    }
}
---

$(P
İlk alt aralığın ilk elemanı bu aralığın da ilk elemanıdır:
)

---
struct BirArada {
// ...

    @property int front() const {
        return aralıklar.front.front;
    }
}
---

$(P
İlk aralığın ilk elemanını çıkartmak, bu aralığın ilk elemanını çıkartmış olur. Bu işlem sonucunda ilk aralık boşalmış olabileceğinden, gerektiğinde o aralığın ve onu izleyen olası boş aralıkların da çıkartılmaları için $(C başıTemizle()) işlevinin çağrılması gerekir:
)

---
struct BirArada {
// ...

    void popFront() {
        aralıklar.front.popFront();
        başıTemizle();
    }
}
---

$(P
Aralığın belirli bir durumunun kopyası, elimizde bulunan alt aralıklarla ilklenen yeni bir $(C BirArada) nesnesi döndürerek sağlanabilir:
)

---
struct BirArada {
// ...

    @property BirArada save() const {
        return BirArada(aralıklar.dup);
    }
}
---

$(P
Aralığın son tarafındaki işlemler baş tarafındakilerin benzerleridir:
)

---
struct BirArada {
// ...

    @property int back() const {
        return aralıklar.back.back;
    }

    void popBack() {
        aralıklar.back.popBack();
        sonuTemizle();
    }
}
---

$(P
Bütün aralığın uzunluğu, alt aralıkların uzunluklarının toplamı olarak hesaplanabilir:
)

---
struct BirArada {
// ...

    @property size_t length() const {
        size_t uzunluk = 0;

        foreach (aralık; aralıklar) {
            uzunluk += aralık.length;
        }

        return uzunluk;
    }
}
---

$(P
$(IX fold, std.algorithm) Aynı işlem $(C std.algorithm.fold) işlevi ile daha kısa olarak da gerçekleştirilebilir. $(C fold()), şablon parametresi olarak aldığı işlemi kendisine verilen aralıktaki bütün elemanlara uygular.
)

---
import std.algorithm;

// ...

    @property size_t length() const {
        return aralıklar.fold!((a, b) => a + b.length)(size_t.init);
    }
---

$(P
Şablon parametresindeki $(C a) şimdiye kadarki toplamı, $(C b) de aralıktaki her bir elemanı temsil eder. İlk işlev parametresi hesabın hangi aralıktaki elemanlara uygulanacağını, ikinci işlev parametresi de toplamın ilk değerini (burada 0) belirler. ($(C aralıklar)'ın $(LINK2 /ders/d/ufcs.html, UFCS'ten) yararlanılarak $(C fold)'dan önce yazıldığına dikkat edin.)
)

$(P
$(I Not: $(C length) her çağrıldığında uzunluğun böyle baştan hesaplanması yerine $(C uzunluk) isminde bir üyeden de yararlanılabilir. Bu üyenin değeri kurucu işlev içinde bir kere baştan hesaplanabilir, ve ondan sonra $(C popFront()) ve $(C popBack()) işlevleri her çağrıldıklarında teker teker azaltılabilir.)
)

$(P
Belirli bir sıra numarasındaki elemanın döndürülebilmesi için bütün alt aralıklara baştan sona doğru bakılması ve sıra numarasının hangi aralıktaki bir elemana denk geldiğinin bulunması gerekir:
)

---
struct BirArada {
// ...

    int opIndex(size_t sıraNumarası) const {
        /* Hata mesajı için saklıyoruz */
        immutable baştakiSıraNumarası = sıraNumarası;

        foreach (aralık; aralıklar) {
            if (aralık.length > sıraNumarası) {
                return aralık[sıraNumarası];

            } else {
                sıraNumarası -= aralık.length;
            }
        }

        throw new Exception(
            format("Geçersiz sıra numarası: %s (uzunluk: %s)",
                   baştakiSıraNumarası, this.length));
    }
}
---

$(P
$(I Not: $(C opIndex), yukarıdaki uyarının aksine sabit zamanda gerçekleşemez. Bu aralığın kabul edilir derecede hızlı işleyebilmesi için $(C aralıklar) üyesinin fazla uzun olmaması gerekir.)
)

$(P
Tanımladığımız bu aralık, istediğimiz sayıda $(C int) dizisiyle kullanılmaya hazırdır. Kendisine vereceğimiz dizileri $(C take()) ve $(C array()) işlevleri yardımıyla bu bölümde tanımladığımız türlerden bile edinebiliriz:
)

---
    auto aralık = BirArada(FibonacciSerisi().take(10).array,
                           [ 777, 888 ],
                           (new KareAralığı()).take(5).array);

    writeln(aralık.save);
---

$(P
Çıktısı, üç aralığın tek aralıkmış gibi kullanılabildiğini gösterir:
)

$(SHELL
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 777, 888, 0, 1, 4, 9, 16]
)

$(P
Bu aralığı başka çeşit aralık kullanan algoritmalara da gönderebiliriz. Örneğin $(C BidirectionalRange) gerektiren $(C retro())'ya:
)

---
    writeln(aralık.save.retro);
---

$(SHELL
[16, 9, 4, 1, 0, 888, 777, 34, 21, 13, 8, 5, 3, 2, 1, 1, 0]
)

$(P
$(C BirArada)'yı bu bölümde öğrendiklerimizin bir uygulaması olarak tasarladık. Programlarınızda daha kapsamlı olan $(C std.range.chain)'i kullanmanızı öneririm.
)

$(H5 $(IX OutputRange) $(IX çıkış aralığı) $(C OutputRange), $(I çıkış aralığı))

$(P
Şimdiye kadar gördüğümüz aralıklar hep elemanlara erişimle ilgili olan aralıklardır. $(C OutputRange) ise çıkış aralığıdır. $(C stdout)'ta olduğu gibi elemanların belirli bir hedefe yazıldıkları akımları temsil ederler.
)

$(P
$(IX put) $(C OutputRange) aralıklarının gerektirdiği işlemi yukarıda kısaca $(C put(aralık, eleman)) olarak belirtmiştim. $(C put()), $(C std.range) modülünde tanımlanmış olan bir işlevdir; çıkış aralığının hangi olanaklara sahip olduğunu $(C static if) yardımıyla derleme zamanında belirler ve $(I elemanı aralığa gönderirken) elemana ve aralığa en uygun olan yöntemi kullanır.
)

$(P
$(C put())'un sırayla denediği durumlar ve seçtiği yöntemler aşağıdaki tablodaki gibidir. Tablodaki durumlara yukarıdan aşağıya doğru bakılır ve uygun olan ilk durum seçilir. Tabloda $(C A), aralığın türünü; $(C aralık), bir aralık nesnesini; $(C E), eleman türünü; ve $(C e) de bir eleman nesnesini temsil ediyor:
)

$(TABLE full,
$(HEAD2 Olası Durum, Seçilen Yöntem)
$(ROW2
$(C A) türünün parametre olarak $(C E) alan$(BR)
$(C put) isminde bir üye işlevi varsa,

$(C aralık.put(e);)

)
$(ROW2
$(C A) türünün parametre olarak $(C E[]) alan$(BR)
$(C put) isminde bir üye işlevi varsa,

$(C aralık.put([ e ]);)

)
$(ROW2
$(C A) bir $(C InputRange) aralığıysa$(BR)
ve $(C e)&#44; $(C aralık.front)'a atanabiliyorsa,

$(C aralık.front = e;)
$(BR)
$(C aralık.popFront();)

)
$(ROW2
$(C E) bir $(C InputRange) aralığıysa$(BR)
ve $(C A) aralığına kopyalanabiliyorsa,

$(C for (; !e.empty; e.popFront()))
$(BR)
$(C put(aralık, e.front);)

)
$(ROW2
$(C A)&#44; parametre olarak $(C E) alabiliyorsa$(BR)
($(C A) örneğin bir $(C delegate) olabilir),

$(C aralık(e);)

)
$(ROW2
$(C A)&#44; parametre olarak $(C E[]) alabiliyorsa$(BR)
($(C A) örneğin bir $(C delegate) olabilir),

$(C aralık([ e ]);)

)
)

$(P
Ben bu kullanımlardan birincisinin bir örneğini göstereceğim: Tanımlayacağımız aralık türünün $(C put) isminde bir işlevi olacak ve bu işlev çıkış aralığının eleman türünü parametre olarak alacak.
)

$(P
Tanımlayacağımız çıkış aralığı, kurulurken belirsiz sayıda dosya ismi alsın. Daha sonradan $(C put()) işlevi ile yazdırılan elemanları hem bu dosyaların hepsine, hem de $(C stdout)'a yazdırsın. Ek olarak, her elemandan sonra yine kurucusunda aldığı ayracı yazdırsın.
)

---
$(CODE_NAME ÇokHedefeYazan)struct ÇokHedefeYazan {
    string ayraç;
    File[] dosyalar;

    this(string ayraç, string[] dosyaİsimleri...) {
        this.ayraç = ayraç;

        /* stdout her zaman dahil */
        this.dosyalar ~= stdout;

        /* Belirtilen her dosya ismi için yeni bir dosya  */
        foreach (dosyaİsmi; dosyaİsimleri) {
            this.dosyalar ~= File(dosyaİsmi, "w");
        }
    }

    /* Dilimlerle kullanılan put() (dizgiler hariç) */
    void put(T)(T dilim)
            if (isArray!T && !isSomeString!T) {
        foreach (eleman; dilim) {
            // Bu, aşağıdaki put()'u çağırmaktadır
            put(eleman);
        }
    }

    /* Dilim olmayan türlerle ve dizgilerle kullanılan put() */
    void put(T)(T değer)
            if (!isArray!T || isSomeString!T) {
        foreach (dosya; dosyalar) {
            dosya.write(değer, ayraç);
        }
    }
}
---

$(P
Her türden çıkış aralığı yerine geçebilmesi için $(C put()) işlevini de şablon olarak tanımladım. Bu sayede aşağıda hem $(C int) hem de $(C string) aralığı olarak kullanabiliyoruz.
)

$(P
$(IX copy, std.algorithm) Phobos'ta $(C OutputRange) kullanan bir algoritma $(C std.algorithm.copy)'dir. $(C copy()), bir $(C InputRange) aralığının elemanlarını bir $(C OutputRange) aralığına kopyalayan çok basit bir işlevdir.
)

---
import std.traits;
import std.stdio;
import std.algorithm;

$(CODE_XREF ÇokHedefeYazan)// ...

void main() {
    auto çıkış = ÇokHedefeYazan("\n", "deneme_0", "deneme_1");
    copy([ 1, 2, 3], çıkış);
    copy([ "kırmızı", "mavi", "yeşil" ], çıkış);
}
---

$(P
Yukarıdaki kod, giriş aralıklarındaki elemanları hem $(C stdout)'a, hem de "deneme_0" ve "deneme_1" isimli dosyalara yazar:
)

$(SHELL
1
2
3
kırmızı
mavi
yeşil
)

$(H6 $(IX dilim, OutputRange olarak) Dilimlerin $(C OutputRange) olarak kullanılmaları)

$(P
$(C std.range), dilimleri $(C OutputRange) tanımına da sokar. ($(C std.array) ise yalnızca giriş aralıkları tanımına sokar). Ancak, dilimlerin $(C OutputRange) olarak kullanılmalarının beklenmedik bir etkisi vardır: $(C OutputRange) olarak kullanılan dilim, her $(C put()) işlemine karşılık bir eleman kaybeder. Üstelik kaybedilen eleman, yeni atanmış olan baştaki elemandır.
)

$(P
Bunun nedeni, $(C put()) üye işlevleri bulunmayan dilimlerin yukarıdaki tablodaki şu yönteme uymalarıdır:
)

---
    aralık.front = e;
    aralık.popFront();
---

$(P
Her bir $(C put()) için yukarıdaki kod işletildiğinde hem baştaki elemana yeni değer atanır, hem de $(C popFront())'un etkisiyle baştaki eleman dilimden çıkartılır:
)

---
import std.stdio;
import std.range;

void main() {
    int[] dilim = [ 1, 2, 3 ];
    $(HILITE put(dilim, 100));
    writeln(dilim);
}
---

$(P
Bir $(C OutputRange) olarak kullanıldığı halde dilim eleman kaybetmiştir:
)

$(SHELL
[2, 3]
)

$(P
Bu yüzden dilimin kendisi değil, başka bir dilim $(C OutputRange) olarak kullanılmalıdır:
)

---
import std.stdio;
import std.range;

void main() {
    int[] dilim = [ 1, 2, 3 ];
    int[] dilim2 = dilim;

    put($(HILITE dilim2), 100);

    writeln(dilim2);
    writeln(dilim);
}
---

$(P
Bu sefer ikinci dilim tükendiği halde asıl dilim istediğimiz elemanlara sahiptir:
)

$(SHELL
[2, 3]
[100, 2, 3]    $(SHELL_NOTE istenen sonuç)
)

$(P
Burada önemli bir noktaya dikkat etmek gerekir: $(C OutputRange) olarak kullanılan dilimin uzunluğu otomatik olarak artmaz. Dilimde yeterli yer olması programcının sorumluluğundadır:
)

---
    int[] dilim = [ 1, 2, 3 ];
    int[] dilim2 = dilim;

    foreach (i; 0 .. 4) {    // ← dilimde 4 elemana yer yok
        put(dilim2, i * 100);
    }
---

$(P
$(C popFront()) nedeniyle boşalan dilimde yer kalmadığı için program boş dilimin ilk elemanı bulunmadığını bildiren bir hatayla sonlanır:
)

$(SHELL
core.exception.AssertError@...: Attempting to fetch the $(HILITE front
of an empty array of int)
)

$(P
$(IX appender, std.array) $(C std.array.Appender) ve onun kolaylık işlevi $(C appender) dilimleri $(I sonuna eklenen bir $(C OutputRange)) olarak kullanmaya yarar. $(C appender)'ın döndürdüğü özel aralık nesnesinin kendi $(C put()) işlevi, verilen elemanı dilimin sonuna ekler:
)

---
import std.array;

// ...

    auto sonunaEkleyen = appender([ 1, 2, 3 ]);

    foreach (i; 0 .. 4) {
        sonunaEkleyen.put(i * 100);
    }
---

$(P
Yukarıdaki koddaki $(C appender) bir dizi ile çağrılıyor, ve onun döndürmüş olduğu nesne $(C put()) işlevi çağrılarak bir $(C OutputRange) olarak kullanılıyor. $(C appender)'ın bir çıkış olarak kullanıldığında edindiği elemanlara $(C .data) niteliği ile erişilir:
)

---
    writeln(sonunaEkleyen.data);
---

$(P
Çıktısı:
)

$(SHELL
[1, 2, 3, 0, 100, 200, 300]
)

$(P
$(C Appender) dizilerin $(C ~=) işlecini de destekler:
)

---
    sonunaEkleyen $(HILITE ~=) 1000;
    writeln(sonunaEkleyen.data);
---

$(P
Çıktısı:
)

$(SHELL
[1, 2, 3, 0, 100, 200, 300, 1000]
)

$(H5 Aralık şablonları)

$(P
Bu bölümde kendi yazdığımız çoğu örnekte $(C int) aralıkları kullandık. Oysa aralıkların ve aralık kullanan algoritmaların şablon olarak tasarlanmaları kullanışlılıklarını büyük ölçüde arttırır.
)

$(P
$(C std.range) modülü aralıklarla ilgili olan çok sayıda yardımcı şablon da tanımlar. Bunların nasıl kullanıldıklarını bir sonraki bölümde göstereceğim.
)

$(H5 Özet)

$(UL

$(LI Aralıklar veri yapılarıyla algoritmaları birbirlerinden soyutlayan ve birbirleriyle uyumlu olarak kullanılmalarını sağlayan olanaktır.)

$(LI Aralıklar D'ye özgü bir kavramdır ve Phobos'ta çok kullanılır.)

$(LI Phobos'taki çoğu algoritma kendisi işlem yapmak yerine özel bir aralık nesnesi döndürür ve tembellikten yararlanır.)

$(LI UFCS aralık algoritmaları ile çok uyumludur.)

$(LI Dizgiler $(C InputRange) olarak kullanıldıklarında elemanlarına $(I harf harf) erişilir.)

$(LI $(C InputRange)'in gerektirdiği işlevler $(C empty), $(C front) ve $(C popFront())'tur.)

$(LI $(C ForwardRange)'in gerektirdiği ek işlev $(C save)'dir.)

$(LI $(C BidirectionalRange)'in gerektirdiği ek işlevler $(C back) ve $(C popBack())'tir.)

$(LI Sonsuz $(C RandomAccessRange)'in $(C ForwardRange)'e ek olarak gerektirdiği işlev $(C opIndex())'tir.)

$(LI Sonlu $(C RandomAccessRange)'in $(C BidirectionalRange)'e ek olarak gerektirdiği işlevler $(C opIndex()) ve $(C length)'tir.)

$(LI $(C std.array.appender) dilimlerin sonuna ekleyen bir $(C OutputRange) nesnesi döndürür. )

$(LI Dilimler sonlu $(C RandomAccessRange) aralıklarıdır)

$(LI Sabit uzunluklu diziler aralık değillerdir.)

)

macros:
        SUBTITLE=Aralıklar

        DESCRIPTION=Topluluk elemanlarına erişimi soyutlayarak her algoritmanın o algoritmaya uyan her toplulukla çalışabilmesini sağlayan Phobos'un aralıkları.

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial aralık range OutputRange InputRange ForwardRange BidirectionalRange RandomAccessRange

SOZLER=
$(algoritma)
$(aralik)
$(bagli_liste)
$(degisken)
$(hevesli)
$(islev)
$(phobos)
$(sag_deger)
$(sol_deger)
$(tembel_degerlendirme)
$(topluluk)
$(veri_yapilari)
