Ddoc

$(DERS_BOLUMU $(IX dizi) Diziler)

$(P
Bir önceki bölümün problemlerinden birisinde 5 tane değişken tanımlamış ve onlarla belirli işlemler yapmıştık: önce iki katlarını almıştık, sonra da beşe bölmüştük. O değişkenleri ayrı ayrı şöyle tanımlamıştık:
)

---
    double sayı_1;
    double sayı_2;
    double sayı_3;
    double sayı_4;
    double sayı_5;
---

$(P
Bu yöntem her duruma uygun değildir, çünkü değişken sayısı arttığında onları teker teker tanımlamak, içinden çıkılmaz bir hal alır. Bin tane sayıyla işlem yapmak gerektiğini düşünün... Bin tane değişkeni ayrı ayrı sayı_1, sayı_2, ..., sayı_1000 diye tanımlamak hemen hemen olanaksız bir iştir.
)

$(P
Dizilerin bir yararı böyle durumlarda ortaya çıkar: diziler bir seferde birden fazla değişken tanımlamaya yarayan olanaklardır. Birden fazla değişkeni bir araya getirmek için en çok kullanılan veri yapısı da dizidir.
)

$(P
Bu bölüm dizi olanaklarının yalnızca bir bölümünü kapsar. Diğer olanaklarını daha ilerideki bir bölümde göreceğiz.
)

$(H5 Tanımlanması)

$(P
Dizi tanımı değişken tanımına çok benzer. Tek farkı, dizide kaç değişken bulunacağının, yani bir seferde kaç değişken tanımlanmakta olduğunun, türün isminden sonraki köşeli parantezler içinde belirtilmesidir. Tek bir değişkenin tanımlanması ile bir dizinin tanımlanmasını şöyle karşılaştırabiliriz:
)

---
    int     tekDeğişken;
    int[10] onDeğişkenliDizi;
---

$(P
O iki tanımdan birincisi, şimdiye kadarki kodlarda gördüklerimiz gibi tek değişken tanımıdır; ikincisi ise 10 değişkenden oluşan bir dizidir.
)

$(P
Yukarıda sözü geçen problemdeki 5 ayrı değişkeni 5 elemanlı bir dizi halinde hep birden tanımlamak için şu söz dizimi kullanılır:
)

---
    double[5] sayılar;
---

$(P
Bu tanım, "double türünde 5 tane sayı" diye okunabilir. Daha sonra kod içinde kullanıldığında tek bir sayı değişkeni sanılmasın diye ismini de çoğul olarak seçtiğime dikkat edin.
)

$(P
Özetle; dizi tanımı, tür isminin yanına köşeli parantezler içinde yazılan dizi uzunluğundan ve bunları izleyen dizi isminden oluşur:
)

---
    $(I tür_ismi)[$(I dizi_uzunluğu)] $(I dizi_ismi);
---

$(P
Tür ismi olarak temel türler kullanılabileceği gibi, programcının tanımladığı daha karmaşık türler de kullanılabilir (bunları daha sonra göreceğiz). Örnekler:
)

---
    // Bütün şehirlerdeki hava durumlarını tutan bir dizi
    // Burada örneğin
    //   false: "kapalı hava"
    //   true : "açık hava"
    // anlamında kullanılabilir
    bool[şehirAdedi] havaDurumları;

    // Yüz kutunun ağırlıklarını ayrı ayrı tutan bir dizi
    double[100] kutuAğırlıkları;

    // Bir okuldaki bütün öğrencilerin kayıtları
    ÖğrenciBilgisi[öğrenciAdedi] öğrenciKayıtları;
---

$(H5 $(IX topluluk) $(IX eleman) Topluluklar ve elemanlar)

$(P
Aynı türden değişkenleri bir araya getiren veri yapılarına $(I topluluk) adı verilir. Bu tanıma uydukları için diziler de toplulukturlar. Örneğin Temmuz ayındaki günlük hava sıcaklıklarını tutmak için kullanılacak bir dizi 31 tane $(C double) değişkenini bir araya getirebilir ve $(I $(C double) türünde elemanlardan oluşan bir topluluk) oluşturur.
)

$(P
Topluluk değişkenlerinin her birisine $(I eleman) denir. Dizilerin barındırdıkları eleman adedine dizilerin $(I uzunluğu) denir. "Eleman adedi" ve "dizi uzunluğu" ifadelerinin ikisi de sık kullanılır.
)

$(H5 $(IX []) Eleman erişimi)

