Ddoc

$(DERS_BOLUMU Diğer İşlev Olanakları)

$(P
İşlevleri daha önce aşağıdaki bölümlerde görmüştük:
)

$(UL
$(LI $(LINK2 /ders/d/islevler.html, İşlevler))

$(LI $(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri))

$(LI $(LINK2 /ders/d/islev_yukleme.html, İşlev Yükleme))

$(LI $(LINK2 /ders/d/kapamalar.html, İşlev Göstergeleri ve Kapamalar))

)

$(P
Burada o bölümlerde yer almayan başka işlev olanaklarını göreceğiz.
)

$(H5 Dönüş türü olanakları)

$(P
İşlevler $(C auto), $(C ref), $(C inout), ve $(C auto ref) olarak bildirilebilirler. Bunlar işlevlerin dönüş türleriyle ilgilidir.
)

$(H6 $(IX auto, dönüş türü) $(IX auto işlev) $(C auto) işlevler)

$(P
$(C auto) olarak bildirilen işlevlerin dönüş türlerinin açıkça yazılması gerekmez:
)

---
$(HILITE auto) topla(int birinci, double ikinci) {
    double sonuç = birinci + ikinci;
    return sonuç;
}
---

$(P
Derleyici dönüş türünü $(C return) satırından otomatik olarak çıkarsar. Yukarıdaki işlevin $(C return) ile döndürdüğü sonuç $(C double) olduğundan, o işlev sanki dönüş türü açıkça $(C double) yazılmış gibi derlenir.
)

$(P
Birden fazla $(C return) deyimi bulunduğunda işlevin dönüş türü o dönüş ifadelerinin $(C ortak türüdür). (Ortak türü $(LINK2 /ders/d/uclu_islec.html, Üçlü İşleç ?:) bölümünde görmüştük.) Örneğin, $(C int) ve $(C double) türlerinin ortak türü $(C double) olduğundan aşağıdaki $(C auto) işlevin dönüş türü $(C double)'dır:
)

---
auto işlev(int i) {
    if (i < 0) {
        return i;      // Burada 'int' döndürülüyor
    }

    return i * 1.5;    // Burada 'double' döndürülüyor
}

void main() {
    // İşlevin dönüş türü, 'int' ve 'double' türlerinin ortak
    // türü olan 'double' türüdür
    auto sonuç = işlev(42);
    static assert(is (typeof(sonuç) == $(HILITE double)));
}
---

$(H6 $(IX ref, dönüş türü) $(C ref) işlevler)

$(P
İşlevlerin döndürdükleri değerler normalde işlevi çağıran tarafa kopyalanırlar. $(C ref) belirteci, dönüş değerinin kopyalanmak yerine referans olarak döndürülmesini sağlar.
)

$(P
Örneğin, aşağıdaki işlev kendisine verilen iki parametreden büyük olanını döndürmektedir:
)

---
$(CODE_NAME büyüğü)int büyüğü(int birinci, int ikinci) {
    return (birinci > ikinci) ? birinci : ikinci;
}
---

$(P
O işlevin hem parametreleri hem de dönüş değeri normalde kopyalanır:
)

---
$(CODE_XREF büyüğü)import std.stdio;

void main() {
    int a = 1;
    int b = 2;
    int sonuç = büyüğü(a, b);
    sonuç += 10;                  // ← ne a ne de b etkilenir
    writefln("a: %s, b: %s, sonuç: %s", a, b, sonuç);
}
---

$(P
$(C büyüğü) işlevinin dönüş değeri $(C sonuç) değişkenine kopyalandığından, değişkenin arttırılması yalnızca $(C sonuç) isimli kopyayı etkiler. İşleve kendileri de zaten kopyalanarak geçirilmiş olan $(C a) ve $(C b) değişmezler:
)

$(SHELL_SMALL
a: 1, b: 2, sonuç: 12
)

$(P
Parametrelerin kopyalanmak yerine referans olarak gönderilmeleri için $(C ref) anahtar sözcüğünün kullanıldığını biliyorsunuz. Aynı sözcük dönüş türü için de kullanılabilir ve işlevin dönüş değerinin de referans olarak döndürülmesini sağlar:
)

---
$(HILITE ref) int büyüğü($(HILITE ref) int birinci, $(HILITE ref) int ikinci) {
    return (birinci > ikinci) ? birinci : ikinci;
}
---

$(P
Bu durumda döndürülen referans parametrelerden birisinin takma ismi yerine geçecek ve onda yapılan değişiklik artık ya $(C a)'yı ya da $(C b)'yi değiştirecektir:
)

---
    int a = 1;
    int b = 2;
    büyüğü(a, b) += 10;           // ← ya a ya b etkilenir
    writefln("a: %s, b: %s", a, b);
---

$(P
Dikkat ederseniz, işlevin döndürdüğü referansı $(C sonuç) diye bir değişken kullanmadan doğrudan arttırıyoruz. O işlem, $(C a) ve $(C b)'den büyük olanını etkiler:
)

