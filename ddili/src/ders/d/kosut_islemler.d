Ddoc

$(DERS_BOLUMU $(IX koşut işlem) $(IX std.parallelism) Koşut İşlemler)

$(P
$(IX çekirdek) Günümüzdeki mikro işlemciler her birisi bağımsız işlem birimi olarak kullanılabilen birden fazla $(I çekirdekten) oluşurlar. Çekirdekler farklı programların farklı bölümlerini aynı anda işletebilirler. $(C std.parallelism) modülü bu çekirdeklerin aynı anda işletilmelerini ve programın bu sayede daha hızlı çalışmasını sağlayan olanaklar içerir.
)

$(P
Bu bölümde aşağıdaki olanakların ayrıntılarını göreceğiz. Bu olanakları yalnızca işlemler birbirlerinden bağımsız olduklarında kullanabilirsiniz:
)

$(UL

$(LI $(C parallel): Bir aralığın elemanlarına koşut olarak erişir.)

$(LI $(C task): Başka işlemlerle aynı anda işletilecek olan görevler oluşturur.)

$(LI $(C asyncBuf): $(C InputRange) aralığındaki elemanları yarı hevesli olarak aynı anda ilerletir.)

$(LI $(C map): İşlevleri $(C InputRange) aralığındaki elemanlara yarı hevesli olarak aynı anda uygular.)

$(LI $(C amap): İşlevleri $(C RandomAccessRange) aralığındaki elemanlara tam hevesli olarak aynı anda uygular.)

$(LI $(C reduce): $(C RandomAccessRange) aralığındaki elemanların hesaplarını aynı anda işletir.)

)

$(P
Daha önce kullandığımız bütün örneklerdeki bütün kodlarda işlemlerin yazıldıkları sırada işletildiklerini varsaydık:
)

---
    ++i;
    ++j;
---

$(P
Yukarıdaki kodda önce $(C i)'nin değerinin, ondan sonra da $(C j)'nin değerinin arttırılacağını biliyoruz. Aslında bu her zaman doğru değildir: Derleyicinin kodun daha hızlı işlemesi için uyguladığı eniyileştirmeler sonucunda her iki değişken de mikro işlemcinin yazmaçlarında depolanmış olabilirler. Bu yazmaçlar da birbirlerinden bağımsız olduklarından, mikro işlemci o iki işlemi $(I aynı anda) işletebilir.
)

$(P
Bu tür eniyileştirmeler yararlıdırlar ama çok alt düzeydeki işlemlerden daha üst düzey kapsamlarda uygulanamazlar. Bir grup üst düzey işlemin birbirlerinden bağımsız olduklarına ve bu yüzden de aynı anda işletilebileceklerine çoğu durumda yalnızca programcı karar verebilir.
)

$(P
Aşağıdaki $(C foreach) döngüsündeki elemanların başından sonuna kadar ve teker teker işletileceklerini biliyoruz:
)

---
    auto öğrenciler =
        [ Öğrenci(1), Öğrenci(2), Öğrenci(3), Öğrenci(4) ];

    foreach (öğrenci; öğrenciler) {
        öğrenci.uzunBirİşlem();
    }
---

$(P
Yukarıdaki kod, işletim sisteminin o programı çalıştırmak için seçmiş olduğu tek çekirdek üzerinde işletilir. $(C foreach) döngüsü de öğrencileri başından sonuna kadar işlettiği için $(C uzunBirİşlem()) öğrencilere sırayla ve teker teker uygulanır. Oysa çoğu durumda bir öğrencinin işletilebilmesi için önceki öğrencilerin işlemlerinin tamamlanmış olmaları gerekmez. $(C Öğrenci) işlemlerinin birbirlerinden bağımsız oldukları durumlarda diğer çekirdeklerden yararlanılmıyor olması zaman kaybına yol açacaktır.
)

$(P
$(IX Thread.sleep) Aşağıdaki örneklerdeki işlemlerin hissedilir derecede uzun süren işlemlere benzemeleri için $(C core.thread) modülündeki $(C Thread.sleep)'ten yararlanacağım. $(C Thread.sleep) işlemleri belirtilen süre kadar durdurur. Ne kadar bekleneceğini bildirmenin bir yolu, "süre" anlamına gelen "duration"ın kısaltması olan $(C dur)'u kullanmaktır. $(C dur)'un şablon parametresi zaman birimini belirler: milisaniye için $(STRING "msecs"), saniye için $(STRING "seconds"). $(C Thread.sleep) işlemciyi hiç meşgul etmeden zaman geçirdiği için buradaki örneklerde fazla yapay kalıyor; buna rağmen, koşut işlemlerin amaçlarını göstermede yeterince etkilidir.
)

---
import std.stdio;
import core.thread;

struct Öğrenci {
    int numara;

    void uzunBirİşlem() {
        writeln(numara,
                " numaralı öğrencinin işlemi başladı");

        /* Gerçekte yavaş olduklarını varsaydığımız işlemlerin
         * yavaşlıklarına benzesin diye 1 saniye bekliyoruz */
        Thread.sleep(1.seconds);

        writeln(numara, " numaralı öğrencinin işlemi bitti");
    }
}

void main() {
    auto öğrenciler =
        [ Öğrenci(1), Öğrenci(2), Öğrenci(3), Öğrenci(4) ];

    foreach (öğrenci; öğrenciler) {
        öğrenci.uzunBirİşlem();
    }
}
---

$(P
Yukarıdaki programın çalışma süresi uç birimde $(C time) komutu ile ölçülebilir:
)

$(SHELL
$ $(HILITE time) ./deneme
$(DARK_GRAY 1 numaralı öğrencinin işlemi başladı
1 numaralı öğrencinin işlemi bitti
2 numaralı öğrencinin işlemi başladı
2 numaralı öğrencinin işlemi bitti
3 numaralı öğrencinin işlemi başladı
3 numaralı öğrencinin işlemi bitti
4 numaralı öğrencinin işlemi başladı
4 numaralı öğrencinin işlemi bitti

real    0m4.003s    $(SHELL_NOTE toplam 4 saniye)
user    0m0.000s
sys     0m0.000s)
)

$(P
Öğrenci işlemleri sırayla işletildiklerinden ve her işlem 1 saniye tuttuğundan toplam süre beklendiği gibi yaklaşık olarak 4 saniye olmaktadır. Oysa 4 öğrencinin işlemleri örneğin 4 çekirdeğin bulunduğu bir ortamda aynı anda ve tek seferde işletilebilseler bütün işlem 1 saniye tutabilir.
)

$(P
$(IX totalCPUs) Bunun nasıl gerçekleştirildiğine geçmeden önce, programın çalıştırıldığı ortamda kaç çekirdek bulunduğunun $(C std.parallelism.totalCPUs)'un değeri ile belirlenebildiğini göstermek istiyorum:
)

