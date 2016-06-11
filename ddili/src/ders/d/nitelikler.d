Ddoc

$(DERS_BOLUMU $(IX nitelik) Nitelikler)

$(P
Nitelikler üye işlevlerin üye değişkenlermiş gibi kullanılmalarını sağlayan olanaktır.
)

$(P
Bu olanağı dinamik dizilerden tanıyorsunuz. Dizilerin $(C length) niteliği dizideki eleman adedini bildirir:
)

---
    int[] dizi = [ 7, 8, 9 ];
    assert(dizi$(HILITE .length) == 3);
---

$(P
Yalnızca bu kullanıma, yani uzunluğu bildirmesine bakarsak, $(C length)'in bir üye değişken olarak tasarlandığını düşünebiliriz:
)

---
struct BirDiziGerçekleştirmesi {
    int length;

    // ...
}
---

$(P
Oysa bu niteliğin diğer kullanımı bunun doğru olamayacağını gösterir. Dinamik dizilerde $(C length) niteliğine yeni bir değer atamak dizi uzunluğunu belki de yeni elemanlar ekleyecek biçimde değiştirir:
)

---
    dizi$(HILITE .length = 5);               // Artık 5 eleman var
    assert(dizi.length == 5);
---

$(P $(I Not: Sabit uzunluklu dizilerde $(C length) niteliği değiştirilemez.)
)

$(P
Yukarıdaki atama basit bir değer değişikliği değildir. $(C length)'e yapılan o atamanın arkasında daha karmaşık başka işlemler gizlidir: Dizinin sığasının yeni elemanlar için yeterli olup olmadığına bakılması, gerekiyorsa daha büyük yeni bir yer ayrılması ve dizi elemanlarının o yeni yerin baş tarafına kopyalanmaları.
)

$(P
Bu açıdan bakınca $(C length)'e yapılan atamanın aslında bir işlev gibi çalışması gerektiği görülür.
)

$(P
$(IX @property) Nitelikler, üye değişken gibi kullanılmalarına rağmen duruma göre belki de çok karmaşık işlemleri olan işlevlerdir. Bu işlevler $(C @property) belirteciyle işaretlenerek tanımlanırlar.
)

$(H5 $(IX ()) İşlevlerin parantezsiz çağrılabilmeleri)

$(P
Bir önceki bölümde de değinildiği gibi, parametre değeri gerekmeyen durumlarda işlev çağırırken parantez yazmak gerekmez:
)

---
    writeln();
    writeln;      // Üsttekinin eşdeğeri
---

$(P
Bu olanak niteliklerle çok yakından ilgilidir. Niteliklerin kullanımında hemen hemen hiçbir zaman parantez yazılmaz.
)

$(H5 Değer üreten nitelik işlevleri)

$(P
Çok basit bir örnek olarak yalnızca en ve boy üyeleri bulunan bir dikdörtgen yapısına bakalım:
)

---
struct Dikdörtgen {
    double en;
    double boy;
}
---

$(P
Dikdörtgenin alanını bildiren bir üye daha olsun:
)

---
    auto bahçe = Dikdörtgen(10, 20);
    writeln(bahçe$(HILITE .alan));
---

$(P
Şimdiye kadarki bölümlerde öğrendiğimiz kadarıyla, bunu yukarıdaki söz dizimiyle gerçekleştirebilmek için bir üçüncü üye eklememiz gerekir:
)

---
struct Dikdörtgen {
    double en;
    double boy;
    double alan;
}
---

$(P
Bu tasarımın sakıncası, bu yapının nesnelerinin tutarsız durumlara düşebilecek olmalarıdır: Aralarında her zaman için "en * boy == alan" gibi bir ilişkinin bulunması gerektiği halde bu ilişki üyeler serbestçe değiştirildikçe bozulabilir.
)

$(P
Hatta, nesne tamamen ilgisiz değerlerle bile kurulabilir:
)

---
    // Tutarsız nesne: alanı 10 * 20 == 200 değil, 1111
    auto bahçe = Dikdörtgen(10, 20, $(HILITE 1111));
---

$(P
İşte böyle durumları önlemenin bir yolu, alan bilgisini D'nin $(I nitelik) olanağından yararlanarak sunmaktır. Bu durumda yapıya yeni üye eklenmez, onun değeri $(C @property) olarak işaretlenmiş olan bir işlevin sonucu olarak hesaplanır. İşlevin ismi üye değişken gibi kullanılacak olan isimdir: $(C alan). Bu işlevin dönüş değeri niteliğin değeri haline gelir:
)