$(SHELL_SMALL
a: 1, b: $(HILITE 12)
)

$(P
$(IX gösterge) $(IX yerel değişken) $(IX değişken, yerel) $(B Yerel referans için gösterge gerekir:) Burada bir noktaya dikkatinizi çekmek istiyorum. $(C ref) kullanılmış olmasına rağmen, o dönüş değerinin yerel bir değişkene atanması $(C a) veya $(C b)'yi yine de değiştirmez:
)

---
    int sonuç = büyüğü(a, b);
    sonuç += 10;               // ← yine yalnızca 'sonuç' değişir
---

$(P
$(C büyüğü) işlevi $(C a)'ya veya $(C b)'ye referans döndürüyor olsa da, o referans $(C sonuç) ismindeki yerel değişkene kopyalandığından $(C a) veya $(C b) değişmez:
)

$(SHELL_SMALL
a: 1, b: 2, sonuç: 12
)

$(P
$(C sonuç)'un $(C a)'nın veya $(C b)'nin referansı olması istendiğinde gösterge olarak tanımlanması gerekir:
)

---
    int $(HILITE *) sonuç = $(HILITE &)büyüğü(a, b);
    $(HILITE *)sonuç += 10;
    writefln("a: %s, b: %s, sonuç: %s", a, b, $(HILITE *)sonuç);
---

$(P
$(C sonuç) artık ya $(C a)'ya ya da $(C b)'ye erişim sağladığından, onun aracılığıyla yapılan değişiklik o ikisinin büyük olanını etkilerdi:
)

$(SHELL_SMALL
a: 1, b: $(HILITE 12), sonuç: 12
)

$(P 
$(B Yerel değişkene referans döndürülemez:) Yukarıdaki $(C ref) dönüş değeri daha işlev çağrılmadan önce yaşamaya başlayan iki değişkenden birisinin takma ismi gibi çalışmaktadır. Bir başka deyişle, $(C birinci) de döndürülse $(C ikinci) de döndürülse o dönüş değeri hep işlevin çağrıldığı noktada zaten yaşamakta olan $(C a)'nın veya $(C b)'nin referansıdır.
)

$(P
Yaşam süresi işlevden çıkılırken sona erecek olan bir değişkene referans döndürülemez:
)

---
$(HILITE ref) string parantezİçinde(string söz) {
    string sonuç = '(' ~ söz ~ ')';
    return sonuç;    $(DERLEME_HATASI)
} // ← sonuç'un yaşamı burada sona erer
---

$(P
İşlev kapsamında tanımlanmış olan $(C sonuç)'un yaşamı o işlevden çıkıldığında sona erer. O yüzden, o değişkenin takma ismi gibi kullanılacak bir dönüş değeri olamaz.
)

$(P
Derleme, yerel değişkene referans döndürüldüğünü bildiren bir hata ile sonlanır:
)

$(SHELL_SMALL
Error: escaping $(HILITE reference to local variable) sonuç
)

$(H6 $(IX auto ref, dönüş türü) $(C auto ref) işlevler)

$(P
Yukarıdaki $(C parantezİçinde) işlevinin yaşam süresi sona eren yerel değişken nedeniyle derlenemediğini gördük. $(C auto ref) öyle durumlarda yararlıdır.
)

$(P
$(C auto ref) olarak bildirilmiş olan bir işlevin dönüş türü $(C auto) işlevlerde olduğu gibi otomatik olarak çıkarsanır. Ek olarak, referans olamayacak bir değer döndürüldüğünde o değer referans olarak değil, kopyalanarak döndürülür.
)

$(P
Aynı işlevi $(C auto ref) olarak yazdığımızda program derlenir:
)

---
$(HILITE auto ref) parantezİçinde(string söz) {
    string sonuç = '(' ~ söz ~ ')';
    return sonuç;                   // ← derlenir
}
---

$(P
İşlevin değer mi yoksa referans mı döndüreceği içindeki ilk $(C return) deyimi tarafından belirlenir.
)

$(P
$(C auto ref) daha çok parametrelerin duruma göre referans veya kopya olabildikleri işlev şablonlarında yararlıdır.
)

$(H6 $(IX inout, dönüş türü) $(C inout) işlevler)

$(P
Bu belirteç işlev parametrelerinde ve dönüş türünde kullanılır ve o işlevin parametrelerine bağlı olarak $(C const), $(C immutable), veya $(I değişebilen) anlamına gelir.
)

$(P
Yukarıdaki işlevi $(C string) alacak ve $(C string) döndürecek şekilde tekrar yazalım:
)

---
string parantezİçinde(string söz) {
    return '(' ~ söz ~ ')';
}
---

$(P
O işleve $(C string) türünde parametre verilmesi gerektiğini ve sonucunun $(C string) olduğunu biliyoruz:
)

---
    writeln(parantezİçinde("merhaba"));
---

