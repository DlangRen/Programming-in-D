Ddoc

$(DERS_BOLUMU $(IX parametre serbestliği) $(IX parametre, belirsiz sayıda) Parametre Serbestliği)

$(P
Bu bölümde $(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri bölümünde) anlatılanlarla doğrudan ilgili olan ve işlev çağırma konusunda bazı serbestlikler sağlayan iki olanağı göstereceğim:
)

$(UL
$(LI Varsayılan parametre değerleri)
$(LI Belirsiz sayıda parametreler)
)

$(H5 $(IX varsayılan parametre değeri) $(IX parametre değeri, varsayılan) Varsayılan parametre değerleri)

$(P
İşlevlerle ilgili bir kolaylık, parametrelere varsayılan değerler atanabilmesidir. Bu, yapı üyelerinin varsayılan değerlerinin belirlenebilmesine benzer.
)

$(P
Bazı işlevlerin bazı parametreleri çoğu durumda hep aynı değerle çağrılıyor olabilirler. Örnek olarak, bir eşleme tablosunu çıkışa yazdıran bir işlev düşünelim. Yazdırdığı eşleme tablosunun hem indeks türü hem de değer türü $(C string) olsun. Bu işlev, çıktıda kullanacağı ayraç karakterlerini de parametre olarak alacak şekilde esnek tasarlanmış olsun:
)

---
import std.algorithm;

// ...

void tabloYazdır(in char[] başlık,
                 in string[string] tablo,
                 in char[] indeksAyracı,
                 in char[] elemanAyracı) {
    writeln("-- ", başlık, " --");

    auto indeksler = sort(tablo.keys);

    foreach (sayaç, indeks; indeksler) {

        // İlk elemandan önce ayraç olmamalı
        if (sayaç != 0) {
            write(elemanAyracı);
        }

        write(indeks, indeksAyracı, tablo[indeks]);
    }

    writeln();
}
---

$(P
O işlev, indekslerle değerler arasına $(C ":"), elemanlar arasına da $(C ", ") gelecek şekilde şöyle çağrılabilir:
)

---
    string[string] sözlük = [
        "mavi":"blue", "kırmızı":"red", "gri":"gray" ];

    tabloYazdır("Renk Sözlüğü", sözlük, ":", ", ");
---

$(P
Çıktısı:
)

$(SHELL
-- Renk Sözlüğü --
gri:gray, kırmızı:red, mavi:blue
)

$(P
Aynı programda başka tabloların da yazdırıldıklarını, ve çoğu durumda hep aynı ayraçların kullanıldıklarını varsayalım. Yalnızca bazı özel durumlarda farklı ayraçlar kullanılıyor olsun.
)

$(P
Parametre değerlerinin çoğunlukla aynı değeri aldıkları durumlarda, o değerler $(I varsayılan değer) olarak belirtilebilirler:
)

---
void tabloYazdır(in char[] başlık,
                 in string[string] tablo,
                 in char[] indeksAyracı $(HILITE = ":"),
                 in char[] elemanAyracı $(HILITE = ", ")) {
    // ...
}
---

$(P
Varsayılan değerleri olan parametreler işlev çağrısı sırasında belirtilmeyebilirler:
)

---
    tabloYazdır("Renk Sözlüğü",
                sözlük); /* ← ayraçlar belirtilmemiş;
                          *   varsayılan değerlerini alırlar */
---

$(P
O durumda, belirtilmeyen parametrelerin varsayılan değerleri kullanılır.
)

$(P
Normalin dışında değer kullanılacağı durumlarda işlev çağrılırken o parametreler için yine de özel değerler verilebilir. Gerekiyorsa yalnızca ilki:
)

---
    tabloYazdır("Renk Sözlüğü", sözlük$(HILITE , "="));
---

$(P
Çıktısı:
)

$(SHELL
-- Renk Sözlüğü --
gri=gray, kırmızı=red, mavi=blue
)

$(P
Veya gerekiyorsa her ikisi birden:
)

---
    tabloYazdır("Renk Sözlüğü", sözlük$(HILITE , "=", "\n"));
