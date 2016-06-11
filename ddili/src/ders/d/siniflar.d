Ddoc

$(DERS_BOLUMU $(IX class) $(IX sınıf) Sınıflar)

$(P
$(IX OOP) $(IX NYP) $(IX nesne yönelimli programlama) Sınıflar kullanıcı türü tanımlamaya yarayan başka bir olanaktır. D'nin nesne yönelimli programlama olanakları sınıflar yoluyla gerçekleştirilir. Nesne yönelimli programlamayı üç temel kavram üzerinde düşünebiliriz:
)

$(UL

$(LI $(B Sarma:) Üyelere erişimin kısıtlanması ($(I Not: Aslında yapılarda da bulunan bu olanağı genelde yapıların kullanım amaçlarının dışında kaldığı için göstermedim.))
)

$(LI $(B Kalıtım:) Başka bir türün üyelerini ve üye işlevlerini kendisininmiş gibi edinmek
)

$(LI $(B Çok şekillilik:) Birbirlerine yakın türlerin daha genel ortak bir tür gibi kullanılabilmeleri
)

)

$(P
Sarma, daha sonra göreceğimiz $(I erişim hakları) ile sağlanır. Kalıtım, $(I gerçekleştirme) türemesidir. $(I Çok şekillilik) ise $(I arayüz) türemesi yoluyla gerçekleştirilir.
)

$(P
Bu bölümde sınıfları genel olarak tanıtacağım ve özellikle $(I referans türü) olduklarına dikkat çekeceğim. Sınıfların diğer olanaklarını daha sonraki bölümlere bırakacağım.
)

$(H5 Yapılarla karşılaştırılması)

$(P
Sınıflar yapılara temelde çok benzerler. Bu yüzden daha önce şu bölümlerde yapılar üzerinde gördüğümüz hemen hemen her konu sınıflar için de geçerlidir:
)

$(UL
$(LI $(LINK2 /ders/d/yapilar.html, Yapılar))
$(LI $(LINK2 /ders/d/uye_islevler.html, Üye İşlevler))
$(LI $(LINK2 /ders/d/const_uye_islevler.html, $(C const ref) Parametreler ve $(C const) Üye İşlevler))
$(LI $(LINK2 /ders/d/ozel_islevler.html, Kurucu ve Diğer Özel İşlevler))
$(LI $(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme))
)

$(P
Sınıfları yapılardan ayıran önemli farklar da vardır. Bu farkları aşağıdaki bölümlerde anlatıyorum.
)

$(H6 Referans türleridir)

$(P
Sınıfların yapılardan farklı olmalarının en büyük nedeni, yapıların $(I değer türü) olmalarına karşın sınıfların $(I referans türü) olmalarıdır. Aşağıdaki farklılıkların büyük bir çoğunluğu, sınıfların bu özelliğinden kaynaklanır.
)

$(H6 $(IX null, sınıf) $(IX new, sınıf) Sınıf değişkenleri $(C null) olabilirler)

$(P
Sınıf değişkenlerinin kendileri değer taşımadıklarından, asıl nesne $(C new) anahtar sözcüğü ile oluşturulur. Aynı nedenden, $(LINK2 /ders/d/null_ve_is.html, $(C null) ve $(C is) bölümünde) de gösterildiği gibi, sınıf değişkenleri $(C null) da olabilirler. Yani, "hiçbir nesneye erişim sağlamıyor" olabilirler.
)

$(P
Hatırlayacağınız gibi, bir değişkenin $(C null) olup olmadığı $(C ==) ve $(C !=) işleçleriyle değil, duruma göre $(C is) ve $(C !is) işleçleriyle denetlenir:
)

---
    BirSınıf erişimSağlayan = new BirSınıf;
    assert(erişimSağlayan $(HILITE !is) null);

    BirSınıf değişken;  // erişim sağlamayan
    assert(değişken $(HILITE is) null);
---