$(P
$(STRING "merhaba") hazır değerinin türü $(C string), yani $(C immutable(char)[]) olduğundan o kod derlenir ve çalışır:
)

$(SHELL_SMALL
(merhaba)
)

$(P
Burada kullanışsız bir durum vardır: O işlev $(C string) türüne bağlı olarak yazıldığından $(C immutable) olmayan bir dizgi ile çağrılamaz:
)

---
    char[] dizgi;         // elemanları değişebilir
    dizgi ~= "selam";
    writeln(parantezİçinde(dizgi));    $(DERLEME_HATASI)
---

$(P
Derleme hatası, $(I değişebilen) karakterlerden oluşan $(C char[]) türünün $(C string)'e dönüştürülemeyeceğini bildirir:
)

$(SHELL_SMALL
Error: function deneme.parantezİçinde ($(HILITE string) söz)
is not callable using argument types ($(HILITE char[]))
)

$(P
Aynı sorun $(C const(char)[]) dizgilerinde de vardır.
)

$(P
Bu sorunu çözmek için bir kaç yöntem düşünülebilir. Bir yöntem, işlevi $(I değişebilen) ve $(C const) karakter dizileri için de yüklemektir:
)

---
char[] parantezİçinde(char[] söz) {
    return '(' ~ söz ~ ')';
}

const(char)[] parantezİçinde(const(char)[] söz) {
    return '(' ~ söz ~ ')';
}
---

$(P
Bunun programcılıkta kaçınılması gereken $(I kod tekrarı) anlamına geldiğini görüyoruz. Bu işlevlerin ileride gelişebileceklerini veya olası hatalarının giderilebileceklerini düşünürsek, o değişikliklerin üçünde de yapılmasının unutulmaması gerekecektir. O yüzden bu riskli bir tasarımdır.
)

$(P
Başka bir yöntem, işlevi şablon olarak tanımlamaktır:
)

---
T parantezİçinde(T)(T söz) {
    return '(' ~ söz ~ ')';
}
---

$(P
O çözüm şablon içindeki kullanıma uyan her tür ile kullanılabilir. Bunun bazen fazla esnek olabileceğini ve şablon kısıtlamaları kullanılmasının gerekebileceğini de önceki bölümde görmüştük.
)

$(P
$(C inout) yöntemi şablon çözümüne çok benzer ama bütün türü değil, yalnızca türün $(C const), $(C immutable), veya $(I değişebilen) özelliğini esnek bırakır. O özelliği işlevin parametrelerinden otomatik olarak çıkarsar:
)

---
$(HILITE inout)(char)[] parantezİçinde($(HILITE inout)(char)[] söz) {
    return '(' ~ söz ~ ')';
}
---

$(P
$(C inout), parametreden otomatik olarak çıkarsanan özelliği dönüş türüne de aktarır.
)

$(P
O işlev $(C char[]) türüyle çağrıldığında hiç $(C inout) yazılmamış gibi derlenir. $(C immutable(char)[]) veya $(C const(char)[]) türleriyle çağrıldığında ise $(C inout) sırasıyla $(C immutable) veya $(C const) yerine geçer. Bunu işlevin dönüş türünü yazdırarak görebiliriz:
)

---
    char[] değişebilen;
    writeln(typeof(parantezİçinde(değişebilen)).stringof);

    const(char)[] sabit;
    writeln(typeof(parantezİçinde(sabit)).stringof);

    immutable(char)[] değişmez;
    writeln(typeof(parantezİçinde(değişmez)).stringof);
---

$(P
Üç çağrının farklı dönüş türleri:
)

$(SHELL_SMALL
char[]
const(char)[]
string
)

$(P
Özetle, $(C inout) parametre türünün $(C const), $(C immutable), veya $(I değişebilen) özelliğini dönüş türüne aktarır.
)

$(H5 Davranış olanakları)

$(P
$(C pure), $(C nothrow), ve $(C @nogc) işlevlerin davranışlarıyla ilgilidir.
)

$(H6 $(IX pure) $(C pure) işlevler)

$(P
İşlevlerin değer üretebildiklerini ve yan etki oluşturabildiklerini $(LINK2 /ders/d/islevler.html, İşlevler bölümünde) görmüştük. Değer üretmenin yan etki oluşturmaktan daha yararlı olduğunun kabul edildiğini de o bölümde görmüştük.
)

$(P
Buna benzeyen başka yararlı bir kavram, bir işlevin saflığıdır. Bu kavramın D'deki tanımı fonksiyonel programlamadaki genel tanımından farklıdır: D'deki tanıma göre, dönüş değerini üretirken veya olası yan etkilerini oluştururken $(I değişebilen) evrensel veya $(C static) değerlere erişmeyen bir işlev saftır. (Giriş çıkış aygıtları da değişebilen evrensel durum olarak kabul edildiklerinden saf işlevler giriş ve çıkış işlemleri de içeremezler.)
)

$(P
Bir başka deyişle, dönüş değeri ve yan etkileri yalnızca parametrelerine, yerel değişkenlerine, ve değişmez evrensel değerlere bağlı olan bir işlev saftır.
)

