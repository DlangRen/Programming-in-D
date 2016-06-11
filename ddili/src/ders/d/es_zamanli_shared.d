Ddoc

$(DERS_BOLUMU $(IX veri paylaşarak eş zamanlı programlama) $(IX eş zamanlı programlama, veri paylaşarak) Veri Paylaşarak Eş Zamanlı Programlama)

$(P
Bir önceki bölümdeki yöntemler iş parçacıklarının mesajlaşarak bilgi alış verişinde bulunmalarını sağlıyordu. Daha önce de söylediğim gibi, eş zamanlı programlamada güvenli olan yöntem odur.
)

$(P
Diğer yöntem, iş parçacıklarının aynı verilere doğrudan erişmelerine dayanır; iş parçacıkları aynı veriyi doğrudan okuyabilirler ve değiştirebilirler. Örneğin, sahip işçiyi $(C bool) bir değişkenin adresi ile başlatabilir ve işçi de sonlanıp sonlanmayacağını doğrudan o değişkenin değerini okuyarak karar verebilir. Başka bir örnek olarak, sahip bir kaç tane iş parçacığını hesaplarının sonuçlarını ekleyecekleri bir değişkenin adresi ile başlatabilir ve işçiler de o değişkenin değerini doğrudan arttırabilirler.
)

$(P
Veri paylaşımı ancak paylaşılan veri değişmez olduğunda güvenilirdir. Verinin değişebildiği durumda ise iş parçacıkları birbirlerinden habersizce yarış halinde bulunurlar. İşletim sisteminin iş parçacıklarını ne zaman duraksatacağı ve ne zaman tekrar başlatacağı konusunda hiçbir tahminde bulunulamadığından programın davranışı bu yüzden şaşırtıcı derecede karmaşıklaşabilir.
)

$(P
Bu başlık altındaki örnekler fazlaca basit ve anlamsız gelebilir. Buna rağmen, veri paylaşımının burada göreceğimiz sorunlarıyla gerçek programlarda da çok daha büyük ölçeklerde karşılaşılır. Ek olarak, buradaki örnekler iş parçacığı başlatırken kolaylık olarak $(C std.concurrency.spawn)'dan yararlanıyor olsalar da, burada anlatılan kavramlar $(C core.thread) modülünün olanakları ile başlatılmış olan iş parçacıkları için de geçerlidir.
)

$(H5 Paylaşım otomatik değildir)

