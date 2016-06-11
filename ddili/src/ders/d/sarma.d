Ddoc

$(DERS_BOLUMU Sarma ve Erişim Hakları)

$(P
Şimdiye kadar tasarladığımız bütün yapı ve sınıf türlerinin bütün üyeleri dışarıdan erişime açıktı.
)

$(P
Hatırlamak için şöyle bir öğrenci yapısı düşünelim.
)

---
enum Cinsiyet { kız, erkek }

struct Öğrenci {
    string isim;
    Cinsiyet cinsiyet;
}
---

$(P
O yapının nesnelerinin üyelerine istediğimiz gibi erişebiliyorduk:
)

---
    auto öğrenci = Öğrenci("Tolga", Cinsiyet.erkek);
    writefln("%s bir %s öğrencidir.", öğrenci$(HILITE .isim), öğrenci$(HILITE .cinsiyet));
---

$(P
Üyelere böyle serbestçe erişebilmek, o üyeleri programda istediğimiz gibi kullanma olanağı sağladığı için yararlıdır. O kod, öğrenci hakkındaki bilgiyi çıkışa şöyle yazdırır:
)

$(SHELL_SMALL
Tolga bir erkek öğrencidir.
)

$(P
Ancak, üye erişiminin bu kadar serbest olması sakıncalar da doğurabilir. Örneğin belki de yanlışlıkla, öğrencinin yalnızca ismini değiştirdiğimizi düşünelim:
)

---
    öğrenci.isim = "Ayşe";
---

$(P
O atama sonucunda artık nesnenin geçerliliği bozulmuş olabilir:
)

$(SHELL_SMALL
$(HILITE Ayşe) bir $(HILITE erkek) öğrencidir.
)

$(P
Başka bir örnek olarak, bir grup öğrenciyi barındıran $(C Okul) isminde bir sınıfa bakalım. Bu sınıf, okuldaki kız ve erkek öğrencilerin sayılarını ayrı olarak tutuyor olsun:
)

---
class Okul {
    Öğrenci[] öğrenciler;
    size_t $(HILITE kızToplamı);
    size_t $(HILITE erkekToplamı);

    void ekle(in Öğrenci öğrenci) {
        öğrenciler ~= öğrenci;

        final switch (öğrenci.cinsiyet) {

        case Cinsiyet.kız:
            ++kızToplamı;
            break;

        case Cinsiyet.erkek:
            ++erkekToplamı;
            break;
        }
    }

    override string toString() const {
        return format(
            "%s kız, %s erkek; toplam %s öğrenci",
            kızToplamı, erkekToplamı, öğrenciler.length);
    }
}
---

$(P
$(C ekle) işlevini kullanarak o sınıfın nesnelerine yeni öğrenciler ekleyebiliriz:
)

---
    auto okul = new Okul;
    okul.ekle(Öğrenci("Leyla", Cinsiyet.kız));
    okul.ekle(Öğrenci("Metin", Cinsiyet.erkek));
    writeln(okul);
---

$(P
ve tutarlı bir çıktı elde ederiz:
)

$(SHELL_SMALL
1 kız, 1 erkek; toplam 2 öğrenci
)

$(P
Oysa bu sınıfın üyelerine serbestçe erişebiliyor olmak, onun nesnelerini de tutarsız hale getirebilir. Örneğin $(C öğrenciler) üyesine doğrudan yeni bir öğrenci eklediğimizi düşünelim:
)

---
    okul$(HILITE .öğrenciler) ~= Öğrenci("Nimet", Cinsiyet.kız);
---

$(P
Yeni öğrenci, toplamları sayan $(C ekle) işlevi çağrılmadan eklendiği için bu $(C Okul) nesnesi artık tutarsızdır:
)

$(SHELL_SMALL
$(HILITE 1) kız, $(HILITE 1) erkek; toplam $(HILITE 3) öğrenci
)

$(H5 $(IX sarma) Sarma)

$(P
Sarma, bu tür durumları önlemek için üyelere erişimi kısıtlayan bir olanaktır.
)

$(P
Başka bir yararı, kullanıcıların sınıfın iç yapısını bilmek zorunda kalmamalarıdır. Sınıf, sarma yoluyla bir anlamda bir kara kutu haline gelir ve ancak arayüzünü belirleyen işlevler aracılığıyla kullanılabilir.
)

$(P
Kullanıcıların sınıfın üyelerine doğrudan erişememeleri, ayrıca sınıfın iç tasarımının ileride rahatça değiştirilebilmesini de sağlar. Sınıfın arayüzündeki işlevlerin tanımına dokunulmadığı sürece, içinin yapısı istendiği gibi değiştirilebilir.
)

