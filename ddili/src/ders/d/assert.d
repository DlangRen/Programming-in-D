Ddoc

$(DERS_BOLUMU $(IX assert) $(IX enforce) $(CH4 assert) ve $(CH4 enforce))

$(P
Programları yazarken çok sayıda varsayımda bulunuruz ve bazı beklentilerin doğru çıkmalarını umarız. Programlar ancak bu varsayımlar ve beklentiler doğru çıktıklarında doğru çalışırlar. $(C assert), programın dayandığı bu varsayımları ve beklentileri denetlemek için kullanılır. Programcının en etkili yardımcılarındandır.
)

$(P
Bazen hata atmakla $(C assert)'ten yararlanmak arasında karar vermek güçtür. Aşağıdaki örneklerde fazla açıklamaya girmeden $(C assert)'ler kullanacağım. Hangi durumda hangi yöntemin daha uygun olduğunu ise daha aşağıda açıklayacağım.
)

$(P
Çoğu zaman programdaki varsayımların farkına varılmaz. Örneğin iki kişinin yaşlarının ortalamasını alan aşağıdaki işlevde kullanılan hesap, yaş parametrelerinin ikisinin de sıfır veya daha büyük olacakları varsayılarak yazılmıştır:
)

---
double ortalamaYaş(double birinciYaş, double ikinciYaş) {
    return (birinciYaş + ikinciYaş) / 2;
}
---

$(P
Yaşlardan en az birisinin eksi bir değer olarak gelmesi hatalı bir durumdur. Buna rağmen, işlev mantıklı bir ortalama üretebilir ve program bu hata hiç farkedilmeden işine yanlış da olsa devam edebilir.
)

$(P
Başka bir örnek olarak, aşağıdaki işlev yalnızca iki komuttan birisi ile çağrılacağını varsaymaktadır: "şarkı söyle" ve "dans et":
)

---
void komutİşlet(string komut) {
    if (komut == "şarkı söyle") {
        robotaŞarkıSöylet();

    } else {
        robotuDansEttir();
    }
}
---

$(P
Böyle bir varsayımda bulunduğu için, "şarkı söyle" dışındaki geçerli olsun olmasın her komuta karşılık $(C robotuDansEttir) işlevini çağıracaktır.
)



$(P
Bu varsayımları kendimize sakladığımızda sonuçta ortaya çıkan program hatalı davranabilir. $(C assert), bu varsayımlarımızı dile getirmemizi sağlayan ve varsayımlar hatalı çıktığında işlemlerin durdurulmalarına neden olan bir olanaktır.
)

$(P
$(C assert), bir anlamda programa "böyle olduğunu varsayıyorum, eğer yanlışsa işlemi durdur" dememizi sağlar.
)

$(H5 Söz dizimi)

$(P
$(C assert) iki biçimde yazılabilir:
)

---
    assert($(I mantıksal_ifade));
    assert($(I mantıksal_ifade), $(I mesaj));
---

$(P
$(C assert), kendisine verilen mantıksal ifadeyi işletir. İfadenin değeri $(C true) ise varsayım doğru çıkmış kabul edilir ve $(C assert) denetiminin hiçbir etkisi yoktur. İfadenin değeri $(C false) olduğunda ise varsayım yanlış çıkmış kabul edilir ve bir $(C AssertError) hatası atılır. İsminden de anlaşılabileceği gibi, bu hata $(C Error)'dan türemiştir ve $(LINK2 /ders/d/hatalar.html, Hatalar bölümünde) gördüğümüz gibi, yakalanmaması gereken bir hata türüdür. Böyle bir hata atıldığında programın hemen sonlanması önemlidir çünkü programın yanlış varsayımlara dayanarak yanlış olabilecek sonuçlar üretmesi böylece önlenmiş olur.
)

$(P
Yukarıdaki $(C ortalamaYaş) işlevindeki varsayımlarımızı iki $(C assert) ile şöyle ifade edebiliriz:
)

---
double ortalamaYaş(double birinciYaş, double ikinciYaş) {
    assert(birinciYaş >= 0);
    assert(ikinciYaş >= 0);

    return (birinciYaş + ikinciYaş) / 2;
}

void main() {
    auto sonuç = ortalamaYaş($(HILITE -1), 10);
}
---

$(P
O $(C assert)'ler "birinciYaş'ın 0 veya daha büyük olduğunu varsayıyorum" ve "ikinciYaş'ın 0 veya daha büyük olduğunu varsayıyorum" anlamına gelir. Başka bir bakış açısıyla, "assert" sözcüğünün "emin olarak öne sürmek" karşılığını kullanarak, "birinciYaş'ın 0 veya daha büyük olduğundan eminim" gibi de düşünülebilir.
)

