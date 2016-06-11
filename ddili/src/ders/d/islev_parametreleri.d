Ddoc

$(DERS_BOLUMU $(IX parametre) $(IX işlev parametresi) İşlev Parametreleri)

$(P
Bu bölümde parametrelerin işlevlere gönderilmeleri konusundaki ayrıntıları göreceğiz ve D'deki parametre çeşitlerini tanıyacağız.
)

$(P
Aslında bu bölümün konularının bazılarıyla önceki bölümlerde karşılaşmıştık.  Örneğin, $(LINK2 /ders/d/foreach_dongusu.html, foreach Döngüsü bölümünde) $(C ref) anahtar sözcüğünün elemanların kopyalarını değil, $(I kendilerini) kullandırdığını görmüştük.
)

$(P
Ek olarak, hem $(C const) ve $(C immutable) belirteçlerinin parametrelerle kullanımını hem de değer türleriyle referans türleri arasındaki farkları daha önceki bölümlerde görmüştük.
)

$(P
Önceki programlarda işlevlerin nasıl parametrelerini kullanarak sonuçlar ürettiklerini gördük. Örneğin, hiçbir yan etkisi olmayan ve işi yalnızca değer üretmek olan bir işlev şöyle yazılabiliyordu:
)

---
double seneSonuNotu(double vizeNotu, double finalNotu) {
    return vizeNotu * 0.4 + finalNotu * 0.6;
}
---

$(P
O işlevde vize notu ağırlığının %40, final notununkinin de %60 olarak hesaplandığını görebiliyoruz. O işlevi örneğin şu şekilde çağırabiliriz:
)

---
    int vizeOrtalaması = 76;
    int finalNotu = 80;

    writefln("Sene sonu notu: %2.0f",
             seneSonuNotu(vizeOrtalaması, finalNotu));
---

$(H5 $(IX kopyalanan parametre) $(IX parametre, kopyalanarak) Parametre her zaman kopyalanır)

$(P
Yukarıdaki kodun $(C vizeOrtalaması) ve $(C finalNotu) değişkenlerini $(I kullandığını) söylediğimizde aslında temelde bir hataya düşmüş oluruz çünkü aslında işlev tarafından kullanılanlar değişkenlerin kendileri değil, $(I kopyalarıdır).
)

$(P
Bu ayrım önemlidir çünkü parametrede yapılan değişiklik ancak kopyayı etkiler. Bunu yan etki üretmeye $(I çalışan) aşağıdaki işlevde görebiliriz. Bu işlev bir oyun karakterinin enerjisini azaltmak için yazılmış olsun:
)

---
void enerjisiniAzalt(double enerji) {
    enerji /= 4;
}
---

$(P
O işlevi denemek için yazılmış olan şu programa bakalım:
)

---
import std.stdio;

void enerjisiniAzalt(double enerji) {
    enerji /= 4;
}

void main() {
    double enerji = 100;

    enerjisiniAzalt(enerji);
    writeln("Yeni enerji: ", enerji);
}
---

$(P
Çıktısı:
)

$(SHELL
Yeni enerji: 100     $(SHELL_NOTE_WRONG Değişmedi)
)

$(P
$(C enerjisiniAzalt) işlevi parametresinin değerini dörtte birine düşürdüğü halde $(C main) içindeki $(C enerji) isimli değişkenin değeri aynı kalmaktadır. Bunun nedeni, $(C main) içindeki $(C enerji) ile $(C enerjisiniAzalt) işlevinin parametresi olan $(C enerji)'nin farklı değişkenler olmalarıdır. Parametre, $(C main) içindeki değişkenin $(I kopyasıdır).
)

$(P
Bu olayı biraz daha yakından incelemek için programa bazı çıktı ifadeleri yerleştirebiliriz:
)

---
import std.stdio;

void enerjisiniAzalt(double enerji) {
    writeln("İşleve girildiğinde       : ", enerji);
    enerji /= 4;
    writeln("İşlevden çıkılırken       : ", enerji);
}

void main() {
    double enerji = 100;

    writeln("İşlevi çağırmadan önce    : ", enerji);
    enerjisiniAzalt(enerji);
    writeln("İşlevden dönüldükten sonra: ", enerji);
}
---

$(P
Çıktısı:
)

$(SHELL
İşlevi çağırmadan önce    : 100
İşleve girildiğinde       : 100
İşlevden çıkılırken       : 25   $(SHELL_NOTE parametre değişir,)
İşlevden dönüldükten sonra: 100  $(SHELL_NOTE asıl enerji değişmez)
)

$(P
Çıktıdan anlaşıldığı gibi, isimleri aynı olsa da $(C main) içindeki $(C enerji) ile $(C enerjisiniAzalt) içindeki $(C enerji) farklı değişkenlerdir. İşleve $(C main) içindeki değişkenin değeri $(I kopyalanır) ve değişiklik bu kopyayı etkiler.
)

