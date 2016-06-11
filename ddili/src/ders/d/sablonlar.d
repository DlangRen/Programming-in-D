Ddoc

$(DERS_BOLUMU $(IX şablon) $(IX template) Şablonlar)

$(P
Şablonlar derleyicinin belirli bir kalıba uygun olarak kod üretmesini sağlayan olanaktır. Herhangi bir kod parçasının bazı bölümleri sonraya bırakılır; derleyici o kod bölümlerini uygun olan türler, değerler, vs. ile kendisi oluşturur.
)

$(P
Şablonlar algoritmaların ve veri yapılarının türden bağımsız olarak yazılabilmelerini sağlarlar ve bu yüzden özellikle kütüphanelerde çok yararlıdırlar.
)

$(P
D'nin şablon olanağı bazı başka dillerdekilerle karşılaştırıldığında çok güçlü ve çok kapsamlıdır. Bu yüzden şablonların bütün ayrıntılarına bu bölümde giremeyeceğim. Burada, gündelik kullanımda en çok karşılaşılan işlev, yapı, ve sınıf şablonlarının türlerle nasıl kullanıldıklarını göstereceğim.
)

$(P
Kendisine verilen değeri parantez içinde yazdıran basit bir işleve bakalım:
)

---
void parantezliYazdır(int değer) {
    writefln("(%s)", değer);
}
---

$(P
Parametresi $(C int) olarak tanımlandığından, o işlev yalnızca $(C int) türüyle veya otomatik olarak $(C int)'e dönüşebilen türlerle kullanılabilir. Derleyici, örneğin kesirli sayı türleriyle çağrılmasına izin vermez.
)

$(P
O işlevi kullanan programın zamanla geliştiğini ve artık başka türlerden olan değerlerin de parantez içinde yazdırılması gerektiğini düşünelim. Bunun için bir çözüm, D'nin işlev yükleme olanağıdır; aynı işlev başka türler için de tanımlanır:
)

---
// Daha önce yazılmış olan işlev
void parantezliYazdır(int değer) {
    writefln("(%s)", değer);
}

// İşlevin double türü için yüklenmesi
void parantezliYazdır($(HILITE double) değer) {
    writefln("(%s)", değer);
}
---

$(P
Bu da ancak belirli bir noktaya kadar yeterlidir çünkü bu işlevi bu sefer de örneğin $(C real) türüyle veya kendi tanımlamış olabileceğimiz başka türlerle kullanamayız. Tabii işlevi o türler için de yüklemeyi düşünebiliriz ama her tür için ayrı ayrı yazılmasının çok külfetli olacağı açıktır.
)

$(P
Burada dikkatinizi çekmek istediğim nokta, tür ne olursa olsun işlevin içeriğinin hep aynı olduğudur. Türler için yüklenen bu işlevdeki işlemler, $(I türden bağımsız olarak) hepsinde aynıdır. Benzer durumlar özellikle algoritmalarda ve veri yapılarında karşımıza çıkar.
)

$(P
Örneğin, ikili arama algoritması türden bağımsızdır: O algoritma yalnızca işlemlerle ilgilidir. Aynı biçimde, örneğin bağlı liste veri yapısı da türden bağımsızdır: Yalnızca topluluktaki elemanların nasıl bir arada tutulduklarını belirler.
)

$(P
İşte şablonlar bu gibi durumlarda yararlıdır: Kod bir kalıp halinde tarif edilir ve derleyici, programda kullanılan türler için kodu gerektikçe kendisi üretir.
)

$(H5 $(IX işlev şablonu) İşlev şablonları)

$(P
İşlevi bir kalıp olarak tarif etmek, içinde kullanılan bir veya daha fazla türün $(I belirsiz) olarak sonraya bırakılması anlamına gelir.
)

$(P
$(IX parametre, şablon) İşlevdeki hangi türlerin sonraya bırakıldıkları işlev parametrelerinden hemen önce yazılan şablon parametreleriyle belirtilir. Bu yüzden işlev şablonlarında iki adet parametre parantezi bulunur; birincisi şablon parametreleridir, ikincisi de işlev parametreleri:
)

---
void parantezliYazdır$(HILITE (T))(T değer) {
    writefln("(%s)", değer);
}
---

$(P
Yukarıda şablon parametresi olarak kullanılan $(C T), "bu işlevde T yazdığımız yerlerde asıl hangi türün kullanılacağına derleyici gerektikçe kendisi karar versin" anlamına gelir. $(C T) yerine herhangi başka bir isim de yazılabilir. Ancak, "type"ın baş harfi olduğu için $(C T) harfi gelenekleşmiştir. "Tür"ün baş harfine de uyduğu için aksine bir neden olmadığı sürece $(C T) kullanmak yerinde olacaktır.
)

$(P
O şablonu yukarıdaki gibi türden bağımsız olarak yazmak, kendi türlerimiz de dahil olmak üzere onu çeşitli türlerle çağırma olanağı sağlar:
)

---
import std.stdio;

void parantezliYazdır(T)(T değer) {
    writefln("(%s)", değer);
}

void main() {
    parantezliYazdır(42);           // int ile
    parantezliYazdır(1.2);          // double ile

    auto birDeğer = BirYapı();
    parantezliYazdır(birDeğer);     // BirYapı nesnesi ile
}