$(P
$(C assert) bu varsayımları denetler ve yukarıdaki programda olduğu gibi, varsayımın yanlış çıktığı durumda programı bir $(C AssertError) hatasıyla sonlandırır:
)

$(SHELL
core.exception.AssertError@deneme(3): Assertion failure
)

$(P
Hatanın $(C @) karakterinden sonra gelen bölümü hangi dosyanın hangi satırındaki varsayımın doğru çıkmadığını gösterir. Bu örnekteki $(C deneme(3))'e bakarak hatanın $(C deneme.d) dosyasının üçüncü satırında olduğu anlaşılır.
)

$(P
$(C assert) beklentisinin yanlış çıktığı durumda açıklayıcı bir mesaj yazdırılmak istendiğinde $(C assert) denetiminin ikinci kullanımından yararlanılır:
)

---
    assert(birinciYaş >= 0, "Yaş sıfırdan küçük olamaz");
---

$(P
Çıktısı:
)

$(SHELL
core.exception.AssertError@deneme.d(3): $(HILITE Yaş sıfırdan küçük olamaz)
)

$(P
Programda kesinlikle gelinmeyeceği düşünülen veya gelinmemesi gereken noktalarda, özellikle başarısız olsun diye mantıksal ifade olarak bilerek $(C false) sabit değeri kullanılır. Örneğin yukarıdaki "şarkı söyle" ve "dans et" örneğinde başka komutların geçersiz olduklarını belirtmek ve bu durumlarda hata atılmasını sağlamak için şöyle bir $(C assert) denetimi kullanılabilir:
)

---
void komutİşlet(in char[] komut) {
    if (komut == "şarkı söyle") {
        robotaŞarkıSöylet();

    } else if (komut == "dans et") {
        robotuDansEttir();

    } else {
        $(HILITE assert(false));
    }
}
---

$(P
Artık işlev yalnızca o iki komutu kabul eder ve başka komut geldiğinde $(C assert(false)) nedeniyle işlem durdurulur. ($(I Not: Burada aynı amaç için bir $(LINK2 /ders/d/switch_case.html, $(C final switch) deyimi) de kullanılabilir.))
)


$(H5 $(IX static assert) $(C static assert))

$(P
$(C assert) denetimleri programın çalışması sırasında işletilirler çünkü programın doğru işleyişi ile ilgilidirler. Bazı denetimler ise daha çok programın yapısı ile ilgilidirler ve derleme zamanında bile işletilebilirler.
)

$(P
$(C static assert), derleme zamanında işletilebilecek olan denetimler içindir. Bunun bir yararı, belirli koşulların sağlanamaması durumunda programın derlenmesinin önlenebilmesidir. Doğal olarak, bütün ifadenin derleme zamanında işletilebiliyor olması şarttır.
)

$(P
Örneğin, çıkış aygıtının genişliği gibi bir kısıtlama nedeniyle menü başlığının belirli bir uzunluktan kısa olması gereken bir durumda $(C static assert)'ten yararlanılabilir:
)

---
    enum dstring menüBaşlığı = "Komut Menüsü";
    static assert(menüBaşlığı.length <= 16);
---

$(P
İfadenin derleme zamanında işletilebilmesi için dizginin $(C enum) olarak tanımlandığına dikkat edin. Yalnızca $(C dstring) olsaydı bir derleme hatası oluşurdu.
)

$(P
Bir programcının o başlığı daha açıklayıcı olduğunu düşündüğü için değiştirdiğini düşünelim:
)

---
    enum dstring menüBaşlığı = "Yön Komutları Menüsü";
    static assert(menüBaşlığı.length <= 16);
---

$(P
Program artık $(C static assert) denetimini geçemediği için derlenemez:
)

$(SHELL
Error: static assert  (20LU <= 16LU) is false
)

$(P
Programcı da böylece programın uyması gereken bu kısıtlamayı farketmiş olur.
)

$(P
$(C static assert)'ün yararı, yukarıda olduğu gibi türlerin ve değerlerin açıkça belli oldukları örneklerde anlaşılamıyor. $(C static assert) özellikle şablon ve koşullu derleme olanakları ile kullanıldığında yararlıdır. Bu olanakları ilerideki bölümlerde göreceğiz.
)

$(H5 $(I Kesinlikle doğru olan) (!) varsayımlar için bile $(C assert))

