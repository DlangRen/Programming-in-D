Ddoc

$(DERS_BOLUMU $(IX alias) $(CH4 alias) ve $(CH4 with))

$(H5 $(C alias))

$(P
$(C alias) anahtar sözcüğü programda geçen isimlere takma isim vermek için kullanılır. $(C alias), farklı bir olanak olan $(C alias this) ile karıştırılmamalıdır.
)

$(H6 Uzun bir ismi kısaltmak)

$(P
Önceki bölümde gördüğümüz şablonlarda olduğu gibi, programda geçen bazı isimler kullanışsız derecede uzun olabilirler. Daha önce tanımladığımız şu işlevi hatırlayalım:
)

---
Yığın!(Nokta!double) rasgeleNoktalar(int adet) {
    auto noktalar = new Yığın!(Nokta!double);

    // ...
}
---

$(P
Programda açıkça $(C Yığın!(Nokta!double)) yazmanın bir kaç sakıncası görülebilir:
)

$(UL
$(LI Okumayı güçleştirecek derecede karmaşıktır.)

$(LI Onun bir yığın veri yapısı olduğunun ve elemanlarının $(C Nokta) şablonunun $(C double) türü ile kullanılmalarından oluştuğunun her noktada görülmesi gereksiz bir bilgi olarak kabul edilebilir.)

$(LI Programın ihtiyaçlarının değişmesi durumunda örneğin $(C double) yerine artık $(C real) kullanılması gerektiğinde, veya yığın veri yapısı yerine bir ikili ağaç veri yapısı gerektiğinde, türün açıkça yazıldığı her yerde değişiklik yapılması gerekecektir.)

)

$(P
Bu sakıncalar $(C Yığın!(Nokta!double)) ismine tek noktada yeni bir isim vererek giderilebilir:
)

---
alias $(HILITE Noktalar) = Yığın!(Nokta!double);

// ...

$(HILITE Noktalar) rasgeleNoktalar(int adet) {
    auto noktalar = new $(HILITE Noktalar);

    // ...
}
---

$(P
Bir adım daha ileri giderek yukarıdaki $(C alias)'ı iki parça halinde de tanımlayabiliriz:
)

---
alias HassasNokta = Nokta!double;
alias Noktalar = Yığın!HassasNokta;
---

$(P
$(C alias)'ın söz dizimi şöyledir:
)

---
    alias $(I takma_isim) = $(I var_olan_isim);
---

$(P
O tanımdan sonra takma isim daha önceden var olan ismin eşdeğeri haline gelir ve artık aynı biçimde kullanılır.
)

$(P
Bazı D programlarında bu olanağın eski söz dizimine de rastlayabilirsiniz:
)

$(MONO
    // Eski söz dizimini kullanmaya gerek yok:
    alias $(I var_olan_isim) $(I takma_isim);
)

$(P
Türlerin isimlerini modülleriyle birlikte uzun uzun yazmak yerine de $(C alias)'tan yararlanabiliriz. Örneğin $(C okul) ve $(C firma) isimli iki modülde $(C Müdür) isminde iki farklı tür tanımlı olduğunu varsayalım. Bu iki modülün de programa eklendikleri bir durumda yalnızca $(C Müdür) yazıldığında program derlenemez:
)

---
import okul;
import firma;

// ...

    Müdür kişi;             $(DERLEME_HATASI)
---

$(P
Derleyici hangi $(C Müdür) türünü kasdettiğimizi anlayamaz:
)

$(SHELL_SMALL
Error: $(HILITE okul.Müdür) at [...]/okul.d(1) conflicts with
$(HILITE firma.Müdür) at [...]/firma.d(1)
)

$(P
Bunun önüne geçmenin bir yolu, programda kullanmak istediğimiz $(C Müdür)'e bir takma isim vermektir. Böylece her seferinde modülüyle birlikte örneğin $(C okul.Müdür) yazmak zorunda kalmadan birden fazla yerde kullanabiliriz:
)

---
import okul;

alias $(HILITE OkulMüdürü) = okul.Müdür;

void main() {
    $(HILITE OkulMüdürü) kişi;

    // ...

    $(HILITE OkulMüdürü) başkaKişi;
}
---

$(P
$(C alias) programdaki başka çeşit isimlerle de kullanılabilir. Aşağıdaki kod bir değişkene nasıl takma isim verildiğini gösteriyor:
)

---
    int uzunBirDeğişkenİsmi = 42;

    alias değişken = uzunBirDeğişkenİsmi;
    değişken = 43;

    assert(uzunBirDeğişkenİsmi == 43);
---

$(H6 Tasarım esnekliği)

$(P
Her ne kadar ileride değişmeyecek olduğundan emin bile olunsa, tasarımın esnek olması için $(C int) gibi temel türlere bile anlamlı yeni isimler verilebilir:
)

---
alias MüşteriNumarası = int;
alias Şirketİsmi = string;
// ...

struct Müşteri {
    MüşteriNumarası numara;
    Şirketİsmi şirket;
    // ...
}
---