---
import std.stdio;
import std.parallelism;

void main() {
    writefln("Bu ortamda toplam %s çekirdek var.", totalCPUs);
}
---

$(P
Bu bölümü yazdığım ortamda şu çıktıyı alıyorum:
)

$(SHELL
Bu ortamda toplam 4 çekirdek var.
)

$(H5 $(IX parallel) $(C taskPool.parallel()))

$(P
Bu işlev kısaca $(C parallel()) diye de çağrılabilir.
)

$(P
$(IX foreach, koşut işlem) $(C parallel()), bir aralığın elemanlarına bütün çekirdeklerden yararlanarak koşut olarak erişmeye yarar. Yukarıdaki programa $(C std.parallelism) modülünü eklemek ve $(C öğrenciler) yerine $(C parallel(öğrenciler)) yazmak bütün çekirdeklerden yararlanmak için yeterlidir:
)

---
import std.parallelism;

// ...

    foreach (öğrenci; $(HILITE parallel)(öğrenciler)) {
---

$(P
$(LINK2 /ders/d/foreach_opapply.html, Yapı ve Sınıflarda $(C foreach) bölümünde) gördüğümüz gibi, $(C foreach) döngüsünün kapsamı nesnelerin $(C opApply) işlevlerine bir $(C delegate) olarak gönderilir. $(C parallel())'in döndürdüğü geçici nesne bu $(C delegate)'i her eleman için farklı bir çekirdek üzerinde işleten bir aralık nesnesidir.
)

$(P
Asıl topluluğu $(C parallel()) işlevine göndererek kullanmak, programın 4 çekirdek bulunan bu ortamda 1 saniyede tamamlanması için yeterli olur:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY 2 numaralı öğrencinin işlemi başladı
1 numaralı öğrencinin işlemi başladı
3 numaralı öğrencinin işlemi başladı
4 numaralı öğrencinin işlemi başladı
2 numaralı öğrencinin işlemi bitti
3 numaralı öğrencinin işlemi bitti
1 numaralı öğrencinin işlemi bitti
4 numaralı öğrencinin işlemi bitti

real    0m1.004s    $(SHELL_NOTE şimdi 1 saniye)
user    0m0.000s
sys     0m0.000s)
)

$(P
$(I Not: Programın çalışma süresi sizin ortamınızda farklı olabilir; kabaca "4 saniye bölü çekirdek sayısı" hesabının sonucu kadar sürede tamamlanacağını bekleyebiliriz.)
)

$(P
$(IX iş parçacığı) Programların işletilmeleri sırasında mikro işlemcinin kodların üzerinden belirli geçişlerine $(I iş parçacığı) denir. Programlar aynı anda etkin olarak işletilen birden fazla iş parçacığından oluşuyor olabilirler. İşletim sistemi her iş parçacığını bir çekirdek üzerinde başlatır, işletir, ve diğer iş parçacıkları da işletilebilsinler diye duraklatır. Her iş parçacığının işletilmesi bir çok kere başlatılması ve duraklatılması ile devam eder.
)

$(P
Mikro işlemcinin bütün çekirdekleri işletim sistemindeki bütün iş parçacıkları tarafından paylaşılır. Bu iş parçacıklarının hangi sırayla başlatıldıklarına ve hangi koşullarda duraksatıldıklarına işletim sistemi karar verir. Bu yüzden $(C uzunBirİşlem()) içinde yazdırdığımız mesajların sıralarının karışık olarak çıktıklarını görüyoruz. Döngü içindeki işlemler her öğrenci için bağımsız oldukları sürece hangisinin daha önce sonlandığının programın işleyişi açısından bir önemi yoktur.
)

$(P
$(C parallel()) yardımıyla aynı anda işletilen işlemlerin gerçekten birbirlerinden bağımsız oldukları programcının sorumluluğundadır. Örneğin, yukarıdaki mesajların çıkışta belirli bir sırada görünmeleri gerekseydi bunu sağlamak elimizde olmadığından $(C parallel())'in kullanılması bir hata olarak kabul edilirdi. İş parçacıklarının birbirlerine bağımlı oldukları durumlarda $(I eş zamanlı programlamadan) yararlanılır. Onu bir sonraki bölümde göreceğiz.
)

$(P
$(C foreach) tamamlandığında bütün işlemler de tamamlanmıştır. Program işleyişine bütün öğrenci işlemlerinin tamamlanmış oldukları garantisiyle devam edebilir.
)

$(H6 $(IX iş birimi büyüklüğü) İş birimi büyüklüğü)

$(P
$(C parallel())'in ikinci parametresinin anlamı duruma göre farklılık gösterir ve bazen bütünüyle gözardı edilir:
)

---
    /* ... */ = parallel($(I aralık), $(I iş_birimi_büyüklüğü) = 100);
---

$(UL

$(LI $(C RandomAccessRange) aralıkları üzerinde ilerlerken:

$(P
İşlemlerin iş parçacıklarına dağıtılmalarının küçük de olsa bir bedeli vardır. Bu bedel özellikle işlemlerin kısa sürdüğü durumlarda farkedilir düzeyde olabilir. Bunun önüne geçmek gereken nadir durumlarda her iş parçacığına birden fazla eleman vermek daha hızlı olabilir:
)

---
    foreach (öğrenci; parallel(öğrenciler, $(HILITE 2))) {
        // ...
    }
---

$(P
Yukarıdaki kod elemanların iş parçacıklarına ikişer ikişer dağıtılmalarını sağlar.
)

$(P
Otomatik olarak seçilen iş birimi büyüklüğü çoğu duruma uygundur ve özel olarak belirtilmesi gerekmez.)

)

$(LI $(C RandomAccessRange) olmayan aralıklar üzerinde ilerlerken:

$(P
$(C parallel()), $(C RandomAccessRange) olmayan aralıklar üzerinde ilerlerken ilk elemanları koşut olarak değil, sırayla işletir. Asıl koşutluk baştaki $(I iş birimi büyüklüğü) adet elemanın işlemleri tamamlandıktan sonra başlar. Bu yüzden kısa ve $(C RandomAccessRange) olmayan aralıklar üzerinde ilerlerken $(C parallel())'in etkisiz olduğu gibi yanlış bir izlenim edinilebilir.
)

)

$(LI $(C asyncBuf()) ve koşut $(C map())'in sonuçları üzerinde ilerlerken (bu iki işlevi aşağıda göreceğiz):

$(P
Bu durumda iş birimi büyüklüğü bütünüyle gözardı edilir. $(C parallel()), $(C asyncBuf()) veya $(C map())'in sonuç olarak ürettiği aralığın içindeki ara belleği kullanır.
)

)

)

$(H5 $(IX Task) Görev türü $(C Task))

$(P
Programdaki başka işlemlerle aynı anda işletilebilen işlemlere $(I görev) denir. Görevler $(C std.parallelism.Task) türü ile ifade edilirler.
)

