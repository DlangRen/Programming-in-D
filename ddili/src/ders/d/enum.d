Ddoc

$(DERS_BOLUMU $(IX enum) $(CH4 enum))

$(P
$(C enum), "numaralandırmak" anlamına gelen "enumerate"in kısaltılmışıdır. İsimli sabit değerler üretmek için kullanılır.
)

$(H5 $(IX sihirli sabit) Sihirli sabitler)

$(P
Tamsayılar ve Aritmetik İşlemler bölümünün $(LINK2 /ders/d/aritmetik_islemler.cozum.html, problem çözümlerinden) birisinde şöyle bir koşul kullanmıştık:
)

---
        if (işlem == 1) {
            sonuç = birinci + ikinci;

        } else if (işlem == 2) {
            sonuç = birinci - ikinci;

        } else if (işlem == 3) {
            sonuç = birinci * ikinci;

        } else if (işlem == 4) {
            sonuç = birinci / ikinci;
        }
---

$(P
O kod parçasındaki 1, 2, 3, ve 4 değerlerine $(I sihirli sabit) denir. Kodu okuyan birisinin onların ne anlama geldiklerini bir bakışta anlaması olanaksızdır. Örneğin yukarıdaki kodda 1'in $(I toplama işlemi), 2'nin $(I çıkarma işlemi), vs. anlamlarına geldiklerini ancak kapsamlarındaki kodları okuduktan sonra anlayabiliyoruz. Bu durumda şanslıyız, çünkü her kapsamda yalnızca tek satır var; daha karmaşık kodlarda kodu anlamak çok güç olabilir.
)

$(P
Programcılıkta sihirli sabitlerden kaçınılır çünkü onlar iyi yazılmış kodun en önemli niteliklerinden olan $(I okunurluğunu) azaltırlar.
)

$(P
$(C enum) olanağı işte bu tür sabitlere isimler vermeyi ve bu sayede kodun okunurluğunu arttırmayı sağlar. Aynı kod $(C enum) değerleriyle yazıldığında her bir $(C if) koşulunun hangi işlemle ilgili olduğu açıkça anlaşılır:
)

---
        if (işlem == İşlem.toplama) {
            sonuç = birinci + ikinci;

        } else if (işlem == İşlem.çıkarma) {
            sonuç = birinci - ikinci;

        } else if (işlem == İşlem.çarpma) {
            sonuç = birinci * ikinci;

        } else if (işlem == İşlem.bölme) {
            sonuç = birinci / ikinci;

        }
---

$(P
Artık 1 gibi anlamı açık olmayan bir değer yerine $(C İşlem.toplama) gibi isimli bir değer kullanılmaktadır. Bundan sonraki bölümlerdeki kodlarda sihirli sabitler yerine hep isimli sabitler kullanacağım.
)

$(P
Yukarıdaki 1, 2, 3, ve 4 değerlerine karşılık gelen $(C enum) tanımı şöyle yazılır:
)

---
    enum İşlem { toplama = 1, çıkarma, çarpma, bölme }
---

$(H5 Söz dizimi)

$(P
$(C enum) yaygın olarak şu söz dizimiyle kullanılır:
)

---
    enum $(I Türİsmi) { $(I değerİsmi_1), $(I değerİsmi_2), /* vs. */ }
---

$(P
Bazen değerlerin asıl türlerini de belirtmek gerekebilir. Bunun nasıl kullanıldığını bir sonraki başlıkta göreceğiz:
)

---
    enum $(I Türİsmi) $(HILITE : $(I asıl_tür)) { $(I değerİsmi_1), $(I değerİsmi_2), /* vs. */ }
---

$(P
$(C enum) anahtar sözcüğünden sonra bütün değerlerin toplu olarak ne anlama geldiğini belirten bir tür ismi verilir. Bütün olası değerler isimler halinde $(C enum) kapsamı içinde sıralanırlar.
)

$(P
Bir kaç örnek:
)

---
    enum ParaAtışıSonucu { yazı, tura }
    enum OyunKağıdıRengi { maça, kupa, karo, sinek }
    enum BiletTürü { normal, çocuk, öğrenci, emekli }
---

