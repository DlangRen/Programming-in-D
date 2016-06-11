Ddoc

$(DERS_BOLUMU İşlev Göstergeleri, İsimsiz İşlevler, ve Temsilciler)

$(P
İşlev göstergeleri işlevlerin adreslerinin saklanabilmelerini ve daha sonraki bir zamanda bu göstergeler yoluyla çağrılabilmelerini sağlarlar. İşlev göstergeleri D'ye C'den geçmiştir.
)

$(P
Temsilciler hem işlev göstergelerini hem de o işlevlerin kullandıkları kapsamları bir arada saklayan olanaklardır. Saklanan kapsam o temsilcinin içinde oluşturulduğu ortam olabileceği gibi, bir yapı veya sınıf nesnesinin kendisi de olabilir.
)

$(P
Temsilciler çoğu fonksiyonel dilde bulunan $(I kapama) olanağını da gerçekleştirirler.
)

$(H5 $(IX işlev göstergesi) $(IX gösterge, işlev) İşlev göstergeleri)

$(P
$(IX &, işlev adresi) Bundan önceki bölümde $(C is) ifadesini denerken $(C &) işleci ile işlevlerin adreslerinin de alınabildiğini görmüştük. O adresi bir işlev şablonuna parametre olarak göndermiştik.
)

$(P
Şablonların çeşitli türlerle çağrılabilmelerinden ve türlerin $(C .stringof) niteliğinden yararlanarak, işlev göstergelerinin türleri hakkında bilgi edinebiliriz:
)

---
import std.stdio;

int işlev(char c, double d) {
    return 42;
}

void main() {
    şablon($(HILITE &işlev));   // adresinin alınması ve
                      // parametre olarak gönderilmesi
}

void şablon(T)(T parametre) {
    writeln("türü  : ", T.stringof);
    writeln("değeri: ", parametre);
}
---

$(P
O program çalıştırıldığında, $(C işlev) isimli işlevin adresinin türü konusunda bir fikir sahibi olabiliyoruz:
)

$(SHELL
türü  : int function(char c, double d)
değeri: 80495B4
)

$(H6 $(IX üye işlev göstergesi) $(IX gösterge, üye işlev) Üye işlev göstergeleri)

$(P
Üye işlevlerin adresleri hem doğrudan tür üzerinden hem de o türün bir nesnesi üzerinden alınabilir. Bu iki yöntemin etkisi farklıdır:
)

---
struct Yapı {
    void işlev() {
    }
}

void main() {
    auto nesne = Yapı();

    auto f = &$(HILITE Yapı).işlev;    // tür üzerinden
    auto d = &$(HILITE nesne).işlev;   // nesne üzerinden

    static assert(is (typeof($(HILITE f)) == void $(HILITE function)()));
    static assert(is (typeof($(HILITE d)) == void $(HILITE delegate)()));
}
---

$(P
Yukarıdaki $(C static assert) satırlarından da görüldüğü gibi, $(C f) bir $(C function), $(C d) ise bir $(C delegate)'tir. Daha aşağıda göreceğimiz gibi, $(C d) doğrudan çağrılabilir ama $(C f)'nin çağrılabilmesi için önce hangi nesne üzerinde çağrılacağının da belirtilmesi gerekir.
)

$(H6 Tanımlanması)

$(P
$(IX function) İşlev göstergeleri $(C function) anahtar sözcüğü ile tanımlanır. Bu sözcükten önce işlevin dönüş türü, sonra da işlevin aldığı parametreler yazılır:
)

---
   $(I dönüş_türü) function($(I aldığı_parametreler)) gösterge;
---

$(P
Bu tanımda parametrelere isim verilmesi gerekmez; yukarıdaki çıktıda gördüğümüz parametre isimleri olan $(C c)'nin ve $(C d)'nin yazılmaları isteğe bağlıdır. Bir örnek olarak, yukarıdakı $(C işlev) isimli işlevi gösteren bir değişkeni şöyle tanımlayabiliriz:
)

---
    int function(char, double) gösterge = &işlev;
---

$(P
İşlev göstergelerinin yazımı oldukça karmaşık olduğundan o türe $(C alias) ile yeni bir isim vermek kodun okunaklılığını arttırır:
)

---
alias Hesapİşlevi = int function(char, double);
---

$(P
Artık $(C function)'lı uzun yazım yerine kısaca $(C Hesapİşlevi) yazmak yeterlidir.
)

---
    Hesapİşlevi gösterge = &işlev;
---

$(P
$(C auto)'dan da yararlanılabilir:
)

---
    auto gösterge = &işlev;
---

$(H6 Çağrılması)

$(P
İşlev göstergesi olarak tanımlanan değişken, sanki kendisi bir işlevmiş gibi isminden sonraki parametre listesiyle çağrılır ve dönüş değeri kullanılabilir:
)

---
    int sonuç = $(HILITE gösterge)('a', 5.67);
    assert(sonuç == 42);
---

$(P
Yukarıdaki çağrı, işlevin kendi ismiyle $(C işlev('a', 5.67)) olarak çağrılmasının eşdeğeridir.
)

$(H6 Ne zaman kullanmalı)

$(P
İşlev göstergeleri değerlerin saklanmalarına benzer şekilde, işlemlerin de saklanabilmelerini sağlar. Saklanan göstergeler programda daha sonradan işlev gibi kullanılabilirler. Bir anlamda, daha sonradan uygulanacak olan davranışları saklarlar.
)

$(P
Aslında davranış farklılıklarının D'nin başka olanakları ile de sağlanabildiğini biliyorsunuz. Örneğin $(C Çalışan) gibi bir yapının ücretinin hesaplanması sırasında hangi işlevin çağrılacağı, bu yapının bir $(C enum) değeri ile belirlenebilir:
)

---
    final switch (çalışan.tür) {

    case ÇalışanTürü.maaşlı:
        maaşlıÜcretHesabı();
        break;

    case ÇalışanTürü.saatli:
        saatliÜcretHesabı();
        break;
    }