$(P
Bunun nedeni $(C ==) işlecinin nesnenin üyelerini de kullanmasının gerekebileceğidir. O üye erişimi, değişkenin $(C null) olduğu durumda programın bir bellek hatası ile sonlanmasına neden olur. O yüzden sınıf değişkenlerinin $(C is) veya $(C !is) ile karşılaştırılmaları gerekir.
)

$(H6 $(IX değişken, sınıf) $(IX nesne, sınıf) Sınıf nesneleri ve değişkenleri)

$(P
Sınıf $(I nesnesi) ile sınıf $(I değişkeni) farklı kavramlardır.
)

$(P
Sınıf nesnesi, $(C new) anahtar sözcüğü ile oluşturulan ve kendi ismi olmayan bir program yapısıdır. Temsil ettiği kavramı gerçekleştiren, onun işlemlerini yapan, ve o türün davranışını belirleyen hep bu sınıf nesnesidir. Sınıf nesnelerine doğrudan erişemeyiz.
)

$(P
Sınıf değişkeni ise sınıf nesnesine erişim sağlayan bir program yapısıdır. Kendisi iş yapmasa da eriştirdiği nesnenin aracısı gibi işlem görür.
)

$(P
Daha önce $(LINK2 /ders/d/deger_referans.html, Değerler ve Referanslar bölümünde) gördüğümüz şu koda bakalım:
)

---
    auto değişken1 = new BirSınıf;
    auto değişken2 = değişken1;
---

$(P
İlk satırda sağ taraftaki $(C new), isimsiz bir $(C BirSınıf) nesnesi oluşturur. $(C değişken1) ve $(C değişken2) ise yalnızca bu isimsiz nesneye erişim sağlayan değişkenlerdir:
)

$(MONO
  (isimsiz BirSınıf nesnesi)   değişken1    değişken2
 ───┬───────────────────┬───  ───┬───┬───  ───┬───┬───
    │        ...        │        │ o │        │ o │
 ───┴───────────────────┴───  ───┴─│─┴───  ───┴─│─┴───
              ▲                    │            │
              │                    │            │
              └────────────────────┴────────────┘
)

$(H6 $(IX kopyalama, sınıf) Kopyalama)

$(P
Değişkenleri etkiler.
)

$(P
Referans türü oldukları için; sınıf değişkenlerinin kopyalanarak oluşturulmaları, onların hangi nesneye erişim sağlayacaklarını belirler. Bu işlem sırasında asıl nesne kopyalanmaz.
)

$(P
Bir nesne kopyalanmadığı için de, yapılarda $(I kopya sonrası işlevi) olarak öğrendiğimiz $(C this(this)) üye işlevi sınıflarda bulunmaz.
)

---
    auto değişken2 = değişken1;
---

$(P
Yukarıdaki kodda $(C değişken2), $(C değişken1)'in kopyası olarak oluşturulmaktadır. O işlem her ikisinin de aynı nesneye erişim sağlamalarına neden olur.
)

$(P
Sınıf nesnelerinin kopyalanmaları gerektiğinde bunu sağlayan bir üye işlev tanımlanmalıdır. Bu işleve $(C kopyala()) gibi bir isim verebileceğiniz gibi, dizilere benzemesi açısından $(C dup()) isminin daha uygun olduğunu düşünebilirsiniz. Bu işlev yeni bir nesne oluşturmalı ve ona erişim sağlayan bir değişken döndürmelidir:
)

---
class Sınıf {
    Yapı   yapıNesnesi;
    char[] dizgi;
    int    tamsayı;

// ...

    this(Yapı yapıNesnesi, const char[] dizgi, int tamsayı) {
        this.yapıNesnesi = yapıNesnesi;
        this.dizgi       = dizgi.dup;
        this.tamsayı     = tamsayı;
    }

    Sınıf dup() const {
        return new Sınıf(yapıNesnesi, dizgi, tamsayı);
    }
}
---

$(P
$(C dup()) içinde oluşturulan yeni nesne için yalnızca $(C Sınıf)'ın kurucusundan yararlanıldığına dikkat edin. Kurucu $(C dizgi) üyesini $(C dup()) ile açıkça kopyalıyor. $(C yapıNesnesi) ve $(C tamsayı) üyeleri ise değer türleri olduklarından onlar zaten otomatik olarak kopyalanırlar.
)