$(P
Çoğu dilin aksine, D'de değişkenler iş parçacıklarına özeldir. Örneğin, her ne kadar aşağıdaki programdaki $(C değişken) tekmiş gibi görünse de her iş parçacığı o değişkenin kendi kopyasını edinir:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

int $(HILITE değişken);

void bilgiVer(string mesaj) {
    writefln("%s: %s (@%s)", mesaj, değişken, &değişken);
}

void işçi() {
    değişken = $(HILITE 42);
    bilgiVer("İşçi sonlanırken");
}

void main() {
    spawn(&işçi);
    thread_joinAll();
    bilgiVer("İşçi sonlandıktan sonra");
}
---

$(P
$(C işçi)'de değiştirilen değişkenin $(C main)'in kullandığı değişkenin aynısı olmadığı hem $(C main)'deki değerinin sıfır olmasından hem de adreslerinin farklı olmasından anlaşılıyor:
)

$(SHELL
İşçi sonlanırken: 42 (@7F299DEF5660)
İşçi sonlandıktan sonra: 0 (@7F299DFF67C0)
)

$(P
Değişkenlerin iş parçacıklarına özel olmalarının doğal bir sonucu, onların iş parçacıkları tarafından otomatik olarak paylaşılamamalarıdır. Örneğin, sonlanmasını bildirmek için işçiye $(C bool) türündeki bir değişkenin adresini göndermeye çalışan aşağıdaki kod D'de derlenemez:
)

---
import std.concurrency;

void işçi($(HILITE bool * devam_mı)) {
    while (*devam_mı) {
        // ...
    }
}

void main() {
    bool devam_mı = true;
    spawn(&işçi, $(HILITE &devam_mı));      $(DERLEME_HATASI)

    // ...

    // Daha sonra işçi'nin sonlanmasını sağlamak için
    devam_mı = false;

    // ...
}
---

$(P
$(C std.concurrency) modülündeki bir $(C static assert), bir iş parçacığının değişebilen $(ASIL mutable) yerel verisine başka iş parçacığı tarafından erişilmesini engeller:
)

$(SHELL
src/phobos/std/concurrency.d(329): Error: static assert
"Aliases to $(HILITE mutable thread-local data) not allowed."
)

$(P
$(C main()) içindeki $(C devam_mı) değişebilen yerel bir veri olduğundan ona erişim sağlayan adresi hiçbir iş parçacığına geçirilemez.
)

$(P
$(IX __gshared) Verinin iş parçacıklarına özel olmasının bir istisnası, $(C __gshared) olarak işaretlenmiş olan değişkenlerdir:
)

---
__gshared int bütünProgramdaTek;
---

$(P
Bu çeşit değişkenlerden bütün programda tek adet bulunur ve o değişken bütün iş parçacıkları tarafından paylaşılır. $(C __gshared) değişkenler paylaşımın otomatik olduğu C ve C++ gibi dillerin kütüphaneleri ile etkileşirken gerekirler.
)

$(H5 $(IX shared) Veri paylaşımı için $(C shared))

$(P
Değişebilen yerel verilerin iş parçacıkları tarafından paylaşılabilmeleri için "paylaşılan" anlamına gelen $(C shared) olarak işaretlenmeleri gerekir:
)

---
import std.concurrency;

void işçi($(HILITE shared(bool)) * devam_mı) {
    while (*devam_mı) {
        // ...
    }
}

void main() {
    $(HILITE shared(bool)) devam_mı = true;
    spawn(&işçi, &devam_mı);

    // ...

    // Daha sonra işçi'nin sonlanmasını sağlamak için
    devam_mı = false;

    // ...
}
---

$(P
($(I Not: İş parçacıklarının haberleşmeleri için bu örnekteki gibi veri paylaşımını değil, bir önceki bölümdeki mesajlaşmayı yeğleyin.))
)

$(P
$(IX immutable, eş zamanlı programlama) Öte yandan, $(C immutable) verilerin değiştirilmeleri olanaksız olduğundan onların paylaşılmalarında bir sakınca yoktur. O yüzden $(C immutable) veriler açıkça belirtilmeseler de $(C shared)'dirler:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void işçi($(HILITE immutable(int)) * veri) {
    writeln("veri: ", *veri);
}

void main() {
    $(HILITE immutable(int)) bilgi = 42;
    spawn(&işçi, &bilgi);         // ← derlenir

    thread_joinAll();
}
---

$(P
Yukarıdaki program bu sefer derlenir ve beklenen çıktıyı üretir:
)

$(SHELL
veri: 42
)

$(P
$(C bilgi)'nin yaşamı $(C main()) ile sınırlı olduğundan, ona erişmekte olan iş parçacığı sonlanmadan $(C main())'den çıkılmamalıdır. Bu yüzden, yukarıdaki programda $(C main())'den çıkılması programın sonundaki $(C thread_joinAll()) çağrısı ile engellenmekte ve $(C bilgi) değişkeni $(C işçi()) işlediği sürece geçerli kalmaktadır.
)

$(H5 Veri değiştirirken yarış halinde olma örneği)

$(P
Değişebilen verilerin paylaşıldığı durumda programın davranışının doğruluğunu sağlamak programcının sorumluluğundadır.
)

$(P
Bunun önemini görmek için aynı değişebilen veriyi paylaşan birden fazla iş parçacığına bakalım. Aşağıdaki programdaki iş parçacıkları iki değişkenin adreslerini alıyorlar ve o değişkenlerin değerlerini değiş tokuş ediyorlar:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void değişTokuşçu($(HILITE shared(int)) * birinci, $(HILITE shared(int)) * ikinci) {
    foreach (i; 0 .. 10_000) {
        int geçici = *ikinci;
        *ikinci = *birinci;
        *birinci = geçici;
    }
}

void main() {
    $(HILITE shared(int)) i = 1;
    $(HILITE shared(int)) j = 2;

    writefln("önce : %s ve %s", i, j);

    foreach (adet; 0 .. 10) {
        spawn(&değişTokuşçu, &i, &j);
    }

    // Bütün işlemlerin bitmesini bekliyoruz
    thread_joinAll();

    writefln("sonra: %s ve %s", i, j);
}
---

$(P
Ne yazık ki, yukarıdaki program büyük olasılıkla yanlış sonuç üretir. Bunun nedeni, 10 iş parçacığının $(C main()) içindeki $(C i) ve $(C j) isimli aynı değişkenlere erişmeleri ve farkında olmadan yarış halinde birbirlerinin işlerini bozmalarıdır.
)

$(P
Yukarıdaki programdaki toplam değiş tokuş adedi 10 çarpı 10 bindir. Bu değer bir çift sayı olduğundan $(C i)'nin ve $(C j)'nin değerlerinin program sonunda yine başlangıçtaki gibi 1 ve 2 olmalarını bekleriz:
)

$(SHELL
önce : 1 ve 2
sonra: 1 ve 2      $(SHELL_NOTE beklenen sonuç)
)

$(P
Program farklı zamanlarda ve ortamlarda bazen o sonucu üretebilse de aşağıdaki yanlış sonuçların çıkma olasılığı daha yüksektir:
)

$(SHELL
önce : 1 ve 2
sonra: 1 ve 1      $(SHELL_NOTE_WRONG yanlış sonuç)
)

$(SHELL
önce : 1 ve 2
sonra: 2 ve 2      $(SHELL_NOTE_WRONG yanlış sonuç)
)

$(P
Bazı durumlarda sonuç "2 ve 1" bile çıkabilir.
)

$(P
Bunun nedenini A ve B olarak isimlendireceğimiz yalnızca iki iş parçacığının işleyişiyle bile açıklayabiliriz. İşletim sistemi iş parçacıklarını belirsiz zamanlarda duraksatıp tekrar başlattığından bu iki iş parçacığı verileri birbirlerinden habersiz olarak aşağıda gösterildiği biçimde değiştirebilirler.
)

$(P
$(C i)'nin ve $(C j)'nin değerlerinin sırasıyla 1 ve 2 olduğu duruma bakalım. Aynı $(C değişTokuşçu()) işlevini işlettikleri halde A ve B iş parçacıklarının yerel $(C geçici) değişkenleri farklıdır. Ayırt edebilmek için onları aşağıda geçiciA ve geçiciB olarak belirtiyorum.
)

$(P
Her iki iş parçacığının işlettiği aynı 3 satırlık kodun zaman ilerledikçe nasıl işletildiklerini yukarıdan aşağıya doğru gösteriyorum: 1 numaralı işlem ilk işlem, 6 numaralı işlem de son işlem. Her işlemde $(C i) ve $(C j)'den hangisinin değiştiğini de sarıyla işaretliyorum:
)

$(MONO
$(B İşlem            İş parçacığı A                      İş parçacığı B)
─────────────────────────────────────────────────────────────────────────────

  1:   int geçici = *ikinci; (geçiciA==2)
  2:   *ikinci = *birinci;   (i==1, $(HILITE j==1))

                $(I (A duraksatılmış ve B başlatılmış olsun))

  3:                                       int geçici = *ikinci; (geçiciB==1)
  4:                                       *ikinci = *birinci;   (i==1, $(HILITE j==1))

                $(I (B duraksatılmış ve A tekrar başlatılmış olsun))

  5:   *birinci = geçici;    ($(HILITE i==2), j==1)

                $(I (A duraksatılmış ve B tekrar başlatılmış olsun))

  6:                                       *birinci = geçici;    ($(HILITE i==1), j==1)
)

$(P
Görüldüğü gibi, yukarıdaki gibi bir durumda hem $(C i) hem de $(C j) 1 değerini alırlar. Artık programın sonuna kadar başka değer almaları mümkün değildir.
)

$(P
Yukarıdaki işlem sıraları bu programdaki hatayı açıklamaya yeten yalnızca bir durumdur. Onun yerine 10 iş parçacığının etkileşimlerinden oluşan çok sayıda başka karmaşık durum da gösterilebilir.
)

$(H5 $(IX synchronized) Veri korumak için $(C synchronized))

$(P
Yukarıdaki hatalı durum aynı verinin birden fazla iş parçacığı tarafından serbestçe okunması ve yazılması nedeniyle oluşmaktadır. Bu tür hataları önlemenin bir yolu, belirli bir anda yalnızca tek iş parçacığı tarafından işletilmesi gereken kod bloğunu $(C synchronized) olarak işaretlemektir. Yapılacak tek değişiklik programın artık doğru sonuç üretmesi için yeterlidir:
)

---
    foreach (i; 0 .. 10_000) {
        $(HILITE synchronized {)
            int geçici = *ikinci;
            *ikinci = *birinci;
            *birinci = geçici;
        $(HILITE })
    }
---

$(P
Çıktısı:
)

$(SHELL
önce : 1 ve 2
sonra: 1 ve 2      $(SHELL_NOTE doğru sonuç)
)

$(P
$(IX kilit) $(C synchronized), isimsiz bir kilit oluşturur ve bu kilidi belirli bir anda yalnızca tek iş parçacığına verir. Yukarıdaki kod bloğu da bu sayede belirli bir anda tek iş parçacığı tarafından işletilir ve $(C i) ve $(C j)'nin değerleri her seferinde doğru olarak değiş tokuş edilmiş olur. Değişkenler $(C foreach) döngüsünün her adımında ya "1 ve 2" ya da "2 ve 1" durumundadırlar.
)

$(P
$(I Not: Bir iş parçacığının bir kilidin açılmasını beklemesi ve tekrar kilitlemesi masraflı bir işlemdir ve programın farkedilir derecede yavaş işlemesine neden olabilir. Bazı programlarda veri paylaşımı $(C synchronized) ile kilit kullanılmasına gerek kalmadan $(I kesintisiz işlemlerden) yararlanılarak da sağlanabilir ve program bu sayede daha hızlı işleyebilir. Bunun örneklerini biraz aşağıda göreceğiz.)
)

$(P
Kullanacağı kilit veya kilitler $(C synchronized)'a açıkça da verilebilir. Bu, belirli bir anda birden fazla bloktan yalnızca birisinin işlemesini sağlar.
)

$(P
Bunun bir örneğini görmek için aşağıdaki programa bakalım. Bu programda paylaşılan veriyi değiştiren iki kod bloğu bulunuyor. Bu blokları $(C shared(int)) türündeki aynı değişkenin adresi ile çağıracağız. Birisi bu değişkenin değerini arttıracak, diğeri ise azaltacak:
)

---
void arttırıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
       *değer = *değer + 1;
    }
}

void azaltıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        *değer = *değer - 1;
    }
}
---

$(P
$(I Not: Yukarıdaki ifadeler yerine daha kısa olan $(C ++(*değer)) ve $(C &#8209;&#8209;(*değer)) ifadeleri kullanıldığında derleyici o ifadelerin $(C shared) değişkenler üzerinde işletilmelerinin emekliye ayrıldığını bildiren bir uyarı mesajı verir.)
)

$(P
Aynı veriyi değiştirdikleri için bu iki bloğun da $(C synchronized) olarak işaretlenmeleri düşünülebilir, ancak bu yeterli olmaz. Bu bloklar farklı olduklarından her birisi farklı bir kilit ile korunacaktır ve değişkenin tek iş parçacığı tarafından değiştirilmesi yine sağlanamayacaktır:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

enum adet = 1000;

void arttırıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        $(HILITE synchronized) {  // ← bu kilit aşağıdakinden farklıdır
            *değer = *değer + 1;
        }
    }
}

void azaltıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        $(HILITE synchronized) {  // ← bu kilit yukarıdakinden farklıdır
            *değer = *değer - 1;
        }
    }
}

void main() {
    shared(int) ortak = 0;

    foreach (i; 0 .. 100) {
        spawn(&arttırıcı, &ortak);
        spawn(&azaltıcı, &ortak);
    }

    thread_joinAll();
    writeln("son değeri: ", ortak);
}
---