---

$(P
O yöntemin bir yetersizliği, o kod bir kütüphane içinde bulunduğu zaman ortaya çıkar: Bütün $(C enum) değerlerinin ve onlara karşılık gelen bütün işlevlerin kütüphane kodu yazıldığı sırada biliniyor olması gerekmektedir. Farklı bir ücret hesabı gerektiğinde, kütüphane içindeki ilgili $(C switch) deyimlerinin hepsinin yeni türü de içerecek şekilde değiştirilmeleri gerekir.
)

$(P
Davranış farkı konusunda başka bir yöntem, nesne yönelimli programlama olanaklarından yararlanmak olabilir. $(C Çalışan) diye bir arayüz tanımlanabilir ve ücret hesabı ondan türeyen alt sınıflara yaptırılabilir:
)

---
interface Çalışan {
    double ücretHesabı();
}

class MaaşlıÇalışan : Çalışan {
    double ücretHesabı() {
        double sonuç;
        // ...
        return sonuç;
    }
}

class SaatliÇalışan : Çalışan {
    double ücretHesabı() {
        double sonuç;
        // ...
        return sonuç;
    }
}

// ...

    double ücret = çalışan.ücretHesabı();
---

$(P
Bu, nesne yönelimli programlama dillerine uygun olan yöntemdir.
)

$(P
İşlev göstergeleri, davranış farklılığı konusunda kullanılan başkaca bir yöntemdir. İşlev göstergeleri, nesne yönelimli olanakları bulunmayan C dilinde yazılmış olan kütüphanelerde görülebilirler.
)

$(H6 Parametre örneği)

$(P
Kendisine verilen bir dizi sayı ile işlem yapan bir işlev tasarlayalım. Bu işlev, sayıların yalnızca sıfırdan büyük olanlarının on katlarını içeren bir dizi döndürsün:
)

---
$(CODE_NAME süz_ve_dönüştür)int[] süz_ve_dönüştür(const int[] sayılar) {
    int[] sonuç;

    foreach (sayı; sayılar) {
        if (sayı > 0) {                       // süzme,
            immutable yeniDeğer = sayı * 10;  // ve dönüştürme
            sonuç ~= yeniDeğer;
        }
    }

    return sonuç;
}
---

$(P
O işlevi şöyle bir programla deneyebiliriz:
)

---
$(CODE_XREF süz_ve_dönüştür)import std.stdio;
import std.random;

void main() {
    int[] sayılar;

    // Rasgele 20 sayı
    foreach (i; 0 .. 20) {
        sayılar ~= uniform(0, 10) - 5;
    }

    writeln("giriş: ", sayılar);
    writeln("sonuç: ", süz_ve_dönüştür(sayılar));
}
---

$(P
Çıktısından görüldüğü gibi, sonuç yalnızca sıfırdan büyük olanların on katlarını içermektedir:
)

$(SHELL
giriş: -2 0 $(HILITE 3 2 4) -3 $(HILITE 2) -4 $(HILITE 4 2 2 4 2 1) -2 -1 0 $(HILITE 2) -2 $(HILITE 4)
sonuç: 30 20 40 20 40 20 20 40 20 10 20 40
)

$(P
$(C süz_ve_dönüştür) işlevinin bu haliyle fazla kullanışlı olduğunu düşünemeyiz çünkü her zaman için sıfırdan büyük değerlerin on katlarını üretmektedir. Oysa süzme ve dönüştürme işlemlerini nasıl uygulayacağını dışarıdan alabilse çok daha kullanışlı olabilir.
)

$(P
Dikkat ederseniz, süzme işlemi $(C int)'ten $(C bool)'a bir dönüşüm, sayı dönüştürme işlemi de $(C int)'ten yine $(C int)'e bir dönüşümdür:
)

$(UL
$(LI $(C sayı > 0), $(C int) olan sayıya bakarak $(C bool) sonuç elde ediyor.)
$(LI $(C sayı * 10), $(C int) olan sayı kullanarak yine $(C int) üretiyor.)
)

$(P
Bu işlemleri işlev göstergeleri yoluyla yapmaya geçmeden önce, bu dönüşümleri sağlayacak olan işlev gösterge türlerini şöyle tanımlayabiliriz:
)

---
alias Süzmeİşlemi = bool function(int);     // int'ten bool
alias Dönüşümİşlemi = int function(int);    // int'ten int
---

$(P
$(C Süzmeİşlemi), "int alan ve bool döndüren" işlev göstergesi, $(C Dönüşümİşlemi) de "int alan ve int döndüren" işlev göstergesi anlamındadır.
)

$(P
Bu türlerden olan işlev göstergelerini $(C süz_ve_dönüştür) işlevine dışarıdan parametre olarak verirsek süzme ve dönüştürme işlemlerini o işlev göstergelerine yaptırabiliriz. Böylece işlev daha kullanışlı hale gelir:
)

---
int[] süz_ve_dönüştür(const int[] sayılar,
                      $(HILITE Süzmeİşlemi süzücü),
                      $(HILITE Dönüşümİşlemi dönüştürücü)) {
    int[] sonuç;

    foreach (sayı; sayılar) {
        if ($(HILITE süzücü(sayı))) {
            immutable yeniDeğer = $(HILITE dönüştürücü(sayı));
            sonuç ~= yeniDeğer;
        }
    }

    return sonuç;
}
---

$(P
Bu işlev artık asıl süzme ve dönüştürme işlemlerinden bağımsız bir hale gelmiştir çünkü o işlemleri kendisine verilen işlev göstergelerine yaptırmaktadır. Yukarıdaki gibi $(I sıfırdan büyük olanlarının on katlarını) üretebilmesi için şöyle iki küçük işlev tanımlayabiliriz ve $(C süz_ve_dönüştür) işlevini onların adresleri ile çağırabiliriz:
)