---

$(P
Çıktısı:
)

$(SHELL
-- Renk Sözlüğü --
gri=gray
kırmızı=red
mavi=blue
)

$(P
Varsayılan değerler yalnızca parametre listesinin son tarafındaki parametreler için belirtilebilir. Baştaki veya aradaki parametrelerin varsayılan değerleri belirtilemez.
)

$(H6 Özel anahtar sözcüklerin varsayılan değer olarak kullanılmaları)

$(P
$(IX özel anahtar sözcük) $(IX anahtar sözcük) Aşağıdaki anahtar sözcükler kodda geçtikleri yeri gösteren hazır değerler olarak işlem görürler:
)

$(UL

$(LI $(IX __MODULE__) $(C __MODULE__): Modülün ismi)
$(LI $(IX __FILE__) $(C __FILE__): Kaynak dosyanın ismi)
$(LI $(IX __LINE__) $(C __LINE__): Satırın numarası)
$(LI $(IX __FUNCTION__) $(C __FUNCTION__): İşlevin ismi)
$(LI $(IX __PRETTY_FUNCTION__) $(C __PRETTY_FUNCTION__): İşlevin tam bildirimi)

)

$(P
Kodun başka noktalarında da kullanışlı olsalar da varsayılan parametre değeri olarak kullanıldıklarında etkileri farklıdır. Normal kod içinde geçtiklerinde değerleri bulundukları yerle ilgilidir:
)

---
import std.stdio;

void işlev(int parametre) {
    writefln("%s dosyasının %s numaralı satırında, %s " ~
             "işlevi içindeyiz.",
             __FILE__, __LINE__, __FUNCTION__);    $(CODE_NOTE $(HILITE satır 6))
}

void main() {
    işlev(42);
}
---

$(P
Bildirilen 6 numaralı satır işlevin kendi kodlarına işaret eder:
)

$(SHELL
deneme.d dosyasının $(HILITE 6 numaralı satırında), deneme.$(HILITE işlev)
işlevi içindeyiz.
)

$(P
Ancak, bazı durumlarda işlevin hangi satırda tanımlandığı değil, hangi satırdan çağrıldığı bilgisi daha önemlidir. Bu özel anahtar sözcükler varsayılan parametre değeri olarak kullanıldıklarında kendi bulundukları satırla değil, işlevin çağrıldığı satırla ilgili bilgi verirler:
)

---
import std.stdio;

void işlev(int parametre,
           string işlevİsmi = $(HILITE __FUNCTION__),
           string dosya = $(HILITE __FILE__),
           size_t satır = $(HILITE __LINE__)) {
    writefln("%s dosyasının %s numaralı satırındaki %s " ~
             "işlevi tarafından çağrılıyor.",
             dosya, satır, işlevİsmi);
}

void main() {
    işlev(42);    $(CODE_NOTE $(HILITE satır 13))
}
---

$(P
Bu sefer özel anahtar sözcüklerin değerleri işlevin çağrıldığı $(C main()) işlevine işaret eder:
)

$(SHELL
deneme.d dosyasının $(HILITE 13 numaralı satırındaki) deneme.$(HILITE main)
işlevi tarafından çağrılıyor.
)

$(P
$(IX özel değişken) $(IX değişken, özel) Yukarıdakilere ek olarak aşağıdaki özel değişkenler de kullanılan derleyiciye ve derleme saatine göre değerler alırlar:
)

$(UL

$(LI $(IX __DATE__) $(C __DATE__): Derleme günü)

$(LI $(IX __TIME__) $(C __TIME__): Derleme saati)

$(LI $(IX __TIMESTAMP__) $(C __TIMESTAMP__): Derleme günü ve saati)

$(LI $(IX __VENDOR__) $(C __VENDOR__): Derleyici (örneğin, $(STRING "Digital Mars D")))

$(LI $(IX __VERSION__) $(C __VERSION__): Derleyici sürümü bir tamsayı olarak (örneğin, 2.069 sürümü için $(C 2069) değeri))

)

