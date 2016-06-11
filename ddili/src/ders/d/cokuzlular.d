Ddoc

$(DERS_BOLUMU $(IX çokuzlu) Çokuzlular)

$(P
Çokuzlu birden fazla değeri bir araya getirerek hep birden bir yapı nesnesi gibi kullanılmalarını sağlayan olanaktır. Bazı dillerin iç olanağı olan çokuzlular D'de $(C std.typecons) modülündeki $(C Tuple) ile bir kütüphane olanağı olarak gerçekleştirilmiştir.
)

$(P
$(C Tuple) bazı işlemleri için $(C std.meta) modülündeki $(C AliasSeq)'ten da yararlanır.
)

$(H5 $(IX Tuple, std.typecons) $(IX tuple, std.typecons) $(C Tuple) ve $(C tuple()))

$(P
Çokuzlular $(C Tuple) şablonu ile gerçekleştirilmişlerdir. Çoğunlukla kolaylık işlevi olan $(C tuple()) ile oluşturulurlar:
)

---
import std.stdio;
import std.typecons;

void main() {
    auto çokuzlu = $(HILITE tuple(42, "merhaba"));
    writeln(çokuzlu);
}
---

$(P
Yukarıdaki $(C tuple()) işlevi 42 değerindeki $(C int)'in ve $(STRING "merhaba") değerindeki $(C string)'in bir araya gelmesinden oluşan bir nesne oluşturur. Bu nesnenin türünü ve üyelerinin değerlerini programın çıktısında görüyoruz:
)

$(SHELL
Tuple!(int, string)(42, "merhaba")
)

$(P
O çokuzlu türünün aşağıdaki sözde yapının eşdeğeri olduğunu ve perde arkasında da öyle gerçekleştirildiğini düşünebilirsiniz:
)

---
// Tuple!(int, string)'in eşdeğeri
struct __Çokuzlu_int_string {
    int __üye_0;
    string __üye_1;
}
---

$(P
Çokuzluların üyelerine normalde sıra numarasıyla erişilir. Bu açıdan bakıldığında her bir üyesi farklı türden olabilen bir dizi gibi düşünülebilir:
)

---
    writeln(çokuzlu$(HILITE [0]));
    writeln(çokuzlu$(HILITE [1]));
---

$(P
Çıktısı:
)

$(SHELL
42
merhaba
)

$(H6 Üye isimleri)

$(P
Çokuzlu üyelerine sıra numarasıyla erişilmesi başka dillerde de yaygındır. Phobos çokuzlularında ise üyelere nitelik isimleriyle de erişilebilir. Bunun için çokuzlunun $(C tuple()) kolaylık işlevi ile değil, $(C Tuple) şablonu ile açıkça oluşturulması gerekir. Üyelerin türleri ve nitelik isimleri çiftler halinde belirtilirler:
)

---
    auto çokuzlu = Tuple!(int, "sayı",
                          string, "mesaj")(42, "merhaba");
---

$(P
Yukarıdaki tanım, $(C int) türündeki 0 numaralı üyeye ayrıca $(C .sayı) niteliğiyle ve $(C string) türündeki 1 numaralı üyeye ayrıca $(C .mesaj) niteliğiyle erişilmesini sağlar:
)

---
    writeln("0 sıra numarasıyla    : ", çokuzlu[0]);
    writeln(".sayı niteliği olarak : ", çokuzlu$(HILITE .sayı));
    writeln("1 sıra numarasıyla    : ", çokuzlu[1]);
    writeln(".mesaj niteliği olarak: ", çokuzlu$(HILITE .mesaj));
---

$(P
Çıktısı:
)

$(SHELL
0 sıra numarasıyla    : 42
.sayı niteliği olarak : 42
1 sıra numarasıyla    : merhaba
.mesaj niteliği olarak: merhaba
)

$(H6 $(IX .expand) Üyelerin değer listesi olarak açılmaları)

$(P
Çokuzlu nesneleri üyelerinin değerlerinden oluşan liste olarak açılabilir ve örneğin o türlere uyan bir işlevi çağırırken kullanılabilir. Bu, $(C .expand) niteliği ile veya çokuzlu nesnesi dilimlenerek sağlanır:
)

---
import std.stdio;
import std.typecons;

void foo(int i, string s, double d, char c) {
    // ...
}