$(P
Problemdeki değişkenleri ayırt etmek için isimlerinin sonuna bir alt çizgi karakteri ve bir sıra numarası eklemiştik: $(C sayı_1) gibi... Sayıları hep birden bir dizi halinde ve $(C sayılar) isminde tanımlayınca elemanlara farklı isimler verme şansımız kalmaz. Onun yerine, elemanlara dizinin erişim işleci olan $(C []) ile ve bir sıra numarasıyla erişilir:
)

---
    sayılar[0]
---

$(P
O yazım, "sayıların 0 numaralı elemanı" diye okunabilir. Bu şekilde yazınca $(C sayı_1) ifadesinin yerini $(C sayılar[0]) ifadesi almış olur.
)

$(P
Burada dikkat edilmesi gereken iki nokta vardır:
)

$(UL

$(LI $(B Numara sıfırdan başlar:) Biz insanlar nesneleri 1'den başlayacak şekilde numaralamaya alışık olduğumuz halde, dizilerde numaralar 0'dan başlar. Bizim 1, 2, 3, 4, ve 5 olarak numaraladığımız sayılar dizi içinde 0, 1, 2, 3, ve 4 olarak numaralanırlar. Programcılığa yeni başlayanların bu farklılığa dikkat etmeleri gerekir.
)

$(LI $(B $(C[]) karakterlerinin iki farklı kullanımı:) Dizi tanımlarken kullanılan $(C []) karakterleri ile erişim işleci olarak kullanılan $(C []) karakterlerini karıştırmayın. Dizi tanımlarken kullanılan $(C []) karakterleri elemanların türünden sonra yazılır ve dizide kaç eleman bulunduğunu belirler; erişim için kullanılan $(C []) karakterleri ise dizinin isminden sonra yazılır ve elemanın sıra numarasını belirler:

---
    // Bu bir tanımdır. 12 tane int'ten oluşmaktadır ve her
    // ayda kaç gün bulunduğu bilgisini tutmaktadır
    int[12] ayGünleri;

    // Bu bir erişimdir. Aralık ayına karşılık gelen elemana
    // erişir ve değerini 31 olarak belirler
    ayGünleri[11] = 31;

    // Bu da bir erişimdir. Ocak ayındaki gün sayısını
    // writeln'a göndermek için kullanılmaktadır.
    writeln("Ocak'ta ", ayGünleri[0], " gün var.");
---

$(P
$(B Hatırlatma:) Ocak ayının sıra numarasının 0, Aralık ayının sıra numarasının 11 olduğuna dikkat edin.
)

)

)

$(H5 $(IX indeks) İndeks)

$(P
Elemanlara erişirken kullanılan sıra numaralarına $(I indeks), elemanlara erişme işine de $(I indeksleme) denir.
)

$(P
İndeks sabit bir değer olmak zorunda değildir; indeks olarak değişken değerleri de kullanılabilir. Bu olanak dizilerin kullanışlılığını büyük ölçüde arttırır. Örneğin aşağıdaki kodda hangi aydaki gün sayısının yazdırılacağını $(C ayNumarası) değişkeni belirlemektedir:
)

---
    writeln("Bu ay ", ayGünleri[ayNumarası], " gün çeker");
---

$(P
$(C ayNumarası)'nın 2 olduğu bir durumda yukarıdaki ifadede $(C ayGünleri[2])'nin değeri, yani Mart ayındaki gün adedi yazdırılır. $(C ayNumarası)'nın başka bir değerinde de o aydaki gün sayısı yazdırılır.
)

$(P
Yasal olan indeksler, 0'dan dizinin uzunluğundan bir eksiğine kadar olan değerlerdir. Örneğin 3 elemanlı bir dizide yalnızca 0, 1, ve 2 indeksleri yasaldır. Bunun dışında indeks kullanıldığında program bir hata ile sonlanır.
)

