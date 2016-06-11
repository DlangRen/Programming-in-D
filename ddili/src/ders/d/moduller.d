Ddoc

$(DERS_BOLUMU $(IX modül) Modüller ve Kütüphaneler)

$(P
D programlarını ve kütüphanelerini oluşturan en alt yapısal birimler modüllerdir.
)

$(P
D'nin modül kavramı çok basit bir temel üzerine kuruludur: Her kaynak dosya bir modüldür. Bu tanıma göre, şimdiye kadar deneme programlarımızı yazdığımız tek kaynak dosya bile bir modüldür.
)

$(P
Her modülün ismi, dosya isminin $(C .d) uzantısından önceki bölümü ile aynıdır ve kaynak dosyanın en başına yazılan $(C module) anahtar sözcüğü ile belirtilir. Örneğin, "kedi.d" isimli bir kaynak dosyanın modül ismi aşağıdaki gibi belirtilir:
)

---
module kedi;

class Kedi {
    // ...
}
---

$(P
Eğer modül bir pakedin parçası değilse $(C module) satırı isteğe bağlıdır. (Paketleri biraz aşağıda göreceğiz.) Yazılmadığı zaman otomatik olarak dosyanın isminin $(C .d)'den önceki bölümü kullanılır.
)

$(H6 $(IX static this) $(IX static ~this) $(IX this, static) $(IX ~this, static) $(C static this()) ve $(C static ~this()))

$(P
Modül düzeyinde tanımlanan $(C static this()) ve $(C static ~this()), yapı ve sınıflardaki eşdeğerleri ile aynı anlamdadır:
)

---
module kedi;

static this() {
    // ... modülün ilk işlemleri ...
}

static ~this() {
    // ... modülün son işlemleri ...
}
---