$(P
$(C parallel()) her iş parçacığı için $(C foreach) bloğundaki işlemlerden oluşan farklı bir $(C Task) nesnesi kurar ve o görevi otomatik olarak başlatır. $(C foreach) döngüsünden çıkmadan önce de başlattığı bütün görevlerin tamamlanmalarını bekler. $(I Kurma), $(I başlatma), ve $(I tamamlanmasını bekleme) işlemlerini otomatik olarak yürüttüğü için çok yararlıdır.
)

$(P
$(IX task) $(IX executeInNewThread) $(IX yieldForce) Aynı anda işletilebilen işlemlerin herhangi bir topluluk ile doğrudan ilgileri olmayan durumlarda kurma, başlatma, ve bekleme işlevlerinin bir $(C Task) nesnesi üzerinden açıkça çağrılmaları gerekir. Görev nesnesi kurmak için $(C task()), görevi başlatmak için $(C executeInNewThread()), görevin tamamlanmasını beklemek için de $(C yieldForce()) kullanılır. Bu işlevleri aşağıdaki programın açıklama satırlarında anlatıyorum.
)

$(P
Aşağıdaki programdaki $(C birİşlem()) iki farklı iş için iki kere başlatılmaktadır. Hangi iş ile ilgili olarak işlediğini görebilmemiz için $(C kimlik)'in baş harfini çıkışa yazdırıyor.
)

$(P
$(IX flush, std.stdio) $(I Not: Standart çıkışa yazdırılan bilgiler çoğu durumda çıkışta hemen belirmezler; satır sonu karakteri gelene kadar bir ara bellekte bekletilirler. $(C write) satır sonu karakteri yazdırmadığından, programın işleyişini izleyebilmek için o ara belleğin hemen çıkışa gönderilmesini $(C stdout.flush()) ile sağlıyoruz.)
)

---
import std.stdio;
import std.parallelism;
import std.array;
import core.thread;

/* kimlik'in baş harfini yarım saniyede bir çıkışa yazdırır */
int birİşlem(string kimlik, int süre) {
    writefln("%s %s saniye sürecek", kimlik, süre);

    foreach (i; 0 .. (süre * 2)) {
        Thread.sleep(500.msecs);  /* yarım saniye */
        write(kimlik.front);
        stdout.flush();
    }

    return 1;
}

void main() {
    /* birİşlem()'i işletecek olan bir görev kuruluyor.
     * Burada belirtilen işlev parametreleri görev işlevine
     * parametre olarak gönderilirler. */
    auto görev = $(HILITE task!birİşlem)("görev", 5);

    /* 'görev' başlatılıyor */
    görev.$(HILITE executeInNewThread());

    /* 'görev' işine devam ederken başka bir işlem
     * başlatılıyor */
    immutable sonuç = birİşlem("main içindeki işlem", 3);

    /* Bu noktada main içinde başlatılan işlemin
     * tamamlandığından eminiz; çünkü onu görev olarak değil,
     * her zaman yaptığımız gibi bir işlev çağrısı olarak
     * başlattık. */

    /* Öte yandan, bu noktada 'görev'in işini tamamlayıp
     * tamamlamadığından emin olamayız. Gerekiyorsa
     * tamamlanana kadar beklemek için yieldForce()'u
     * çağırıyoruz. yieldForce() ancak görev tamamlanmışsa
     * döner. Dönüş değeri görev işlevinin, yani
     * birİşlem()'in dönüş değeridir. */
    immutable görevSonucu = görev.$(HILITE yieldForce());

    writeln();
    writefln("Hepsi tamam; sonuç: %s", sonuç + görevSonucu);
}
---

$(P
Programın çıktısı benim denediğim ortamda aşağıdakine benziyor. İşlemlerin aynı anda gerçekleştiklerini $(C m) ve $(C g) harflerinin karışık olarak yazdırılmalarından anlıyoruz:
)

$(SHELL
main içindeki işlem 3 saniye sürecek
görev 5 saniye sürecek
mgmggmmgmgmggggg
Hepsi tamam; sonuç: 2
)

$(P
Yukarıdaki $(C task!birİşlem) kullanımında görev işlevi $(C task)'e şablon parametresi olarak belirtilmektedir. Bu yöntem çoğu duruma uygun olsa da, $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) gördüğümüz gibi, bir şablonun her farklı gerçekleştirmesi farklı bir türdendir. Bu fark, aynı türden olmalarını bekleyeceğimiz görev nesnelerinin aslında farklı türden olmalarına ve bu yüzden birlikte kullanılamamalarına neden olabilir.
)

$(P
Örneğin, aşağıdaki iki işlevin parametre ve dönüş türleri aynı olduğu halde $(C task()) işlev şablonu yoluyla elde edilen iki $(C Task) şablon gerçekleştirmesi farklı türdendir. Bu yüzden, aynı dizinin elemanı olamazlar:
)

---
import std.parallelism;

double foo(int i) {
    return i * 1.5;
}

double bar(int i) {
    return i * 2.5;
}

void main() {
    auto tasks = [ task$(HILITE !)foo(1),
                   task$(HILITE !)bar(2) ];    $(DERLEME_HATASI)
}
---

$(P
Derleyici, "uyumsuz türler" anlamına gelen bir hata mesajı verir:
)

$(SHELL
Error: $(HILITE incompatible types) for ((task(1)) : (task(2))):
'Task!($(HILITE foo), int)*' and 'Task!($(HILITE bar), int)*'
)

$(P
$(C task())'in başka bir yüklemesi görev işlevini şablon parametresi olarak değil, işlev parametresi olarak alır:
)

---
    void işlem(int sayı) {
        // ...
    }

    auto görev = task($(HILITE &işlem), 42);
---

$(P
Bu yöntem farklı şablon gerçekleştirmeleri kullanmadığından, farklı işlev kullanıyor olsalar bile farklı $(C Task) nesneleri aynı dizinin elemanı olabilirler:
)

---
import std.parallelism;

double foo(int i) {
    return i * 1.5;
}

double bar(int i) {
    return i * 2.5;
}

void main() {
    auto tasks = [ task($(HILITE &)foo, 1),
                   task($(HILITE &)bar, 2) ];    $(CODE_NOTE derlenir)
}
---

$(P
Gerektiğinde isimsiz bir işlev veya $(C opCall()) işlecini tanımlamış olan bir türün bir nesnesi de kullanılabilir. Örneğin bir isimsiz işlev ile şöyle çağrılabilir:
)

---
    auto görev = task((int sayı) $(HILITE {)
                          /* ... */
                      $(HILITE }), 42);
---

$(H6 $(IX hata, koşut işlem) Atılan hatalar)