$(P
Bu, ilerideki bölümlerde göreceğimiz yapı nesnelerinde de böyledir: Yapı nesneleri de işlevlere kopyalanarak gönderilirler.
)

$(H5 $(IX referans parametre) $(IX parametre, referans olarak) Referans türlerinin eriştirdiği değişkenler kopyalanmazlar)

$(P
Dilim, eşleme tablosu, ve sınıf gibi referans türleri de işlevlere kopyalanırlar. Ancak, bu türlerin erişim sağladığı değişkenler (dilim ve eşleme tablosu elemanları ve sınıf nesneleri) kopyalanmazlar. Bu çeşit değişkenler işlevlere $(I referans) olarak geçirilirler. Parametre, asıl nesneye eriştiren yeni bir reeferanstır ve dolayısıyla, parametrede yapılan değişiklik asıl nesneyi değiştirir.
)

$(P
Dizgiler de dizi olduklarından bu durum onlar için de geçerlidir. Parametresinde değişiklik yapan şu işleve bakalım:
)

---
import std.stdio;

void başHarfiniNoktaYap(dchar[] dizgi) {
    dizgi[0] = '.';
}

void main() {
    dchar[] dizgi = "abc"d.dup;
    başHarfiniNoktaYap(dizgi);
    writeln(dizgi);
}
---

$(P
Parametrede yapılan değişiklik $(C main) içindeki asıl nesneyi değiştirmiştir:
)

$(SHELL
.bc
)

$(P
Buna rağmen, dilim ve eşleme tablosu değişkenlerinin kendileri yine de kopyalanırlar. Bu durum, parametre özellikle $(C ref) belirteci ile tanımlanmamışsa şaşırtıcı sonuçlar doğurabilir.
)

$(H6 Dilimlerin şaşırtıcı olabilen referans davranışları)

$(P
$(LINK2 /ders/d/dilimler.html, Başka Dizi Olanakları bölümünde) belirtildiği gibi, $(I bir dilime eleman eklenmesi paylaşımı sonlandırabilir). Paylaşım sonlanmışsa yukarıdaki $(C dizgi) gibi bir parametre artık asıl elemanlara erişim sağlamıyor demektir.
)

---
import std.stdio;

void sıfırEkle(int[] dilim) {
    dilim $(HILITE ~= 0);
    writefln("sıfırEkle() içindeyken: %s", dilim);
}

void main() {
    auto dilim = [ 1, 2 ];
    sıfırEkle(dilim);
    writefln("sıfırEkle()'den sonra : %s", dilim);
}
---

$(P
Yeni eleman yalnızca parametreye eklenir, çağıran taraftaki dilime değil:
)

$(SHELL
sıfırEkle() içindeyken: [1, 2, 0]
sıfırEkle()'den sonra : [1, 2]    $(SHELL_NOTE_WRONG 0 elemanı yok)
)

$(P
Yeni elemanların gerçekten de asıl dilime eklenmesi istendiğinde parametrenin $(C ref) olarak geçirilmesi gerekir:
)

---
void sıfırEkle($(HILITE ref) int[] dilim) {
    // ...
}
---

$(P
$(C ref) belirtecini biraz aşağıda göreceğiz.
)

$(H6 Eşleme tablolarının şaşırtıcı olabilen referans davranışları)

$(P
Eşleme tablosu çeşidinden olan parametreler de şaşırtıcı sonuçlar doğurabilirler. Bunun nedeni, eşleme tablolarının yaşamlarına boş olarak değil, $(C null) olarak başlamalarıdır.
)

$(P
$(C null), bu anlamda $(I ilklenmemiş eşleme tablosu) anlamına gelir. Eşleme tabloları ilk elemanları eklendiğinde otomatik olarak ilklenirler. Bunun bir etkisi olarak, eğer bir işlev $(C null) olan bir eşleme tablosuna bir eleman eklerse o eleman çağıran tarafta görülemez çünkü parametre ilklenmiştir ama çağıran taraftaki değişken yine $(C null)'dır:
)

---
import std.stdio;

void elemanEkle(int[string] tablo) {
    tablo$(HILITE ["kırmızı"] = 100);
    writefln("elemanEkle() içindeyken: %s", tablo);
}

void main() {
    int[string] tablo;    // ← null tablo
    elemanEkle(tablo);
    writefln("elemanEkle()'den sonra : %s", tablo);
}
---

$(P
Eklenen eleman çağıran taraftaki tabloya eklenmemiştir:
)

$(SHELL
elemanEkle() içindeyken: ["kırmızı":100]
elemanEkle()'den sonra : []    $(SHELL_NOTE_WRONG Elemanı yok)
)

$(P
Öte yandan, işleve gönderilen tablo $(C null) değilse, eklenen eleman o tabloda da görülür:
)

---
    int[string] tablo;
    tablo["mavi"] = 10;    // ← Bu sefer null değil
    elemanEkle(tablo);