$(P
Dizileri, elemanları yan yana duran bir topluluk olarak düşünebilirsiniz. Örneğin ayların günlerini tutan bir dizinin elemanları ve indeksleri şu şekilde gösterilebilir (Şubat'ın 28 gün çektiğini varsayarak):
)

$(MONO
<span style="color:green"> indeksler →     0    1    2    3    4    5    6    7    8    9   10   11</span>
<span style="color:blue"> elemanlar →  | 31 | 28 | 31 | 30 | 31 | 30 | 31 | 31 | 30 | 31 | 30 | 31 |</span>
)

$(P
$(I Not: Yukarıdaki indeksleri yalnızca gösterim amacıyla kullandım; indeksler belleğe yazılmazlar.)
)

$(P
İlk elemanın indeksi 0, ve Ocak ayındaki gün sayısı olan 31 değerine sahip; ikinci elemanın indeksi 1, ve Şubat ayındaki gün sayısı olan 28 değerine sahip; vs.
)

$(H5 $(IX sabit uzunluklu dizi) $(IX dinamik dizi) $(IX statik dizi) Sabit uzunluklu diziler ve dinamik diziler)

$(P
Kaç eleman barındıracakları programın yazıldığı sırada bilinen dizilere $(I sabit uzunluklu dizi); elemanlarının sayısı programın çalışması sırasında değişebilen dizilere $(I dinamik dizi) denir.
)

$(P
Yukarıda 5 sayı tanımlamak için kullandığımız $(C sayılar) dizisi ve 12 aydaki gün sayılarını tutmak için kullandığımız $(C ayGünleri) dizileri sabit uzunluklu dizilerdir; çünkü eleman sayıları baştan belirlenmiştir. O dizilerin uzunlukları programın çalışması sırasında değiştirilemez. Uzunluklarının değişmesi gerekse, bu ancak kaynak koddaki sabit olan değerin elle değiştirilmesi ve programın tekrar derlenmesi ile mümkündür.
)

$(P
Dinamik dizi tanımlamak sabit uzunluklu dizi tanımlamaktan daha kolaydır; dizinin uzunluğunu boş bırakmak diziyi dinamik yapmaya yeter:
)

---
    int[] dinamikDizi;
---

$(P
Böyle dizilerin uzunlukları programın çalışması sırasında gerektikçe arttırılabilir veya azaltılabilir.
)

$(H5 $(IX .length) Eleman adedini edinmek ve değiştirmek için $(C .length))

$(P
Türlerin olduğu gibi dizilerin de nitelikleri vardır. Burada yalnızca bir tanesini göreceğiz. $(C .length) dizideki eleman adedini bildirir:
)

---
    writeln("Dizide ", dizi.length, " tane eleman var");
---

$(P
Ek olarak, $(C .length) dinamik dizilerde dizinin uzunluğunu değiştirmeye de yarar:
)

---
    int[] dizi;            // boştur
    dizi.length = 5;       // uzunluğu 5 olur
---

$(H5 Bir dizi örneği)

$(P
Bu bilgiler ışığında 5 değişkenli probleme dönelim ve onu dizi kullanacak şekilde tekrar yazalım:
)

---
import std.stdio;

void main() {
    // Bu değişkeni döngüleri kaç kere tekrarladığımızı saymak
    // için kullanacağız
    int sayaç;

    // double türündeki beş elemandan oluşan sabit uzunluklu
    // bir dizi tanımlıyoruz
    double[5] sayılar;

    // Sayıları bir döngü içinde girişten alıyoruz
    while (sayaç < sayılar.length) {
        write("Sayı ", sayaç + 1, ": ");
        readf(" %s", &sayılar[sayaç]);
        ++sayaç;
    }

    writeln("İki katları:");
    sayaç = 0;
    while (sayaç < sayılar.length) {
        writeln(sayılar[sayaç] * 2);
        ++sayaç;
    }

    // Beşte birlerini hesaplayan döngü de bir önceki
    // döngünün benzeridir...
}
---

$(P $(B Gözlemler:) Döngülerin kaç kere tekrarlanacaklarını $(C sayaç) belirliyor: döngüleri, o değişkenin değeri $(C sayılar.length)'ten küçük olduğu sürece tekrarlıyoruz. Sayacın değeri her tekrarda bir arttıkça, $(C sayılar[sayaç]) ifadesi de sırayla dizinin elemanlarını göstermiş oluyor: $(C sayılar[0]), $(C sayılar[1]), vs.
)

$(P
Bu programın yararını görmek için girişten 5 yerine örneğin 20 sayı alınacağını düşünün... Dizi kullanan bu programda tek bir yerde küçük bir değişiklik yapmak yeter: 5 değerini 20 olarak değiştirmek... Oysa dizi kullanmayan programda 15 tane daha değişken tanımlamak ve kullanıldıkları kod satırlarını 15 değişken için tekrarlamak gerekirdi.
)

$(H5 $(IX ilkleme, dizi) Elemanları ilklemek)

$(P
D'de her türde olduğu gibi dizi elemanları da otomatik olarak ilklenirler. Elemanlar için kullanılan ilk değer, elemanların türüne bağlıdır: $(C int) için 0, $(C double) için $(C double.nan), vs.
)

$(P
Yukarıdaki programdaki $(C sayılar) dizisinin beş elemanı da dizi tanımlandığı zaman $(C double.nan) değerine sahiptir:
)

---
    double[5] sayılar;     // dizinin bütün elemanlarının
                           // ilk değeri double.nan olur
---

$(P
Elemanların bu ilk değerleri dizi kullanıldıkça değişebilir. Bunun örneklerini yukarıdaki programlarda gördük. Örneğin $(C ayGünleri) dizisinin 11 indeksli elemanına 31 değerini atadık:
)

---
    ayGünleri[11] = 31;
---

$(P
Daha sonra da girişten gelen değeri, $(C sayılar) isimli dizinin $(C sayaç) indeksli elemanının değeri olarak okuduk:
)

---
    readf(" %s", &sayılar[sayaç]);
---

$(P
Bazen elemanların değerleri, dizi kurulduğu anda bilinir. Öyle durumlarda dizi, $(I atama) söz dizimiyle ve elemanların ilk değerleri sağ tarafta belirtilerek tanımlanır. Kullanıcıdan ay numarasını alan ve o ayın kaç gün çektiğini yazan bir program düşünelim:
)

---
import std.stdio;

void main() {
    // Şubat'ın 28 gün çektiğini varsayıyoruz
    int[12] ayGünleri =
        [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

    write("Kaçıncı ay? ");
    int ayNumarası;
    readf(" %s", &ayNumarası);

    int indeks = ayNumarası - 1;
    writeln(ayNumarası, ". ay ",
            ayGünleri[indeks], " gün çeker");
}
---

$(P
O programda $(C ayGünleri) dizisinin elemanlarının dizinin tanımlandığı anda ilklendiklerini görüyorsunuz. Ayrıca, kullanıcıdan alınan ve değeri <span style="white-space: nowrap">1-12</span> aralığında olan ay numarasının indekse nasıl dönüştürüldüğüne dikkat edin. Böylece kullanıcının <span style="white-space: nowrap">1-12</span> aralığında verdiği numara, programda <span style="white-space: nowrap">0-11</span> aralığına dönüştürülmüş olur. Kullanıcı <span style="white-space: nowrap">1-12</span> aralığının dışında bir değer girdiğinde, program dizinin dışına erişildiğini bildiren bir hata ile sonlanır.
)

$(P
Dizileri ilklerken sağ tarafta tek bir eleman değeri de kullanılabilir. Bu durumda dizinin bütün elemanları o değeri alır:
)

---
    int[10] hepsiBir = 1;    // Bütün elemanları 1 olur
---

$(H5 Temel dizi işlemleri)

$(P
Diziler, bütün elemanlarını ilgilendiren bazı işlemlerde büyük kolaylık sağlarlar.
)

$(H6 $(IX kopyalama, dizi) Sabit uzunluklu dizileri kopyalama)

$(P
Atama işleci, sağdaki dizinin elemanlarının hepsini birden soldaki diziye kopyalar:
)
---
    int[5] kaynak = [ 10, 20, 30, 40, 50 ];
    int[5] hedef;

    hedef = kaynak;
---

$(P
$(I Not: Atama işleminin anlamı dinamik dizilerde çok farklıdır; bunu ilerideki bir bölümde göreceğiz.)
)

$(H6 Dinamik dizilere eleman ekleme)

$(P
$(IX ~=) $(IX ekleme, dizi) $(IX eleman ekleme, dizi) $(C ~=) işleci, dinamik dizinin sonuna yeni bir eleman veya yeni bir dizi ekler:
)

---
    int[] dizi;                // dizi boştur
    dizi ~= 7;                 // dizide tek eleman vardır
    dizi ~= 360;               // dizide iki eleman olur
    dizi ~= [ 30, 40 ];        // dizide dört eleman olur
---

$(P
Sabit uzunluklu dizilere eleman eklenemez:
)

---
    int[$(HILITE 10)] dizi;
    dizi ~= 7;                 $(DERLEME_HATASI)
---

$(H6 Birleştirme)

$(P
$(IX ~, birleştirme) $(IX birleştirme, dizi) $(C ~) işleci iki diziyi uç uca birleştirerek yeni bir dizi oluşturur. Aynı işlecin atamalı olanı da vardır ($(C ~=)) ve sağdaki diziyi soldaki dizinin sonuna ekler:
)

---
import std.stdio;

void main() {
    int[10] birinci = 1;
    int[10] ikinci = 2;
    int[] sonuç;

    sonuç = birinci ~ ikinci;
    writeln(sonuç.length);     // 20 yazar

    sonuç ~= birinci;
    writeln(sonuç.length);     // 30 yazar
}
---

$(P
Eğer sol tarafta sabit uzunluklu bir dizi varsa, dizinin uzunluğu değiştirilemeyeceği için $(C ~=) işleci kullanılamaz:
)

---
    int[20] sonuç;
    // ...
    sonuç $(HILITE ~=) birinci;          $(DERLEME_HATASI)
---

$(P
Atama işleminde de, sağ tarafın uzunluğu sol tarafa uymazsa program çöker:
)

---
    int[10] birinci = 1;
    int[10] ikinci = 2;
    int[$(HILITE 21)] sonuç;

    sonuç = birinci ~ ikinci;
---

$(P
O kod, programın "dizi kopyası sırasında uzunluklar aynı değil" anlamına gelen hata ile çökmesine neden olur:
)

$(SHELL
object.Error@(0): Array lengths don't match for copy: $(HILITE 20 != 21)
)

$(H6 $(IX sort) Elemanları sıralama)

$(P
$(C std.algorithm.sort) işlevi elemanları küçükten büyüğe doğru sıralar. $(C sort())'tan yararlanabilmek için $(C std.algorithm) modülünün eklenmesi gerekir. (İşlevleri daha sonraki bir bölümde göreceğiz.)
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] dizi = [ 4, 3, 1, 5, 2 ];
    $(HILITE sort)(dizi);
    writeln(dizi);
}
---

$(P
Çıktısı:
)

$(SHELL
[1, 2, 3, 4, 5]
)

$(H6 $(IX reverse) Elemanları ters çevirmek)

$(P
$(C std.algorithm.reverse) elemanların yerlerini aynı dizi içinde ters çevirir; ilk eleman sonuncu eleman olur, vs.:
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] dizi = [ 4, 3, 1, 5, 2 ];
    $(HILITE reverse)(dizi);
    writeln(dizi);
}
---

