Ddoc

$(DERS_BOLUMU Dizgiler)

$(P
"merhaba" gibi metin parçalarının dizgi olduklarını zaten öğrenmiş ve şimdiye kadarki kodlarda çok yerde kullanmıştık. Dizgileri anlamaya yarayan iki olanağı da bundan önceki üç bölümde gördük: diziler ve karakterler.
)

$(P
Dizgiler o iki olanağın bileşiminden başka bir şey değildir: elemanlarının türü $(I karakter) olan $(I dizilere) dizgi denir. Örneğin $(C char[]) bir dizgi türüdür. Ancak, $(LINK2 /ders/d/karakterler.html, Karakterler bölümünde) gördüğümüz gibi, D'de üç değişik karakter türü olduğu için, üç değişik dizgi türünden ve bunların bazen şaşırtıcı olabilecek etkileşimlerinden söz etmek gerekir.
)

$(H5 $(IX readln) $(IX strip) $(C readf) yerine $(C readln) ve $(C strip))

$(P
Konsoldan satır okuma ile ilgili bazı karışıklıklara burada değinmek istiyorum.
)

$(P
Dizgiler karakter dizileri oldukları için $(I satır sonu) anlamına gelen $(STRING '\n') gibi kontrol karakterlerini de barındırabilirler. O yüzden, girdiğimiz bilgilerin sonunda bastığımız Enter tuşunu temsil eden kodlar da okunurlar ve dizginin parçası haline gelirler.
)

$(P
Dahası, girişten kaç karakter okunmak istendiği de bilinmediği için $(C readf) $(I giriş tükenene kadar) gelen bütün karakterleri dizginin içine okur.
)

$(P
Bunun sonucunda da şimdiye kadar kullanmaya alıştığımız $(C readf) istediğimiz gibi işlemez:
)

---
import std.stdio;

void main() {
    char[] isim;

    write("İsminiz nedir? ");
    readf(" %s", &isim);

    writeln("Çok memnun oldum ", isim, "!");
}
---

$(P
Yazılan isimden sonra basılan Enter girişi sonlandırmaz, ve $(C readf) dizgiye eklemek için karakter beklemeye devam eder:
)