$(P
Görevler farklı iş parçacıklarında işletildiklerinden, attıkları hatalar onları başlatan iş parçacığı tarafından yakalanamaz. Bu yüzden, atılan hatayı görevin kendisi yakalar ve $(C yieldForce()) çağrılana kadar bekletir. Aynı hata $(C yieldForce()) çağrıldığında tekrar atılır ve böylece görevi başlatmış olan iş parçacığı tarafından yakalanabilir.
)

---
import std.stdio;
import std.parallelism;
import core.thread;

void hataAtanİşlem() {
    writeln("hataAtanİşlem() başladı");
    Thread.sleep(1.seconds);
    writeln("hataAtanİşlem() hata atıyor");
    throw new Exception("Atılan hata");
}

void main() {
    auto görev = task!hataAtanİşlem();
    görev.executeInNewThread();

    writeln("main devam ediyor");
    Thread.sleep(3.seconds);

    writeln("main, görev'in sonucunu alıyor");
    görev.yieldForce();
}
---

$(P
Görev sırasında atılan hatanın programı hemen sonlandırmadığını programın çıktısında görüyoruz:
)

$(SHELL
main devam ediyor
hataAtanİşlem() başladı
hataAtanİşlem() hata atıyor                   $(SHELL_NOTE atıldığı zaman)
main, görev'in sonucunu alıyor
object.Exception@deneme.d(10): Atılan hata    $(SHELL_NOTE farkedildiği zaman)
)

$(P
Görevin attığı hata, istendiğinde $(C yieldForce())'u sarmalayan bir $(C try-catch) bloğu ile yakalanabilir. Bunun alışılmışın dışında bir kullanım olduğuna dikkat edin: $(C try-catch) bloğu normalde hatayı atan kodu sarmalar. Görevlerde ise $(C yieldForce())'u sarmalar:
)

---
    try {
        görev.yieldForce();

    } catch (Exception hata) {
        writefln("görev sırasında bir hata olmuş: '%s'",
                 hata.msg);
    }
---

$(P
Programın şimdiki çıktısı:
)

$(SHELL
main devam ediyor
hataAtanİşlem() başladı
hataAtanİşlem() hata atıyor                   $(SHELL_NOTE atıldığı zaman)
main, görev'in sonucunu alıyor
görev sırasında bir hata olmuş: 'Atılan hata' $(SHELL_NOTE yakalandığı zaman)
)

$(H6 $(C Task) işlevleri)

$(UL

$(LI $(C done): Görevin tamamlanıp tamamlanmadığını bildirir; görev sırasında hata atılmışsa o hatayı atar.

---
    if (görev.done) {
        writeln("Tamamlanmış");

    } else {
        writeln("İşlemeye devam ediyor");
    }
---

)

$(LI $(C executeInNewThread()): Görevi yeni başlattığı bir iş parçacığında işletir.)

$(LI $(C executeInNewThread(int öncelik)): Görevi yeni başlattığı iş parçacığında ve belirtilen öncelikle $(ASIL priority) işletir. (Öncelik değeri iş parçacıklarının işlem önceliklerini belirleyen bir işletim sistemi kavramıdır.))

)

$(P
Görevin tamamlanmasını beklemek için üç farklı işlev vardır:
)

