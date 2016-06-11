Ddoc

$(DERS_BOLUMU $(IX türeme) $(IX kalıtım) Türeme)

$(P
Daha genel bir türün daha özel bir alt türünü tanımlamaya türetme denir. Türetilen alt tür; genel türün üyelerini edinir, onun gibi davranır, ve onun yerine geçebilir.
)

$(P
$(IX üst sınıf) $(IX alt sınıf) D'de türeme yalnızca sınıflar arasında geçerlidir. Yeni bir sınıf, mevcut başka bir sınıftan türetilerek tanımlanabilir. Bir sınıfın türetildiği türe $(I üst sınıf), ondan türetilen yeni sınıfa da $(I alt sınıf) adı verilir. Üst sınıfın özelliklerinin alt sınıf tarafından edinilmesine $(I kalıtım) denir.
)

$(P
D'de iki tür türeme vardır. Bu bölümde $(I gerçekleştirme türemesi) olan $(C class)'tan türemeyi göstereceğim; $(I arayüz türemesi) olan $(C interface)'ten türemeyi ise daha sonraki bir bölüme bırakacağım.
)

$(P
$(IX :, türeme) Sınıfın hangi sınıftan türetildiği, tanımlanırken isminden sonra yazılan $(C :) karakterinden sonra belirtilir:
)

---
class $(I AltSınıf) : $(I ÜstSınıf) {
    // ...
}
---

$(P
Masa saati kavramını temsil eden bir sınıf olduğunu varsayalım:
)

---
$(CODE_NAME Saat)$(CODE_COMMENT_OUT)class Saat {
    int saat;
    int dakika;
    int saniye;

    void ayarla(int saat, int dakika, int saniye = 0) {
        this.saat = saat;
        this.dakika = dakika;
        this.saniye = saniye;
    }
$(CODE_COMMENT_OUT)}
---

$(P
Bu sınıfın üyelerinin, nesne oluşturulduğu an özel değerler almalarının şart olmadığını varsayalım. O yüzden bu sınıfın kurucu işlevine gerek yok. Saat, daha sonraki bir zamanda $(C ayarla) üye işlevi ile ayarlanabiliyor; ve varsayılan değeri belirtilmiş olduğu için de saniye değerini vermek isteğe bağlı:
)

---
    auto masaSaati = new Saat;
    masaSaati.ayarla(20, 30);
    writefln(
        "%02s:%02s:%02s",
        masaSaati.saat, masaSaati.dakika, masaSaati.saniye);
---

$(P $(I Not: Zaman bilgisini $(C toString) üye işlevi ile yazdırmak çok daha uygun olurdu. O işlevi biraz aşağıda $(C override) anahtar sözcüğünü tanırken ekleyeceğiz.)
)

$(P
Yukarıdaki kodun çıktısı:
)

$(SHELL
20:30:00
)

$(P
Bu kadarına bakarak $(C Saat) sınıfının bir yapı olarak da tanımlanabileceğini düşünebiliriz. Bu üç üyeyi bir yapı olarak da bir araya getirebilirdik, ve o yapı için de üye işlevler tanımlayabilirdik. Programa bağlı olarak, bu kadarı yeterli de olabilirdi.
)

$(P
Oysa $(C Saat)'in sınıf olması, bize ondan yararlanarak yeni türler tanımlama olanağı sunar.
)

$(P
Örneğin, temelde bu $(C Saat) sınıfının olanaklarını olduğu gibi içeren, ve ek olarak alarm bilgisi de taşıyan bir $(C ÇalarSaat) sınıfı düşünebiliriz. Bu sınıfı tek başına tanımlamak istesek; $(C Saat)'in mevcut üç üyesinin aynılarına ek olarak iki tane de alarm üyesi, ve saati ayarlamak için kullanılan $(C ayarla) işlevinin yanında da bir $(C alarmıKur) işlevi gerekirdi.
)

$(P
Bu sınıf, bu anlatıma uygun olarak şöyle gerçekleştirilebilir:
)

---
class ÇalarSaat {
    $(HILITE int saat;)
    $(HILITE int dakika;)
    $(HILITE int saniye;)
    int alarmSaati;
    int alarmDakikası;

    $(HILITE void ayarla(int saat, int dakika, int saniye = 0) {)
        $(HILITE this.saat = saat;)
        $(HILITE this.dakika = dakika;)
        $(HILITE this.saniye = saniye;)
    $(HILITE })

    void alarmıKur(int saat, int dakika) {
        alarmSaati = saat;
        alarmDakikası = dakika;
    }
}
---

$(P
$(C Saat) sınıfında da bulunan üyelerini sarı ile gösterdim. Görüldüğü gibi; $(C Saat) ve $(C ÇalarSaat) sınıflarını aynı program içinde bu şekilde ayrı ayrı tanımlamak oldukça fazla kod tekrarına neden olur.
)

$(P
$(C class)'tan türetmek, bir sınıfın üyelerinin başka bir sınıf tarafından oldukları gibi edinilmelerini sağlar. $(C ÇalarSaat)'i $(C Saat)'ten türeterek tanımlamak, yeni sınıfı büyük ölçüde kolaylaştırır ve kod tekrarını ortadan kaldırır:
)

---
$(CODE_NAME ÇalarSaat)$(CODE_COMMENT_OUT)class ÇalarSaat $(HILITE : Saat) {
    int alarmSaati;
    int alarmDakikası;

    void alarmıKur(int saat, int dakika) {
        alarmSaati = saat;
        alarmDakikası = dakika;
    }
$(CODE_COMMENT_OUT)}
---

$(P
$(C ÇalarSaat)'in $(C Saat)'ten türetildiği bu tanım öncekinin eşdeğeridir. Bu tanımdaki sarı ile işaretli bölüm, bir önceki tanımdaki sarı ile işaretli bölüm yerine geçer.
)

$(P
$(C ÇalarSaat), $(C Saat)'in bütün üye değişkenlerini ve işlevlerini kalıtım yoluyla edindiği için bir $(C Saat) gibi de kullanılabilir:
)

