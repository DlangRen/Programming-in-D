Ddoc

$(DERS_BOLUMU $(IX sözleşmeli programlama) Sözleşmeli Programlama)

$(P
Sözleşmeli programlama, işlevlerin hizmet sunan birimler olarak kabul edilmeleri düşüncesi üzerine kurulu bir programlama yöntemidir. Bu düşünceye göre, işlevler ve onları çağıran kodlar arasında yazısız bazı anlaşmalar vardır. Sözleşmeli programlama, bu anlaşmaları dil düzeyinde belirlemeye yarayan olanaktır.
)

$(P
Sözleşmeli programlama, ticari bir dil olan Eiffel tarafından "design by contract (DBC)" adıyla yayılmıştır. Bu yöntem D dilinde "contract programming" olarak geçer. Birim testlerinde olduğu gibi, $(C assert) denetimlerine dayanır ve D'nin kod sağlamlığı sağlayan bir başka olanağıdır.
)

$(P
D'de sözleşmeli programlama üç temelden oluşur:
)

$(UL
$(LI İşlevlerin $(C in) blokları)
$(LI İşlevlerin $(C out) blokları)
$(LI Yapı ve sınıfların $(C invariant) blokları)
)

$(P
$(C invariant) bloklarını ve $(I sözleşme kalıtımını) $(LINK2 /ders/d/invariant.html, ilerideki bir bölümde) ve yapı ve sınıflardan daha sonra göreceğiz.
)

$(H5 $(IX in, giriş koşulu) $(IX giriş koşulu) Giriş koşulları için $(C in) blokları)

$(P
İşlevlerin doğru çalışabilmeleri, aldıkları parametre değerlerine bağlı olabilir. Örneğin karekök alan bir işlev kendisine verilen parametrenin sıfırdan küçük olmamasını şart koşar; veya parametre olarak tarih bilgisi alan bir işlev ayın 1 ile 12 arasında olmasını şart koşar.
)

$(P
Bu tür koşulları daha önce $(LINK2 /ders/d/assert.html, $(C assert) ve $(C enforce) bölümünde) görmüştük. İşlevlerin parametreleriyle ilgili olan $(C assert) denetimleri işlevin tanımlandığı blok içinde yapılıyordu:
)

---
string zamanDizgisi(in int saat, in int dakika) {
    assert((saat >= 0) && (saat <= 23));
    assert((dakika >= 0) && (dakika <= 59));

    return format("%02s:%02s", saat, dakika);
}
---

$(P
$(IX body) D'nin sözleşmeli programlama anlayışında işlevlerin giriş koşulları "giriş" anlamına gelen $(C in) bloklarında denetlenir. Sözleşmeli programlama blokları kullanıldığı zaman, işlevin asıl bloğu da "gövde" anlamına gelen $(C body) ile belirlenir:
)

---
import std.stdio;
import std.string;

string zamanDizgisi(in int saat, in int dakika)
$(HILITE in) {
    assert((saat >= 0) && (saat <= 23));
    assert((dakika >= 0) && (dakika <= 59));

} $(HILITE body) {
    return format("%02s:%02s", saat, dakika);
}

void main() {
    writeln(zamanDizgisi(12, 34));
}
---

$(P
İşlevin $(C in) bloğunun yararı, işlevin başlatılmasıyla ilgili olan denetimlerin bir arada ve ayrı bir blok içinde yapılmasıdır. Böylece $(C assert) denetimleri işlevin asıl işlemlerinin arasına karışmamış olurlar. İşlevin içinde yine de gerektikçe $(C assert) denetimleri kullanılabilir, ama giriş koşulları sözleşmeli programlama anlayışına uygun olarak $(C in) bloğuna yazılırlar.
)

$(P
$(C in) bloklarındaki kodlar programın çalışması sırasında işlevin her çağrılışında otomatik olarak işletilirler. İşlevin asıl işleyişi, ancak bu koşullar sağlandığında devam eder. Böylece işlevin geçersiz başlangıç koşulları ile çalışması ve programın yanlış sonuçlarla devam etmesi önlenmiş olur.
)

$(P
$(C in) bloğundaki bir $(C assert) denetiminin başarısız olması sözleşmeyi işlevi çağıran tarafın bozduğunu gösterir. İşlev sözleşmenin gerektirdiği şekilde çağrılmamış demektir.
)

$(H5 $(IX out, sözleşme) $(IX çıkış garantisi) Çıkış garantileri için $(C out) blokları)

$(P
İşlevin yaptığı kabul edilen sözleşmenin karşı tarafı da işlevin sağladığı garantilerdir. Örneğin belirli bir senedeki Şubat ayının kaç gün çektiği bilgisini döndüren bir işlevin çıkış garantisi, döndürdüğü değerin 28 veya 29 olmasıdır.
)