$(P
Bu değerler aynı zamanda yeni bir türün parçaları haline de gelirler. Örneğin $(C yazı) ve $(C tura) artık $(C ParaAtışıSonucu) diye tanımlanmış olan yeni bir türün değerleridir. Bu yeni tür de başka türler gibi değişken tanımlamak için kullanılabilir:
)

---
    ParaAtışıSonucu sonuç;           // otomatik ilklenerek
    auto yt = ParaAtışıSonucu.yazı;  // türü çıkarsanarak
---

$(P
Yukarıdaki kodlarda da olduğu gibi, $(C enum) türlerinin değerleri kod içinde sabit olarak belirtilecekleri zaman ait oldukları türün ismiyle birlikte ve ondan bir nokta ile ayrılarak yazılırlar:
)

---
    if (sonuç == ParaAtışıSonucu.yazı) {
        // ...
    }
---

$(H5 Asıl değerler ve türleri)

$(P
$(C enum) türlerin değerleri arka planda normalde $(C int) olarak gerçekleştirilirler. Yani her ne kadar $(C yazı) ve $(C tura) gibi isimleri olsa da, arka planda birer $(C int) değeridirler. ($(C int)'ten başka türlerin de kullanılabileceğini aşağıda göreceğiz.)
)

$(P
Bu değerler programcı özellikle belirtmediği sürece 0'dan başlar ve her isimli değer için bir tane arttırılır. Örneğin yukarıda tanımlanan $(C ParaAtışıSonucu)'nun iki değerinin sırasıyla 0 ve 1'e eşit olduklarını şöyle gösterebiliriz:
)

---
    writefln("yazı'nın değeri 0: %s", (ParaAtışıSonucu.yazı == 0));
    writefln("tura'nın değeri 1: %s", (ParaAtışıSonucu.tura == 1));
---

$(P
Çıktısı:
)

$(SHELL
yazı'nın değeri 0: true
tura'nın değeri 1: true
)

$(P
Normalde 0'dan başlayan bu değerleri istediğimiz noktadan itibaren $(C =) işareti ile kendimiz de belirleyebiliriz. Yukarıda $(C İşlem.toplama) değerini 1 olarak belirken bundan yararlanmıştık. Belirlediğimiz değerden sonrakilerin değerleri de yine derleyici tarafından birer birer arttırılarak verilir:
)

---
    enum Deneme { a, b, c, ç = 100, d, e, f = 222, g, ğ }
    writefln("%d %d %d", Deneme.b, Deneme.ç, Deneme.ğ);
---

$(P
Çıktısı:
)

$(SHELL
1 100 224
)

$(P
$(C enum) değerlerinin perde arkasında tamsayılardan başka bir tür olması gerektiğinde o tür $(C enum) isminden sonra belirtilir:
)

---
    enum DoğalSabit $(HILITE : double) { pi = 3.14, e = 2.72 }
    enum IsıBirimi $(HILITE : string) { C = "Celcius", F = "Fahrenheit" }
---

$(H5 Bir $(C enum) türüne ait olmayan $(C enum) değerleri)

$(P
Sihirli sabitlerden kurtulmanın önemli olduğunu ve bu amaçla $(C enum)'lardan yararlanabileceğimizi gördük.
)

$(P
Ancak, sihirli sabitlerden kurtulabilmek için ayrıca bir $(C enum) türü belirlemek doğal olmayabilir. Örneğin tek amacımızın 24 saatteki toplam saniye sayısını tutan bir sabit tanımlamak olduğunu düşünelim. Böyle tek sabitin tanımlanmasında ayrıca $(C enum) türü belirlemeye gerek yoktur. Böyle durumlarda $(C enum) türü ve $(C enum) kapsam parantezleri yazılmayabilir:
)

---
    enum günBaşınaSaniye = 60 * 60 * 24;
---

$(P
Artık o sabiti hesaplarda ismiyle kullanabiliriz:
)

---
    toplamSaniye = günAdedi * günBaşınaSaniye;
---

$(P
$(C enum), başka türden hazır değerler tanımlamak için de kullanılabilir. Örneğin isimli bir $(C string) hazır değeri şöyle tanımlanabilir:
)

---
    enum dosyaİsmi = "liste.txt";
---

$(P
$(IX manifest constant) $(IX sabit, manifest) Böyle sabitler $(LINK2 /ders/d/deger_sol_sag.html, $(I sağ değerdirler)) ve İngilizce'de "manifest constant" diye anılırlar.
)

$(H5 Nitelikleri)

$(P
$(C .min) ve $(C .max) nitelikleri $(C enum) türünün sırasıyla en küçük ve en büyük değerleridir. Bunları bir $(C for) döngüsünde kullanarak bütün değerleri sırayla gezebiliriz:
)

---
    enum OyunKağıdıRengi { maça, kupa, karo, sinek }

    for (auto renk = OyunKağıdıRengi.min;
         renk <= OyunKağıdıRengi.max;
         ++renk) {

        writefln("%s: %d", renk, renk);
    }
---

$(P
$(STRING "%s") ve $(STRING "%d") düzen belirteçlerinin çıktılarının farklı olduklarına dikkat edin:
)

$(SHELL
maça: 0
kupa: 1
karo: 2
sinek: 3
)

$(P
Bunun için $(C foreach) döngüsünün uygun olmadığına dikkat edin. $(C foreach) değer aralığı ile kullanılsaydı $(C .max) değeri aralığın dışında kalırdı:
)

---
    foreach (renk; OyunKağıdıRengi.min .. OyunKağıdıRengi.max) {
        writefln("%s: %d", renk, renk);
    }
---

$(P
Çıktısı:
)

$(SHELL
maça: 0
kupa: 1
karo: 2
          $(SHELL_NOTE_WRONG sinek eksik)
)

$(P
$(IX EnumMembers, std.traits) Bu yüzden, bir $(C enum)'ın bütün değerleri üzerinde ilerlemenin doğru bir yolu $(C std.traits) modülünde tanımlı olan $(C EnumMembers) şablonundan yararlanmaktır:
)

---
import std.traits;
// ...
    foreach (renk; $(HILITE EnumMembers!OyunKağıdıRengi)) {
        writefln("%s: %d", renk, renk);
    }
---

$(P
$(I Not: Yukarıdaki $(C !) karakteri şablon parametre değeri bildirmek içindir. Şablonları $(LINK2 /ders/d/sablonlar.html, ilerideki bir bölümde) göreceğiz.)
)

$(SHELL
maça: 0
kupa: 1
karo: 2
sinek: 3  $(SHELL_NOTE sinek mevcut)
)

$(H5 Asıl türden dönüştürmek)

$(P
Yukarıdaki yazdırma örneklerinde görüldüğü gibi, bir $(C enum) değer perde arkasında kullanılan asıl türe (örneğin $(C int)'e) otomatik olarak dönüşür. Bunun tersi doğru değildir:
)

---
    OyunKağıdıRengi renk = 1;      $(DERLEME_HATASI)
---

$(P
Bunun nedeni, $(C enum) değişkenlerine yanlışlıkla geçersiz değerlerin atanmasını önlemektir:
)

---
    renk = 100;   // ← geçerli bir değer olmadığı için
                  //   anlamsız olurdu
---

$(P
Geçerli olduğunu bildiğimiz bir değeri bir $(C enum) değerine dönüştürmek istiyorsak, bunu açıkça bir $(I tür dönüşümü) olarak yazmamız gerekir:
)

---
    renk = cast(OyunKağıdıRengi)1;    // şimdi kupa
---

$(P
Tür dönüşümlerini $(LINK2 /ders/d/tur_donusumleri.html, ilerideki bir bölümde) göreceğiz.
)

$(PROBLEM_TEK

$(P
$(LINK2 /ders/d/aritmetik_islemler.html, Tamsayılar ve Aritmetik İşlemler bölümünün) problemlerindeki hesap makinesini değiştirin: Dört işlemi destekleyen basit bir hesap makinesi, işlemi bir menüden seçtirsin ve girilen iki değere o işlemi uygulasın.
)

$(P
Programı bu sefer şu farklarla yazın:
)

$(UL
$(LI Hangi işlem olduğunu sihirli sabitlerden değil, $(C enum) değerlerden anlasın.)
$(LI $(C int) yerine $(C double) kullansın.)
$(LI "if else if" zinciri yerine $(C switch) kullansın.)
)
)

Macros:
        SUBTITLE=enum

        DESCRIPTION=D dilinin isimli değerler üretme olanağı olan enum'un tanıtılması

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial enum numaralandırma numara

SOZLER=
$(sag_deger)
$(sihirli_sabit)
$(sablon)