$(H5 $(IX işlev, belirsiz sayıda parametre) Belirsiz sayıda parametreler)

$(P
Varsayılan parametre değerleri, işlevin aslında kaç tane parametre aldığını değiştirmez. Örneğin yukarıdaki $(C tabloYazdır) işlevi her zaman için dört adet parametre alır; ve işini yaparken o dört parametreyi kullanır.
)

$(P
D'nin başka bir olanağı, işlevleri belirsiz sayıda parametre ile çağırabilmemizi sağlar. Bu olanağı aslında daha önce de çok kere kullandık. Örneğin $(C writeln)'i hiçbir kısıtlamayla karşılaşmadan sınırsız sayıda parametre ile çağırabiliyorduk:
)

---
    writeln(
        "merhaba", 7, "dünya", 9.8 /*, ve istediğimiz kadar
                                    *  daha parametre */);
---

$(P
D'de belirsiz sayıda parametre kullanmanın dört yolu vardır:
)

$(UL

$(LI $(IX _argptr) $(C extern(C)) olarak işaretlenmiş olan işlevler ve $(C _argptr) gizli parametresini kullanan düzenek. Güvensiz olan bu olanağı bu kitapta anlatmayacağım.)

$(LI $(IX _arguments) Normal D işlevleri için $(C _argptr) ve $(C TypeInfo[]) türündeki $(C _arguments) gizli parametrelerini kullanan düzenek. $(C writeln) gibi işlevler bu düzeneği kullanır. Hem henüz öğrenmediğimiz $(I göstergeleri) kullandığı için, hem de aynı nedenden ötürü güvensiz olabilen bu olanağı da bu kitapta anlatmayacağım.)

$(LI Belirsiz sayıdaki parametrelerin hep aynı türden olmalarını gerektiren ama bunun yanında güvenli olan D olanağı. Aşağıda bu düzeneği anlatıyorum.)

$(LI Belirsiz sayıda şablon parametresi. Bu olanağı daha sonra $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) göreceğiz.)

)

$(P
$(IX ..., işlev parametresi) $(IX belirsiz sayıda işlev parametresi) D, belirsiz sayıdaki parametreleri o tür işlevlere bir dizi halinde sunar. Belirsiz sayıda parametre alacak olan işlevin parametresi olarak bir dizi belirtilir ve hemen arkasından $(C ...) karakterleri yazılır:
)

---
double topla(in double[] sayılar$(HILITE ...)) {
    double sonuç = 0.0;

    foreach (sayı; sayılar) {
        sonuç += sayı;
    }

    return sonuç;
}
---

$(P
O şekilde tanımlanan $(C topla), belirsiz sayıda parametre alan bir işlev haline gelmiş olur. Onu istediğimiz sayıda $(C double) ile çağırabiliriz:
)

---
    writeln(topla($(HILITE 1.1, 2.2, 3.3)));
---

$(P
Bütün parametre değerleri tek dilim olarak da verilebilirler:
)

---
    writeln(sum($(HILITE [) 1.1, 2.2, 3.3 $(HILITE ])));    // üsttekinin eşdeğeri
---

$(P
Parametre listesindeki dizi ve ondan sonra gelen $(C ...) karakterleri işlevin çağrıldığı sırada kullanılan parametreleri temsil ederler. $(C topla) işlevi örneğin beş $(C double) parametre ile çağrıldığında, $(C topla)'nın $(C sayılar) parametresi o beş sayıyı içerir.
)

$(P
Böyle işlevlerin şart koştukları parametreler de bulunabilir. Örneğin, belirsiz sayıdaki sözcüğü parantezler arasında yazdıran bir işlev düşünelim. Bu işlev, her ne kadar sözcük sayısını serbest bıraksa da, ne tür parantezler kullanılacağının belirtilmesini şart koşsun.
)

$(P
Kesinlikle belirtilmesi gereken parametreler parametre listesinde baş tarafa yazılırlar. Belirsiz sayıdaki parametreyi temsil eden dizi ise en sona yazılır:
)