$(P
Sırasıyla $(C int)'in ve $(C string)'in aynıları olsalar da, eğer o yapıyı kullanan kodlar her zaman için $(C MüşteriNumarası) ve $(C Şirketİsmi) yazarlarsa, yapı tanımında $(C int) veya $(C string) yerine başka bir tür kullanıldığında daha az satırda değişiklik gerekmiş olur.
)

$(P
Bu yöntem kodun anlaşılır olmasına da yardım eder. Bir değerin türünün $(C int) yerine $(C MüşteriNumarası) olması, kod okunurken o değerin anlamı konusunda hiçbir şüphe bırakmaz.
)

$(P
Bazı durumlarda böyle tür isimleri bir yapı veya sınıfın içinde de tanımlanabilir. Böylece o yapının veya sınıfın arayüzünde bu takma isimleriyle kullanılırlar. Örnek olarak ağırlık niteliğine sahip bir sınıfa bakalım:
)

---
class Kutu {
private:

    double ağırlık_;

public:

    double ağırlık() const @property {
        return ağırlık_;
    }

    // ...
}
---

$(P
Bu sınıfın üyesinin ve niteliğinin açıkça $(C double) yazılarak tanımlanmış olması kullanıcıların da ağırlığı $(C double) olarak kullanmalarına neden olacaktır:
)

---
    $(HILITE double) toplamAğırlık = 0;

    foreach (kutu; kutular) {
        toplamAğırlık += kutu.ağırlık;
    }
---

$(P
Bunun karşıtı olarak, ağırlığın türünün sınıf içindeki bir $(C alias) ile tanımlandığı duruma bakalım:
)

---
class Kutu {
private:

    $(HILITE Ağırlık) ağırlık_;

public:

    alias $(HILITE Ağırlık) = double;

    $(HILITE Ağırlık) ağırlık() const @property {
        return ağırlık_;
    }

    // ...
}
---

$(P
Kullanıcı kodu da sınıfın arayüzüne bağlı kalarak artık $(C Ağırlık) yazacaktır:
)

---
    $(HILITE Kutu.Ağırlık) toplamAğırlık = 0;

    foreach (kutu; kutular) {
        toplamAğırlık += kutu.ağırlık;
    }
---

$(P
$(C Kutu) sınıfının tasarımcısı $(C Ağırlık)'ı daha sonradan başka şekilde tanımlarsa kodda değiştirilmesi gereken yerlerin sayısı bu sayede azalmış olur.
)

$(H6 $(IX isim gizleme) $(IX gizleme, isim) Üst sınıfın gizlenen isimlerini alt sınıfta görünür yapmak)

$(P
Aynı ismin hem üst sınıfta hem de alt sınıfta bulunması isim çakışmasına neden olur. Alt sınıfta aynı isimde tek bir işlev bile bulunsa, üst sınıfın işlevlerinin isimleri $(I gizlenirler) ve alt sınıf arayüzünde görünmezler:
)

---
class GenelHesap {
    void hesapla(int x) {
        // ...
    }
}

class ÖzelHesap : GenelHesap {
    void hesapla() {
        // ...
    }
}

void main() {
    auto hesap = new ÖzelHesap;
    hesap.hesapla(42);            $(DERLEME_HATASI)
}
---

$(P
O çağrıda 42 değeri kullanıldığından, $(C ÖzelHesap) nesnesinin kalıtım yoluyla edindiği ve $(C int) türünde parametre alan $(C GenelHesap.hesapla) işlevinin çağrılacağını bekleyebiliriz. Oysa, her ne kadar parametre listeleri farklı olsa da $(C ÖzelHesap.hesapla) işlevi, aynı isme sahip olduğu için $(C GenelHesap.hesapla) işlevini gizler ve program derlenmez.
)

$(P $(I Not: Üst sınıf işlevinin alt sınıfta değişik olarak yeniden tanımlanmasından bahsetmediğimize dikkat edin. Öyle olsaydı, $(LINK2 /ders/d/tureme.html, Türeme bölümünde) anlatıldığı gibi, parametre listesini üst sınıftakiyle aynı yapar ve $(C override) anahtar sözcüğünü kullanırdık. Burada, alt sınıfa eklenen yeni bir işlev isminin üst sınıftaki bir isimle aynı olduğu durumdan bahsediyoruz.)
)

$(P
Derleyici, $(C GenelHesap.hesapla)'yı bu gizleme nedeniyle dikkate bile almaz ve $(C ÖzelHesap.hesapla)'nın bir $(C int) ile çağrılamayacağını belirten bir hata verir:
)

$(SHELL_SMALL
Error: function $(HILITE deneme.ÖzelHesap.hesapla ()) is not callable
using argument types $(HILITE (int))
)

$(P
Bunun geçerli bir nedeni vardır: İsim gizleme olmasa, ileride bu sınıflara eklenen veya onlardan çıkartılan $(C hesapla) işlevleri hiçbir uyarı verilmeden kodun istenenden farklı bir işlevi çağırmasına neden olabilirler. İsim gizleme, nesne yönelimli programlamayı destekleyen başka dillerde de bulunan ve bu tür hataları önleyen bir olanaktır.
)

