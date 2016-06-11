Ddoc

$(DERS_BOLUMU $(IX programın çevresi) $(IX çevre, program) $(IX ortam, program) Programın Çevresiyle Etkileşimi)

$(P
$(IX main) İşlevleri anlatırken $(C main)'in de bir işlev olduğunu söylemiştim. Programın işleyişi $(C main)'le başlar ve oradan başka işlevlere dallanır. $(C main)'in şimdiye kadar gördüğümüz tanımı şöyleydi:
)

---
void main() {
    // ...
}
---

$(P
O tanıma bakarak $(C main)'in bir değer döndürmediğini ve hiçbir parametre almadığını düşünürüz. Aslında bu mümkün değildir, çünkü programı başlatan ortam bir dönüş değeri bekler; $(C main), $(C void) döndürüyor gibi yazılmış olsa da aslında bir değer döndürür.
)

$(H5 $(C main)'in dönüş değeri)

$(P
Programlar her zaman için başka bir ortam tarafından başlatılırlar. Bu ortam, programı ismini yazıp Enter'a basarak başlattığımız uç birim olabilir, menülerindeki "Çalıştır" gibi bir komutla başlattığımız bir geliştirme ortamı olabilir, programı kendisi başlatan başka bir program olabilir, vs.
)

$(P
Program kendisini başlatan bu ortama işini başarıyla tamamlayıp tamamlamadığı bilgisini $(C main)'in dönüş değeri olarak bildirir.
)

$(P
Programın dönüş değeri olarak 0 değeri programın başarıyla sonuçlandığını, 0'dan başka bir değer ise programın çalışması sırasında bir hata oluştuğunu bildirmek için kullanılır. İstediğimiz değeri döndürmek bize kalmış olsa da, 0'ın $(I başarı) anlamına gelmesi standartlaşmıştır.
)

$(P $(I Not: Dönüş değeri olarak ancak [0,127] aralığındaki tamsayılara güvenebilirsiniz. Bunun dışındaki değerler her ortam tarafından desteklenmiyor olabilir.
))

$(P
Sıfırdan başka değerler her programa göre değişik anlamlar taşıyabilir. Örneğin Unix türevi ortamlarda dosyaları listelemek için kullanılan $(C ls) programı önemsiz hatalarda 1 değerini, ciddi hatalarda ise 2 değerini döndürür. Komut satırından başlatılan programların dönüş değerleri $(C $?) ortam değişkeninden okunabilir. Örneğin klasörde bulunmayan bir dosyayı görmek istediğimizde, programın dönüş değeri komut satırında $(C $?) değişkeninden aşağıdaki gibi okunabilir.
)

$(P
$(I Not: Aşağıdaki komut satırı örneklerinde $(C #) karakteriyle başlayan satırlar kullanıcın yazdığı satırları gösteriyor. Aynı adımları denemek istediğinizde o satırları $(C #) karakteri dışında sizin yazarak Enter'a basmanız gerekir. O satırları daha koyu olarak gösterdim.)
)

$(P $(I Ek olarak, aşağıdaki örnekler bir Linux ortamında denenmiş olsalar da, benzerlerini örneğin Windows DOS pencerelerinde de kullanabilirsiniz.)
)

$(SHELL
# ls klasorde_bulunmayan_bir_dosya
$(DARK_GRAY ls: klasorde_bulunmayan_bir_dosya: No such file or directory)
# $(HILITE echo $?)
$(DARK_GRAY 2)      $(SHELL_NOTE ls'in dönüş değeri)
)

$(H6 Dönüş değeri $(C void) olan $(C main)'ler de değer üretirler)

$(P
Şimdiye kadar karşılaştığımız işlevlerin bazılarının işlerini yapamayacakları durumlara düştüklerinde hata attıklarını görmüştük. Şimdiye kadar gördüğümüz kadarıyla, hata atıldığı zaman program bir $(C object.Exception) mesajıyla sonlanıyordu.
)

$(P
Bu gibi durumlarda, $(C main)'in dönüş türü olarak $(C void) kullanılmış olsa bile, yani $(C main) bir değer döndürmeyecekmiş gibi yazılmış olsa bile, programı çalıştıran ortama otomatik olarak 1 değeri döndürülür. Bunu görmek için hata atarak sonlanan şu basit programı çalıştıralım:
)

---
void main() {
    throw new Exception("Bir hata oldu");
}
---

$(P
Dönüş türü $(C void) olarak tanımlandığı halde programı çalıştıran ortama 1 değeri döndürülmüştür:
)

$(SHELL
# ./deneme
$(DARK_GRAY object.Exception: Bir hata oldu)
# echo $?
$(DARK_GRAY $(HILITE 1))
)

$(P
Benzer şekilde, dönüş türü $(C void) olarak tanımlanmış olan $(C main) işlevleri başarıyla sonlandıklarında, otomatik olarak dönüş değeri olarak 0 üretirler. Bu sefer $(I başarıyla sonlanan) şu programa bakalım:
)

---
import std.stdio;

void main() {
    writeln("Başardım!");
}
---

$(P
Bu program dönüş değeri olarak 0 üretmiştir:
)

$(SHELL
# ./deneme
$(DARK_GRAY Başardım!)
# echo $?
$(DARK_GRAY $(HILITE 0))
)

$(H6 Dönüş değerini belirlemek)

$(P
Kendi programlarımızdan değer döndürmek, başka işlevlerde de olduğu gibi, $(C main)'i dönüş türünü $(C int) olarak tanımlamak ve bir $(C return) deyimi kullanmak kadar basittir:
)

---
import std.stdio;

$(HILITE int) main() {
    int sayı;
    write("Lütfen 3-6 arasında bir sayı giriniz: ");
    readf(" %s", &sayı);

    if ((sayı < 3) || (sayı > 6)) {
        $(HILITE stderr).writeln("HATA: ", sayı, " uygun değil!");
        $(HILITE return 111);
    }

    writeln("Teşekkür: ", sayı);

    $(HILITE return 0);
}
---

$(P
Programın isminin $(C deneme) olduğunu kabul edersek ve istenen aralıkta bir sayı verildiğinde programın dönüş değeri 0 olur:
)

$(SHELL
# ./deneme
$(DARK_GRAY Lütfen 3-6 arasında bir sayı giriniz: 5
Teşekkür: 5)
# echo $?
$(DARK_GRAY $(HILITE 0))
)

$(P
Aralığın dışında bir sayı verildiğinde ise programın dönüş değeri 111 olur:
)

$(SHELL
# ./deneme
$(DARK_GRAY Lütfen 3-6 arasında bir sayı giriniz: 10
HATA: 10 uygun değil!)
# echo $?
$(DARK_GRAY $(HILITE 111))
)

$(P
Normalde hata için 1 değerini kullanmak yeterlidir. Ben yalnızca örnek olması için özel bir nedeni olmadan 111 değerini seçtim.
)

$(H5 $(IX stderr) Standart hata akımı $(C stderr))

$(P
Yukarıdaki programda $(C stderr) akımını kullandım. Bu akım, standart akımların üçüncüsüdür ve programın hata mesajlarını yazmak için kullanılır:
)

$(UL
$(LI $(C stdin): standart giriş akımı)
$(LI $(C stdout): standart çıkış akımı)
$(LI $(C stderr): standart hata akımı)
)

$(P
Programlar uç birimde başlatıldıklarında $(C stdout) ve $(C stderr) akımlarına yazılanlar normalde ekranda belirirler. Bu akımlara yazılan mesajları istendiğinde ayrı ayrı elde etmek de mümkündür.
)

$(H5 $(C main)'in parametreleri)

$(P
Bazı programlar kendilerini başlatan ortamlardan parametre alabilirler. Örneğin yukarıda gördüğümüz $(C ls) programı parametresiz olarak yalnızca $(C ls) yazarak başlatılabilir:
)

$(SHELL
# ls
$(DARK_GRAY deneme
deneme.d)
)

$(P
İsteğe bağlı olarak da bir veya daha çok parametreyle başlatılabilir. Bu parametrelerin anlamları bütünüyle programa bağlıdır ve o programın belgelerinde belirtilmiştir:
)

$(SHELL
# ls $(HILITE -l deneme)
$(DARK_GRAY -rwxr-xr-x 1 acehreli users 460668 Nov  6 20:38 deneme)
)

$(P
D programlarını başlatırken kullanılan parametreler $(C main)'e bir $(C string) dizisi olarak gönderilirler. $(C main)'i $(C string[]) parametre alacak şekilde tanımlamak bu parametrelere erişmek için yeterlidir. Aşağıdaki program kendisine verilen parametreleri çıkışına yazdırıyor:
)

---
import std.stdio;

void main($(HILITE string[] parametreler)) {
    foreach (i, parametre; parametreler) {
        writefln("%3s numaralı parametre: %s", i, parametre);
    }
}
---

$(P
Rasgele parametrelerle şöyle başlatılabilir:
)

$(SHELL
# ./deneme komut satirina yazilan parametreler 42 --bir_secenek
$(DARK_GRAY&nbsp;&nbsp;0 numaralı parametre: ./deneme
&nbsp;&nbsp;1 numaralı parametre: komut
&nbsp;&nbsp;2 numaralı parametre: satirina
&nbsp;&nbsp;3 numaralı parametre: yazilan
&nbsp;&nbsp;4 numaralı parametre: parametreler
&nbsp;&nbsp;5 numaralı parametre: 42
&nbsp;&nbsp;6 numaralı parametre: --bir_secenek)
)

$(P
Parametre dizisinin ilk elemanı her zaman için program başlatılırken kullanılan program ismidir. Diğer parametreler bu dizinin geri kalan elemanlarıdır.
)

$(P
Bu parametrelerle ne yapacağı tamamen programa kalmıştır. Örneğin kendisine verilen iki sözcüğü ters sırada yazdıran bir program:
)

---
import std.stdio;

int main(string[] parametreler) {
    if (parametreler.length != 3) {
        stderr.writeln("HATA! Doğru kullanım:\n    ",
                       parametreler[0],
                       " bir_sözcük başka_sözcük");
        return 1;
    }

    writeln(parametreler[2], ' ', parametreler[1]);

    return 0;
}
---

$(P
Bu program gerektiğinde doğru kullanımını da gösteriyor:
)

$(SHELL
# ./deneme
$(DARK_GRAY HATA! Doğru kullanım:
    ./deneme bir_sözcük başka_sözcük)
# ./deneme dünya merhaba
$(DARK_GRAY merhaba dünya)
)

$(H5 $(IX program seçenekleri) $(IX komut satırı seçenekleri) $(IX seçenek, program) $(IX getopt, std.getopt) Program seçenekleri ve $(C std.getopt) modülü)

$(P
$(C main)'in parametreleriyle ve dönüş değeriyle ilgili olarak bilinmesi gerekenler aslında bu kadardır. Ancak parametreleri teker teker listeden ayıklamak zahmetli olabilir. Onun yerine, bu konuda yardım alabileceğimiz $(C std.getopt) modülünün bir kullanımını göstereceğim.
)

$(P
Bazı parametreler program tarafından bilgi olarak kullanılırlar. Örneğin yukarıdaki programa verilen "dünya" ve "merhaba" parametreleri, o programın ekrana yazdıracağı bilgiyi belirliyordu.
)

$(P
Bazı parametreler ise programın işini nasıl yapacağını belirlerler; bunlara $(I program seçeneği) denir. Örneğin yukarıda kullandığımız $(C ls) programına komut satırında seçenek olarak $(C -l) vermiştik.
)

$(P
Program seçenekleri programların kullanışlılıklarını arttırırlar. Böylece, programın istediği parametreler bir insan tarafından teker teker komut satırından yazılmak yerine örneğin bir betik program içinden verilebilirler.
)

$(P
Komut satırı parametrelerinin ne oldukları ve ne anlama geldikleri her ne kadar tamamen programa bağlı olsalar da onların da bir standardı gelişmiştir. POSIX standardına uygun bir kullanımda, her seçenek $(C --) ile başlar, seçenek ismi bunlara bitişik olarak yazılır, ve seçenek değeri de bir $(C =) karakterinden sonra gelir:
)

$(SHELL
# ./deneme --bir_secenek=17
)

$(P
Phobos'un $(C std.getopt) modülü, programa parametre olarak verilen bu tür seçeneklerin ayıklanmasında yardımcı olur. Ben burada fazla ayrıntısına girmeden $(C getopt) işlevinin kısa bir kullanımını göstereceğim.
)

$(P
Çıkışına rasgele seçtiği sayıları yazdıran bir program tasarlayalım. Kaç tane sayı yazdıracağı ve sayıların değerlerinin hangi aralıkta olacağı programa komut satırından seçenekler olarak verilsin. Program örneğin şu şekilde başlatılabilsin:
)

$(SHELL
# ./deneme --adet=7 --en-kucuk=10 --en-buyuk=15
)

$(P
$(C getopt) işlevi bu değerleri program parametreleri arasında bulmakta yararlıdır. $(C getopt)'un okuduğu değerlerin hangi değişkenlere yazılacakları $(C readf) kullanımından tanıdığımız $(C &) karakteriyle bir $(I gösterge) olarak bildirilir:
)

---
import std.stdio;
$(HILITE import std.getopt;)
import std.random;

void main(string[] parametreler) {
    int adet;
    int enKüçükDeğer;
    int enBüyükDeğer;

    $(HILITE getopt)(parametreler,
           "adet", $(HILITE &)adet,
           "en-kucuk", $(HILITE &)enKüçükDeğer,
           "en-buyuk", $(HILITE &)enBüyükDeğer);

    foreach (i; 0 .. adet) {
        write(uniform(enKüçükDeğer, enBüyükDeğer + 1), ' ');
    }

    writeln();
}
---

$(SHELL
# ./deneme --adet=7 --en-kucuk=10 --en-buyuk=15
$(DARK_GRAY 11 11 13 11 14 15 10)
)

$(P
Çoğu zaman parametrelerin kestirmeleri de olur. Örneğin $(C --adet) yazmak yerine kısaca $(C -a) yazılır. Seçeneklerin kestirmeleri $(C getopt)'a $(C |) ayracından sonra bildirilir:
)

---
    getopt(parametreler,
           "adet|a", &adet,
           "en-kucuk|k", &enKüçükDeğer,
           "en-buyuk|b", &enBüyükDeğer);
---

$(P
Çoğu zaman kestirme seçenekler için $(C =) karakteri de kullanılmaz:
)

$(SHELL
# ./deneme -a7 -k10 -b15
$(DARK_GRAY 11 13 10 15 14 15 14)
)

$(P
Parametrelerin programa $(C string) türünde geldiklerini görmüştük. $(C getopt) bu dizgileri değişkenlerin türlerine otomatik olarak dönüştürür. Örneğin yukarıdaki programdaki $(C adet)'in $(C int) olduğunu bildiği için, onu $(C string)'den $(C int)'e çevirir. $(C getopt)'u kullanmadığımız zamanlarda bu dönüşümü daha önce de bir kaç kere kullandığımız $(C to) işleviyle kendimiz de gerçekleştirebiliriz.
)

$(P
$(C std.conv) modülünde tanımlanmış olan $(C to)'yu daha önce hep tamsayıları $(C string)'e dönüştürmek için $(C to!string) şeklinde kullanmıştık. $(C string) yerine başka türlere de dönüştürebiliriz. Örneğin 0'dan başlayarak kendisine komut satırından bildirilen sayıda ikişer ikişer sayan bir programda $(C to)'yu şöyle kullanabiliriz:
)

---
import std.stdio;
$(HILITE import std.conv);

void main(string[] parametreler) {
    // Parametre verilmediğinde 10 varsayıyoruz
    size_t adet = 10;

    if (parametreler.length > 1) {
        // Bir parametre verilmiş
        adet = $(HILITE to!size_t(parametreler[1]));
    }

    foreach (i; 0 .. adet) {
        write(i * 2, ' ');
    }

    writeln();
}
---


$(P
Program parametre verilmediğinde 10, verildiğinde ise belirtildiği kadar sayı üretir:
)

$(SHELL
# ./deneme
$(DARK_GRAY 0 2 4 6 8 10 12 14 16 18)
# ./deneme 3
$(DARK_GRAY 0 2 4)
)

$(H5 $(IX ortam değişkeni) Ortam değişkenleri)

$(P
Programları başlatan ortamlar programların yararlanmaları için ortam değişkenleri de sunarlar. Bu değişkenlere $(C std.process) modülündeki $(C environment) topluluğu ile eşleme tablosu arayüzü ile erişilir. Örneğin, çalıştırılacak olan programların hangi klasörlerde arandıklarını belirten $(C PATH) değişkeni aşağıdaki gibi yazdırılabilir:
)

---
import std.stdio;
$(HILITE import std.process;)

void main() {
    writeln($(HILITE environment["PATH"]));
}
---

$(P
Çıktısı:
)

$(SHELL
# ./deneme
$(DARK_GRAY /usr/local/bin:/usr/bin)
)

$(P
$(C std.process.environment) bütün ortam değişkenlerini eşleme tablolarının söz dizimiyle sunar:
)

---
import std.process;
// ...
    writeln(environment["PATH"]);
---

$(P
Buna rağmen kendisi bir eşleme tablosu değildir. Bütün değişkenleri tek eşleme tablosu olarak elde etmek için:
)

---
    string[string] hepsi = environment.toAA();
---

$(H5 Başka programları başlatmak)

$(P
Programlar başka programları başlattıklarında onların $(I ortamları) haline gelirler. Program başlatmaya yarayan işlevler $(C std.process) modülünün olanakları rasındadır.
)

$(P
$(IX executeShell, std.process) Örneğin, $(C executeShell) kendisine parametre olarak verilen dizgiyi sanki komut satırında yazılmış gibi başlatır ve hem programın dönüş değerini hem de çıktısını bir $(I çokuzlu) olarak döndürür. Diziye benzer biçimde kullanılan çokuzluları daha sonra $(LINK2 /ders/d/cokuzlular.html, Çokuzlular bölümünde) göreceğiz:
)

---
import std.stdio;
import std.process;

void main() {
    const sonuç = $(HILITE executeShell)("ls -l deneme");
    const dönüşDeğeri = sonuç[0];
    const çıktısı = sonuç[1];

    writefln("ls programı %s değerini döndürdü.", dönüşDeğeri);
    writefln("Çıktısı:\n%s", çıktısı);
}
---

$(P
Çıktısı:
)

$(SHELL
# ./deneme
$(DARK_GRAY
ls programı 0 değerini döndürdü.
Çıktısı:
-rwxrwxr-x. 1 acehreli acehreli 1352810 Oct  6 15:00 deneme
)
)

$(H5 Özet)

$(UL

$(LI Dönüş türü $(C void) olarak tanımlansa bile $(C main) başarıyla sonlandığında 0, hata ile sonlandığında 1 döndürür.)

$(LI $(C stderr) hata mesajlarını yazmaya uygun olan akımdır.)

$(LI $(C main), $(C string[]) türünde parametre alabilir.)

$(LI $(C std.getopt) modülü program parametrelerini ayrıştırmaya yarar.)

$(LI $(C std.process) modülü ortam değişkenlerine eriştirmeye ve başka programları başlatmaya yarar.)

)

$(PROBLEM_COK

$(PROBLEM
Komut satırından parametre olarak iki değer ve bir işlem karakteri alan bir hesap makinesi yazın. Şöyle çalışsın:

$(SHELL
# ./deneme 3.4 x 7.8
$(DARK_GRAY 26.52)
)

$(P $(I Not: $(C *) karakterinin komut satırında özel bir anlamı olduğu için çarpma işlemi için $(C x) karakterini kullanın. Yine de $(C *) karakterini kullanmak isterseniz komut satırında $(C \*) şeklinde yazmanız gerekir.
)
)

)

$(PROBLEM
Hangi programı başlatmak istediğinizi soran, bu programı başlatan ve çıktısını yazdıran bir program yazın.
)

)

Macros:
        SUBTITLE=Programın Çevresiyle Etkileşimi

        DESCRIPTION=D dilinde programın ana fonksiyonu olan main'in parametreleri, dönüş türü, ve ortam değişkenleri.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function parametre main dönüş değeri

SOZLER=
$(betik)
$(donus_degeri)
$(gosterge)
$(islev)
$(klasor)
$(modul)
$(ortam_degiskeni)
$(parametre)
$(phobos)
$(uc_birim)
