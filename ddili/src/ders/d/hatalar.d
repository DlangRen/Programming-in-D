Ddoc

$(DERS_BOLUMU $(IX hata atma) Hata Yönetimi)

$(P
Beklenmedik durumlar programların yaşamlarının doğal parçalarıdır. Kullanıcı hataları, programcı hataları, ortamdaki beklenmedik değişiklikler, vs. programların çalışmaları sırasında her zaman karşılaşılan durumlardır.
)

$(P
Bu durumlar bazen normal işleyişe devam edilemeyecek kadar vahim olabilir. Örneğin gereken bir bilgi elde edilemiyordur, eldeki bilgi geçersizdir, bir çevre aygıtı çalışmıyordur, vs. Böyle çaresiz kalınan durumlarda D'nin hata atma düzeneği kullanılarak işleme son verilir.
)

$(P
Devam edilemeyecek kadar kötü bir durum örneği olarak yalnızca dört aritmetik işlemi destekleyen bir işlevin bunların dışındaki bir işlemle çağrılması durumunu düşünebilirsiniz. Önceki bölümün problem çözümlerinde de olduğu gibi:
)

---
    switch (işlem) {

    case "+":
        writeln(birinci + ikinci);
        break;

    case "-":
        writeln(birinci - ikinci);
        break;

    case "x":
        writeln(birinci * ikinci);
        break;

    case "/":
        writeln(birinci / ikinci);
        break;

    default:
        throw new Exception(format("Geçersiz işlem: %s", işlem));
    }
---

$(P
Yukarıdaki $(C switch) deyiminde $(C case)'lerle belirtilmiş olan dört işlem dışında ne yapılacağı bilinmemektedir. O yüzden deyimin $(C default) kapsamında bir hata atılmaktadır.
)

$(P
Çaresiz durumlarda atılan hata örnekleriyle Phobos'ta da karşılaşırız. Örneğin bir dizgiyi $(C int) türüne dönüştürmek için kullanılan $(C to!int), $(C int) olamayacak bir dizgiyle çağrıldığında hata atar:
)

---
import std.conv;

void main() {
    const int sayı = to!int("merhaba");
}
---

$(P
"merhaba" dizgisi bir tamsayı değer ifade etmediği için; o program, $(C to!int)'in attığı bir hatayla sonlanır.
)