$(P
Çıkış garantileri, işlevlerin "çıkış" anlamına gelen $(C out) bloklarında denetlenirler.
)

$(P
İşlevin dönüş değerinin özel bir ismi yoktur; bu değer $(C return) ile isimsiz olarak döndürülür. Bu durum, dönüş değeriyle ilgili garantileri yazarken bir sorun doğurur: ismi olmayınca, dönüş değeriyle ilgili $(C assert) denetimleri de yazılamaz.
)

$(P
Bu sorun $(C out) anahtar sözcüğünden sonra verilen isimle halledilmiştir. Bu isim dönüş değerini temsil eder ve denetlenecek olan garantilerde bu isim kullanılır:
)

---
int şubattaKaçGün(in int yıl)
$(HILITE out (sonuç)) {
    assert((sonuç == 28) || (sonuç == 29));

} body {
    return artıkYıl_mı(yıl) ? 29 : 28;
}
---

$(P
Ben $(C out) bloğunun parametresinin ismi olarak $(C sonuç) yazmayı uygun buldum; siz $(C dönüşDeğeri) gibi başka bir isim de verebilirsiniz. Hangi ismi kullanırsanız kullanın, o isim işlevin dönüş değerini temsil eder.
)

$(P
Bazen işlevin dönüş değeri yoktur, veya dönüş değerinin denetlenmesi gerekmiyordur. O zaman $(C out) bloğu parametresiz olarak yazılır:
)

---
out {
    // ...
}
---

$(P
İşleve girerken $(C in) bloklarının otomatik olarak işletilmeleri gibi, $(C out) blokları da işlevden çıkarken otomatik olarak işletilirler.
)

$(P
$(C out) bloğundaki bir $(C assert) denetiminin başarısız olması sözleşmenin işlev tarafından bozulduğunu gösterir. İşlev sözleşmenin gerektirdiği değeri veya yan etkiyi üretememiş demektir.
)

$(P
Daha önceki bölümlerde hiç kullanmamış olduğumuzdan da anlaşılabileceği gibi, $(C in) ve $(C out) bloklarının kullanımı seçime bağlıdır. Bunlara yine seçime bağlı olan $(C unittest) bloklarını da eklersek, D'de işlevler dört blok halinde yazılabilirler:
)

$(UL
$(LI Giriş koşulları için $(C in) bloğu: seçime bağlıdır ve giriş koşullarını denetler)

$(LI Çıkış garantileri için $(C out) bloğu: seçime bağlıdır ve çıkış garantilerini denetler)

$(LI İşlevin asıl işlemlerini içeren $(C body) bloğu: bu bloğun yazılması şarttır, ama eğer $(C in) ve $(C out) blokları kullanılmamışsa $(C body) anahtar sözcüğü yazılmayabilir)

$(LI İşlevin birim testlerini içeren $(C unittest) bloğu: bu aslında işlevin parçası değildir ve kendi başına işlev gibi yazılır; ama denetlediği işlevin hemen altına yazılması, aralarındaki bağı gösterme bakımından uygun olur)
)

$(P
Bütün bu blokları içeren bir işlev tanımı şöyle yazılabilir:
)

---
import std.stdio;

/* Toplamı iki parça olarak bölüştürür.
 *
 * Toplamdan öncelikle birinciye verir, ama birinciye hiçbir
 * zaman 7'den fazla vermez. Gerisini ikinciye verir. */
void bölüştür(in int toplam, out int birinci, out int ikinci)
in {
    assert(toplam >= 0);

} out {
    assert(toplam == (birinci + ikinci));

} body {
    birinci = (toplam >= 7) ? 7 : toplam;
    ikinci = toplam - birinci;
}

unittest {
    int birinci;
    int ikinci;

    // Toplam 0 ise ikisi de 0 olmalı
    bölüştür(0, birinci, ikinci);
    assert(birinci == 0);
    assert(ikinci == 0);

    // Toplam 7'den az ise birincisi toplam'a, ikincisi 0'a
    // eşit olmalı
    bölüştür(3, birinci, ikinci);
    assert(birinci == 3);
    assert(ikinci == 0);

    // Sınır koşulunu deneyelim
    bölüştür(7, birinci, ikinci);
    assert(birinci == 7);
    assert(ikinci == 0);

    // 7'den fazla olduğunda birinci 7 olmalı, gerisi ikinciye
    // gitmeli
    bölüştür(8, birinci, ikinci);
    assert(birinci == 7);
    assert(ikinci == 1);

    // Bir tane de büyük bir değerle deneyelim
    bölüştür(1_000_007, birinci, ikinci);
    assert(birinci == 7);
    assert(ikinci == 1_000_000);
}