struct BirYapı {
    string toString() const {
        return "merhaba";
    }
}
---

$(P
Derleyici, programdaki kullanımlarına bakarak yukarıdaki işlev şablonunu gereken her tür için ayrı ayrı üretir. Program, sanki o işlev $(C T)'nin kullanıldığı üç farklı tür için, yani $(C int), $(C double), ve $(C BirYapı) için ayrı ayrı yazılmış gibi derlenir:
)

$(MONO
/* Not: Bu işlevlerin hiçbirisi programa dahil değildir.
 *      Derleyicinin kendi ürettiği işlevlerin eşdeğerleri
 *      olarak gösteriyorum. */

void parantezliYazdır($(HILITE int) değer) {
    writefln("(%s)", değer);
}

void parantezliYazdır($(HILITE double) değer) {
    writefln("(%s)", değer);
}

void parantezliYazdır($(HILITE BirYapı) değer) {
    writefln("(%s)", değer);
}
)

$(P
Programın çıktısı da o üç farklı işlevin etkisini gösterecek biçimde her tür için farklıdır:
)

$(SHELL
(42)
(1.2)
(merhaba)
)

$(P
Her şablon parametresi birden fazla işlev parametresini belirliyor olabilir. Örneğin, tek parametresi bulunan aşağıdaki şablonun hem iki işlev parametresinin hem de dönüş değerinin türü o şablon parametresi ile belirlenmektedir:
)

---
/* 'dilim'in 'değer'e eşit olmayan elemanlarından oluşan yeni
 * bir dilim döndürür. */
$(HILITE T)[] süz(T)(const($(HILITE T))[] dilim, $(HILITE T) değer) {
    T[] sonuç;

    foreach (eleman; dilim) {
        if (eleman != değer) {
            sonuç ~= eleman;
        }
    }

    return sonuç;
}
---

$(H5 Birden fazla şablon parametresi kullanılabilir)

$(P
Aynı işlevi, açma ve kapama parantezlerini de kullanıcıdan alacak şekilde değiştirdiğimizi düşünelim:
)

---
void parantezliYazdır(T)(T değer, char açma, char kapama) {
    writeln(açma, değer, kapama);
}
---

$(P
Artık o işlevi, istediğimiz parantez karakterleri ile çağırabiliriz:
)

---
    parantezliYazdır(42, '<', '>');
---

$(P
Parantezleri belirleyebiliyor olmak işlevin kullanışlılığını arttırmış olsa da, parantezlerin türünün $(C char) olarak sabitlenmiş olmaları işlevin kullanışlılığını tür açısından düşürmüştür. İşlevi örneğin ancak $(C wchar) ile ifade edilebilen Unicode karakterleri arasında yazdırmaya çalışsak, $(C wchar)'ın $(C char)'a dönüştürülemeyeceği ile ilgili bir derleme hatası alırız:
)

---
    parantezliYazdır(42, '→', '←');      $(DERLEME_HATASI)
---

$(SHELL_SMALL
Error: template deneme.parantezliYazdır(T) cannot deduce
template function from argument types !()(int,$(HILITE wchar),$(HILITE wchar))
)

$(P
Bunun bir çözümü, parantez karakterlerini her karakteri ifade edebilen $(C dchar) olarak tanımlamaktır. Bu da yetersiz olacaktır çünkü işlev bu sefer de örneğin $(C string) ile veya kendi özel türlerimizle kullanılamaz.
)

$(P
$(IX , (virgül), şablon parametre listesi) Başka bir çözüm, yine şablon olanağından yararlanmak ve parantezin türünü de derleyiciye bırakmaktır. Yapmamız gereken, işlev parametresi olarak $(C char) yerine yeni bir şablon parametresi kullanmak ve onu da şablon parametre listesinde belirtmektir:
)

---
void parantezliYazdır(T$(HILITE , ParantezTürü))(T değer,
                                       $(HILITE ParantezTürü) açma,
                                       $(HILITE ParantezTürü) kapama) {
    writeln(açma, değer, kapama);
}
---

$(P
Yeni şablon parametresinin anlamı da $(C T)'ninki gibidir: "bu işlev tanımında ParantezTürü geçen yerlerde hangi tür gerekiyorsa o kullanılsın".
)

$(P
Artık parantez olarak herhangi bir tür kullanılabilir. Örneğin $(C wchar) ve $(C string) türleriyle:
)

---
    parantezliYazdır(42, '→', '←');
    parantezliYazdır(1.2, "-=", "=-");
---

$(SHELL
→42←
-=1.2=-
)

$(P
Bu şablonun yararı, tek işlev tanımlamış olduğumuz halde $(C T) ve $(C ParantezTürü) şablon parametrelerinin otomatik olarak belirlenebilmeleridir.
)

$(H5 $(IX tür çıkarsama) $(IX çıkarsama, tür) Tür çıkarsama)

$(P
Derleyici yukarıdaki iki kullanımda şu türleri otomatik olarak seçer:
)