$(P
Dolayısıyla, saflığın D'deki önemli farkı saf işlevlerin parametrelerini değiştirebilmeleridir.
)

$(P
Ek olarak, programın genel durumunu etkilediği için aslında izin verilmemesi gereken bazı işlemlere de D'nin bir sistem dili olması nedeniyle izin verilir. Bu yüzden, D'de saf işlevler aşağıdaki işlemleri de gerçekleştirebilirler:
)

$(UL
$(LI $(C new) ifadesi ile nesne oluşturulabilirler.)
$(LI Programı sonlandırabilirler.)
$(LI İşlemcinin kesirli sayı bayraklarına erişebilirler.)
$(LI Hata atabilirler.)
)

$(P
$(C pure) anahtar sözcüğü bir işlevin bu koşullara uyduğunu bildirir ve bu durumun derleyici tarafından denetlenmesini sağlar.
)

$(P
Doğal olarak, aynı garantileri vermediklerinden saf olmayan işlevler saf işlevler tarafından çağrılamazlar.
)

$(P
Aşağıdaki örnek program bu koşullardan bazılarını gösteriyor:
)

---
import std.stdio;
import std.exception;

int değişebilenEvrensel;
const int constEvrensel;
immutable int immutableEvrensel;

void safOlmayanİşlev() {
}

int safİşlev(ref int i, int[] dilim) $(HILITE pure) {
    // Hata atabilir:
    enforce(dilim.length >= 1);

    // Parametrelerini değiştirebilir:
    i = 42;
    dilim[0] = 43;

    // Değişmez evrensel duruma erişebilir:
    i = constEvrensel;
    i = immutableEvrensel;

    // new ifadesini kullanabilir:
    auto p = new int;

    // Değişebilen evrensel duruma erişemez:
    i = değişebilenEvrensel;    $(DERLEME_HATASI)

    // Giriş ve çıkış işlemleri uygulayamaz:
    writeln(i);                 $(DERLEME_HATASI)

    static int değişebilenStatik;

    // Değişebilen statik duruma erişemez:
    i = değişebilenStatik;      $(DERLEME_HATASI)

    // Saf olmayan işlevleri çağıramaz:
    safOlmayanİşlev();          $(DERLEME_HATASI)

    return 0;
}

void main() {
    int i;
    int[] dilim = [ 1 ];
    safİşlev(i, dilim);
}
---

$(P
Bazı saf işlevler parametrelerinde değişiklik de yapmazlar. Dolayısıyla, bu gibi işlevlerin programdaki tek etkileri dönüş değerleridir. Bu açıdan bakıldığında, parametrelerinde değişiklik yapmayan saf işlevlerin belirli parametre değerlerine karşılık hep aynı değeri döndürecekleri belli demektir. Dolayısıyla, böyle bir işlevin dönüş değeri eniyileştirme amacıyla sonradan kullanılmak üzere saklanabilir. (Bu gözlem hem derleyici hem de programcı için yararlıdır.)
)

$(P
$(IX çıkarsama, pure niteliği) $(IX nitelik çıkarsama, pure) Bir şablonun tam olarak ne çeşit kodlar içereceği ve derleneceği şablon parametrelerine bağlı olduğundan, saf olup olmadığı da şablon parametrelerine bağlı olabilir. Bu yüzden, şablonların saf olup olmadıkları derleyici tarafından otomatik olarak belirlenir. Şablonlarda gerekmese de $(C pure) anahtar sözcüğü istendiğinde yine de belirtilebilir. Benzer biçimde, $(C auto) işlevlerin saflıkları da otomatik olarak çıkarsanır.
)

$(P
Örneğin, aşağıdaki şablon $(C N)'nin sıfır olduğu durumda saf olmadığından $(C şablon!0)'ın saf olan bir işlev tarafından çağrılması mümkün değildir:
)

---
import std.stdio;

// Bu şablon N sıfır olduğunda saf değildir.
void şablon(size_t N)() {
    static if (N == 0) {
        // N sıfır olduğunda çıkışa yazdırmaya çalışmaktadır:
        writeln("sıfır");
    }
}

void foo() $(HILITE pure) {
    şablon!0();    $(DERLEME_HATASI)
}

void main() {
    foo();
}
---

$(P
Derleyici yukarıdaki şablonun $(C 0) kullanımının saf olmadığını otomatik olarak anlar ve onun saf olan $(C foo) tarafından çağrılmasına izin vermez:
)

$(SHELL_SMALL
Error: pure function 'deneme.foo' $(HILITE cannot call impure function)
'deneme.şablon!0.şablon'
)

$(P
Öte yandan, şablonun örneğin $(C 1) değeri ile kullanımı saftır ve kod derlenir:
)

---
void foo() $(HILITE pure) {
    şablon!1();    // ← derlenir
}
---