void bar(int i, double d, char c) {
    // ...
}

void main() {
    auto ç = tuple(1, "2", 3.3, '4');

    // İkisi de foo(1, "2", 3.3, '4')'ün eşdeğeridir:
    foo(ç$(HILITE.expand));
    foo(ç$(HILITE[]));

    // bar(1, 3.3, '4')'ün eşdeğeridir:
    bar(ç$(HILITE[0]), ç$(HILITE[$-2..$]));
}
---

$(P
Yukarıdaki çokuzlu $(C int), $(C string), $(C double), ve $(C char) türündeki değerlerden oluşmaktadır. Bu yüzden, bütün üyelerinin açılmasından oluşan liste $(C foo())'nun parametre listesine uyar ve o yüzden $(C foo()) çağrılırken kullanılabilir. $(C bar()) çağrılırken ise yalnızca ilk üyesinin ve son iki üyesinin değerlerinden oluşan üç değer gönderilmektedir.
)

$(P
Üyelerin türleri aynı dizinin elemanı olabilecek kadar uyumlu olduklarında çokuzlunun açılımı bir diziyi ilklerken de kullanılabilir:
)

---
import std.stdio;
import std.typecons;

void main() {
    auto çokuzlu = tuple(1, 2, 3);
    auto dizi = [ çokuzlu$(HILITE .expand), çokuzlu$(HILITE []) ];
    writeln(dizi);
}
---

$(P
Yukarıdaki örnek dizi üç $(C int)'ten oluşan çokuzlunun iki kere açılmasından oluşmaktadır:
)

$(SHELL
[1, 2, 3, 1, 2, 3]
)

$(H6 $(IX foreach, derleme zamanı) $(IX derleme zamanı foreach) Derleme zamanı $(C foreach)'i)

$(P
Hem dizi gibi düşünülebildiklerinden hem de değerleri liste olarak açılabildiğinden çokuzlular $(C foreach) ile de kullanılabilirler:
)

---
    auto çokuzlu = tuple(42, "merhaba", 1.5);

    foreach (i, üye; $(HILITE çokuzlu)) {
        writefln("%s: %s", i, üye);
    }
---

$(P
Çıktısı:
)

$(SHELL
0: 42
1: merhaba
2: 1.5
)

$(P
$(IX döngü açılımı) Yukarıdaki koddaki $(C foreach)'in çalışma zamanında işletildiği düşünülebilir; ancak, bu doğru değildir. Çokuzlu üyeleri üzerinde işletilen $(C foreach)'ler aslında döngü değil, döngünün içeriğinin üye adedi kadar tekrarlanmasından oluşan bir $(I döngü açılımıdır). Dolayısıyla, yukarıdaki $(C foreach) döngüsü aşağıdaki üç kod bloğunun eşdeğeridir:
)

---
    {
        enum size_t i = 0;
        $(HILITE int) üye = çokuzlu[i];
        writefln("%s: %s", i, üye);
    }
    {
        enum size_t i = 1;
        $(HILITE string) üye = çokuzlu[i];
        writefln("%s: %s", i, üye);
    }
    {
        enum size_t i = 2;
        $(HILITE double) üye = çokuzlu[i];
        writefln("%s: %s", i, üye);
    }
---

$(P
Bunun nedeni, her çokuzlu üyesinin farklı türden olabilmesi ve dolayısıyla döngünün her ilerletilişinde döngü kapsamındaki kodların farklı olarak derlenmesinin gerekmesidir.
)

$(H6 Birden fazla değer döndürmek)

$(P
$(IX findSplit, std.algorithm) Çokuzlular işlevlerin tek değer döndürebilme yetersizliklerine karşı basit bir çözüm olarak görülebilirler. Örneğin, $(C std.algorithm) modülündeki $(C findSplit()) bir aralığı başka bir aralık içinde arar ve arama sonucunda üç bilgi üretir: bulunan aralıktan öncesi, bulunan aralık, ve bulunan aralıktan sonrası. $(C findSplit()), bu üç parça bilgiyi bir çokuzlu olarak döndürür:
)

---
import std.algorithm;

// ...

    auto bütünAralık = "merhaba";
    auto aranan = "er";

    auto sonuç = findSplit(bütünAralık, aranan);

    writeln("öncesi : ", sonuç[0]);
    writeln("bulunan: ", sonuç[1]);
    writeln("sonrası: ", sonuç[2]);
---

$(P
Çıktısı:
)

$(SHELL
öncesi : m
bulunan: er
sonrası: haba
)

$(P
Birden fazla değer döndürmek için bir yapı nesnesi de döndürülebileceğini biliyorsunuz:
)

---
struct Sonuç {
    // ...
}

$(HILITE Sonuç) işlev() {
    // ...
}
---

$(H5 $(IX AliasSeq, std.meta) $(C AliasSeq))

$(P
$(C std.meta) modülünde tanımlı olan $(C AliasSeq) normalde derleyiciye ait olan ve hep üstü kapalı olarak geçen ve yukarıda da rastladığımız bir kavramı programcının kullanımına sunar: virgüllerle ayrılmış değer listesi. Aşağıda bunun üç örneğini görmekteyiz:
)

$(UL
$(LI İşlev parametre değeri listesi)
$(LI Şablon parametre değeri listesi)
$(LI Dizi hazır değeri eleman listesi)
)

$(P
Bu üç farklı listenin örnekleri şöyle gösterilebilir:
)

---
    işlev($(HILITE 1, "merhaba", 2.5));             // işlev parametreleri
    auto n = YapıŞablonu!($(HILITE char, long))();  // şablon parametreleri
    auto d = [ $(HILITE 1, 2, 3, 4) ];              // dizi elemanları
---

$(P
Daha yukarıda örneklerini gördüğümüz $(C Tuple) üyelerinin değer listesi olarak açılabilmeleri de aslında $(C AliasSeq) tarafından sağlanır.
)

$(P
$(IX TypeTuple, std.typetuple) $(C AliasSeq)'in adı "sıralanmış isimler" olarak açıklanabilen "alias sequence"tan gelir ve türler, değerler, ve isimler içerir. ($(C AliasSeq) ve $(C std.meta)'nın eski isimleri sırasıyla $(C TypeTuple) ve $(C std.typetuple) idi.)
)