---

$(P
Bu sefer, eklenen eleman çağıran taraftaki tabloda da görülür:
)

$(SHELL
elemanEkle() içindeyken: ["mavi":10, "kırmızı":100]
elemanEkle()'den sonra : ["mavi":10, $(HILITE "kırmızı":100)]
)

$(P
Bu yüzden, eşleme tablolarını da $(C ref) parametreler olarak geçirmek daha uygun olabilir.
)

$(H5 Parametre çeşitleri)

$(P
Parametrelerin işlevlere geçirilmeleri normalde yukarıdaki iki temel kurala uyar:
)

$(UL

$(LI Değer türleri kopyalanırlar. Asıl değişken ve parametre birbirlerinden bağımsızdır.)

$(LI Referans türleri de kopyalanırlar ama hem asıl değişken hem de parametre aynı nesneye erişim sağlarlar.)

)

$(P
Bunlar bir belirteç kullanılmadığı zaman varsayılan kurallardır. Bu genel kurallar aşağıdaki anahtar sözcükler yardımıyla değiştirilebilir.
)

$(H6 $(IX in, parametre) $(C in))

$(P
İşlevlerin değer veya yan etki üretebildiklerini görmüştük. $(C in) anahtar sözcüğü parametrenin işlev tarafından yalnızca giriş bilgisi olarak kullanıldığını belirtir. Bu tür parametreler değiştirilemezler. İngilizce'de "içeriye" anlamına gelen "in" parametrenin amacını daha açık ifade eder:
)

---
import std.stdio;

double ağırlıklıToplam($(HILITE in) double şimdikiToplam,
                       $(HILITE in) double ağırlık,
                       $(HILITE in) double eklenecekDeğer) {
    return şimdikiToplam + (ağırlık * eklenecekDeğer);
}

void main() {
    writeln(ağırlıklıToplam(1.23, 4.56, 7.89));
}
---

$(P
$(C in) parametreler değiştirilemezler:
)

---
void deneme(in int değer) {
    değer = 1;    $(DERLEME_HATASI)
}
---

$(H6 $(IX out, parametre) $(C out))

$(P
İşlevin ürettiği bilginin işlevden $(C return) anahtar sözcüğü ile döndürüldüğünü görmüştük. İşlevlerden tek değer döndürülebiliyor olması bazen kısıtlayıcı olabilir çünkü bazı işlevlerin birden fazla sonuç üretmesi istenir. ($(I Not: Aslında dönüş türü $(C Tuple) veya $(C struct) olduğunda işlevler birden fazla değer döndürebilirler. Bu olanakları ilerideki bölümlerde göreceğiz.))
)

$(P
"Dışarıya" anlamına gelen $(C out) belirteci, işlevlerin parametreleri yoluyla da sonuç üretmelerini sağlar. İşlev bu çeşit parametrelerin değerlerini atama yoluyla değiştirdiğinde, o değerler işlevi çağıran ortamda da sonuç olarak görülürler. Bilgi bir anlamda işlevden $(I dışarıya) gönderilmektedir.
)

$(P
Örnek olarak iki sayıyı bölen ve hem bölümü hem de kalanı üreten bir işleve bakalım. İşlevin dönüş değerini bölmenin sonucu için kullanırsak bölmeden kalanı da bir $(C out) parametre olarak döndürebiliriz:
)

---
import std.stdio;

int kalanlıBöl(in int bölünen, in int bölen, $(HILITE out) int kalan) {
    $(HILITE kalan = bölünen % bölen);
    return bölünen / bölen;
}

void main() {
    int kalan;
    int bölüm = kalanlıBöl(7, 3, kalan);

    writeln("bölüm: ", bölüm, ", kalan: ", kalan);
}
---

$(P
İşlevin $(C kalan) isimli parametresinin değiştirilmesi $(C main) içindeki $(C kalan)'ın değişmesine neden olur (isimlerinin aynı olması gerekmez):
)

$(SHELL
bölüm: 2, kalan: 1
)

$(P
Değerleri çağıran tarafta ne olursa olsun, işleve girildiğinde $(C out) parametreler öncelikle türlerinin ilk değerine dönüşürler:
)

---
import std.stdio;

void deneme(out int parametre) {
    writeln("İşleve girildiğinde   : ", parametre);
}

void main() {
    int değer = 100;

    writeln("İşlev çağrılmadan önce: ", değer);
    deneme(değer);
    writeln("İşlevden dönüldüğünde : ", değer);
}
---

$(P
O işlevde parametreye hiçbir değer atanmıyor bile olsa işleve girildiğinde parametrenin değeri $(C int)'in ilk değeri olmakta ve bu $(C main) içindeki değeri de etkilemektedir:
)

$(SHELL
İşlev çağrılmadan önce: 100
İşleve girildiğinde   : 0     $(SHELL_NOTE int.init değerinde)
İşlevden dönüldüğünde : 0
)

