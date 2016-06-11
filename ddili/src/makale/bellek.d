Ddoc

$(H4 Bellek Yönetimi)

$(P
  $(B Çeviren:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Tarih:) 14 Temmuz 2009
$(BR)
  $(B İngilizcesi:) $(LINK2 http://wiki.dlang.org/Memory_Management, Memory Management)
)

$(P
Her ciddi program bellek ayırma ve geri verme işlemleriyle ilgilenmek zorundadır. Programların karmaşıklıkları, boyutları, ve hızları arttıkça bu işlemlerin önemi de artar. D'de bellek yönetimi için birçok seçenek bulunur.
)

$(P
D'de bellek ayırma konusunda 3 temel nesne türü vardır:
)

$(OL
$(LI Programın statik veri bölgesinde [static data segment] yer alan $(I statik veriler))
$(LI CPU'nun program yığıtında [program stack] yer alan $(I yığıt verileri))
$(LI Çöp toplamalı bellekte yer alan ve dinamik olarak ayrılan $(I çöp toplamalı veriler))
)

$(P
Bunların programda kullanılmaları ve bazı ileri bellek yönetimi teknikleri şunlardır:
)

$(UL_FARK
$(HEADER_INDEX yazinca_kopyalama, Dizgilerde (ve Dizilerde) $(I Yazınca Kopyalama) [copy-on-write])
$(HEADER_INDEX gercek_zaman, Gerçek Zamanlı [real time] Programlama)
$(HEADER_INDEX kesintisiz, Kesintisiz Çalışma)
$(HEADER_INDEX serbest, Serbest Bellek Listeleri [free list])
$(HEADER_INDEX referans, Referans Sayma)
$(HEADER_INDEX nesne_ayirma, Nesne Ayırmanın Özel Olarak Tanımlanması)
$(HEADER_INDEX isaretle, İşaretle ve Geri Ver [mark/release])
$(HEADER_INDEX raii, Kaynakları Bozucu Fonksiyonlarda Geri Verme: RAII (Resource Acquisition is Initialization))
$(HEADER_INDEX yigit, Sınıf Nesnelerini Yığıtta Oluşturmak)
$(HEADER_INDEX dizi, Yığıtta İlklenmemiş Diziler Oluşturmak)
$(HEADER_INDEX kesme, Kesme Servisleri [Interrupt Service Routines] (ISR))
)

$(HEADER yazinca_kopyalama, Dizgilerde (ve Dizilerde) $(I Yazınca Kopyalama) [copy-on-write])

$(P
Bir fonksiyona bir dizinin gönderildiği bir örneği ele alalım; fonksiyon dizide duruma göre değişiklik yapıyor olsun ve sonuçta değişiklik yaptığı bu diziyi fonksiyondan döndürsün. Diziler fonksiyonlara değer olarak değil, referans olarak gönderildikleri için; dizi içeriğinin kime ait olduğu cevaplanması gereken önemli bir sorudur. Örneğin bir dizideki ASCII karakterleri büyük harfe çeviren bir fonksiyon şöyle yazılabilir:
)

---
char[] büyük_harfe_çevir(char[] s)
{
    int i;

    for (i = 0; i < s.length; i++)
    {
        char c = s[i];
        if ('a' <= c && c <= 'z')
            s[i] = c - (cast(char)'a' - 'A');
    }
    return s;
}
---

$(P
Dikkat edilirse, fonksiyonu çağıran taraftaki dizideki karakterlerin de değiştirildikleri görülür. Bunun istenen bir sonuç olmayabileceğinin yanı sıra, $(CODE s[]) yazılamayan bir bellek bölgesine bağlı bir dizi dilimi bile olabilir.
)

$(P
Bunun önüne geçmek için $(CODE büyük_harfe_çevir()) içinde $(CODE s[])'nin bir kopyası alınabilir. Ancak bu da dizinin zaten bütünüyle büyük harflerden oluştuğu durumlarda tamamen gereksiz bir işlemdir.
)

$(P
Burada çözüm, $(I yazınca kopyalama) yöntemini kullanmaktır; dizi ancak gerçekten gerekiyorsa kopyalanır. Bazı dizgi işleme dillerinde bu işlem otomatiktir ama otomatik olmasının büyük bir bedeli de vardır: "abcdeF" gibi bir dizgi 5 kere kopyalanmak zorunda kalacaktır. Dolayısıyla, bu yöntemden en yüksek verimin alınabilmesi için bunun kod içinde açıkça yapılması gerekir. $(CODE büyük_harfe_çevir()) $(I yazınca kopyalama) yönteminden yararlanacak şekilde etkin olarak şöyle yazılabilir:
)

---
char[] büyük_harfe_çevir(char[] s)
{
    int değişti;
    int i;

    değişti = 0;
    for (i = 0; i < s.length; i++)
    {
        char c = s[i];
        if ('a' <= c && c <= 'z')
        {
            if (!değişti)
            {   char[] r = new char[s.length];
                r[] = s;
                s = r;
                değişti = 1;
            }
            s[i] = c - (cast(char)'a' - 'A');
        }
    }
    return s;
}
---

$(P
D'nin Phobos kütüphenesindeki dizi fonksiyonları $(I yazınca kopyalama) yönteminden yararlanırlar.
)

$(HEADER gercek_zaman, Gerçek Zamanlı [real time] Programlama)

$(P
Gerçek zamanlı programlama, işlemlerin en fazla ne kadar gecikmeyle tamamlanacaklarının garanti edilmesidir. Bu gecikme, malloc/free'nin ve çöp toplamanın da aralarında bulunduğu çoğu bellek yönetimi işlemlerinde teorik olarak sınırsızdır. Bu durumda en güvenilir yöntem; gerekli belleğin önceden ayrılmasıdır. Böylece gecikmeye tahammülü olmayan işlem sırasında bellek ayrılmaz ve çöp toplayıcı çalışmayacağı için gecikme miktarı belirli bir sınırın altında kalır.
)

$(HEADER kesintisiz, Kesintisiz Çalışma)

$(P
Gerçek zamanlı programlamaya bağlı olarak, çöp toplayıcının belirsiz anlarda çalışmaya başlayarak programda duraksamalara neden olmasının önlenmesi gerekir. Örnek olarak bir savaş oyunu programını düşünebiliriz. Her ne kadar programda bir bozukluk olarak kabul edilmese de, oyunun rastgele duraksaması kullanıcıyı son derece rahatsız edecektir.
)

$(P
Duraksamaları ortadan kaldırmanın veya hiç olmazsa azaltmanın bazı yolları vardır:
)

$(UL
$(LI Gereken bütün belleği programın kesintisiz olarak çalışması gereken yerinden önce ayırmak)
$(LI Çöp toplayıcıyı programın zaten durmuş olduğu yerlerde açıkça çağırmak. Örneğin kullanıcıdan giriş beklenen bir yerde... Böylece çöp toplayıcının kendi başına çalışma olasılığı azalmış olur.)
$(LI Kesintisiz çalışması gereken yerden önce $(CODE std.gc.disable())'ı, sonra $(CODE std.gc.enable())'ı çağırmak. Çöp toplayıcı çalışmaya karar vermek yerine öncelikle yeni bellek ayırmayı tercih edecektir.)
)

$(HEADER serbest, Serbest Bellek Listeleri [free list])

$(P
Serbest bellek listeleri, sıklıkla ayrılıp tekrar geri verilen türlerde büyük hız kazancı sağlar. Aslında çok basit bir fikirdir: işi biten nesne geri verilmek yerine, bir serbest bellek listesine yerleştirilir. Bellek gerektiği zaman da öncelikle bu listeye bakılır.
)

---
class Foo
{
    static Foo serbestler_listesi;      // listenin başı

    static Foo ayır()
    {   Foo f;

        if (serbestler_listesi)
        {   f = serbestler_listesi;
            serbestler_listesi = f.sonraki;
        }
        else
            f = new Foo();
        return f;
    }

    static void geri_ver(Foo f)
    {
        f.sonraki = serbestler_listesi;
        serbestler_listesi = f;
    }

    Foo sonraki;         // bağlı liste için
    ...
}

void deneme()
{
    Foo f = Foo.ayır();
    ...
    Foo.geri_ver(f);
}
---

$(P
Bu tür listeler son derece hızlı olabilirler.
)

$(UL
$(LI Birden fazla iş parçacığıyla kullanıldığında $(CODE ayır()) ve $(CODE geri_ver()) fonksiyonlarının erişim sıralarının yönetilmesi gerekir. [synchronization])
$(LI Foo kurucusu $(CODE ayır()) içinde tekrar tekrar çağrılmadığı için döndürülen nesnenin en azından bazı üyelerinin değerlerinin tekrardan atanması gerekebilir.)
$(LI Bu yönteme RAII'nin eklenmesine gerek yoktur, çünkü atılan bir hata yüzünden $(CODE geri_ver())'in çağrılamadığı durumlarda kaybedilen bellek, çöp toplayıcı tarafından geri alınacaktır.)
)

$(HEADER referans, Referans Sayma)

$(P
Burada fikir, nesne içinde bir sayaç barındırmaktır. Sayaç, nesneye yapılan her referansta arttırılır, sonlandırılan her referansta da azaltılır. Sayacın değeri sıfıra indiğinde artık nesne geri verilebilir demektir.
)

$(P
D'de referans saymaya yönelik olanaklar bulunmadığı için istendiğinde elle yapılması gerekir.
)

$(P
$(LINK2 http://www.dlang.org/COM.html, Win32 COM programlama), referans sayıları için $(CODE AddRef()) ve $(CODE Release()) fonksiyonlarını kullanır.
)

$(HEADER nesne_ayirma, Nesne Ayırmanın Özel Olarak Tanımlanması)

$(P
D'de her tür nesne için özel ayırma ve geri verme fonksiyonları tanımlanabilir. Nesneler normalde çöp toplamalı bellek bölgesinde yer alırlar; çöp toplayıcı çalışmaya karar verdiğinde de sonlanmış olan nesnelerin bellekleri otomatik olarak geri alınır. Ayırma ve geri verme işlemlerini bir tür için özel olarak tanımlamak için $(CODE new) ve $(CODE delete) bildirimleri kullanılır. Örneğin bu işi C kütüphanesindeki $(CODE malloc) ve $(CODE free) ile yapmak için:
)

---
import std.c.stdlib;
import std.outofmemory;
import std.gc;

class Foo
{
    new(size_t uzunluk)
    {
        void* p;

        p = std.c.stdlib.malloc(uzunluk);
        if (!p)
            throw new OutOfMemoryException();
        std.gc.addRange(p, p + uzunluk);
        return p;
    }

    delete(void* p)
    {
        if (p)
        {   std.gc.removeRange(p);
            std.c.stdlib.free(p);
        }
    }
}
---

$(P
$(CODE new())'ün özel olarak tanımlanmasıyla ilgili önemli bazı bilgiler:
)

$(UL
$(LI $(CODE new())'ün dönüş türü belirtilmiyor olsa da $(CODE void*)'dir ve $(CODE new())'ün $(CODE void*) döndürmesi gerekir.)

$(LI Bellek ayıramadığı zaman null döndürmek yerine bir hata atması gerekir. Atılan hatanın türü programcıya kalmıştır. Bu örnekte bir $(CODE OutOfMemoryException) atılmaktadır.)

$(LI Döndürülen bellek sistemin normal yerleştirme aralığında [alignment] olmalıdır. Örneğin win32 sistemlerinde bu adım 8'dir.)

$(LI $(CODE uzunluk) parametresinin nedeni, ayırma fonksiyonunun $(CODE Foo)'nun bir alt türü tarafından çağrılmış olabileceği, ve o alt türün $(CODE Foo)'dan daha büyük yer tutuyor olabileceğidir.)

$(LI Çöp toplamalı belleği gösteren kök işaretçiler taranırken statik veri bölgesine ve program yığıtına da bakılır. C'nin çalışma ortamı tarafından kullanılan bellek buna dahil değildir. Bu yüzden, $(CODE Foo)'nun veya ondan türemiş olan bir türün üyelerinin çöp toplamalı belleği gösterdiklerinde, bu durumdan çöp toplayıcının haberdar edilmesi gerekir. Bu işlem $(CODE std.gc.addRange()) ile yapılır.)

$(LI Belleğin ilklenmesine gerek yoktur; $(CODE new()) çağrıldıktan hemen sonra sınıf üyelerine zaten ilk değerleri verilir, ve varsa kurucu fonksiyon çalıştırılır.)
)


$(P
$(CODE delete())'in özel olarak tanımlanmasıyla ilgili önemli bazı bilgiler:
)

$(UL
$(LI Bozucu fonksiyon, $(CODE p)'nin gösterdiği bölgede zaten çalıştırılmıştır; dolayısıyla gösterdiği yerde artık çöp değerler bulunmaktadır.)

$(LI $(CODE p) işaretçisi null olabilir.)

$(LI Eğer çöp toplayıcıya $(CODE std.gc.addRange()) ile haber verilmişse, geri veren fonksiyonda da ona karşılık bir $(CODE std.gc.removeRange()) çağrısı bulunması gerekir.)

$(LI Eğer bir $(CODE delete()) tanımlanmışsa, ona karşılık gelen bir $(CODE new())'ün de tanımlanmış olması gerekir.)

)

$(P
Bir sınıf için özel bellek ayırma ve geri verme fonksiyonları yazıldığında, bellek sızıntısı ve geçersiz işaretçiler gibi sorunları önlemek için çok dikkatli olmak gerekir. Özellikle hata atma durumlarında bellek sızıntılarını önlemek için RAII yöntemini uygulamak çok önemlidir.
)

$(P
Bu özel fonksiyonlar $(CODE struct) ve $(CODE union) türleri için de tanımlanabilirler.
)

$(HEADER isaretle, İşaretle ve Geri Ver [mark/release])

$(P
Bu yöntem program yığıtına benzer. Bellekte program yığıtı gibi kullanılacak bir yer ayrılır ve nesneler için gereken yer, bu bellekte ilerleyen bir işaretçinin değeri değiştirilerek $(I ayrılır). Bazı noktalara $(I işaretler koyulur) ve yığıt işaretçisine tekrar o noktalardan birisi göstertilerek belleğin bir bölümü tümden $(I geri verilmiş) olur.
)

---
import std.c.stdlib;
import std.outofmemory;

class Foo
{
    static void[] bellek;
    static int indeks;
    static const int uzunluk = 100;

    static this()
    {   void *p;

        p = malloc(uzunluk);
        if (!p)
            throw new OutOfMemoryException;
        std.gc.addRange(p, p + uzunluk);
        bellek = p[0 .. uzunluk];
    }

    static ~this()
    {
        if (bellek.length)
        {
            std.gc.removeRange(bellek);
            free(bellek);
            bellek = null;
        }
    }

    new(size_t gereken_uzunluk)
    {   void *p;

        p = &bellek[indeks];
        indeks += gereken_uzunluk;
        if (indeks > bellek.length)
            throw new OutOfMemory;
        return p;
    }

    delete(void* p)
    {
        // [Çevirenin notu: Bu yöntemde Foo nesneleri teker
        // teker 'delete' ile geri verilmeyecekleri için,
        // 'delete'in yanlışlıkla çağrıldığı durumları
        // yakalamak için burada program sonlandırılıyor.]
        assert(0);
    }

    static int yerini_işaretle()
    {
        return indeks;
    }

    static void geri_ver(int i)
    {
        indeks = i;
    }
}

void test()
{
    int m = Foo.yerini_işaretle();
    Foo f1 = new Foo;          // yer ayır
    Foo f2 = new Foo;          // yer ayır
    ...
    Foo.geri_ver(m);           // f1 ve f2'yi birlikte geri ver
}
---

$(P
$(CODE bellek[]) için ayrılan yer $(CODE std.gc.addRange(p, p + uzunluk);) ile çöp toplayıcıya bildirildiği için, açıkça geri verilmesi gerekmez.
)

$(HEADER raii, Kaynakları Bozucu Fonksiyonlarda Geri Verme: RAII (Resource Acquisition is Initialization))

$(P
RAII yöntemi, ayırma ve geri verme fonksiyonlarının açıkça kod içinde yapıldığı durumlarda bellek sızıntılarının önlenmesinde çok yararlıdır. Bu tür sınıflara $(LINK2 http://www.dlang.org/attribute.html#scope, $(CODE scope) niteliği) eklemek bu konuda yarar sağlar.
)

$(HEADER yigit, Sınıf Nesnelerini Yığıtta Oluşturmak)

$(P
Sınıf nesneleri normalde çöp toplamalı bellekte yer alırlar. Bazı durumlarda ise program yığıtında oluşturulurlar:
)

$(UL
$(LI fonksiyonlarda yerel tanımlandıklarında)
$(LI $(CODE new) ile oluşturulduklarında)
$(LI $(CODE new) argümansız kullanıldığında (yine de kurucu için argüman kullanılabilir))
$(LI $(CODE scope) depolama türü ile tanımlandıklarında)
)

$(P
Çöp toplayıcının bu nesne için zaman geçirmesi gerekmeyeceği için bu etkin bir yöntemdir. Ama böyle nesneleri gösteren referansların fonksiyondan çıkıldığı anda geçersiz hale geldiklerine dikkat etmek gerekir.
)

---
class C { ... }

scope c = new C();      // c yığıttadır
scope c2 = new C(5);    // yığıttadır
scope c3 = new(5) C();  // özel ayırıcısı ile ayrılmıştır
---

$(P
Eğer sınıfın bir bozucusu varsa, kapsamdan (örneğin fonksiyondan) hangi nedenle olursa olsun çıkılırken, o bozucu fonksiyon çağrılır (hata atıldığında bile).
)

$(HEADER dizi, Yığıtta İlklenmemiş Diziler Oluşturmak)

$(P
D'de diziler normalde otomatik olarak ilklenirler. Dolayısıyla şu kodda $(CODE dizi[]) elemanlarının ilk değerleri hiç kullanılmadıklarından ($(CODE diziyi_doldur()) tarafından üzerlerine yazıldığı varsayılırsa) bu kod daha hızlandırılabilir.
)

---
void foo()
{   byte[1024] dizi;

    diziyi_doldur(dizi);
    ...
}
---

$(P
Eğer programın bu kod yüzünden gerçekten hız kaybettiği kanıtlanmışsa, elemanların ilklenmelerinin istenmediği $(CODE void) ile belirtilir:
)

---
void foo()
{   byte[1024] dizi = void;

    diziyi_doldur(dizi);
    ...
}
---

$(P
Ancak, yığıttaki ilklenmemiş verilerle ilgili bazı uyarıları akılda tutmak gerekir:
)

$(UL
$(LI
Yığıttaki ilklenmemiş veriler de çöp toplayıcı tarafından taranırlar ve başka bellek bölgelerine referanslar barındırıp barındırmadıklarına bakılır. Yığıtta bulunan ilklenmemiş değerler daha önce program tarafından kullanılan nesnelerin kalıntıları oldukları için, bu eski değerler çöp toplayıcı belleğindeki nesneleri gösteriyor gibi algılanabilirler ve çöp toplayıcı belleğindeki bu şanssız nesneler hiçbir zaman geri verilmeyebilirler. Bu gerçekten karşılaşılan bir hatadır ve farkedilip giderilmesi çok belalı olabilir.
)

$(LI
Bir fonksiyon, kendisini çağırana bir yığıt nesnesi referansı döndürme hatasına düşmüş olabilir. Bu referans yine yığıtın ilklenmemiş bir bölgesindeki geçerli bir nesneyi gösteriyor gibi algılanabilir ve programın davranışını garip ve tutarsız hale getirebilir. Oysa yığıttaki verilerin her zaman için ilklenmeleri, böyle olası hataların hiç olmazsa tutarlı ve tekrarlanabilir olmalarını sağlar.
)

$(LI
İlklenmemiş veri doğru kullanıldığında bile hatalara yol açabilir. D'nin tasarım hedeflerinden birisi, programların güvenilirliklerini ve taşınabilirliklerini arttırmaktır. İlklenmemiş veriler; tanımsız, taşınamaz, hatalı, ve tutarsız davranışların kaynaklarıdırlar. Bu yüzden verileri ilklemeden kullanmak, ancak ve ancak hız kazancı için diğer yollar tükendiğinde ve gerçekten bir hız kazancı sağladığı kanıtlandığında denenmelidir.
)

)

$(HEADER kesme, Kesme Servisleri [Interrupt Service Routines] (ISR))

$(P
Çöp toplayıcı her çalıştığında yığıtlarını ve yazmaçlarını [register] taramak için bütün iş parçacıklarını [thread] durdurmak zorundadır. Eğer bir kesme servisi iş parçacığı durdurulursa, bütün program göçebilir.
)

$(P
Bu yüzden kesme servislerinin durdurulmamaları gereklidir. $(CODE std.thread) modülündeki fonksiyonlar tarafından başlatılan iş parçacıkları durdurulurlar. Ama C'nin $(CODE _beginthread()) ve benzeri fonksiyonları tarafından başlatılan iş parçacıkları durdurulmazlar, çünkü çöp toplayıcının bunların varlığından haberi yoktur.
)

$(P
Bunun başarıyla çalışabilmesi için:
)

$(UL
$(LI
ISR iş parçacığı çöp toplamalı kaynaklar kullanmamalıdır. Yani global $(CODE new) kullanılamaz, dinamik dizilerin boyları değiştirilemez, ve çağrışımlı dizilere yeni elemanlar eklenemez. D kütüphanesinin ISR tarafından her kullanımı dikkatle incelenmeli ve çöp toplayıcı belleğinin kullanılmadığından emin olunmalıdır. Daha da iyisi, kesme servisi D çalışma zamanı kütüphanesindeki hiçbir fonksiyonu çağırmamalıdır.
)

$(LI
ISR, çöp toplamalı bellekteki bir bölgenin tek referansı olamaz; çünkü bundan haberi olmayan çöp toplayıcı belleği geri verebilir. Bir çözüm, durdurulan bir iş parçacığında veya bir globalde de o bellek bölgesini gösteren bir referans tutmaktır.
)

)


Macros:
        SUBTITLE="Bellek Yönetimi", Walter Bright

        DESCRIPTION=D'de etkin bellek yönetimi yöntemleri.

        KEYWORDS=d programlama dili makale d tanıtım bellek yönetimi çöp toplayıcı