$(P
"Kesinlikle doğru olan"ın özellikle üzerine basıyorum. Hiçbir varsayım bilerek yanlış olmayacağı için, zaten çoğu hata $(I kesinlikle doğru olan) varsayımlara dayanır.
)

$(P
Bu yüzden bazen kesinlikle gereksizmiş gibi duran $(C assert) denetimleri de kullanılır. Örneğin belirli bir senenin aylarının kaç gün çektikleri bilgisini bir dizi olarak döndüren bir işlev ele alalım:
)

---
int[] ayGünleri(in int yıl) {
    int[] günler = [
        31, şubatGünleri(yıl),
        31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ];

    assert((diziToplamı(günler) == 365) ||
           (diziToplamı(günler) == 366));

    return günler;
}
---

$(P
Doğal olarak bu işlevin döndürdüğü dizideki gün toplamları ya 365 olacaktır, ya da 366. Bu yüzden yukarıdaki $(C assert) denetiminin gereksiz olduğu düşünülebilir. Oysa, her ne kadar gereksiz gibi görünse de, o denetim $(C şubatGünleri) işlevinde ilerideki bir zamanda yapılabilecek bir hataya karşı bir güvence sağlar. $(C şubatGünleri) işlevi bir hata nedeniyle örneğin 30 değerini döndürse, o $(C assert) sayesinde bu hata hemen farkedilecektir.
)

$(P
Hatta biraz daha ileri giderek dizinin uzunluğunun her zaman için 12 olacağını da denetleyebiliriz:
)

---
    assert(günler.length == 12);
---

$(P
Böylece kodu diziden yanlışlıkla silinebilecek veya diziye yanlışlıkla eklenebilecek bir elemana karşı da güvence altına almış oluruz.
)

$(P
Böyle denetimler her ne kadar gereksizmiş gibi görünseler de son derece yararlıdırlar. Kodun sağlamlığını arttıran ve kodu ilerideki değişiklikler karşısında güvencede tutan çok etkili yapılardır.
)

$(P
Kodun sağlamlığını arttıran ve programın yanlış sonuçlar doğuracak işlemlerle devam etmesini önleyen bir olanak olduğu için, $(C assert) bundan sonraki bölümlerde göreceğimiz $(I birim testleri) ve $(I sözleşmeli programlama) olanaklarının da temelini oluşturur.
)

$(H5 Değer üretmez ve yan etkisi yoktur)

$(P
İfadelerin değer üretebildiklerini ve yan etkilerinin olabildiğini görmüştük. $(C assert) değer üretmeyen bir denetimdir.
)

$(P
Ek olarak, $(C assert) denetiminin kendisinin bir yan etkisi de yoktur. Ona verilen mantıksal ifadenin yan etkisinin olmaması da D standardı tarafından şart koşulmuştur. $(C assert), programın durumunu değiştirmeyen ve yalnızca varsayımları denetleyen bir yapı olarak kalmak zorundadır.
)

$(H5 $(C assert) denetimlerini etkisizleştirmek)

$(P
$(C assert) programın doğruluğu ile ilgilidir. Programın yeterince denenip amacı doğrultusunda doğru olarak işlediğine karar verildikten sonra programda başkaca yararı yoktur. Üstelik, ne değerleri ne de yan etkileri olduğundan, $(C assert) denetimleri programdan bütünüyle kaldırılabilmelidirler ve bu durumda programın işleyişinde hiçbir değişiklik olmamalıdır.
)

$(P
$(IX -release, derleyici seçeneği) Derleyici seçeneği $(C -release), $(C assert) denetimlerinin sanki programa hiç yazılmamışlar gibi gözardı edilmelerini sağlar:
)

$(SHELL
dmd deneme.d -release
)

$(P
Böylece olasılıkla uzun süren denetimlerin programı yavaşlatmaları önlenmiş olur.
)

$(P
Bir istisna olarak, $(C false) veya ona otomatik olarak dönüşen bir hazır değerle çağrılan $(C assert)'ler $(C &#8209;release) ile derlendiklerinde bile programdan çıkartılmazlar. Bunun nedeni, $(C assert(false)) denetimlerinin hiçbir zaman gelinmemesi gereken satırları belirliyor olmaları ve o satırlara gelinmesinin her zaman için hatalı olacağıdır.
)

$(H5 Hata atmak için $(C enforce))

