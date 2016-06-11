Ddoc

$(DERS_BOLUMU $(IX yaşam süreci) Yaşam Süreçleri ve Temel İşlemler)

$(P
Çok yakında yapı ve sınıfları anlatmaya başlayacağım. Yapıların kullanıcı türlerinin temeli olduklarını göreceğiz. Onlar sayesinde temel türleri ve başka yapıları bir araya getirerek yeni türler oluşturabileceğiz.
)

$(P
Daha sonra D'nin nesneye dayalı programlama olanaklarının temelini oluşturan sınıfları tanıyacağız. Sınıflar başka türleri bir araya getirmenin yanında o türlerle ilgili özel işlemleri de belirlememizi sağlayacaklar.
)

$(P
O konulara geçmeden önce şimdiye kadar hiç üzerinde durmadan kullandığımız bazı temel kavramları ve temel işlemleri açıklamam gerekiyor. Bu kavramlar ileride yapı ve sınıf tasarımları sırasında yararlı olacak.
)

$(P
Şimdiye kadar kavramları temsil eden veri yapılarına $(I değişken) adını verdik. Bir kaç noktada da yapı ve sınıf türünden olan değişkenlere özel olarak $(I nesne) dedik. Ben bu bölümde bunların hepsine birden genel olarak $(I değişken) diyeceğim. Herhangi bir türden olan herhangi bir veri yapısı en azından bu bölümde $(I değişken) adını alacak.
)

$(P
Bu bölümde yalnızca şimdiye kadar gördüğümüz temel türleri, dizileri, ve eşleme tablolarını kullanacağım; siz bu kavramların bütün türler için geçerli olduklarını aklınızda tutun.
)

$(H5 $(IX değişken, yaşam süreci) Değişkenlerin yaşam süreçleri)

$(P
Bir değişkenin tanımlanması ile başlayan ve $(I geçerliliğinin bitmesine) kadar geçen süreye o değişkenin $(I yaşam süreci) denir.
)

$(P
Geçerliliğin bitmesi kavramını $(LINK2 /ders/d/isim_alani.html, İsim Alanı bölümünde) $(I değişkenin tanımlandığı kapsamdan çıkılması) olarak tanımlamıştım.
)

$(P
O konuyu hatırlamak için şu örneğe bakalım:
)

---
void hızDenemesi() {
    int hız;                      // tek değişken ...

    foreach (i; 0 .. 10) {
        hız = 100 + i;            // ... 10 farklı değer alır
        // ...
    }
} // ← yaşamı burada sonlanır
---

$(P
O koddaki $(C hız) değişkeninin yaşam süreci $(C hızDenemesi) işlevinden çıkıldığında sona erer. Orada 100 ile 109 arasında 10 değişik değer alan tek değişken vardır.
)

$(P
Aşağıdaki kodda ise durum yaşam süreçleri açısından çok farklıdır:
)

---
void hızDenemesi() {
    foreach (i; 0 .. 10) {
        int hız = 100 + i;        // 10 farklı değişken vardır
        // ...
    } // ← yaşamları burada sonlanır
}
---

$(P
O kodda her birisi tek değer alan 10 farklı değişken vardır: döngünün her tekrarında $(C hız) isminde yeni bir değişken yaşamaya başlar; yaşamı, döngünün kapama parantezinde sona erer.
)

$(H5 $(IX parametre, yaşam süreci) Parametrelerin yaşam süreçleri)

$(P
$(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri bölümünde) gördüğümüz parametre türlerine bir de yaşam süreçleri açısından bakalım:
)

$(P
$(IX ref, parametre yaşam süreci) $(C ref): Parametre aslında işlev çağrıldığında kullanılan değişkenin takma ismidir. Parametrenin asıl değişkenin yaşam süreci üzerinde etkisi yoktur.
)

$(P
$(IX in, parametre yaşam süreci) $(C in): $(I Değer türündeki) bir parametrenin yaşamı işleve girildiği an başlar ve işlevden çıkıldığı an sona erer. $(I Referans türündeki) bir parametrenin yaşamı ise $(C ref)'te olduğu gibidir.
)