$(P
O işlevden örneğin şöyle yararlanılabilir:
)

---
    auto nesne1 = new Sınıf(Yapı(1.5), "merhaba", 42);
    auto nesne2 = nesne1.dup();
---

$(P
Sonuçta, $(C nesne2) $(C nesne1)'in hiçbir üyesini paylaşmayan ayrı bir nesnedir.
)

$(P
Benzer biçimde, nesnenin $(C immutable) bir kopyası da ismi $(C idup) olan bir işlev tarafından sağlanabilir:
)

---
class Sınıf {
// ...

    immutable(Sınıf) idup() const {
        return new immutable(Sınıf)(yapıNesnesi, dizgi, tamsayı);
    }
}

// ...

    immutable(Sınıf) imm = nesne1.idup();
---

$(H6 $(IX atama, sınıf) Atama)

$(P
Değişkenleri etkiler.
)

$(P
Referans türü oldukları için; sınıf değişkenlerinin atanmaları, daha önce erişim sağladıkları nesneyi bırakmalarına ve yeni bir nesneye erişim sağlamalarına neden olur.
)

$(P
Eğer $(I bırakılan) nesneye erişim sağlayan başka değişken yoksa, asıl nesne ilerideki belirsiz bir zamanda çöp toplayıcı tarafından sonlandırılacak demektir.
)

---
    auto değişken1 = new BirSınıf;
    auto değişken2 = new BirSınıf;
    değişken1 $(HILITE =) değişken2;
---

$(P
Yukarıdaki atama işlemi, $(C değişken1)'in kendi nesnesini bırakmasına ve $(C değişken2)'nin nesnesine erişim sağlamaya başlamasına neden olur. Kendisine erişim sağlayan başka bir değişken olmadığı için bırakılan nesne daha sonra çöp toplayıcı tarafından sonlandırılacaktır.
)

$(P
Atama işleminin davranışı sınıflar için değiştirilemez; yani $(C opAssign) sınıflarda yüklenemez.
)

$(H6 Tanımlama)

$(P
$(C struct) yerine $(C class) anahtar sözcüğü kullanılır:
)

---
$(HILITE class) SatrançTaşı {
    // ...
}
---

$(H6 Kurma)

$(P
Kurucu işlevin ismi, yapılarda olduğu gibi $(C this)'tir. Yapılardan farklı olarak sınıf nesneleri $(C {}) karakterleri ile kurulamaz.
)

---
class SatrançTaşı {
    dchar şekil;

    $(HILITE this)(dchar şekil) {
        this.şekil = şekil;
    }
}
---

$(P
Yapıların aksine, sınıf üyeleri kurucu parametre değerlerinden sırayla otomatik olarak kurulamazlar:
)

---
class SatrançTaşı {
    dchar şekil;
    size_t değer;
}

void main() {
    auto şah = new SatrançTaşı('♔', 100);  $(DERLEME_HATASI)
}
---

$(SHELL
Error: no constructor for SatrançTaşı
)

$(P
Nesnelerin o yazımla kurulabilmeleri için programcının açıkça bir kurucu tanımlamış olması şarttır.
)

$(H6 Sonlandırma)

$(P
Sonlandırıcı işlevin ismi yapılarda olduğu gibi $(C ~this)'tir:
)

---
    ~this() {
        // ...
    }
---

$(P
Ancak, yapılardan farklı olarak, sınıfların sonlandırıcıları nesnenin yaşamı sona erdiği an işletilmez. Yukarıda da değinildiği gibi, sonlandırıcı ilerideki belirsiz bir zamandaki bir çöp toplama işlemi sırasında işletilir.
)

$(P
Daha sonra $(LINK2 /ders/d/bellek_yonetimi.html, Bellek Yönetimi bölümünde) de göreceğimiz gibi, sınıf sonlandırıcılarının aşağıdaki kurallara uymaları şarttır:
)