$(P
Programın çalışması sırasında karşılaşılan her beklenmedik durum programdaki bir yanlışlığı göstermez. Beklenmedik durumlar programın elindeki verilerle veya çevresiyle de ilgili olabilir. Örneğin, kullanıcının girmiş olduğu geçersiz bir değerin $(C assert) ile denetlenmesi doğru olmaz çünkü kullanıcının girdiği yanlış değerin $(I programın doğruluğu) ile ilgisi yoktur. Bu gibi durumlarda $(C assert)'ten yararlanmak yerine daha önceki bölümlerde de yaptığımız gibi $(C throw) ile hata atmak doğru olur.
)

$(P
$(C std.exception) modülünde tanımlanmış olan ve buradaki kullanımında "şart koşuyorum" anlamına gelen $(C enforce), hata atarken daha önce de kullandığımız $(C throw) ifadesinin yerine geçer.
)

$(P
Örneğin, belirli bir koşula bağlı olarak bir hata atıldığını varsayalım:
)

---
    if (adet < 3) {
        throw new Exception("En az 3 tane olmalı.");
    }
---

$(P
$(C enforce) bir anlamda $(C if) denetimini ve $(C throw) deyimini sarmalar. Aynı kod $(C enforce) ile aşağıdaki gibi yazılır:
)

---
import std.exception;
// ...
    enforce(adet >= 3, "En az 3 tane olmalı.");
---

$(P
Mantıksal ifadenin öncekinin tersi olduğuna dikkat edin. Bunun nedeni, $(C enforce)'un "bunu şart koşuyorum" anlamını taşımasıdır. Görüldüğü gibi, $(C enforce) koşul denetimine ve $(C throw) deyimine gerek bırakmaz.
)

$(H5 Nasıl kullanmalı)

$(P
$(C assert) $(I programcı hatalarını) yakalamak için kullanılır. Örneğin, yukarıdaki $(C ayGünleri) işlevinde ve $(C menüBaşlığı) değişkeniyle ilgili olarak kullanılan $(C assert)'ler tamamen programcılıkla ilgili hatalara karşı bir güvence olarak kullanılmışlardır.
)

$(P
Bazı durumlarda $(C assert) kullanmakla hata atmak arasında karar vermek güç olabilir. Böyle durumlarda beklenmedik durumun programın kendisi ile mi ilgili olduğuna bakmak gerekir. Eğer denetim programın kendisi ile ilgili ise $(C assert) kullanılmalıdır.
)

$(P
Herhangi bir işlem gerçekleştirilemediğinde ise hata atılmalıdır. Bu iş için daha kullanışlı olduğu için $(C enforce)'tan yararlanmanızı öneririm.
)

$(P
Bu konudaki başka bir kıstas, karşılaşılan durumun giderilebilen bir hata çeşidi olup olmadığıdır. Eğer giderilebilen bir durumsa hata atmak uygun olabilir. Böylece daha üst düzeydeki bir işlev atılan bu hatayı yakalayabilir ve duruma göre farklı davranabilir.
)