void main() {
    int birinci;
    int ikinci;

    bölüştür(123, birinci, ikinci);
    writeln("birinci: ", birinci, " ikinci: ", ikinci);
}
---

$(P
Program aşağıdaki gibi derlenebilir ve çalıştırılabilir:
)

$(SHELL
$ dmd deneme.d -w -unittest
$ ./deneme
$(DARK_GRAY birinci: 7 ikinci: 116)
)

$(P
Bu işlevin asıl işi yalnızca 2 satırdan oluşuyor; denetleyen kodlar ise tam 19 satır! Bu kadar küçük bir işlev için bu kadar emeğin gereksiz olduğu düşünülebilir. Ama dikkat ederseniz, programcı hiçbir zaman bilerek hatalı kod yazmaz. Programcının yazdığı kod her zaman için $(I doğru çalışacak şekilde) yazılmıştır. Buna rağmen, hatalar da hep böyle doğru çalışacağı düşünülen kodlar arasından çıkar.
)

$(P
İşlevlerden beklenenlerin birim testleri ve sözleşmeli programlama ile böyle açıkça ortaya koyulmaları, doğru olarak yazdığımız işlevlerin her zaman için doğru kalmalarına yardım eder. Program hatalarını azaltan hiçbir olanağı küçümsememenizi öneririm. Birim testleri ve sözleşmeli programlama olanakları bizi zorlu hatalardan koruyan çok etkili araçlardır. Böylece zamanımızı hata ayıklamak yerine, ondan çok daha zevkli ve verimli olan kod yazmaya ayırabiliriz.
)

$(H5 Sözleşmeli programlamayı etkisizleştirmek)

$(P
$(IX -release, derleyici seçeneği) Birim testlerinin tersine, sözleşmeli programlama normalde etkilidir; etkisizleştirmek için özel bir derleyici veya geliştirme ortamı ayarı gerekir. Bunun için $(C dmd) derleyicisinde $(C -release) seçeneği kullanılır:
)

$(SHELL
dmd deneme.d -w -release
)

$(P
Program o seçenekle derlendiğinde $(C in), $(C out), ve $(C invariant) blokları programa dahil edilmezler.
)

$(H5 $(IX in ve enforce) $(IX enforce ve in) $(IX assert ve enforce) $(IX enforce ve assert) $(C in) bloğu mu $(C enforce) mu)

$(P
$(LINK2 /ders/d/assert.html, $(C assert) ve $(C enforce) bölümünde) karşılaştığımız $(C assert) ile $(C enforce) arasındaki karar güçlüğü $(C in) blokları ile $(C enforce()) arasında da vardır. $(C in) bloğundaki $(C assert) denetimlerinin mi yoksa işlev tanımı içindeki $(C enforce) denetimlerinin mi daha uygun olduğuna karar vermek bazen güç olabilir.
)

$(P
Yukarıda gördüğümüz gibi, sözleşmeli programlama bütünüyle etkisizleştirilebilir. Bundan da anlaşılabileceği gibi, sözleşmeli programlama da $(C assert) ve $(C unittest) gibi $(I programcı hatalarına) karşı koruma getiren bir olanaktır.
)

$(P
Bu yüzden işlevlerin giriş koşulu denetimlerinin hangi yöntemle sağlanacağının kararı da yine $(LINK2 /ders/d/assert.html, $(C assert) ve $(C enforce) bölümünde) gördüğümüz maddelerle verilebilir:
)

