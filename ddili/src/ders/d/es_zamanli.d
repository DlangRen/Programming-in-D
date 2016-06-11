Ddoc

$(DERS_BOLUMU $(IX eş zamanlı programlama, mesajlaşarak) $(IX mesajlaşarak eş zamanlı programlama) Mesajlaşarak Eş Zamanlı Programlama)

$(P
Eş zamanlı programlama bir önceki bölümde gördüğümüz koşut işlemlere çok benzer. İkisi de işlemlerin farklı iş parçacıkları üzerinde aynı anda işletilmeleri ile ilgilidir ve aslında koşut işlemler de perde arkasında eş zamanlı programlama ile gerçekleştirilir. Bu iki kavram bu yüzden çok karıştırılır.
)

$(P
$(IX koşut işlemler ve eş zamanlı programlama) $(IX eş zamanlı programlama ve koşut işlemler) Koşut işlemlerle eş zamanlı programlama arasındaki farklar şunlardır:
)

$(UL

$(LI Koşut işlemlerin temel amacı mikro işlemci çekirdeklerinden yararlanarak programın hızını arttırmaktır. Eş zamanlı programlama ise yalnızca tek çekirdeği bulunan ortamlarda bile gerekebilir ve programın aynı anda birden fazla iş yürütmesini sağlar. Örneğin bir sunucu program her istemcinin işini farklı bir iş parçacığında yürütebilir.)

$(LI Koşut işlemler birbirlerinden bağımsızdırlar. Hatta, birbirlerine bağlı olan işlemlerin koşut olarak işletilmeleri hata olarak kabul edilir. Eş zamanlı programlamada ise çoğu zaman iş parçacıkları birbirlerine bağlıdırlar. Örneğin, devam edebilmek için başka iş parçacıklarının ürettikleri verilere gerek duyarlar.)

$(LI Her iki yöntem de işletim sisteminin iş parçacıklarını kullanırlar. Koşut işlemler iş parçacıklarını $(I görev) kavramının arkasına gizlerler; eş zamanlı programlama ise doğrudan iş parçacıklarını kullanır.)

$(LI Koşut işlemler çok kolay kullanılırlar ve görevler bağımsız oldukları sürece program doğruluğu açısından güvenlidirler. Eş zamanlı programlama ise ancak mesajlaşma yöntemi kullanıldığında güvenlidir. Veri paylaşımına dayanan geleneksel eş zamanlı programlamada programın doğru çalışacağı kanıtlanamayabilir.)

)

$(P
D hem mesajlaşmaya dayanan hem de veri paylaşımına dayanan eş zamanlı programlamayı destekler. Veri paylaşımı ile hatasız programlar üretmek çok zor olduğundan modern programcılıkta mesajlaşma yöntemi benimsenmiştir. Bu bölümde $(C std.concurrency) modülünün sağladığı mesajlaşma olanaklarını, bir sonraki bölümde ise veri paylaşımına dayalı eş zamanlı programlama olanaklarını göreceğiz.
)

$(H5 Kavramlar)

$(P$(IX iş parçacığı) $(B İş parçacığı $(ASIL thread)): İşletim sistemi bütün programları $(I iş parçacığı) adı verilen işlem birimleri ile işletir. Çalıştırılan her D programının $(C main()) ile başlayan işlemleri işletim sisteminin o programı çalıştırmak için seçmiş olduğu bir iş parçacığı üzerinde başlatılır. $(C main())'in işlettiği bütün işlemler normalde hep aynı iş parçacığı üzerinde işletilirler. Program, gerektiğinde kendisi başka iş parçacıkları başlatabilir ve böylece aynı anda birden fazla iş yürütebilir. Örneğin bir önceki bölümde gördüğümüz her görev, $(C std.parallelism)'in olanakları tarafından başlatılmış olan bir iş parçacığını kullanır.

)

$(P
İşletim sistemi iş parçacıklarını önceden kestirilemeyecek anlarda duraksatır ve tekrar başlatır. Bunun sonucunda örneğin aşağıdaki kadar basit işlemler bile bir süre yarım kalmış olabilirler:
)

---
    ++i;
---

$(P
Yukarıdaki işlem aslında üç adımdan oluşur: Değişkenin değerinin okunması, değerin arttırılması ve tekrar değişkene atanması. İşletim sisteminin bu iş parçacığını duraksattığı bir anda bu adımlar sonradan devam edilmek üzere yarım kalmış olabilirler.
)

$(P $(IX mesaj) $(B Mesaj $(ASIL message)): İş parçacıklarının işleyişleri sırasında birbirlerine gönderdikleri bilgilere mesaj denir. Mesaj her türden ve her sayıda değişkenden oluşabilir.
)

$(P $(IX kimlik) $(B İş parçacığı kimliği $(ASIL Tid)): Her iş parçacığının bir kimliği vardır. Kimlik, gönderilen mesajın alıcısı olan iş parçacığını belirler.
)

$(P $(IX sahip) $(B Sahip $(ASIL owner)): İş parçacığı başlatan her iş parçacığı, başlatılan iş parçacığının sahibi olarak anılır.
)

$(P $(IX işçi) $(B İşçi $(ASIL worker)): Başlatılan iş parçacığına işçi denir.
)

$(H5 $(IX spawn) İş parçacıklarını başlatmak)

$(P
Yeni bir iş parçacığı başlatmak için $(C spawn()) kullanılır. $(C spawn()) parametre olarak bir işlev alır ve yeni iş parçacığını o işlevden başlatır. O işlevin belki de başka işlevlere de dallanarak devam eden işlemleri artık yeni iş parçacığı üzerinde işletilir. $(C spawn()) ile $(LINK2 /ders/d/kosut_islemler.html, $(C task())) arasındaki bir fark, $(C spawn()) ile başlatılan iş parçacıklarının birbirlerine mesaj gönderebilmeleridir.
)