$(PROBLEM_COK

$(PROBLEM
Bu problemde size önceden yazılmış bir program göstermek istiyorum. Bu programın hata olasılığını azaltmak için bazı noktalarına $(C assert) denetimleri yerleştirilmiş. Amacım, bu $(C assert) denetimlerinin programdaki hataları ortaya çıkartma konusunda ne kadar etkili olduklarını göstermek.

$(P
Program kullanıcıdan bir başlangıç zamanı ve bir işlem süresi alıyor ve o işlemin ne zaman sonuçlanacağını hesaplıyor. Program, sayılardan sonra gelen 'da' eklerini de doğru olarak yazdırıyor:
)

$(SHELL
09:06'da başlayan ve 1 saat 2 dakika süren işlem
10:08'de sonlanır.
)

---
import std.stdio;
import std.string;
import std.exception;

/* Verilen mesajı kullanıcıya gösterir ve girilen zaman
 * bilgisini saat ve dakika olarak okur. */
void zamanOku(in string mesaj, out int saat, out int dakika) {
    write(mesaj, "? (SS:DD) ");

    readf(" %s:%s", &saat, &dakika);

    enforce((saat >= 0) && (saat <= 23) &&
            (dakika >= 0) && (dakika <= 59),
            "Geçersiz zaman!");
}

/* Zamanı dizgi düzeninde döndürür. */
string zamanDizgisi(in int saat, in int dakika) {
    assert((saat >= 0) && (saat <= 23));
    assert((dakika >= 0) && (dakika <= 59));

    return format("%02s:%02s", saat, dakika);
}

/* İki zaman bilgisini birbirine ekler ve üçüncü parametre
 * çifti olarak döndürür. */
void zamanEkle(
        in int başlangıçSaati, in int başlangıçDakikası,
        in int eklenecekSaat, in int eklenecekDakika,
        out int sonuçSaati, out int sonuçDakikası) {
    sonuçSaati = başlangıçSaati + eklenecekSaat;
    sonuçDakikası = başlangıçDakikası + eklenecekDakika;

    if (sonuçDakikası > 59) {
        ++sonuçSaati;
    }
}

/* Sayılardan sonra kesme işaretiyle ayrılarak kullanılacak
 * olan "de, da" ekini döndürür. */
string daEki(in int sayı) {
    string ek;

    immutable int sonHane = sayı % 10;

    switch (sonHane) {

    case 1, 2, 7, 8:
        ek = "de";
        break;

    case 3, 4, 5:
        ek = "te";
        break;

    case 6, 9:
        ek = "da";
        break;

    default:
        break;
    }

    assert(ek.length != 0);

    return ek;
}

void main() {
    int başlangıçSaati;
    int başlangıçDakikası;
    zamanOku("Başlangıç zamanı",
             başlangıçDakikası, başlangıçSaati);

    int işlemSaati;
    int işlemDakikası;
    zamanOku("İşlem süresi", işlemSaati, işlemDakikası);

    int bitişSaati;
    int bitişDakikası;
    zamanEkle(başlangıçSaati, başlangıçDakikası,
              işlemSaati, işlemDakikası,
              bitişSaati, bitişDakikası);

    sonucuYazdır(başlangıçSaati, başlangıçDakikası,
                 işlemSaati, işlemDakikası,
                 bitişSaati, bitişDakikası);
}

void sonucuYazdır(
        in int başlangıçSaati, in int başlangıçDakikası,
        in int işlemSaati, in int işlemDakikası,
        in int bitişSaati, in int bitişDakikası) {
    writef("%s'%s başlayan",
           zamanDizgisi(başlangıçSaati, başlangıçDakikası),
           daEki(başlangıçDakikası));

    writef(" ve %s saat %s dakika süren işlem",
           işlemSaati, işlemDakikası);

    writef(" %s'%s sonlanır.",
           zamanDizgisi(bitişSaati, bitişDakikası),
           daEki(bitişDakikası));

    writeln();
}
---

$(P
Bu programı çalıştırın ve girişine başlangıç olarak $(C 06:09) ve süre olarak $(C 1:2) verin. Programın normal olarak sonlandığını göreceksiniz.
)

$(P $(I Not: Aslında çıktının hatalı olduğunu farkedebilirsiniz. Bunu şimdilik görmezden gelin; çünkü az sonra $(C assert)'lerin yardımıyla bulacaksınız.)
)

)

$(PROBLEM
Bu sefer programa $(C 06:09) ve $(C 15:2) zamanlarını girin. Bir $(C AssertError) atıldığını göreceksiniz. Hatada belirtilen satıra gidin ve programla ilgili olan hangi beklentinin gerçekleşmediğine bakın. Bu hatanın kaynağını bulmanız zaman alabilir.
)

$(PROBLEM
Bu sefer programa $(C 06:09) ve $(C 1:1) zamanlarını girin. Yeni bir hata ile karşılaşacaksınız. O satıra da gidin ve o hatayı da giderin.
)

$(PROBLEM
Bu sefer programa $(C 06:09) ve $(C 20:0) bilgilerini girin. Yine $(C assert) tarafından yakalanan bir program hatası ile karşılaşacaksınız. O hatayı da giderin.
)

$(PROBLEM
Bu sefer programa $(C 06:09) ve $(C 1:41) bilgilerini girin. Programın $(I da) ekinin doğru çalışmadığını göreceksiniz:

$(SHELL
Başlangıç zamanı? (SS:DD) 06:09
İşlem süresi? (SS:DD) 1:41
06:09'da başlayan ve 1 saat 41 dakika süren işlem
$(HILITE 07:50'da) sonlanır
)

$(P
Bunu düzeltin ve duruma göre doğru ek yazmasını sağlayın: 7:10'da, 7:50'de, 7:40'ta, vs.
)

)

)

Macros:
        SUBTITLE=assert ve enforce

        DESCRIPTION=D dilinin kod varsayımlarını denetleyen olanağı assert ve hata atmayı kolaşlaştıran işlevi enforce.

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial güvenlik kod güvenliği assert varsayım

SOZLER=
$(donus_degeri)
$(ic_olanak)
$(ifade)
$(yan_etki)