---
bool sıfırdanBüyük_mü(int sayı) {
    return sayı > 0;
}

int onKatı(int sayı) {
    return sayı * 10;
}

// ...

    writeln("sonuç: ", süz_ve_dönüştür(sayılar,
                                       $(HILITE &sıfırdanBüyük_mü),
                                       $(HILITE &onKatı)));
---

$(P
Bunun yararı, $(C süz_ve_dönüştür) işlevinin artık bambaşka süzücü ve dönüştürücü işlevleriyle de serbestçe çağrılacak hale gelmiş olmasıdır. Örneğin $(I çift olanlarının ters işaretlileri) şöyle elde edilebilir:
)

---
bool çift_mi(int sayı) {
    return (sayı % 2) == 0;
}

int tersİşaretlisi(int sayı) {
    return -sayı;
}

// ...

    writeln("sonuç: ", süz_ve_dönüştür(sayılar,
                                       &çift_mi,
                                       &tersİşaretlisi));
---

$(P
Çıktısı:
)

$(SHELL
giriş: 2 -3 -3 -2 4 4 3 1 4 3 -4 -1 -2 1 1 -5 0 2 -3 2
sonuç: -2 2 -4 -4 -4 4 2 0 -2 -2
)

$(P
İşlevler $(C çift_mi) ve $(C tersİşaretlisi) gibi çok kısa olduklarında başlı başlarına tanımlanmaları gerekmeyebilir. Bunun nasıl gerçekleştirildiğini biraz aşağıda $(I İsimsiz işlevler) ve özellikle onların $(C =>) söz dizimini tanırken göreceğiz:
)

---
    writeln("sonuç: ", süz_ve_dönüştür(sayılar,
                                       sayı => (sayı % 2) == 0,
                                       sayı => -sayı));
---

$(H6 Üye örneği)

$(P
İşlev göstergeleri değişken olarak kullanılabildikleri için yapı ve sınıf üyeleri de olabilirler. Yukarıdaki $(C süz_ve_dönüştür) işlevi yerine, süzme ve dönüştürme işlemlerini kurucu parametreleri olarak alan bir sınıf da yazılabilir:
)

---
class SüzücüDönüştürücü {
    $(HILITE Süzmeİşlemi süzücü);
    $(HILITE Dönüşümİşlemi dönüştürücü);

    this(Süzmeİşlemi süzücü, Dönüşümİşlemi dönüştürücü) {
        this.süzücü = süzücü;
        this.dönüştürücü = dönüştürücü;
    }

    int[] işlemYap(const int[] sayılar) {
        int[] sonuç;

        foreach (sayı; sayılar) {
            if (süzücü(sayı)) {
                immutable yeniDeğer = dönüştürücü(sayı);
                sonuç ~= yeniDeğer;
            }
        }

        return sonuç;
    }
}
---

$(P
Daha sonra o türden bir nesne oluşturulabilir ve yukarıdaki sonuçların aynıları şöyle elde edilebilir:
)

---
    auto işlemci = new SüzücüDönüştürücü($(HILITE &çift_mi), $(HILITE &tersİşaretlisi));
    writeln("sonuç: ", işlemci.işlemYap(sayılar));
---

$(H5 $(IX isimsiz işlev) $(IX işlev, isimsiz) $(IX işlev, lambda) $(IX işlev hazır değeri) $(IX hazır değer, işlev) $(IX lambda) İsimsiz işlevler)

$(P
Yukarıdaki örnek programlarda $(C süz_ve_dönüştür) işlevinin esnekliğinden yararlanmak için küçük işlevler tanımlandığını ve $(C süz_ve_dönüştür) çağrılırken o küçük işlevlerin adreslerinin gönderildiğini gördük.
)

$(P
Yukarıdaki örneklerde de görüldüğü gibi, işlevin asıl işi az olduğunda başlı başına işlevler tanımlamak külfetli olabilir. Örneğin, $(C sayı&nbsp;>&nbsp;0) ve $(C sayı&nbsp;*&nbsp;10) oldukça basit ve küçük işlemlerdir.
)

$(P
$(I İşlev hazır değeri) olarak da adlandırabileceğimiz $(I isimsiz işlev) olanağı $(ASIL lambda), başka ifadelerin arasında küçük işlevler tanımlamaya yarar. İsimsiz işlevler işlev göstergesi kullanılabilen her yerde şu söz dizimiyle tanımlanabilirler:
)

---
    function $(I dönüş_türü)($(I parametreleri)) { /* ... işlemleri ... */ }
---

$(P
Örneğin, yukarıdaki örnekte tanımladığımız sınıftan olan bir nesneyi $(I ikiden büyük olanlarının yedi katlarını) üretecek şekilde şöyle kullanabiliriz:
)

---
    new SüzücüDönüştürücü(
            function bool(int sayı) { return sayı > 2; },
            function int(int sayı) { return sayı * 7; });
---

$(P
Böylece, hem bu kadar küçük işlemler için ayrıca işlevler tanımlamak zorunda kalmamış oluruz hem de istediğimiz davranışı tam da gereken noktada belirtmiş oluruz.
)

$(P
Yukarıdaki söz dizimlerinin normal işlevlere ne kadar benzediğine dikkat edin. Normal işlevlerle isimsiz işlevlerin söz dizimlerinin bu derece yakın olmaları kolaylık olarak kabul edilebilir. Öte yandan, bu ağır söz dizimi isimsiz işlevlerin kullanım amaçlarıyla hâlâ çelişmektedir çünkü isimsiz işlevler özellikle kısa işlemleri kolayca tanımlama amacını taşırlar.
)

$(P
Bu yüzden isimsiz işlevler çeşitli kısa söz dizimleri ile de tanımlanabilirler.
)

$(H6 Kısa söz dizimi)

$(P
İsimsiz işlevlerin yazımlarında bazı kolaylıklar da vardır. İşlevin dönüş türünün $(C return) satırından anlaşılabildiği durumlarda dönüş türü yazılmayabilir:
)