$(P
Sarma, kredi kartı numarası veya şifre gibi değerli veya gizli verilere erişimi kısıtlamak için değildir ve bu amaçla kullanılamaz. Sarma, program geliştirme konusunda yararlı bir olanaktır: Programdaki tanımların kolay ve doğru kullanılmalarını ve kolayca değiştirilebilmelerini sağlar.
)

$(H5 $(IX erişim hakkı) $(IX hak, erişim) Erişim hakları)

$(P
D'de erişim hakları iki bağlamda belirtilebilir:
)

$(UL

$(LI
$(B Yapı veya sınıf düzeyinde): Her yapı veya sınıf üyesinin erişim hakkı ayrıca belirtilebilir.
)

$(LI
$(B Modül düzeyinde): Modül içinde tanımlanmış olan her tür olanağın erişim hakkı ayrıca belirtilebilir: sınıf, yapı, işlev, enum, vs.
)

)

$(P
Bir üyenin veya modül tanımının erişim hakkı aşağıdaki özelliklerden birisi olarak belirtilebilir. Varsayılan erişim $(C public)'tir.
)

$(UL

$(LI $(IX public) $(C public), $(I genel): Programın her tarafından erişilebilmeyi ifade eder; hiçbir erişim kısıtlaması yoktur.

$(P
Bunun bir örneği olarak $(C stdout) standart akımını  düşünebilirsiniz. Onu bildiren $(C std.stdio) modülünün $(C import) ile eklenmesi, $(C stdout)'un serbestçe kullanılabilmesi için yeterlidir.
)

)

$(LI $(IX private) $(C private), $(I özel): özel erişimi ifade eder

$(P
Bu şekilde tanımlanan üyelere içinde tanımlı oldukları sınıfın kodları tarafından, veya o sınıfı barındıran modüldeki kodlar tarafından erişilebilir.
)

$(P
Ek olarak, $(C private) olarak işaretlenmiş olan üye işlevler alt sınıflar tarafından tekrar tanımlanamazlar.
)

)

$(LI $(IX package) $(C package), $(I pakede açık): paketteki modüller tarafından erişilebilmeyi ifade eder

$(P
Bu şekilde işaretlenmiş olan bir tanım, onu barındıran paketteki bütün kodlara açıktır. Bu erişim hakkı yalnızca modülü içeren en içteki pakede verilir.
)

$(P
Örneğin $(C hayvan.omurgalilar.kedi) isimli bir modül içinde $(C package) olarak işaretlenmiş olan bir tanım; $(C kedi) modülünün kendisinden başka, $(C omurgalilar) pakedindeki bütün modüllere de açıktır.
)

$(P
$(C private) belirtecinde olduğu gibi, $(C package) olarak işaretlenmiş olan üye işlevler alt sınıflar tarafından tekrar tanımlanamazlar.
)

)

$(LI $(IX protected) $(C protected), $(I korumalı): türetilen sınıf tarafından da erişilebilmeyi ifade eder

$(P
$(C private) erişimi genişleten bir erişimdir: Bu şekilde işaretlenmiş olan üyeye sınıf tarafından erişilmek yanında, o sınıftan türetilen sınıflardan da erişilebilir.
)

)

)

$(P
$(IX export) Ek olarak, $(C export) belirteci program içinde tanımlanmış olanaklara programın dışından da erişilebilmesini sağlar.
)

$(H5 Belirtilmesi)

$(P
Erişim hakları üç şekilde belirtilebilir.
)

$(P
Tek bir tanımın önüne yazıldığında yalnızca o tanımın erişim haklarını belirler. Bu, Java ve bazı başka dillerdeki gibidir:
)

---
private int birSayı;

private void birİşlev() {
    // ...
}
---

$(P
İki nokta üst üste karakteriyle yazıldığında, aynı şekilde yeni bir erişim hakkı yazılana kadarki bütün tanımları etkiler. Bu, C++'daki gibidir:
)

---
private:
    // ...
    // ... buradaki bütün tanımlar özel ...
    // ...

protected:
    // ...
    // ... buradakiler korumalı ...
    // ...
---

$(P
Blok söz dizimiyle yazıldığında bütün bloğun içini etkiler:
)

---
private {
    // ...
    // ... buradakilerin hepsi özel ...
    // ...
}
---

$(P
Bu üç yöntemin etkisi aynıdır. Hangisini kullanacağınıza tasarımınıza uygun olduğunu düşündüğünüz şekilde serbestçe karar verebilirsiniz.
)