$(P
Görüldüğü gibi, $(C out) parametreler dışarıdan bilgi alamazlar, yalnızca dışarıya bilgi gönderebilirler.
)

$(P
$(C out) parametre yerine dönüş türü olarak $(C Tuple) veya $(C struct) kullanmak daha iyidir. Bunları ilerideki bölümlerde göreceğiz.
)

$(H6 $(IX const, parametre) $(C const))

$(P
Daha önce de gördüğümüz gibi, bu belirteç parametrenin işlev içinde değiştirilmeyeceği garantisini verir. Bu sayede, işlevi çağıranlar hem parametrede değişiklik yapılmadığını bilmiş olurlar, hem de işlev $(C const) veya $(C immutable) olan değişkenlerle de çağrılabilir:
)

---
import std.stdio;

dchar sonHarfi($(HILITE const) dchar[] dizgi) {
    return dizgi[$ - 1];
}

void main() {
    writeln(sonHarfi("sabit"));
}
---

$(H6 $(IX immutable, parametre) $(C immutable))

$(P
Daha önce de gördüğümüz gibi, bu belirteç parametrenin programın çalışması süresince değişmemesini şart koşar. Bu konuda ısrarlı olduğundan aşağıdaki işlevi ancak elemanları $(C immutable) olan dizgilerle çağırabiliriz (örneğin, dizgi hazır değerleriyle):
)

---
import std.stdio;

dchar[] karıştır($(HILITE immutable) dchar[] birinci,
                 $(HILITE immutable) dchar[] ikinci) {
    dchar[] sonuç;
    int i;

    for (i = 0; (i < birinci.length) && (i < ikinci.length); ++i) {
        sonuç ~= birinci[i];
        sonuç ~= ikinci[i];
    }

    sonuç ~= birinci[i..$];
    sonuç ~= ikinci[i..$];

    return sonuç;
}

void main() {
    writeln(karıştır("MERHABA", "dünya"));
}
---

$(P
Kısıtlayıcı bir belirteç olduğundan, $(C immutable)'ı ancak değişmezliğin gerçekten gerekli olduğu durumlarda kullanmanızı öneririm. Öte yandan, $(C const) parametreler genelde daha kullanışlıdır çünkü bunlar $(C const), $(C immutable), ve $(I değişebilen) değişkenlerin hepsini kabul ederler.
)

$(H6 $(IX ref, parametre) $(C ref))

$(P
İşleve normalde kopyalanarak geçirilecek olan bir değişkenin referans olarak geçirilmesini sağlar.
)

$(P
Yukarıda parametresi normalde kopyalandığı için istediğimiz gibi çalışmayan $(C enerjisiniAzalt) işlevinin $(C main) içindeki asıl değişkeni değiştirebilmesi için parametresini referans olarak alması gerekir:
)

---
import std.stdio;

void enerjisiniAzalt($(HILITE ref) double enerji) {
    enerji /= 4;
}

void main() {
    double enerji = 100;

    enerjisiniAzalt(enerji);
    writeln("Yeni enerji: ", enerji);
}
---

$(P
İşlev parametresinde yapılan değişiklik artık $(C main) içindeki $(C enerji)'nin değerini değiştirir:
)

$(SHELL
Yeni enerji: 25
)

$(P
Görüldüğü gibi, $(C ref) parametreler işlev içinde hem kullanılmak üzere giriş bilgisidirler, hem de sonuç üretmek üzere çıkış bilgisidirler. $(C ref) parametreler asıl değişkenlerin takma isimleri olarak da düşünülebilirler. Yukarıdaki işlev parametresi olan $(C enerji), $(C main) içindeki $(C enerji)'nin bir takma ismi gibi işlem görür. $(C ref) yoluyla yapılan değişiklik asıl değişkeni değiştirir.
)

$(P
$(C ref) parametreler işlevlerin yan etki üreten türden işlevler olmalarına neden olurlar: Dikkat ederseniz, $(C enerjisiniAzalt) işlevi değer üretmemekte, parametresinde bir değişiklik yapmaktadır.
)

$(P
$(I Fonksiyonel programlama) denen programlama yönteminde yan etkilerin özellikle azaltılmasına çalışılır. Hatta, bazı programlama dillerinde yan etkilere hiç izin verilmez. Değer üreten işlevlerin yan etkisi olan işlevlerden programcılık açısından daha üstün oldukları kabul edilir. İşlevlerinizi olabildiğince değer üretecek şekilde tasarlamanızı öneririm. İşlevlerin yan etkilerini azaltmak, onların daha anlaşılır ve daha kolay olmalarını sağlar.
)

$(P
Aynı işi fonksiyonel programlamaya uygun olacak şekilde gerçekleştirmek için (yani, değer üreten işlev kullanmak için) programı şöyle değiştirmek önerilir:
)

---
import std.stdio;

