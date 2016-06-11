Ddoc

$(DERS_BOLUMU $(IX dosya) Dosyalar)

$(P
Ne kadar güçlü olsalar da, önceki bölümde uç birimlerde kullanıldıklarını gördüğümüz $(C >), $(C <), ve $(C |) karakterleri her duruma uygun değildir. Çünkü her program işini yalnızca standart giriş ve çıkışla etkileşerek yapamaz.
)

$(P
Örneğin öğrenci kayıtları ile ilgilenen bir program, standart çıkışını kullanıcıya bir komut menüsü göstermek için kullanıyor olabilir. Standart girişini de kullanıcıdan komut almak için kullandığını düşünürsek, böyle bir programın kayıtlarını tuttuğu öğrenci bilgilerini yazmak için en az bir dosyaya ihtiyacı olacaktır.
)

$(P
Bu bölümde dosya sisteminin klasörlerde barındırdığı dosyalara yazmayı ve dosyalardan okumayı öğreneceğiz.
)

$(H5 Temel kavramlar)

$(P
Dosya işlemleri için $(C std.stdio) modülünde tanımlanmış olan $(C File) $(I yapısı) kullanılır. Henüz yapıları göstermediğim için $(C File) nesnelerinin $(I kurulma) söz diziminin ayrıntısına girmeyeceğim ve şimdilik bir kalıp olarak kabul etmenizi bekleyeceğim.
)

$(P
Kullanımlarına geçmeden önce dosyalarla ilgili temel kavramların açıklanması gerekir.
)

$(H6 Karşı taraf)

$(P
Bu bölümdeki bilgilerle oluşturulan dosyaların başka ortamlarda hemen okunabileceklerini düşünmeyin. Dosyayı oluşturan taraf ile dosyayı kullanan tarafın en azından dosya düzeni konusundan anlaşmış olmaları gerekir. Örneğin öğrenci numarasının ve isminin dosyaya yazıldıkları sırada okunmaları gerekir.
)

$(P
Bir dosya oluşturup içine bilgiler yazmak, o dosyanın başka bir ortamda açılıp okunması için yeterli olmayabilir. Dosyayı yazan tarafla okuyan tarafın belirli konularda anlaşmış olmaları gerekir. Örneğin dosyaya $(C char[]) olarak yazılmış olan bir bilginin $(C wchar[]) olarak okunması yanlış sonuç doğurur.
)

$(P
Ek olarak, aşağıdaki kodlar dosyaların başına BOM belirtecini yazmazlar. Bu, dosyalarınızın BOM belirteci gerektiren ortamlarda doğru olarak açılamamasına neden olabilir. ("Byte order  mark"ın kısası olan BOM, karakterleri oluşturan UTF kod birimlerinin dosyaya hangi sırada yazılmış olduklarını belirtir.)
)

$(H6 Dosya erişim hakları)

$(P
Dosya sistemi dosyaları programlara çeşitli erişim haklarıyla sunar. Erişim hakları hem performans hem de dosya sağlığı açısından önemlidir.
)

$(P
Konu $(I dosyadan okumak) olunca; aynı dosyadan okumak isteyen birden fazla programa aynı anda okuma izni verilmesi, programlar birbirlerini beklemeyecekleri için hız kazancı sağlar. Öte yandan, konu $(I dosyaya yazmak) olunca; dosyanın içeriğinin tutarlılığı açısından dosyaya belirli bir anda ancak tek bir programın yazmasına izin verilmelidir; yoksa iki programın birbirlerinden habersiz olarak yazmaları sonucunda dosyanın içeriği tutarsız hale gelebilir.
)

$(H6 Dosya açmak)

$(P
Programın standart giriş ve çıkış akımları olan $(C stdin) ve $(C stdout), program başladığında zaten $(I açılmış) ve kullanıma hazır olarak gelirler; onları kullanmaya başlamadan önce özel bir işlem gerekmez.
)