$(UL

$(LI $(C yieldForce()): Henüz başlatılmamışsa görevi bu iş parçacığında başlatır; zaten tamamlanmışsa dönüş değerini döndürür; hâlâ işlemekteyse bitmesini mikro işlemciyi meşgul etmeden bekler; hata atılmışsa tekrar atar.)

$(LI $(IX spinForce) $(C spinForce()): $(C yieldForce())'tan farkı, gerektiğinde mikro işlemciyi meşgul ederek beklemesidir.)

$(LI $(IX workForce) $(C workForce()): $(C yieldForce())'tan farkı, beklenen görev tamamlananana kadar yeni bir görevi işletmeye başlamasıdır.)

)

$(P
Bunlar arasından çoğu durumda en uygun olan $(C yieldForce())'tur. $(C spinForce()), her ne kadar mikro işlemciyi meşgul etse de görevin çok kısa bir süre sonra tamamlanacağının bilindiği durumlarda yararlıdır. $(C workForce()), görev beklenene kadar başka bir görevin başlatılmasının istendiği durumlara uygundur.
)

$(P
$(C Task)'in diğer üye işlevleri için internet üzerindeki Phobos belgelerine bakınız.
)

$(H5 $(IX asyncBuf) $(C taskPool.asyncBuf()))

$(P
Bu işlev normalde sırayla ilerletilen $(C InputRange) aralıklarının koşut olarak ilerletilmelerini sağlar. $(C asyncBuf()) koşut olarak ilerlettiği aralığın elemanlarını kendisine ait bir ara bellekte bekletir ve gerektikçe buradan sunar.
)

$(P
Ancak, olasılıkla bütünüyle tembel olan giriş aralığının bütünüyle hevesli hale gelmesini önlemek için elemanları dalgalar halinde ilerletir. Belirli sayıdaki elemanı koşut olarak hazırladıktan sonra onlar $(C popFront()) ile aralıktan çıkartılana kadar başka işlem yapmaz. Daha sonraki elemanları hesaplamaya başlamadan önce hazırdaki o elemanların tamamen kullanılmalarını bekler.
)

$(P
Parametre olarak bir aralık ve seçime bağlı olarak her dalgada kaç eleman ilerletileceği bilgisini alır. Bu bilgiyi $(I ara bellek uzunluğu) olarak adlandırabiliriz:
)

---
    auto elemanlar = taskPool.asyncBuf($(I aralık), $(I ara_bellek_uzunluğu));
---

$(P
$(C asyncBuf())'ın etkisini görmek için hem ilerletilmesi hem de $(C foreach) içindeki kullanımı yarım saniye süren bir aralık olduğunu varsayalım. Bu aralık, kurulurken belirtilmiş olan sınır değere kadar elemanlar üretiyor:
)

---
import std.stdio;
import core.thread;

struct BirAralık {
    int sınır;
    int i;

    bool empty() const @property {
        return i >= sınır;
    }

    int front() const @property {
        return i;
    }

    void popFront() {
        writefln("%s değerinden sonrası hesaplanıyor", i);
        Thread.sleep(500.msecs);
        ++i;
    }
}

void main() {
    auto aralık = BirAralık(10);

    foreach (eleman; aralık) {
        writefln("%s değeri kullanılıyor", eleman);
        Thread.sleep(500.msecs);
    }
}
---

$(P
Aralık tembel olarak kullanıldıkça elemanları teker teker hesaplanır ve döngü içinde kullanılır. Her elemanın hesaplanması ve kullanılması toplam bir saniye sürdüğü için 10 elemanlı aralığın işlemleri 10 saniye sürer:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
0 değeri kullanılıyor
0 değerinden sonrası hesaplanıyor
1 değeri kullanılıyor
1 değerinden sonrası hesaplanıyor
2 değeri kullanılıyor
...
8 değerinden sonrası hesaplanıyor
9 değeri kullanılıyor
9 değerinden sonrası hesaplanıyor

real	0m10.007s    $(SHELL_NOTE toplam 10 saniye)
user	0m0.004s
sys	0m0.000s)
)

$(P
Elemanların sırayla hesaplandıkları ve kullanıldıkları görülüyor.
)

$(P
Oysa, bir sonraki elemanın hazırlanmasına başlamak için öndeki elemanların işlemlerinin sonlanmaları gerekmeyebilir. Öndeki elemanın kullanılması ile bir sonraki elemanın hesaplanması aynı anda gerçekleşebilseler, bütün süre kabaca yarıya inebilir. $(C asyncBuf()) bunu sağlar:
)

---
import std.parallelism;
//...
    foreach (eleman; $(HILITE taskPool.asyncBuf)(aralık, $(HILITE 2))) {
---

$(P
Yukarıdaki kullanımda $(C asyncBuf()) her seferinde iki elemanı hazırda bekletecektir. Yeni elemanların hazırlanmaları döngü işlemleri ile koşut olarak gerçekleştirilir ve toplam süre azalır:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
0 değerinden sonrası hesaplanıyor
1 değerinden sonrası hesaplanıyor
0 değeri kullanılıyor
2 değerinden sonrası hesaplanıyor
1 değeri kullanılıyor
3 değerinden sonrası hesaplanıyor
2 değeri kullanılıyor
4 değerinden sonrası hesaplanıyor
3 değeri kullanılıyor
5 değerinden sonrası hesaplanıyor
4 değeri kullanılıyor
6 değerinden sonrası hesaplanıyor
5 değeri kullanılıyor
7 değerinden sonrası hesaplanıyor
6 değeri kullanılıyor
8 değerinden sonrası hesaplanıyor
7 değeri kullanılıyor
9 değerinden sonrası hesaplanıyor
8 değeri kullanılıyor
9 değeri kullanılıyor

real	0m6.007s    $(SHELL_NOTE şimdi 6 saniye)
user	0m0.000s
sys	0m0.004s)
)

$(P
Hangi ara bellek uzunluğunun daha hızlı sonuç vereceği her programa ve her duruma göre değişebilir. Ara bellek uzunluğunun varsayılan değeri 100'dür.
)

$(P
$(C asyncBuf()) $(C foreach) döngüleri dışında da yararlıdır. Aşağıdaki kod $(C asyncBuf())'ın dönüş değerini bir $(C InputRange) aralığı olarak kullanıyor:
)

---
    auto aralık = BirAralık(10);
    auto koşutAralık = taskPool.asyncBuf(aralık, 2);
    writeln($(HILITE koşutAralık.front));
---

$(H5 $(IX map, koşut işlem) $(C taskPool.map()))

$(P
$(IX map, std.algorithm) Koşut $(C map())'i anlamadan önce $(C std.algorithm) modülündeki $(C map())'i anlamak gerekir. Çoğu fonksiyonel dilde de bulunan $(C std.algorithm.map), belirli bir işlevi belirli bir aralıktaki bütün elemanlara teker teker uygular. Sonuç olarak o işlevin sonuçlarından oluşan yeni bir aralık döndürür. İşleyişi tembeldir; işlevi elemanlara ancak gerektikçe uygular. $(C std.algorithm.map) tek çekirdek üzerinde işler.
)

$(P
$(C map())'in tembel işleyişi bir çok programda hız açısından yararlıdır. Ancak, işlevin nasıl olsa bütün elemanlara da uygulanacağı ve o işlemlerin birbirlerinden bağımsız oldukları durumlarda bu tembellik aksine yavaşlığa neden olabilir. $(C std.parallelism) modülündeki $(C taskPool.map()) ve $(C taskPool.amap()) ise bütün işlemci çekirdeklerinden yararlanırlar ve bu gibi durumlarda daha hızlı işleyebilirler.
)

$(P
Bu üç algoritmayı yine $(C Öğrenci) örneği üzerinde karşılaştıralım. Elemanlara uygulanacak olan işlev örneği olarak $(C Öğrenci) türünün not ortalaması döndüren bir işlevi olduğunu varsayalım. Koşut programlamanın etkisini görebilmek için bu işlevi de $(C Thread.sleep) ile yapay olarak yavaşlatalım.
)

$(P
$(C std.algorithm.map), uygulanacak olan işlevi şablon parametresi olarak, aralığı da işlev parametresi olarak alır. İşlevin elemanlara uygulanmasından oluşan sonuç değerleri başka bir aralık olarak döndürür:
)

---
    auto $(I sonuç_aralık) = map!$(I işlev)($(I aralık));
---

$(P
İşlev $(C map())'e önceki bölümlerde de gördüğümüz gibi $(I isimsiz işlev) olarak verilebilir. Aşağıdaki örnekteki $(C ö) parametresi işlevin uygulanmakta olduğu elemanı belirler:
)

---
import std.stdio;
import std.algorithm;
import core.thread;

struct Öğrenci {
    int numara;
    int[] notlar;

    double ortalamaNot() @property {
        writeln(numara,
                " numaralı öğrencinin işlemi başladı");
        Thread.sleep(1.seconds);

        const ortalama = notlar.sum / notlar.length;

        writeln(numara, " numaralı öğrencinin işlemi bitti");
        return ortalama;
    }
}

void main() {
    Öğrenci[] öğrenciler;

    foreach (i; 0 .. 10) {
        /* Her öğrenciye 80'li ve 90'lı iki not */
        öğrenciler ~= Öğrenci(i, [80 + i, 90 + i]);
    }

    auto sonuçlar = $(HILITE map)!(ö => ö.ortalamaNot)(öğrenciler);

    foreach (sonuç; sonuçlar) {
        writeln(sonuç);
    }
}
---

$(P
Programın çıktısı $(C map())'in tembel olarak işlediğini gösteriyor; $(C ortalamaNot()) her sonuç için $(C foreach) ilerledikçe çağrılır:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
0 numaralı öğrencinin işlemi başladı
0 numaralı öğrencinin işlemi bitti
85              $(SHELL_NOTE foreach ilerledikçe hesaplanır)
1 numaralı öğrencinin işlemi başladı
1 numaralı öğrencinin işlemi bitti
86
...
9 numaralı öğrencinin işlemi başladı
9 numaralı öğrencinin işlemi bitti
94

real	0m10.006s    $(SHELL_NOTE toplam 10 saniye)
user	0m0.000s
sys	0m0.004s)
)

$(P
$(C std.algorithm.map) hevesli bir algoritma olsaydı, işlemlerin başlangıç ve bitişleriyle ilgili mesajların hepsi en başta yazdırılırlardı.
)