---
    new SüzücüDönüştürücü(
            function (int sayı) { return sayı > 2; },
            function (int sayı) { return sayı * 7; });
---

$(P
İsimsiz işlevin parametre almadığı durumlarda da parametre listesi yazılmayabilir. Bunu görmek için işlev göstergesi alan bir işlev düşünelim:
)

---
void birİşlev(/* ... işlev göstergesi alsın ... */) {
    // ...
}
---

$(P
O işlevin aldığı parametre, $(C double) döndüren ama parametre almayan bir işlev göstergesi olsun:
)

---
void birİşlev(double function() gösterge) {
    // ...
}
---

$(P
O parametrenin tanımındaki $(C function)'dan sonraki parantezin boş olması, o göstergenin $(I parametre almayan bir işlev göstergesi) olduğunu ifade eder. Böyle bir durumda, isimsiz işlevin oluşturulduğu noktada boş parantez yazmaya da gerek yoktur. Şu üç isimsiz işlev tanımı birbirlerinin eşdeğeridir:
)

---
    birİşlev(function double() { return 42.42; });
    birİşlev(function () { return 42.42; }); // üsttekiyle aynı
    birİşlev(function { return 42.42; });    // üsttekiyle aynı
---

$(P
Birincisi hiçbir kısaltmaya başvurmadan yazılmıştır. İkincisi dönüş türünün $(C return) satırından çıkarsanmasından yararlanmıştır. Üçüncüsü de gereksiz olan boş parametre listesini de yazmamıştır.
)

$(P
Bir adım daha atılabilir ve $(C function) da yazılmayabilir. O zaman bunun isimsiz bir işlev mi yoksa isimsiz bir temsilci mi olduğuna derleyici karar verir. Oluşturulduğu ortamdaki değişkenleri kullanıyorsa temsilcidir, kullanmıyorsa $(C function)'dır:
)

---
    birİşlev({ return 42.42; });    // bu durumda 'function' çıkarsanır
---

$(P
Bazı isimsiz işlevler $(C =>) söz dizimiyle daha da kısa yazılabilirler.
)

$(H6 $(IX =>) Tek $(C return) ifadesi yerine $(C =>) söz dizimi)

$(P
Yukarıdaki en kısa söz dizimi bile gereğinden fazla karmaşık olarak görülebilir. İşlevin parametre listesinin hemen içindeki küme parantezleri okumayı güçleştirmektedirler. Üstelik çoğu isimsiz işlev tek $(C return) deyiminden oluşur. Öyle durumlarda ne $(C return) anahtar sözcüğüne gerek olmalıdır ne de sonundaki noktalı virgüle. D'nin isimsiz işlevlerinin en kısa söz dizimi başka dillerde de bulunan $(C =>) ile sağlanır.
)

$(P
Yalnızca tek $(C return) deyimi içeren bir isimsiz işlevin söz dizimini hatırlayalım:
)

---
    function $(I dönüş_türü)($(I parametreler)) { return $(I ifade); }
---

$(P
$(C function) anahtar sözcüğünün ve dönüş türünün belirtilmelerinin gerekmediğini yukarıda görmüştük:
)

---
    ($(I parametreler)) { return $(I ifade); }
---

$(P
Aynı isimsiz işlev $(C =>) ile çok daha kısa olarak şöyle tanımlanabilir:
)

---
    ($(I parametreler)) => $(I ifade)
---

$(P
Yukarıdaki söz diziminin anlamı, "o parametreler verildiğinde şu ifadeyi (değeri) üret" olarak açıklanabilir.
)

$(P
Dahası, yalnızca tek parametre bulunduğunda etrafındaki parantezler de yazılmayabilir:
)

---
    $(I tek_parametre) => $(I ifade)
---

$(P
Buna rağmen, D'nin gramerinin bir gereği olarak hiç parametre bulunmadığında parametre listesinin boş olarak verilmesi şarttır:
)

---
    () => $(I ifade)
---

$(P
İsimsiz işlevleri başka dillerden tanıyan programcılar $(C =>) karakterlerinden sonra küme parantezleri yazma hatasına düşebilirler. O söz dizimi başka bir anlam taşır:
)

---
    // 'a + 1' döndüren isimsiz işlev
    auto l0 = (int a) => a + 1

    // 'a + 1' döndüren isimsiz işlev döndüren isimsiz işlev
    auto l1 = (int a) => $(HILITE {) return a + 1; $(HILITE })

    assert(l0(42) == 43);
    assert(l1(42)$(HILITE ()) == 43);    // l1'in döndürdüğünün işletilmesi
---

$(P
$(IX filter, std.algorithm) Kısa söz diziminin bir örneğini $(C std.algorithm) modülündeki $(C filter) algoritmasının kullanımında görelim. $(C filter), şablon parametresi olarak bir kıstas, işlev parametresi olarak da bir $(I aralık) alır. Kıstası elemanlara teker teker uygular; $(C false) çıkan elemanları eler ve diğerlerini geçirir. Kıstas, isimsiz işlevler de dahil olmak üzere çeşitli yollarla bildirilebilir.
)

$(P
($(I $(B Not:) Aralık kavramını daha sonraki bir bölümde göreceğiz. Şimdilik dilimlerin aralık olduklarını kabul edebilirsiniz.))
)

$(P
Örneğin, değerleri 10'dan büyük olan elemanları geçiren ve diğerlerini eleyen bir $(C filter) ifadesine şablon parametresi olarak aşağıdaki gibi bir isimsiz işlev verilebilir:
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] sayılar = [ 20, 1, 10, 300, -2 ];
    writeln(sayılar.filter!($(HILITE sayı => sayı > 10)));
}
---

$(P
Çıktısı:
)

$(SHELL
[20, 300]
)

