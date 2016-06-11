Ddoc

$(DERS_BOLUMU $(IX mantıksal ifade) Mantıksal İfadeler)

$(P
$(IX ifade) Programda asıl işleri $(I ifadeler) yaparlar. Programda değer veya yan etki üreten her şeye ifade denir. Aslında oldukça geniş bir kavramdır, çünkü $(C 42) gibi bir tamsayı sabiti bile 42 değerini ürettiği için bir ifadedir. $(STRING "merhaba") gibi bir dizgi de bir ifadedir, çünkü $(STRING "merhaba") sabit dizgisini üretir. (Not: Buradaki $(I üretme) kavramını değişken tanımlama ile karıştırmayın. Burada yalnızca $(I değer) üretmekten söz ediliyor; değişken üretmekten değil. Her değerin bir değişkene ait olması gerekmez.)
)

$(P
$(C writeln) gibi kullanımlar da ifadedirler, çünkü yan etkileri vardır: çıkış akımına karakter yerleştirdikleri için çıkış akımını etkilemiş olurlar. Şimdiye kadar gördükleriniz arasından atama işlecini de bir ifade örneği olarak verebiliriz.
)

$(P
İfadelerin değer üretiyor olmaları, onların başka ifadelerde değer olarak kullanılmalarını sağlar. Böylece basit ifadeler kullanılarak daha karmaşık ifadeler elde edilebilir. Örneğin hava sıcaklığını veren bir $(C hava_sıcaklığı()) işlevi olduğunu düşünürsek, onu kullanarak şöyle bir çıktı oluşturabiliriz:
)

---
writeln("Şu anda hava ", hava_sıcaklığı(), " derece");
---

$(P
O satır toplam dört ifadeden oluşur:
)