$(P
Eşit sayıda arttırıcı ve azaltıcı iş parçacığı başlatılmış olduğundan $(C ortak) isimli değişkenin son değerinin sıfır olmasını bekleriz ama büyük olasılıkla sıfırdan farklı çıkar:
)

$(SHELL
son değeri: -3325  $(SHELL_NOTE_WRONG sıfır değil)
)

$(P
Farklı blokların aynı kilidi veya kilitleri paylaşmaları gerektiğinde kilit veya kilitler $(C synchronized)'a parantez içinde bildirilir:
)

---
    synchronized ($(I kilit_nesnesi), $(I başka_kilit_nesnesi), ...)
---

$(P
D'de özel bir kilit nesnesi yoktur; herhangi bir sınıf türünün herhangi bir nesnesi kilit olarak kullanılabilir. Yukarıdaki programdaki iş parçacıklarının aynı kilidi kullanmaları için $(C main()) içinde bir nesne oluşturulabilir ve iş parçacıklarına parametre olarak o nesne gönderilebilir. Programın değişen yerlerini işaretliyorum:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

enum adet = 1000;

$(HILITE class Kilit {
})

void arttırıcı(shared(int) * değer, $(HILITE shared(Kilit) kilit)) {
    foreach (i; 0 .. adet) {
        synchronized $(HILITE (kilit)) {
            *değer = *değer + 1;
        }
    }
}

void azaltıcı(shared(int) * değer, $(HILITE shared(Kilit) kilit)) {
    foreach (i; 0 .. adet) {
        synchronized $(HILITE (kilit)) {
            *değer = *değer - 1;
        }
    }
}

void main() {
    $(HILITE shared(Kilit) kilit = new shared(Kilit)());
    shared(int) ortak = 0;

    foreach (i; 0 .. 100) {
        spawn(&arttırıcı, &ortak, $(HILITE kilit));
        spawn(&azaltıcı, &ortak, $(HILITE kilit));
    }

    thread_joinAll();
    writeln("son değeri: ", ortak);
}
---

$(P
Bütün iş parçacıkları $(C main()) içinde tanımlanmış olan aynı kilidi kullandıklarından belirli bir anda bu iki $(C synchronized) bloğundan yalnızca bir tanesi işletilir ve beklenen sonuç elde edilir:
)

$(SHELL
son değeri: 0      $(SHELL_NOTE doğru sonuç)
)

$(P
Sınıflar da $(C synchronized) olarak tanımlanabilirler. Bunun anlamı, o türün bütün üye işlevlerinin aynı kilidi kullanacaklarıdır:
)

---
$(HILITE synchronized) class Sınıf {
    void foo() {
        // ...
    }

    void bar() {
        // ...
    }
}
---

$(P
$(C synchronized) olarak işaretlenen türlerin bütün üye işlevleri nesnenin kendisini kilit olarak kullanırlar. Yukarıdaki sınıfın eşdeğeri aşağıdaki sınıftır:
)

---
class Sınıf {
    void foo() {
        synchronized (this) {
            // ...
        }
    }

    void bar() {
        synchronized (this) {
            // ...
        }
    }
}
---

$(P
Birden fazla nesnenin kilitlenmesi gerektiğinde bütün nesneler aynı $(C synchronized) deyimine yazılmalıdırlar. Aksi taktirde farklı iş parçacıkları farklı nesnelerin kilitlerini ele geçirmiş olabileceklerinden sonsuza kadar birbirlerini bekleyerek takılıp kalabilirler.
)

$(P
Bunun tanınmış bir örneği, bir banka hesabından diğerine para aktaran işlevdir. Böyle bir işlemin hatasız gerçekleşmesi için her iki banka hesabının da kilitlenmesinin gerekeceği açıktır. Bu durumda yukarıda gördüğümüz $(C synchronized) kullanımını aşağıdaki gibi uygulamak hatalı olur:
)

---
void paraAktar(shared(BankaHesabı) kimden,
               shared(BankaHesabı) kime) {
    synchronized (kimden) {           $(CODE_NOTE_WRONG HATALI)
        synchronized (kime) {
            // ...
        }
    }
}
---

$(P
Yanlışlığın nedenini şöyle basit bir durumla açıklayabiliriz: Bir iş parçacığının A hesabından B hesabına para aktardığını, başka bir iş parçacığının da B hesabından A hesabına para aktardığını düşünelim. İşletim sisteminin iş parçacıklarını belirsiz zamanlarda duraksatması sonucunda; $(C kimden) olarak A hesabını işlemekte olan iş parçacığı A nesnesini, $(C kimden) olarak B nesnesini işlemekte olan iş parçacığı da B nesnesini kilitlemiş olabilir. Bu durumda her ikisi de diğerinin elinde tuttuğu nesneyi kilitlemeyi bekleyeceklerinden sonsuza kadar takılıp kalacaklardır.
)

$(P
Bu sorunun çözümü $(C synchronized) deyiminde birden  fazla nesne belirtmektir:
)

---
void paraAktar(shared(BankaHesabı) kimden,
               shared(BankaHesabı) kime) {
    synchronized (kimden, kime) {     // ← doğru
        // ...
    }
}
---

$(P
Derleyici ya nesnelerin ikisinin birden kilitleneceğini ya da hiçbirisinin kilitlenmeyeceğini garanti eder.
)

$(H5 $(IX shared static this) $(IX shared static ~this) $(IX this, shared static) $(IX ~this, shared static) Tek ilkleme için $(C shared static this()) ve tek sonlandırma için $(C shared static ~this()))

$(P
$(C static this())'in modül değişkenlerini ilklerken kullanıldığını görmüştük. D'de veri iş parçacıklarına özel olduğundan $(C static this()) her iş parçacığı için ayrıca işletilir:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

static this() {
    writeln("static this() işletiliyor");
}

void işçi() {
}

void main() {
    spawn(&işçi);

    thread_joinAll();
}
---

$(P
Yukarıdaki programdaki $(C static this()) bir kere ana iş parçacığında bir kere de $(C spawn()) ile başlatılan iş parçacığında işletilir:
)

$(SHELL
static this() işletiliyor
static this() işletiliyor
)

$(P
Bu durum $(C shared) olarak işaretlenmiş olan modül değişkenleri ($(C immutable) dahil) için bir sorun oluşturur çünkü aynı değişkenin birden fazla ilklenmesi $(I yarış hali) nedeniyle özellikle eş zamanlı programlamada yanlış olacaktır. Bunun çözümü $(C shared static this()) bloklarıdır. Bu bloklar bütün programda tek kere işletilirler:
)

---
int a;              // her iş parçacığına özel
immutable int b;    // bütün programda paylaşılan

static this() {
    writeln("İş parçacığı değişkeni ilkleniyor; adresi: ", &a);
    a = 42;
}

$(HILITE shared) static this() {
    writeln("Program değişkeni ilkleniyor; adresi: ", &b);
    b = 43;
}
---

$(P
Çıktısı:
)

$(SHELL
Program değişkeni ilkleniyor; adresi: 6B0140    $(SHELL_NOTE programda tek)
İş parçacığı değişkeni ilkleniyor; adresi: 7F80E22667D0
İş parçacığı değişkeni ilkleniyor; adresi: 7F80E2165670
)

$(P
Benzer biçimde, $(C shared static ~this()) de bütün programda tek kere işletilmesi gereken sonlandırma işlemleri içindir.
)

$(H5 $(IX kesintisiz işlemler) Kesintisiz işlemler)

$(P
İşlemlerin başka iş parçacıkları araya girmeden kesintisiz olarak işletilmesini sağlamanın bir yolu; mikro işlemci, derleyici, veya işletim sistemi tarafından sunulmuş olan kesintisiz işlemlerden yararlanmaktır.
)

$(P
Phobos bu olanakları $(C core.atomic) modülünde sunar. Bu bölümde bu olanaklardan yalnızca ikisini göstereceğim:
)

$(H6 $(IX atomicOp, core.atomic) $(C atomicOp))

$(P
Bu işlev, şablon parametresi olarak belirtilen işleci parametrelerine uygular. Şablon parametresinin $(C +), $(C +=), vs. gibi bir $(I ikili işleç) olması şarttır:
)

---
import core.atomic;

// ...

        atomicOp!"+="(*değer, 1);    // kesintisiz
---

$(P
Yukarıdaki satır, aşağıdakinin kesintiye uğratılmadan işletilmesinin eşdeğeridir:
)

---
        *değer += 1;                 // kesintili
---

$(P
Dolayısıyla, eğer kesintiye uğratılmadan işletilmesi gereken işlem bir ikili işleç ise $(C synchronized) bloğuna gerek kalmaz ve kod daha hızlı işleyebilir. Yukarıdaki $(C arttırıcı) ve $(C azaltıcı) işlevlerinin aşağıdaki eşdeğerleri de programın doğru çalışmasını sağlar. Bu çözümde $(C Kilit) türüne de gerek yoktur:
)

---
import core.atomic;

//...

void arttırıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        $(HILITE atomicOp!"+="(*değer, 1));
    }
}

void azaltıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        $(HILITE atomicOp!"-="(*değer, 1));
    }
}
---

$(P
$(C atomicOp) başka ikili işleçlerle de kullanılabilir.
)

$(H6 $(IX cas, core.atomic) $(C cas))

$(P
Bu işlevin ismi "karşılaştır ve değiş tokuş et" anlamına gelen İngilizce $(I compare and swap)'ın kısasıdır. İşleyişi, $(I değişkenin hâlâ belirli bir değere eşit ise değiştirilmesi) temeline dayanır. Önce değişkenin mevcut değeri okunur ve o değer $(C cas)'a yeni değerle birlikte verilir:
)

---
    bool değişti_mi = cas(değişken_adresi, mevcutDeğer, yeniDeğer);
---

$(P
Değişkenin mevcut değerinin $(C cas)'ın işleyişi sırasında aynı kalmış olması başka bir iş parçacığının araya girmediğinin göstergesidir. Bu durumda $(C cas) değişkene yeni değerini atar ve değişimin başarıyla gerçekleştiğini belirtmek için $(C true) döndürür. Değişkenin eski değerine eşit olmadığını gördüğünde $(C cas) işleyişine devam etmez ve $(C false) döndürür.
)

$(P
Aşağıdaki işlevler $(C cas) başarısız olduğunda (yani, dönüş değeri $(C false) olduğunda) mevcut değeri tekrar okumakta ve işlemi hemen tekrar denemekteler. Bu çağrıların anlamı $(I değeri $(C mevcutDeğer)'e eşit ise yeni değerle değiştir) diye açıklanabilir:
)

---
void arttırıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        int mevcutDeğer;

        do {
            mevcutDeğer = *değer;
        } while (!$(HILITE cas(değer, mevcutDeğer, mevcutDeğer + 1)));
    }
}