$(HILITE double düşükEnerji)(double enerji) {
    $(HILITE return enerji / 4);
}

void main() {
    double enerji = 100;

    $(HILITE enerji = düşükEnerji(enerji));
    writeln("Yeni enerji: ", enerji);
}
---

$(H6 $(C auto ref))

$(P
Bu belirteç yalnızca $(LINK2 /ders/d/sablonlar.html, şablonlarla) kullanılabilir. Bir sonraki bölümde göreceğimiz gibi, $(I sol değerler) $(C auto ref) parametrelere referans olarak, $(I sağ değerler) ise kopyalanarak geçirilirler.
)

$(H6 $(IX inout, parametre) $(C inout))

$(P
İsminin $(C in) ve $(C out) sözcüklerinden oluştuğuna bakıldığında bu belirtecin $(I hem giriş hem çıkış) anlamına geldiği düşünebilir ancak bu doğru değildir. Hem giriş hem çıkış anlamına gelen belirtecin $(C ref) olduğunu yukarıda gördük.
)

$(P
$(C inout), parametrenin $(I değişmezlik) bilgisini otomatik olarak çıkış değerine taşımaya yarar. Parametre $(C const), $(C immutable), veya $(I değişebilen) olduğunda dönüş değeri de $(C const), $(C immutable), veya $(I değişebilen) olur.
)

$(P
Bu belirtecin yararını görmek için kendisine verilen dilimin ortadaki elemanlarını yine dilim olarak döndüren bir işleve bakalım:
)

---
import std.stdio;

int[] ortadakileri(int[] dilim) {
    if (dilim.length) {
        --dilim.length;               // sondan kırp

        if (dilim.length) {
            dilim = dilim[1 .. $];    // baştan kırp
        }
    }

    return dilim;
}

void main() {
    int[] sayılar = [ 5, 6, 7, 8, 9 ];
    writeln(ortadakileri(sayılar));
}
---

$(P
Çıktısı:
)

$(SHELL
[6, 7, 8]
)

$(P
Kitabın bu noktasına kadar anladıklarımız doğrultusunda bu işlevin parametresinin aslında $(C const(int)[]) olarak bildirilmiş olması gerekir çünkü kendisine verilen dilimin elemanlarında değişiklik yapmamaktadır. Dikkat ederseniz, dilimin kendisinin değiştirilmesinde bir sakınca yoktur çünkü değiştirilen dilim işlevin çağrıldığı yerdeki dilim değil, onun kopyasıdır.
)

$(P
Ancak, işlev buna uygun olarak tekrar yazıldığında bir derleme hatası alınır:
)

---
int[] ortadakileri($(HILITE const(int)[]) dilim) {
    // ...
    return dilim;    $(DERLEME_HATASI)
}
---

$(P
Derleme hatası, elemanları değiştirilemeyen bir dilimin elemanları $(I değiştirilebilen) bir dilim olarak döndürülemeyeceğini bildirir:
)

$(SHELL
Error: cannot implicitly convert expression (dilim) of
type const(int)[] to int[]
)

$(P
Bunun çözümü olarak dönüş türünün de $(C const(int)[]) olarak belirlenmesi düşünülebilir:
)

---
$(HILITE const(int)[]) ortadakileri(const(int)[] dilim) {
    // ...
    return dilim;    // şimdi derlenir
}
---

$(P
Kod, yapılan o değişiklikle derlenir. Ancak, bu sefer ortaya farklı bir kısıtlama çıkmıştır: İşlev $(I değişebilen) elemanlardan oluşan bir dilimle bile çağrılmış olsa döndürdüğü dilim $(C const) elemanlardan oluşacaktır. Bunun zararını görmek için bir dilimin ortadaki elemanlarının on katlarını almaya çalışan şu koda bakalım:
)

---
    int[] ortadakiler = ortadakileri(sayılar); $(DERLEME_HATASI)
    ortadakiler[] *= 10;
---

$(P
İşlevin döndürdüğü $(C const(int)[]) türündeki dilimin $(C int[]) türündeki dilime atanamaması doğaldır:
)

$(SHELL
Error: cannot implicitly convert expression
(ortadakileri(sayılar)) of type const(int)[] to int[]
)

$(P
Asıl dilim değişebilen elemanlardan oluştuğu halde ortadaki bölümü üzerine böyle bir kısıtlama getirilmesi kullanışsızlıktır. İşte, $(C inout) değişmezlikle ilgili olan bu sorunu çözer. Bu anahtar sözcük hem parametrede hem de dönüş türünde kullanılır ve parametrenin değişebilme durumunu dönüş değerine taşır:
)

---
$(HILITE inout)(int)[] ortadakileri($(HILITE inout)(int)[] dilim) {
    // ...
    return dilim;
}
---

$(P
Aynı işlev artık $(C const), $(C immutable), ve $(I değişebilen) dilimlerle çağrılabilir:
)