$(P
Bu bölümde $(C AliasSeq)'in yalnızca ya bütünüyle türlerden ya da bütünüyle değerlerden oluşan örneklerini göreceğiz. Hem türlerden hem değerlerden oluşan örneklerini bir sonraki bölüme ayıracağız. $(C AliasSeq) bir sonraki bölümde göreceğimiz $(I belirsiz sayıda parametre) alan şablonlarda da yararlıdır.
)

$(H6 Değerlerden oluşan $(C AliasSeq))

$(P
Bir derleme zamanı olanağı olan $(C AliasSeq), ifade ettiği parametre listesini kendi şablon parametreleri olarak alır. Bunu üç parametre alan bir işlev çağrısında görelim:
)

---
import std.stdio;

void foo(int i, string s, double d) {
    writefln("foo çağrıldı: %s %s %s", i, s, d);
}
---

$(P
Normalde o işlevin açıkça üç parametre değeri ile çağrıldığını biliyoruz:
)

---
    foo(1, "merhaba", 2.5);
---

$(P
$(C AliasSeq) o parametre değerlerini tek değişken olarak bir arada tutabilir ve işlev çağrıları sırasında otomatik olarak parametre listesi olarak açılabilir:
)

---
import std.meta;

// ...

    alias parametreler = AliasSeq!(1, "merhaba", 2.5);
    foo($(HILITE parametreler));
---

$(P
Her ne kadar bu sefer tek değer alıyormuş gibi görünse de, yukarıdaki $(C foo) çağrısı öncekinin eşdeğeridir ve her iki yöntem de aynı çıktıyı üretir:
)

$(SHELL
foo çağrıldı: 1 merhaba 2.5
)

$(P
$(C parametreler)'in $(C auto) anahtar sözcüğü ile değişken olarak değil, $(C alias) sözcüğü ile belirli bir $(C AliasSeq)'in takma ismi olarak tanımlandığına dikkat edin. $(C auto) anahtar sözcüğünün kullanılabildiği durumlar olsa da bu bölümdeki örneklerde yalnızca takma isim olarak göreceğiz.
)

$(P
Yukarıda $(C Tuple) başlığı altında da gördüğümüz gibi, değerlerin hepsi aynı türden veya daha genel olarak $(I uygun) türlerden olduklarında, $(C AliasSeq) bir dizi hazır değerinin elemanlarını da temsil edebilir:
)