$(P
$(IX out, parametre yaşam süreci) $(C out): Parametre aslında işlev çağrıldığında kullanılan değişkenin takma ismidir. $(C ref)'ten farklı olarak, işleve girildiğinde asıl değişkene önce otomatik olarak türünün $(C .init) değeri atanır. Bu değer daha sonra işlev içinde değiştirilebilir.
)

$(P
$(IX lazy, parametre yaşam süreci) $(C lazy): Parametre tembel olarak işletildiğinden yaşamı kullanıldığı an başlar ve o an sona erer.
)

$(P
Bu dört parametre türünü kullanan ve yaşam süreçlerini açıklayan bir örnek şöyle yazılabilir:
)

---
void main() {
    int main_in;      // değeri işleve kopyalanır

    int main_ref;     // işleve kendisi olarak ve kendi
                      // değeriyle gönderilir

    int main_out;     // işleve kendisi olarak gönderilir;
                      // işleve girildiği an değeri sıfırlanır

    işlev(main_in, main_ref, main_out, birHesap());
}

void işlev(
    in int p_in,       // yaşamı main_in'in kopyası olarak
                       // işleve girilirken başlar ve işlevden
                       // çıkılırken sonlanır

    ref int p_ref,     // main_ref'in takma ismidir

    out int p_out,     // main_out'un takma ismidir; ref'ten
                       // farklı olarak, işleve girildiğinde
                       // değeri önce int.init olarak atanır

    lazy int p_lazy) { // yaşamı işlev içinde kullanıldığı an
                       // başlar ve eğer kullanımı bitmişse
                       // hemen o an sonlanır; değeri için,
                       // her kullanıldığı an 'birHesap'
                       // işlevi çağrılır
    // ...
}

int birHesap() {
    int sonuç;
    // ...
    return sonuç;
}
---

$(H5 Temel işlemler)

$(P
Hangi türden olursa olsun, bir değişkenin yaşamı boyunca etkili olan üç temel işlem vardır:
)

$(UL
$(LI $(B Kurma): Yaşamın başlangıcı.)
$(LI $(B Sonlandırma): Yaşamın sonu.)
$(LI $(B Atama): Değerin değişmesi.)
)

$(P
Değişkenlerin yaşam süreçleri kurma işlemiyle başlar ve sonlandırma işlemiyle sona erer. Bu süreç boyunca değişkene yeni değerler atanabilir.
)

$(H6 $(IX ilkleme) $(IX kurma) Kurma)

$(P
Her değişken, kullanılmadan önce kurulmak zorundadır. Burada "kurma" sözcüğünü "hazırlamak, inşa etmek" anlamlarında kullanıyorum. Kurma iki alt adımdan oluşur:
)

$(OL
$(LI $(B Yer ayrılması): Değişkenin yaşayacağı yer belirlenir.)
$(LI $(B İlk değerinin verilmesi): O adrese ilk değeri yerleştirilir.)
)

$(P
Her değişken bilgisayarın belleğinde kendisine ayrılan bir yerde yaşar. Derleyicinin istediğimiz işleri yaptırmak için mikro işlemcinin anladığı dilde kodlar ürettiğini biliyorsunuz. Derleyicinin ürettiği kodların bir bölümünün görevi, tanımlanan değişkenler için bellekten yer ayırmaktır.
)

$(P
Örneğin, hızı temsil eden şöyle bir değişken olsun:
)

---
    int hız = 123;
---

$(P
Daha önce $(LINK2 /ders/d/deger_referans.html, Değerler ve Referanslar bölümünde) gördüğümüz gibi, o değişkenin belleğin bir noktasında yaşadığını düşünebiliriz:
)

$(MONO
   ──┬─────┬─────┬─────┬──
     │     │ 123 │     │
   ──┴─────┴─────┴─────┴──
)

$(P
Her değişkenin bellekte bulunduğu yere o değişkenin $(I adresi) denir. Bir anlamda o değişken o adreste yaşamaktadır. Programda bir değişkenin değerini değiştirdiğimizde, değişkenin yeni değeri aynı yere yerleştirilir:
)

---
    ++hız;
---

$(P
Aynı adresteki değer bir artar:
)

$(MONO
   ──┬─────┬─────┬─────┬──
     │     │ 124 │     │
   ──┴─────┴─────┴─────┴──
)