---
char[] parantezle(
        in char[] açma,     // ← işlev çağrılırken belirtilmelidir
        in char[] kapama,   // ← işlev çağrılırken belirtilmelidir
        in char[][] sözcükler...) {    // ← hiç belirtilmeyebilir
    char[] sonuç;

    foreach (sözcük; sözcükler) {
        sonuç ~= açma;
        sonuç ~= sözcük;
        sonuç ~= kapama;
    }

    return sonuç;
}
---

$(P
O işlevi çağırırken ilk iki parametre mutlaka belirtilmelidir:
)

---
    parantezle("{");     $(DERLEME_HATASI)
---

$(P
Kesinlikle belirtilmeleri gereken baştaki parametreler verildiği sürece, geri kalan parametreler konusunda serbestlik vardır. Buna uygun olarak açma ve kapama parantezlerini kullanan bir örnek:
)

---
    writeln(parantezle("{", "}", "elma", "armut", "muz"));
---

$(P
Çıktısı:
)

$(SHELL
{elma}{armut}{muz}
)

$(H6 Parametre dizisinin ömrü kısadır)

$(P
Belirsiz sayıdaki parametrelerin sunulduğu dilim, ömrü kısa olan geçici bir dizinin elemanlarını gösterir. Bu elemanlar yalnızca işlevin işleyişi sırasında kullanmalıdır. Ömürleri kısa olduğundan, işlevin böyle bir dilimi daha sonradan kullanmak üzere saklaması hatalıdır:
)

---
int[] sonraKullanmakÜzereSayılar;

void foo(int[] sayılar...) {
    sonraKullanmakÜzereSayılar = sayılar;    $(CODE_NOTE_WRONG HATALI)
}

struct S {
    string[] sonraKullanmakÜzereİsimler;

    void foo(string[] isimler...) {
        sonraKullanmakÜzereİsimler = isimler;    $(CODE_NOTE_WRONG HATALI)
    }
}

void bar() {
    foo(1, 10, 100);  /* Geçici [ 1, 10, 100 ] dizisi bu
                       * noktadan sonra geçerli değildir. */

    auto s = S();
    s.foo("merhaba", "dünya");/* Geçici [ "merhaba", "dünya" ]
                               * dizisi bu noktadan sonra
                               * geçerli değildir. */

    // ...
}

void main() {
    bar();
}
---

$(P
Program yığıtında yaşayan geçici dizilerin elemanlarına erişim sağlayan dilimler sakladıklarından hem serbest işlev $(C foo()) hem de üye işlev $(C S.foo()) hatalıdır. Belirsiz sayıda parametre alan işlev çağrılırken otomatik olarak oluşturulan diziler yalnızca o işlevin işleyişi sırasında geçerlidirler.
)

$(P
Bu yüzden, parametreleri gösteren bir dilimi sonradan kullanmak üzere saklamak isteyen bir işlevin dilim elemanlarının kopyalarını alması gerekir:
)

---
void foo(int[] sayılar...) {
    sonraKullanmakÜzereSayılar = sayılar$(HILITE .dup);    $(CODE_NOTE doğru)
}

// ...

    void foo(string[] isimler...) {
        sonraKullanmakÜzereİsimler = isimler$(HILITE .dup);    $(CODE_NOTE doğru)
    }
---

$(P
Ancak, böyle işlevler normal dizi dilimleriyle de çağrılabildiklerinden, normal dilimlerin elemanlarının kopyalanmaları gereksizce masraflı olacaktır.
)

$(P
Hem doğru hem de hızlı olan bir çözüm, birisi belirsiz sayıda parametre, diğeri ise normal dilim alan aynı isimde iki işlev tanımlamaktır. İşlev belirsiz sayıda parametre ile çağrıldığında birisi, normal dilimle çağrıldığında diğeri işletilir:
)

---
int[] sonraKullanmakÜzereSayılar;

void foo(int[] sayılar$(HILITE ...)) {
    /* Bu, belirsiz sayıda parametre alan foo() işlevi
     * olduğundan, kendilerini gösteren dilim saklamadan önce
     * elemanların kopyalarını almak gerekir. */
    sonraKullanmakÜzereSayılar = sayılar$(HILITE .dup);
}