---
struct Dikdörtgen {
    double en;
    double boy;

    double alan() const $(HILITE @property) {
        return en * boy;
    }
}
---

$(P $(I Not: İşlev bildiriminin sonundaki $(C const), $(LINK2 /ders/d/const_uye_islevler.html, const ref Parametreler ve const Üye İşlevler bölümünden) hatırlayacağınız gibi, bu nesnenin bu işlev içinde değiştirilmediğini bildirir.)
)

$(P
Artık o yapıyı sanki üçüncü bir üyesi varmış gibi kullanabiliriz:
)

---
    auto bahçe = Dikdörtgen(10, 20);
    writeln("Bahçenin alanı: ", bahçe$(HILITE .alan));
---

$(P
Bu olanak sayesinde, $(C alan) niteliğinin değeri işlevde enin ve boyun çarpımı olarak hesaplandığı için her zaman tutarlı olacaktır:
)

$(SHELL
Bahçenin alanı: 200
)

$(H5 Atama işleci ile kullanılan nitelik işlevleri)

$(P
Dizilerin $(C length) niteliğinde olduğu gibi, kendi tanımladığımız nitelikleri de atama işlemlerinde kullanabiliriz:
)

---
    bahçe.alan = 50;
---

$(P
O atamanın sonucunda alanın gerçekten değişmesi için dikdörtgenin üyelerinin, yani eninin veya boyunun değişmesi gerekir. Bunu sağlamak için dikdörtgenin $(I esnek) olduğunu kabul edebiliriz: "en * boy == alan" ilişkisini koruyabilmek için kenar uzunluklarının değişmeleri gerekir.
)

$(P
Niteliklerin atama işleminde kullanılmalarını sağlayan işlev de $(C @property) ile işaretlenir. İşlevin ismi bu durumda da niteliğin isminin aynısıdır. Atama işleminin sağ tarafında kullanılan değer bu işlevin tek parametresinin değeri haline gelir.
)

$(P
$(C alan) niteliğine değer atamayı da sağlayan bir tür şöyle yazılabilir:
)

---
import std.stdio;
import std.math;

struct Dikdörtgen {
    double en;
    double boy;

    double alan() const @property {
        return en * boy;
    }

    $(HILITE void alan(double yeniAlan) @property) {
        auto büyültme = sqrt(yeniAlan / alan);

        en *= büyültme;
        boy *= büyültme;
    }
}

void main() {
    auto bahçe = Dikdörtgen(10, 20);
    writeln("Bahçenin alanı: ", bahçe.alan);

    $(HILITE bahçe.alan = 50);
    writefln("Yeni durum: %s x %s = %s",
             bahçe.en, bahçe.boy, bahçe.alan);
}
---

$(P
Atama işlemi ile kullanılan işlevde $(C std.math) modülünün karekök almaya yarayan işlevi olan $(C sqrt)'u kullandım. Dikdörtgenin hem eni hem de boyu oranın karekökü kadar değişince alan da yeni değere gelmiş olur.
)

$(P
$(C alan) niteliğine yukarıda dörtte biri kadar bir değer atandığında (200 yerine 50), kenarların uzunlukları yarıya inmiş olur:
)

$(SHELL
Bahçenin alanı: 200
Yeni durum: 5 x 10 = 50
)

$(H5 Nitelikler şart değildir)

$(P
Yukarıdaki örnekteki yapının nasıl sanki üçüncü bir üyesi varmış gibi kullanılabildiğini gördük. Ancak bu hiçbir zaman kesinlikle gerekmez çünkü değişik şekilde yazılıyor olsa da aynı işi üye işlevler yoluyla da gerçekleştirebiliriz:
)

---
import std.stdio;
import std.math;

struct Dikdörtgen {
    double en;
    double boy;

    double $(HILITE alan()) const {
        return en * boy;
    }

    void $(HILITE alanDeğiştir(double yeniAlan)) {
        auto büyültme = sqrt(yeniAlan / alan);

        en *= büyültme;
        boy *= büyültme;
    }
}

void main() {
    auto bahçe = Dikdörtgen(10, 20);
    writeln("Bahçenin alanı: ", bahçe$(HILITE .alan()));

    bahçe$(HILITE .alanDeğiştir(50));
    writefln("Yeni durum: %s x %s = %s",
             bahçe.en, bahçe.boy, bahçe$(HILITE .alan()));
}
---