$(SHELL
# ./deneme
$(DARK_GRAY std.conv.ConvException@std/conv.d(37): std.conv(1161): Can't convert
value `merhaba' of type const(char)[] to type int)
)

$(P
$(C to!int)'in attığı yukarıdaki hatayı şu şekilde çevirebiliriz: "const(char)[] türündeki `merhaba' değeri int türüne dönüştürülemez".
)

$(P
Hata mesajının baş tarafındaki std.conv.ConvException da hatanın türünü belirtir. Bu hatanın ismine bakarak onun $(C std.conv) modülü içinde tanımlanmış olduğunu anlayabiliyoruz. İsmi de "dönüşüm hatası" anlamına gelen "conversion exception"dan türemiş olan $(C ConvException)'dır.
)

$(H5 $(IX throw) Hata atmak için $(C throw))

$(P
Bunun örneklerini hem yukarıdaki $(C switch) deyiminde, hem de daha önceki bölümlerde gördük.
)

$(P
Anlamı "at, fırlat" olan $(C throw) deyimi, kendisinden sonra yazılan ifadenin değerini bir $(I hata nesnesi olarak atar) ve işleme hemen son verilmesine neden olur. $(C throw) deyiminden sonraki adımlar işletilmez. Bu, hata kavramına uygun bir davranıştır: hatalar işlemlere devam edilemeyecek durumlarda atıldıkları için, zaten devam etmek söz konusu olmamalıdır.
)

$(P
Başka bir bakış açısıyla; eğer işleme devam edilebilecek gibi bir durumla karşılaşmışsak, hata atılacak kadar çaresiz bir durum yok demektir. O durumda hata atılmaz ve işlev bir çaresini bulur ve işine devam edebilir.
)

$(H6 $(IX Exception) $(IX Error) $(IX Throwable) $(C Exception) ve $(C Error) hata türleri)

$(P
$(C throw) deyimi ile yalnızca $(C Throwable) türünden türemiş olan nesneler atılabilir. Buna rağmen, programlarda ondan da türemiş olan $(C Exception) ve $(C Error) türleri kullanılır. Örneğin Phobos'taki hatalar ya $(C Exception) sınıfından, ya da $(C Error) sınıfından türemişlerdir. $(C Error), giderilemez derecede hatalı durumları ifade eder. O hatanın yakalanması önerilmez. Bu yüzden, atacağınız hataları ya doğrudan $(C Exception)'dan, ya da ondan türeteceğiniz daha belirgin türlerden atmanız gerekir. ($(I Not: Sınıflarla ilgili bir konu olan türemeyi daha sonra göreceğiz.))
)

$(P
$(C Exception) nesneleri, kurulurlarken hata mesajını $(C string) olarak alırlar. Bu mesajı, $(C std.string) modülündeki $(C format) işlevi ile oluşturmak kolaylık sağlar:
)

---
import std.stdio;
import std.string;
import std.random;

int[] rasgeleZarlarAt(int adet) {
    if (adet < 0) {
        $(HILITE throw new Exception)(
            format("Geçersiz 'adet' değeri: %s", adet));
    }

    int[] sayılar;

    foreach (i; 0 .. adet) {
        sayılar ~= uniform(1, 7);
    }

    return sayılar;
}

void main() {
    writeln(rasgeleZarlarAt(-5));
}
---

$(SHELL
# ./deneme
$(DARK_GRAY object.Exception: Geçersiz 'adet' değeri: -5)
)

$(P
Çoğu durumda, $(C new) ile açıkça hata nesnesi oluşturmak ve $(C throw) ile açıkça atmak yerine bu adımları kapsayan $(C enforce()) işlevi kullanılır. Örneğin, yukarıdaki denetimin eşdeğeri aşağıdaki $(C enforce()) çağrısıdır:
)

---
    enforce(adet >= 0, format("Geçersiz 'adet' değeri: %s", adet));
---

$(P
$(C enforce()) ve $(C assert()) işlevlerinin farklarını daha sonraki bir bölümde göreceğiz.
)

$(H6 Hata atıldığında bütün kapsamlardan çıkılır)

$(P
Programın, $(C main) işlevinden başlayarak başka işlevlere, onlardan da daha başka işlevlere dallandığını görmüştük. İşlevlerin birbirlerini katmanlar halinde çağırmaları, çağrılan işlevlerin kendilerini çağıran işlevlere dönmeleri, ardından başka işlevlerin çağrılmaları, vs. bir ağacın dalları halinde gösterilebilir.
)

$(P
Örneğin $(C main)'den çağrılan $(C yumurtaYap) adlı bir işlev, kendisi $(C malzemeleriHazırla) adlı başka bir işlevi çağırabilir, ve o işlev de $(C yumurtaHazırla) adlı başka bir işlevi çağırabilir. Okların işlev çağrıları anlamına geldiklerini kabul edersek, böyle bir programın dallanmasını şu şekilde gösterebiliriz:
)

$(MONO
main
  │
  ├──▶ yumurtaYap
  │      │
  │      ├──▶ malzemeleriHazırla
  │      │          │
  │      │          ├─▶ yumurtaHazırla
  │      │          ├─▶ yağHazırla
  │      │          └─▶ tavaHazırla
  │      │
  │      ├──▶ yumurtalarıPişir
  │      └──▶ malzemeleriKaldır
  │
  └──▶ yumurtaYe
)

$(P
Toplam 3 alt düzeye dallanan bu programı, dallanma düzeylerini değişik miktarlarda girintiyle gösterecek şekilde aşağıdaki gibi yazabiliriz. Tabii bu programda işlevler yararlı işler yapmıyorlar; burada amaç, yalnızca programın dallanmasını göstermek:
)

---
$(CODE_NAME butun_islevler)import std.stdio;

void girinti(in int miktar) {
    foreach (i; 0 .. miktar * 2) {
        write(' ');
    }
}

void başlıyor(in char[] işlev, in int girintiMiktarı) {
    girinti(girintiMiktarı);
    writeln("▶ ", işlev, " ilk satır");
}

void bitiyor(in char[] işlev, in int girintiMiktarı) {
    girinti(girintiMiktarı);
    writeln("◁ ", işlev, " son satır");
}

void main() {
    başlıyor("main", 0);
    yumurtaYap();
    yumurtaYe();
    bitiyor("main", 0);
}

void yumurtaYap() {
    başlıyor("yumurtaYap", 1);
    malzemeleriHazırla();
    yumurtalarıPişir();
    malzemeleriKaldır();
    bitiyor("yumurtaYap", 1);
}

void yumurtaYe() {
    başlıyor("yumurtaYe", 1);
    bitiyor("yumurtaYe", 1);
}

void malzemeleriHazırla() {
    başlıyor("malzemeleriHazırla", 2);
    yumurtaHazırla();
    yağHazırla();
    tavaHazırla();
    bitiyor("malzemeleriHazırla", 2);
}

void yumurtalarıPişir() {
    başlıyor("yumurtalarıPişir", 2);
    bitiyor("yumurtalarıPişir", 2);
}

void malzemeleriKaldır() {
    başlıyor("malzemeleriKaldır", 2);
    bitiyor("malzemeleriKaldır", 2);
}

void yumurtaHazırla() {
    başlıyor("yumurtaHazırla", 3);
    bitiyor("yumurtaHazırla", 3);
}

void yağHazırla() {
    başlıyor("yağHazırla", 3);
    bitiyor("yağHazırla", 3);
}

void tavaHazırla() {
    başlıyor("tavaHazırla", 3);
    bitiyor("tavaHazırla", 3);
}
---

$(P
Normal işleyişi sırasında program şu çıktıyı üretir:
)

$(SHELL
▶ main ilk satır
  ▶ yumurtaYap ilk satır
    ▶ malzemeleriHazırla ilk satır
      ▶ yumurtaHazırla ilk satır
      ◁ yumurtaHazırla son satır
      ▶ yağHazırla ilk satır
      ◁ yağHazırla son satır
      ▶ tavaHazırla ilk satır
      ◁ tavaHazırla son satır
    ◁ malzemeleriHazırla son satır
    ▶ yumurtalarıPişir ilk satır
    ◁ yumurtalarıPişir son satır
    ▶ malzemeleriKaldır ilk satır
    ◁ malzemeleriKaldır son satır
  ◁ yumurtaYap son satır
  ▶ yumurtaYe ilk satır
  ◁ yumurtaYe son satır
◁ main son satır
)

$(P
$(C başlıyor) ve $(C bitiyor) işlevleri sayesinde $(C ▶) işareti ile işlevin ilk satırını, $(C ◁) işareti ile de son satırını gösterdik. Program $(C main)'in ilk satırıyla başlıyor, başka işlevlere dallanıyor, ve en son $(C main)'in son satırıyla sonlanıyor.
)

$(P
Şimdi, programı $(C yumurtaHazırla) işlevine dolaptan kaç yumurta çıkartacağını parametre olarak belirtecek şekilde değiştirelim; ve bu işlev birden az bir değer geldiğinde hata atsın:
)

---
$(CODE_NAME yumurtaHazırla_int)import std.string;

// ...

void yumurtaHazırla($(HILITE int adet)) {
    başlıyor("yumurtaHazırla", 3);

    if (adet < 1) {
        throw new Exception(
            format("Dolaptan %s yumurta çıkartılamaz", adet));
    }

    bitiyor("yumurtaHazırla", 3);
}
---

$(P
Programın doğru olarak derlenebilmesi için tabii başka işlevleri de değiştirmemiz gerekir. Dolaptan kaç yumurta çıkartılacağını işlevler arasında $(C main)'den başlayarak elden elden iletebiliriz. Bu durumda programın diğer tarafları da aşağıdaki gibi değiştirilebilir. Bu örnekte, $(C main)'den bilerek geçersiz olan -8 değerini gönderiyoruz; amaç, programın dallanmasını bir kere de hata atıldığında görmek:
)

---
$(CODE_NAME yumurtaYap_int_etc)$(CODE_XREF butun_islevler)$(CODE_XREF yumurtaHazırla_int)// ...

void main() {
    başlıyor("main", 0);
    yumurtaYap($(HILITE -8));
    yumurtaYe();
    bitiyor("main", 0);
}

void yumurtaYap($(HILITE int adet)) {
    başlıyor("yumurtaYap", 1);
    malzemeleriHazırla($(HILITE adet));
    yumurtalarıPişir();
    malzemeleriKaldır();
    bitiyor("yumurtaYap", 1);
}

// ...

void malzemeleriHazırla($(HILITE int adet)) {
    başlıyor("malzemeleriHazırla", 2);
    yumurtaHazırla($(HILITE adet));
    yağHazırla();
    tavaHazırla();
    bitiyor("malzemeleriHazırla", 2);
}

// ...
---

$(P
Programın bu halini çalıştırdığımızda, $(C throw) ile hata atıldığı yerden sonraki hiçbir satırın işletilmediğini görürüz:
)

$(SHELL
▶ main ilk satır
  ▶ yumurtaYap ilk satır
    ▶ malzemeleriHazırla ilk satır
      ▶ yumurtaHazırla ilk satır
object.Exception: Dolaptan -8 yumurta çıkartılamaz
)

$(P
Hata oluştuğu an; en alt düzeyden en üst düzeye doğru, önce $(C yumurtaHazırla) işlevinden, sonra $(C malzemeleriHazırla) işlevinden, daha sonra $(C yumurtaYap) işlevinden, ve en sonunda da $(C main) işlevinden çıkılır. Bu çıkış sırasında, işlevlerin henüz işletilmemiş olan adımları işletilmez.
)

$(P
İşlemlere devam etmeden bütün işlevlerden çıkılmasının mantığı; en alt düzeydeki $(C yumurtaHazırla) işlevinin başarısızlıkla sonuçlanmış olmasının, onu çağıran daha üst düzeydeki işlevlerin de başarısız olacakları anlamına gelmesidir.
)

$(P
Alt düzey bir işlevden atılan hata, teker teker o işlevi çağıran üst düzey işlevlere geçer ve en sonunda $(C main)'den de çıkarak programın sonlanmasına neden olur. Hatanın izlediği yolu işaretli olarak aşağıdaki gibi gösterebiliriz:
)

$(MONO
     $(HILITE ▲)
     $(HILITE │)
     $(HILITE │)
main $(HILITE &nbsp;◀───────────┐)
  │               $(HILITE │)
  │               $(HILITE │)
  ├──▶ yumurtaYap $(HILITE &nbsp;◀─────────────┐)
  │      │                       $(HILITE │)
  │      │                       $(HILITE │)
  │      ├──▶ malzemeleriHazırla $(HILITE &nbsp;◀─────┐)
  │      │          │                   $(HILITE │)
  │      │          │                   $(HILITE │)
  │      │          ├─▶ yumurtaHazırla  $(HILITE X) $(I atılan hata)
  │      │          ├─▶ yağHazırla
  │      │          └─▶ tavaHazırla
  │      │
  │      ├──▶ yumurtalarıPişir
  │      └──▶ malzemeleriKaldır
  │
  └──▶ yumurtaYe
)

$(P
Hata atma düzeneğinin yararı, hatalı bir durumla karşılaşıldığında dallanılmış olan bütün işlevlerin derhal terkedilmelerini sağlamasıdır.
)

$(P
Bazı durumlarda, atılan hatanın $(I yakalanması) ve programın devam edebilmesi de mümkündür. Bunu sağlayan $(C catch) anahtar sözcüğünü biraz aşağıda göreceğiz.
)

$(H6 $(C throw)'u ne zaman kullanmalı)

$(P
$(C throw)'u gerçekten işe devam edilemeyecek durumlarda kullanın. Örneğin kayıtlı öğrenci adedini bir dosyadan okuyan bir işlev, bu değer sıfırdan küçük çıktığında hata atabilir. Çünkü örneğin eksi adet öğrenci ile işine devam etmesi olanaksızdır.
)

$(P
Öte yandan; eğer devam edilememesinin nedeni kullanıcının girdiği bir bilgiyse, kullanıcının girdiği bu bilgiyi denetlemek daha uygun olabilir. Kullanıcıya bir hata mesajı gösterilebilir ve bilgiyi geçerli olacak şekilde tekrar girmesi istenebilir. Kullanıcıyla etkileşilen böyle bir durum, programın atılan bir hata ile sonlanmasından daha uygun olabilir.
)

$(H5 $(IX try) $(IX catch) Hata yakalamak için $(C try-catch) deyimi)

$(P
Yukarıda, atılan hatanın bütün işlevlerden ve en sonunda da programdan hemen çıkılmasına neden olduğunu anlattım. Aslında atılan bu hata $(I yakalanabilir) ve hatanın türüne veya duruma göre davranılarak programın sonlanması önlenebilir.
)

$(P
Hata, atıldığı işlevden üst düzey işlevlere doğru adım adım ilerlerken, onunla ilgilenen bir noktada $(C try-catch) deyimi ile yakalanabilir. "try"ın anlamı "dene", "catch"in anlamı da "yakala"dır. $(C try-catch) deyimini, bu anlamları göze alarak "çalıştırmayı $(I dene), eğer hata atılırsa $(I yakala)" olarak anlatabiliriz. Söz dizimi şöyledir:
)

---
    try {
        // çalıştırılması istenen ve belki de
        // hata atacak olan kod bloğu

    } catch (ilgilenilen_bir_hata_türü_nesnesi) {
        // bu türden hata atıldığında
        // işletilecek olan işlemler

    } catch (ilgilenilen_diğer_bir_hata_türü_nesnesi) {
        // bu diğer türden hata atıldığında
        // işletilecek olan işlemler

    // ... seçime bağlı olarak başka catch blokları ...

    } finally {
        // hata atılsa da atılmasa da;
        // mutlaka işletilmesi gereken işlemler
    }
---

$(P
Bu bloğu anlamak için önce aşağıdaki $(C try-catch) kullanmayan programa bakalım. Bu program, zar değerini bir dosyadan okuyor ve çıkışa yazdırıyor:
)

---
import std.stdio;

int dosyadanZarOku() {
    auto dosya = File("zarin_yazili_oldugu_dosya", "r");

    int zar;
    dosya.readf(" %s", &zar);

    return zar;
}

void main() {
    const int zar = dosyadanZarOku();

    writeln("Zar: ", zar);
}
---

$(P
Dikkat ederseniz, $(C dosyadanZarOku) işlevi hiç hatalarla ilgilenmeden ve sanki dosya başarıyla açılacakmış ve içinden bir zar değeri okunacakmış gibi yazılmış. O, yalnızca kendi işini yapıyor. Bu, hata atma düzeneğinin başka bir yararıdır: işlevler her şey yolunda gidecekmiş gibi yazılabilirler.
)

$(P
Şimdi o programı klasörde $(C zarin_yazili_oldugu_dosya) isminde bir dosya bulunmadığı zaman başlatalım:
)

$(SHELL
# ./deneme
$(DARK_GRAY std.exception.ErrnoException@std/stdio.d(286): Cannot open file
$(BACK_TICK)zarin_yazili_oldugu_dosya' in mode $(BACK_TICK)r' (No such file or directory))
)

$(P
Klasörde dosya bulunmadığı zaman, mesajı "'zarin_yazili_oldugu_dosya' 'r' modunda açılamıyor" olan bir $(C ErrnoException) atılmıştır. Yukarıda gördüğümüz diğer örneklere uygun olarak, program çıkışına "Zar: " yazdıramamış ve hemen sonlanmıştır.
)

$(P
Şimdi programa $(C dosyadanZarOku) işlevini bir $(C try) bloğu içinde çağıran bir işlev ekleyelim, ve $(C main)'den bu işlevi çağıralım:
)

---
import std.stdio;

int dosyadanZarOku() {
    auto dosya = File("zarin_yazili_oldugu_dosya", "r");

    int zar;
    dosya.readf(" %s", &zar);

    return zar;
}

int $(HILITE dosyadanZarOkumayıDene)() {
    int zar;

    $(HILITE try) {
        zar = dosyadanZarOku();

    } $(HILITE catch) (std.exception.ErrnoException hata) {
        writeln("(Dosyadan okuyamadım; 1 varsayıyorum)");
        zar = 1;
    }

    return zar;
}

void main() {
    const int zar = $(HILITE dosyadanZarOkumayıDene)();

    writeln("Zar: ", zar);
}
---

$(P
Eğer programı yine aynı şekilde klasörde $(C zarin_yazili_oldugu_dosya) dosyası olmadan başlatırsak, bu sefer programın hata ile sonlanmadığını görürüz:
)

$(SHELL
$ ./deneme
$(DARK_GRAY (Dosyadan okuyamadım; 1 varsayıyorum)
Zar: 1)
)

$(P
Bu kodda, $(C dosyadanZarOku) işlevinin işleyişi bir $(C try) bloğu içinde $(I denenmektedir). Eğer hatasız çalışırsa, işlev ondan sonra $(C return zar;) satırı ile normal olarak sonlanır. Ama eğer özellikle belirtilmiş olan $(C std.exception.ErrnoException) hatası atılırsa, işlevin işleyişi o $(C catch) bloğuna geçer ve o bloğun içindeki kodları çalıştırır. Bunu programın yukarıdaki çıktısında görüyoruz.
)

$(P
Özetle, klasörde zar dosyası bulunmadığı için
)

$(UL
$(LI önceki programdaki gibi bir $(C std.exception.ErrnoException) hatası atılmakta, (bunu bizim kodumuz değil, $(C File) atıyor))
$(LI bu hata $(C catch) ile yakalanmakta,)
$(LI $(C catch) bloğunun normal işleyişi sırasında zar için 1 değeri varsayılmakta,)
$(LI ve programın işleyişine devam edilmektedir.)
)

$(P
İşte $(C catch), atılabilecek olan hataları yakalayarak o durumlara uygun olarak davranılmasını, ve programın işleyişine devam etmesini sağlar.
)

$(P
Başka bir örnek olarak, yumurtalı programa dönelim ve onun $(C main) işlevine bir $(C try-catch) deyimi ekleyelim:
)

---
$(CODE_XREF yumurtaYap_int_etc)void main() {
    başlıyor("main", 0);

    try {
        yumurtaYap(-8);
        yumurtaYe();

    } catch (Exception hata) {
        write("Yumurta yiyemedim: ");
        writeln('"', hata.msg, '"');
        writeln("Komşuda yiyeceğim...");
    }

    bitiyor("main", 0);
}
---

$(P
($(I Not: $(C .msg) niteliğini biraz aşağıda göreceğiz.))
)

$(P
Yukarıdaki $(C try) bloğunda iki satır kod bulunuyor. $(C catch), bu satırların herhangi birisinden atılacak olan hatayı yakalar.
)

$(SHELL
▶ main ilk satır
  ▶ yumurtaYap ilk satır
    ▶ malzemeleriHazırla ilk satır
      ▶ yumurtaHazırla ilk satır
Yumurta yiyemedim: "Dolaptan -8 yumurta çıkartılamaz"
Komşuda yiyeceğim...
◁ main son satır
)

$(P
Görüldüğü gibi, bu program bir hata atıldı diye artık hemen sonlanmamaktadır. Program; hataya karşı önlem almakta, işleyişine devam etmekte, ve $(C main) işlevi normal olarak sonuna kadar işletilmektedir.
)

$(H6 $(C catch) blokları sırayla taranır)

$(P
Örneklerde kendimiz hata atarken kullandığımız $(C Exception), $(I genel) bir hata türüdür. Bu hatanın atılmış olması, programda bir hata olduğunu belirtir; ve hatanın içinde saklanmakta olan mesaj, o mesajı okuyan insanlara da hatayla ilgili bilgi verir. Ancak, $(C Exception) sınıfı hatanın $(I türü) konusunda bir bilgi taşımaz.
)

$(P
Bu bölümde daha önce gördüğümüz $(C ConvException) ve $(C ErrnoException) ise $(I daha özel) hata türleridir: birincisi, atılan hatanın bir dönüşüm ile ilgili olduğunu; ikincisi ise sistem işlemleriyle ilgili olduğunu anlatır.
)

$(P
Phobos'taki çoğu başka hata gibi $(C ConvException) ve $(C ErrnoException), $(C Exception) sınıfından türemişlerdir. Atılan hata türleri, $(C Error) ve $(C Exception) genel hata türlerinin daha özel halleridir. $(C Error) ve $(C Exception) da kendilerinden daha genel olan $(C Throwable) sınıfından türemişlerdir. ("Throwable"ın anlamı "atılabilen"dir.)
)

$(P
Her ne kadar $(C catch) ile yakalanabiliyor olsa da, $(C Error) türünden veya ondan türemiş olan hataların yakalanmaları önerilmez. $(C Error)'dan daha genel olduğu için $(C Throwable)'ın yakalanması da önerilmez. Yakalanmasının doğru olduğu sıradüzen, $(C Exception) sıradüzenidir.
)

$(MONO
           Throwable $(I (yakalamayın))
             ↗   ↖
    Exception     Error $(I (yakalamayın))
     ↗    ↖        ↗    ↖
   ...    ...    ...    ...
)

$(P $(I Not: Sıradüzen gösterimini daha sonraki $(LINK2 /ders/d/tureme.html, Türeme bölümünde) göstereceğim. Yukarıdaki şekil, $(C Throwable)'ın en genel, $(C Exception) ve $(C Error)'ın daha özel türler olduklarını ifade eder.)
)

$(P
Atılan hataları özellikle belirli bir türden olacak şekilde yakalayabiliriz. Örneğin $(C ErrnoException) türünü yakalayarak dosya açma sorunu ile karşılaşıldığını anlayabilir ve programda buna göre hareket edebiliriz.
)

$(P
Atılan hata, ancak eğer $(C catch) bloğunda belirtilen türe uyuyorsa yakalanır. Örneğin $(C ÖzelBirHata) türünü yakalamaya çalışan bir $(C catch) bloğu, $(C ErrnoException) hatasını yakalamaz.
)

$(P
Bir $(C try) deyimi içerisindeki kodların (veya onların çağırdığı başka kodların) attığı hata, o $(C try) deyiminin $(C catch) bloklarında belirtilen hata türlerine $(I sırayla) uydurulmaya çalışılır. Eğer atılan hatanın türü sırayla bakılan $(C catch) bloğunun hata türüne uyuyorsa, o hata yakalanmış olur ve o $(C catch) bloğunun içerisindeki kodlar işletilir. Uyan bir $(C catch) bloğu bulunursa, artık diğer $(C catch) bloklarına bakılmaz.
)

$(P
$(C catch) bloklarının böyle sırayla taranmalarının doğru olarak çalışması için $(C catch) bloklarının daha özel hata türlerinden daha genel hata türlerine doğru sıralanmış olmaları gerekir. Buna göre; genel bir kural olarak eğer yakalanması uygun bulunuyorsa, yakalanması önerilen en genel hata türü olduğu için $(C Exception) her zaman en sondaki $(C catch) bloğunda belirtilmelidir.
)

$(P
Örneğin öğrenci kayıtlarıyla ilgili hataları yakalamaya çalışan bir $(C try) deyimi, $(C catch) bloklarındaki hata türlerini özelden genele doğru şu şekilde yazabilir:
)

---
    try {
        // ... hata atabilecek kayıt işlemleri ...

    } catch (KayıtNumarasıHanesiHatası hata) {

        // özellikle kayıt numarasının bir hanesiyle ilgili
        // olan bir hata

    } catch (KayıtNumarasıHatası hata) {

        // kayıt numarasıyla ilgili olan, ama hanesi ile
        // ilgili olmayan daha genel bir hata

    } catch (KayıtHatası hata) {

        // kayıtla ilgili daha genel bir hata

    } catch (Exception hata) {

        // kayıtla ilgisi olmayan genel bir hata

    }
---

$(H6 $(IX finally) $(C finally) bloğu)

$(P
$(C try-catch) deyiminin son bloğu olan $(C finally), hata atılsa da atılmasa da mutlaka işletilecek olan işlemleri içerir. $(C finally) bloğu isteğe bağlıdır; gerekmiyorsa yazılmayabilir.
)

$(P
$(C finally)'nin etkisini görmek için %50 olasılıkla hata atan şu programa bakalım:
)

---
import std.stdio;
import std.random;

void yüzdeElliHataAtanİşlev() {
    if (uniform(0, 2) == 1) {
        throw new Exception("hata mesajı");
    }
}

void deneme() {
    writeln("ilk satır");

    try {
        writeln("try'ın ilk satırı");
        yüzdeElliHataAtanİşlev();
        writeln("try'ın son satırı");

    // ... isteğe bağlı olarak catch blokları da olabilir ...

    } $(HILITE finally) {
        writeln("finally işlemleri");
    }

    writeln("son satır");
}

void main() {
    deneme();
}
---

$(P
O işlev hata atmadığında programın çıktısı şöyledir:
)

$(SHELL
ilk satır
try'ın ilk satırı
try'ın son satırı
$(HILITE finally işlemleri)
son satır
)

$(P
Hata attığında ise şöyle:
)

$(SHELL
ilk satır
try'ın ilk satırı
$(HILITE finally işlemleri)
object.Exception@deneme.d(7): hata mesajı
)

$(P
Görüldüğü gibi, hata atıldığında "try'ın son satırı" ve "son satır" yazdırılmamış, ama $(C finally) bloğunun içi iki durumda da işletilmiştir.
)

$(H6 $(C try-catch)'i ne zaman kullanmalı)

$(P
$(C try-catch) deyimi, atılmış olan hataları yakalamak ve bu durumlarda özel işlemler yapmak için kullanılır.
)

$(P
Dolayısıyla, $(C try-catch) deyimini ancak ve ancak atılan bir hata ile ilgili özel işlemler yapmanız gereken veya yapabildiğiniz durumlarda kullanın. Başka durumlarda hatalara karışmayın. Hataları, onları yakalamaya çalışan işlevlere bırakın.
)

$(H5 Hata nitelikleri)

$(P
Program hata ile sonlandığında çıktıya otomatik olarak yazdırılan bilgiler yakalanan hata nesnelerinin niteliklerinden de edinilebilir. Bu nitelikler $(C Throwable) arayüzü tarafından sunulur:
)

$(UL

$(LI $(IX .file) $(C .file): Hatanın atıldığı kaynak dosya)

$(LI $(IX .line) $(C .line): Hatanın atıldığı satır)

$(LI $(IX .msg) $(C .msg): Hata mesajı)

$(LI $(IX .info) $(C .info): Çağrı yığıtının hata atıldığındaki durumu)

$(LI $(IX .next) $(C .next): Bir sonraki ikincil hata)

)

$(P
$(C finally) bloğunun hata atılan durumda otomatik olarak işletildiğini gördük. (Bir sonraki bölümde göreceğimiz $(C scope) deyimi ve daha ilerideki bir bölümde göreceğimiz $(I sonlandırıcı işlevler) de kapsamlardan çıkılırken otomatik olarak işletilirler.)
)

$(P
$(IX ikincil hata) Doğal olarak, kapsamlardan çıkılırken işletilen kodlar da hata atabilirler. $(I İkincil) olarak adlandırılan bu hatalar birbirlerine bir bağlı liste olarak bağlanmışlardır; her birisine asıl hatadan başlayarak $(C .next) niteliği ile erişilir. Sonuncu hatanın $(C .next) niteliğinin değeri $(C null)'dır. ($(C null) değerini ilerideki bir bölümde göreceğiz.)
)

$(P
Aşağıdaki örnekte toplam üç adet hata atılmaktadır: $(C foo()) içinde atılan asıl hata ve $(C foo())'nun ve onu çağıran $(C bar())'ın $(C finally) bloklarında atılan ikincil hatalar. Program, ikincil hatalara $(C .next) nitelikleri ile nasıl erişildiğini gösteriyor.
)

$(P
Bu programdaki bazı kavramları daha sonraki bölümlerde göreceğiz. Örneğin, $(C for) döngüsünün yalnızca $(C hata) ifadesinden oluşan devam koşulu $(I $(C hata) $(C null) olmadığı sürece) anlamına gelir.
)

---
import std.stdio;

void foo() {
    try {
        throw new Exception("foo'daki asıl hata");

    } finally {
        throw new Exception("foo'daki finally hatası");
    }
}

void bar() {
    try {
        foo();

    } finally {
        throw new Exception("bar'daki finally hatası");
    }
}

void main() {
    try {
        bar();

    } catch (Exception yakalananHata) {

        for (Throwable hata = yakalananHata;
             hata;    $(CODE_NOTE Anlamı: null olmadığı sürece)
             hata = hata$(HILITE .next)) {

            writefln("mesaj: %s", hata$(HILITE .msg));
            writefln("dosya: %s", hata$(HILITE .file));
            writefln("satır: %s", hata$(HILITE .line));
            writeln();
        }
    }
}
---

$(P
Çıktısı:
)

$(SHELL
mesaj: foo'daki asıl hata
dosya: deneme.d
satır: 6

mesaj: foo'daki finally hatası
dosya: deneme.d
satır: 9

mesaj: bar'daki finally hatası
dosya: deneme.d
satır: 19
)

$(H5 $(IX hata çeşitleri) Hata çeşitleri)

$(P
Hata atma düzeneğinin ne kadar yararlı olduğunu gördük. Hem alt düzeydeki işlemlerin, hem de o işleme bağımlı olan daha üst düzey işlemlerin hemen sonlanmalarına neden olur. Böylece program yanlış bilgiyle veya eksik işlemle devam etmemiş olur.
)

$(P
Buna bakarak her hatalı durumda hata atılmasının uygun olduğunu düşünmeyin. Hatanın çeşidine bağlı olarak farklı davranmak gerekebilir.
)

$(H6 Kullanıcı hataları)

$(P
Hataların bazıları kullanıcıdan gelir. Yukarıda da gördüğümüz gibi, örneğin bir sayı beklenen durumda "merhaba" gibi bir dizgi girilmiş olabilir. Programın kullanıcıyla etkileştiği bir durumda programın hata ile sonlanması uygun olmayacağı için, böyle durumlarda kullanıcıya bir hata mesajı göstermek ve doğru bilgi girmesini istemek daha uygun olabilir.
)

$(P
Yine de, kullanıcının girdiği bilginin doğrudan işlenmesinde ve o işlemler sırasında bir hata atılmasında da bir sakınca olmayabilir. Önemli olan, bu tür bir hatanın programın sonlanmasına neden olmak yerine, kullanıcıya geçerli bilgi girmesini söylemesidir.
)

$(P
Bir örnek olarak, kullanıcıdan dosya ismi alan bir programa bakalım. Aldığımız dosya isminin geçerli olup olmadığı konusunda iki yol izleyebiliriz:
)

$(UL
$(LI $(B Bilgiyi denetlemek): $(C std.file) modülündeki $(C exists) işlevini kullanarak verilen isimde bir dosya olup olmadığına bakabiliriz:

---
    if (exists(dosya_ismi)) {
        // dosya mevcut

    } else {
        // dosya mevcut değil
    }
---

$(P
Dosyayı ancak dosya mevcut olduğunda açarız. Ancak; dosya, program bu denetimi yaptığı anda mevcut olduğu halde, az sonra $(C File) ile açılmaya çalışıldığında mevcut olmayabilir. Çünkü örneğin sistemde çalışmakta olan başka bir program tarafından silinmiş veya ismi değiştirilmiş olabilir.
)

$(P
Bu yüzden, belki de aşağıdaki diğer yöntem daha uygundur.
)

)

$(LI $(B Bilgiyi doğrudan kullanmak): Kullanıcıdan alınan bilgiye güvenebilir ve doğrudan işlemlere geçebiliriz. Eğer verilen bilgi geçersizse, zaten $(C File) bir hata atacaktır:

---
import std.stdio;
import std.string;

void dosyayıKullan(string dosyaİsmi) {
    auto dosya = File(dosyaİsmi, "r");
    // ...
}

string dizgiOku(in char[] soru) {
    write(soru, ": ");
    string dizgi = strip(readln());

    return dizgi;
}

void main() {
    bool dosyaKullanılabildi = false;

    while (!dosyaKullanılabildi) {
        try {
            dosyayıKullan(
                dizgiOku("Dosyanın ismini giriniz"));

            /* Eğer bu noktaya gelebildiysek, dosyayıKullan
             * işlevi başarıyla sonlanmış demektir. Yani,
             * verilen dosya ismi geçerlidir.
             *
             * Bu yüzden bu noktada bu değişkenin değerini
             * 'true' yaparak while'ın sonlanmasını
             * sağlıyoruz. */
            dosyaKullanılabildi = true;
            writeln("Dosya başarıyla kullanıldı");

        } catch (std.exception.ErrnoException açmaHatası) {
            stderr.writeln("Bu dosya açılamadı");
        }
    }
}
---

)

)

$(H6 Programcı hataları)

$(P
Bazı hatalar programcının kendisinden kaynaklanır. Örneğin yazılan bir işlevin programda kesinlikle sıfırdan küçük bir değerle çağrılmayacağından eminizdir. Programın tasarımına göre bu işlev kesinlikle eksi bir değerle çağrılmıyordur. İşlevin buna rağmen eksi bir değer alması; ya programın mantığındaki bir hatadan kaynaklanıyordur, ya da o mantığın gerçekleştirilmesindeki bir hatadan. Bunların ikisi de programcı hatası olarak kabul edilir.
)

$(P
Böyle, programın yazımıyla ilgili olan, yani programcının kendisinden kaynaklanan hatalı durumlarda hata atmak yerine bir $(C assert) kullanmak daha uygun olabilir ($(I Not: $(C assert)'ü daha sonraki bir bölümde göreceğiz.)):
)

---
void menüSeçeneği(int sıraNumarası) {
    assert(sıraNumarası >= 0);
    // ...
}

void main() {
    menüSeçeneği(-1);
}
---

$(P
Program bir $(C assert) hatası ile sonlanır:
)

$(SHELL_SMALL
core.exception.AssertError@$(HILITE deneme.d(3)): Assertion failure
)

$(P
$(C assert) hangi kaynak dosyanın hangi satırındaki beklentinin gerçekleşmediğini de bildirir. (Bu mesajda deneme.d dosyasının üçüncü satırı olduğu anlaşılıyor.)
)

$(H6 Beklenmeyen durumlar)

$(P
Yukarıdaki iki durumun dışında kalan her türlü hatalı durumda hata atmak uygundur. Zaten başka çare kalmamıştır: ne bir kullanıcı hatasıyla ne de bir programcı hatasıyla karşı karşıyayızdır. Eğer işimize devam edemiyorsak, hata atmaktan başka çare yoktur.
)

$(P
Bizim attığımız hatalar karşısında ne yapacakları bizi çağıran üst düzey işlevlerin görevidir. Eğer uygunsa, attığımız hatayı yakalayarak bir çare bulabilirler.
)

$(H5 Özet)

$(UL

$(LI
Eğer bir kullanıcı hatasıyla karşılaşmışsanız ya kullanıcıyı uyarın ya da yine de işlemlere devam ederek nasıl olsa bir hata atılacağına güvenin.
)

$(LI
Programın mantığında veya gerçekleştirilmesinde hata olmadığını garantilemek için $(C assert)'ü kullanın. ($(I Not: $(C assert)'ü ilerideki bir bölümde göreceğiz.))
)

$(LI
Bunların dışındaki durumlarda $(C throw) veya $(C enforce()) ile hata atın. ($(I Not: $(C enforce())'u ilerideki bir bölümde göreceğiz.))
)

$(LI
Hataları ancak ve ancak yakaladığınızda yararlı bir işlem yapabilecekseniz yakalayın. Yoksa hiç $(C try-catch) deyimi içine almayın; belki de işlevinizi çağıran daha üst düzeydeki bir işlev yakalayacaktır.
)

$(LI
$(C catch) bloklarını özelden genele doğru sıralayın.
)

$(LI
İşletilmeleri mutlaka gereken işlemleri $(C finally) bloğuna yazın.
)

)

Macros:
        SUBTITLE=Hata Yönetimi

        DESCRIPTION=D dilinde işlevlerin işlerine devam edememe durumlarında kullanılan hata atma düzeneği [exceptions]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev hata atma throw exception catch finally aykırı durum

SOZLER=
$(bagli_liste)
$(blok)
$(cagri_yigiti)
$(deyim)
$(hata_atma)
$(ifade)
$(ikincil_hata)
$(islev)
$(kapsam)
$(klasor)
$(kurma)
$(nesne)
$(nitelik)
$(phobos)
$(sinif)
$(sonlandirici_islev)
$(turetmek)