$(SHELL
İsminiz nedir? Mert
                    $(SHELL_NOTE Enter'a basıldığı halde giriş sonlanmaz)
                    $(SHELL_NOTE (bir kere daha basıldığını varsayalım))
)

$(P
Konsolda girişi sonlandırmak için Linux ortamlarında Ctrl-D'ye, Windows ortamlarında da Ctrl-Z'ye basılır. Girişi o şekilde sonlandırdığınızda Enter'lar nedeniyle oluşan satır sonu kodlarının bile dizginin parçası haline geldiklerini görürsünüz:
)

$(SHELL
Çok memnun oldum Mert
          $(SHELL_NOTE_WRONG isimden sonra $(I satır sonu karakteri) var)
!         $(SHELL_NOTE_WRONG (bir tane daha))
)

$(P
İsimden hemen sonra yazdırılmak istenen ünlem işareti satır sonu kodlarından sonra belirmiştir.
)

$(P
Bu yüzden $(C readf) çoğu durumda girişten dizgi okumaya uygun değildir. Onun yerine ismi "satır oku" anlamındaki "read line"dan türemiş olan $(C readln) kullanılabilir.
)

$(P
$(C readln)'ın kullanımı $(C readf)'ten farklıdır; $(STRING " %s") düzen dizgisini ve $(C &) işlecini gerektirmez:
)

---
import std.stdio;

void main() {
    char[] isim;

    write("İsminiz nedir? ");
    $(HILITE readln(isim));

    writeln("Çok memnun oldum ", isim, "!");
}
---

$(P
Buna rağmen satır sonunu belirleyen kodu o da barındırır:
)

$(SHELL
İsminiz nedir? Mert
Çok memnun oldum Mert
!                   $(SHELL_NOTE_WRONG isimden sonra yine "satır sonu" var)
)

$(P
Dizgilerin sonundaki satır sonu kodları ve bütün boşluk karakterleri $(C std.string) modülünde tanımlanmış olan $(C strip) işlevi ile silinebilir:
)

---
import std.stdio;
$(HILITE import std.string;)

void main() {
    char[] isim;

    write("İsminiz nedir? ");
    readln(isim);
    $(HILITE isim = strip(isim);)

    writeln("Çok memnun oldum ", isim, "!");
}
---

$(P
Yukarıdaki $(C strip) ifadesi $(C isim)'in sonundaki satır sonu kodlarının silinmiş halini döndürür. O halinin tekrar $(C isim)'e atanması da $(C isim)'i değiştirmiş olur:
)

$(SHELL
İsminiz nedir? Mert
Çok memnun oldum Mert!  $(SHELL_NOTE "satır sonu" kodlarından arınmış olarak)
)

$(P
$(C readln) ve $(C strip) zincirleme biçimde daha kısa olarak da yazılabilirler:
)

---
    string isim = strip(readln());
---

$(P
O yazımı $(C string) türünü tanıttıktan sonra kullanmaya başlayacağım.
)

$(H5 $(IX formattedRead) Dizgiden veri okumak için $(C formattedRead))

$(P
Girişten veya herhangi başka bir kaynaktan edinilmiş olan bir dizginin içeriği $(C std.format) modülündeki $(C formattedRead()) ile okunabilir. Bu işlevin ilk parametresi veriyi içeren dizgidir. Sonraki parametreler ise aynı $(C readf)'teki anlamdadır:
)

---
import std.stdio;
import std.string;
$(HILITE import std.format;)

void main() {
    write("İsminizi ve yaşınızı aralarında boşluk" ~
          " karakteriyle girin: ");

    string satır = strip(readln());

    string isim;
    int yaş;
    $(HILITE formattedRead)(satır, " %s %s", &isim, &yaş);

    writeln("İsminiz ", isim, ", yaşınız ", yaş, '.');
}
---

$(SHELL
İsminizi ve yaşınızı aralarında boşluk karakteriyle girin: $(HILITE Mert 30)
İsminiz $(HILITE Mert), yaşınız $(HILITE 30).
)

$(P
Aslında, hem $(C readf) hem de $(C formattedRead) başarıyla okuyup dönüştürdükleri veri adedini $(I döndürürler). Dizginin geçerli düzende olup olmadığı bu değer beklenen adet ile karşılaştırılarak belirlenir. Örneğin, yukarıdaki $(C formattedRead) çağrısı $(C string) türündeki isimden ve $(C int) türündeki yaştan oluşan $(I iki) adet veri beklediğinden, dizginin geçerliliği aşağıdaki gibi denetlenebilir:
)

---
    $(HILITE uint adet) = formattedRead(satır, " %s %s", &isim, &yaş);

    if ($(HILITE adet != 2)) {
        writeln("Hata: Geçersiz satır.");

    } else {
        writeln("İsminiz ", isim, ", yaşınız ", yaş, '.');
    }
---

$(P
Girilen veri $(C isim) ve $(C yaş) değişkenlerine dönüştürülemiyorsa program hata verir:
)

$(SHELL
İsminizi ve yaşınızı aralarında boşluk karakteriyle girin: $(HILITE Mert)
Hata: Geçersiz satır.
)

$(H5 $(IX &quot;) Tek tırnak değil, çift tırnak)

$(P
Tek tırnakların karakter sabiti tanımlarken kullanıldıklarını görmüştük. Dizgi sabitleri için ise çift tırnaklar kullanılır: $(STRING 'a') karakterdir, $(STRING "a") tek karakterli bir dizgidir.
)

$(H5 $(IX string) $(IX wstring) $(IX dstring) $(IX char[]) $(IX wchar[]) $(IX dchar[]) $(IX immutable) $(C string), $(C wstring), ve $(C dstring) değişmezdirler)

$(P
D'de üç karakter türüne karşılık gelen üç farklı karakter dizisi türü vardır: $(C char[]), $(C wchar[]), ve $(C dchar[]).
)

$(P
Bu üç dizi türünün $(I değişmez) olanlarını göstermek için üç tane de $(I takma isim) vardır: $(C string), $(C wstring), ve $(C dstring). Bu takma isimler kullanılarak tanımlanan dizgilerin karakterleri $(I değişmezdirler). Bir örnek olarak, bir $(C wchar[]) değişkeninin karakterleri değişebilir ama bir $(C wstring) değişkeninin karakterleri değişemez. (D'nin $(I değişmezlik) kavramının ayrıntılarını daha sonraki bölümlerde göreceğiz.)
)

$(P
Örneğin bir $(C string)'in baş harfini büyütmeye çalışan şu kodda bir derleme hatası vardır:
)

---
    string değişmez = "merhaba";
    değişmez[0] = 'M';             $(DERLEME_HATASI)
---

$(P
Buna bakarak, değiştirilmesi istenen dizgilerin dizi yazımıyla yazılabileceklerini düşünebiliriz ama o da derlenemez. Sol tarafı dizi yazımıyla yazarsak:
)

---
    char[] bir_dilim = "merhaba";  $(DERLEME_HATASI)
---

$(P
O kod da derlenemez. Bunun iki nedeni vardır:
)

$(OL
$(LI $(STRING "merhaba") gibi kodun içine hazır olarak yazılan dizgilerin türü $(C string)'dir ve bu yüzden değişmezdirler.
)
$(LI Türü $(C char[]) olan sol taraf, sağ tarafın bir $(I dilimidir).
)
)

$(P
Bir önceki bölümden hatırlayacağınız gibi, sol taraf sağ tarafı gösteren  bir dilim olarak algılanır. $(C char[]) değişebilir ve $(C string) değişmez olduğu için de burada bir uyumsuzluk oluşur: derleyici, değişebilen bir dilim ile değişmez bir diziye erişilmesine izin vermemektedir.
)

$(P
Bu durumda yapılması gereken, değişmez dizinin bir kopyasını almaktır. Bir önceki bölümde gördüğümüz $(C .dup) niteliğini kullanarak:
)

---
import std.stdio;

void main() {
    char[] dizgi = "merhaba"$(HILITE .dup);
    dizgi[0] = 'M';
    writeln(dizgi);
}
---

$(P
Derlenir ve dizginin baş harfi değişir:
)

$(SHELL
Merhaba
)

$(P
Benzer şekilde, örneğin $(C string) gereken yerde de $(C char[]) kullanılamaz. Değişebilen $(C char[]) türünden, değiştirilemeyen $(C string) türünü üretmek için de $(C .idup) niteliğini kullanmak gerekebilir. $(C s)'nin türü $(C char[]) olduğunda aşağıdaki satır derlenemez:
)

---
    string sonuç = s ~ '.';    $(DERLEME_HATASI)
---

$(P
$(C s)'nin türü $(C char[]) olduğu için sağ taraftaki sonucun türü de $(C char[])'dır. Bütün o sonuç kullanılarak değişmez bir dizgi elde etmek için $(C .idup) kullanılabilir:
)

---
    string sonuç = (s ~ '.')$(HILITE .idup);
---

$(H5 $(IX length, dizgi) Dizgilerin şaşırtıcı olabilen uzunlukları)

$(P
Unicode karakterlerinin bazılarının birden fazla baytla gösterildiklerini ve Türk alfabesine özgü harflerin iki baytlık olduklarını görmüştük. Bu bazen şaşırtıcı olabilir:
)

---
    writeln("aĞ".length);
---

$(P
"aĞ" dizgisi 2 harf içerdiği halde dizinin uzunluğu 3'tür:
)

$(SHELL
3
)

$(P
Bunun nedeni, "merhaba" şeklinde yazılan hazır dizgilerin eleman türünün $(C char) olmasıdır. $(C char) da UTF-8 kod birimi olduğu için, o dizginin uzunluğu 3'tür (a için tek, Ğ için iki kod birimi).
)

$(P
Bunun görünür bir etkisi, iki baytlık bir harfi tek baytlık bir harfle değiştirmeye çalıştığımızda karşımıza çıkar:
)

---
    char[] d = "aĞ".dup;
    writeln("Önce: ", d);
    d[1] = 't';
    writeln("Sonra:", d);
---

$(SHELL
Önce: aĞ
Sonra:at�    $(SHELL_NOTE_WRONG YANLIŞ)
)

$(P
O kodda dizginin 'Ğ' harfinin 't' harfi ile değiştirilmesi istenmiş, ancak 't' harfi tek bayttan oluştuğu için 'Ğ'yi oluşturan baytlardan ancak birincisinin yerine geçmiş ve ikinci bayt çıktıda belirsiz bir karaktere dönüşmüştür.
)

$(P
O yüzden, bazı başka programlama dillerinin normal karakter türü olan $(C char)'ı D'de bu amaçla kullanamayız. (Aynı sakınca $(C wchar)'da da vardır.) Unicode'un tanımladığı anlamda harflerle, imlerle, ve diğer simgelerle ilgilendiğimiz durumlarda $(C dchar) türünü kullanmamız gerekir:
)

---
    dchar[] d = "aĞ"d.dup;
    writeln("Önce: ", d);
    d[1] = 't';
    writeln("Sonra:", d);
---

$(SHELL
Önce: aĞ
Sonra:at
)

$(P
Doğru çalışan kodda iki değişiklik yapıldığına dikkat edin:
)
$(OL
$(LI Dizginin türü $(C dchar[]) olarak belirlenmiştir.)
$(LI $(STRING "aĞ"d) hazır dizgisinin sonunda $(C d) belirteci kullanılmıştır.)
)

$(P
Buna rağmen, $(C dchar[]) ve $(C dstring) kullanımı karakterlerle ilgili bütün sorunları çözemez. Örneğin, kullanıcının girdiği "aĞ" dizgisinin uzunluğu 2 olmayabilir çünkü örneğin 'Ğ' tek Unicode karakteri olarak değil, 'G' ve sonrasında gelen $(I birleştirici) $(ASIL combining) breve şapkası olarak kodlanmış olabilir. Unicode ile ilgili bu tür sorunlardan kaçınmanın en kolay yolu bir Unicode kütüphanesi kullanmaktır.
)

$(H5 $(IX hazır dizgi) Hazır dizgiler)

$(P
Hazır dizgilerin özellikle belirli bir karakter türünden olmasını sağlamak için sonlarına belirleyici karakterler eklenir:
)

---
import std.stdio;

void main() {
     string s = "aĞ"c;   // bu, "aĞ" ile aynı şeydir
    wstring w = "aĞ"w;
    dstring d = "aĞ"d;

    writeln(s.length);
    writeln(w.length);
    writeln(d.length);
}
---

$(SHELL
3
2
2
)

$(P
a ve Ğ harflerinin her ikisi de $(C wchar) ve $(C dchar) türlerinden tek bir elemana sığabildiklerinden son iki dizginin uzunlukları 2 olmaktadır.
)

$(H5 $(IX birleştirmek, dizgi) Dizgi birleştirmek)

$(P
Dizgiler aslında dizi olduklarından, dizi işlemleri onlar için de geçerlidir. İki dizgiyi birleştirmek için $(C ~) işleci, bir dizginin sonuna başka dizgi eklemek için de $(C ~=) işleci kullanılır:
)

---
import std.stdio;
import std.string;

void main() {
    write("İsminiz? ");
    string isim = strip(readln());

    // Birleştirme örneği:
    string selam = "Merhaba " ~ isim;

    // Sonuna ekleme örneği:
    selam ~= "! Hoşgeldin...";

    writeln(selam);
}
---

$(SHELL
İsminiz? Can
Merhaba Can! Hoşgeldin...
)

$(H5 Dizgileri karşılaştırmak)

$(P
$(I Not: Unicode bütün yazı sistemlerindeki harfleri tanımlasa da onların o yazı sistemlerinde nasıl sıralandıklarını belirlemez. Aşağıdaki işlevleri kullanırken bu konuda beklenmedik sonuçlarla karşılaşabilirsiniz.)
)

$(P
Daha önce sayıların küçüklük büyüklük karşılaştırmalarında kullanılan $(C <), $(C >=), vs. işleçlerini görmüştük. Aynı işleçleri dizgilerle de kullanabiliriz. Bu işleçlerin $(I küçüklük) kavramı dizgilerde alfabetik sırada $(I önce) anlamındadır. Benzer şekilde, büyüklük de alfabetik sırada $(I sonra) demektir:
)

---
import std.stdio;
import std.string;

void main() {
    write("     Bir dizgi giriniz: ");
    string dizgi_1 = strip(readln());

    write("Bir dizgi daha giriniz: ");
    string dizgi_2 = strip(readln());

    if (dizgi_1 $(HILITE ==) dizgi_2) {
        writeln("İkisi aynı!");

    } else {
        string önceki;
        string sonraki;

        if (dizgi_1 $(HILITE <) dizgi_2) {
            önceki = dizgi_1;
            sonraki = dizgi_2;

        } else {
            önceki = dizgi_2;
            sonraki = dizgi_1;
        }

        writeln("Sıralamada önce '", önceki,
                "', sonra '", sonraki, "' gelir.");
    }
}
---

$(H5 Büyük küçük harfler farklıdır)

$(P
Harflerin büyük ve küçük hallerinin farklı karakter kodlarına sahip olmaları onların birbirlerinden farklı oldukları gerçeğini de getirir. Örneğin 'A' ile 'a' farklı harflerdir.
)

$(P
Ek olarak, ASCII tablosundaki kodlarının bir yansıması olarak, büyük harflerin hepsi, sıralamada küçük harflerin hepsinden önce gelir. Örneğin büyük olduğu için 'B', sıralamada 'a'dan önce gelir. Aynı şekilde, "aT" dizgisi, 'T' harfi 'ç'den önce olduğu için "aç" dizgisinden önce sıralanır.
)

$(P
Bazen dizgileri harflerin küçük veya büyük olmalarına bakmaksızın karşılaştırmak isteriz. Böyle durumlarda yukarıda gösterilen aritmetik işleçler yerine, $(C std.string.icmp) işlevi kullanılabilir.
)

$(H5 std.string modülü)

$(P
$(C std.string) modülü dizgilerle ilgili işlevler içerir. Bu işlevlerin tam listesini $(LINK2 http://dlang.org/phobos/std_string.html, kendi belgesinde) bulabilirsiniz.
)

$(P
Oradaki işlevler arasından bir kaç tanesi:
)

$(UL

$(LI $(C indexOf): Verilen karakteri bir dizgi içinde baştan sona doğru arar ve bulursa bulduğu yerin indeksini, bulamazsa -1 değerini döndürür. Seçime bağlı olarak bildirilebilen üçüncü parametre, küçük büyük harf ayrımı olmadan aranmasını sağlar)

$(LI $(C lastIndexOf): $(C indexOf)'a benzer şekilde çalışır. Farkı, sondan başa doğru aramasıdır
)

$(LI $(C countChars): Birinci dizgi içinde ikinci dizgiden kaç tane bulunduğunu sayar
)

$(LI $(C toLower): Verilen dizginin, bütün harfleri küçük olan eşdeğerini döndürür
)

$(LI $(C toUpper): $(C toLower)'a benzer şekilde çalışır. Farkı, büyük harf kullanmasıdır
)

$(LI $(C strip): Dizginin başındaki ve sonundaki boşlukları siler
)

$(LI $(C insert): Dizginin içine başka dizgi yerleştirir
)

)

$(P
Dizgiler de aslında dizi olduklarından, diziler için yararlı işlevler içeren $(C std.array), $(C std.algorithm) ve $(C std.range) modüllerindeki işlevler de dizgilerle kullanılabilir.
)

$(PROBLEM_COK

$(PROBLEM
$(LINK2 http://dlang.org/phobos/std_string.html, std.string modülünün belgesini) inceleyin.
)

$(PROBLEM
$(C ~) işlecini de kullanan bir program yazın: Kullanıcı bütünüyle küçük harflerden oluşan ad ve soyad girsin; program önce bu iki kelimeyi aralarında boşluk olacak şekilde birleştirsin ve sonra baş harflerini büyütsün. Örneğin "ebru" ve "domates" girildiğinde programın çıktısı "Ebru&nbsp;Domates" olsun.
)

$(PROBLEM
Kullanıcıdan bir satır alın. Satırın içindeki ilk 'a' harfinden, satırın içindeki son 'a' harfine kadar olan bölümü yazdırsın. Örneğin kullanıcı "balıkadam" dizgisini girdiğinde ekrana "alıkada" yazdırılsın.

$(P
Bu programda $(C indexOf) ve $(C lastIndexOf) işlevlerini kullanarak iki değişik indeks bulmanız, ve bu indekslerle bir dilim oluşturmanız işe yarayabilir.
)

$(P
$(C indexOf) ve $(C lastIndexOf) işlevlerinin dönüş türleri $(C int) değil, $(C ptrdiff_t)'dir. İlk 'a' harfini bulmak için şöyle bir satır kullanabilirsiniz:
)

---
    ptrdiff_t ilk_a = indexOf(satır, 'a');
---

$(P
Bir kaç bölüm sonra göreceğimiz $(C auto) anahtar sözcüğü ile daha da kısa olabilir:
)

---
    auto ilk_a = indexOf(satır, 'a');
---

)

)

Macros:
        SUBTITLE=Dizgiler

        DESCRIPTION=D dilinde dizgilerin ve dizgi işlemlerinin tanıtılması

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial dizgi string

SOZLER=
$(akim)
$(degismez)
$(dilim)
$(dizgi)
$(dizi)
$(hazir_veri)
$(islev)
$(karakter)
$(parametre)
$(phobos)
$(takma_isim)