$(OL
$(LI $(C "Şu anda hava ") ifadesi)
$(LI $(C hava_sıcaklığı()) ifadesi)
$(LI $(C " derece") ifadesi)
$(LI ve o üç ifadeyi kullanan $(C writeln)'li ifade)
)

$(P
Bu bölümde mantıksal ifadeleri göreceğiz ama daha ileri gitmeden önce en temel işlemlerden olan atama işlecini hatırlayalım.
)

$(P $(B = (atama işleci):)
Sağ tarafındaki ifadenin değerini sol tarafındaki ifadeye (örneğin bir değişkene) atar.
)

---
hava_sıcaklığı = 23      // hava_sıcaklığı'nın değeri 23 olur
---

$(H5 Mantıksal ifadeler)

$(P
Mantıksal ifadeler Bool aritmetiğinde geçen ifadelerdir. Karar verme düzeneğinin parçası oldukları için bilgisayarları akıllı gösteren davranışların da temelidirler. Örneğin bir programın "eğer girilen yanıt Evet ise dosyayı kaydedeceğim" gibi bir kararında bir mantıksal ifade kullanılır.
)

$(P
Mantıksal ifadelerde yalnızca iki değer vardır: "doğru olmama" anlamını taşıyan $(C false) ve "doğruluk" anlamını taşıyan $(C true).
)

$(P
Aşağıdaki örneklerde bir soru ile kullanılan $(C writeln) ifadelerini şöyle anlamanız gerekiyor: Eğer sorunun karşısına "true" yazılmışsa $(I evet), "false" yazılmışsa $(I hayır)... Örneğin programın çıktısı
)

$(SHELL
Tatlı var: true
)

$(P
olduğunda "evet, tatlı var" demektir. Aynı şekilde
)

$(SHELL
Tatlı var: false
)

$(P
olduğunda "hayır, tatlı yok" demektir. Yani çıktıda "var" göründüğü için "var olduğunu" düşünmeyin; çıktıdaki "... var: false", "yok" anlamına geliyor. Aşağıdaki program parçalarını hep öyle okumanız gerekiyor.
)

$(P
Mantıksal ifadeleri daha ileride göreceğimiz $(I koşullarda), $(I döngülerde), $(I parametrelerde), vs. çok kullanacağız. Programlarda bu kadar çok kullanıldıkları için mantıksal ifadeleri çok iyi anlamak gerekir. Tanımları son derece kısa olduğu için çok da kolaydırlar.
)

$(P
Mantıksal ifadelerde kullanılan mantıksal işleçler şunlardır:
)

$(UL

$(LI $(IX ==) $(IX eşittir, mantıksal işleç) $(C ==)

"Eşit midir" sorusunu yanıtlar. İki tarafındaki ifadelerin değerlerini karşılaştırır ve eşit olduklarında "doğruluk" anlamına gelen $(C true) değerini, eşit olmadıklarında da "doğru olmama" anlamına gelen $(C false) değerini üretir. Ürettiği değerin türü de doğal olarak $(C bool)'dur. Örneğin şöyle iki değişkenimiz olsun:

---
int haftadaki_gün_sayısı = 7;
int yıldaki_ay_sayısı = 12;
---

$(P
Onları kullanan iki eşitlik işleci ifadesi ve sonuçları şöyle gösterilebilir:
)

---
haftadaki_gün_sayısı == 7      // true
yıldaki_ay_sayısı == 11        // false
---
)

$(LI $(IX !=) $(IX eşit değildir, mantıksal işleç) $(C !=)

"Eşit değil midir" sorusunu yanıtlar. İki tarafındaki ifadeleri karşılaştırır ve $(C ==) işlecinin tersi sonuç üretir.

---
haftadaki_gün_sayısı != 7      // false
yıldaki_ay_sayısı != 11        // true
---
)

$(LI $(IX ||) $(IX veya, mantıksal işleç) $(C ||)

"Veya" anlamındadır. Sol tarafındaki ifadenin değeri $(C true) ise hiç sağ taraftaki ifadeyi işletmeden $(C true) değerini üretir. Sol taraf $(C false) ise sağ taraftakinin değerini üretir. Bu işlem Türkçe $(I veya) ifadesine benzer: birincisi, ikincisi, veya ikisi birden $(C true) olduğunda $(C true) üretir.

$(BR)$(BR)

$(P
Bu işlece verilen iki ifadenin alabileceği olası değerler ve sonuçları şöyledir:
)

<table class="wide centered" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">Sol ifade</th><th scope="col">İşleç</th><th scope="col">Sağ ifade</th><th scope="col">Sonuç</th></tr>
<tr><td>false</td><td>||</td><td>false</td><td>false</td></tr>
<tr><td>false</td><td>||</td><td>true</td><td>true</td></tr>
<tr><td>true</td><td>||</td><td>false (bakılmaz)</td><td>true</td></tr>
<tr><td>true</td><td>||</td><td>true (bakılmaz)</td><td>true</td></tr>
</table>

---
import std.stdio;

void main() {
    /* false "yok" anlamına gelsin,
     * true "var" anlamına gelsin */
    bool baklava_var = false;
    bool kadayıf_var = true;

    writeln("Tatlı var: ", baklava_var || kadayıf_var);
}
---

$(P
Yukarıdaki programdaki $(C ||) işlecini kullanan ifade, en az bir $(C true) değer olduğu için $(C true) değerini üretir.
)
)

$(LI $(IX &&) $(IX ve, mantıksal işleç) $(C &&)

"Ve" anlamındadır. Sol tarafındaki ifadenin değeri $(C false) ise hiç sağ taraftaki ifadeyi işletmeden $(C false) değerini üretir. Sol taraf $(C true) ise sağ taraftakinin değerini üretir. Bu işlem Türkçe $(I ve) ifadesine benzer: birincisi ve ikincisi $(C true) olduğunda $(C true) üretir.

<table class="wide centered" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">Sol ifade</th><th scope="col">İşleç</th><th scope="col">Sağ ifade</th><th scope="col">Sonuç</th></tr>
<tr><td>false</td><td>&&</td><td>false (bakılmaz)</td><td>false</td></tr>
<tr><td>false</td><td>&&</td><td>true (bakılmaz)</td><td>false</td></tr>
<tr><td>true</td><td>&&</td><td>false</td><td>false</td></tr>
<tr><td>true</td><td>&&</td><td>true</td><td>true</td></tr>
</table>

---
writeln("Baklava yiyeceğim: ",
        baklava_yemek_istiyorum && baklava_var);
---

$(P $(I
$(B Not:) $(C ||) ve $(C &&) işleçlerinin bu "sağ tarafı ancak gerektiğinde" işletme davranışları işleçler arasında çok nadirdir, ve bir de şimdilik sonraya bırakacağımız $(C ?:) işlecinde vardır. Diğer işleçler bütün ifadelerinin değerlerini her zaman için hesaplarlar ve kullanırlar.
))

)

$(LI $(IX ^, ya da) $(IX ya da, mantıksal işleç) $(C ^)

"Yalnızca birisi mi" sorusunu yanıtlar. İki ifadeden ya biri ya öbürü $(C true) olduğunda (ama ikisi birden değil) $(C true) değerini üretir.

<table class="wide centered" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">Sol ifade</th><th scope="col">İşleç</th><th scope="col">Sağ ifade</th><th scope="col">Sonuç</th></tr>
<tr><td>false</td><td>^</td><td>false</td><td>false</td></tr>
<tr><td>false</td><td>^</td><td>true</td><td>true</td></tr>
<tr><td>true</td><td>^</td><td>false</td><td>true</td></tr>
<tr><td>true</td><td>^</td><td>true</td><td>false</td></tr>
</table>

$(P
Örneğin ancak ve ancak bir arkadaşımın geldiğinde tavla oynayacağımı, aksi taktirde onlarla başka bir şey yapacağımı düşünürsek; onların gelip gelmeme durumlarına göre tavla oynayıp oynamayacağımı şöyle hesaplayabiliriz:
)

---
writeln("Tavla oynayacağım: ", ahmet_burada ^ barış_burada);
---

)

$(LI $(IX <, küçüktür) $(IX küçüktür, mantıksal işleç) $(C <)

"Küçük müdür" sorusunu yanıtlar. Sol taraf sağ taraftan küçükse (veya sıralamada $(I önceyse)) $(C true), değilse $(C false) değerini üretir.

---
writeln("Yendik: ", yediğimiz_gol < attığımız_gol);
---

)

$(LI $(IX >, büyüktür) $(IX büyüktür, mantıksal işleç) $(C >)

"Büyük müdür" sorusunu yanıtlar. Sol taraf sağ taraftan büyükse (veya sıralamada $(I sonraysa)) $(C true), değilse $(C false) değerini üretir.

---
writeln("Yenildik: ", yediğimiz_gol > attığımız_gol);
---
)

$(LI $(IX <=) $(IX küçüktür veya eşittir, mantıksal işleç) $(C <=)

"Küçük veya eşit midir" sorusunu yanıtlar. Sol taraf sağ taraftan küçük (veya sıralamada daha önce) veya ona eşit olduğunda $(C true) üretir. $(C >) işlecinin tersidir.

---
writeln("Yenilmedik: ", yediğimiz_gol <= attığımız_gol);
---
)

$(LI $(IX >=) $(IX büyüktür veya eşittir, mantıksal işleç) $(C >=)

"Büyük veya eşit midir" sorusunu yanıtlar. Sol taraf sağ taraftan büyük (veya sıralamada daha sonra) veya ona eşit olduğunda $(C true) üretir. $(C <) işlecinin tersidir.

---
writeln("Yenmedik: ", yediğimiz_gol >= attığımız_gol);
---
)

$(LI $(IX !, değil) $(IX değil, mantıksal işleç) $(C !)

"Tersi" anlamındadır. Diğer mantıksal işleçlerden farklı olarak tek bir ifade ile çalışır ve sağ tarafındaki ifadenin değerinin tersini üretir: $(C true) ise $(C false), $(C false) ise $(C true).

---
writeln("Bakkala gideceğim: ", !ekmek_var);
---

)

)

$(H5 İfadeleri gruplamak)

$(P
İfadelerin hangi sırada işletilecekleri gerektiğinde parantezlerle belirtilir. Karmaşık ifadelerde önce parantez içindeki ifadeler işletilir ve onların değeri dıştaki işleçle kullanılır. Örneğin "kahve veya çay varsa ve yanında da baklava veya kadayıf varsa keyfim yerinde" gibi bir ifadeyi şöyle hesaplayabiliriz:
)

---
writeln("Keyfim yerinde: ",
        (kahve_var || çay_var) && (baklava_var || kadayıf_var));
---

$(P
Kendimiz parantezlerle gruplamazsak, ifadeler D dilinin kuralları ile belirlenmiş olan önceliklere uygun olarak işletilirler. $(C &&) işlecinin önceliği $(C ||) işlecininkinden daha yüksektir. Yukarıdaki mantıksal ifadeyi parantezlerle gruplamadan şöyle yazdığımızı düşünelim:
)

---
writeln("Keyfim yerinde: ",
        kahve_var || çay_var && baklava_var || kadayıf_var);
---

$(P
O ifade, işlem öncelikleri nedeniyle aşağıdakinin eşdeğeri olarak işletilir:
)

---
writeln("Keyfim yerinde: ",
        kahve_var || (çay_var && baklava_var) || kadayıf_var);
---

$(P
Bu da tamamen farklı anlamda bir ifadeye dönüşmüş olur: "kahve varsa, veya çay ve baklava varsa, veya kadayıf varsa; keyfim yerinde".
)

$(P
Bütün işleçlerin işlem önceliklerini hemen hemen hiçbir programcı ezbere bilmez. O yüzden, gerekmese bile parantezler kullanarak hangi ifadeyi kurmak istediğinizi açıkça belirtmek kodun anlaşılırlığı açısından çok yararlıdır.
)

$(P
İşleç öncelikleri tablosunu $(LINK2 /ders/d/islec_oncelikleri.html, ilerideki bir bölümde) göreceğiz.
)

$(H5 $(IX giriş, bool) $(IX bool okumak) Girişten $(C bool) okumak)

$(P
Yukarıdaki örneklerdeki bütün $(C bool) ifadeler çıkışa $(STRING "false") veya $(STRING "true") dizgileri olarak yazdırılırlar. Bunun tersi de doğrudur: $(C readf()) girişten gelen $(STRING "false") ve $(STRING "true") dizgilerini $(C false) ve $(C true) değerlerine dönüştürür. Bu dizgilerdeki harfler büyük veya küçük olabilir; örneğin, $(STRING "False") ve $(STRING "FALSE") dizgileri $(C false)'a, $(STRING "True") ve $(STRING "TRUE") dizgileri de $(C true)'ya dönüştürülür.
)

$(PROBLEM_COK

$(PROBLEM
Sayıların büyüklüğü ve küçüklüğü ile ilgili olan $(C <), $(C >) vs. işleçleri bu bölümde tanıdık. Bu işleçler içinde "arasında mıdır" sorusunu yanıtlayan işleç bulunmaz. Yani verilen bir sayının iki değer arasında olup olmadığını hesaplayan işleç yoktur. Bir arkadaşınız bunun üstesinden gelmek için şöyle bir program yazmış olsun. Bu programı derlemeye çalışın ve derlenemediğini görün:

---
import std.stdio;

void main() {
    int sayı = 15;
    writeln("Arasında: ", 10 < sayı < 20); $(DERLEME_HATASI)
}
---

$(P
Derleme hatasını gidermek için bütün ifadenin etrafında parantez kullanmayı deneyin:
)

---
writeln("Arasında: ", (10 < sayı < 20)); $(DERLEME_HATASI)
---

$(P
Yine derlenemediğini görün.
)

)

$(PROBLEM
Aynı arkadaşınız hatayı gidermek için $(I bir şeyler denerken) derleme hatasının gruplama ile giderildiğini farketsin:

---
writeln("Arasında: ", (10 < sayı) < 20);
---

$(P
Bu sefer programın beklendiği gibi çalıştığını ve "true" yazdığını gözlemleyin. Ne yazık ki o çıktı yanıltıcıdır çünkü programda gizli bir hata bulunuyor. Hatanın etkisini görmek için 15 yerine bu sefer 20'den büyük bir değer kullanın:
)

---
    int sayı = 21;
---

$(P
O değer 20'den küçük olmadığı halde programın yine de "true" yazdırdığını görün.
)

$(P
$(B İpucu:) Mantıksal ifadelerin değerlerinin $(C bool) türünde olduklarını hatırlayın. Bildiğiniz $(C bool) değerlerin 20 gibi bir sayıdan küçük olması gibi bir kavram tanımadık.
)

)

$(PROBLEM
D'de "arasında mıdır" sorusunu yanıtlayan mantıksal ifadeyi şu şekilde kodlamamız gerekir: alt sınırdan büyüktür ve üst sınırdan küçüktür. Programdaki ifadeyi o şekilde değiştirin ve artık çıktının beklendiği gibi "true" olduğunu görün. Ayrıca, yazdığınız ifadenin $(C sayı)'nın başka değerleri için de doğru çalıştığını denetleyin. Örneğin, $(C sayı) 50 veya 1 olduğunda sonuç "false" çıksın; 12 olduğunda "true" çıksın.
)

$(PROBLEM
Plaja ancak iki koşuldan birisi gerçekleştiğinde gidiyor olalım:

$(UL
$(LI Mesafe 10'dan az (kilometre varsayalım) ve yeterince bisiklet var)
$(LI Kişi sayısı 5 veya daha az, arabamız var, ve ehliyetli birisi var)
)

$(P
Aşağıdaki programdaki mantıksal ifadeyi bu koşullar sağlandığında "true" yazdıracak şekilde kurun. Programı denerken "... var mı?" sorularına "false" veya "true" diye yanıt verin:
)

---
import std.stdio;
import std.conv;
import std.string;

void main() {
    write("Kaç kişiyiz? ");
    int kişi_sayısı;
    readf(" %s", &kişi_sayısı);

    write("Kaç bisiklet var? ");
    int bisiklet_sayısı;
    readf(" %s", &bisiklet_sayısı);

    write("Mesafe? ");
    int mesafe;
    readf(" %s", &mesafe);

    write("Araba var mı? ");
    bool araba_var;
    readf(" %s", &araba_var);

    write("Ehliyet var mı? ");
    bool ehliyet_var;
    readf(" %s", &ehliyet_var);

    /* Aşağıdaki true'yu silin ve yerine sorudaki koşullardan
     * birisi gerçekleştiğinde true üretecek olan bir
     * mantıksal ifade yazın: */
    writeln("Plaja gidiyoruz: ", true);
}
---

$(P
Programın doğru çalıştığını farklı değerler girerek denetleyin.
)

)

)

Macros:
        SUBTITLE=Mantıksal İfadeler

        DESCRIPTION=D dilinin mantıksal ifade işleçleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial mantıksal ifadeler bool true false

SOZLER= 
$(atama)
$(dizgi)
$(ifade)
$(islec)
$(islev)
$(oncelik)
$(yan_etki)