$(P
$(C writeln) gibi işlevlerin evrensel durumu etkiledikleri için kullanılamadıklarını gördük. Bu gibi kısıtlamalar özellikle hata ayıklama gibi durumlarda büyük sıkıntıya neden olacaklarından $(C debug) olarak işaretlenmiş olan kodlara saf olmasalar bile $(C pure) işlevler içinde izin verilir:
)

---
import std.stdio;

debug size_t fooÇağrılmaSayacı;

void foo(int i) $(HILITE pure) {
    $(HILITE debug) ++fooÇağrılmaSayacı;

    if (i == 0) {
        $(HILITE debug) writeln("i sıfır");
        i = 42;
    }

    // ...
}

void main() {
    foreach (i; 0..100) {
        if ((i % 10) == 0) {
            foo(i);
        }
    }

    debug writefln("foo %s kere çağrıldı", fooÇağrılmaSayacı);
}
---

$(P
Yukarıdaki koddaki saf işlev hem değişebilen evrensel bir değişkeni değiştirmekte hem de çıkışa bir mesaj yazdırmaktadır. Bunlara rağmen derlenebilmesinin nedeni, o işlemlerin $(C debug) olarak işaretlenmiş olmalarıdır.
)

$(P
$(I Not: Hatırlarsanız, o deyimlerin etkinleşmesi için programın $(C -debug) seçeneği ile derlenmesi gerekir.)
)

$(P
Üye işlevler de saf olabilirler. Saf olmayan bir üye işlevin alt sınıftaki tanımı saf olabilir ama bunun tersi doğru değildir. Bunların örneklerini aşağıdaki kodda görmekteyiz:
)

---
interface Arayüz {
    void foo() pure;    // Alt sınıflar foo'yu saf olarak
                        // tanımlamak zorundadırlar.

    void bar();         // Alt sınıflar bar'ı isterlerse saf
                        // olarak da tanımlayabilirler.
}

class Sınıf : Arayüz {
    void foo() pure {    // Gerektiği için pure
        // ...
    }

    void bar() pure {     // Gerekmediği halde pure
        // ...
    }
}
---

$(P
Temsilciler ve isimsiz işlevler de saf olabilirler. Hazır değer olarak tanımlandıklarında derleyici saf olup olmadıklarını otomatik olarak çıkarsar:
)

---
import std.stdio;

void foo(int delegate(double) $(HILITE pure) temsilci) {
    int i = temsilci(1.5);
}

void main() {
    foo(a => 42);                // ← derlenir

    foo((a) {                    $(DERLEME_HATASI)
            writeln("merhaba");
            return 42;
        });
}
---

$(P
Yukarıdaki koddaki $(C foo), parametresinin saf bir temsilci olmasını gerektirmektedir. Derleyici $(C a&nbsp;=>&nbsp;42) temsilcisinin saf olduğunu anlar ve birinci çağrıya izin verir. İkinci temsilci ise saf olmadığı için $(C foo)'ya parametre değeri olarak gönderilemez:
)

$(SHELL_SMALL
Error: function deneme.foo (int delegate(double) $(HILITE pure) temsilci)
is $(HILITE not callable) using argument types (void)
)


$(H6 $(IX nothrow) $(IX throw) $(C nothrow) işlevler)

$(P
D'nin hata düzeneğini $(LINK2 /ders/d/hatalar.html, Hata Yönetimi bölümünde) görmüştük.
)

$(P
Her işlevin hangi durumda ne tür hata atacağı o işlevin belgesinde belirtilmelidir. Ancak, genel bir kural olarak her işlevin her türden hata atabileceği varsayılabilir.
)

$(P
Bazı durumlarda ise çağırdığımız işlevlerin ne tür hatalar atabildiklerini değil, kesinlikle hata atmadıklarını bilmek isteriz. Örneğin, belirli adımlarının kesintisiz olarak devam etmesi gereken bir algoritma o adımlar sırasında hata atılmadığından emin olmak isteyebilir.
)

$(P
$(C nothrow), işlevin hata atmadığını garanti eder:
)

---
int topla(int birinci, int ikinci) $(HILITE nothrow) {
    // ...
}
---

$(P
$(I Not: Hatırlarsanız, "giderilemez derecede hatalı" durumları ifade eden $(C Error) sıradüzeni altındaki hataların yakalanmaları önerilmez. Burada bir işlevin hata atmadığından söz edilirken o işlevin "$(C Exception) sıradüzeni altındaki hatalardan atmadığı" kastediliyor. Yoksa, $(C nothrow) işlevler $(C Error) sıradüzeni altındaki hataları atabilirler.)
)

$(P
Yukarıdaki işlev ne kendisi hata atabilir ne de hata atabilen bir işlevi çağırabilir:
)

---
int topla(int birinci, int ikinci) nothrow {
    writeln("topluyorum");      $(DERLEME_HATASI)
    return birinci + ikinci;
}
---

$(P
Derleme hatası, $(C topla)'nın bu koşula uymadığını bildirir:
)