$(P
Kurma, değişkenin yaşamı başladığı anda gerçekleştirilir çünkü değişkeni kullanıma hazırlayan işlemleri içerir. Değişkenin herhangi bir biçimde kullanılabilmesi için kurulmuş olması önemlidir.
)

$(P
Değişkenler üç farklı şekilde kurulabilirler:
)

$(UL
$(LI $(B Varsayılan şekilde): Programcı değer belirtmemişse)
$(LI $(B Kopyalanarak): Başka bir değişkenin değeriyle)
$(LI $(B Belirli bir değerle): Programcının belirlediği değerle)
)

$(P
Hiçbir değer kullanılmadan kurulduğunda değişkenin değeri o türün $(I varsayılan) değeridir. Varsayılan değer, her türün $(C .init) niteliğidir:
)

---
    int hız;
---

$(P
O durumda $(C hız)'ın değeri $(C int.init)'tir (yani 0). Varsayılan değerle kurulmuş olan bir değişkenin programda sonradan başka değerler alacağını düşünebiliriz.
)

---
    File dosya;
---

$(P
$(LINK2 /ders/d/dosyalar.html, Dosyalar bölümünde) gördüğümüz $(C std.stdio.File) türünden olan yukarıdaki $(C dosya) nesnesi dosya sisteminin hiçbir dosyasına bağlı olmayan bir $(C File) yapısı nesnesidir. Onun dosya sisteminin hangi dosyasına erişmek için kullanılacağının daha sonradan belirleneceğini düşünebiliriz; varsayılan şekilde kurulmuş olduğu için henüz kullanılamaz.
)

$(P
Değişken bazen başka bir değişkenin değeri $(I kopyalanarak) kurulur:
)

---
    int hız = başkaHız;
---

$(P
O durumda $(C hız)'ın değeri $(C başkaHız)'ın değerinden kopyalanır ve $(C hız) yaşamına o değerle başlar. Sınıf değişkenlerinde ise durum farklıdır:
)

---
    auto sınıfDeğişkeni = başkaSınıfDeğişkeni;
---

$(P
$(C sınıfDeğişkeni) de yaşamına $(C başkaSınıfDeğişkeni)'nin kopyası olarak başlar.
)

$(P
Aralarındaki önemli ayrım, $(C hız) ile $(C başkaHız)'ın birbirlerinden farklı iki değer olmalarına karşın $(C sınıfDeğişkeni) ile $(C başkaSınıfDeğişkeni)'nin aynı nesneye erişim sağlamalarıdır. Bu çok önemli ayrım $(I değer türleri) ile $(I referans türleri) arasındaki farktan ileri gelir.
)

$(P
Son olarak, değişkenler belirli değerlerle veya özel şekillerde kurulabilirler:
)

---
   int hız = birHesabınSonucu();
---

$(P
Yukarıdaki $(C hız)'ın ilk değeri programın çalışması sırasındaki bir hesabın değeri olarak belirlenmektedir.
)

---
   auto sınıfDeğişkeni = new BirSınıf;
---

$(P
Yukarıdaki $(C sınıfDeğişkeni), yaşamına $(C new) ile kurulan nesneye erişim sağlayacak şekilde başlamaktadır.
)

$(H6 $(IX sonlandırma) Sonlandırma)

$(P
Değişkenin yaşamının sona ermesi sırasında yapılan işlemlere sonlandırma denir. Kurma gibi sonlandırma da iki adımdan oluşur:
)

$(OL
$(LI $(B Son işlemler): Değişkenin yapması gereken son işlemler işletilir)
$(LI $(B Belleğin geri verilmesi): Değişkenin yaşadığı yer geri verilir)
)

$(P
Temel türlerin çoğunda sonlandırma sırasında özel işlemler gerekmez. Örneğin $(C int) türünden bir değişkenin bellekte yaşamakta olduğu yere sıfır gibi özel bir değer atanmaz. Program o adresin artık boş olduğunun hesabını tutar ve orayı daha sonra başka değişkenler için kullanır.
)