$(UL

$(LI Sınıf sonlandırıcısındaki kodlar, yaşamı çöp toplayıcı tarafından yönetilen hiçbir üyeye erişmemelidir. Bunun nedeni, çöp toplayıcının nesneyi veya üyelerini hangi sırada sonlandıracağı garantisini vermek zorunda olmamasıdır. Sonlandırıcı işletilmeye başladığında bütün üyeler zaten sonlandırılmış olabilirler.)

$(LI Sınıf sonlandırıcısı çöp toplayıcıdan yeni bellek ayırmamalıdır. Bunun nedeni, çöp toplayıcının temizlik işlemleri sırasında yeni bellek ayırabilme garantisini vermek zorunda olmamasıdır.)

)

$(P
Bu kurallara uymamak tanımsız davranıştır. Tanımsız davranışın bir etkisini sonlandırıcı içinde yeni bir sınıf nesnesi kurmaya çalışarak görebiliriz:
)

---
class C {
    ~this() {
        auto c = new C(); // ← YANLIŞ: Sınıf sonlandırıcısında
                          //           yeni nesne kuruluyor
    }
}

void main() {
    auto c = new C();
}
---

$(P
Program bir hata ile sonlanır:
)

$(SHELL
core.exception.$(HILITE InvalidMemoryOperationError)@(0)
)

$(P
Sonlandırıcı içinde çöp toplayıcıdan $(I dolaylı olarak) bellek ayırmak da aynı derecede yanlıştır. Örneğin, dinamik dizi elemanları için kullanılan bellek bölgesi de çöp toplayıcı tarafından yönetilir. Bu yüzden, bir dinamik dizinin yeni bellek ayrılmasını gerektirecek herhangi biçimde kullanılması da tanımsız davranıştır:
)

---
    ~this() {
        auto dizi = [ 1 ];  // ← YANLIŞ: Sınıf sonlandırıcısında
                            //           çöp toplayıcıdan
                            //           dolaylı olarak bellek
                            //           ayrılıyor
    }
---

$(SHELL
core.exception.$(HILITE InvalidMemoryOperationError)@(0)
)

$(H6 Üye erişimi)

$(P
Yapılarda olduğu gibi, üyelere nokta karakteri ile erişilir.
)

---
    auto şah = new SatrançTaşı('♔');
    writeln(şah$(HILITE .şekil));
---

$(P
Her ne kadar değişkenin bir üyesine erişiliyor gibi yazılsa da, erişilen asıl nesnenin üyesidir. Sınıf değişkenlerinin üyeleri yoktur, sınıf nesnelerinin üyeleri vardır. Bir başka deyişle, $(C şah)'ın $(C şekil) diye bir üyesi yoktur, isimsiz sınıf nesnesinin $(C şekil) diye bir üyesi vardır.
)

$(P $(I Not: Üye değişkenlere böyle doğrudan erişilmesi çoğu durumda doğru kabul edilmez. Onun yerine daha sonra $(LINK2 /ders/d/nitelikler.html, Nitelikler bölümünde) göreceğimiz sınıf niteliklerinden yararlanmak daha uygundur.)
)

$(H6 İşleç yükleme)

$(P
Yapılardaki gibidir.
)

$(P
Bir fark, $(C opAssign)'ın sınıflar için özel olarak tanımlanamamasıdır. Yukarıda atama başlığında anlatıldığı gibi, sınıflarda atama işleminin anlamı $(I yeni nesneye erişim sağlamaktır); bu anlam değiştirilemez.
)

$(H6 Üye işlevler)

$(P
Sınıf üye işlevleri yapılarda olduğu gibi tanımlanırlar ve kullanılırlar. Buna rağmen, aralarında önemli bir fark vardır: Sınıf üye işlevleri $(I yeniden tanımlanabilirler) ve bu, onlar için varsayılan durumdur. Yeniden tanımlama kavramını daha sonra $(LINK2 /ders/d/tureme.html, Türeme bölümünde) göreceğiz.
)