$(SHELL_SMALL
Error: function deneme.topla 'topla' is nothrow yet $(HILITE may throw)
)

$(P
Bunun nedeni, $(C writeln)'in $(C nothrow) olarak bildirilmiş bir işlev olmamasıdır.
)

$(P
$(IX çıkarsama, nothrow niteliği) $(IX nitelik çıkarsama, nothrow) Derleyici, işlevlerin kesinlikle hata atmayacaklarını da anlayabilir. $(C topla)'nın aşağıdaki tanımında her tür hata yakalandığından $(C nothrow)'un getirdiği garantiler geçerliliğini sürdürür ve işlev $(C nothrow) olmayan işlevleri bile çağırabilir:
)

---
int topla(int birinci, int ikinci) nothrow {
    int sonuç;

    try {
        writeln("topluyorum");   // ← derlenir
        sonuç = birinci + ikinci;

    } catch (Exception hata) {   // bütün hataları yakalar
        // ...
    }

    return sonuç;
}
---

$(P
Yukarıda belirtildiği gibi, $(C nothrow) belirteci $(C Error) sıradüzeni altındaki hataları kapsamaz. Örneğin, dilim elemanına $(C []) işleci ile erişilirken $(C RangeError) atılabileceği halde aşağıdaki işlev yine de $(C nothrow) olarak tanımlanabilir:
)

---
int foo(int[] arr, size_t i) $(HILITE nothrow) {
    return 10 * arr$(HILITE [i]);
}
---

$(P
$(C pure)'da olduğu gibi, şablonların, temsilcilerin, isimsiz işlevlerin, ve $(C auto) işlevlerin hata atıp atmadıkları otomatik olarak çıkarsanır.
)

$(H6 $(IX @nogc) $(C @nogc) işlevler)

$(P
D çöp toplayıcılı bir dildir. Çoğu programda kullanılan çok sayıda değişken ve algoritma, çöp toplayıcıya ait olan dinamik bellek bölgelerini kullanır. Programda kullanımları sona eren dinamik bellek bölgeleri daha sonra $(I çöp toplama) adı verilen bir algoritma ile otomatik olarak sonlandırılır.
)

$(P
Sık kullanılan bazı D olanakları da çöp toplayıcıdan yararlanır. Örneğin, dizi elemanları dinamik bellek bölgelerinde yaşarlar:
)

---
// Dolaylı olarak çöp toplayıcıdan yararlanan bir işlev
int[] ekle(int[] dizi) {
    dizi $(HILITE ~=) 42;
    return dizi;
}
---

$(P
Yukarıdaki $(C ~=) işleci de mevcut sığa yetersiz olduğunda çöp toplayıcıdan yeni bir bellek bölgesi ayırır.
)

$(P
Hem veri yapıları hem de algoritmalar açısından büyük kolaylık getirmelerine rağmen, bellek ayırma ve çöp toplama işlemleri program hızını farkedilir derecede yavaşlatabilir.
)

$(P
"No garbage collector operations"ın kısaltması olan ve "çöp toplayıcı işlemleri içermez" anlamına gelen $(C @nogc), işlevlerin hız kaybına neden olabilecek böyle işlemler içermediğini garanti etmek içindir:
)

---
void foo() $(HILITE @nogc) {
    // ...
}
---

$(P
Derleyici bu garantiyi denetler. Örneğin, aşağıdaki işlev yukarıdaki $(C ekle()) işlevini çağıramaz çünkü $(C ekle()) bu garantiyi vermemektedir:
)

---
void foo() $(HILITE @nogc) {
    int[] dizi;
    // ...
    ekle(dizi);    $(DERLEME_HATASI)
}
---

$(SHELL_SMALL
Error: @nogc function 'deneme.foo' $(HILITE cannot call non-@nogc function)
'deneme.ekle'
)

$(H5 Güvenilirlik olanakları)

$(P
$(IX çıkarsama, @safe niteliği) $(IX nitelik çıkarsama, @safe) $(C @safe), $(C @trusted), ve $(C @system) belirteçleri işlevlerin güvenilirlikleri ile ilgilidir. Yine $(C pure)'da olduğu gibi, şablonların, temsilcilerin, isimsiz işlevlerin, ve $(C auto) işlevlerin güvenilirlikleri otomatik olarak çıkarsanır.
)

$(H6 $(IX @safe) $(C @safe) işlevler)

$(P
Programcı hatalarının önemli bir bölümü farkında olmadan belleğin yanlış yerlerine yazılması ve o yerlerdeki bilgilerin bu yüzden $(I bozulmaları) ile ilgilidir. Bu hatalar genellikle göstergelerin yanlış kullanılmaları ve güvensiz tür dönüşümleri sonucunda oluşur.
)

$(P
"Güvenli" anlamına gelen $(C @safe) işlevler, belleği bozmayacağını garanti eden işlevlerdir.
)

$(P
Bazılarına bu bölümlerde hiç değinmemiş olsam da derleyici $(C @safe) işlevlerde aşağıdaki işlemlere ve olanaklara izin vermez:
)