$(P
Dosyaların ise diskteki isimleri ve istenen erişim hakları bildirilerek program tarafından açılmaları gerekir. Aşağıdaki örneklerde de göreceğimiz gibi, oluşturulan bir $(C File) nesnesi, belirtilen isimdeki dosyanın açılması için yeterlidir:
)

---
    File dosya = File("ogrenci_bilgisi", "r");
---

$(H6 Dosya kapatmak)

$(P
Açılan dosyaların mutlaka kapatılmaları da gerekir. Ancak, $(C File) nesneleri kendileri sonlanırken erişim sağlamakta oldukları asıl dosyaları da kapattıkları için, normalde bu işin programda açıkça yapılması gerekmez. Dosya, $(C File) nesnesinin içinde bulunduğu kapsamdan çıkılırken kendiliğinden kapatılır:
)

---
if (bir_koşul) {

    // File nesnesi burada oluşturulmuş ve kullanılmış olsun
    // ...

} // ← Dosya bu kapsamdan çıkılırken otomatik olarak
  //   kapatılır. Açıkça kapatmaya gerek yoktur.
---

$(P
Bazen aynı $(C File) nesnesinin başka dosyayı veya aynı dosyayı farklı erişim haklarıyla kullanması istenir. Böyle durumlarda dosyanın kapatılıp tekrar açılması gerekir:
)

---
    dosya.close();                       // dosyayı kapatır
    dosya.open("ogrenci_bilgisi", "r");  // dosyayı açar
---

$(H6 Dosyaya yazmak ve dosyadan okumak)

$(P
Dosyalar da karakter akımları olduklarından, $(C writeln) ve $(C readf) gibi işlevler onlarla da kullanılabilir. Farklı olan, dosya değişkeninin isminin ve bir noktanın da yazılmasının gerekmesidir:
)

---
    writeln("merhaba");        // standart çıkışa yazar
    stdout.writeln("merhaba"); // yukarıdakinin uzun yazımıdır
    $(HILITE dosya.)writeln("merhaba");  // dosyaya yazar
---

$(H6 $(IX eof) Dosya sonu için $(C eof()))

$(P
Bir dosyadan okurken dosyanın sonuna gelinip gelinmediği, "dosya sonu" anlamına gelen "end of file"ın kısaltması olan $(C eof()) üye işleviyle denetlenir. Bu işlev dosya sonuna gelindiğinde $(C true) döndürür.
)

$(P
Örneğin, aşağıdaki döngü dosyanın sonuna gelene kadar devam eder:
)

---
    while (!dosya.eof()) {
        // ...
    }
---

$(H6 $(IX std.file) Klasör işlemleri için $(C std.file) modülü)