$(UL
$(LI 42'nin yazdırıldığı satırda $(C int) ve $(C wchar))
$(LI 1.2'nin yazdırıldığı satırda $(C double) ve $(C string))
)

$(P
İşlevin çağrıldığı noktalarda hangi türlerin gerektiği işlevin parametrelerinden kolayca anlaşılabilmektedir. Derleyicinin, türü işlev çağrılırken kullanılan parametrelerden anlamasına $(I tür çıkarsaması) denir.
)

$(P
Derleyici şablon parametrelerini ancak ve ancak işlev çağrılırken kullanılan türlerden çıkarsayabilir.
)

$(H5 $(IX tür belirtilmesi, şablon) Türün açıkça belirtilmesi)

$(P
Bazı durumlarda ise şablon parametreleri çıkarsanamazlar, çünkü örneğin işlevin parametresi olarak geçmiyorlardır. Öyle durumlarda derleyicinin şablonun kullanımına bakarak çıkarsaması olanaksızdır.
)

$(P
Örnek olarak kullanıcıya bir soru soran ve o soru karşılığında girişten bir değer okuyan bir işlev düşünelim; okuduğu değeri döndürüyor olsun. Ayrıca, bütün türler için kullanılabilmesi için de dönüş türünü sabitlemeyelim ve bir şablon parametresi olarak tanımlayalım:
)

---
$(HILITE T) giriştenOku$(HILITE (T))(string soru) {
    writef("%s (%s): ", soru, T.stringof);

    $(HILITE T) cevap;
    readf(" %s", &cevap);

    return cevap;
}
---

$(P
O işlev, girişten okuma işini türden bağımsız olarak gerçekleştirdiği için programda çok yararlı olacaktır. Örneğin, kullanıcı bilgilerini edinmek için şu şekilde çağırmayı düşünebiliriz:
)

---
    giriştenOku("Yaşınız?");
---

$(P
Ancak, o çağırma sırasında $(C T)'nin hangi türden olacağını belirten hiçbir ipucu yoktur. Soru işleve $(C string) olarak gitmektedir ama derleyici dönüş türü için hangi türü istediğimizi bilemez ve $(C T)'yi çıkarsayamadığını bildiren bir hata verir:
)

$(SHELL_SMALL
Error: template deneme.giriştenOku(T) $(HILITE cannot deduce) template
function from argument types !()(string)
)

$(P
$(IX !, şablon parametre değeri) Bu gibi durumlarda şablon parametrelerinin ne oldukları programcı tarafından açıkça belirtilmek zorundadır. Şablonun hangi türlerle üretileceği, yani şablon parametreleri, işlev isminden sonraki ünlem işareti ve hemen ardından gelen şablon parametre listesi ile bildirilir:
)

---
    giriştenOku$(HILITE !(int))("Yaşınız?");
---

$(P
O kod artık derlenir ve yukarıdaki şablon, $(C T) yerine $(C int) yazılmış gibi derlenir.
)

$(P
Tek şablon parametresi belirtilen durumlarda bir kolaylık olarak şablon parantezleri yazılmayabilir:
)

---
    giriştenOku$(HILITE !int)("Yaşınız?");    // üsttekinin eşdeğeri
---

$(P
O yazılışı şimdiye kadar çok kullandığımız $(C to!string)'den tanıyorsunuz. $(C to) bir işlev şablonudur. Ona verdiğimiz değerin hangi türe dönüştürüleceğini bir şablon parametresi olarak alır. Tek şablon parametresi gerektiği için de $(C to!(string)) yerine onun kısası olan $(C to!string) yazılır.
)

$(H5 $(IX özelleme, şablon) Şablon özellemeleri)

$(P
$(C giriştenOku) işlevini başka türlerle de kullanabiliriz. Ancak, derleyicinin ürettiği kod her tür için geçerli olmayabilir. Örneğin, iki boyutlu düzlemdeki bir noktayı ifade eden bir yapı olsun:
)

---
struct Nokta {
    int x;
    int y;
}
---

$(P
Her ne kadar yasal olarak derlenebilse de, $(C giriştenOku) şablonunu bu yapı ile kullanırsak şablon içindeki $(C readf) işlevi doğru çalışmaz. Şablon içinde $(C Nokta) türüne karşılık olarak üretilen kod şöyle olacaktır:
)

---
    Nokta cevap;
    readf(" %s", &cevap);    // YANLIŞ
---

$(P
Doğrusu, $(C Nokta)'yı oluşturacak olan x ve y değerlerinin girişten ayrı ayrı okunmaları ve nesnenin bu değerlerle $(I kurulmasıdır).
)

$(P
Böyle durumlarda, şablonun belirli bir tür için özel olarak tanımlanmasına $(I özelleme) denir. Hangi tür için özellendiği, şablon parametre listesinde  $(C :) karakterinden sonra yazılarak belirtilir:
)

---
// Şablonun genel tanımı (yukarıdakinin aynısı)
T giriştenOku(T)(string soru) {
    writef("%s (%s): ", soru, T.stringof);

    T cevap;
    readf(" %s", &cevap);

    return cevap;
}

// Şablonun Nokta türü için özellenmesi
T giriştenOku(T $(HILITE : Nokta))(string soru) {
    writefln("%s (Nokta)", soru);

    auto x = giriştenOku!int("  x");
    auto y = giriştenOku!int("  y");

    return Nokta(x, y);
}
---

$(P
$(C giriştenOku) işlevi bir $(C Nokta) için çağrıldığında, derleyici artık o özel tanımı kullanır:
)

---
    auto merkez = giriştenOku!Nokta("Merkez?");
---

$(P
O işlev de kendi içinde $(C giriştenOku!int)'i iki kere çağırarak x ve y değerlerini ayrı ayrı okur:
)

$(SHELL_SMALL
Merkez? (Nokta)
  x (int): 11
  y (int): 22
)

$(P
$(C giriştenOku!int) çağrıları şablonun genel tanımına, $(C giriştenOku!Nokta) çağrıları da şablonun özel tanımına yönlendirilecektir.
)

$(P
Başka bir örnek olarak, şablonu $(C string) ile kullanmayı da düşünebiliriz. Ne yazık ki şablonun genel tanımı $(I girişin sonuna kadar) okunmasına neden olur:
)

---
    // bütün girişi okur:
    auto isim = giriştenOku!string("İsminiz?");
---

$(P
Eğer $(C string)'lerin tek satır olarak okunmalarının uygun olduğunu kabul edersek, bu durumda da çözüm şablonu $(C string) için $(I özel) olarak tanımlamaktır:
)

---
T giriştenOku(T $(HILITE : string))(string soru) {
    writef("%s (string): ", soru);

    // Bir önceki kullanıcı girişinin sonunda kalmış
    // olabilecek boşluk karakterlerini de oku ve gözardı et
    string cevap;
    do {
        cevap = strip(readln());
    } while (cevap.length == 0);

    return cevap;
}
---

$(H5 $(IX yapı şablonu) $(IX sınıf şablonu) Yapı ve sınıf şablonları)

$(P
Yukarıdaki $(C Nokta) sınıfının iki üyesi $(C int) olarak tanımlandığından, işlev şablonlarında karşılaştığımız yetersizlik onda da vardır.
)

$(P
$(C Nokta) yapısının daha kapsamlı olduğunu düşünelim. Örneğin, kendisine verilen başka bir noktaya olan uzaklığını hesaplayabilsin:
)

---
import std.math;

// ...

struct Nokta {
    int x;
    int y;

    int uzaklık(in Nokta diğerNokta) const {
        immutable real xFarkı = x - diğerNokta.x;
        immutable real yFarkı = y - diğerNokta.y;

        immutable uzaklık = sqrt((xFarkı * xFarkı) +
                                 (yFarkı * yFarkı));

        return cast(int)uzaklık;
    }
}
---

$(P
O yapı, örneğin kilometre duyarlığındaki uygulamalarda yeterlidir:
)

---
    auto merkez = giriştenOku!Nokta("Merkez?");
    auto şube = giriştenOku!Nokta("Şube?");

    writeln("Uzaklık: ", merkez.uzaklık(şube));
---

$(P
Ancak, kesirli değerler gerektiren daha hassas uygulamalarda kullanışsızdır.
)

$(P
Yapı ve sınıf şablonları, onları da belirli bir kalıba uygun olarak tanımlama olanağı sağlarlar. Bu durumda, yapıya $(C (T)) parametresi eklemek ve tanımındaki $(C int)'ler yerine $(C T) kullanmak, bu tanımın bir şablon haline gelmesi ve üyelerin türlerinin derleyici tarafından belirlenmesi için yeterlidir:
)

---
struct Nokta$(HILITE (T)) {
    $(HILITE T) x;
    $(HILITE T) y;

    $(HILITE T) uzaklık(in Nokta diğerNokta) const {
        immutable real xFarkı = x - diğerNokta.x;
        immutable real yFarkı = y - diğerNokta.y;

        immutable uzaklık = sqrt((xFarkı * xFarkı) +
                                 (yFarkı * yFarkı));

        return cast($(HILITE T))uzaklık;
    }
}
---

$(P
Yapı ve sınıflar işlev olmadıklarından, çağrılmaları söz konusu değildir. O yüzden derleyicinin şablon parametrelerini çıkarsaması olanaksızdır; türleri açıkça belirtmemiz gerekir:
)

---
    auto merkez = Nokta$(HILITE !int)(0, 0);
    auto şube = Nokta$(HILITE !int)(100, 100);

    writeln("Uzaklık: ", merkez.uzaklık(şube));
---

$(P
Yukarıdaki kullanım, derleyicinin $(C Nokta) şablonunu $(C T) yerine $(C int) gelecek şekilde üretmesini sağlar. Bir şablon olduğundan başka türlerle de kullanabiliriz. Örneğin, virgülden sonrasının önemli olduğu bir uygulamada:
)

---
    auto nokta1 = Nokta$(HILITE !double)(1.2, 3.4);
    auto nokta2 = Nokta$(HILITE !double)(5.6, 7.8);

    writeln(nokta1.uzaklık(nokta2));
---

$(P
Yapı ve sınıf şablonları, veri yapılarını böyle türden bağımsız olarak tanımlama olanağı sağlar. Dikkat ederseniz, $(C Nokta) şablonundaki üyeler ve işlemler tamamen $(C T)'nin asıl türünden bağımsız olarak yazılmışlardır.
)

$(P
$(C Nokta)'nın artık bir yapı şablonu olması, $(C giriştenOku) işlev şablonunun daha önce yazmış olduğumuz $(C Nokta) özellemesinde bir sorun oluşturur:
)

---
T giriştenOku(T : Nokta)(string soru) {    $(DERLEME_HATASI)
    writefln("%s (Nokta)", soru);

    auto x = giriştenOku!int("  x");
    auto y = giriştenOku!int("  y");

    return Nokta(x, y);
}
---

$(P
Hatanın nedeni, artık $(C Nokta) diye bir tür bulunmamasıdır: $(C Nokta) artık bir tür değil, bir $(I yapı şablonudur). Bir tür olarak kabul edilebilmesi için, mutlaka şablon parametresinin de belirtilmesi gerekir. $(C giriştenOku) işlev şablonunu $(I bütün Nokta kullanımları için) özellemek için aşağıdaki değişiklikleri yapabiliriz. Açıklamalarını koddan sonra yapacağım:
)

---
Nokta!T giriştenOku(T : Nokta!T)(string soru) {   // 2, 1
    writefln("%s (Nokta!%s)", soru, T.stringof);  // 5

    auto x = giriştenOku!T("  x");                // 3a
    auto y = giriştenOku!T("  y");                // 3b

    return Nokta!T(x, y);                         // 4
}
---

$(OL

$(LI Bu işlev şablonu özellemesinin $(C Nokta)'nın bütün kullanımlarını desteklemesi için, şablon parametre listesinde $(C Nokta!T) yazılması gerekir; bir anlamda, $(C T) ne olursa olsun, bu özellemenin $(C Nokta!T) türleri için olduğu belirtilmektedir: $(C Nokta!int), $(C Nokta!double), vs.)

$(LI Girişten okunan türe uyması için dönüş türünün de $(C Nokta!T) olarak belirtilmesi gerekir.)

$(LI Bu işlevin önceki tanımında olduğu gibi $(C giriştenOku!int)'i çağıramayız çünkü $(C Nokta)'nın üyeleri herhangi bir türden olabilir. Bu yüzden, $(C T) ne ise, $(C giriştenOku) şablonunu o türden değer okuyacak şekilde, yani $(C giriştenOku!T) şeklinde çağırmamız gerekir.)

$(LI 1 ve 2 numaralı maddelere benzer şekilde, döndürdüğümüz değer de bir $(C Nokta!T) olmak zorundadır.)

$(LI Okumakta olduğumuz türün "(Nokta)" yerine örneğin "(Nokta!double)" olarak bildirilmesi için şablon türünün ismini $(C T.stringof)'tan ediniyoruz.)

)

$(H5 $(IX varsayılan şablon parametresi) Varsayılan şablon parametreleri)

$(P
Şablonların getirdiği bu esneklik çok kullanışlı olsa da şablon parametrelerinin her durumda belirtilmeleri bazen gereksiz olabilir. Örneğin, $(C giriştenOku) işlev şablonu programda hemen hemen her yerde $(C int) ile kullanılıyordur ve belki de yalnızca bir kaç noktada örneğin $(C double) ile de kullanılıyordur.
)

$(P
Böyle durumlarda şablon parametrelerine varsayılan türler verilebilir ve açıkça belirtilmediğinde o türler kullanılır. Varsayılan şablon parametre türleri $(C =) karakterinden sonra belirtilir:
)

---
T giriştenOku(T $(HILITE = int))(string soru) {
    // ...
}

// ...

    auto yaş = giriştenOku("Yaşınız?");
---

$(P
Yukarıdaki işlev çağrısında şablon parametresi belirtilmediği halde $(C int) varsayılır; yukarıdaki çağrı $(C giriştenOku!int) ile aynıdır.
)

$(P
Yapı ve sınıf şablonları için de varsayılan parametre türleri bildirilebilir. Ancak, şablon parametre listesinin boş olsa bile yazılması şarttır:
)

---
struct Nokta(T = int) {
    // ...
}

// ...

    Nokta!$(HILITE ()) merkez;
---

$(P
$(LINK2 /ders/d/parametre_serbestligi.html, Parametre Serbestliği bölümünde) işlev parametreleri için anlatılana benzer şekilde, varsayılan şablon parametreleri ya bütün parametreler için ya da yalnızca sondaki parametreler için belirtilebilir:
)

---
void birŞablon(T0, T1 $(HILITE = int), T2 $(HILITE = char))() {
    // ...
}
---

$(P
O şablonun son iki parametresinin belirtilmesi gerekmez ama birincisi şarttır:
)

---
    birŞablon!string();
---

$(P
O kullanımda ikinci parametre $(C int), üçüncü parametre de $(C char) olur.
)

$(H5 Her şablon gerçekleştirmesi farklı bir türdür)

$(P
Bir şablonun belirli bir tür veya türler için üretilmesi yepyeni bir tür oluşturur. Örneğin $(C Nokta!int) başlıbaşına bir türdür. Aynı şekilde, $(C Nokta!double) da başlıbaşına bir türdür.
)

$(P
Bu türler birbirlerinden farklıdırlar:
)

---
Nokta!int nokta3 = Nokta!double(0.25, 0.75); $(DERLEME_HATASI)
---

$(P
Türlerin uyumsuz olduklarını gösteren bir derleme hatası alınır:
)

$(SHELL_SMALL
Error: cannot implicitly convert expression (Nokta(0.25,0.75))
of type $(HILITE Nokta!(double)) to $(HILITE Nokta!(int))
)

$(H5 Derleme zamanı olanağıdır)

$(P
Şablon olanağı bütünüyle derleme zamanında işleyen ve derleyici tarafından işletilen bir olanaktır. Derleyicinin kod üretmesiyle ilgili olduğundan, program çalışmaya başladığında şablonların koda çevrilmeleri ve derlenmeleri çoktan tamamlanmıştır.
)

$(H5 Sınıf şablonu örneği: yığın veri yapısı)

$(P
Yapı ve sınıf şablonları $(I veri yapılarında) çok kullanılırlar. Bunun bir örneğini görmek için bir $(I yığın topluluğu) (stack container) tanımlayalım.
)

$(P
Yığın topluluğu veri yapılarının en basit olanlarındandır: Elemanların üst üste durdukları düşünülür. Eklenen her eleman en üste yerleştirilir ve yalnızca bu üstteki elemana erişilebilir. Topluluktan eleman çıkartılmak istendiğinde de yalnızca en üstteki eleman çıkartılabilir.
)

$(P
Kullanışlı olsun diye topluluktaki eleman sayısını veren bir nitelik de tasarlarsak, bu basit veri yapısının işlemlerini şöyle sıralayabiliriz:
)

$(UL
$(LI Eleman eklemek)
$(LI Eleman çıkartmak)
$(LI Üsttekine eriştirmek)
$(LI Eleman adedini bildirmek)
)

$(P
Bu veri yapısını gerçekleştirmek için D'nin iç olanaklarından olan dizilerden yararlanabiliriz. Dizinin sonuncu elemanı, yığın topluluğunun $(I üstteki) elemanı olarak kabul edilebilir.
)

$(P
Dizi elemanı türünü de sabit bir tür olarak yazmak yerine şablon parametresi olarak belirlersek, bu veri yapısını her türle kullanabilecek şekilde şöyle tanımlayabiliriz:
)

---
$(CODE_NAME Yığın)class Yığın$(HILITE (T)) {
private:

    $(HILITE T)[] elemanlar;

public:

    void ekle($(HILITE T) eleman) {
        elemanlar ~= eleman;
    }

    void çıkart() {
        --elemanlar.length;
    }

    $(HILITE T) üstteki() const @property {
        return elemanlar[$ - 1];
    }

    size_t uzunluk() const @property {
        return elemanlar.length;
    }
}
---

$(P
Ekleme ve çıkartma işlemlerinin üye işlevler olmaları doğaldır. $(C üstteki) ve $(C uzunluk) işlevlerini ise nitelik olarak tanımlamayı daha uygun buldum. Çünkü ikisi de bu veri yapısıyla ilgili basit bir bilgi sunuyorlar.
)

$(P
Bu sınıf için bir $(C unittest) bloğu tanımlayarak beklediğimiz şekilde çalıştığından emin olabiliriz. Aşağıdaki blok bu türü $(C int) türündeki elemanlarla kullanıyor:
)

---
unittest {
    auto yığın = new Yığın$(HILITE !int);

    // Eklenen eleman üstte görünmeli
    yığın.ekle(42);
    assert(yığın.üstteki == 42);
    assert(yığın.uzunluk == 1);

    // .üstteki ve .uzunluk elemanları etkilememeli
    assert(yığın.üstteki == 42);
    assert(yığın.uzunluk == 1);

    // Yeni eklenen eleman üstte görünmeli
    yığın.ekle(100);
    assert(yığın.üstteki == 100);
    assert(yığın.uzunluk == 2);

    // Eleman çıkartılınca önceki görünmeli
    yığın.çıkart();
    assert(yığın.üstteki == 42);
    assert(yığın.uzunluk == 1);

    // Son eleman çıkartılınca boş kalmalı
    yığın.çıkart();
    assert(yığın.uzunluk == 0);
}
---

$(P
Bu veri yapısını bir şablon olarak tanımlamış olmanın yararını görmek için onu kendi tanımladığımız bir türle kullanalım:
)

---
struct Nokta(T) {
    T x;
    T y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}
---

$(P
$(C double) türünde üyeleri bulunan $(C Nokta)'ları içeren bir $(C Yığın) şablonu şöyle oluşturulabilir:
)

---
    auto noktalar = new Yığın!(Nokta!double);
---

$(P
Bu veri yapısına on tane rasgele değerli nokta ekleyen ve sonra onları teker teker çıkartan bir deneme programı şöyle yazılabilir:
)

---
$(CODE_XREF Yığın)import std.string;
import std.stdio;
import std.random;

struct Nokta(T) {
    T x;
    T y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}

// -0.50 ile 0.50 arasında rasgele bir değer döndürür
double rasgele_double()
out (sonuç) {
    assert((sonuç >= -0.50) && (sonuç < 0.50));

} body {
    return (double(uniform(0, 100)) - 50) / 100;
}

// Belirtilen sayıda rasgele Nokta!double içeren bir Yığın
// döndürür
Yığın!(Nokta!double) rasgeleNoktalar(size_t adet)
out (sonuç) {
    assert(sonuç.uzunluk == adet);

} body {
    auto noktalar = new Yığın!(Nokta!double);

    foreach (i; 0 .. adet) {
        immutable nokta = Nokta!double(rasgele_double(),
                                       rasgele_double());
        writeln("ekliyorum   : ", nokta);
        noktalar.ekle(nokta);
    }

    return noktalar;
}

void main() {
    auto üstÜsteNoktalar = rasgeleNoktalar(10);

    while (üstÜsteNoktalar.uzunluk) {
        writeln("çıkartıyorum: ", üstÜsteNoktalar.üstteki);
        üstÜsteNoktalar.çıkart();
    }
}
---

$(P
Programın çıktısından anlaşılacağı gibi, eklenenlerle çıkartılanlar ters sırada olmaktadır:
)

$(SHELL_SMALL
ekliyorum   : (0.02,0.1)
ekliyorum   : (0.23,-0.34)
ekliyorum   : (0.47,0.39)
ekliyorum   : (0.03,-0.05)
ekliyorum   : (0.01,-0.47)
ekliyorum   : (-0.25,0.02)
ekliyorum   : (0.39,0.35)
ekliyorum   : (0.32,0.31)
ekliyorum   : (0.02,-0.27)
ekliyorum   : (0.25,0.24)
çıkartıyorum: (0.25,0.24)
çıkartıyorum: (0.02,-0.27)
çıkartıyorum: (0.32,0.31)
çıkartıyorum: (0.39,0.35)
çıkartıyorum: (-0.25,0.02)
çıkartıyorum: (0.01,-0.47)
çıkartıyorum: (0.03,-0.05)
çıkartıyorum: (0.47,0.39)
çıkartıyorum: (0.23,-0.34)
çıkartıyorum: (0.02,0.1)
)

$(H5 İşlev şablonu örneği: ikili arama algoritması)

$(P
İkili arama algoritması, bir dizi halinde yan yana ve sıralı olarak duran değerler arasında arama yapan en hızlı algoritmadır. Bu algoritmanın bir diğer adı "ikiye bölerek arama", İngilizcesi de "binary search"tür.
)

$(P
Çok basit bir algoritmadır: Sıralı olarak duran değerlerin ortadakine bakılır. Eğer aranan değere eşitse, değer bulunmuş demektir. Eğer değilse, o orta değerin aranan değerden daha küçük veya büyük olmasına göre ya sol yarıda ya da sağ yarıda aynı algoritma tekrarlanır.
)

$(P
Böyle kendisini tekrarlayarak tarif edilen algoritmalar $(I özyinelemeli) olarak $(I da) programlanabilirler. Ben de bu işlevi  yukarıdaki tanımına da çok uyduğu için kendisini çağıran bir işlev olarak yazacağım.
)

$(P
İşlevi şablon olarak yazmak yerine, önce $(C int) için gerçekleştireceğim. Ondan sonra algoritmada kullanılan $(C int)'leri $(C T) yaparak onu bir şablona dönüştüreceğim.
)

---
/* Aranan değer dizide varsa değerin indeksini, yoksa
 * size_t.max döndürür. */
size_t ikiliAra(const int[] değerler, in int değer) {
    // Dizi boşsa bulamadık demektir.
    if (değerler.length == 0) {
        return size_t.max;
    }

    immutable ortaNokta = değerler.length / 2;

    if (değer == değerler[ortaNokta]) {
        // Bulduk.
        return ortaNokta;

    } else if (değer < değerler[ortaNokta]) {
        // Sol tarafta aramaya devam etmeliyiz
        return ikiliAra(değerler[0 .. ortaNokta], değer);

    } else {
        // Sağ tarafta aramaya devam etmeliyiz
        auto indeks =
            ikiliAra(değerler[ortaNokta + 1 .. $], değer);

        if (indeks != size_t.max) {
            // İndeksi düzeltmemiz gerekiyor çünkü bu noktada
            // indeks, sağ taraftaki dilim ile ilgili olan
            // ve sıfırdan başlayan bir değerdedir.
            indeks += ortaNokta + 1;
        }

        return indeks;
    }

    assert(false, "Bu satıra hiç gelinmemeliydi");
}
---

$(P
Yukarıdaki işlev bu basit algoritmayı şu dört adım halinde gerçekleştiriyor:
)

$(UL
$(LI Dizi boşsa bulamadığımızı bildirmek için $(C size_t.max) döndür.)
$(LI Ortadaki değer aranan değere eşitse ortadaki değerin indeksini döndür.)
$(LI Aranan değer ortadaki değerden önceyse aynı işlevi sol tarafta devam ettir.)
$(LI Değilse aynı işlevi sağ tarafta devam ettir.)
)

$(P
O işlevi deneyen bir kod da şöyle yazılabilir:
)

---
unittest {
    auto dizi = [ 1, 2, 3, 5 ];
    assert(ikiliAra(dizi, 0) == size_t.max);
    assert(ikiliAra(dizi, 1) == 0);
    assert(ikiliAra(dizi, 4) == size_t.max);
    assert(ikiliAra(dizi, 5) == 3);
    assert(ikiliAra(dizi, 6) == size_t.max);
}
---

$(P
O işlevi bir kere $(C int) dizileri için yazıp doğru çalıştığından emin olduktan sonra, şimdi artık bir şablon haline getirebiliriz. Dikkat ederseniz, işlevin tanımında yalnızca iki yerde $(C int) geçiyor:
)

---
size_t ikiliAra(const int[] değerler, in int değer) {
    // ... burada hiç int bulunmuyor ...
}
---

$(P
Parametrelerde geçen $(C int)'ler bu işlevin kullanılabildiği değerlerin türünü belirlemekteler. Onları şablon parametreleri olarak tanımlamak bu işlevin bir şablon haline gelmesi ve dolayısıyla başka türlerle de kullanılabilmesi için yeterlidir:
)

---
size_t ikiliAra$(HILITE (T))(const $(HILITE T)[] değerler, in $(HILITE T) değer) {
    // ...
}
---

$(P
Artık o işlevi içindeki işlemlere uyan her türle kullanabiliriz. Dikkat ederseniz, elemanlar işlev içinde yalnızca $(C ==) ve $(C <) işleçleriyle kullanılıyorlar:
)

---
    if (değer $(HILITE ==) değerler[ortaNokta]) {
        // ...

    } else if (değer $(HILITE <) değerler[ortaNokta]) {
        // ...
---

$(P
O yüzden, yukarıda tanımladığımız $(C Nokta) şablonu henüz bu türle kullanılmaya hazır değildir:
)

---
import std.string;

struct Nokta(T) {
    T x;
    T y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}

void $(CODE_DONT_TEST)main() {
    Nokta!int[] noktalar;

    foreach (i; 0 .. 15) {
        noktalar ~= Nokta!int(i, i);
    }

    assert(ikiliAra(noktalar, Nokta!int(10, 10)) == 10);
}
---

$(P
Bir derleme hatası alırız:
)

$(SHELL_SMALL
Error: need member function $(HILITE opCmp()) for struct
const(Nokta!(int)) to compare
)

$(P
O hata, $(C Nokta!int)'in bir karşılaştırma işleminde kullanılabilmesi için $(C opCmp) işlevinin tanımlanmış olması gerektiğini bildirir. Bu eksikliği gidermek için $(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme bölümünde) gösterildiği biçimde bir $(C opCmp) tanımladığımızda program artık derlenir ve ikili arama işlevi $(C Nokta) şablonu ile de kullanılabilir:
)

---
struct Nokta(T) {
// ...

    int opCmp(const ref Nokta sağdaki) const {
        return (x == sağdaki.x
                ? y - sağdaki.y
                : x - sağdaki.x);
    }
}
---

$(H5 Özet)

$(P
Şablonlar bu bölümde gösterdiklerimden çok daha kapsamlıdır. Devamını sonraya bırakarak bu bölümü şöyle özetleyebiliriz:
)

$(UL

$(LI Şablonlar kodun kalıp halinde tarif edilmesini ve derleyici tarafından gereken her tür için otomatik olarak üretilmesini sağlayan olanaktır.)

$(LI Şablonlar bütünüyle derleme zamanında işleyen bir olanaktır.)

$(LI Tanımlarken isimlerinden sonra şablon parametresi de belirtmek; işlevlerin, yapıların, ve sınıfların şablon haline gelmeleri için yeterlidir.

---
void işlevŞablonu$(HILITE (T))(T işlevParametresi) {
    // ...
}

class SınıfŞablonu$(HILITE (T)) {
    // ...
}
---

)

$(LI Şablon parametreleri ünlem işaretinden sonra açıkça belirtilebilirler. Tek parametre için parantez kullanmaya gerek yoktur.

---
    auto nesne1 = new SınıfŞablonu!(double);
    auto nesne2 = new SınıfŞablonu!double;    // aynı şey
---

)

$(LI Şablonun farklı türlerle her kullanımı farklı bir türdür.

---
    assert(typeid(SınıfŞablonu!$(HILITE int)) !=
           typeid(SınıfŞablonu!$(HILITE uint)));
---

)

$(LI Şablon parametreleri yalnızca işlev şablonlarında çıkarsanabilirler.

---
    işlevŞablonu(42);    // işlevŞablonu!int(42) çağrılır
---

)

$(LI Şablonlar $(C :) karakterinden sonra belirtilen tür için özellenebilirler.

---
class SınıfŞablonu(T $(HILITE : dchar)) {
    // ...
}
---

)

$(LI Varsayılan şablon parametre türleri $(C =) karakterinden sonra belirtilebilir.

---
void işlevŞablonu(T $(HILITE = long))(T işlevParametresi) {
    // ...
}
---

)

$(LI $(C pragma(msg)) şablon yazarken yararlı olabilir.)

)

Macros:
        SUBTITLE=Şablonlar

        DESCRIPTION=Derleyicinin belirli bir kalıba uygun olarak kod üretmesini sağlayan şablon (template) olanağı; D'nin 'türden bağımsız programlama'ya getirdiği çözüm

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial şablon şablonlar template türden bağımsız programlama generic programming işlev şablonu yapı şablonu sınıf şablonu

SOZLER=
$(algoritma)
$(anahtar_sozcuk)
$(baglayici)
$(bagli_liste)
$(calisma_ortami)
$(cikarsama)
$(indeks)
$(kisitlama)
$(nitelik)
$(ozelleme)
$(ozyineleme)
$(sablon)
$(tasma)
$(topluluk)
$(ozgun_isim_uretme)
$(veri_yapilari)
$(yukleme)