---
    {
        $(HILITE int[]) sayılar = [ 5, 6, 7, 8, 9 ];
        // Dönüş türü değişebilen elemanlı dilimdir
        $(HILITE int[]) ortadakiler = ortadakileri(sayılar);
        ortadakiler[] *= 10;
        writeln(ortadakiler);
    }

    {
        $(HILITE immutable int[]) sayılar = [ 10, 11, 12 ];
        // Dönüş türü immutable elemanlı dilimdir
        $(HILITE immutable int[]) ortadakiler = ortadakileri(sayılar);
        writeln(ortadakiler);
    }

    {
        $(HILITE const int[]) sayılar = [ 13, 14, 15, 16 ];
        // Dönüş türü const elemanlı dilimdir
        $(HILITE const int[]) ortadakiler = ortadakileri(sayılar);
        writeln(ortadakiler);
    }
---

$(H6 $(IX lazy) $(C lazy))

$(P
Doğal olarak, parametre değerleri işlevler çağrılmadan $(I önce) işletilirler. Örneğin, $(C topla) gibi bir işlevi başka iki işlevin sonucu ile çağırdığımızı düşünelim:
)

---
    sonuç = topla(birMiktar(), başkaBirMiktar());
---

$(P
$(C topla)'nın çağrılabilmesi için öncelikle $(C birMiktar) ve $(C başkaBirMiktar) işlevlerinin çağrılmaları gerekir çünkü $(C topla) hangi iki değeri toplayacağını bilmek zorundadır.
)

$(P
İşlemlerin bu şekilde doğal olarak işletilmeleri $(I hevesli) olarak tanımlanır. Program, işlemleri öncelik sıralarına göre hevesle işletir.
)

$(P
Oysa bazı parametreler işlevin işleyişine bağlı olarak belki de hiçbir zaman kullanılmayacaklardır. Parametre değerlerinin hevesli olarak önceden işletilmeleri kullanılmayan parametrelerin gereksiz yere hesaplanmış olmalarına neden olacaktır.
)

$(P
Bunun bilinen bir örneği, programın işleyişiyle ilgili mesajlar yazdırmaya yarayan $(I log) işlevleridir. Bu işlevler kullanıcı ayarlarına bağlı olarak yalnızca yeterince öneme sahip olan mesajları yazdırırlar:
)

---
enum Önem { düşük, orta, yüksek }
// Not: Önem, İngilizce'de 'log level' olarak bilinir.

void logla(Önem önem, string mesaj) {
    if (önem >= önemAyarı) {
        writefln("%s", mesaj);
    }
}
---

$(P
Örneğin, eğer kullanıcı yalnızca $(C Önem.yüksek) değerli mesajlarla ilgileniyorsa, $(C Önem.orta) değerindeki mesajlar yazdırılmazlar. Buna rağmen, parametre değeri işlev çağrılmadan önce yine de hesaplanacaktır. Örneğin, aşağıdaki mesajı oluşturan $(C format) ifadesinin tamamı ($(C bağlantıDurumunuÖğren()) çağrısı dahil)  $(C logla) işlevi çağrılmadan önce işletilecek ama bu işlem mesaj yazdırılmadığı zaman boşa gitmiş olacaktır:
)

---
    if (!bağlanıldı_mı) {
        logla(Önem.orta,
              format("Hata. Bağlantı durumu: '%s'.",
                     bağlantıDurumunuÖğren()));
    }
---

$(P
$(C lazy) anahtar sözcüğü parametreyi oluşturan ifadenin yalnızca o parametre işlev içinde gerçekten kullanıldığında (ve her kullanıldığında) hesaplanacağını bildirir:
)

---
void logla(Önem önem, $(HILITE lazy) string mesaj) {
   // ... işlevin tanımı öncekiyle aynı ...
}
---

$(P
Artık ifade $(C mesaj) gerçekten kullanıldığında hesaplanır.
)

$(P
Dikkat edilmesi gereken bir nokta, $(C lazy) parametrenin değerinin o parametre $(I her kullanıldığında) hesaplanacağıdır.
)

$(P
Örneğin, aşağıdaki işlevin $(C lazy) parametresi üç kere kullanıldığından onu hesaplayan işlev de üç kere çağrılmaktadır:
)

---
import std.stdio;

int parametreyiHesaplayanİşlev() {
    writeln("Hesap yapılıyor");
    return 1;
}

void tembelParametreliİşlev(lazy int değer) {
    int sonuç = $(HILITE değer + değer + değer);
    writeln(sonuç);
}

void main() {
    tembelParametreliİşlev(parametreyiHesaplayanİşlev());
}
---

$(P
Çıktısı:
)

$(SHELL
Hesap yapılıyor
Hesap yapılıyor
Hesap yapılıyor
3
)

$(P
$(C lazy) belirtecini değeri ancak bazı durumlarda kullanılan parametreleri belirlemek için kullanabilirsiniz. Ancak, değerin birden fazla sayıda hesaplanabileceğini de unutmamak gerekir.
)