$(P
İşçinin başlatılmasından sonra sahip ve işçi birbirlerinden bağımsız iki alt program gibi işlemeye devam ederler:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void işçi() {
    foreach (i; 0 .. 5) {
        Thread.sleep(500.msecs);
        writeln(i, " (işçi)");
    }
}

void main() {
    $(HILITE spawn(&işçi));

    foreach (i; 0 .. 5) {
        Thread.sleep(300.msecs);
        writeln(i, " (main)");
    }

    writeln("main tamam");
}
---

$(P
İşlemlerin aynı anda işletildiklerini gösterebilmek için buradaki örneklerde de $(C Thread.sleep)'ten yararlanıyorum. Programın çıktısı $(C main())'den ve $(C işçi())'den başlamış olan iki iş parçacığının diğerinden bağımsız olarak işlediğini gösteriyor:
)

$(SHELL
0 (main)
0 (işçi)
1 (main)
2 (main)
1 (işçi)
3 (main)
2 (işçi)
4 (main)
main tamam
3 (işçi)
4 (işçi)
)

$(P
Program bütün iş parçacıklarının tamamlanmasını otomatik olarak bekler. Bunu yukarıdaki çıktıda görüyoruz: $(C main())'in sonundaki "main tamam" yazdırıldığı halde $(C işçi()) işlevinin de tamamlanması beklenmiştir.
)

$(P
İş parçacığını başlatan işlevin aldığı parametreler $(C spawn())'a işlev isminden sonra verilirler. Aşağıdaki programdaki iki işçi, çıkışa dörder tane sayı yazdırıyor. Hangi değerden başlayacağını parametre olarak alıyor:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void işçi($(HILITE int başlangıçDeğeri)) {
    foreach (i; 0 .. 4) {
        Thread.sleep(500.msecs);
        writeln(başlangıçDeğeri + i);
    }
}

void main() {
    foreach (i; 1 .. 3) {
        spawn(&işçi, $(HILITE i * 10));
    }
}
---

$(P
İş parçacıklarından birisinin yazdırdıklarını işaretli olarak belirtiyorum. İşletim sisteminin iş parçacıklarını başlatmasına ve duraklatmasına bağlı olarak bu çıktıdaki satırlar farklı sırada da olabilirler:
)

$(SHELL
10
$(HILITE 20)
11
$(HILITE 21)
12
$(HILITE 22)
13
$(HILITE 23)
)

$(P
$(IX iş parçacığı performansı) $(IX mikro işlemciye bağlı) $(IX giriş/çıkış'a bağlı) İşletim sistemleri belirli bir anda işlemekte olan iş parçacıklarının sayısı konusunda kısıtlama getirir. Bu kısıtlamalar kullanıcı başına olabileceği gibi, bütün sistem başına veya herhangi başka bir kavramla ilgili olabilir. Mikro işlemciyi meşgul ederek işleyen iş parçacıklarının sayısı sistemdeki çekirdek sayısından fazla olduğunda bütün sistemin performansı düşebilir. Belirli bir anda mikro işlemciyi meşgul ederek işlemekte olan iş parçacıklarına $(I mikro işlemciye bağlı) denir. Öte yandan, bazı iş parçacıkları zamanlarının çoğunu iş yaparak değil, belirli bir olayın gerçekleşmesini bekleyerek geçirirler. Örneğin, kullanıcıdan veya ağ üzerinden bilgi gelmesinin veya bir $(C Thread.sleep) çağrısının sonlanmasının beklenmesi sırasında mikro işlemci meşgul değildir. Böyle durumdaki iş parçacıklarına $(I giriş/çıkış'a bağlı) denir. İş parçacıklarının çoğunluğunun giriş/çıkış'a bağlı olarak işlediği bir programın sistemdeki çekirdek sayısından daha fazla iş parçacığı başlatmasında bir sakınca yoktur. Program hızıyla ilgili her tasarım kararında olması gerektiği gibi, bu konudaki kararlarınızı da ölçümler yaparak vermenizi öneririm.
)

$(H5 $(IX Tid) $(IX thisTid) $(IX ownerTid) İş parçacıklarının kimlikleri)

$(P
$(C thisTid()) iş parçacığının kendi kimliğini döndürür. İsmi "bu iş parçacığının kimliği" anlamına gelen "this thread's identifier"dan türemiştir. Bir işlev olmasına rağmen daha çok parantezsiz kullanılır:
)

---
import std.stdio;
import std.concurrency;

void kimlikBilgisi(string açıklama) {
    writefln("%s: %s", açıklama, $(HILITE thisTid));
}

void işçi() {
    kimlikBilgisi("işçi ");
}

void main() {
    spawn(&işçi);
    kimlikBilgisi("sahip");
}
---

$(P
$(C Tid) türündeki kimliğin değerinin program açısından bir önemi olmadığından bu türün $(C toString) işlevi bile tanımlanmamıştır. Bu yüzden programın aşağıdaki çıktısında yalnızca türün ismini görüyoruz:
)

$(SHELL
sahip: Tid(std.concurrency.MessageBox)
işçi : Tid(std.concurrency.MessageBox)
)

$(P
Çıktıları aynı olsa da sahip ve işçinin kimlikleri farklıdır.
)

$(P
$(C spawn())'ın bu noktaya kadar gözardı etmiş olduğum dönüş değeri de işçinin kimliğini sahibe bildirir:
)

---
    $(HILITE Tid işçim) = spawn(&işçi);
---

$(P
Her işçinin sahibinin kimliği ise $(C ownerTid()) işlevi ile elde edilir.
)

$(P
Özetle, sahibin kimliği $(C ownerTid) değişkeni ile, işçinin kimliği de $(C spawn)'ın dönüş değeri ile elde edilmiş olur.
)

$(H5 $(IX send) $(IX receiveOnly) Mesajlaşma)

$(P
Mesaj göndermek için $(C send()), belirli türden mesaj beklemek için de $(C receiveOnly()) kullanılır. (Çeşitli türlerden mesaj bekleyen $(C receive())'i ve belirli süreye kadar bekleyen $(C receiveTimeout())'u daha aşağıda göstereceğim.)
)

$(P
Aşağıdaki programdaki sahip iş parçacığı işçisine $(C int) türünde bir mesaj göndermekte ve ondan $(C double) türünde bir mesaj beklemektedir. Bu iş parçacıkları sahip sıfırdan küçük bir değer gönderene kadar mesajlaşmaya devam edecekler. Önce sahip iş parçacığını gösteriyorum:
)

---
void $(CODE_DONT_TEST)main() {
    Tid işçi = spawn(&işçiİşlevi);

    foreach (değer; 1 .. 5) {
        $(HILITE işçi.send)(değer);
        double sonuç = $(HILITE receiveOnly!double)();
        writefln("gönderilen: %s, alınan: %s", değer, sonuç);
    }

    /* Sonlanmasını sağlamak için işçiye sıfırdan küçük bir
     * değer gönderiyoruz */
    $(HILITE işçi.send)(-1);
}
---

$(P
$(C main()), $(C spawn())'ın döndürdüğü iş parçacığının kimliğini $(C işçi) ismiyle saklamakta ve bu kimliği $(C send()) ile mesaj gönderirken kullanmaktadır.
)

$(P
İşçi ise kullanacağı $(C int)'i bir mesaj olarak alıyor, onu bir hesapta kullanıyor ve ürettiği $(C double)'ı yine bir mesaj olarak sahibine gönderiyor:
)

---
void işçiİşlevi() {
    int değer = 0;

    while (değer >= 0) {
        değer = $(HILITE receiveOnly!int)();
        double sonuç = cast(double)değer / 5;
        $(HILITE ownerTid.send)(sonuç);
    }
}
---

$(P
Yukarıdaki iş parçacığı mesajdaki değerin beşte birini hesaplar. Programın çıktısı şöyle:
)

$(SHELL
gönderilen: 1, alınan: 0.2
gönderilen: 2, alınan: 0.4
gönderilen: 3, alınan: 0.6
gönderilen: 4, alınan: 0.8
)

$(P
Birden fazla değer aynı mesajın parçası olarak gönderilebilir:
)

---
    ownerTid.send($(HILITE thisTid, 42, 1.5));
---

$(P
Aynı mesajın parçası olarak gönderilen değerler alıcı tarafta bir çokuzlunun üyeleri olarak belirirler. $(C receiveOnly())'nin şablon parametrelerinin mesajı oluşturan türlere uymaları şarttır:
)

---
    /* Tid, int, ve double türlerinden oluşan bir mesaj
     * bekliyoruz */
    auto mesaj = receiveOnly!($(HILITE Tid, int, double))();

    /* Mesaj bir çokuzlu olarak alınır */
    auto gönderen = mesaj$(HILITE [0]);    // Tid türünde
    auto tamsayı =  mesaj$(HILITE [1]);    // int türünde
    auto kesirli =  mesaj$(HILITE [2]);    // double türünde
---

$(P
$(IX MessageMismatch) Türler uymadığında "mesaj uyumsuzluğu" anlamına gelen $(C MessageMismatch) hatası atılır:
)

---
import std.concurrency;

void işçiİşlevi() {
    ownerTid.send("merhaba");    $(CODE_NOTE $(HILITE string) gönderiyor)
}

void main() {
    spawn(&işçiİşlevi);

    auto mesaj = receiveOnly!double();    $(CODE_NOTE $(HILITE double) bekliyor)
}
---

$(P
Çıktısı:
)

$(SHELL
std.concurrency.$(HILITE MessageMismatch)@std/concurrency.d(202):
Unexpected message type: expected 'double', got 'immutable(char)[]'
)

$(H6 Örnek)

$(P
Şimdiye kadar gördüğümüz kavramları kullanan basit bir benzetim programı tasarlayalım.
)

$(P
Bu örnek iki boyutlu düzlemdeki robotların birbirlerinden bağımsız ve rasgele hareketlerini belirliyor. Her robotu farklı bir iş parçacığı yönetiyor. Her iş parçacığı başlatılırken üç bilgi alıyor:
)

$(UL

$(LI Robotun numarası: Gönderilen mesajın hangi robotla ilgili olduğu
)

$(LI Başlangıç noktası: Robotun hareketinin başlangıç noktası
)

$(LI Robotun dinlenme süresi: Robotun ne kadar zamanda bir yer değiştireceği
)

)

$(P
Yukarıdaki üç bilgiyi bir arada tutan bir $(C İş) yapısı şöyle tanımlanabilir:
)

---
struct İş {
    size_t robotNumarası;
    Yer başlangıç;
    Duration dinlenmeSüresi;
}
---

$(P
Bu iş parçacığının yaptığı tek iş, robotun numarasını ve hareketini bir sonsuz döngü içinde sahibine göndermek:
)

---
void gezdirici(İş iş) {
    Yer nereden = iş.başlangıç;

    while (true) {
        Thread.sleep(iş.dinlenmeSüresi);

        Yer nereye = rasgeleKomşu(nereden);
        Hareket hareket = Hareket(nereden, nereye);
        nereden = nereye;

        ownerTid.send($(HILITE HareketMesajı)(iş.robotNumarası, hareket));
    }
}
---

$(P
Sahip de sonsuz bir döngü içinde bu mesajları bekliyor. Aldığı mesajların hangi robotla ilgili olduğunu her mesajın parçası olan robot numarasından anlıyor:
)

---
    while (true) {
        auto mesaj = receiveOnly!$(HILITE HareketMesajı)();

        writefln("%s %s",
                 robotlar[mesaj.robotNumarası],
                 mesaj.hareket);
    }
---

$(P
Bu örnekteki bütün mesajlar işçilerden sahibe gönderiliyor. Daha karmaşık programlarda her iki yönde ve çok çeşitli türlerden mesajlar da gönderilebilir. Programın tamamı şöyle:
)

---
import std.stdio;
import std.random;
import std.string;
import std.concurrency;
import core.thread;

struct Yer {
    int satır;
    int sütun;

    string toString() {
        return format("%s,%s", satır, sütun);
    }
}

struct Hareket {
    Yer nereden;
    Yer nereye;

    string toString() {
        return ((nereden == nereye)
                ? format("%s (durgun)", nereden)
                : format("%s -> %s", nereden, nereye));
    }
}

class Robot {
    string görünüm;
    Duration dinlenmeSüresi;

    this(string görünüm, Duration dinlenmeSüresi) {
        this.görünüm = görünüm;
        this.dinlenmeSüresi = dinlenmeSüresi;
    }

    override string toString() {
        return format("%s(%s)", görünüm, dinlenmeSüresi);
    }
}

/* 0,0 noktası etrafında rasgele bir yer döndürür */
Yer rasgeleYer() {
    return Yer(uniform!"[]"(-10, 10), uniform!"[]"(-10, 10));
}

/* Verilen değerin en fazla bir adım ötesinde bir değer
 * döndürür */
int rasgeleAdım(int şimdiki) {
    return şimdiki + uniform!"[]"(-1, 1);
}

/* Verilen Yer'in komşusu olan bir Yer döndürür; çapraz
 * komşusu olabileceği gibi tesadüfen aynı yer de olabilir. */
Yer rasgeleKomşu(Yer yer) {
    return Yer(rasgeleAdım(yer.satır),
               rasgeleAdım(yer.sütun));
}

struct İş {
    size_t robotNumarası;
    Yer başlangıç;
    Duration dinlenmeSüresi;
}

struct HareketMesajı {
    size_t robotNumarası;
    Hareket hareket;
}

void gezdirici(İş iş) {
    Yer nereden = iş.başlangıç;

    while (true) {
        Thread.sleep(iş.dinlenmeSüresi);

        Yer nereye = rasgeleKomşu(nereden);
        Hareket hareket = Hareket(nereden, nereye);
        nereden = nereye;

        ownerTid.send(HareketMesajı(iş.robotNumarası, hareket));
    }
}

void main() {
    /* Farklı hızlardaki robotlar */
    Robot[] robotlar = [ new Robot("A",  600.msecs),
                         new Robot("B", 2000.msecs),
                         new Robot("C", 5000.msecs) ];

    /* Her birisi için bir iş parçacığı başlatılıyor */
    foreach (robotNumarası, robot; robotlar) {
        spawn(&gezdirici, İş(robotNumarası,
                             rasgeleYer(),
                             robot.dinlenmeSüresi));
    }

    /* Artık hareket bilgilerini işçilerden toplamaya
     * başlayabiliriz */
    while (true) {
        auto mesaj = receiveOnly!HareketMesajı();

        /* Bu robotla ilgili yeni bilgiyi çıkışa
         * yazdırıyoruz */
        writefln("%s %s",
                 robotlar[mesaj.robotNumarası],
                 mesaj.hareket);
    }
}
---

$(P
Program sonlandırılana kadar robotların konumlarını çıkışa yazdırır:
)

$(SHELL
A(600 ms) -3,3 -> -4,4
A(600 ms) -4,4 -> -4,3
A(600 ms) -4,3 -> -3,2
B(2 secs) -6,9 (durgun)
A(600 ms) -3,2 -> -2,2
A(600 ms) -2,2 -> -3,1
A(600 ms) -3,1 -> -2,0
B(2 secs) -6,9 -> -5,9
A(600 ms) -2,0 (durgun)
A(600 ms) -2,0 -> -3,-1
C(5 secs) -6,6 -> -6,7
A(600 ms) -3,-1 -> -4,-1
...
)

$(P
Mesajlaşmaya dayanan eş zamanlı programlamanın yararını bu örnekte görebiliyoruz. Her robotun hareketi aynı anda ve diğerlerinden bağımsız olarak hesaplanıyor. Bu basit örnekteki sahip yalnızca robotların hareketlerini çıkışa yazdırıyor; bütün robotları ilgilendiren başka işlemler de uygulanabilir.
)

$(H5 $(IX temsilci, mesajlaşma) Farklı çeşitlerden mesaj beklemek)

$(P
$(C receiveOnly()) yalnızca belirtilen türden mesaj bekleyebilir. $(C receive()) ise farklı çeşitlerden mesajlar beklemek için kullanılır. Parametre olarak belirsiz sayıda $(I mesajcı işlev) alır. Gelen mesaj bu mesajcı işlevlere sırayla uydurulmaya çalışılır ve mesaj, mesajın türünün uyduğu ilk işleve gönderilir.
)

$(P
Örneğin aşağıdaki $(C receive()) çağrısı ilki $(C int), ikincisi de $(C string) bekleyen iki mesajcı işlev kullanmaktadır:
)

---
$(CODE_NAME işçiİşlevi)void işçiİşlevi() {
    bool tamam_mı = false;

    while (!tamam_mı) {
        void intİşleyen($(HILITE int) mesaj) {
            writeln("int mesaj: ", mesaj);

            if (mesaj == -1) {
                writeln("çıkıyorum");
                tamam_mı = true;
            }
        }

        void stringİşleyen($(HILITE string) mesaj) {
            writeln("string mesaj: ", mesaj);
        }

        receive($(HILITE &intİşleyen), $(HILITE &stringİşleyen));
    }
}
---

$(P
Gönderilen $(C int) mesajlar $(C intİşleyen())'e, $(C string) mesajlar da $(C stringİşleyen())'e uyarlar. O iş parçacığını şöyle bir kodla deneyebiliriz:
)

---
$(CODE_XREF işçiİşlevi)import std.stdio;
import std.concurrency;

// ...

void main() {
    auto işçi = spawn(&işçiİşlevi);

    işçi.send(10);
    işçi.send(42);
    işçi.send("merhaba");
    işçi.send(-1);        // ← işçinin sonlanması için
}
---

$(P
Mesajlar alıcı taraftaki uygun mesajcı işlevlere gönderilirler:
)

$(SHELL
int mesaj: 10
int mesaj: 42
string mesaj: merhaba
int mesaj: -1
çıkıyorum
)

$(P
$(C receive()), yukarıdaki normal işlevler yerine isimsiz işlevler veya $(C opCall()) üye işlevi tanımlanmış olan türlerin nesnelerini de kullanabilir. Bunun bir örneğini görmek için programı isimsiz işlevler kullanacak şekilde değiştirelim. Ek olarak, işçinin sonlanmasını da -1 gibi özel bir değer yerine ismi açıkça $(C Sonlan) olan özel bir türle bildirelim.
)

$(P
Aşağıda $(C receive())'e parametre olarak üç isimsiz işlev gönderildiğine dikkat edin. Bu işlevlerin açma ve kapama parantezlerini sarı ile belirtiyorum:
)

---
import std.stdio;
import std.concurrency;

struct Sonlan {
}

void işçiİşlevi() {
    bool devam_mı = true;

    while (devam_mı) {
        receive(
            (int mesaj) $(HILITE {)
                writeln("int mesaj: ", mesaj);
            $(HILITE }),

            (string mesaj) $(HILITE {)
                writeln("string mesaj: ", mesaj);
            $(HILITE }),

            (Sonlan mesaj) $(HILITE {)
                writeln("çıkıyorum");
                devam_mı = false;
            $(HILITE }));
    }
}

void main() {
    auto işçi = spawn(&işçiİşlevi);

    işçi.send(10);
    işçi.send(42);
    işçi.send("merhaba");
    işçi.send($(HILITE Sonlan()));
}
---

$(H6 Beklenmeyen mesaj almak)

$(P
$(IX Variant, std.variant) $(C std.variant) modülünde tanımlanmış olan $(C Variant) her türden veriyi sarmalayabilen bir türdür. $(C receive())'e verilen diğer mesajcı işlevlere uymayan mesajlar $(C Variant) türünü bekleyen bir mesajcı tarafından yakalanabilirler:
)

---
import std.stdio;
import std.concurrency;

void işçiİşlev() {
    receive(
        (int mesaj) { /* ... */ },

        (double mesaj) { /* ... */ },

        ($(HILITE Variant) mesaj) {
            writeln("Beklemediğim bir mesaj aldım: ", mesaj);
        });
}

struct ÖzelMesaj {
    // ...
}

void main() {
    auto işçi = spawn(&işçiİşlev);
    işçi.send(ÖzelMesaj());
}
---

$(P
Çıktısı:
)

$(SHELL
Beklemediğim bir mesaj aldım: ÖzelMesaj()
)

$(P
Bu bölümün konusu dışında kaldığı için $(C Variant)'ın ayrıntılarına girmeyeceğim.
)

$(H5 $(IX receiveTimeout) Mesajları belirli süreye kadar beklemek)

$(P
Mesajların belirli bir süreden daha fazla beklenmesi istenmeyebilir. Gönderen iş parçacığı geçici olarak meşgul olmuş olabilir veya bir hata ile sonlanmış olabilir. Mesaj bekleyen iş parçacığının belki de hiç gelmeyecek olan bir mesajı sonsuza kadar beklemesini önlemek için $(C receiveTimeout()) çağrılır.
)

$(P
$(C receiveTimeout())'un ilk parametresi mesajın en fazla ne kadar bekleneceğini bildirir. Dönüş değeri de mesajın o süre içinde gelip gelmediğini belirtir: Mesaj alındığında $(C true), alınmadığında ise $(C false) değeridir.
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void işçi() {
    Thread.sleep(3.seconds);
    ownerTid.send("merhaba");
}

void main() {
    spawn(&işçi);

    writeln("mesaj bekliyorum");
    bool alındı = false;
    while (!alındı) {
        alındı = $(HILITE receiveTimeout)(600.msecs,
                                (string mesaj) {
                                    writeln("geldi: ", mesaj);
                                });

        if (!alındı) {
            writeln("... henüz yok");

            /* ... burada başka işlere devam edilebilir ... */
        }
    }
}
---

$(P
Yukarıdaki sahip, gereken mesajı en fazla 600 milisaniye bekliyor. Mesaj o süre içinde gelmezse başka işlerine devam edebilir:
)

$(SHELL
mesaj bekliyorum
... henüz yok
... henüz yok
... henüz yok
... henüz yok
geldi: merhaba
)

$(P
Mesajın belirli süreden uzun sürmesi sonucunda çeşitli durumlarda başka kararlar da verilebilir. Örneğin, mesaj geç geldiğinde artık bir anlamı yoktur.
)

$(H5 $(IX hata atma, eş zamanlı programlama) İşçide atılan hatalar)

$(P
Hatırlayacağınız gibi, $(C std.parallelism) modülünün çoğu olanağı görevler sırasında atılan hataları yakalar ve görevle ilgili bir sonraki işlem sırasında tekrar atmak üzere saklar. Böylece örneğin bir görevin işlemesi sırasında atılmış olan hata daha sonra $(C yieldForce()) çağrıldığında görevi başlatan tarafta yakalanabilir:
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
$(C std.concurrency) genel hata türleri konusunda kolaylık sağlamaz. Atılan olası bir hatanın sahip iş parçacığına iletilebilmesi için açıkça yakalanması ve bir mesaj halinde gönderilmesi gerekir. Bir kolaylık olarak, biraz aşağıda göreceğimiz gibi, $(C OwnerTerminated) ve $(C LinkTerminated) hataları mesaj olarak da alınabilirler.
)

$(P
Aşağıdaki $(C hesapçı()) işlevi $(C string) türünde mesajlar alıyor; onları $(C double) türüne çeviriyor, 0.5 değerini ekliyor ve sonucu bir mesaj olarak gönderiyor:
)

---
$(CODE_NAME hesapçı)void hesapçı() {
    while (true) {
        auto mesaj = receiveOnly!string();
        ownerTid.send(to!double(mesaj) + 0.5);
    }
}
---

$(P
Yukarıdaki $(C to!double()), "merhaba" gibi $(C double)'a dönüştürülemeyen bir dizgi ile çağrıldığında hata atar. Atılan o hata $(C hesapçı())'dan hemen çıkılmasına neden olacağından aşağıdaki üç mesajdan yalnızca birincisinin yanıtı alınabilir:
)

---
$(CODE_XREF hesapçı)import std.stdio;
import std.concurrency;
import std.conv;

// ...

void main() {
    Tid hesapçı = spawn(&hesapçı);

    hesapçı.send("1.2");
    hesapçı.send("merhaba");  // ← hatalı veri
    hesapçı.send("3.4");

    foreach (i; 0 .. 3) {
        auto mesaj = receiveOnly!double();
        writefln("sonuç %s: %s", i, mesaj);
    }
}
---

$(P
Bu yüzden, sahip "1.2"nin sonucunu 1.7 olarak alır ama işçi sonlanmış olduğundan bir sonraki mesajı alamaz:
)

$(SHELL
sonuç 0: 1.7
                 $(SHELL_NOTE hiç gelmeyecek olan mesajı bekleyerek takılır)
)

$(P
Hesapçı iş parçacığının bu konuda yapabileceği bir şey, kendi işlemleri sırasında atılabilecek olan hatayı $(C try-catch) ile yakalamak ve özel bir mesaj olarak iletmektir. Programı hatanın nedenini bir $(C HesapHatası) nesnesi olarak gönderecek şekilde aşağıda değiştiriyoruz. Ek olarak, iş parçacığının sonlanması da özel $(C Sonlan) türü ile sağlanıyor:
)

---
import std.stdio;
import std.concurrency;
import std.conv;

struct HesapHatası {
    string neden;
}

struct Sonlan {
}

void hesapçı() {
    bool devam_mı = true;

    while (devam_mı) {
        receive(
            (string mesaj) {
                try {
                    ownerTid.send(to!double(mesaj) + 0.5);

                } $(HILITE catch) (Exception hata) {
                    ownerTid.send(HesapHatası(hata.msg));
                }
            },

            (Sonlan mesaj) {
                devam_mı = false;
            });
    }
}

void main() {
    Tid hesapçı = spawn(&hesapçı);

    hesapçı.send("1.2");
    hesapçı.send("merhaba");  // ← hatalı veri
    hesapçı.send("3.4");
    hesapçı.send(Sonlan());

    foreach (i; 0 .. 3) {
        writef("sonuç %s: ", i);

        receive(
            (double mesaj) {
                writeln(mesaj);
            },

            (HesapHatası hata) {
                writefln("HATA! '%s'", hata.neden);
            });
    }
}
---

$(P
Hatanın nedeninin "rakam bulunamadı" anlamına gelen "no digits seen" olduğunu bu sefer görebiliyoruz:
)

$(SHELL
sonuç 0: 1.7
sonuç 1: HATA! 'no digits seen'
sonuç 2: 3.9
)

$(P
Bu konuda diğer bir yöntem, işçinin yakaladığı hatanın olduğu gibi sahibe gönderilmesidir. Aynı hata sahip tarafından kullanılabileceği gibi tekrar atılabilir de:
)

---
// ... işçi tarafta ...
                try {
                    // ...

                } catch ($(HILITE shared(Exception)) hata) {
                    ownerTid.send(hata);
                }},

// ... sahip tarafta ...
        receive(
            // ...

            ($(HILITE shared(Exception)) hata) {
                throw hata;
            });
---

$(P
Yukarıdaki $(C shared) belirteçlerine neden gerek olduğunu bir sonraki bölümde göreceğiz.
)

$(H5 İş parçacıklarının sonlandıklarını algılamak)

$(P
İş parçacıkları alıcı tarafın herhangi bir nedenle sonlanmış olduğunu algılayabilirler.
)

$(H6 $(IX OwnerTerminated) $(C OwnerTerminated) hatası)

$(P
"Sahip sonlandı" anlamına gelen bu hata işçinin bu durumdan haberinin olmasını sağlar. Aşağıdaki programdaki aracı iş parçası iki mesaj gönderdikten sonra sonlanıyor. Bunun sonucunda işçi tarafta bir $(C OwnerTerminated) hatası atılıyor:
)

---
import std.stdio;
import std.concurrency;

void main() {
    spawn(&aracıİşlev);
}

void aracıİşlev() {
    auto işçi = spawn(&işçiİşlev);
    işçi.send(1);
    işçi.send(2);
}  // ← İki mesajdan sonra sonlanıyor.

void işçiİşlev() {
    while (true) {
        auto mesaj = receiveOnly!int(); // ← Sahip sonlanmışsa
                                        //   hata atılır.
        writeln("Mesaj: ", mesaj);
    }
}
---

$(P
Çıktısı:
)

$(SHELL
Mesaj: 1
Mesaj: 2
std.concurrency.$(HILITE OwnerTerminated)@std/concurrency.d(248):
Owner terminated
)

$(P
İstendiğinde o hata işçi tarafından yakalanabilir ve böylece işçinin de hatasız olarak sonlanması sağlanabilir:
)

---
void işçiİşlev() {
    bool devam_mı = true;

    while (devam_mı) {
        try {
            auto mesaj = receiveOnly!int();
            writeln("Mesaj: ", mesaj);

        } catch ($(HILITE OwnerTerminated) hata) {
            writeln("Sahibim sonlanmış.");
            devam_mı = false;
        }
    }
}
---

$(P
Çıktısı:
)

$(SHELL
Mesaj: 1
Mesaj: 2
Sahibim sonlanmış.
)

$(P
Bu hatanın mesaj olarak da alınabileceğini biraz aşağıda göreceğiz.
)

$(H6 $(IX LinkTerminated) $(IX spawnLinked) $(C LinkTerminated) hatası)

$(P
$(C spawnLinked()) ile başlatılmış olan bir iş parçacığı sonlandığında sahibin tarafında $(C LinkTerminated) hatası atılır. $(C spawnLinked()), $(C spawn()) ile aynı biçimde kullanılır:
)

---
import std.stdio;
import std.concurrency;

void main() {
    auto işçi = $(HILITE spawnLinked)(&işçiİşlev);

    while (true) {
        auto mesaj = receiveOnly!int(); // ← İşçi sonlanmışsa
                                        //   hata atılır.
        writeln("Mesaj: ", mesaj);
    }
}

void işçiİşlev() {
    ownerTid.send(10);
    ownerTid.send(20);
}  // ← İki mesajdan sonra sonlanıyor.
---

$(P
İşçi yalnızca iki mesaj gönderdikten sonra sonlanıyor. İşçisini $(C spawnLinked()) ile başlatmış olduğu için sahip bu durumu bir $(C LinkTerminated) hatası ile öğrenir:
)

$(SHELL
Mesaj: 10
Mesaj: 20
std.concurrency.$(HILITE LinkTerminated)@std/concurrency.d(263):
Link terminated
)

$(P
$(C OwnerTerminated) hatasında olduğu gibi bu hata da yakalanabilir ve sahip de bu durumda düzenli olarak sonlanabilir:
)

---
    bool devam_mı = true;

    while (devam_mı) {
        try {
            auto mesaj = receiveOnly!int();
            writeln("Mesaj: ", mesaj);

        } catch ($(HILITE LinkTerminated) hata) {
            writeln("İşçi sonlanmış.");
            devam_mı = false;
        }
    }
---

$(P
Çıktısı:
)

$(SHELL
Mesaj: 10
Mesaj: 20
İşçi sonlanmış.
)

$(P
Bu hata mesaj olarak da alınabilir.
)

$(H6 Hataları mesaj olarak almak)

$(P
$(C OwnerTerminated) ve $(C LinkTerminated) hataları karşı tarafta mesaj olarak da alınabilirler. Aşağıdaki kod bunu $(C OwnerTerminated) hatası üzerinde gösteriyor:
)

---
    bool devam_mı = true;

    while (devam_mı) {
        receive(
            (int mesaj) {
                writeln("Mesaj: ", mesaj);
            },

            ($(HILITE OwnerTerminated hata)) {
                writeln("Sahip sonlanmış; çıkıyorum.");
                devam_mı = false;
            }
        );
    }
---

$(H5 Posta kutusu yönetimi)

$(P
İş parçacıklarına gönderilen mesajlar her iş parçacığına özel bir posta kutusunda dururlar. Posta kutusundaki mesajların sayısı alıcının mesajları işleyiş hızına bağlı olarak zamanla artabilir ve azalabilir. Posta kutusunun aşırı büyümesi hem sistem belleğine fazla yük getirir hem de programın tasarımındaki bir hataya işaret eder. Posta kutusunun sürekli olarak büyümesi bazı mesajların hiçbir zaman alınamayacaklarını da gösteriyor olabilir.
)

$(P
$(IX setMaxMailboxSize) Posta kutusunun uzunluğu $(C setMaxMailboxSize()) işlevi ile kısıtlanır. Bu işlevin ilk parametresi hangi iş parçacığına ait posta kutusunun kısıtlanmakta olduğunu, ikinci parametresi posta kutusunun en fazla kaç mesaj alabileceğini, üçüncü parametresi de posta kutusu dolu olduğunda ne olacağını belirler. Üçüncü parametre için dört seçenek vardır:
)

$(UL

$(LI $(IX OnCrowding) $(C OnCrowding.block): Gönderen taraf posta kutusunda yer açılana kadar bekler.)

$(LI $(C OnCrowding.ignore): Mesaj gözardı edilir.)

$(LI $(IX MailboxFull) $(C OnCrowding.throwException): Mesaj gönderilirken $(C MailboxFull) hatası atılır.)

$(LI $(C bool function(Tid)) türünde işlev göstergesi: Belirtilen işlev çağrılır.)

)

$(P
Bunun bir örneğini görmek için önce posta kutusunun sürekli olarak büyümesini sağlayalım. Aşağıdaki programdaki işçi hiç zaman geçirmeden art arda mesaj gönderdiği halde sahip iş parçacığı her mesaj için bir saniye zaman harcamaktadır:
)

---
/* UYARI: Bu program çalışırken sisteminiz aşırı derecede
 *        yavaşlayabilir. */
import std.concurrency;
import core.thread;

void işçiİşlev() {
    while (true) {
        ownerTid.send(42);    // ← Sürekli olarak mesaj üretiyor.
    }
}

void main() {
    spawn(&işçiİşlev);

    while (true) {
        receive(
            (int mesaj) {
                // Her mesajda zaman geçiriyor.
                Thread.sleep(1.seconds);
            });
    }
}
---

$(P
Mesajları tüketen taraf üreten taraftan yavaş kaldığı için yukarıdaki programın kullandığı bellek sürekli olarak artacaktır. Bunun önüne geçmek için ana iş parçacığının posta kutusu daha işçi başlatılmadan önce belirli bir mesaj sayısı ile kısıtlanabilir:
)

---
void $(CODE_DONT_TEST)main() {
    setMaxMailboxSize(thisTid, 1000, OnCrowding.block);

    spawn(&işçiİşlev);
// ...
}
---

$(P
Yukarıdaki $(C setMaxMailboxSize()) çağrısı ana iş parçacığının posta kutusunun uzunluğunu 1000 ile kısıtlamaktadır. $(C OnCrowding.block), gönderen tarafın mesaja yer açılana kadar beklemesine neden olur.
)

$(P
$(C OnCrowding.throwException) kullanılan aşağıdaki örnekte ise mesajı gönderen taraf posta kutusunun dolu olduğunu atılan $(C MailboxFull) hatasından anlamaktadır:
)

---
import std.concurrency;
import core.thread;

void işçiİşlev() {
    while (true) {
        try {
            ownerTid.send(42);

        } catch ($(HILITE MailboxFull) hata) {
            /* Gönderemedim; biraz sonra tekrar denerim. */
            Thread.sleep(1.msecs);
        }
    }
}

void main() {
    setMaxMailboxSize(thisTid, 1000, $(HILITE OnCrowding.throwException));

    spawn(&işçiİşlev);

    while (true) {
        receive(
            (int mesaj) {
                Thread.sleep(1.seconds);
            });
    }
}
---

$(H5 $(IX prioritySend) $(IX PriorityMessageException) Öncelikli mesajlar)

$(P
$(C prioritySend()) ile gönderilen mesajlar önceliklidir. Bu mesajlar posta kutusunda beklemekte olan mesajlardan daha önce alınırlar:
)

---
    prioritySend(ownerTid, ÖnemliMesaj(100));
---

$(P
Alıcı tarafta $(C prioritySend()) ile gönderilmiş olan mesajın türünü bekleyen mesajcı işlev yoksa $(C PriorityMessageException) hatası atılır:
)

$(SHELL
std.concurrency.$(HILITE PriorityMessageException)@std/concurrency.d(280):
Priority message
)

$(H5 İş parçacığı isimleri)

$(P
Şimdiye kadar kullandığımız basit örneklerde sahip ve işçinin birbirlerinin kimliklerini kolayca edindiklerini gördük. Çok sayıda iş parçacığının görev aldığı programlarda ise iş parçacıklarının $(C Tid) değerlerini birbirlerini tanısınlar diye elden ele geçirmek karmaşık olabilir. Bunun önüne geçmek için iş parçacıklarına bütün program düzeyinde isimler atanabilir.
)

$(P
Aşağıdaki üç işlev bütün iş parçacıkları tarafından erişilebilen bir eşleme tablosu gibi düşünülebilirler:
)

$(UL

$(LI $(IX register) $(C register()): İş parçacığını bir isimle eşleştirir.)

$(LI $(IX locate) $(C locate()): Belirtilen isme karşılık gelen iş parçacığını döndürür. O isme karşılık gelen iş parçacığı yoksa $(C Tid.init) değerini döndürür.)

$(LI $(IX unregister) $(C unregister()): İş parçacığı ile ismin ilişkisini kaldırır.)

)

$(P
Aşağıdaki program birbirlerini isimleriyle bulan iki eş iş parçacığı başlatıyor. Bu iş parçacıkları sonlanmalarını bildiren $(C Sonlan) mesajını alana kadar birbirlerine mesaj gönderiyorlar:
)

---
import std.stdio;
import std.concurrency;
import core.thread;

struct Sonlan {
}

void main() {
    // Eşinin ismi "ikinci" olan bir iş parçacığı
    auto birinci = spawn(&oyuncu, "ikinci");
    $(HILITE register)("birinci", birinci);
    scope(exit) $(HILITE unregister)("birinci");

    // Eşinin ismi "birinci" olan bir iş parçacığı
    auto ikinci = spawn(&oyuncu, "birinci");
    $(HILITE register)("ikinci", ikinci);
    scope(exit) $(HILITE unregister)("ikinci");

    Thread.sleep(2.seconds);

    prioritySend(birinci, Sonlan());
    prioritySend(ikinci, Sonlan());

    // unregister() çağrıları iş parçacıkları sonlandıktan
    // sonra işletilsinler diye main() beklemelidir.
    thread_joinAll();
}

void oyuncu(string eşİsmi) {
    Tid eş;

    while (eş == Tid.init) {
        Thread.sleep(1.msecs);
        eş = $(HILITE locate)(eşİsmi);
    }

    bool devam_mı = true;

    while (devam_mı) {
        eş.send("merhaba " ~ eşİsmi);
        receive(
            (string mesaj) {
                writeln("Mesaj: ", mesaj);
                Thread.sleep(500.msecs);
            },

            (Sonlan mesaj) {
                writefln("%s, ben çıkıyorum.", eşİsmi);
                devam_mı = false;
            });
    }
}
---

$(P
$(IX thread_joinAll) $(C main)'in sonunda çağrıldığını gördüğümüz $(C thread_joinAll), sahip iş parçacığının işçilerinin hepsinin sonlanmalarını beklemesini sağlar.
)

$(P
Çıktısı:
)

$(SHELL
Mesaj: merhaba birinci
Mesaj: merhaba ikinci
Mesaj: merhaba birinci
Mesaj: merhaba ikinci
Mesaj: merhaba birinci
Mesaj: merhaba ikinci
Mesaj: merhaba ikinci
Mesaj: merhaba birinci
birinci, ben çıkıyorum.
ikinci, ben çıkıyorum.
)

$(H5 Özet)

$(UL

$(LI İş parçacıklarının birbirlerine bağlı olmadıkları durumlarda bir önceki bölümün konusu olan $(C std.parallelism) modülünün sunduğu $(I koşut programlamayı) yeğleyin. Ancak iş parçacıkları birbirlerine bağlı olduklarında $(C std.concurrency)'nin sunduğu $(I eş zamanlı programlamayı) düşünün.)

$(LI Veri paylaşımı çeşitli program hatalarına açık olduğundan eş zamanlı programlama gerçekten gerektiğinde bu bölümün konusu olan mesajlaşmayı yeğleyin.)

$(LI $(C spawn()) ve $(C spawnLinked()) iş parçacığı başlatır.)

$(LI $(C thisTid) bu iş parçacığının kimliğidir.)

$(LI $(C ownerTid) bu iş parçacığının sahibinin kimliğidir.)

$(LI $(C send()) ve $(C prioritySend()) mesaj gönderir.)

$(LI $(C receiveOnly()), $(C receive()) ve $(C receiveTimeout()) mesaj bekler.)

$(LI $(C Variant) her mesaja uyar.)

$(LI $(C setMaxMailboxSize()) posta kutusunun büyüklüğünü kısıtlar.)

$(LI $(C register()), $(C unregister()) ve $(C locate()) iş parçacıklarını isimle kullanma olanağı sağlar.)

$(LI Mesajlaşma sırasında hata atılabilir: $(C MessageMismatch), $(C OwnerTerminated), $(C LinkTerminated), $(C MailboxFull) ve $(C PriorityMessageException).)

$(LI Sahip, işçiden atılan hataları otomatik olarak yakalayamaz.)

)

macros:
        SUBTITLE=Mesajlaşarak Eş Zamanlı Programlama

        DESCRIPTION=Programın birden fazla iş parçacığı üzerinde işletilmesi ve iş parçacıklarının mesajlaşarak iletişimleri (concurrency)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial eş zamanlı programlama iş parçacığı concurrency mesajlaşma

SOZLER=
$(cokuzlu)
$(degismez)
$(es_zamanli)
$(giris_cikisa_bagli)
$(gorev)
$(is_parcacigi)
$(kosut_islemler)
$(mesajlasma)
$(mikro_islemciye_bagli)