---
    alias elemanlar = AliasSeq!(1, 2, 3, 4);
    auto dizi = [ $(HILITE elemanlar) ];
    assert(dizi == [ 1, 2, 3, 4 ]);
---

$(H6 Türlerden oluşan $(C AliasSeq))

$(P
$(C AliasSeq)'in parametreleri türlerin $(I kendilerinden) de oluşabilir. Yani, belirli bir türün belirli bir değeri değil, $(C int) gibi bir türün $(I kendisi) olabilir.
)

$(P
Tür içeren $(C AliasSeq)'ler şablonlarla kullanılmaya elverişlidir. Bunun bir örneğini görmek için iki parametreli bir yapı şablonu düşünelim. Bu şablonun ilk parametresi yapının bir dizisinin eleman türünü, ikincisi de yapının bir işlevinin dönüş türünü belirliyor olsun:
)

---
import std.conv;

struct S($(HILITE ElemanTürü, SonuçTürü)) {
    ElemanTürü[] dizi;

    SonuçTürü uzunluk() {
        return to!SonuçTürü(dizi.length);
    }
}

void main() {
    auto s = S!$(HILITE (double, int))([ 1, 2, 3 ]);
    auto u = s.uzunluk();
}
---

$(P
Yukarıda bu şablonun $(C (double, int)) türleri ile kullanıldığını görüyoruz. Aynı amaç için iki tür içeren bir $(C AliasSeq)'ten de yararlanılabilir:
)

---
import std.meta;

// ...

    alias Türler = AliasSeq!(double, int);
    auto s = S!$(HILITE Türler)([ 1, 2, 3 ]);
---

$(P
Yukarıda $(C S) şablonu her ne kadar tek şablon parametresi ile kullanılıyor gibi görünse de, $(C Türler) otomatik olarak açılır ve sonuçta $(C S!(double,&nbsp;int)) türünün aynısı elde edilir.
)

$(P
$(C AliasSeq) özellikle $(I belirsiz sayıda parametre) alan şablonlarda yararlıdır. Bunun örneklerini bir sonraki bölümde göreceğiz.
)

$(H6 Dizi gibi kullanılması)

$(P
$(C AliasSeq)'in kurulduğu şablon parametrelerine dizi erişim işleci ile erişilebilir:
)

---
    alias parametreler = AliasSeq!(1, "merhaba", 2.5);
    assert(parametreler$(HILITE [0]) == 1);
    assert(parametreler$(HILITE [1]) == "merhaba");
    assert(parametreler$(HILITE [2]) == 2.5);
---

$(P
$(C AliasSeq) yine dizilerde olduğu gibi dilimleme işleminde de kullanılabilir. Yukarıdaki örneklerde kullanılan $(C AliasSeq)'in son iki parametresine uyan bir işlev olduğunu düşünelim. Böyle bir işlev yukarıdaki $(C parametreler)'in son iki değeri dilimlenerek çağrılabilir:
)

---
void bar(string s, double d) {
    // ...
}

// ...

    bar(parametreler$(HILITE [$-2 .. $]));
---

$(H6 $(C foreach) ile kullanılması)

$(P
Yukarıda gördüğümüz $(C Tuple)'da olduğu gibi, $(C AliasSeq)'in $(C foreach) ile kullanılmasında da çalışma zamanında işletilen bir döngü $(I oluşmaz); döngünün içeriği parametre listesindeki her eleman için derleme zamanında kod olarak açılır ve sonuçta o açılım derlenir.
)

$(P
Bunun örneğini yukarıdaki $(C S) yapı şablonu için yazılmış olan bir birim testinde görelim. Aşağıdaki kod bu yapı şablonunun eleman türü olarak $(C int), $(C long), ve $(C float) kullanılabildiğini test ediyor ($(C SonuçTürü) ise hep $(C size_t)):
)

---
unittest {
    alias Türler = AliasSeq!($(HILITE int, long, float));

    foreach (Tür; $(HILITE Türler)) {
        auto s = S!(Tür, size_t)([ Tür.init, Tür.init ]);
        assert(s.uzunluk() == 2);
    }
}
---

$(P
Yukarıdaki koddaki $(C Tür) değişkeni sırasıyla $(C int), $(C long), ve $(C float) türünü temsil eder ve sonuçta $(C foreach) döngüsü aşağıdaki eşdeğer döngü açılımı olarak derlenir:
)