---
    auto başucuSaati = new ÇalarSaat;
    başucuSaati$(HILITE .ayarla(20, 30));
    başucuSaati.alarmıKur(7, 0);
---

$(P
Yeni türün $(C Saat)'ten kalıtım yoluyla edindiği üyeleri de kendi üyeleri haline gelir, ve istendiğinde dışarıdan erişilebilir:
)

---
    writefln("%02s:%02s:%02s ♫%02s:%02s",
             başucuSaati$(HILITE .saat),
             başucuSaati$(HILITE .dakika),
             başucuSaati$(HILITE .saniye),
             başucuSaati.alarmSaati,
             başucuSaati.alarmDakikası);
---

$(P
Yukarıdaki kodun çıktısı:
)

$(SHELL
20:30:00 ♫07:00
)

$(P $(I Not: Onun yerine biraz aşağıda gösterilecek olan $(C ÇalarSaat.toString) işlevini kullanmak çok daha doğru olur.)
)

$(P
Bu örnekte görüldüğü gibi, üye veya üye işlev edinmek amacıyla yapılan türemeye $(I gerçekleştirme türemesi) denir.
)

$(P
$(C Saat)'ten kalıtım yoluyla edinilen üyeler de $(C ÇalarSaat)'in parçaları haline gelirler. Her $(C ÇalarSaat) nesnesinin artık hem kendi tanımladığı alarmla ilgili üyeleri, hem de kalıtımla edindiği saatle ilgili üyeleri vardır.
)

$(P
Belleği bu sefer aşağıya doğru ilerleyen bir şerit olarak hayal edersek, $(C ÇalarSaat) nesnelerinin bellekte aşağıdakine benzer biçimde durduklarını düşünebiliriz:
)

$(MONO
                       │       .       │
                       │       .       │
    nesnenin adresi →  ├───────────────┤
                       │$(GRAY $(I (başka veriler)))│
                       │$(HILITE &nbsp;saat          )│
                       │$(HILITE &nbsp;dakika        )│
                       │$(HILITE &nbsp;saniye        )│
                       │ alarmSaati    │
                       │ alarmDakikası │
                       ├───────────────┤
                       │       .       │
                       │       .       │
)

$(P
$(IX vtbl) Yukarıdaki şekli yalnızca bir fikir vermesi için gösteriyorum. Üyelerin bellekte tam olarak nasıl durdukları derleyicinin kodu derlerken aldığı kararlara bağlıdır. Örneğin, $(I başka veriler) diye işaretlenmiş olan bölümde o türün sanal işlev tablosunu gösteren bir gösterge bulunur. (Nesnelerin belleğe tam olarak nasıl yerleştirildikleri bu kitabın kapsamı dışındadır.)
)

$(H5 $(IX is-a) $(IX o-türdendir ilişkisi) Uyarı: "o türden" ise türetin)

$(P
Gerçekleştirme türemesinin $(I üye edinme) ile ilgili olduğunu gördük. Bu amaçla türetmeyi ancak türler arasında "bu özel tür, o genel türdendir" gibi bir ilişki $(ASIL is-a) kurabiliyorsanız düşünün. Yukarıdaki örnek için böyle bir ilişkinin var olduğunu söyleyebiliriz, çünkü "çalar saat bir saattir."
)

$(P
$(IX has-a) $(IX içerme ilişkisi) Bazı türler arasında ise böyle bir ilişki yoktur. Çoğu durumda türler arasında bir $(I içerme) ilişkisi $(ASIL has-a) vardır. Örneğin $(C Saat) sınıfına $(C Pil) de eklemek istediğimizi düşünelim. $(C Pil) üyesini türeme yoluyla edinmek uygun olmaz, çünkü "saat bir pildir" ifadesi doğru değildir:
)

---
class Saat : Pil {    $(CODE_NOTE_WRONG YANLIŞ TASARIM)
    // ...
}
---

$(P
Bunun nedeni saatin bir pil $(I olmaması) ama bir pil $(I içermesidir). Türler arasında böyle bir içerme ilişkisi bulunduğunda doğru olan içeren türün diğerini üye olarak tanımlamasıdır:
)

---
class Saat {
    Pil pil;          $(CODE_NOTE Doğru tasarım)
    // ...
}
---