$(P
Bu işlevler her iş parçacığında ayrı ayrı işletilir. (Çoğu program yalnızca $(C main())'in işlediği tek iş parçacığından oluşur.) İş parçacıklarının sayısından bağımsız olarak bütün programda tek kere işletilmesi gereken kodlar ise (örneğin, $(C shared) ve $(C immutable) değişkenlerin ilklenmeleri) $(C shared static this()) ve $(C shared static ~this()) işlevlerinde tanımlanırlar. Bunları daha sonraki $(LINK2 /ders/d/es_zamanli_shared.html, Veri Paylaşarak Eş Zamanlı Programlama bölümünde) göreceğiz.
)

$(H6 Dosya ve modül isimleri)

$(P
D programlarını Unicode olarak oluşturma konusunda şanslıyız; bu, hangi ortamda olursa olsun geçerlidir. Ancak, dosya sistemleri konusunda aynı serbesti bulunmaz. Örneğin, Windows işletim sistemlerinin standart dosya sistemleri dosya isimlerinde büyük/küçük harf ayrımı gözetmezken, Linux sistemlerinde büyük/küçük harfler farklıdır. Ayrıca, çoğu dosya sistemi dosya isimlerinde kullanılabilecek karakterler konusunda kısıtlamalar getirir.
)

$(P
O yüzden, programlarınızın taşınabilir olmaları için dosya isimlerinde yalnızca ASCII küçük harfler kullanmanızı öneririm. Örneğin, yukarıdaki $(C Kedi) sınıfı ile birlikte kullanılacak olan bir $(C Köpek) sınıfının modülünün dosya ismini "kopek.d" olarak seçebiliriz.
)

$(P
Dolayısıyla, modülün ismi de ASCII harflerden oluşur:
)

---
module kopek;    // ASCII harflerden oluşan modül ismi

class Köpek {    // Unicode harflerden oluşan program kodu
    // ...
}
---

$(H5 $(IX paket) Paketler)

$(P
Modüllerin bir araya gelerek oluşturdukları yapıya $(I paket) denir. D'nin paket kavramı da çok basittir: Dosya sisteminde aynı klasörde bulunan bütün modüller aynı pakedin parçası olarak kabul edilirler. Pakedi içeren klasörün ismi de pakedin ismi haline gelir ve modül isimlerinin baş tarafını oluşturur.
)

$(P
Örneğin, yukarıdaki "kedi.d" ve "kopek.d" dosyalarının "hayvan" isminde bir klasörde bulunduklarını düşünürsek, modül isimlerinin başına klasör ismini yazmak, onları aynı pakedin modülleri yapmaya yeter:
)

---
module $(HILITE hayvan.)kedi;

class Kedi {
    // ...
}
---

$(P
Aynı şekilde $(C kopek) modülü için de:
)

---
module $(HILITE hayvan.)kopek;

class Köpek {
    // ...
}
---

$(P
$(C module) satırı bir pakedin parçası olan modüllerde zorunludur.
)

$(P
Paket isimleri dosya sistemi klasörlerine karşılık geldiğinden, iç içe klasörlerde bulunan modüllerin paket isimleri de o klasör yapısının eşdeğeridir. Örneğin, "hayvan" klasörünün altında bir de "omurgalilar" klasörü olsa, oradaki bir modülün paket ismi bu klasörü de içerir:
)

---
module hayvan.omurgalilar.kedi;
---

$(P
Kaynak dosyaların ne derece dallanacağı programın büyüklüğüne ve tasarımına bağlıdır. Küçük bir programın bütün dosyalarının tek bir klasörde bulunmasında bir sakınca yoktur. Öte yandan, dosyaları belirli bir düzen altına almak için klasörleri gerektiği kadar dallandırmak da mümkündür.
)

$(H5 $(IX import) Modüllerin programda kullanılmaları)

$(P
Şimdiye kadar çok kullandığımız $(C import) anahtar sözcüğü, bir modülün başka bir modüle tanıtılmasını ve o modül içinde kullanılabilmesini sağlar:
)

---
import std.stdio;
---

$(P
$(C import)'tan sonra yazılan modül ismi, eğer varsa paket bilgisini de içerir. Yukarıdaki koddaki $(C std.), standart kütüphaneyi oluşturan modüllerin $(C std) isimli pakette bulunduklarını gösterir.
)

$(P
Benzer şekilde, $(C hayvan.kedi) ve $(C hayvan.kopek) modülleri bir "deneme.d" dosyasında şu şekilde bildirilir:
)

---
module deneme;          // bu modülün ismi

import hayvan.kedi;     // kullandığı bir modül
import hayvan.kopek;    // kullandığı başka bir modül

void main() {
    auto kedi = new Kedi();
    auto köpek = new Köpek();
}
---

$(P $(I Not: Aşağıda anlatıldığı gibi, yukarıdaki programın derlenip oluşturulabilmesi için o modül dosyalarının da bağlayıcıya derleme satırında bildirilmeleri gerekir.)
)

$(P
Birden fazla modül aynı anda eklenebilir:
)

---
import hayvan.kedi, hayvan.kopek;
---

$(H6 $(IX import, seçerek) Seçerek eklemek)

$(P
$(IX :, import) Bir modüldeki isimlerin hepsini birden eklemek yerine içindeki isimler tek tek seçilerek eklenebilir:
)

---
import std.stdio $(HILITE : writeln;)

// ...

    write$(HILITE f)ln("Merhaba %s.", isim);    $(DERLEME_HATASI)
---

$(P
$(C stdio) modülünden yalnızca $(C writeln) eklenmiş olduğundan yukarıdaki kod derlenemez ($(C writefln) eklenmemiştir).
)

$(P
İsimleri seçerek eklemek hepsini birden eklemekten daha iyidir çünkü $(I isim çakışmalarının) olasılığı daha azdır. Biraz aşağıda bir örneğini göreceğimiz gibi, isim çakışması iki farklı modüldeki aynı ismin eklenmesiyle oluşur.
)

$(P
Ek olarak, yalnızca belirtilen isimler derleneceğinden derleme sürelerinin kısalacağı da beklenebilir. Öte yandan, her kullanılan ismin ayrıca belirtilmesini gerektirdiğinden seçerek eklemek daha fazla emek gerektirir.
)

$(P
Kod örneklerini kısa tutmak amacıyla bu kitapta seçerek ekleme olanağından yararlanılmamaktadır.
)

$(H6 $(IX yerel import) $(IX import, yerel) Yerel $(C import) satırları)

$(P
Bu kitaptaki bütün $(C import) satırlarını hep programların en başlarına yazdık:
)

---
import std.stdio;     $(CODE_NOTE en başta)
import std.string;    $(CODE_NOTE en başta)

// ... modülün geri kalanı ...
---

$(P
Aslında modüller herhangi başka bir satırda da eklenebilirler. Örneğin, aşağıdaki programdaki iki işlev ihtiyaç duydukları farklı modülleri kendi yerel kapsamlarında eklemekteler:
)

---
string mesajOluştur(string isim) {
    $(HILITE import std.string;)

    string söz = format("Merhaba %s", isim);
    return söz;
}

void kullanıcıylaEtkileş() {
    $(HILITE import std.stdio;)

    write("Lütfen isminizi girin: ");
    string isim = readln();
    writeln(mesajOluştur(isim));
}

void main() {
    kullanıcıylaEtkileş();
}
---

$(P
$(C import) satırlarının yerel kapsamlarda bulunmaları modül kapsamında bulunmalarından daha iyidir çünkü derleyici kullanılmayan kapsamlardaki $(C import) satırlarını derlemek zorunda kalmaz. Ek olarak, yerel olarak eklenmiş olan modüllerdeki isimler ancak eklendikleri kapsamda görünürler ve böylece isim çakışmalarının olasılığı da azalmış olur.
)

$(P
Daha sonra $(LINK2 /ders/d/katmalar.html, Katmalar bölümünde) göreceğimiz $(I şablon katmaları) olanağında modüllerin yerel olarak eklenmeleri şarttır.
)

$(P
Bu kitaptaki örnekler yerel $(C import) olanağından hemen hemen hiç yararlanmazlar çünkü bu olanak D'ye bu kitabın yazılmaya başlanmasından sonra eklenmiştir.
)

$(H6 Modüllerin dosya sistemindeki yerleri)

$(P
Modül isimleri dosya sistemindeki dosyalara bire bir karşılık geldiğinden, derleyici bir modül dosyasının nerede bulunduğunu modül ismini klasör ve dosya isimlerine dönüştürerek bulur.
)

$(P
Örneğin, yukarıdaki programın kullandığı iki modül, "hayvan/kedi.d" ve "hayvan/kopek.d" dosyalarıdır. Dolayısıyla, yukarıdaki dosyayı da sayarsak bu programı oluşturmak için üç modül kullanılmaktadır.
)

$(H6 Kısa ve uzun isimler)

$(P
Programda kullanılan isimler, paket ve modül bilgilerini de içeren $(I uzun halde) de yazılabilirler. Bunu $(C Kedi) sınıfının tür ismini kısa ve uzun yazarak şöyle gösterebiliriz:
)

---
    auto kedi0 = new Kedi();
    auto kedi1 = new hayvan.kedi.Kedi();  // üsttekinin aynısı
---

$(P
Normalde uzun isimleri kullanmak gerekmez. Onları yalnızca olası karışıklıkları gidermek için kullanırız. Örneğin, iki modülde birden tanımlanmış olan bir ismi kısa olarak yazdığımızda derleyici hangi modüldekinden bahsettiğimizi anlayamaz.
)

$(P
Hem $(C hayvan) modülünde hem de $(C arabalar) modülünde bulunabilecek $(C Jaguar) isimli iki sınıftan hangisinden bahsettiğimizi uzun ismiyle şöyle belirtmek zorunda kalırız:
)

---
import hayvan.jaguar;
import arabalar.jaguar;

// ...

    auto karışıklık =  Jaguar();            $(DERLEME_HATASI)

    auto hayvanım = hayvan.jaguar.Jaguar(); $(CODE_NOTE derlenir)
    auto arabam = arabalar.jaguar.Jaguar(); $(CODE_NOTE derlenir)
---

$(H6 $(IX takma isimle import) $(IX import, takma isimle) Takma isimle eklemek)

$(P
Modüller kolaylık veya isim çakışmalarını önleme gibi amaçlarla takma isim vererek eklenebilirler:
)

---
import $(HILITE etobur =) hayvan.jaguar;
import $(HILITE araç =) arabalar.jaguar;

// ...

    auto hayvanım = $(HILITE etobur.)Jaguar();       $(CODE_NOTE derlenir)
    auto arabam   = $(HILITE araç.)Jaguar();         $(CODE_NOTE derlenir)
---

$(P
Bütün modüle takma isim vermek yerine seçilen her isme ayrı ayrı takma isim de verilebilir.
)

$(P
Bir örnek olarak, aşağıdaki kod $(C -w) derleyici seçeneği ile derlendiğinde derleyici $(C .sort) $(I niteliğinin) değil, $(C sort()) $(I işlevinin) yeğlenmesi yönünde bir uyarı verir:
)

---
import std.stdio;
import std.algorithm;

// ...

    auto dizi = [ 2, 10, 1, 5 ];
    dizi.sort;    $(CODE_NOTE_WRONG derleme UYARISI)
    writeln(dizi);
---

$(SHELL
Warning: use std.algorithm.sort instead of .sort property
)

$(P
$(I Not: Yukarıdaki $(C dizi.sort) ifadesi $(C sort(dizi)) çağrısının eşdeğiridir. Farkı, $(LINK2 /ders/d/ufcs.html, ilerideki bir bölümde) göreceğimiz UFCS söz dizimi ile yazılmış olmasıdır.)
)

$(P
Bu durumda bir çözüm, $(C std.algorithm.sort) işlevinin takma isimle eklenmesidir. Aşağıdaki yeni $(C algSort) ismi $(C sort()) $(I işlevi) anlamına geldiğinden derleyici uyarısına gerek kalmamış olur:
)

---
import std.stdio;
import std.algorithm : $(HILITE algSort =) sort;

void main() {
    auto arr = [ 2, 10, 1, 5 ];
    arr$(HILITE .algSort);
    writeln(arr);
}
---

$(H6 $(IX paket, import) Pakedi modül olarak eklemek)

$(P
Bazen bir paketteki bir modül eklendiğinde o pakedin başka modüllerinin de eklenmeleri gerekiyor olabilir. Örneğin, $(C hayvan.kedi) modülü eklendiğinde $(C hayvan.kopek), $(C hayvan.at), vs. modülleri de ekleniyordur.
)

$(P
Böyle durumlarda modülleri tek tek eklemek yerine bütün pakedi veya bir bölümünü eklemek mümkündür:
)

---
import hayvan;    // ← bütün paket modül gibi ekleniyor
---

$(P
$(IX package.d) Bu, ismi $(C package.d) olan özel bir ayar dosyası ile sağlanır. Bu dosyada önce bir $(C module) satırıyla pakedin ismi bildirilir, sonra da bir arada eklenmeleri gereken modüller $(C public) olarak eklenirler:
)

---
// hayvan/package.d dosyasının içeriği:
module hayvan;

$(HILITE public) import hayvan.kedi;
$(HILITE public) import hayvan.kopek;
$(HILITE public) import hayvan.at;
// ... diğer modüller için de benzer satırlar ...
---

$(P
Bir modülün $(C public) olarak eklenmesi, kullanıcıların eklenen modüldeki isimleri görebilmelerini sağlar. Sonuç olarak, kullanıcılar aslında bir paket olan $(C hayvan) modülünü eklediklerinde $(C hayvan.kedi), $(C hayvan.kopek), vs. modüllere otomatik olarak erişmiş olurlar.
)

$(H6 $(IX deprecated) Modül olanaklarını emekliye ayırmak)

$(P
Modüller geliştikçe yeni sürümleri kullanıma sunulur. Modülün yazarları bazı olanakların belirli bir sürümden sonra $(I emekliye ayrılmalarına) karar vermiş olabilirler. Bir olanağın emekliye ayrılması, yeni yazılacak olan programların artık o olanağı kullanmamaları gerektiği anlamına gelir. Emekliye ayrılan bir olanak daha ilerideki bir sürümde modülden çıkartılabilir bile.
)

$(P
Olanakların emekliye ayrılmalarını gerektiren çeşitli nedenler vardır. Örneğin, modülün yeni sürümü o olanağın yerine kullanılabilecek daha iyi bir olanak getiriyordur, olanak başka bir modüle taşınmıştır, olanağın ismi modülün geri kalanıyla uyumlu olsun diye değiştirilmiştir, vs.
)

$(P
Bir olanağın emekliye ayrılmış olduğu $(C deprecated) anahtar sözcüğü ile ve gerekiyorsa özel bir mesajla bildirilir. Örneğin, aşağıdaki mesaj, $(C bir_şey_yap()) işlevini kullananlara işlevin isminin değiştiğini belirtmektedir:
)

---
deprecated("Lütfen bunun yerine birŞeyYap() işlevini kullanınız.")
void bir_şey_yap() {
    // ...
}
---

$(P
Emekliye ayrılan olanak kullanıldığında derleyicinin nasıl davranacağı aşağıdaki derleyici seçenekleri ile ayarlanabilir:
)

$(UL
$(LI $(IX -d, derleyici seçeneği) $(C -d): Emekliye ayrılmış olan olanakların kullanılmasına izin verilir)
$(LI $(IX -dw, derleyici seçeneği) $(C -dw): Emekliye ayrılmış olan olanak kullanıldığında derleme uyarısı verilir)
$(LI $(IX -de, derleyici seçeneği) $(C -de): Emekliye ayrılmış olan olanak kullanıldığında derleme hatası verilir)
)

$(P
Örneğin, emekliye ayrılmış olan yukarıdaki olanağı kullanan bir program $(C -de) seçeneği ile derlendiğinde derleme hatası oluşur:
)

---
    bir_şey_yap();
---

$(SHELL_SMALL
$ dmd deneme.d $(HILITE -de)
$(SHELL_OBSERVED deneme.d: $(HILITE Deprecation): function deneme.bir_şey_yap is
deprecated - Lütfen bunun yerine birŞeyYap() işlevini kullanınız.)
)

$(P
Çoğu durumda, emekliye ayrılan olanak yeni olanağın $(I takma ismi) olarak tanımlanır:
)

---
deprecated("Lütfen bunun yerine birŞeyYap() işlevini kullanınız.")
$(HILITE alias bir_şey_yap) = birŞeyYap;

void birŞeyYap() {
    // ...
}
---

$(P
$(C alias) anahtar sözcüğünü $(LINK2 /ders/d/alias.html, ilerideki bir bölümde) göreceğiz.
)

$(H6 Modüllerdeki tanımların programa dahil edilmesi)

$(P
$(C import) anahtar sözcüğü, belirtilen modülün programın parçası haline gelmesi için yeterli değildir. $(C import), yalnızca o modüldeki olanakların bu kaynak kod içinde kullanılabilmelerini sağlar. O kadarı ancak kaynak kodun $(I derlenebilmesi) için yeterlidir.
)

$(P
Yukarıdaki programı yalnızca "deneme.d" dosyasını kullanarak oluşturmaya çalışmak yetmez:
)

$(SHELL_SMALL
$ dmd deneme.d -w -de
$(DARK_GRAY deneme.o: In function `_Dmain':
deneme.d: $(HILITE undefined reference) to `_D6hayvan4kedi4Kedi7__ClassZ'
deneme.d: $(HILITE undefined reference) to `_D6hayvan5kopek6Köpek7__ClassZ'
collect2: ld returned 1 exit status)
)

$(P
O hata mesajları $(I bağlayıcıdan) gelir. Her ne kadar anlaşılmaz isimler içeriyor olsalar da, yukarıdaki hata mesajları programda kullanılan bazı tanımların bulunamadıklarını bildirir.
)

$(P
$(IX bağlayıcı) Programın oluşturulması, perde arkasında çağrılan bağlayıcının görevidir. Derleyici, derlediği modülleri bağlayıcıya verir; program, bağlayıcının bir araya getirdiği parçalardan oluşturulur.
)

$(P
$(IX programın oluşturulması) O yüzden, programı oluşturan bütün parçaların derleme satırında belirtilmeleri gerekir. Yukarıdaki programın oluşturulabilmesi için, kullandığı "hayvan/kedi.d" ve "hayvan/kopek.d" dosyaları da derleme satırında bildirilmelidir:
)

$(SHELL_SMALL
$ dmd deneme.d hayvan/kedi.d hayvan/kopek.d -w -de
)

$(P
Modülleri derleme satırında her program için ayrı ayrı belirtmek yerine kütüphaneler içinden de kullanabiliriz.
)

$(H5 $(IX kütüphane) Kütüphaneler)

$(P
Modül tanımlarının derlendikten sonra bir araya getirilmelerine kütüphane adı verilir. Kütüphaneler kendileri program olmadıklarından, programların başlangıç işlevi olan $(C main) kütüphanelerde bulunmaz. Kütüphaneler yalnızca işlev, yapı, sınıf, vs. $(I tanımlarını) bir araya getirirler. Daha sonra program oluşturulurken programın diğer modülleriyle bağlanırlar.
)

$(P
Kütüphane oluşturmak için dmd'nin $(C -lib) seçeneği kullanılır. Oluşturulan kütüphanenin isminin $(C hayvan) olacağını da $(C -of) seçeneği ile bildirirsek, yukarıdaki "kedi.d" ve "kopek.d" modüllerini içeren bir kütüphane şu şekilde oluşturulabilir:
)

$(SHELL_SMALL
$ dmd hayvan/kedi.d hayvan/kopek.d -lib -ofhayvan -w -de
)

$(P
Konsoldan çalıştırılan o komut, belirtilen $(C .d) dosyalarını derler ve bir kütüphane dosyası olarak bir araya getirir. Çalıştığınız ortama bağlı olarak kütüphane dosyasının ismi farklı olacaktır. Örneğin, Linux ortamlarında kütüphane dosyalarının uzantıları .a olur: $(C hayvan.a).
)

$(P
Program oluşturulurken artık "hayvan/kedi.d"nin ve "hayvan/kopek.d"nin ayrı ayrı bildirilmelerine gerek kalmaz. Onları içeren kütüphane dosyası tek başına yeterlidir:
)

$(SHELL_SMALL
$ dmd deneme.d hayvan.a -w -de
)

$(P
O komut, daha önce kullandığımız şu komutun eşdeğeridir:
)

$(SHELL_SMALL
$ dmd deneme.d hayvan/kedi.d hayvan/kopek.d -w -de
)

$(P
$(IX Phobos, kütüphane) Bir istisna olarak, şimdiye kadar çok yararlandığımız Phobos modüllerini içeren standart kütüphanenin açıkça bildirilmesi gerekmez. O kütüphane, programa otomatik olarak dahil edilir. Yoksa normalde onu da örneğin şu şekilde belirtmemiz gerekirdi:
)

$(SHELL_SMALL
$ dmd deneme.d hayvan.a /usr/lib64/libphobos2.a -w -de
)

$(P
$(I Not: Phobos kütüphane dosyasının yeri ve ismi sizin ortamınızda farklı olabilir.)
)

$(H6 Başka dillerin kütüphanelerini kullanmak)

$(P
C ve C++ gibi başka bazı derlemeli dillerin kütüphaneleri D programlarında kullanılabilir. Ancak, farklı diller farklı $(I bağlanım) kullandıklarından, böyle bir kütüphanenin D ile kullanılabilmesi için o kütüphanenin bir $(I D ilintisinin) olması gerekir.
)

$(P
$(IX bağlanım) $(IX özgün isim) $(IX sembol) Bağlanım, bir kütüphanenin olanaklarının dışarıdan erişimini ve o olanakların isimlerinin (sembollerinin) derlenmiş kodda nasıl ifade edildiklerini belirleyen kurallar bütünüdür. Derlenmiş koddaki isimler programcının kaynak kodda yazdığı isimlerden farklıdır: Derlenmiş koddaki isimler belirli bir dilin veya bir derleyicinin kurallarına göre $(I özgünleştirilmişlerdir).
)

$(P
$(IX mangle, core.demangle) Örneğin, ismi kaynak kodda $(C foo) olan bir işlevin derlenmiş koddaki özgün ismi, C bağlanım kurallarına göre başına alt çizgi karakteri eklenerek oluşturulur: $(C _foo). Özgün isim üretme C++ ve D dillerinde daha karmaşıktır çünkü bu diller aynı ismin farklı modüllerde, yapılarda, sınıflarda, ve bir işlevin farklı yüklemelerinde kullanılmasına izin verir. D kaynak kodundaki $(C foo) gibi bir işlevin özgün ismi onu olası bütün başka $(C foo) isimlerinden ayırt edecek biçimde seçilir. Özgün isimlerin tam olarak ne oldukları genelde programcı için önemli olmasa da, bu konuda $(C core.demangle) modülünden yararlanılabilir:
)

---
module deneme;

import std.stdio;
import core.demangle;

void foo() {
}

void main() {
    writeln($(HILITE mangle)!(typeof(foo))("deneme.foo"));
}
---

$(P
$(I Not: Söz dizimi kitabın bu noktasında yabancı gelen $(C mangle) bir işlev şablonudur. Şablonları daha sonra $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) göreceğiz.)
)

$(P
Programın çıktısı, yukarıdaki $(C foo) ile aynı türden olan $(C deneme.foo) isimli bir işlevin özgün ismini göstermektedir:
)

$(SHELL_SMALL
_D6deneme3fooFZv
)

$(P
Bağlayıcının verdiği hata mesajlarının anlaşılmaz isimler içermelerinin nedeni de özgün isimlerdir. Örneğin, yukarıdaki bir bağlayıcı hata mesajında $(C hayvan.kedi.Kedi) ismi değil, $(C _D6hayvan4kedi4Kedi7__ClassZ) ismi geçmiştir.
)

$(P
$(IX extern()) $(IX C) $(IX C++) $(IX D) $(IX Objective-C) $(IX Pascal) $(IX System) $(IX Windows) $(C extern()) niteliği olanakların bağlanımlarını belirtmek için kullanılır. $(C extern()) ile kullanılabilen bağlanım türleri şunlardır: $(C C), $(C C++), $(C D), $(C Objective-C), $(C Pascal), $(C System), ve $(C Windows). Örneğin, bir C kütüphanesinde tanımlanmış olan bir işlevi çağırması gereken bir D kodunun o işlevi C bağlanımı ile bildirmesi gerekir:
)

---
// 'foo'nun C bağlanımı olduğu bildiriliyor (örneğin, bir C
// kütüphanesinde tanımlanmıştır)
$(HILITE extern(C)) void foo();

void main() {
    foo();  // bu işlev çağrısı '_foo' özgün ismi ile yapılır
}
---

$(P
$(IX namespace, C++) C++'ın $(C namespace) anahtar sözcüğü ile tanımlanan isim alanları $(C extern(C++))'ın ikinci parametresi olarak belirtilir. Örneğin, aşağıdaki $(C bar()) bildirimi, C++ kütüphanesindeki $(C a::b::c::bar()) işlevine karşılık gelir (dikkat ederseniz, D kodu $(C ::) yerine nokta kullanır):
)

---
// 'bar'ın a::b::c isim alanında bulunduğu ve C++ bağlanımı
// olduğu bildiriliyor:
extern(C++, $(HILITE a.b.c)) void bar();

void main() {
    bar();          // a::b::c::bar()'a çağrıdır
    a.b.c.bar();    // üsttekinin eşdeğeri
}
---

$(P
$(IX ilinti) Bir kütüphanedeki olanakların D bildirimlerini içeren dosyaya o kütüphanenin $(I D ilintisi) denir. D ilintilerini elle kendiniz yazmak yerine, çoğu yaygın kütüphanenin ilintilerini içeren $(LINK2 https://github.com/D-Programming-Deimos/, Deimos projesinden) yararlanmanızı öneririm.
)

$(P
$(IX extern) Bağlanım türü belirtilmeden kullanılan $(C extern) niteliğinin farklı bir anlamı vardır: Bir değişken için kullanılan yerin başka bir kütüphanenin sorumluluğunda olduğunu bildirir. Farklı anlamlar taşıdıklarından, $(C extern) ve $(C extern()) nitelikleri birlikte kullanılabilir:
)

---
// 'g_degisken' için kullanılan yerin bir C kütüphanesi
// tarafından zaten ayrıldığı bildiriliyor:
extern(C) $(HILITE extern) int g_degisken;
---

$(P
Yukarıdaki $(C extern) niteliği kullanılmasa, C bağlanımına sahip olmasından bağımsız olarak, $(C g_degisken) bu D modülünün bir değişkeni haline gelirdi.
)

Macros:
        SUBTITLE=Modüller ve Kütüphaneler

        DESCRIPTION=D programlarını oluşturan alt parçalar olan modüllerin, ve onların bir araya gelmelerinden oluşan kütüphanelerin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial modül module kütüphane library

SOZLER=
$(baglanim)
$(baglayici)
$(derleyici)
$(emekli)
$(ilinti)
$(is_parcacigi)
$(kaynak_dosya)
$(klasor)
$(kutuphane)
$(modul)
$(ozgun_isim_uretme)
$(paket)
$(phobos)
$(takma_isim)
$(tanim)