$(P
$(IX final) Yeniden tanımlama düzeneğinin program hızına kötü bir etkisi olduğundan, burada daha fazla ayrıntısına girmeden bütün sınıf üye işlevlerini $(C final) olarak tanımlamanızı öneririm. Bu ilkeyi derleyici hatası almadığınız sürece bütün sınıf üyeleri için uygulayabilirsiniz:
)

---
class Sınıf {
    $(HILITE final) int işlev() {    $(CODE_NOTE Önerilir)
        // ...
    }
}
---

$(P
Yapılardan başka bir fark, bazı işlevlerin $(C Object) sınıfından kalıtım yoluyla hazır olarak edinilmiş olmalarıdır. Bunlar arasından $(C toString) işlevinin $(C override) anahtar sözcüğü ile nasıl tanımlandığını $(LINK2 /ders/d/tureme.html, bir sonraki bölümde) göreceğiz.
)

$(H6 $(IX is, işleç) $(IX !is) $(C is) ve $(C !is) işleçleri)

$(P
Sınıf değişkenleri üzerinde işler.
)

$(P
$(C is) işleci, sınıf değişkenlerinin aynı nesneye erişim sağlayıp sağlamadıklarını bildirir. İki değişken de aynı nesneye erişim sağlıyorlarsa $(C true), değilse $(C false) değerini üretir. $(C !is) işleci de bunun tersi olarak işler: Aynı nesneye erişim sağlıyorlarsa $(C false), değilse $(C true) değerini üretir.
)

---
    auto benimŞah = new SatrançTaşı('♔');
    auto seninŞah = new SatrançTaşı('♔');
    assert(benimŞah !is seninŞah);
---

$(P
Yukarıdaki koddaki $(C benimŞah) ve $(C seninŞah) değişkenleri $(C new) ile oluşturulmuş olan iki farklı nesneye erişim sağladıkları için $(C !is)'in sonucu $(C true)'dur. Bu iki nesnenin aynı şekilde kurulmuş olmaları, yani ikisinin $(C şekil) üyelerinin de $(C'♔') olması bunu değiştirmez; nesneler birbirlerinden ayrı iki nesnedir.
)

$(P
İki değişkenin aynı nesneye erişim sağladıkları durumda ise $(C is) işleci $(C true) üretir:
)

---
    auto benimŞah2 = benimŞah;
    assert(benimŞah2 is benimŞah);
---

$(P
Yukarıdaki iki değişken de aynı nesneye erişim sağlamaya başlarlar. $(C is) işleci bu durumda $(C true) üretir.
)

$(H5 Özet)

$(UL

$(LI Sınıfların yapılarla çok sayıda ortak yanları olduğu kadar büyük farkları da vardır.
)

$(LI Sınıflar referans türleridir; $(C new) ile isimsiz bir $(I sınıf nesnesi) kurulur; döndürülen, o nesneye erişim sağlayan bir $(I sınıf değişkenidir).
)

$(LI Hiçbir nesneye erişim sağlamayan sınıf değişkenlerinin değeri $(C null)'dır; bu durum $(C is) veya $(C !is) ile denetlenir ($(C ==) veya $(C !=) ile değil).
)

$(LI Kopyalama normalde değişkeni kopyalar; nesnenin kopyalanabilmesi için $(C dup()) gibi bir üye işlev yazılması gerekir.
)

$(LI Atama, değişkenin başka bir nesneyi göstermesini sağlar; bu davranış değiştirilemez.
)

)

Macros:
        SUBTITLE=Sınıflar

        DESCRIPTION=D dilinin nesne yönelimli programlama olanaklarının temeli olan sınıflar (class)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sınıf class sınıflar kullanıcı türleri

SOZLER=
$(arayuz)
$(cok_sekillilik)
$(deger_turu)
$(degisken)
$(gerceklestirme)
$(kalitim)
$(nesne)
$(referans_turu)
$(sarma)
$(sinif)
$(tanimsiz_davranis)
$(turetmek)
$(yapi)
$(yeniden_tanimlama)