$(P
Öte yandan, bazı türlerden olan değişkenlerin yaşamlarının sonlanması sırasında özel işlemler gerekebilir. Örneğin bir $(C File) nesnesi, eğer varsa, ara belleğinde tutmakta olduğu karakterleri diske yazmak zorundadır. Ek olarak, dosyayla işinin bittiğini dosya sistemine bildirmek için de dosyayı kapatmak zorundadır. Bu işlemler $(C File)'ın sonlandırma işlemleridir.
)

$(P
Dizilerde durum biraz daha üst düzeydedir: o dizinin erişim sağlamakta olduğu bütün elemanlar da sonlanırlar. Eğer dizinin elemanları temel türlerdense özel bir sonlanma işlemi gerekmez. Ama eğer dizinin elemanları sonlanma gerektiren bir yapı veya sınıf türündense, o türün sonlandırma işlemleri her eleman için uygulanır.
)

$(P
Sonlandırma eşleme tablolarında da dizilerdeki gibidir. Ek olarak, eşleme tablosunun sahip olduğu indeks değişkenleri de sonlandırılırlar. Eğer indeks türü olarak bir yapı veya sınıf türü kullanılmışsa, her indeks nesnesi için o türün gerektirdiği sonlandırma işlemleri uygulanır.
)

$(P $(B Çöp toplayıcı): D $(I çöp toplayıcılı) bir dildir. Bu tür dillerde sonlandırma işlemleri programcı tarafından açıkça yapılmak zorunda değildir. Yaşamı sona eren bir değişkenin sonlandırılması otomatik olarak çöp toplayıcı denen düzenek tarafından halledilir. Çöp toplayıcının ayrıntılarını ilerideki bir bölümde göreceğiz.
)

$(P
Değişkenler iki şekilde sonlandırılabilirler:
)

$(UL
$(LI $(B Hemen): Sonlandırma işlemleri hemen işletilir)
$(LI $(B Sonra): Çöp toplayıcı tarafından ilerideki bir zamanda)
)

$(P
Bir değişkenin bunlardan hangi şekilde sonlandırılacağı öncelikle kendi türüne bağlıdır. Temel türlerin hemen sonlandırıldıklarını düşünebilirsiniz çünkü zaten sonlandırma için özel işlemleri yoktur. Bazı türlerin değişkenlerinin son işlemleri ise çöp toplayıcı tarafından daha sonraki bir zamanda işletilebilir.
)

$(H6 $(IX atama) Atama)

$(P
Bir değişkenin yaşamı boyunca karşılaştığı diğer önemli işlem atamadır.
)

$(P
Temel türlerde atama işlemi yalnızca değişkenin değerinin değiştirilmesi olarak görülebilir. Yukarıdaki bellek gösteriminde olduğu gibi, değişken örneğin 123 olan bir değer yerine artık 124 değerine sahip olabilir.
)

$(P
Daha genel olarak aslında atama işlemi de iki adımdan oluşur:
)

$(OL
$(LI $(B Eski değerin sonlandırılması): Eğer varsa, sonlandırma işlemleri ya hemen ya da çöp toplayıcı tarafından daha sonra işletilir)
$(LI $(B Yeni değerin verilmesi): Eski değerin yerine yeni değer atanır)
)

$(P
Bu iki adım sonlandırma işlemleri bulunmadığı için temel türlerde önemli değildir. Ama sonlandırma işlemleri bulunan türlerde atamanın böyle iki adımdan oluştuğunu akılda tutmakta yarar vardır: atama aslında bir sonlandırma ve bir yeni değer verme işlemidir.
)


Macros:
        SUBTITLE=Yaşam Süreçleri ve Temel İşlemler

        DESCRIPTION=D dilinde türlerin temel işlemleri olan kurma, sonlandırma, ve atama işlemlerinin tanıtılması; ve değişkenlerin yaşam süreçlerinin tanımlanması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial nesne temel işlemler kurma kurucu sonlandırma bozucu kopyalama kopyalayıcı atama işleç

SOZLER=
$(adres)
$(atama)
$(cop_toplayici)
$(deger_turu)
$(degisken)
$(kopyalama)
$(kurma)
$(nesne)
$(referans_turu)
$(sinif)
$(sonlandirma)
$(varsayilan)
$(yapi)
$(yasam_sureci)