$(H5 $(C import)'lar normalde modüle özeldir)

$(P
$(C import) ile eklenen modüller, o modülü dolaylı olarak ekleyen başka modüller tarafından görülemezler. Örneğin $(C okul) modülü $(C std.stdio) modülünü eklese, $(C okul) modülünü ekleyen başka modüller $(C std.stdio)'dan otomatik olarak yararlanamazlar.
)

$(P
Örneğin $(C okul) modülü şöyle başlıyor olsun:
)

---
module okul.okul;

import std.stdio;       // kendi işi için eklenmiş...

// ...
---

$(P
Onu kullanan şu program derlenemez:
)

---
import okul.okul;

void main() {
    writeln("merhaba");   $(DERLEME_HATASI)
}
---

$(P
O yüzden, $(C std.stdio)'yu asıl modülün ayrıca eklemesi gerekir:
)

---
import okul.okul;
$(HILITE import std.stdio;)

void main() {
    writeln("merhaba");   // şimdi derlenir
}
---

$(P
$(IX public import) $(IX import, public) Bazen, eklenen bir modülün başka modülleri de otomatik ve dolaylı olarak sunması istenebilir. Örneğin $(C okul) isimli bir modülün eklenmesinin, $(C ogrenci) modülünü de otomatik olarak eklemesi istenebilir. Bu, $(C import) işlemi $(C public) olarak işaretlenerek sağlanır:
)

---
module okul.okul;

$(HILITE public import) okul.ogrenci;

// ...
---

$(P
Artık $(C okul) modülünü ekleyen modüller $(C ogrenci) modülünü açıkça eklemek zorunda kalmadan, onun içindeki $(C Öğrenci) yapısını kullanabilirler:
)

---
import okul.okul;

void main() {
    auto öğrenci = Öğrenci("Tolga", Cinsiyet.erkek);

    // ...
}
---

$(P
O program yalnızca $(C okul) modülünü eklediği halde $(C Öğrenci) yapısını da kullanabilmektedir.
)

$(H5 Sarmayı ne zaman kullanmalı)

$(P
Sarma, giriş bölümünde gösterdiğim sorunları önlemek ve sınıf tasarımlarını serbest bırakmak için çok etkili bir olanaktır.
)

$(P
Üyelerin ve başka değişkenlerin ilgisiz kodlar tarafından serbestçe değiştirilmeleri önlenmiş olur. Böylece, yukarıdaki $(C ekle) işlevinde olduğu gibi, nesnelerin tutarlılıkları denetim altına alınmış olur.
)

$(P
Ayrıca, başka kodlar yapı ve sınıf gerçekleştirmelerine bağımlı kalmamış olurlar. Örneğin $(C Okul.öğrenciler) üyesine erişilebiliyor olması, sizin o diziyi daha sonradan örneğin bir eşleme tablosu olarak değiştirmenizi güçleştirir. Çünkü bu değişiklik kullanıcı kodlarını da etkileyecektir.
)

$(P
Sarma, nesne yönelimli programlamanın en yararlı olanakları arasındadır.
)

$(H5 Örnek)

$(P
Yukarıdaki $(C Öğrenci) yapısını ve $(C Okul) sınıfını sarmaya uygun olacak şekilde tanımlayalım ve küçük bir deneme programında kullanalım.
)

$(P
Bu örnekte toplam üç dosya tanımlayacağız. Önceki bölümden de hatırlayacağınız gibi; "okul" isminde bir klasör içinde tanımlandıkları için ilk ikisi $(C okul) pakedinin parçaları olacaklar:
)

$(UL
$(LI "okul/ogrenci.d": $(C Öğrenci) yapısını içeren $(C ogrenci) modülü)
$(LI "okul/okul.d": $(C Okul) sınıfını tanımlayan $(C okul) modülü)
$(LI "deneme.d": küçük bir deneme programı)
)

$(P
Bu programın oluşturulabilmesi için bütün dosyaların belirtilmesi gerektiğini unutmayın:
)

$(SHELL
$ dmd deneme.d okul/ogrenci.d okul/okul.d -w
)

$(P
İlk önce "okul/ogrenci.d" dosyasını görelim:
)

---
module okul.ogrenci;

import std.string;
import std.conv;

enum Cinsiyet { kız, erkek }

struct Öğrenci {
    $(HILITE package) string isim;
    $(HILITE package) Cinsiyet cinsiyet;

    string toString() const {
        return format("%s bir %s öğrencidir.",
                      isim, to!string(cinsiyet));
    }
}
---

$(P
Bu yapının üyelerini yalnızca kendi pakedindeki kodlara açmak için $(C package) olarak belirledim; çünkü biraz sonra göreceğimiz $(C Okul) sınıfının bu yapının üyelerine doğrudan erişmesini istedim.
)

$(P
Aynı pakedin parçası olsa bile başka bir modül tarafından yapının üyelerine erişilmesi, aslında temelde sarmaya karşıdır. Yine de; $(C Öğrenci) ve $(C Okul)'un birbirlerinin üyelerine doğrudan erişebilecek kadar yakın tanımlar oldukları düşünülebilir.
)

$(P
Bu sefer de, o modülden yararlanan "okul/okul.d" dosyasına bakalım:
)

---
module okul.okul;

$(HILITE public import) okul.ogrenci;                    // 1

import std.string;

class Okul {
$(HILITE private:)                                       // 2

    Öğrenci[] öğrenciler;
    size_t kızToplamı;
    size_t erkekToplamı;

$(HILITE public:)                                        // 3

    void ekle(in Öğrenci öğrenci) {
        öğrenciler ~= öğrenci;

        final switch (öğrenci$(HILITE .cinsiyet)) {      // 4a

        case Cinsiyet.kız:
            ++kızToplamı;
            break;

        case Cinsiyet.erkek:
            ++erkekToplamı;
            break;
        }
    }

    override string toString() const {
        string sonuç = format(
            "%s kız, %s erkek; toplam %s öğrenci",
            kızToplamı, erkekToplamı, öğrenciler.length);

        foreach (i, öğrenci; öğrenciler) {
            sonuç ~= (i == 0) ? ": " : ", ";
            sonuç ~= öğrenci$(HILITE .isim);             // 4b
        }

        return sonuç;
    }
}
---

$(OL
$(LI Bu modülü ekleyen programlar $(C ogrenci) modülünü de ayrıca eklemek zorunda kalmasınlar diye; $(C public) olarak ekleniyor. Bir anlamda, bu "ekleme", genele açılıyor.
)

$(LI $(C Okul) sınıfının bütün üyeleri özel olarak işaretleniyor. Bu sayede sınıf nesnelerinin tutarlılığı güvence altına alınmış oluyor.)

$(LI Bu sınıfın herhangi bir şekilde kullanışlı olabilmesi için üye işlevler sunması gerekir; $(C ekle) ve $(C toString) işlevleri, kullanılabilmeleri için $(C public) olarak işaretleniyorlar.
)

$(LI Önceki dosyada $(C package) olarak işaretlendikleri için, $(C Öğrenci) yapısının her iki üyesine de bu modüldeki kodlar tarafından erişilebiliyor.
)

)

$(P
Son olarak bu iki modülü kullanan program dosyasına da bakalım:
)

---
import std.stdio;
import okul.okul;

void main() {
    auto öğrenci = Öğrenci("Tolga", Cinsiyet.erkek);
    writeln(öğrenci);

    auto okul = new Okul;

    okul.ekle(Öğrenci("Leyla", Cinsiyet.kız));
    okul.ekle(Öğrenci("Metin", Cinsiyet.erkek));
    okul.ekle(Öğrenci("Nimet", Cinsiyet.kız));

    writeln(okul);
}
---

$(P
Bu program, $(C Öğrenci) ve $(C Okul)'u ancak genel erişime açık olan arayüzleri aracılığıyla kullanabilir. Ne $(C Öğrenci)'nin, ne de $(C Okul)'un üyelerine erişemez ve bu yüzden nesneler her zaman için tutarlıdır:
)

$(SHELL_SMALL
Tolga bir erkek öğrencidir.
2 kız, 1 erkek; toplam 3 öğrenci: Leyla, Metin, Nimet
)

$(P
Dikkat ederseniz, o program bu tanımları yalnızca $(C Okul.ekle) ve $(C Öğrenci.toString) işlevleri aracılığıyla kullanıyor. O işlevlerin kullanımları değiştirilmediği sürece, $(C Öğrenci)'nin ve $(C Okul)'un tanımlarında yapılan hiçbir değişiklik bu programı etkilemez.
)

Macros:
        SUBTITLE=Sarma ve Erişim Hakları

        DESCRIPTION=Program parçalarının birbirlerinden bağımsızlaştırılmalarına olanak veren sarma kavramı; ve onu sağlayan private, protected, ve public anahtar sözcükleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar yapı struct yapılar sarma encapsulation private protected public

SOZLER=
$(blok)
$(genel_erisim)
$(korumali_erisim)
$(modul)
$(ozel_erisim)
$(paket)
$(sarma)
$(varsayilan)