$(P
O kıstası şöyle açıklayabiliriz: $(I bir sayı verildiğinde o sayı 10'dan büyük ise $(C true) üret). Bu açıdan bakıldığında $(C =>) söz diziminin $(I solundaki değere karşılık sağındaki ifadeyi üreten) bir söz dizimi olduğunu düşünebiliriz.
)

$(P
O kısa söz diziminin yerine bir kere de onun eşdeğeri olan en uzun söz dizimini yazalım. İsimsiz işlevin tanımını belirleyen küme parantezlerini sarı ile işaretliyorum:
)

---
    writeln(sayılar.filter!(function bool(int sayı) $(HILITE {)
                                return sayı > 10;
                            $(HILITE })));
---

$(P
Görüldüğü gibi, $(C =>) söz dizimi tek $(C return) deyimi içeren isimsiz işlevlerde büyük kolaylık ve okunaklılık sağlamaktadır.
)

$(P
Başka bir örnek olarak iki parametre kullanan bir isimsiz işlev tanımlayalım. Aşağıdaki algoritma kendisine verilen iki dilimin birbirlerine karşılık olan elemanlarını iki parametre alan bir işleve göndermektedir. O işlevin döndürdüğü sonuçları da bir dizi olarak döndürüyor:
)

---
$(CODE_NAME ikiliHesap)import std.exception;

int[] ikiliHesap(int function$(HILITE (int, int)) işlem,
                 const int[] soldakiler,
                 const int[] sağdakiler) {
    enforce(soldakiler.length == sağdakiler.length);

    int[] sonuçlar;

    foreach (i; 0 .. soldakiler.length) {
        sonuçlar ~= işlem(soldakiler[i], sağdakiler[i]);
    }

    return sonuçlar;
}
---

$(P
Oradaki işlev göstergesi iki parametre aldığından, $(C ikiliHesap)'ın çağrıldığı yerde $(C =>) karakterlerinden önce parantez içinde iki parametre belirtilmelidir:
)

---
$(CODE_XREF ikiliHesap)import std.stdio;

void main() {
    writeln(ikiliHesap($(HILITE (a, b)) => (a * 10) + b,
                       [ 1, 2, 3 ],
                       [ 4, 5, 6 ]));
}
---

$(P
Çıktısı:
)

$(SHELL
[14, 25, 36]
)

$(H5 $(IX delegate) $(IX temsilci) Temsilciler)

$(P
$(IX kapsam) $(IX kapama) Temsilci, işlev göstergesine ek olarak onun içinde tanımlandığı kapsamın da saklanmasından oluşur. Temsilciler daha çok fonksiyonel programlama dillerinde görülen $(I kapamaları) da gerçekleştirirler. Temsilciler çoğu emirli dilde bulunmasalar da D'nin güçlü olanakları arasındadırlar.
)

$(P
$(LINK2 /ders/d/yasam_surecleri.html, Yaşam Süreçleri ve Temel İşlemler bölümünde) gördüğümüz gibi, değişkenlerin yaşamları tanımlı oldukları kapsamdan çıkıldığında son bulur:
)

---
{
    int artış = 10;
    // ...
} // ← artış'ın yaşamı burada son bulur
---

$(P
$(C artış) gibi $(I yerel) değişkenlerin adresleri bu yüzden işlevlerden döndürülemezler.
)

$(P
$(C artış)'ın işlev göstergesi döndüren bir işlev içinde tanımlanmış olan yerel bir değişken olduğunu düşünelim. Bu işlevin sonuç olarak döndürdüğü isimsiz işlev bu yerel değişkeni de kullanıyor olsun:
)

---
alias Hesapİşlevi = int function(int);

Hesapİşlevi hesapçı() {
    int artış = 10;
    return sayı => $(HILITE artış) + sayı;    $(DERLEME_HATASI)
}
---

$(P
Döndürülen isimsiz işlev yerel bir değişkeni kullanmaya çalıştığı için o kod hatalıdır. Derlenmesine izin verilmiş olsa, isimsiz işlev daha sonradan işletildiği sırada yaşamı çoktan sona ermiş olan $(C artış) değişkenine erişmeye çalışacaktır.
)

$(P
O kodun derlenip doğru olarak çalışabilmesi için $(C artış)'ın yaşam sürecinin isimsiz işlev yaşadığı sürece uzatılması gerekir. Temsilciler işte böyle durumlarda yararlıdırlar: Hem işlev göstergesini hem de onun kullandığı kapsamları sakladıkları için o kapsamlardaki değişkenlerin yaşamları, temsilcinin yaşamı kadar uzamış olur.
)

$(P
Temsilcilerin kullanımı işlev göstergelerine çok benzer: Tek farkları $(C function) yerine $(C delegate) anahtar sözcüğünün kullanılmasıdır. Yukarıdaki kodun derlenip doğru olarak çalışması için o kadarı yeterlidir:
)

---
alias Hesapİşlevi = int $(HILITE delegate)(int);

Hesapİşlevi hesapçı() {
    int artış = 10;
    return sayı => artış + sayı;
}
---

$(P
O temsilcinin kullandığı yerel kapsamdaki $(C artış) gibi değişkenlerin yaşamları temsilci yaşadığı sürece devam edecektir. Bu yüzden temsilciler ilerideki bir zamanda çağrıldıklarında o yerel değişkenleri değiştirebilirler de. Bunun örneklerini daha sonraki bir bölümde öğreneceğimiz yapı ve sınıfların $(C opApply) üye işlevlerinde göreceğiz.
)

$(P
Yukarıdaki temsilciyi şöyle bir kodla deneyebiliriz:
)

---
    auto işlev = hesapçı();
    writeln("hesap: ", işlev(3));
---

$(P
$(C hesapçı), isimsiz bir temsilci döndürmektedir. Yukarıdaki kod o temsilciyi $(C işlev) isimli bir değişkenin değeri olarak kullanmakta ve $(C işlev(3)) yazımıyla çağırmaktadır. Temsilcinin işi de kendisine verilen sayı ile $(C artış)'ın toplamını döndürmek olduğu için çıkışa 3 ve 10'un toplamı yazdırılacaktır:
)

$(SHELL
hesap: 13
)

$(H6 Kısa söz dizimi)

$(P
Yukarıdaki örnekte de kullandığımız gibi, temsilciler de kısa söz dizimiyle ve hatta $(C =>) söz dizimiyle yazılabilirler. $(C function) veya $(C delegate) yazılmadığında hangisinin uygun olduğuna derleyici karar verir. Kapsam saklama kaygısı olmadığından daha etkin olarak çalıştığı için öncelikle $(C function)'ı dener, olamıyorsa $(C delegate)'i seçer.
)

$(P
Kısa söz dizimini bir kere de parametre almayan bir temsilci ile görelim:
)

---
int[] özelSayılarOluştur(int adet, int delegate$(HILITE ()) sayıÜretici) {
    int[] sonuç = [ -1 ];
    sonuç.reserve(adet + 2);

    foreach (i; 0 .. adet) {
        sonuç ~= sayıÜretici();
    }

    sonuç ~= -1;

    return sonuç;
}
---

$(P
O işlev ilk ve son sayıları -1 olan bir dizi sayı oluşturmaktadır. Bu iki özel sayının arasına kaç adet başka sayı geleceğini ve bu sayıların nasıl üretileceklerini ise parametre olarak almaktadır.
)

$(P
O işlevi, her çağrıldığında aynı sabit değeri döndüren aşağıdaki gibi bir temsilciyle çağırabiliriz. Yukarıda belirtildiği gibi, parametre almayan isimsiz işlevlerin parametre listesinin boş olarak belirtilmesi şarttır:
)

---
    writeln(özelSayılarOluştur(3, $(HILITE () => 42)));
---

$(P
Çıktısı:
)

$(SHELL
-1 42 42 42 -1
)

$(P
Aynı işlevi bir de yerel bir değişken kullanan bir temsilci ile çağıralım:
)

---
    int sonSayı;
    writeln(özelSayılarOluştur(15, $(HILITE () => sonSayı += uniform(0, 3))));

    writeln("son üretilen sayı: ", sonSayı);
---

$(P
O temsilci rasgele bir değer üretmekte, ama her zaman için son sayıya eklediği için rasgele sayıların değerleri hep artan yönde gitmektedir. Yerel değişkenin temsilcinin işletilmesi sırasında nasıl değişmiş olduğunu da çıktının son satırında görüyoruz:
)

$(SHELL
-1 0 2 3 4 6 6 8 9 9 9 10 12 14 15 17 -1
son üretilen sayı: 17
)

$(H6 $(IX &, nesne temsilcisi) $(IX temsilci, üye işlev) $(IX nesne temsilcisi) $(IX üye işlev temsilcisi) Temsilci olarak nesne ve üye işlevi)

$(P
Temsilcinin bir işlev göstergesini ve onun oluşturulduğu kapsamı bir arada sakladığını gördük. Bu ikisinin yerine belirli bir nesne ve onun bir üye işlevi de kullanılabilir. Böyle oluşturulan temsilci, o üye işlevi ve nesnenin kendisini bir araya getirmiş olur.
)

$(P
Bunun söz dizimi aşağıdaki gibidir:
)

---
    &$(I nesne).$(I üye_işlev)
---

$(P
Önce bu söz diziminin gerçekten de bir $(C delegate) oluşturduğunu yine $(C .stringof)'tan yararlanarak görelim:
)

---
import std.stdio;

struct Konum {
    long x;
    long y;

    void sağa(size_t adım)     { x += adım; }
    void sola(size_t adım)     { x -= adım; }
    void yukarıya(size_t adım) { y += adım; }
    void aşağıya(size_t adım)  { y -= adım; }
}

void main() {
    auto nokta = Konum();
    writeln(typeof($(HILITE &nokta.sağa)).stringof);
}
---

$(P
Çıktısı:
)

$(SHELL
void delegate(ulong adım)
)

$(P
O söz dizimi yalnızca bir temsilci oluşturur. Nesnenin üye işlevi temsilci oluşturulduğu zaman çağrılmaz. O işlev, temsilci daha sonradan işlev gibi kullanıldığında çağrılacaktır. Bunun örneğini görmek için bir temsilci değişken tanımlayabiliriz:
)

---
    auto yönİşlevi = &nokta.sağa;    // burada tanımlanır
    yönİşlevi(3);                    // burada çağrılır
    writeln(nokta);
---

$(P
Çıktısı:
)

$(SHELL
Konum(3, 0)
)

$(P
İşlev göstergeleri, isimsiz işlevler, ve temsilciler kendileri değişken olabildiklerinden; değişkenlerin kullanılabildikleri her yerde kullanılabilirler. Örneğin yukarıdaki nesne ve üye işlevlerinden oluşan bir temsilci dizisi şöyle oluşturulabilir ve daha sonra işlemleri işletilebilir:
)

---
    auto nokta = Konum();

    void delegate(size_t)[] işlemler =
        [ &nokta.sağa, &nokta.yukarıya, &nokta.sağa ];

    foreach (işlem; işlemler) {
        işlem(1);
    }

    writeln(nokta);
---

$(P
O dizide iki kere sağa bir kere de yukarıya gitme işlemi bulunduğundan bütün temsilciler işletildiklerinde noktanın durumu şöyle değişmiş olur:
)

$(SHELL
Konum(2, 1)
)

$(H6 $(IX .ptr, delegate kapsamı) $(IX gösterge, delegate kapsamı) $(IX .funcptr) Temsilci nitelikleri)

$(P
Bir temsilcinin işlev ve kapsam göstergeleri $(C .funcptr) ve $(C .ptr) nitelikleri ile elde edilebilir:
)

---
struct Yapı {
    void işlev() {
    }
}

void main() {
    auto nesne = Yapı();

    auto d = &nesne.işlev;

    assert(d$(HILITE .funcptr) == &Yapı.işlev);
    assert(d$(HILITE .ptr) == &nesne);
}
---

$(P
Bu niteliklere değerler atayarak $(C delegate) oluşturmak mümkündür:
)

---
struct Yapı {
    int i;

    void işlev() {
        import std.stdio;
        writeln(i);
    }
}

void main() {
    auto nesne = Yapı(42);

    void delegate() d;
    assert(d is null);    // null temsilci ile başlıyoruz

    d$(HILITE .funcptr) = &Yapı.işlev;
    d$(HILITE .ptr) = &nesne;

    $(HILITE d());
}
---

$(P
Yukarıdaki $(C d()) söz dizimi ile temsilcinin çağrılması $(C nesne.işlev()) ifadesinin (yani, $(C Yapı.işlev)'in $(C nesne) üzerinde işletilmesinin) eşdeğeridir:
)

$(SHELL
42
)

$(H6 $(IX lazy parametre, temsilci) $(C lazy) parametre temsilcidir)

$(P
$(C lazy) anahtar sözcüğünü $(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri bölümünde) görmüştük:
)

---
void logla(Önem önem, $(HILITE lazy) string mesaj) {
    if (önem >= önemAyarı) {
        writefln("%s", mesaj);
    }
}

// ...

    if (!bağlanıldı_mı) {
        logla(Önem.orta,
              $(HILITE format)("Hata. Bağlantı durumu: '%s'.",
                     bağlantıDurumunuÖğren()));
    }
---

$(P
Yukarıdaki $(C mesaj) isimli parametre $(C lazy) olduğundan, işleve o parametreye karşılık gönderilen bütün $(C format) ifadesi (yaptığı $(C bağlantıDurumunuÖğren()) çağrısı dahil), ancak o parametre işlev içinde kullanıldığında işletilir.
)

$(P
Perde arkasında $(C lazy) parametreler aslında temsilcidirler. O parametrelere karşılık olarak gönderilen ifadeler otomatik olarak temsilci nesnelerine dönüştürülürler. Buna göre, aşağıdaki kod yukarıdakinin eşdeğeridir:
)

---
void logla(Önem önem, string $(HILITE delegate)() tembelMesaj) {  // (1)
    if (önem >= önemAyarı) {
        writefln("%s", $(HILITE tembelMesaj()));                  // (2)
    }
}

// ...

    if (!bağlanıldı_mı) {
        logla(Önem.orta,
              delegate string() $(HILITE {)                       // (3)
                  return
                      format("Hata. Bağlantı durumu: '%s'.",
                             bağlantıDurumunuÖğren());
              $(HILITE }));
    }
---

$(OL

$(LI $(C lazy) parametre $(C string) değildir; $(C string) döndüren bir temsilcidir.)

$(LI O temsilci çağrılır ve dönüş değeri kullanılır.)

$(LI Bütün ifade onu döndüren bir temsilci ile sarmalanır.)

)

$(H6 $(IX belirsiz sayıda lazy parametre) Belirsiz sayıda $(C lazy) parametre)

$(P
Belirsiz sayıda $(C lazy) parametresi olan bir işlevin $(I sayıları belirsiz olan) bu parametreleri $(C lazy) olarak işaretlemesi olanaksızdır.
)

$(P
Bu durumda kullanılan çözüm, belirsiz sayıda $(C delegate) parametre tanımlamaktır. Böyle parametreler temsilcilerin $(I dönüş türüne) uyan bütün ifadeleri parametre değeri olarak kabul ederler. Bir koşul, bu temsilcilerin kendilerinin parametre almamasıdır:
)

---
import std.stdio;

void foo(double delegate()$(HILITE []) parametreler$(HILITE ...)) {
    foreach (parametre; parametreler) {
        writeln($(HILITE parametre()));     // Temsilcinin çağrılması
    }
}

void main() {
    foo($(HILITE 1.5), () => 2.5);    /* 'double' ifade, temsilci
                             * olarak gönderiliyor. */
}
---

$(P
Yukarıdaki hem $(C double) ifade hem de isimsiz işlev belirsiz sayıdaki parametreye uyar. $(C double) ifade otomatik olarak bir temsilci ile sarmalanır ve işlev gereğinde $(I tembel) olarak işletilebilecek olan bu parametrelerinin değerlerini çıkışa yazdırır:
)

$(SHELL
1.5
2.5
)

$(P
Bu yöntemin bir yetersizliği, bütün parametrelerin aynı türden olmalarının gerekmesidir (bu örnekte $(C double)). Daha sonraki $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar bölümünde) göreceğimiz $(I çokuzlu şablon parametreleri) bu yetersizliği giderir.
)

$(H5 $(IX toString, delegate) $(C delegate) parametreli $(C toString))

$(P
Nesneleri $(C string) türünde ifade etmek için kullanılan $(C toString) işlevini kitabın bu noktasına kadar hep parametre almayan ve $(C string) döndüren işlevler olarak tanımladık. Yapılar ve sınıflar kendi üyelerinin $(C toString) işlevlerini $(C format) aracılığıyla dolaylı olarak çağırıyorlardı ve $(C toString) işlevleri kolaylıkla tanımlanabiliyordu:
)

---
import std.stdio;
import std.string;

struct Nokta {
    int x;
    int y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}

struct Renk {
    ubyte r;
    ubyte g;
    ubyte b;

    string toString() const {
        return format("RGB:%s,%s,%s", r, g, b);
    }
}

struct RenkliNokta {
    Renk renk;
    Nokta nokta;

    string toString() const {
        // Bu, Renk.toString ve Nokta.toString'den yararlanıyor:
        return format("{%s;%s}", renk, nokta);
    }
}

struct Poligon {
    RenkliNokta[] noktalar;

    string toString() const {
        // Bu, RenkliNokta.toString'den yararlanıyor
        return format("%s", noktalar);
    }
}

void main() {
    auto poligon = Poligon(
        [ RenkliNokta(Renk(10, 10, 10), Nokta(1, 1)),
          RenkliNokta(Renk(20, 20, 20), Nokta(2, 2)),
          RenkliNokta(Renk(30, 30, 30), Nokta(3, 3)) ]);

    writeln(poligon);
}
---

$(P
Yukarıdaki $(C poligon) nesnesinin programın son satırında çıktıya yazdırılabilmesi için $(C Poligon), $(C RenkliNokta), $(C Renk), ve $(C Nokta) yapılarının $(C toString) işlevlerinden dolaylı olarak yararlanıldığında toplam 10 farklı $(C string) nesnesi oluşturulmaktadır. Dikkat ederseniz, alt düzeylerde oluşturulan her $(C string) nesnesi yalnızca kendi üst düzeyindeki $(C string) nesnesini oluşturmak için kullanılmakta ve ondan sonra yaşamı sona ermektedir.
)

$(P
Sonuçta çıktıya tek mesaj yazdırılmış olmasına rağmen 10 adet $(C string) nesnesi oluşturulmuş, ancak bunlardan yalnızca sonuncusu çıktıya yazdırılmak için kullanılmıştır:
)

$(SHELL
[{RGB:10,10,10;(1,1)}, {RGB:20,20,20;(2,2)}, {RGB:30,30,30;(3,3)}]
)

$(P
Bu yöntem kodun gereksizce yavaş işlemesine neden olabilir.
)

$(P
Bu yavaşlığın önüne geçmek için $(C toString) işlevinin $(C delegate) türünde parametre alan ve genel olarak daha hızlı işleyen çeşidi de kullanılabilir:
)

---
    void toString(void delegate(const(char)[]) çıkış) const;
---

$(P
Dönüş türünün $(C void) olmasından anlaşıldığı gibi, $(C toString)'in bu tanımı $(C string) döndürmez. Onun yerine, çıktıya yazılacak olan karakterleri kendisine verilen temsilciye gönderir. O temsilci de verilen karakterleri sonuçta yazdırılacak olan tek $(C string)'in sonuna ekler.
)

$(P
$(IX formattedWrite, std.format) Bu $(C toString) işlevinden yararlanmak için yapılması gereken, $(C std.string.format) yerine $(C std.format.formattedWrite)'ı çağırmak ve $(C çıkış) isimli parametreyi onun ilk parametresi olarak vermektir:
)

---
import std.stdio;
$(HILITE import std.format;)

struct Nokta {
    int x;
    int y;

    void toString(void delegate(const(char)[]) çıkış) const {
        $(HILITE formattedWrite)(çıkış, "(%s,%s)", x, y);
    }
}

struct Renk {
    ubyte r;
    ubyte g;
    ubyte b;

    void toString(void delegate(const(char)[]) çıkış) const {
        $(HILITE formattedWrite)(çıkış, "RGB:%s,%s,%s", r, g, b);
    }
}

struct RenkliNokta {
    Renk renk;
    Nokta nokta;

    void toString(void delegate(const(char)[]) çıkış) const {
        $(HILITE formattedWrite)(çıkış, "{%s;%s}", renk, nokta);
    }
}

struct Poligon {
    RenkliNokta[] noktalar;

    void toString(void delegate(const(char)[]) çıkış) const {
        $(HILITE formattedWrite)(çıkış, "%s", noktalar);
    }
}

void main() {
    auto poligon = Poligon(
        [ RenkliNokta(Renk(10, 10, 10), Nokta(1, 1)),
          RenkliNokta(Renk(20, 20, 20), Nokta(2, 2)),
          RenkliNokta(Renk(30, 30, 30), Nokta(3, 3)) ]);

    writeln(poligon);
}
---

$(P
Bu programın farkı, yine toplam 10 adet $(C toString) işlevi çağrılmış olmasına rağmen, o çağrıların tek $(C string)'in sonuna karakter eklenmesine neden olmalarıdır.
)

$(H5 Özet)

$(UL
$(LI $(C function) anahtar sözcüğü ile işlev göstergeleri tanımlanabilir ve bu göstergeler daha sonra işlev gibi kullanılabilir.)

$(LI $(C delegate) anahtar sözcüğü temsilci tanımlar. Temsilci, işlev göstergesine ek olarak o işlev göstergesinin kullandığı kapsamı da barındırır.)

$(LI Bir nesne ve onun bir üye işlevi $(C &amp;nesne.üye_işlev) söz dizimi ile $(C delegate) oluşturur.)

$(LI İşlev göstergesi veya temsilci gereken yerlerde isimsiz işlevler veya isimsiz temsilciler tanımlanabilir.)

$(LI Temsilciler $(C .funcptr) ve $(C .ptr) niteliklerine değer atanarak açıkça oluşturulabilirler.)

$(LI İsimsiz işlevlerin çeşitli kısa söz dizimleri vardır. Tek $(C return) deyimi içeren isimsiz işlevler bu söz dizimlerinin en kısası olan $(C parametre => ifade) söz dizimi ile tanımlanabilirler.)

$(LI $(C toString)'in daha hızlı işleyen çeşidi $(C delegate) parametre alır.)

)

Macros:
        SUBTITLE=İşlev Göstergeleri, İsimsiz İşlevler, ve Temsilciler

        DESCRIPTION=İşlev göstergeleri, isimsiz işlevler, ve D'nin fonksiyonel porogramlama (functional programming) olanaklarından olan temsilciler

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial function delegate işlev fonksiyon göstergesi işaretçisi fonksiyonel programlama işlev hazır değeri isimsiz işlev lambda kapama

SOZLER=
$(adres)
$(belirsiz_sayida_parametre)
$(emirli_programlama)
$(fonksiyonel_programlama)
$(gosterge)
$(hazir_deger)
$(isimsiz_islev)
$(kapama)
$(tanimsiz_davranis)
$(tembel_degerlendirme)
$(temsilci)