---
    {
        auto s = S!($(HILITE int), size_t)([ $(HILITE int).init, $(HILITE int).init ]);
        assert(s.uzunluk() == 2);
    }
    {
        auto s = S!($(HILITE long), size_t)([ $(HILITE long).init, $(HILITE long).init ]);
        assert(s.uzunluk() == 2);
    }
    {
        auto s = S!($(HILITE float), size_t)([ $(HILITE float).init, $(HILITE float).init ]);
        assert(s.uzunluk() == 2);
    }
---

$(H5 $(IX .tupleof) $(C .tupleof) niteliği)

$(P
$(C .tupleof) bir türün veya bir nesnenin bütün üyelerini bir çokuzlu olarak elde etmeye yarar. Aşağıdaki örnek $(C .tupleof) niteliğini bir türe uyguluyor:
)

---
import std.stdio;

struct Yapı {
    int numara;
    string dizgi;
    double kesirli;
}

void main() {
    foreach (i, ÜyeTürü; typeof($(HILITE Yapı.tupleof))) {
        writefln("Üye %s:", i);
        writefln("  tür : %s", ÜyeTürü.stringof);

        string isim = $(HILITE Yapı.tupleof)[i].stringof;
        writefln("  isim: %s", isim);
    }
}
---

$(P
$(C Yapı.tupleof)'un yukarıda iki yerde geçtiğine dikkat edin. İlkinde eleman türleri $(C typeof) ile elde edilmekte ve her tür $(C foreach)'in $(C ÜyeTürü) değişkeni olarak belirmektedir. İkincisinde ise yapı üyesinin ismi $(C Yapı.tupleof[i].stringof) ile elde edilmektedir.
)

$(SHELL
Üye 0:
  tür : int
  isim: numara
Üye 1:
  tür : string
  isim: dizgi
Üye 2:
  tür : double
  isim: kesirli
)

$(P
$(C .tupleof) bir nesneye uygulandığında ise o nesnenin üyelerinin değerlerini çokuzlu olarak elde etmeye yarar:
)

---
    auto nesne = Yapı(42, "merhaba", 1.5);

    foreach (i, üye; $(HILITE nesne.tupleof)) {
        writefln("Üye %s:", i);
        writefln("  tür  : %s", typeof(üye).stringof);
        writefln("  değer: %s", üye);
    }
---

$(P
Bu durumda $(C üye) isimli döngü değişkeni sırasıyla üyelerin değerlerini temsil eder:
)

$(SHELL
Üye 0:
  tür  : int
  değer: 42
Üye 1:
  tür  : string
  değer: merhaba
Üye 2:
  tür  : double
  değer: 1.5
)

$(P
Buradaki önemli bir ayrıntı, nesneye uygulanan $(C .tupleof) çokuzlusunun üyelerin değerlerinden değil, üyelerin kendilerinden oluşmasıdır. Bir anlamda, her çokuzlu üyesi temsil ettiği asıl üyenin referansıdır.
)

$(H5 Özet)

$(UL

$(LI $(C tuple()) yapı benzeri değişkenler oluşturur.)

$(LI Açıkça $(C Tuple) kullanıldığında üyelere isim verilebilir.)

$(LI Üyeler $(C .expand) niteliği ile veya dilimlenerek değer listesi olarak açılabilirler.)

$(LI Çokuzluya uygulanan $(C foreach) çalışma zamanında işleyen döngü değildir, döngü açılımıdır.)

$(LI $(C AliasSeq) parametre değer listesi gibi kavramları temsil eder.)

$(LI $(C AliasSeq) hem değerleri hem türlerin kendilerini içerebilir.)

$(LI $(C Tuple) ve $(C AliasSeq) dizi erişim ve dilimleme işleçlerini destekler.)

$(LI $(C .tupleof) türlerin veya nesnelerin üyeleri ile ilgili bilgi verir.)

)

macros:
        SUBTITLE=Çokuzlular

        DESCRIPTION=Birden fazla değişkeni hızlıca bir araya getiren tuple olanağı

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial tuple çokuzlu

SOZLER=
$(belirsiz_sayida_parametre)
$(cokuzlu)
$(dongu_acilimi)
$(ic_olanak)
$(phobos)