$(H6 $(IX scope) $(C scope))

$(P
Bu anahtar sözcük, parametrenin işlev tarafından bir kenara kaydedilmeyeceğini bildirir. Bir anlamda, işlevin o parametreyle işinin kısa olacağını garanti eder:
)

$(COMMENT_XXX Aşağıda DERLEME_HATASI makrosunu kullanmıyoruz çünkü 'scope' derleme hatasına neden olmadığından codetester hata veriyor.)

---
int[] modülDilimi;

int[] işlev($(HILITE scope) int[] parametre) {
    modülDilimi = parametre;    // ← derleme HATASI
    return parametre;           // ← derleme HATASI
}

void main() {
    int[] dilim = [ 10, 20 ];
    int[] sonuç = işlev(dilim);
}
---

$(P
O işlev $(C scope) ile verdiği sözü iki yerde bozmaktadır çünkü onu hem modül kapsamındaki bir dilime atamakta hem de dönüş değeri olarak kullanmaktadır. Bu davranışların ikisi de parametrenin işlevin sonlanmasından sonra da kullanılabilmelerine neden olacağından derleme hatasına neden olur.
)

$(P
($(I Not: Bu bölümdeki kodların en son denendikleri derleyici olan dmd 2.071 bu anahtar sözcüğü desteklemiyordu.
))
)

$(H6 $(IX shared, parametre) $(C shared))

$(P
Bu anahtar sözcük parametrenin iş parçacıkları arasında paylaşılabilen çeşitten olmasını gerektirir:
)

---
void işlev($(HILITE shared) int[] i) {
    // ...
}

void main() {
    int[] sayılar = [ 10, 20 ];
    işlev(sayılar);    $(DERLEME_HATASI)
}
---

$(P
Yukarıdaki program derlenemez çünkü parametre olarak kullanılan değişken $(C shared) değildir. Program aşağıdaki değişiklikle derlenebilir:
)

---
    $(HILITE shared) int[] sayılar = [ 10, 20 ];
    işlev(sayılar);    // şimdi derlenir
---

$(P
$(C shared) anahtar sözcüğünü ilerideki $(LINK2 /ders/d/es_zamanli_shared.html, Veri Paylaşarak Eş Zamanlı Programlama bölümünde) kullanacağız.
)

$(H6 $(IX return, parametre) $(C return))

$(P
Bazı durumlarda bir işlevin $(C ref) parametrelerinden birisini doğrudan döndürmesi istenebilir. Örneğin, aşağıdaki $(C seç()) işlevi rasgele seçtiği bir parametresini döndürmekte ve böylece çağıran taraftaki bir değişkenin doğrudan değiştirilmesi sağlanmaktadır:
)

---
import std.stdio;
import std.random;

$(HILITE ref) int seç($(HILITE ref) int soldaki, $(HILITE ref) int sağdaki) {
    return uniform(0, 2) ? soldaki : sağdaki;
}

void main() {
    int a;
    int b;

    seç(a, b) $(HILITE = 42);

    writefln("a: %s, b: %s", a, b);
}
---

$(P
Sonuçta $(C main()) içindeki $(C a) veya $(C b) değişkenlerinden birisinin değeri $(C 42) olur:
)

$(SHELL
a: 42, b: 0
)

$(SHELL
a: 0, b: 42
)

$(P
Ancak, bazı durumlarda $(C seç())'e gönderilen parametrelerin yaşam süreçleri döndürülen referansın yaşam sürecinden daha kısa olabilir. Örneğin, aşağıdaki $(C foo()) işlevi $(C seç())'i iki yerel değişkenle çağırmakta ve sonuçta kendisi bunlardan birisine referans döndürmüş olmaktadır:
)

---
import std.random;

ref int seç(ref int soldaki, ref int sağdaki) {
    return uniform(0, 2) ? soldaki : sağdaki;
}

ref int foo() {
    int a;
    int b;

    return seç(a, b);    $(CODE_NOTE_WRONG HATA: geçersiz referans döndürülüyor)
}

void main() {
    foo() = 42;          $(CODE_NOTE_WRONG HATA: yasal olmayan adrese yazılıyor)
}
---

$(P
$(C a) ve $(C b) değişkenlerinin yaşam süreçleri $(C foo())'dan çıkıldığında sona erdiğinden, $(C main()) içindeki atama işlemi yasal bir değişkene yapılamaz. Bu, $(I tanımsız davranıştır).
)

$(P
$(IX tanımsız davranış) Tanımsız davranış, programın davranışının programlama dili tarafından belirlenmediğini ifade eder. Tanımsız davranış içeren bir programın davranışı hakkında hiçbir şey söylenemez. (Olasılıkla, $(C 42) değeri daha önceden $(C a) veya $(C b) için kullanılan ama belki de artık ilgisiz bir değişkene ait olan bir bellek bölgesine yazılacak ve o değişkenin değerini önceden kestirilemeyecek biçimde bozacaktır.)
)