$(UL

$(LI Göstergeler $(C void*) dışındaki gösterge türlerine dönüştürülemezler.)

$(LI Gösterge olmayan bir değer bir gösterge türüne dönüştürülemez.)

$(LI Göstergelerin değerleri değiştirilemez.)

$(LI Gösterge veya referans üyeleri bulunan birlikler kullanılamaz.)

$(LI $(C @system) olarak bildirilmiş olan işlevler çağrılamaz.)

$(LI $(C Exception) sınıfından türemiş olmayan bir hata yakalanamaz.)

$(LI $(I Inline assembler) kullanılamaz.)

$(LI $(I Değişebilen) değişkenler $(C immutable)'a dönüştürülemezler.)

$(LI $(C immutable) değişkenler $(I değişebilen) türlere dönüştürülemezler.)

$(LI İş parçacıklarının yerel değişkenleri $(C shared)'e dönüştürülemezler.)

$(LI $(C shared) değişkenler iş parçacığının yerel değişkeni olacak şekilde dönüştürülemezler.)

$(LI İşlevlerin yerel değişkenlerinin veya parametrelerinin adresleri alınamaz.)

$(LI $(C __gshared) olarak tanımlanmış olan değişkenlere erişilemez.)

)

$(H6 $(IX @trusted) $(C @trusted) işlevler)

$(P
"Güvenilir" anlamına gelen $(C @trusted) olarak bildirilmiş olan işlevler $(C @safe) olarak bildirilemeyecek oldukları halde tanımsız davranışa neden olmayan işlevlerdir.
)

$(P
Böyle işlevler $(C @safe) işlevlerin yasakladığı işlemleri yapıyor oldukları halde hatalı olmadıkları programcı tarafından garantilenen işlevlerdir. Programcının derleyiciye "bu işleve güvenebilirsin" demesi gibidir.
)

$(P
Derleyici programcının sözüne güvenir ve $(C @trusted) işlevlerin $(C @safe) işlevlerden çağrılmalarına izin verir.
)

$(H6 $(IX @system) $(C @system) işlevler)

$(P
$(C @safe) veya $(C @trusted) olarak bildirilmiş olmayan bütün işlevlerin $(C @system) oldukları varsayılır. Derleyici böyle işlevlerin doğru veya güvenilir olduklarını düşünemez.
)

$(H5 $(IX CTFE) $(IX derleme zamanında işlev işletme, CTFE) Derleme zamanında işlev işletme (CTFE))

$(P
Derleme zamanında yapılabilen hesaplar çoğu programlama dilinde oldukça kısıtlıdır. Bu hesaplar genellikle sabit uzunluklu dizilerin uzunlukları veya hazır değerler kullanan aritmetik işlemler kadar basittir:
)

---
    writeln(1 + 2);
---

$(P
Yukarıdaki $(C 1&nbsp;+&nbsp;2) işlemi derleme zamanında işletilir ve program doğrudan $(C writeln(3)) yazılmış gibi derlenir; o hesap için çalışma zamanında hiç süre harcanmaz.
)

$(P
D'nin "compile time function execution (CTFE)" denen özelliği ise normal olarak çalışma zamanında işletildiklerini düşüneceğimiz işlevlerin bile derleme zamanında işletilmelerini sağlar.
)

$(P
Çıktıya bir menü yazdıran bir programa bakalım:
)

---
import std.stdio;
import std.string;
import std.range;

string menüSatırları(string[] seçenekler) {
    string sonuç;

    foreach (i, seçenek; seçenekler) {
        sonuç ~= format(" %s. %s\n", i + 1, seçenek);
    }

    return sonuç;
}

string menü(string başlık, string[] seçenekler,
            size_t genişlik) {
    return format("%s\n%s\n%s",
                  başlık.center(genişlik),
                  '='.repeat(genişlik),    // yatay çizgi
                  menüSatırları(seçenekler));
}

void main() {
    $(HILITE enum) tatlıMenüsü =
        menü("Tatlılar",
             [ "Baklava", "Kadayıf", "Muhallebi" ], 20);

    writeln(tatlıMenüsü);
}
---

$(P
Aynı iş çok farklı başka yollarla da yapılabilse de, yukarıdaki program bazı işlemler sonucunda bir dizgi üretmekte ve bu dizgiyi çıktıya yazdırmaktadır:
)

$(SHELL_SMALL
      Tatlılar      
====================
 1. Baklava
 2. Kadayıf
 3. Muhallebi
)

$(P
$(C tatlıMenüsü) değişkeni $(C enum) olarak tanımlandığından değerinin derleme zamanında bilinmesi gerektiğini biliyoruz. Bu, $(C menü) işlevinin derleme zamanında işletilmesi için yeterlidir ve döndürdüğü değer $(C tatlıMenüsü)'nü ilklemek için kullanılır. Sonuçta, $(C tatlıMenüsü) değişkeni sanki o işlemlerin sonucunda oluşan dizgi programa açıkça yazılmış gibi derlenir:
)

---
    // Yukarıdaki kodun eşdeğeri:
    enum tatlıMenüsü = "      Tatlılar      \n"
                       "====================\n"
                       " 1. Baklava\n"
                       " 2. Kadayıf\n"
                       " 3. Muhallebi\n";
---

$(P
Bir işlevin derleme zamanında işletilmesi için bunun gerektiği bir ifadede geçmesi yeterlidir:
)

$(UL
$(LI $(C static) bir değişkenin ilklenmesi)
$(LI $(C enum) bir değişkenin ilklenmesi)
$(LI Sabit uzunluklu bir dizinin uzunluğunun hesaplanması)
$(LI Bir değer şablon parametresinin değerinin hesaplanması)
)

$(P
Her işlev derleme zamanında işletilemez. Örneğin, evrensel bir değişkene erişen bir işlev o değişken ancak çalışma zamanında yaşamaya başlayacağından derleme zamanında işletilemez. Benzer biçimde, $(C stdout) da çalışma zamanında yaşamaya başlayacağından çıkışa yazdıran bir işlev de derleme zamanında işletilemez.
)

$(H6 $(IX __ctfe) $(C __ctfe) değişkeni)

$(P
CTFE'nin güçlü bir tarafı, aynı işlevin hem çalışma zamanında hem de derleme zamanında kullanılabilmesidir. İşlevin bunun için farklı yazılması gerekmese de bazı ifadelerin ancak çalışma zamanında etkinleştirilmeleri gerekebilir. Bunun için $(C __ctfe) değişkeninden yararlanılır: Bu değişken işlev derleme zamanında işletilirken $(C true), çalışma zamanında işletilirken $(C false) değerindedir:
)

---
import std.stdio;

size_t sayaç;

int foo() {
    if (!$(HILITE __ctfe)) {
        // Çalışma zamanında işletilmekteyiz
        ++sayaç;
    }

    return 42;
}

void main() {
    enum i = foo();
    auto j = foo();
    writefln("foo %s kere çağrıldı.", sayaç);
}
---

$(P
$(C sayaç) değişkeninin derleme zamanında arttırılması mümkün olmadığından yukarıdaki program onu yalnızca çalışma zamanında işletildiğinde arttırmaktadır. $(C i) derleme zamanında ve $(C j) çalışma zamanında ilklendiklerinden $(C foo) çalışma zamanında 1 kere çağrılmaktadır:
)

$(SHELL_SMALL
foo 1 kere çağrıldı.
)

$(H5 Özet)

$(UL

$(LI $(C auto) işlevin dönüş türü otomatik olarak çıkarsanır.)

$(LI $(C ref) işlevin dönüş değeri var olan bir değişkene referanstır.)

$(LI $(C auto ref) işlevin dönüş değeri referans olabiliyorsa referans, değilse kopyadır.)

$(LI $(C inout), parametrenin $(C const), $(C immutable), veya $(I değişebilen) özelliğini dönüş türüne aktarır.)

$(LI $(C pure) işlev $(I değişebilen) evrensel veya static değerlere erişemez. Şablonların, temsilcilerin, isimsiz işlevlerin, ve $(C auto) işlevlerin saf olup olmadıkları otomatik olarak çıkarsanır.)

$(LI $(C nothrow) işlev hata atamaz. Şablonların, temsilcilerin, isimsiz işlevlerin, ve $(C auto) işlevlerin hata atıp atmadıkları otomatik olarak çıkarsanır.)

$(LI $(C @nogc) işlev çöp toplayıcı işlemleri içeremez.)

$(LI $(C @safe) işlev bellek hatalarına neden olamaz. Şablonların, temsilcilerin, isimsiz işlevlerin, ve $(C auto) işlevlerin $(C @safe) olup olmadıkları otomatik olarak çıkarsanır.)

$(LI $(C @trusted) işlev güvenilir olduğu halde $(C @safe) olarak işaretlenmemiş olan işlevdir; $(C @safe) kabul edilerek derlenir.)

$(LI $(C @system) işlev her D olanağını kullanabilir. $(C @system), varsayılan güvenilirlik belirtecidir.)

$(LI İşlevler derleme zamanında işletilebilirler (CTFE). Bu durum $(C __ctfe) değişkeni ile denetlenebilir.)

)

Macros:
        SUBTITLE=Diğer İşlev Olanakları

        DESCRIPTION=D dili işlevlerinin (fonksiyon) [function] şimdiye kadar gösterilenlerden başka olanakları

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function pure nothrow auto ref inout @safe @trusted @system ctfe __ctfe

SOZLER=
$(cikarsama)
$(cop_toplayici)
$(degismez)
$(evrensel)
$(fonksiyonel_programlama)
$(hata_ayiklama)
$(is_parcacigi)
$(referans)
$(sabit)
$(statik)
$(tanimsiz_davranis)
$(yukleme)