void azaltıcı(shared(int) * değer) {
    foreach (i; 0 .. adet) {
        int mevcutDeğer;

        do {
            mevcutDeğer = *değer;
        } while (!$(HILITE cas(değer, mevcutDeğer, mevcutDeğer - 1)));
    }
}
---

$(P
Yukarıdaki işlevler de $(C synchronized) bloğuna gerek kalmadan doğru sonuç üretirler.
)

$(P
$(C core.atomic) modülünün olanakları çoğu durumda $(C synchronized) bloklarından kat kat hızlıdır. Probleme uygun olduğu sürece öncelikle bu modülden yararlanmanızı öneririm.
)

$(P
Bu olanaklar bu kitabın konusu dışında kalan $(I kilitsiz veri yapılarının) gerçekleştirilmelerinde de kullanılırlar.
)

$(P
Klasik eş zamanlı programlamada çok karşılaşılan başka olanakları da $(C core.sync) pakedinin modüllerinde bulabilirsiniz:
)

$(UL

$(LI $(C core.sync.barrier))
$(LI $(C core.sync.condition))
$(LI $(C core.sync.config))
$(LI $(C core.sync.exception))
$(LI $(C core.sync.mutex))
$(LI $(C core.sync.rwmutex))
$(LI $(C core.sync.semaphore))

)