$(P
Parametreye uygulanan $(C return) anahtar sözcüğü böyle hataları önler. $(C return), o parametrenin döndürülen referanstan daha uzun yaşayan bir değişken olması gerektiğini bildirir:
)

---
import std.random;

ref int seç($(HILITE return) ref int soldaki, $(HILITE return) ref int sağdaki) {
    return uniform(0, 2) ? soldaki : sağdaki;
}

ref int foo() {
    int a;
    int b;

    return seç(a, b);    $(DERLEME_HATASI)
}

void main() {
    foo();
}
---

$(P
Derleyici bu sefer $(C seç())'e gönderilen değişkenlerin $(C foo())'nun döndürmeye çalıştığı referanstan daha kısa yaşadıklarını farkeder ve $(I yerel değişkene referans döndürülmekte) olduğunu bildiren bir hata verir:
)

$(SHELL
Error: escaping reference to local variable a
Error: escaping reference to local variable b
)

$(P
$(I Not: Derleyicinin böyle bir hatayı $(C return) anahtar sözcüğüne gerek kalmadan da görmüş olabileceği düşünülebilir. Ancak, bu her durumda mümkün değildir çünkü derleyici her derleme sırasında her işlevin içeriğini görmüyor olabilir.)
)

$(H5 Özet)

$(UL

$(LI $(I Parametre), işlevin işi için kullanılan bilgidir.
)

$(LI $(I Parametre değeri), işleve parametre olarak gönderilen bir ifadedir (örneğin bir değişken).
)

$(LI
Her parametre kopyalanarak gönderilir. Ancak, referans türlerinde kopyalanan asıl değişken değil, referansın kendisidir.
)

$(LI $(C in), parametrenin yalnızca bilgi girişi için kullanıldığını bildirir.)

$(LI $(C out), parametrenin yalnızca bilgi çıkışı için kullanıldığını bildirir.
)

$(LI $(C ref), parametrenin hem bilgi girişi hem de bilgi çıkışı için kullanıldığını bildirir.
)

$(LI $(C auto ref) yalnızca şablonlarla kullanılır. $(I Sol değerlerin) referans olarak, $(I sağ değerlerin) ise kopyalanarak geçirileceğini bildirir.)

$(LI $(C const), parametrenin işlev içinde değiştirilmediğini garanti eder. (Hatırlarsanız, $(C const) geçişlidir: böyle bir değişken aracılığıyla erişilen başka veriler de değiştirilemez.)
)

$(LI $(C immutable), parametre olarak kullanılan değişkenin $(C immutable) olması şartını getirir.
)

$(LI $(C inout) hem paremetrede hem de dönüş türünde kullanılır ve parametrenin $(C const), $(C immutable), veya $(I değişebilme) özelliğini dönüş türüne taşır.
)

$(LI $(C lazy), parametre olarak gönderilen ifadenin değerinin ancak o değer gerçekten kullanıldığında (ve her kullanıldığında) işletilmesini sağlar.
)

$(LI $(C scope), parametreye eriştiren herhangi bir referansın işlevden dışarıya sızdırılmayacağını bildirir.
)

$(LI $(C shared), parametre olarak kullanılan değişkenin $(C shared) olması şartını getirir.
)

$(LI $(C return), parametrenin döndürülen referanstan daha uzun yaşaması gerektiğini bildirir.
)

)

$(PROBLEM_TEK

$(P
Aşağıdaki işlev kendisine verilen iki parametrenin değerlerini değiş tokuş etmeye çalışmaktadır:
)

---
import std.stdio;

void değişTokuş(int birinci, int ikinci) {
    int geçici = birinci;
    birinci = ikinci;
    ikinci = geçici;
}

void main() {
    int birSayı = 1;
    int başkaSayı = 2;

    değişTokuş(birSayı, başkaSayı);

    writeln(birSayı, ' ', başkaSayı);
}
---

$(P
Ancak, işlev istendiği gibi çalışmamaktadır:
)

$(SHELL
1 2          $(SHELL_NOTE_WRONG değiş tokuş olmamış)
)

$(P
İşlevi düzeltin ve değişkenlerin değerlerinin değiş tokuş edilmelerini sağlayın.
)

)

Macros:
        SUBTITLE=İşlev Parametreleri

        DESCRIPTION=D dilinde işlev (fonksiyon) [function] parametrelerinin çeşitleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function parametre in out inout ref lazy const immutable scope shared

SOZLER=
$(atama)
$(degisken)
$(donus_degeri)
$(fonksiyonel_programlama)
$(hevesli)
$(is_parcacigi)
$(islev)
$(nesne)
$(parametre)
$(parametre_degeri)
$(referans)
$(sag_deger)
$(sol_deger)
$(tanimsiz_davranis)
$(yapi)