$(UL

$(LI
Eğer denetim programın kendisi ile ilgili ise, yani programcının olası hatalarına karşı koruma getiriyorsa $(C in) bloklarındaki $(C assert) denetimleri kullanılmalıdır. Örneğin, işlev yalnızca programın kendi işlemleri için çağırdığı bir yardımcı işlevse, o işlevin giriş koşullarını sağlamak bütünüyle programı yazan programcının sorumluluğunda demektir. O yüzden böyle bir işlevin giriş koşullarının denetimi $(C in) bloklarında yapılmalıdır.)

$(LI
Herhangi bir işlem başka bazı koşullar sağlanmadığı için gerçekleştirilemiyorsa $(C enforce) ile hata atılmalıdır.

$(P
Bunun bir örneğini görmek için bir dilimin en ortasını yine bir dilim olarak döndüren bir işleve bakalım. Bu işlev bir kütüphaneye ait olsun; yani, belirli bir modülün özel bir yardımcı işlevi değil, bir kütüphanenin arayüzünün bir parçası olsun. Kullanıcılar böyle bir işlevi doğru veya yanlış her türlü parametre değeriyle çağırabilecekleri için bu işlevin giriş koşullarının her zaman için denetlenmesi gerekecektir.
)

$(P
O yüzden aşağıdaki işlevde $(C in) bloğundaki $(C assert) denetimlerinden değil, işlevin tanımındaki bir $(C enforce)'tan yararlanılmaktadır. Yoksa $(C in) bloğu kullanılmış olsa, sözleşmeli programlama etkisizleştirildiğinde böyle bir denetimin ortadan kalkması güvensiz olurdu.
)

---
import std.exception;

inout(int)[] ortadakiler(inout(int)[] asılDilim, size_t uzunluk)
out (sonuç) {
    assert(sonuç.length == uzunluk);

} body {
    $(HILITE enforce)(asılDilim.length >= uzunluk);

    immutable baş = (asılDilim.length - uzunluk) / 2;
    immutable son = baş + uzunluk;

    return asılDilim[baş .. son];
}

unittest {
    auto dilim = [1, 2, 3, 4, 5];

    assert(ortadakiler(dilim, 3) == [2, 3, 4]);
    assert(ortadakiler(dilim, 2) == [2, 3]);
    assert(ortadakiler(dilim, 5) == dilim);
}

void main() {
}
---

$(P
$(C out) blokları ile ilgili buna benzer bir karar güçlüğü yoktur. Her işlev döndürdüğü değerden kendisi sorumlu olduğundan ve bir anlamda dönüş değeri programcının sorumluluğunda olduğundan çıkış denetimleri her zaman için $(C out) bloklarına yazılmalıdır. Yukarıdaki işlev buna uygun olarak $(C out) bloğundan yararlanıyor.
)

)

$(LI
$(C in) blokları ve $(C enforce) arasında karar verirken başka bir kıstas, karşılaşılan durumun giderilebilen bir hata çeşidi olup olmadığıdır. Eğer giderilebilen bir durumsa hata atmak uygun olabilir. Böylece daha üst düzeydeki bir işlev atılan bu hatayı yakalayabilir ve hatanın türüne göre farklı davranabilir.
)

)

$(PROBLEM_TEK

$(P
İki futbol takımının puanlarını bir maçın sonucuna göre arttıran bir işlev yazın.
)

$(P
Bu işlevin ilk iki parametresi birinci ve ikinci takımın attıkları goller olsun. Son iki parametresi de bu takımların maçtan önceki puanları olsun. Bu işlev golleri dikkate alarak birinci ve ikinci takımın puanlarını düzenlesin: fazla gol atan taraf üç puan kazansız, goller eşitse iki takım da birer puan kazansınlar.
)

$(P
Ek olarak, işlevin dönüş değeri de kazanan tarafı belirtsin: birinci kazanmışsa 1, ikinci kazanmışsa 2, berabere kalmışlarsa 0.
)

$(P
Aşağıdaki programla başlayın ve işlevin dört bloğunu uygun şekilde doldurun. Benim $(C main) içine yazdığım $(C assert) denetimlerini silmeyin. Onlar benim bu işlevin çalışması konusundaki beklentilerimi belgeliyorlar.
)

---
int puanEkle(in int goller1,
             in int goller2,
             ref int puan1,
             ref int puan2)
in {
    // ...

} out (sonuç) {
    // ...

} body {
    int kazanan;

    // ...

    return kazanan;
}

unittest {
    // ...
}

void main() {
    int birincininPuanı = 10;
    int ikincininPuanı = 7;
    int kazananTaraf;

    kazananTaraf =
        puanEkle(3, 1, birincininPuanı, ikincininPuanı);
    assert(birincininPuanı == 13);
    assert(ikincininPuanı == 7);
    assert(kazananTaraf == 1);

    kazananTaraf =
        puanEkle(2, 2, birincininPuanı, ikincininPuanı);
    assert(birincininPuanı == 14);
    assert(ikincininPuanı == 8);
    assert(kazananTaraf == 0);
}
---

$(P
$(I Not: Burada üç değerli bir $(C enum) türü döndürmek daha uygun olabilir:)
)

---
enum MaçSonucu {
    birinciKazandı, ikinciKazandı, berabere
}

$(HILITE MaçSonucu) puanEkle(in int goller1,
                   in int goller2,
                   ref int puan1,
                   ref int puan2)
// ...
---

$(P
Dönüş değeri 0, 1, ve 2 değerleriyle $(C out) bloğunda karşılaştırılabilsin diye ben bu problemde $(C int) türünü seçtim.
)

)

Macros:
        SUBTITLE=Sözleşmeli Programlama

        DESCRIPTION=D dilinin kod güvenilirliğini arttıran olanağı 'sözleşmeli programlama' [contract programming]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sözleşmeli programlama contract programming design by contract

SOZLER=
$(birim_testi)
$(cikis_kosulu)
$(donus_degeri)
$(giris_kosulu)
$(islev)
$(parametre)
$(sozlesmeli_programlama)