$(P
Hatta, $(LINK2 /ders/d/islev_yukleme.html, İşlev Yükleme bölümünde) de anlatıldığı gibi, bu iki işlevin isimleri aynı da olabilir:
)

---
    double alan() const {
        // ...
    }

    void alan(double yeniAlan) {
        // ...
    }
---

$(H5 Ne zaman kullanmalı)

$(P
Bu bölümde anlatılan nitelik işlevleri ile daha önceki bölümlerde gördüğümüz erişim işlevleri arasında seçim yapmak her zaman kolay olmayabilir. Bazen erişim işlevleri, bazen nitelikler, bazen de ikisi birden doğal gelecektir. Niteliklerin kullanılmamaları da bir kayıp değildir. Örneğin, C++ gibi başka bazı dillerde nitelik olanağı bulunmaz.
)

$(P
Ancak ne olursa olsun, $(LINK2 /ders/d/sarma.html, Sarma ve Erişim Hakları bölümünde) gördüğümüz gibi, üyelere doğrudan erişimin engellenmesi önemlidir. Yapı ve sınıf tasarımları zamanla geliştikçe üyelerin kullanıcı kodları tarafından doğrudan değiştirilmeleri sorun haline gelebilir. O yüzden, üye erişimlerini mutlaka nitelikler veya erişim işlevleri yoluyla sağlamanızı öneririm.
)

$(P
Örneğin yukarıdaki $(C Dikdörtgen) yapısının $(C en) ve $(C boy) üyelerinin erişime açık bırakılmaları, yani $(C public) olmaları, ancak çok basit yapılarda kabul edilir bir davranıştır.  Normalde bunun yerine ya üye işlevler, ya da nitelikler kullanılmalıdır:
)

---
struct Dikdörtgen {
$(HILITE private:)

    double en_;
    double boy_;

public:

    double alan() const @property {
        return en * boy;
    }

    void alan(double yeniAlan) @property {
        auto büyültme = sqrt(yeniAlan / alan);

        en_ *= büyültme;
        boy_ *= büyültme;
    }

    double $(HILITE en()) const @property {
        return en_;
    }

    double $(HILITE boy()) const @property {
        return boy_;
    }
}
---

$(P
Üyelerin $(C private) olarak işaretlendiklerine ve o sayede değerlerine yalnızca nitelik işlevleri yoluyla erişilebildiklerine dikkat edin.
)

$(P
Ayrıca aynı isimdeki nitelik işlevleriyle karışmasınlar diye üyelerin isimlerinin sonlarına $(C _) karakteri eklediğime dikkat edin. Üye isimlerinin bu şekilde farklılaştırılmaları nesne yönelimli programlamada oldukça sık karşılaşılan bir uygulamadır.
)

$(P
Yukarıda da gördüğümüz gibi, üyelere erişimin nitelik işlevleri yoluyla sağlanması kullanım açısından farklılık getirmez. $(C en) ve $(C boy) yine sanki nesnenin üyeleriymiş gibi kullanılabilir:
)

---
    auto bahçe = Dikdörtgen(10, 20);
    writeln("en: ", bahçe$(HILITE .en), " boy: ", bahçe$(HILITE .boy));
---

$(P
Hatta, atama işleci ile kullanılan nitelik işlevini bu üyeler için bilerek tanımlamadığımız için enin ve boyun dışarıdan değiştirilmeleri de artık olanaksızdır:
)

---
    bahçe.en = 100;    $(DERLEME_HATASI)
---

$(P
Bu da, üyelere yapılan değişikliklerin kendi denetimimiz altında olması açısından çok önemlidir. Bu üyeler ancak bu sınıfın kendi işlevleri tarafından değiştirilebilirler. Nesnelerin tutarlılıkları bu sayede bu türün üye işlevleri tarafından sağlanabilir.
)

$(P
Dışarıdan değiştirilmelerinin yine de uygun olduğu üyeler varsa, atamayı sağlayan nitelik işlevi onlar için özel olarak tanımlanabilir.
)

Macros:
        SUBTITLE=Nitelikler

        DESCRIPTION=İşlev çağrılarını üye değişken yazımıyla sunan sınıf ve yapı niteliklerinin D dilinde tanımlanmaları

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar kullanıcı türleri nitelik property @property

SOZLER=
$(genel_erisim)
$(nitelik)
$(ozel_erisim)
$(sarma)