void foo(int[] sayılar) {
    /* Bu, normal dilim alan foo() işlevi olduğundan, dilimi
     * olduğu gibi saklayabiliriz. */
    sonraKullanmakÜzereSayılar = sayılar;
}

struct S {
    string[] sonraKullanmakÜzereİsimler;

    void foo(string[] isimler$(HILITE ...)) {
        /* Bu, belirsiz sayıda parametre alan S.foo() işlevi
         * olduğundan, kendilerini gösteren dilim saklamadan
         * önce elemanların kopyalarını almak gerekir. */
        sonraKullanmakÜzereİsimler = isimler$(HILITE .dup);
    }

    void foo(string[] isimler) {
        /* Bu, normal dilim alan S.foo() işlevi olduğundan,
         * dilimi olduğu gibi saklayabiliriz. */
        sonraKullanmakÜzereİsimler = isimler;
    }
}

void bar() {
    /* Bu çağrı, belirsiz sayıda parametre alan işleve
     * yönlendirilir. */
    foo(1, 10, 100);

    /* Bu çağrı, normal dilim alan işleve yönlendirilir. */
    foo($(HILITE [) 2, 20, 200 $(HILITE ]));

    auto s = S();

    /* Bu çağrı, belirsiz sayıda parametre alan işleve
     * yönlendirilir. */
    s.foo("merhaba", "dünya");

    /* Bu çağrı, normal dilim alan işleve yönlendirilir. */
    s.foo($(HILITE [) "selam", "ay" $(HILITE ]));

    // ...
}

void main() {
    bar();
}
---

$(P
Aynı isimde ama farklı parametreli işlevler tanımlamaya $(I işlev yükleme) denir. İşlev yüklemeyi bir sonraki bölümde göreceğiz.
)

$(PROBLEM_TEK

$(P
Daha önce gördüğümüz aşağıdaki $(C enum) türünün tanımlı olduğunu varsayın:
)

---
enum İşlem { toplama, çıkarma, çarpma, bölme }
---

$(P
O işlem çeşidini ve işlemde kullanılacak iki kesirli sayıyı içeren bir de yapı olsun:
)

---
struct Hesap {
    İşlem işlem;
    double birinci;
    double ikinci;
}
---

$(P
Örneğin $(C Hesap(İşlem.bölme, 7.7, 8.8)) nesnesi, 7.7'nin 8.8'e bölüneceği anlamına gelsin.
)

$(P
Bu yapı nesnelerinden belirsiz sayıda parametre alan, her birisini teker teker hesaplayan, ve bütün sonuçları bir $(C double) dizisi olarak döndüren $(C hesapla) isminde bir işlev yazın.
)

$(P
Bu işlev örneğin şöyle çağrılabilsin:
)

---
void $(CODE_DONT_TEST)main() {
    writeln(hesapla(Hesap(İşlem.toplama, 1.1, 2.2),
                    Hesap(İşlem.çıkarma, 3.3, 4.4),
                    Hesap(İşlem.çarpma, 5.5, 6.6),
                    Hesap(İşlem.bölme, 7.7, 8.8)));
}
---

$(P
Yukarıdaki gibi kullanıldığında, $(C hesapla)'nın işlem sonuçlarını yerleştirdiği dizi $(C writeln) tarafından çıktıya şöyle yazdırılacaktır:
)

$(SHELL
[3.3, -1.1, 36.3, 0.875]
)

)


Macros:
        SUBTITLE=Parametre Serbestliği

        DESCRIPTION=D'nin işlevlerin kullanışlılığını arttıran olanaklarından olan parametrelere varsayılan değerler verme ve işlevleri belirsiz sayıda parametre [variadic] ile çağrılabilme olanakları

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial belirsiz sayıda parametre variadic varsayılan parametre değeri

SOZLER=
$(belirsiz_sayida_parametre)
$(gosterge)
$(varsayilan)