$(H5 Özet)

$(UL

$(LI İş parçacıklarının birbirlerine bağlı olmadıkları durumlarda iki önceki bölümün konusu olan $(C std.parallelism) modülünün sunduğu $(I koşut programlamayı) yeğleyin. Ancak iş parçacıkları birbirlerine bağlı olduklarında $(C std.concurrency)'nin sunduğu $(I eş zamanlı programlamayı) düşünün.)

$(LI Eş zamanlı programlama gerçekten gerektiğinde bir önceki bölümün konusu olan mesajlaşmayı yeğleyin çünkü veri paylaşımı çeşitli program hatalarına açıktır.)

$(LI Yalnızca $(C shared) veriler paylaşılabilir; $(C immutable) otomatik olarak $(C shared)'dir.)

$(LI $(C __gshared) C ve C++ anlamında veri paylaşımı sağlar.)

$(LI $(C synchronized) belirli bir kod bloğunun belirli bir anda tek iş parçacığı tarafından işletilmesini sağlar.)

$(LI Bir sınıf türü $(C synchronized) olarak tanımlandığında belirli bir nesnesi üzerinde belirli bir anda üye işlevlerinden yalnızca birisi işletilir.)

$(LI $(C static this()) her iş parçacığı için ayrıca işletilir; $(C shared static this()) bütün programda tek kere işletilir.)

$(LI $(C core.atomic) modülünün olanakları $(C synchronized)'dan çok daha hızlı işleyen programlar üretir; ancak, her duruma uygun değildir.)

$(LI $(C core.sync) pakedi başka eş zamanlı programlama olanakları içerir.)

)

macros:
        SUBTITLE=Veri Paylaşarak Eş Zamanlı Programlama

        DESCRIPTION=Programın birden fazla iş parçacığı üzerinde işletilmesi ve iş parçacıklarının veri paylaşımı yoluyla iletişimleri (concurrency)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial eş zamanlı programlama iş parçacığı concurrency immutable shared synchronized veri paylaşımı

SOZLER=
$(cokuzlu)
$(degismez)
$(emekli)
$(es_zamanli)
$(gorev)
$(is_parcacigi)
$(kesintisiz_islem)
$(kilitsiz_veri_yapisi)
$(kosut_islemler)
$(yaris_hali)