$(P
Klasör işlemleri ile ilgili olan $(C std.file) modülünün $(LINK2 http://dlang.org/phobos/std_file.html, belgesinde) işinize yarayacak işlevler bulabilirsiniz. Örneğin, $(C exists) belirtilen isimdeki dosyanın mevcut olup olmadığını bildirir:
)

---
    if (exists(dosya_ismi)) {
        // dosya mevcut

    } else {
        // dosya mevcut değil
    }
---

$(H5 $(IX File) $(C std.stdio.File) yapısı)

$(P
$(IX erişim belirteci, dosya) $(C File), C dilindeki standart $(C fopen) işlevinin kullandığı erişim belirteçlerini kullanır:
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr align="center"><th scope="col">&nbsp;Belirteç&nbsp;</th> <th scope="col">Anlamı</th></tr>

<tr><td align="center">r</td><td>$(B okuma) erişimi$(BR)dosya başından okunacak şekilde hazırlanır</td></tr>

<tr><td align="center">r+</td><td>$(B okuma ve yazma) erişimi$(BR)dosya başından okunacak ve başına yazılacak şekilde hazırlanır</td></tr>

<tr><td align="center">w</td><td>$(B yazma) erişimi$(BR)dosya yoksa: boş olarak oluşturulur$(BR)dosya zaten varsa: içi boşaltılır</td></tr>

<tr><td align="center">w+</td><td>$(B okuma ve yazma) erişimi$(BR)dosya yoksa: boş olarak oluşturulur$(BR)dosya zaten varsa: içi boşaltılır</td></tr>

<tr><td align="center">a</td><td>$(B sonuna yazma) erişimi$(BR)dosya yoksa: boş olarak oluşturulur$(BR)dosya zaten varsa: içeriği korunur ve sonuna yazılacak şekilde hazırlanır</td></tr>

<tr><td align="center">a+</td><td>$(B okuma ve sonuna yazma) erişimi$(BR)dosya yoksa: boş olarak oluşturulur$(BR)dosya zaten varsa: içeriği korunur; başından okunacak ve sonuna yazılacak şekilde hazırlanır</td></tr>
</table>

$(P
Yukarıdaki erişim haklarının sonuna 'b' karakteri de gelebilir ("rb" gibi). O karakter $(I binary mode) açma durumunu destekleyen platformlarda etkili olabilir ama POSIX ortamlarında gözardı edilir.
)

$(H6 Dosyaya yazmak)

$(P
Dosyanın önce yazma erişimi ile açılmış olması gerekir:
)

---
import std.stdio;

void main() {
    File dosya = File("ogrenci_bilgisi", $(HILITE "w"));

    dosya.writeln("İsim  : ", "Zafer");
    dosya.writeln("Numara: ", 123);
    dosya.writeln("Sınıf : ", "1A");
}
---

$(P
$(LINK2 /ders/d/dizgiler.html, Dizgiler bölümünden) hatırlayacağınız gibi, "ogrenci_bilgisi" gibi bir dizginin türü $(C string)'dir ve $(I değişmezdir). Yani $(C File), dosya ismini ve erişim hakkını $(C string) türü olarak kabul eder. Bu yüzden, yine o bölümden hatırlayacağınız gibi, $(C File) örneğin $(C char[]) türünde bir dizgi ile kurulamaz; kurmak gerektiğinde o dizginin $(C .idup) niteliğinin çağrılması gerekir.
)

$(P
Yukarıdaki program, çalıştırıldığı klasör içinde ismi $(C ogrenci_bilgisi) olan bir dosya oluşturur veya var olan dosyanın üzerine yazar.
)

$(P
$(I Not: Dosya ismi olarak dosya sisteminin izin verdiği her karakteri kullanabilirsiniz. Ben bu kitapta dosya isimlerinde yalnızca ASCII harfler kullanacağım.)
)

$(H6 Dosyadan okumak)

$(P
Dosyanın önce okuma erişimi ile açılmış olması gerekir:
)

---
import std.stdio;
import std.string;

void main() {
    File dosya = File("ogrenci_bilgisi", $(HILITE "r"));

    while (!dosya.eof()) {
        string satır = strip(dosya.readln());
        writeln("Okuduğum satır -> |", satır);
    }
}
---

$(P
Yukarıdaki program, çalıştırıldığı klasör içindeki $(C ogrenci_bilgisi) isimli dosyanın içindeki satırları başından sonuna kadar okur ve standart çıkışa yazdırır.
)

$(PROBLEM_TEK

$(P
Yazacağınız program kullanıcıdan bir dosya ismi alsın, o dosyanın içindeki $(I boş olmayan) bütün satırları, dosyanın ismine $(C .bak) eklenmiş başka bir dosyaya yazsın. Örneğin, verilen dosyanın ismi $(C deneme.txt) ise, boş olmayan satırlarını $(C deneme.txt.bak) dosyasına yazsın.
)

)

Macros:
        SUBTITLE=Dosyalar

        DESCRIPTION=D dilinde dosyaların ve dosya işlemlerinin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial dosya

SOZLER=
$(akim)
$(bom)
$(degismez)
$(kapsam)
$(klasor)
$(kurma)
$(nesne)
$(standart_cikis)
$(standart_giris)
$(uc_birim)
$(uye_islev)
$(yapi)