$(P
Çıktısı:
)

$(SHELL
[2, 5, 1, 3, 4]
)

$(PROBLEM_COK

$(PROBLEM
Yazacağınız program önce kullanıcıdan kaç tane sayı girileceğini öğrensin ve girişten o kadar kesirli sayı alsın. Daha sonra bu sayıları önce küçükten büyüğe, sonra da büyükten küçüğe doğru sıralasın.

$(P
Burada $(C sort) ve $(C reverse) işlevlerini kullanabilirsiniz.
)

)

$(PROBLEM
Başka bir program yazın: girişten aldığı sayıların önce tek olanlarını sırayla, sonra da çift olanlarını sırayla yazdırsın. Özel olarak <span style="white-space: nowrap">-1</span> değeri girişi sonlandırmak için kullanılsın: bu değer geldiğinde artık girişten yeni sayı alınmasın.

$(P
Örneğin girişten
)

$(SHELL
1 4 7 2 3 8 11 -1
)

$(P
geldiğinde çıkışa şunları yazdırsın:
)

$(SHELL
1 3 7 11 2 4 8
)

$(P
$(B İpucu:) Sayıları iki ayrı diziye yerleştirmek işinize yarayabilir. Girilen sayıların tek veya çift olduklarını da aritmetik işlemler sayfasında öğrendiğiniz $(C %) (kalan) işlecinin sonucuna bakarak anlayabilirsiniz.
)

)

$(PROBLEM
Bir arkadaşınız yazdığı bir programın doğru çalışmadığını söylüyor.

$(P
Girişten beş tane sayı alan, bu sayıların karelerini bir diziye yerleştiren, ve sonunda da dizinin elemanlarını çıkışa yazdıran bir program yazmaya çalışmış ama programı doğru çalışmıyor.
)

$(P
Bu programın hatalarını giderin ve beklendiği gibi çalışmasını sağlayın:
)

---
import std.stdio;

void main() {
    int[5] kareler;

    writeln("5 tane sayı giriniz");

    int i = 0;
    while (i <= 5) {
        int sayı;
        write(i + 1, ". sayı: ");
        readf(" %s", &sayı);

        kareler[i] = sayı * sayı;
        ++i;
    }

    writeln("=== Sayıların Kareleri ===");
    while (i <= kareler.length) {
        write(kareler[i], " ");
        ++i;
    }

    writeln();
}
---

)

)

Macros:
        SUBTITLE=Diziler

        DESCRIPTION=D dilinde dizilerin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial diziler

SOZLER=
$(atama)
$(cokme)
$(degisken)
$(dinamik)
$(dizi)
$(eleman)
$(indeks)
$(kalan)
$(tanim)
$(topluluk)