$(H5 $(IX tekli türeme) $(IX tekli kalıtım) $(IX sıradüzen) En fazla bir $(C class)'tan türetilebilir)

$(P
Sınıflar birden çok $(C class)'tan türetilemezler.
)

$(P
Örneğin "çalar saat sesli bir alettir" ilişkisini gerçekleştirmek için $(C ÇalarSaat)'i bir de $(C SesliAlet) sınıfından türetmek istesek, derleme hatası ile karşılaşırız:
)

---
class SesliAlet {
    // ...
}

class ÇalarSaat : Saat$(HILITE, SesliAlet) {    $(DERLEME_HATASI)
    // ...
}
---

$(P
$(C interface)'lerden ise istenildiği kadar sayıda türetilebilir. Bunu da daha sonra göreceğiz.
)

$(P
Öte yandan, sınıfların ne kadar derinlemesine türetildiklerinin bir sınırı yoktur:
)

---
class Çalgı {
    // ...
}

class TelliÇalgı : Çalgı {
    // ...
}

class Kemençe : TelliÇalgı {
    // ...
}
---

$(P
Yukarıdaki kodda $(C Kemençe) $(C TelliÇalgı)'dan, $(C TelliÇalgı) da $(C Çalgı)'dan türetilmiştir. Bu tanımda $(C Kemençe), $(C TelliÇalgı) ve $(C Çalgı) özelden genele doğru bir $(I sıradüzen) oluştururlar.
)

$(H5 Sıradüzenin gösterimi)

$(P
Aralarında türeme ilişkisi bulunan türlerin hepsine birden $(I sıradüzen) ismi verilir.
)

$(P
Nesne yönelimli programlamada sıradüzenin geleneksel bir gösterimi vardır: üst sınıflar yukarıda ve alt sınıflar aşağıda olacak şekilde gösterilirler. Sınıflar arasındaki türeme ilişkisi de alt sınıftan üst sınıfa doğru bir okla belirtilir.
)

$(P
Örneğin yukarıdaki sınıf ilişkisini de içeren bir sıradüzen şöyle gösterilir:
)

$(MONO
             Çalgı
             ↗   ↖
    TelliÇalgı   NefesliÇalgı
      ↗    ↖        ↗    ↖
  Kemençe  Saz   Kaval   Ney
)

$(H5 $(IX super, üye erişimi) Üst sınıf üyelerine erişmek için $(C super) anahtar sözcüğü)

$(P
Alt sınıf içinden üst sınıfın üyelerine erişilmek istendiğinde, üst sınıfı temsil etmek için $(C super) anahtar sözcüğü kullanılır.
)

$(P
Örneğin $(C ÇalarSaat) sınıfının üye işlevlerinin içindeyken, $(C Saat)'ten edindiği bir üyeye $(C super.dakika) diye erişilebilir:
)

---
class ÇalarSaat : Saat {
    // ...

    void birÜyeİşlev() {
        $(HILITE super.)dakika = 10; // Saat'ten edindiği dakika değişir
        dakika = 10;       // ... aynı şey
    }
}
---

$(P
Yukarıdaki koddan da anlaşıldığı gibi, $(C super) anahtar sözcüğü her zaman gerekli değildir çünkü bu durumda yalnızca $(C dakika) yazıldığında da üst sınıftaki $(C dakika) anlaşılır. $(C super)'in bu kullanımı, hem üst sınıfta hem de alt sınıfta aynı isimde üyeler bulunduğu durumlardaki karışıklıkları gidermek için yararlıdır. Bunu biraz aşağıdaki $(C super.sıfırla()) ve $(C super.toString()) kullanımlarında göreceğiz.
)

$(P
Sıradüzendeki iki sınıfın aynı isimde üyeleri varsa isim karışıklıkları üyelerin tam isimleri belirtilerek giderilir:
)

---
class Alet {
    string $(HILITE üretici);
}

class Saat : Alet {
    string $(HILITE üretici);
}

class ÇalarSaat : Saat {
    // ...

    void foo() {
        $(HILITE Alet.)üretici = "Öz Saatçilik";
        $(HILITE Saat.)üretici = "En Öz Saatçilik";
    }
}
---

$(H5 $(IX super, kurucu) Üst sınıf üyelerini kurmak için $(C super) anahtar sözcüğü)

$(P
$(C super) anahtar sözcüğü, $(I üst sınıfın kurucusu) anlamına da gelir. Alt sınıfın kurucusundan üst sınıfın kurucusunu çağırmak için kullanılır. Bu kullanımda; $(C this) nasıl bu sınıfın kurucusu ise, $(C super) de üst sınıfın kurucusudur.
)

$(P
Üst sınıfın kurucusunun açıkça çağrılması gerekmez. Eğer alt sınıfın kurucusu üst sınıfın herhangi bir kurucusunu açıkça çağırıyorsa, üst sınıfın kurucusu çağrıldığı noktada işletilir. Öte yandan (ve eğer üst sınıfın varsayılan kurucusu varsa), üst sınıfın varsayılan kurucusu henüz alt sınıf kurucusuna girilmeden otomatik olarak işletilir.
)

$(P
Yukarıdaki $(C Saat) ve $(C ÇalarSaat) sınıflarının kurucularını tanımlamamıştık. Bu yüzden her ikisinin üyeleri de kendi $(C .init) değerleri ile ilklenirler. Hatırlarsanız, o değer $(C int) için sıfırdır.
)

$(P
$(C Saat)'in aşağıdaki gibi bir kurucusu olduğunu varsayalım:
)

---
$(CODE_NAME Saat_ctor)$(CODE_COMMENT_OUT)class Saat {
    this(int saat, int dakika, int saniye) {
        this.saat = saat;
        this.dakika = dakika;
        this.saniye = saniye;
    }

    // ...
$(CODE_COMMENT_OUT)}
---

$(P
Kullanıcıların $(C Saat) nesnelerini bu kurucu ile kurmaları gerektiğini biliyoruz:
)

---
    auto saat = new Saat(17, 15, 0);
---

$(P
Bir $(C Saat) nesnesinin öyle tek başına kurulması doğaldır.
)

$(P
Ancak, kullanıcıların bir $(C ÇalarSaat) kurdukları durumda, onun türemeyle edindiği $(C Saat) parçasını açıkça kurmaları olanaksızdır. Hatta kullanıcılar bazı durumlarda $(C ÇalarSaat)'in bir $(C Saat)'ten türediğini bile bilmek zorunda değillerdir.)

$(P
Kullanıcının tek amacı, yalnızca alt sınıftan bir nesne kurmak ve onu kullanmak olabilir:
)

---
    auto başucuSaati = new ÇalarSaat(/* ... */);
    // ... bir ÇalarSaat olarak kullan ...
---

$(P
Bu yüzden, kalıtımla edindiği üst sınıf parçasını kurmak alt sınıfın görevidir. Üst sınıfın kurucusu $(C super) ismiyle çağrılır:
)

---
$(CODE_NAME ÇalarSaat_ctor)$(CODE_COMMENT_OUT)class ÇalarSaat : Saat {
    this(int saat, int dakika, int saniye,    // Saat için
         int alarmSaati, int alarmDakikası) { // ÇalarSaat için
        $(HILITE super)(saat, dakika, saniye);
        this.alarmSaati = alarmSaati;
        this.alarmDakikası = alarmDakikası;
    }

    // ...
$(CODE_COMMENT_OUT)}
---

$(P
$(C ÇalarSaat)'in kurucusu, hem kendisi için gereken alarmla ilgili bilgileri hem de üst sınıf için gereken saat bilgilerini parametre olarak almakta ve $(C Saat)'in üyelerini $(C super)'i çağırarak kurmaktadır.
)

$(H5 $(IX override) Üye işlevleri $(C override) ile özel olarak tanımlamak)

$(P
Türemenin önemli bir yararı, üst sınıfta bulunan işlevlerin alt sınıf tarafından özel olarak yeniden tanımlanabilmesidir. $(C override), bu kullanımda "hükümsüz kılmak, bastırmak" anlamına gelir. Alt sınıf, üst sınıfın işlevini kendisine uygun olacak şekilde yeniden tanımlayabilir.
)

$(P
$(IX sanal işlev) Alt sınıfta yeniden tanımlanabilen işlevlere $(I sanal işlev) denir. Derleyiciler sanal işlevleri $(I sanal işlev gösterge tabloları) $(ASIL virtual function pointer table (vtbl)) ve $(I vtbl göstergeleri) ile gerçekleştirirler. Bu konu bu kitabın kapsamı dışında olsa da, sanal işlev çağrılarının normal işlev çağrılarından biraz daha yavaş olduklarını bilmeniz gerekir. D'de bütün sınıf işlevleri sanal varsayılırlar. O yüzden, üst sınıfın işlevinin yeniden tanımlanmasının gerekmediği bir durumda o işlevin sanal olmaması için $(C final) olarak işaretlenmesi uygun olur. $(C final) anahtar sözcüğünü daha sonra $(LINK2 /ders/d/interface.html, Arayüzler bölümünde) göreceğiz.
)

$(P
$(C Saat)'in $(C sıfırla) isminde bir üye işlevi olduğunu düşünelim. Bu işlev bütün üyelerin değerlerini sıfırlıyor olsun:
)

---
class Saat {
    void sıfırla() {
        saat = 0;
        dakika = 0;
        saniye = 0;
    }

    // ...
}
---

$(P
Hatırlayacağınız gibi, aynı işlev kalıtım yoluyla $(C ÇalarSaat) tarafından da edinilir ve onun nesneleri ile de kullanılabilir:
)

---
    auto başucuSaati = new ÇalarSaat(20, 30, 0, 7, 0);
    // ...
    başucuSaati.sıfırla();
---

$(P
Ancak, $(C Saat)'in bu $(C sıfırla) işlevinin alarmla ilgili üyelerden haberi yoktur; o, yalnızca kendi sınıfının üyeleri ile ilgili olabilir. Bu yüzden, alt sınıfın üyelerinin de sıfırlanabilmeleri için; üst sınıftaki $(C sıfırla) işlevinin $(I bastırılması), ve alt sınıfta yeniden tanımlanması gerekir:
)

---
class ÇalarSaat : Saat {
    $(HILITE override) void sıfırla() {
        super.sıfırla();
        alarmSaati = 0;
        alarmDakikası = 0;
    }

    // ...
}
---

$(P
Alt sınıfın yalnızca kendi üyelerini sıfırladığına, ve üst sınıfın işini $(C super.sıfırla()) çağrısı yoluyla üst sınıfa havale ettiğine dikkat edin.
)

$(P
Yukarıdaki kodda $(C super.sıfırla()) yerine yalnızca $(C sıfırla()) yazamadığımıza da ayrıca dikkat edin. Eğer yazsaydık, $(C ÇalarSaat) sınıfı içinde bulunduğumuz için öncelikle onun $(sıfırla) işlevi anlaşılırdı, ve içinde bulunduğumuz bu işlev tekrar tekrar kendisini çağırırdı. Sonuçta da program sonsuz döngüye girer, bir bellek sorunu yaşar, ve çökerek sonlanırdı.
)

$(P
$(C toString)'in tanımını bu noktaya kadar geciktirmemin nedeni, her sınıfın bir sonraki bölümde anlatacağım $(C Object) isminde bir sınıftan otomatik olarak türemiş olması ve $(C Object)'in zaten bir $(C toString) işlevi tanımlamış olmasıdır.
)

$(P
Bu yüzden, bir sınıfın $(C toString) işlevinin tanımlanabilmesi için $(C override) anahtar sözcüğünün de kullanılması gerekir:
)

---
$(CODE_NAME Saat_ÇalarSaat)import std.string;

class Saat {
    $(HILITE override) string toString() const {
        return format("%02s:%02s:%02s", saat, dakika, saniye);
    }

    // ...
$(CODE_XREF Saat)$(CODE_XREF Saat_ctor)}

class ÇalarSaat : Saat {
    $(HILITE override) string toString() const {
        return format("%s ♫%02s:%02s", super.toString(),
                      alarmSaati, alarmDakikası);
    }

    // ...
$(CODE_XREF ÇalarSaat)$(CODE_XREF ÇalarSaat_ctor)}
---

$(P
$(C ÇalarSaat)'in işlevinin $(C Saat)'in işlevini $(C super.toString()) diye çağırdığına dikkat edin.
)

$(P
Artık $(C ÇalarSaat) nesnelerini de dizgi olarak ifade edebiliriz:
)

---
$(CODE_XREF Saat_ÇalarSaat)void main() {
    auto masaSaatim = new ÇalarSaat(10, 15, 0, 6, 45);
    writeln($(HILITE masaSaatim));
}
---

$(P
Çıktısı:
)

$(SHELL
10:15:00 ♫06:45
)

$(H5 $(IX çok şekillilik, çalışma zamanı) $(IX çalışma zamanı çok şekilliliği) Alt sınıf nesnesi, üst sınıf nesnesi yerine geçebilir)

$(P
Üst sınıf daha $(I genel), ve alt sınıf daha $(I özel) olduğu için; alt sınıf nesneleri üst sınıf nesneleri yerine geçebilirler. Buna $(I çok şekillilik) denir.
)

$(P
Bu genellik ve özellik ilişkisini "bu tür o türdendir" gibi ifadelerde görebiliriz: "çalar saat bir saattir", "öğrenci bir insandır", "kedi bir omurgalı hayvandır", vs. Bu ifadelere uygun olarak; saatin gerektiği yerde çalar saat, insanın gerektiği yerde öğrenci, omurgalı hayvanın gerektiği yerde de kedi kullanılabilir.
)

$(P
Üst sınıfın yerine kullanılan alt sınıf nesneleri kendi türlerini kaybetmezler. Nasıl normal hayatta bir çalar saatin bir saat olarak kullanılması onun aslında bir çalar saat olduğu gerçeğini değiştirmiyorsa, türemede de değiştirmez. Alt sınıf kendisi gibi davranmaya devam eder.
)

$(P
Elimizde $(C Saat) nesneleri ile çalışabilen bir işlev olsun. Bu işlev kendi işlemleri sırasında bu verilen saati de sıfırlıyor olsun:
)

---
void kullan(Saat saat) {
    // ...
    saat.sıfırla();
    // ...
}
---

$(P
Çok şekilliliğin yararı böyle durumlarda ortaya çıkar. Yukarıdaki işlev $(C Saat) türünden bir parametre beklediği halde, onu bir $(C ÇalarSaat) nesnesi ile de çağırabiliriz:
)

---
    auto masaSaatim = new ÇalarSaat(10, 15, 0, 6, 45);
    writeln("önce : ", masaSaatim);
    $(HILITE kullan(masaSaatim));
    writeln("sonra: ", masaSaatim);
---

$(P
$(C kullan) işlevi, $(C masaSaatim) nesnesini bir $(C ÇalarSaat) olmasına rağmen kabul eder, ve bir $(C Saat) gibi kullanır. Bu, aralarındaki türemenin "çalar saat bir saattir" ilişkisini oluşturmuş olmasındandır. Sonuçta, $(C masaSaatim) nesnesi sıfırlanmıştır:
)

$(SHELL
önce : 10:15:00 ♫06:45
sonra: 00:00:00 ♫$(HILITE 00:00)
)

$(P
Burada dikkatinizi çekmek istediğim önemli nokta, yalnızca saat bilgilerinin değil, alarm bilgilerinin de sıfırlanmış olmasıdır.
)

$(P
$(C kullan) işlevinde bir $(C Saat)'in $(C sıfırla) işlevinin çağrılıyor olmasına karşın; asıl nesne bir $(C ÇalarSaat) olduğu için, o türün özel $(C sıfırla) işlevi çağrılır ve onun tanımı gereği hem saatle ilgili üyeleri, hem de alarmla ilgili üyeleri sıfırlanır.
)

$(P
$(C masaSaatim)'in $(C kullan) işlevine bir $(C Saat)'miş gibi gönderilebilmesi, onun asıl türünde bir değişiklik yapmaz. Görüldüğü gibi, $(C kullan) işlevi bir $(C Saat) nesnesi kullandığını düşündüğü halde, elindeki nesnenin asıl türüne uygun olan $(C sıfırla) işlevi çağrılmıştır.
)

$(P
$(C Saat) sıradüzenine bir sınıf daha ekleyelim. Sıfırlanmaya çalışıldığında üyelerinin rasgele değerler aldığı $(C BozukSaat) sınıfı:
)

---
import std.random;

class BozukSaat : Saat {
    this() {
        super(0, 0, 0);
    }

    override void sıfırla() {
        saat = uniform(0, 24);
        dakika = uniform(0, 60);
        saniye = uniform(0, 60);
    }
}
---

$(P
O türün parametre kullanmadan kurulabilmesi için parametresiz bir kurucu işlev tanımladığına da dikkat edin. O kurucunun tek yaptığı, kendi sorumluğunda bulunan üst sınıfını kurmaktır.
)

$(P
$(C kullan) işlevine bu türden bir nesne gönderdiğimiz durumda da bu türün özel $(C sıfırla) işlevi çağrılır. Çünkü bu durumda da $(C kullan) içindeki $(C saat) parametresinin asıl türü $(C BozukSaat)'tir:
)

---
    auto raftakiSaat = new BozukSaat;
    kullan(raftakiSaat);
    writeln(raftakiSaat);
---

$(P
$(C BozukSaat)'in $(C kullan) içinde sıfırlanması sonucunda oluşan rasgele saat değerleri:
)

$(SHELL
22:46:37
)

$(H5 Türeme geçişlidir)

$(P
Sınıfların birbirlerinin yerine geçmeleri yalnızca türeyen iki sınıfla sınırlı değildir. Alt sınıflar, üst sınıflarının türedikleri sınıfların da yerine geçerler.
)

$(P
Yukarıdaki $(C Çalgı) sıradüzenini hatırlayalım:
)

---
class Çalgı {
    // ...
}

class TelliÇalgı : Çalgı {
    // ...
}

class Kemençe : TelliÇalgı {
    // ...
}
---

$(P
Oradaki türemeler şu iki ifadeyi gerçekleştirirler: "telli çalgı bir çalgıdır" ve "kemençe bir telli çalgıdır". Dolayısıyla, "kemençe bir çalgıdır" da doğru bir ifadedir. Bu yüzden, $(C Çalgı) beklenen yerde $(C Kemençe) de kullanılabilir.
)

$(P
Gerekli türlerin ve üye işlevlerin tanımlanmış olduklarını varsayarsak:
)

---
void güzelÇal(Çalgı çalgı, Parça parça) {
    çalgı.akortEt();
    çalgı.çal(parça);
}

// ...

    auto kemençem = new Kemençe;
    güzelÇal(kemençem, doğaçlama);
---

$(P
$(C güzelÇal) işlevi bir $(C Çalgı) beklediği halde, onu bir $(C Kemençe) ile çağırabiliyoruz; çünkü geçişli olarak "kemençe bir çalgıdır".
)

$(P
Türeme yalnızca iki sınıfla sınırlı değildir. Eldeki probleme bağlı olarak, ve her sınıfın tek bir $(C class)'tan türeyebileceği kuralına uyulduğu sürece, sıradüzen gerektiği kadar kapsamlı olabilir.
)

$(H5 $(IX soyut üye işlev) Soyut üye işlevler ve soyut sınıflar)

$(P
Bazen bir sınıfta bulunmasının doğal olduğu, ama o sınıfın kendisinin tanımlayamadığı işlevlerle karşılaşılabilir. Somut bir gerçekleştirmesi bulunmayan bu işleve bu sınıfın bir $(I soyut işlevi) denir. En az bir soyut işlevi bulunan sınıflara da $(I soyut sınıf) ismi verilir.
)

$(P
Örneğin satranç taşlarını ifade eden bir sıradüzende  $(C SatrançTaşı) sınıfının taşın hamlesinin yasal olup olmadığını sorgulamaya yarayan $(C yasal_mı) isminde bir işlevi olduğunu varsayalım. Böyle bir sıradüzende bu üst sınıf, taşın hangi karelere ilerletilebileceğini bilemiyor olabilir; her taşın hareketi, onunla ilgili olan alt sınıf tarafından biliniyordur: piyonun hareketini $(C Piyon) sınıfı biliyordur, şahın hareketini $(C Şah) sınıfı, vs.
)

$(P
$(IX abstract) $(C abstract) anahtar sözcüğü, o üye işlevin bu sınıfta gerçekleştirilmediğini, ve alt sınıflardan birisinde gerçekleştirilmesinin $(I şart olduğunu) bildirir:
)

---
class SatrançTaşı {
    $(HILITE abstract) bool yasal_mı(in Kare nereden, in Kare nereye);
}
---

$(P
Görüldüğü gibi; o işlev o sınıfta tanımlanmamış, yalnızca $(C abstract) olarak bildirilmiştir.
)

$(P
Soyut sınıf türlerinin nesneleri oluşturulamaz:
)

---
    auto taş = new SatrançTaşı;       $(DERLEME_HATASI)
---

$(P
Bunun nedeni, eksik işlevi yüzünden bu sınıfın kullanılamaz durumda bulunmasıdır. Çünkü; eğer oluşturulabilse, $(C taş.yasal_mı(buKare,&nbsp;şuKare)) gibi bir çağrının sonucunda ne yapılacağı bu sınıf tarafından bilinemez.
)

$(P
Öte yandan, bu işlevin tanımını veren alt sınıfların nesneleri oluşturulabilir; çünkü alt sınıf bu işlevi kendisine göre tanımlamıştır ve işlev çağrısı sonucunda ne yapılacağı böylece bilinir:
)

---
class Piyon : SatrançTaşı {
    override bool yasal_mı(in Kare nereden, in Kare nereye) {
        // ... işlevin piyon tarafından gerçekleştirilmesi ...
        return karar;
    }
}
---

$(P
Bu işlevin tanımını da sunduğu için bu alt sınıftan nesneler oluşturulabilir:
)

---
    auto taş = new Piyon;             // derlenir
---

$(P
Soyut işlevlerin de tanımları bulunabilir. (Alt sınıf yine de kendi tanımını vermek zorundadır.) Örneğin, $(C SatrançTaşı) türünün $(C yasal_mı) işlevi genel denetimler içerebilir:
)

---
class SatrançTaşı {
    $(HILITE abstract) bool yasal_mı(in Kare nereden, in Kare nereye) {
        // 'nereden' karesinin 'nereye' karesinden farklı
        // olduğunu denetliyoruz
        return nereden != nereye;
    }
}

class Piyon : SatrançTaşı{
    override bool yasal_mı(in Kare nereden, in Kare nereye) {
        // Öncelikle hamlenin herhangi bir SatrançTaşı için
        // yasal olduğundan emin oluyoruz
        if (!$(HILITE super.yasal_mı)(nereden, nereye)) {
            return false;
        }

        // ... sonra Piyon için özel karar veriyoruz ...

        return karar;
    }
}
---

$(P
$(C SatrançTaşı) sınıfı $(C yasal_mı) işlevi tanımlanmış olduğu halde yine de sanaldır. $(C Piyon) sınıfının ise nesneleri oluşturulabilir.
)

$(H5 Örnek)

$(P
Bir örnek olarak demir yolunda ilerleyen araçlarla ilgili bir sıradüzene bakalım. Bu örnekte sonuçta şu sıradüzeni gerçekleştirmeye çalışacağız:
)

$(MONO
           DemirYoluAracı
           /     |      \
    Lokomotif   Tren   Vagon { bindir()?, indir()? }
                       /   \
             YolcuVagonu   YükVagonu
)

$(P
$(C Vagon) sınıfının soyut olarak bıraktığı işlevleri aynı satırda soru işaretleriyle belirttim.
)

$(P
Burada amacım yalnızca sınıf ve sıradüzen tasarımlarını göstermek olduğu için fazla ayrıntıya girmeyeceğim ve yalnızca gerektiği kadar kod yazacağım. O yüzden aşağıdaki işlevlerde gerçek işler yapmak yerine yalnızca çıkışa mesaj yazdırmakla yetineceğim.
)

$(P
Yukarıdaki tasarımdaki en genel araç olan $(C DemirYoluAracı) yalnızca ilerleme işiyle ilgilenecek şekilde tasarlanmış olsun. Genel olarak bir $(I demir yolu aracı) olarak kabul edilebilmek için bu tasarımda bundan daha fazlası da gerekmiyor. O sınıfı şöyle tanımlayabiliriz:
)

---
$(CODE_NAME DemirYoluAracı)class DemirYoluAracı {
    void ilerle(in size_t kilometre) {
        writefln("Araç %s kilometre ilerliyor", kilometre);
    }
}
---

$(P
$(C DemirYoluAracı)'ndan türemiş olan bir tür $(C Lokomotif). Bu sınıfın henüz bir özelliği bulunmuyor:
)

---
$(CODE_NAME Lokomotif)$(CODE_XREF DemirYoluAracı)class Lokomotif : DemirYoluAracı {
}
---

$(P
Problemler bölümünde $(C DemirYoluAracı)'na soyut $(C sesÇıkart) işlevini eklediğimiz zaman $(C Lokomotif) türü de $(C sesÇıkart) işlevinin tanımını vermek zorunda kalacak.
)

$(P
Benzer biçimde, $(C Vagon) da bir $(C DemirYoluAracı)'dır. Ancak, eğer vagonların programda yük ve yolcu vagonu olarak ikiye ayrılmaları gerekiyorsa $(I indirme) ve $(I bindirme) işlemlerinin farklı olarak tanımlanmaları gerekebilir. Kullanım amacına uygun olarak her vagon mal veya yolcu taşır. Bu genel tanıma uygun olarak bu sınıfa iki işlev ekleyelim:
)

---
$(CODE_NAME Vagon)class Vagon : DemirYoluAracı {
    $(HILITE abstract) void bindir();
    $(HILITE abstract) void indir();
}
---

$(P
Görüldüğü gibi, bu işlevlerin $(C Vagon) arayüzünde $(I soyut) olarak tanımlanmaları gerekiyor çünkü vagonun indirme ve bindirme işlemleri sırasında tam olarak ne olacağı o vagonun türüne bağlıdır. Bu işlemler $(C Vagon) düzeyinde bilinemez. Yolcu vagonlarının indirme işlemi vagon kapılarının açılması ve yolcuların trenden çıkmalarını beklemek kadar basit olabilir. Yük vagonlarında ise yük taşıyan görevlilere ve belki de vinç gibi bazı araçlara gerek duyulabilir. Bu yüzden $(C indir) ve $(C bindir) işlevlerinin sıradüzenin bu aşamasında soyut olmaları gerekir.
)

$(P
Soyut $(C Vagon) sınıfının soyut işlevlerini gerçekleştirmek, ondan türeyen somut iki sınıfın görevidir:
)

---
$(CODE_NAME YolcuVagonu_YükVagonu)class YolcuVagonu : Vagon {
    override void bindir() {
        writeln("Yolcular biniyor");
    }

    override void indir() {
        writeln("Yolcular iniyor");
    }
}

class YükVagonu : Vagon {
    override void bindir() {
        writeln("Mal yükleniyor");
    }

    override void indir() {
        writeln("Mal boşalıyor");
    }
}
---

$(P
Soyut bir sınıf olması $(C Vagon)'un kullanılamayacağı anlamına gelmez. $(C Vagon) sınıfının kendisinden nesne oluşturulamasa da $(C Vagon) sınıfı bir arayüz olarak kullanılabilir. Yukarıdaki türetmeler "yük vagonu bir vagondur" ve "yolcu vagonu bir vagondur" ilişkilerini gerçekleştirdikleri için bu iki sınıfı $(C Vagon) yerine kullanabiliriz. Bunu biraz aşağıda $(C Tren) sınıfı içinde göreceğiz.
)

$(P
Treni temsil eden sınıfı bir lokomotif ve bir vagon dizisi içerecek biçimde tanımlayabiliriz:
)

---
$(CODE_NAME Tren_members)$(CODE_COMMENT_OUT)class Tren : DemirYoluAracı {
    Lokomotif lokomotif;
    Vagon[] vagonlar;

    // ...
$(CODE_COMMENT_OUT)}
---

$(P
Burada çok önemli bir konuya tekrar dikkatinizi çekmek istiyorum. Her ne kadar $(C Lokomotif) ve $(C Vagon) demir yolu araçları olsalar da, trenin onlardan türetilmesi doğru olmaz. Yukarıda değindiğimiz kuralı hatırlayalım: sınıfların türemeleri için, "bu özel tür, o genel türdendir" gibi bir ilişki bulunması gerekir. Oysa tren ne bir lokomotiftir, ne de vagondur. Tren onları $(I içerir). Bu yüzden lokomotif ve vagon kavramlarını trenin üyeleri olarak tanımladık.
)

$(P
Bir trenin her zaman için lokomotifinin olması gerektiğini kabul edersek geçerli bir $(C Lokomotif) nesnesini şart koşan bir kurucu tanımlamamız gerekir. Vagonlar seçime bağlı iseler onlar da vagon eklemeye yarayan bir işlevle eklenebilirler:
)

---
$(CODE_NAME Tren_ctor)import std.exception;
// ...

$(CODE_COMMENT_OUT)class Tren : DemirYoluAracı {
    // ...

    this(Lokomotif lokomotif) {
        enforce(lokomotif !is null, "Lokomotif null olamaz");
        this.lokomotif = lokomotif;
    }

    void vagonEkle(Vagon[] vagonlar...) {
        this.vagonlar ~= vagonlar;
    }

    // ...
$(CODE_COMMENT_OUT)}
---

$(P
Kurucuya benzer biçimde, $(C vagonEkle) işlevi de vagon nesnelerinin $(C null) olup olmadıklarına bakabilirdi. Bu konuyu gözardı ediyorum.
)

$(P
Trenle ilgili bir durum daha düşünebiliriz. Trenin istasyondan ayrılma ve istasyona gelme işlemlerinin de desteklenmesinin gerektiğini varsayalım:
)

---
$(CODE_NAME Tren)$(CODE_XREF Vagon)class Tren : DemirYoluAracı {
    // ...

    void istasyondanAyrıl(string istasyon) {
        foreach (vagon; vagonlar) {
            vagon.bindir();
        }

        writefln("%s garından ayrılıyoruz", istasyon);
    }

    void istasyonaGel(string istasyon) {
        writefln("%s garına geldik", istasyon);

        foreach (vagon; vagonlar) {
            vagon.indir();
        }
    }
$(CODE_XREF Tren_members)$(CODE_XREF Tren_ctor)}
---

$(P
Bu programda geriye kalan, $(C std.stdio) modülünün eklenmesi ve bu sınıfları kullanan bir $(C main) işlevinin yazılmasıdır:
)

---
$(CODE_XREF Lokomotif)$(CODE_XREF Tren)$(CODE_XREF YolcuVagonu_YükVagonu)import std.stdio;
// ...
void main() {
    auto lokomotif = new Lokomotif;
    auto tren = new Tren(lokomotif);

    tren.vagonEkle(new YolcuVagonu, new YükVagonu);

    tren.istasyondanAyrıl("Ankara");
    tren.ilerle(500);
    tren.istasyonaGel("Haydarpaşa");
}
---

$(P
Programda trene farklı türden iki vagon eklenmektedir: $(C YolcuVagonu) ve $(C YükVagonu). Ek olarak, $(C Tren) sınıfı programda iki farklı arayüzün sunduğu işlevlerle kullanılmaktadır:
)

$(OL

$(LI $(C ilerle) işlevi çağrıldığında $(C tren) nesnesi bir $(C DemirYoluAracı) olarak kullanılmaktadır çünkü o işlev $(C DemirYoluAracı) düzeyinde bildirilmiştir ve $(C Tren) tarafından türeme yoluyla edinilmiştir.)

$(LI $(C istasyondanAyrıl) ve $(C istasyonaGel) işlevleri çağrıldığında ise $(C tren) nesnesi bir $(C Tren) olarak kullanılmaktadır çünkü o işlevler $(C Tren) düzeyinde bildirilmişlerdir.)

)

$(P
Programın çıktısı $(C indir) ve $(C bindir) işlevlerinin vagonların türüne bağlı olarak uygulandığını gösteriyor:
)

$(SHELL
Yolcular biniyor    $(SHELL_NOTE)
Mal yükleniyor      $(SHELL_NOTE)
Ankara garından ayrılıyoruz
Araç 500 kilometre ilerliyor
Haydarpaşa garına geldik
Yolcular iniyor     $(SHELL_NOTE)
Mal boşalıyor       $(SHELL_NOTE)
)

$(H5 Özet)

$(UL
$(LI Türeme, "bu tür o türdendir" ilişkisi içindir.)
$(LI Her sınıf en fazla bir $(C class)'tan türetilebilir.)
$(LI $(C super)'in iki kullanımı vardır: üst sınıfın kurucusunu çağırmak ve üst sınıfın üyelerine erişmek.)
$(LI $(C override), üst sınıfın bir işlevini bu sınıf için özel olarak tanımlar.)
$(LI $(C abstract), soyut işlevin alt sınıflardan birisinde tanımlanmasını şart koşar.)
)

$(PROBLEM_COK

$(PROBLEM
Yukarıdaki sıradüzenin en üst sınıfı olan $(C DemirYoluAracı)'nı değiştirelim. Kaç kilometre ilerlediğini bildirmenin yanında her yüz kilometre için bir de ses çıkartsın:

---
class DemirYoluAracı {
    void ilerle(in size_t kilometre) {
        writefln("Araç %s kilometre ilerliyor:", kilometre);

        foreach (i; 0 .. kilometre / 100) {
            writefln("  %s", $(HILITE sesÇıkart()));
        }
    }
}
---

$(P
Ancak, $(C sesÇıkart) işlevi $(C DemirYoluAracı) sınıfında tanımlanamasın çünkü her aracın kendi özel sesi olsun:
)

$(UL
$(LI $(C Lokomotif) için "çuf çuf")
$(LI $(C Vagon) için "takıtak tukutak")
)

$(P $(I Not: $(C Tren.sesÇıkart) işlevini şimdilik bir sonraki soruya bırakın.)
)

$(P
Her aracın farklı sesi olduğu için $(C sesÇıkart)'ın genel bir tanımı verilemez. O yüzden üst sınıfta soyut olarak bildirilmesi gerekir:
)

---
class DemirYoluAracı {
    // ...

    abstract string sesÇıkart();
}
---

$(P
$(C sesÇıkart) işlevini alt sınıflar için gerçekleştirin ve şu $(C main) ile deneyin:
)

---
$(CODE_XREF Lokomotif)$(CODE_XREF Tren)$(CODE_XREF YolcuVagonu_YükVagonu)void main() {
    auto vagon1 = new YolcuVagonu;
    vagon1.ilerle(100);

    auto vagon2 = new YükVagonu;
    vagon2.ilerle(200);

    auto lokomotif = new Lokomotif;
    lokomotif.ilerle(300);
}
---

$(P
Bu programın aşağıdaki çıktıyı vermesini sağlayın:
)

$(SHELL
Araç 100 kilometre ilerliyor:
  takıtak tukutak
Araç 200 kilometre ilerliyor:
  takıtak tukutak
  takıtak tukutak
Araç 300 kilometre ilerliyor:
  çuf çuf
  çuf çuf
  çuf çuf
)

$(P
Dikkat ederseniz, $(C YolcuVagonu) ile $(C YükVagonu) aynı sesi çıkartıyorlar. O yüzden onların sesi, ortak üst sınıfları olan $(C Vagon) tarafından sağlanabilir.
)

)

$(PROBLEM
$(C sesÇıkart) işlevini $(C Tren) sınıfı için nasıl tanımlayabileceğinizi düşünün.

$(P
Bir fikir: $(C Tren)'in sesini, içerdiği lokomotifin ve vagonların seslerinin birleşimi olarak oluşturabilirsiniz.
)

)

)

Macros:
        SUBTITLE=Türeme

        DESCRIPTION=D dilinde class'tan türeme [implementation inheritance]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar kullanıcı türleri türeme gerçekleştirme türemesi

SOZLER=
$(alt_sinif)
$(arayuz)
$(cok_sekillilik)
$(cokme)
$(gerceklestirme)
$(kalitim)
$(kurucu_islev)
$(phobos)
$(sanal_islev)
$(sanal_islev_tablosu)
$(siraduzen)
$(soyut)
$(turetmek)
$(ust_sinif)
$(varsayilan)
$(yeniden_tanimlama)