$(P
$(C std.parallelism) modülündeki $(C taskPool.map()), temelde $(C std.algorithm.map) ile aynı biçimde işler. Tek farkı, işlevleri aynı anda işletmesidir. Ürettiği sonuçları uzunluğu ikinci parametresi ile belirtilen bir ara belleğe yerleştirir ve buradan sunar. Örneğin, aşağıdaki kod işlevleri her adımda üç eleman için aynı anda işletir:
)

---
import std.parallelism;
// ...
double ortalamaNot(Öğrenci öğrenci) {
    return öğrenci.ortalamaNot;
}
// ...
    auto sonuçlar = $(HILITE taskPool.map)!ortalamaNot(öğrenciler, $(HILITE 3));
---

$(P
$(I Not: Yukarıdaki $(C ortalamaNot()) işlevi temsilcilerin şablonlarla kullanımları ile ilgili bir kısıtlama nedeniyle gerekmiştir. Daha kısa olan aşağıdaki satır, $(C TaskPool.map)'in bir "sınıf içi şablon" olması nedeniyle derlenemez:)
)

---
auto sonuçlar =
    taskPool.map!(ö => ö.ortalamaNot)(öğrenciler, 3); $(DERLEME_HATASI)
---

$(P
Bu sefer işlemlerin üçer üçer aynı anda ama belirsiz sırada işletildiklerini görüyoruz:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
0 numaralı öğrencinin işlemi başladı $(SHELL_NOTE aynı anda)
2 numaralı öğrencinin işlemi başladı $(SHELL_NOTE ama belirsiz sırada)
1 numaralı öğrencinin işlemi başladı
0 numaralı öğrencinin işlemi bitti
2 numaralı öğrencinin işlemi bitti
1 numaralı öğrencinin işlemi bitti
85
86
87
5 numaralı öğrencinin işlemi başladı
3 numaralı öğrencinin işlemi başladı
4 numaralı öğrencinin işlemi başladı
5 numaralı öğrencinin işlemi bitti
4 numaralı öğrencinin işlemi bitti
3 numaralı öğrencinin işlemi bitti
88
89
90
8 numaralı öğrencinin işlemi başladı
6 numaralı öğrencinin işlemi başladı
7 numaralı öğrencinin işlemi başladı
8 numaralı öğrencinin işlemi bitti
6 numaralı öğrencinin işlemi bitti
7 numaralı öğrencinin işlemi bitti
91
92
93
9 numaralı öğrencinin işlemi başladı
9 numaralı öğrencinin işlemi bitti
94

real	0m4.007s    $(SHELL_NOTE toplam 4 saniye)
user	0m0.000s
sys	0m0.004s)
)

$(P
İşlevin belgesinde $(C bufSize) olarak geçen ikinci parametrenin anlamı $(C asyncBuf())'ın ikinci parametresi ile aynı anlamdadır. Bu parametre, üretilen sonuçların depolandığı ara belleğin uzunluğunu belirtir ve varsayılan değeri 100'dür. Üçüncü parametre ise $(C parallel())'de olduğu gibi $(I iş birimi büyüklüğü) anlamındadır. Farkı, varsayılan değerinin $(C size_t.max) olmasıdır:
)

---
    /* ... */ = taskPool.map!$(I işlev)($(I aralık),
                                   $(I ara_bellek_uzunluğu) = 100,
                                   $(I iş_birimi_büyüklüğü) = size_t.max);
---

$(H5 $(IX amap) $(C taskPool.amap()))

$(P
İki fark dışında $(C taskPool.map()) ile aynı biçimde işler:
)

$(UL

$(LI
Bütünüyle hevesli bir algoritmadır.
)

$(LI
Yalnızca $(C RandomAccessRange) aralıklarıyla işler.
)

)

---
    auto sonuçlar = $(HILITE taskPool.amap)!ortalamaNot(öğrenciler);
---

$(P
Hevesli olduğu için $(C amap())'ten dönüldüğünde bütün sonuçlar hesaplanmışlardır:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
0 numaralı öğrencinin işlemi başladı $(SHELL_NOTE hepsi en başta)
2 numaralı öğrencinin işlemi başladı
1 numaralı öğrencinin işlemi başladı
3 numaralı öğrencinin işlemi başladı
0 numaralı öğrencinin işlemi bitti
4 numaralı öğrencinin işlemi başladı
1 numaralı öğrencinin işlemi bitti
5 numaralı öğrencinin işlemi başladı
3 numaralı öğrencinin işlemi bitti
6 numaralı öğrencinin işlemi başladı
2 numaralı öğrencinin işlemi bitti
7 numaralı öğrencinin işlemi başladı
4 numaralı öğrencinin işlemi bitti
8 numaralı öğrencinin işlemi başladı
5 numaralı öğrencinin işlemi bitti
9 numaralı öğrencinin işlemi başladı
6 numaralı öğrencinin işlemi bitti
7 numaralı öğrencinin işlemi bitti
9 numaralı öğrencinin işlemi bitti
8 numaralı öğrencinin işlemi bitti
85
86
87
88
89
90
91
92
93
94

real	0m3.005s    $(SHELL_NOTE toplam 3 saniye)
user	0m0.000s
sys	0m0.004s)
)

$(P
$(C amap()) koşut $(C map())'ten daha hızlı işler ama bütün sonuçları alacak kadar büyük bir dizi kullanmak zorundadır. Hız kazancının karşılığı olarak daha fazla bellek kullanır.
)

$(P
$(C amap())'in isteğe bağlı olan ikinci parametresi de $(C parallel())'de olduğu gibi $(I iş birimi büyüklüğü) anlamındadır:
)

---
    auto sonuçlar = taskPool.amap!ortalamaNot(öğrenciler, $(HILITE 2));
---

$(P
Sonuçlar dönüş değeri olarak elde edilmek yerine üçüncü parametre olarak verilen bir $(C RandomAccessRange) aralığına da yazılabilirler. O aralığın uzunluğu elemanların uzunluğuna eşit olmalıdır:
)

---
    double[] sonuçlar;
    sonuçlar.length = öğrenciler.length;
    taskPool.amap!ortalamaNot(öğrenciler, 2, $(HILITE sonuçlar));
---

$(H5 $(IX reduce, koşut işlem) $(C taskPool.reduce()))

$(P
$(IX reduce, std.algorithm) Koşut $(C reduce())'u anlamadan önce $(C std.algorithm) modülündeki $(C reduce())'u anlamak gerekir.
)