$(P
Gizlenen isimlerin alt sınıf arayüzünde de görünmeleri istendiğinde yine $(C alias)'tan yararlanılır:
)

---
class GenelHesap {
    void hesapla(int x) {
        // ...
    }
}

class ÖzelHesap : GenelHesap {
    void hesapla() {
        // ...
    }

    alias $(HILITE hesapla) = GenelHesap.hesapla;
}
---

$(P
Yukarıdaki $(C alias), üst sınıftaki $(C hesapla) ismini alt sınıf arayüzüne getirir ve böylece gizlenmesini önlemiş olur.
)

$(P
O eklemeden sonra kod artık derlenir ve istenmiş olduğu gibi üst sınıfın $(C hesapla) işlevi çağrılır.
)

$(P
Eğer daha uygun olduğu düşünülürse, üst sınıfın işlevi farklı bir isimle bile görünür hale getirilebilir:
)

---
class GenelHesap {
    void hesapla(int x) {
        // ...
    }
}

class ÖzelHesap : GenelHesap {
    void hesapla() {
        // ...
    }

    alias $(HILITE genelHesapla) = GenelHesap.hesapla;
}

void main() {
    auto hesap = new ÖzelHesap;
    hesap.$(HILITE genelHesapla(42));
}
---

$(P
İsim gizleme üye değişkenler için de geçerlidir. İstendiğinde onların alt sınıf arayüzünde görünmeleri de $(C alias) ile sağlanır.
)

---
class ÜstSınıf {
    int şehir;
}

class AltSınıf : ÜstSınıf {
    string şehir() const @property {
        return "Kayseri";
    }
}
---

$(P
Her ne kadar birisi üye değişken ve diğeri üye işlev olsa da, alt sınıftaki $(C şehir), üst sınıfın aynı isimdeki üyesini gizler ve bu yüzden aşağıdaki kod derlenemez:
)

---
void main() {
    auto nesne = new AltSınıf;
    nesne.şehir = 42;             $(DERLEME_HATASI)
}
---

$(P
Üst sınıfın üye değişkeni $(C alias) ile alt sınıf arayüzüne getirildiğinde kod artık derlenir. Aşağıdaki kod değişkenlerin de yeni isimle kullanılabileceklerini gösteriyor:
)

---
class ÜstSınıf {
    int şehir;
}

class AltSınıf : ÜstSınıf {
    string şehir() const @property {
        return "Kayseri";
    }

    alias $(HILITE şehirKodu) = ÜstSınıf.şehir;
}

void main() {
    auto nesne = new AltSınıf;
    nesne.$(HILITE şehirKodu) = 42;
}
---


$(H5 $(IX with) $(C with))

$(P
$(C with), bir nesnenin veya başka bir ismin tekrarlanmasını önler. Parantez içinde bir ifade veya isim alır ve kendi kapsamı içinde geçen isimleri belirlerken o ifade veya ismi de göz önünde bulundurur:
)

---
struct S {
    int i;
    int j;
}

void main() {
    auto s = S();

    with ($(HILITE s)) {
        $(HILITE i) = 1;    // s.i ile aynı anlamda
        $(HILITE j) = 2;    // s.j ile aynı anlamda
    }
}
---

$(P
Parantez içinde geçici bir nesne de oluşturulabilir. Oluşturulan nesne bir $(LINK2 /ders/d/deger_sol_sag.html, sol değer) haline gelir. Doğal olarak, bu geçici nesnenin yaşam süreci $(C with) kapsamı ile sınırlıdır:
)

---
    with (S()) {
        i = 1;    // geçici nesnenin i üyesi
        j = 2;    // geçici nesnenin j üyesi
    }
---

$(P
Daha sonra $(LINK2 /ders/d/gostergeler.html, Göstergeler bölümünde) göreceğimiz gibi, bu geçici nesnenin yaşamı $(C new) anahtar sözcüğü ile uzatılabilir.
)

$(P
$(C with) özellikle $(C enum) gibi tür isimlerinin $(C case) bloklarında tekrarlanmalarını önlemek için yararlıdır:
)

---
enum Renk { kırmızı, turuncu }

// ...

    final switch (r) $(HILITE with (Renk)) {

    case kırmızı:    // Renk.kırmızı anlamında
        // ...

    case turuncu:    // Renk.turuncu anlamında
        // ...
    }
---

$(H5 Özet)

$(UL

$(LI $(C alias) var olan isimlere takma isimler verir.)

$(LI $(C with) aynı nesnenin veya ismin tekrarlanmasını önler.)

)

Macros:
        SUBTITLE=alias

        DESCRIPTION=Kodun okunurluğunu arttırma amacıyla takma isimler verme olanağı, alias.

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial alias takma isim alias

SOZLER=
$(arayuz)
$(gecici)
$(ifade)
$(isim_gizleme)
$(kalitim)
$(sablon)
$(takma_isim)