$(P
$(IX fold, std.algorithm) $(C std.algorithm.reduce), daha önce $(LINK2 /ders/d/araliklar.html, Aralıklar bölümünde) gördüğümüz $(C fold())'un eşdeğeridir. En belirgin farkı, işlev parametrelerinin sırasının $(C fold)'un tersi olmasıdır. (Bu yüzden, koşut olmayan işlemlerde $(C std.algorithm.reduce) yerine $(LINK2 /ders/d/ufcs.html, UFCS'e) olanak veren $(C std.algorithm.fold)'u yeğlemenizi öneririm.)
)

$(P
$(C reduce()) başka dillerde de bulunan üst düzey bir algoritmadır. $(C map())'te olduğu gibi, şablon parametresi olarak bir veya birden fazla işlev alır. İşlev parametreleri olarak da bir başlangıç değeri ve bir aralık alır. Belirtilen işlevleri o andaki sonuca ve her elemana uygular. Açıkça başlangıç değeri verilmediği zaman aralığın ilk elemanını başlangıç değeri olarak kullanır.
)

$(P
Nasıl işlediği, kendi içinde tanımlamış olduğu varsayılan $(C sonuç) isimli bir değişken üzerinden aşağıdaki gibi ifade edilebilir:
)

$(OL

$(LI $(C sonuç)'u başlangıç değeri ile ilkler.)

$(LI Her bir eleman için $(C sonuç = işlev(sonuç, eleman)) ifadesini işletir.)

$(LI $(C sonuç)'un son değerini döndürür.)

)

$(P
Örneğin bir dizinin bütün elemanlarının karelerinin toplamı aşağıdaki gibi hesaplanabilir:
)

---
import std.stdio;
import std.algorithm;

void main() {
    writeln(reduce!((a, b) => a + b * b)(0, [5, 10]));
}
---

$(P
İşlev yukarıdaki gibi dizgi olarak belirtildiğinde $(C a) belirli bir andaki sonuç değerini, $(C b) de eleman değerini temsil eder. İlk işlev parametresi başlangıç değeridir (yukarıdaki $(C 0)).
)

$(P
Program sonuçta 5 ve 10'un kareleri olan 25 ve 100'ün toplamını yazdırır:
)

$(SHELL
125
)

$(P
Tarifinden de anlaşılacağı gibi $(C reduce()) kendi içinde bir döngü işletir. O döngü tek çekirdek üzerinde işlediğinden, elemanların işlemlerinin birbirlerinden bağımsız oldukları durumlarda yavaş kalabilir. Böyle durumlarda $(C std.parallelism) modülündeki $(C taskPool.reduce()) kullanılarak işlemlerin bütün çekirdekler üzerinde işletilmeleri sağlanabilir.
)

$(P
Bunun örneğini görmek için $(C reduce())'u yine yapay olarak yavaşlatılmış olan bir işlevle kullanalım:
)

---
import std.stdio;
import std.algorithm;
import core.thread;

int birHesap(int sonuç, int eleman) {
    writefln("başladı    - eleman: %s, sonuç: %s",
             eleman, sonuç);

    Thread.sleep(1.seconds);
    sonuç += eleman;

    writefln("tamamlandı - eleman: %s, sonuç: %s",
             eleman, sonuç);

    return sonuç;
}

void main() {
    writeln("Sonuç: ", $(HILITE reduce)!birHesap(0, [1, 2, 3, 4]));
}
---

$(P
$(C reduce()) elemanları sırayla ve teker teker kullanır ve bu yüzden program 4 saniye sürer:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
başladı    - eleman: 1, sonuç: 0
tamamlandı - eleman: 1, sonuç: 1
başladı    - eleman: 2, sonuç: 1
tamamlandı - eleman: 2, sonuç: 3
başladı    - eleman: 3, sonuç: 3
tamamlandı - eleman: 3, sonuç: 6
başladı    - eleman: 4, sonuç: 6
tamamlandı - eleman: 4, sonuç: 10
Sonuç: 10

real	0m4.003s    $(SHELL_NOTE 4 saniye)
user	0m0.000s
sys	0m0.000s)
)

$(P
$(C parallel()) ve $(C map()) örneklerinde olduğu gibi, bu programa da $(C std.parallelism) modülünü eklemek ve $(C reduce()) yerine $(C taskPool.reduce())'u çağırmak bütün çekirdeklerden yararlanmak için yeterlidir:
)

---
import std.parallelism;
// ...
    writeln("Sonuç: ", $(HILITE taskPool.reduce)!birHesap(0, [1, 2, 3, 4]));
---

$(P
Ancak, $(C taskPool.reduce())'un işleyişinin önemli farklılıkları vardır.
)

$(P
Yukarıda gördüğümüz koşut algoritmalarda olduğu gibi $(C taskPool.reduce()) da elemanları birden fazla göreve paylaştırarak koşut olarak işletir. Her görev kendisine verilen elemanları kullanarak farklı bir $(C sonuç) hesaplar. Yalnızca tek başlangıç değeri olduğundan, her görevin hesapladığı $(C sonuç) o değerden başlar (yukarıdaki $(C 0)).
)

$(P
Görevlerin hesapları tamamladıkça, onların ürettikleri sonuçlar son bir kez aynı $(C sonuç) hesabından geçirilirler. Bu son hesap koşut olarak değil, tek çekirdek üzerinde işletilir. O yüzden $(C taskPool.reduce()) bu örnekte olduğu gibi az sayıda elemanla kullanıldığında daha yavaş sonuç verebilir. Bunu aşağıdaki çıktıda göreceğiz.
)

$(P
Aynı başlangıç değerinin bütün görevler tarafından kullanılıyor olması $(C taskPool.reduce())'un hesapladığı sonucun normal $(C reduce())'dan farklı çıkmasına neden olabilir. Bu sonuç aynı nedenden dolayı yanlış da olabilir. O yüzden başlangıç değeri bu örnekteki toplama işleminin başlangıç değeri olan $(C 0) gibi etkisiz bir değer olmak zorundadır.
)

$(P
Ek olarak, elemanlara uygulanan işlevin aldığı parametrelerin türü ve işlevin dönüş türü ya aynı olmalıdır ya da birbirlerine otomatik olarak dönüşebilmelidirler.
)

$(P
$(C taskPool.reduce()) ancak bu özellikleri anlaşılmışsa kullanılmalıdır.
)

---
import std.parallelism;
// ...
    writeln("Sonuç: ", $(HILITE taskPool.reduce)!birHesap(0, [1, 2, 3, 4]));
---

$(P
Çıktısında önce birden fazla görevin aynı anda, onların sonuçlarının ise sırayla işletildiklerini görüyoruz. Sırayla işletilen işlemleri işaretli olarak gösteriyorum:
)

$(SHELL
$ time ./deneme
$(DARK_GRAY
başladı    - eleman: 1, sonuç: 0 $(SHELL_NOTE önce görevler aynı anda)
başladı    - eleman: 2, sonuç: 0
başladı    - eleman: 3, sonuç: 0
başladı    - eleman: 4, sonuç: 0
tamamlandı - eleman: 1, sonuç: 1
$(HILITE başladı    - eleman: 1, sonuç: 0) $(SHELL_NOTE onların sonuçları sırayla)
tamamlandı - eleman: 2, sonuç: 2
tamamlandı - eleman: 3, sonuç: 3
tamamlandı - eleman: 4, sonuç: 4
$(HILITE tamamlandı - eleman: 1, sonuç: 1)
$(HILITE başladı    - eleman: 2, sonuç: 1)
$(HILITE tamamlandı - eleman: 2, sonuç: 3)
$(HILITE başladı    - eleman: 3, sonuç: 3)
$(HILITE tamamlandı - eleman: 3, sonuç: 6)
$(HILITE başladı    - eleman: 4, sonuç: 6)
$(HILITE tamamlandı - eleman: 4, sonuç: 10)
Sonuç: 10

real	0m5.006s    $(SHELL_NOTE bu örnekte koşut reduce daha yavaş)
user	0m0.004s
sys	0m0.000s)
)

$(P
Matematik sabiti $(I pi)'nin (π) seri yöntemiyle hesaplanması gibi başka hesaplarda koşut $(C reduce()) daha hızlı işleyecektir.
)

$(H5 Birden çok işlev ve çokuzlu sonuçlar)

$(P
Hem $(C std.algorithm) modülündeki $(C map()) hem de $(C std.parallelism) modülündeki $(C map()), $(C amap()), ve $(C reduce()) birden fazla işlev alabilirler. O durumda bütün işlevlerin sonuçları bir arada $(LINK2 /ders/d/cokuzlular.html, Çokuzlular bölümünde) gördüğümüz $(C Tuple) türünde döndürülür. Her işlevin sonucu, o işlevin sırasına karşılık gelen çokuzlu üyesidir. Örneğin, ilk işlevin sonucu çokuzlunun 0 numaralı üyesidir.
)

$(P
Aşağıdaki program birden fazla işlev kullanımını $(C std.algorithm.map) üzerinde gösteriyor. Dikkat ederseniz $(C çeyreği()) ve $(C onKatı()) işlevlerinin dönüş türleri farklıdır. Öyle bir durumda çokuzlu sonuçların üyelerinin türleri de farklı olur.
)

---
import std.stdio;
import std.algorithm;
import std.conv;

double çeyreği(double değer) {
    return değer / 4;
}

string onKatı(double değer) {
    return to!string(değer * 10);
}

void main() {
    auto sayılar = [10, 42, 100];
    auto sonuçlar = map!($(HILITE çeyreği, onKatı))(sayılar);

    writefln("  Çeyreği  On Katı");

    foreach (çeyrekSonucu, onKatSonucu; sonuçlar) {
        writefln("%8.2f%8s", çeyrekSonucu, onKatSonucu);
    }
}
---

$(P
Çıktısı:
)

$(SHELL
  Çeyreği  On Katı
    2.50     100
   10.50     420
   25.00    1000
)


$(P
$(C taskPool.reduce()) kullanımında sonuçların ilk değerlerinin de çokuzlu olarak verilmeleri gerekir:
)

---
    taskPool.reduce!(foo, bar)($(HILITE tuple(0, 1)), [1, 2, 3, 4]);
---

$(H5 $(IX TaskPool) $(C TaskPool))

$(P
$(C std.parallelism) modülünün bütün koşut algoritmalarının perde arkasında yararlandıkları görevler bir $(C TaskPool) topluluğunun parçalarıdır. Normalde, bütün algoritmalar aynı $(C taskPool) isimli topluluğu kullanırlar.
)

$(P
$(C taskPool) programın çalışmakta olduğu ortama uygun sayıda göreve sahip olduğundan çoğu durumda ondan başkaca $(C TaskPool) nesnesine gerek duyulmaz. Buna rağmen bazen özel bir görev topluluğunun açıkça oluşturulması ve bazı koşut işlemler için onun kullanılması istenebilir.
)

$(P
$(C TaskPool) kaç iş parçacığı kullanacağı bildirilerek kurulur. İş parçacığı adedinin varsayılan değeri ortamdaki çekirdek adedinin bir eksiğidir. Bu bölümde gördüğümüz bütün olanaklar açıkça kurulmuş olan bir $(C TaskPool) nesnesi üzerinden kullanılabilirler.
)

$(P
Aşağıdaki örnekte $(C parallel()) ile nasıl kullanıldığını görüyoruz:
)

---
import std.stdio;
import std.parallelism;

void $(CODE_DONT_TEST compiler_asm_deprecation_warning)main() {
    auto işçiler = new $(HILITE TaskPool(2));

    foreach (i; $(HILITE işçiler).parallel([1, 2, 3, 4])) {
        writefln("%s kullanılıyor", i);
    }

    $(HILITE işçiler).finish();
}
---

$(P
Görevler tamamlandığında $(C TaskPool) nesnesinin iş parçacıklarının sonlandırılmaları için $(C TaskPool.finish()) çağrılır.
)

$(H5 Özet)

$(UL

$(LI Birbirlerine bağlı işlemlerin koşut olarak işletilmeleri hatalıdır.)

$(LI $(C parallel()), Bir aralığın elemanlarına koşut olarak erişilmesini sağlar.)

$(LI Gerektiğinde görevler $(C task()) ile oluşturulabilirler, $(C executeInNewThread()) ile başlatılabilirler ve $(C yieldForce()) ile beklenebilirler.)

$(LI Hata atılarak sonlanmış olan görevlerden atılan hatalar $(C yieldForce()) gibi işlevler çağrıldığında yakalanabilirler.)

$(LI $(C asyncBuf()), $(C InputRange) aralığındaki elemanları yarı hevesli olarak aynı anda ilerletir.)

$(LI $(C map()), işlevleri $(C InputRange) aralığındaki elemanlara yarı hevesli olarak aynı anda uygular.)

$(LI $(C amap()), işlevleri $(C RandomAccessRange) aralığındaki elemanlara tam hevesli olarak aynı anda uygular.)

$(LI $(C reduce()), hesapları $(C RandomAccessRange) aralığındaki elemanlar için aynı anda işletir.)

$(LI $(C map()), $(C amap()), ve $(C reduce()) birden fazla işlev alabilirler; öyle olduğunda sonuçlar çokuzlu üyeleridirler.)

$(LI İstendiğinde $(C taskPool)'dan başka $(C TaskPool) nesneleri de kullanılabilir.)

)

macros:
        SUBTITLE=Koşut İşlemler

        DESCRIPTION=Mikro işlemci çekirdeklerinin hepsinden birden yararlanmayı sağlayan koşut programlama (parallel programming)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial koşut işlemler paralel parallel parallelism parallelization

SOZLER=
$(eniyilestirme)
$(es_zamanli)
$(fonksiyonel_programlama)
$(gorev)
$(hevesli)
$(is_parcacigi)
$(kapsam)
$(kosut_islemler)
$(mikro_islemci)
$(mikro_islemci_cekirdegi)
$(tembel_degerlendirme)
$(uc_birim)
