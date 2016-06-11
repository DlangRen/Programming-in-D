Ddoc

$(DERS_BOLUMU $(IX kesirli sayı) $(IX kayan noktalı sayı) Kesirli Sayılar)

$(P
Tamsayıların ve aritmetik işlemlerin oldukça kolay olduklarını, buna rağmen yapılarından kaynaklanan taşma ve kırpılma gibi özellikleri olduğunu gördük.
)

$(P
Bu bölümde de biraz ayrıntıya girmek zorundayız. Eğer aşağıdaki listedeki herşeyi bildiğinizi düşünüyorsanız, ayrıntılı bilgileri okumayıp doğrudan problemlere geçebilirsiniz:
)

$(UL

$(LI Bin kere 0.001 eklemek 1 eklemekle aynı şey değildir)

$(LI $(C ==) veya $(C !=) mantıksal ifadelerini kesirli sayı türleriyle kullanmak çoğu durumda hatalıdır)

$(LI Kesirli sayıların ilk değerleri 0 değil, $(C .nan)'dır. $(C .nan) değeriyle işlem yapmak anlamlı değildir; başka bir değerle karşılaştırıldığında $(C .nan) ne küçüktür ne de büyük.)

$(LI Artı yöndeki taşma değeri $(C .infinity), eksi yöndeki taşma değeri de $(I eksi) $(C .infinity)'dir)
)

$(P
Kesirli sayı türleri çok daha kullanışlıdırlar ama onların da mutlaka bilinmesi gereken özellikleri vardır. Kırpılma konusunda çok iyidirler, çünkü zaten özellikle virgülden sonrası için tasarlanmışlardır. Belirli sayıda bitle sınırlı oldukları için taşma bu türlerde de vardır ancak alabildikleri değer aralığı tamsayılarla karşılaştırıldığında olağanüstü geniştir. Ek olarak, tamsayı türlerinin taşma durumunda sessiz kalmalarının aksine, kesirli sayılar "sonsuzluk" değerini alırlar.
)

$(P
$(IX float)
$(IX double)
$(IX real)
Önce kesirli sayı türlerini hatırlayalım:
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr align="center"><th scope="col">Tür</th> <th scope="col">Bit Uzunluğu</th> <th scope="col">İlk Değeri</th></tr>
<tr align="center"><td>float</td>
	<td>32</td>
	<td>float.nan</td>
</tr>
<tr align="center"><td>double</td>

	<td>64</td>
	<td>double.nan</td>
</tr>
<tr align="center"><td>real</td>
	<td>en az 64, veya donanım sağlıyorsa$(BR)daha fazla (örneğin, 80)</td>

	<td>real.nan</td>
</tr>
</table>

$(H5 Kesirli tür nitelikleri)

$(P
Kesirli türlerin nitelikleri tamsayılardan daha fazladır:
)

$(UL

$(LI $(C .stringof) türün okunaklı ismidir)

$(LI $(C .sizeof) türün bayt olarak uzunluğudur; türün kaç bitten oluştuğunu hesaplamak için bu değeri bir bayttaki bit sayısı olan 8 ile çarpmak gerekir)

$(LI $(IX .min, kesirli sayı) $(C .max) "en çok" anlamına gelen "maximum"un kısaltmasıdır; türün alabileceği en büyük değerdir. Kesirli türlerde $(C .min) bulunmaz; türün alabileceği en düşük değer için $(C .max)'ın eksi işaretlisi kullanılır. Örneğin, $(C double) türünün alabileceği en düşük değer $(C -double.max)'tır.)

$(LI $(IX .min_normal) $(IX taşma, alttan) $(IX alttan taşma) $(C .min_normal) "türün ifade edebildiği sıfıra en yakın normalize değer" anlamındadır. Tür aslında bundan daha küçük değerler de ifade edebilir ama o değerlerin duyarlığı türün normal duyarlığının altındadır. Bir kesirli sayı değerinin $(C -.min_normal) ile $(C .min_normal) aralığında (0 hariç) olması durumuna $(I alttan taşma) denir.)

$(LI $(IX .dig) $(C .dig) "basamak sayısı" anlamına gelen "digits"in kısaltmasıdır; türün kaç basamak duyarlığı olduğunu belirtir)

$(LI $(IX .infinity) $(C .infinity) "sonsuz" anlamına gelir; taşma durumunda kullanılan değerdir.)
)

$(P
Kesirli sayı türlerinin diğer nitelikleri daha az kullanılır. Bütün nitelikleri dlang.org'da $(LINK2 http://dlang.org/property.html, Properties for Floating Point Types) başlığı altında bulabilirsiniz.
)

$(P
Yukarıdaki nitelikleri birbirleriyle olan ilişkilerini görmek için bir sayı çizgisine şöyle yerleştirebiliriz:
)

$(MONO
   +     +─────────+─────────+   ...   +   ...   +─────────+─────────+     +
   │   -max       -1         │         0         │         1        max    │
   │                         │                   │                         │
-infinity               -min_normal          min_normal               infinity
)

$(P
İki özel sonsuzluk değeri hariç, yukarıdaki çizginin ölçeği doğrudur: $(C min_normal) ile 1 arasında ne kadar değer ifade edilebiliyorsa, 1 ile $(C max) arasında da aynı sayıda değer ifade edilir. Bu da $(C min_normal) ile 1 arasındaki değerlerin son derece yüksek doğrulukta oldukları anlamına gelir. (Aynı durum eksi taraf için de geçerlidir.)
)

$(H5 $(IX .nan) $(C .nan))

$(P
Açıkça ilk değeri verilmeyen kesirli sayıların ilk değerlerinin $(C .nan) olduğunu gördük. $(C .nan) değeri bazı anlamsız işlemler sonucunda da ortaya çıkabilir. Örneğin şu programdaki ifadelerin hepsi $(C .nan) sonucunu verir:
)

---
import std.stdio;

void main() {
    double sıfır = 0;
    double sonsuz = double.infinity;

    writeln("nan kullanan her işlem: ", double.nan + 1);
    writeln("sıfır bölü sıfır      : ", sıfır / sıfır);
    writeln("sıfır kere sonsuz     : ", sıfır * sonsuz);
    writeln("sonsuz bölü sonsuz    : ", sonsuz / sonsuz);
    writeln("sonsuz eksi sonsuz    : ", sonsuz - sonsuz);
}
---

$(P
$(C .nan)'ın tek yararı bir değişkenin ilklenmemiş olduğunu göstermek değildir. İşlem sonuçlarında oluşan $(C .nan) değerleri sonraki hesaplar sırasında da korunurlar ve böylece hesap hatalarının erkenden ve kolayca yakalanmalarına yardım ederler.
)

$(H5 Kesirli sayıların yazımları)

$(P
Bu üç türün niteliklerine bakmadan önce kesirli sayıların nasıl yazıldıklarını görelim. Kesirli sayıları 123 gibi tamsayı şeklinde veya 12.3 gibi noktalı olarak yazabiliriz.
)

$(P
Ek olarak, $(C 1.23e+4) gibi bir yazımdaki $(C e+), "çarpı 10 üzeri" anlamına gelir. Yani bu örnek 1.23x10$(SUP 4)'tür, bir başka deyişle "1.23 çarpı 10000"dir ve ifadenin değeri 12300'dür.
)

$(P
Eğer $(C e)'den sonra gelen değer eksi ise, yani örneğin $(C 5.67e-3) gibi yazılmışsa, o zaman "10 üzeri o kadar değere bölünecek" demektir. Yani bu örnek 5.67/10$(SUP 3)'tür, bir başka deyişle "5.67 bölü 1000"dir ve ifadenin değeri 0.00567'dir.
)

$(P
Kesirli sayıların bu gösterimlerini türlerin niteliklerini yazdıran aşağıdaki programın çıktısında göreceksiniz:
)

---
import std.stdio;

void main() {
    writeln("Tür ismi                 : ", float.stringof);
    writeln("Duyarlık                 : ", float.dig);
    writeln("En küçük normalize değeri: ", float.min_normal);
    writeln("En küçük değeri          : ", -float.max);
    writeln("En büyük değeri          : ", float.max);
    writeln();

    writeln("Tür ismi                 : ", double.stringof);
    writeln("Duyarlık                 : ", double.dig);
    writeln("En küçük normalize değeri: ", double.min_normal);
    writeln("En küçük değeri          : ", -double.max);
    writeln("En büyük değeri          : ", double.max);
    writeln();

    writeln("Tür ismi                 : ", real.stringof);
    writeln("Duyarlık                 : ", real.dig);
    writeln("En küçük normalize değeri: ", real.min_normal);
    writeln("En küçük değeri          : ", -real.max);
    writeln("En büyük değeri          : ", real.max);
}
---

$(P
Programın çıktısı benim ortamımda aşağıdaki gibi oluyor. $(C real) türü donanıma bağlı olduğu için bu çıktı sizin ortamınızda farklı olabilir:
)

$(SHELL
Tür ismi                 : float
Duyarlık                 : 6
En küçük normalize değeri: 1.17549e-38
En küçük değeri          : -3.40282e+38
En büyük değeri          : 3.40282e+38

Tür ismi                 : double
Duyarlık                 : 15
En küçük normalize değeri: 2.22507e-308
En küçük değeri          : -1.79769e+308
En büyük değeri          : 1.79769e+308

Tür ismi                 : real
Duyarlık                 : 18
En küçük normalize değeri: 3.3621e-4932
En küçük değeri          : -1.18973e+4932
En büyük değeri          : 1.18973e+4932
)

$(H6 Gözlemler)

$(P
$(C ulong) türünün tutabileceği en yüksek değerin ne kadar çok basamağı olduğunu hatırlıyor musunuz: 18,446,744,073,709,551,616 sayısı 20 basamaktan oluşur. Buna karşın, en küçük kesirli sayı türü olan $(C float)'un bile tutabileceği en yüksek değer 10$(SUP 38) mertebesindedir. Yani şunun gibi bir değer: 340,282,000,000,000,000,000,000,000,000,000,000,000. $(C real)'in en büyük değeri ise 10$(SUP 4932) mertebesindedir (4900'den fazla basamağı olan bir sayı).
)

$(P
Başka bir gözlem olarak $(C double)'ın 15 duyarlıkla ifade edebileceği en düşük değere bakalım:
)

$(MONO
    0.000...$(I (burada 300 tane daha 0 var))...0000222507385850720
)

$(H5 Taşma gözardı edilmez)

$(P
Ne kadar büyük değerler tutuyor olsalar da kesirli sayılarda da taşma olabilir. Kesirli sayı türlerinin iyi tarafı, taşma oluştuğunda tamsayılardaki taşmanın tersine bundan haberimizin olabilmesidir: taşan sayının değeri "artı sonsuz" için $(C .infinity), "eksi sonsuz" için $(C -.infinity) haline gelir. Bunu görmek için şu programda $(C .max)'ın değerini %10 arttırmaya çalışalım. Sayı zaten en büyük değerinde olduğu için, %10 arttırınca taşacak ve yarıya bölünse bile değeri "sonsuz" olacaktır:
)

---
import std.stdio;

void main() {
    real sayı = real.max;

    writeln("Önce: ", sayı);

    // 1.1 ile çarpmak, %110 haline getirmektir:
    sayı *= 1.1;
    writeln("%10 arttırınca: ", sayı);

    // İkiye bölerek küçültmeye çalışalım:
    sayı /= 2;
    writeln("Yarıya bölünce: ", sayı);
}
---

$(P
O programda $(C sayı) bir kere $(C real.infinity) değerini alınca yarıya bölünse bile sonsuz değerinde kalır:
)

$(SHELL
Önce: 1.18973e+4932
%10 arttırınca: inf
Yarıya bölünce: inf
)

$(H5 $(IX duyarlık) $(IX hassasiyet) Duyarlık (Hassasiyet))

$(P
Duyarlık, yine günlük hayatta çok karşılaştığımız ama fazla sözünü etmediğimiz bir kavramdır. Duyarlık, bir değeri belirtirken kullandığımız basamak sayısıdır. Örneğin 100 liranın üçte birinin 33 lira olduğunu söylersek, duyarlık 2 basamaktır. Çünkü 33 değeri sadece iki basamaktan ibarettir. Daha hassas değerler gereken bir durumda 33.33 dersek, bu sefer dört basamak kullanmış olduğumuz için duyarlık 4 basamaktır.
)

$(P
Kesirli sayı türlerinin bit olarak uzunlukları yalnızca alabilecekleri en yüksek değerleri değil; değerlerin duyarlıklarını da etkiler. Bit olarak uzunlukları ne kadar fazlaysa, duyarlıkları da o kadar fazladır.
)

$(H5 Bölmede kırpılma yoktur)

$(P
Önceki bölümde gördüğümüz gibi, tamsayı bölme işlemlerinde sonucun virgülden sonrası kaybedilir:
)

---
    int birinci = 3;
    int ikinci = 2;
    writeln(birinci / ikinci);
---

$(P
Çıktısı:
)

$(SHELL
1
)

$(P
Kesirli sayı türlerinde ise virgülden sonrasını kaybetmek anlamında kırpılma yoktur:
)

---
    double birinci = 3;
    double ikinci = 2;
    writeln(birinci / ikinci);
---

$(P
Çıktısı:
)

$(SHELL
1.5
)

$(P
Virgülden sonraki bölümün doğruluğu kullanılan türün duyarlığına bağlıdır: $(C real) en yüksek duyarlıklı, $(C float) da en düşük duyarlıklı kesirli sayı türleridir.
)

$(H5 Hangi durumda hangi tür)

$(P
Özel bir neden yoksa her zaman için $(C double) türünü kullanabilirsiniz. $(C float)'un duyarlığı düşüktür ama küçük olmasının yarar sağlayacağı nadir programlardan birisini yazıyorsanız düşünerek ve ölçerek karar verebilirsiniz. Öte yandan, $(C real)'in duyarlığı bazı ortamlarda $(C double)'dan daha yüksek olduğundan yüksek duyarlığın önemli olduğu hesaplarda $(C real) türünü kullanmak isteyebilirsiniz.
)

$(H5 Her değeri ifade etmek olanaksızdır)

$(P
Her değerin ifade edilememesi kavramını önce günlük hayatımızda göstermek istiyorum. Kullandığımız onlu sayı sisteminde virgülden önceki basamaklar birler, onlar, yüzler, vs. basamaklarıdır; virgülden sonrakiler de onda birler, yüzde birler, binde birler, vs.
)

$(P
Eğer ifade etmek istediğimiz değer bu basamakların bir karışımı ise, değeri tam olarak ifade edebiliriz. Örneğin 0.23 değeri 2 adet $(I onda bir) değerinden ve 3 adet $(I yüzde bir) değerinden oluştuğu için tam olarak ifade edilebilir. Öte yandan, 1/3 değerini onlu sistemimizde tam olarak ifade edemeyiz çünkü virgülden sonra ne kadar uzatırsak uzatalım yeterli olmaz: 0.33333...
)

$(P
Benzer durum kesirli sayılarda da vardır. Türlerin bit sayıları sınırlı olduğu için, her değer tam olarak ifade edilemez.
)

$(P
Bilgisayarlarda kullanılan ikili sayı sistemlerinin bir farkı, virgülden öncesinin birler, ikiler, dörtler, vs. diye; virgülden sonrasının da yarımlar, dörtte birler, sekizde birler, vs. diye gitmesidir. Eğer değer bunların bir karışımı ise tam olarak ifade edilebilir; değilse edilemez.
)

$(P
Bilgisayarlarda tam olarak ifade edilemeyen bir değer 0.1'dir (10 kuruş gibi). Onlu sistemde tam olarak 0.1 şeklinde ifade edilebilen bu değer, ikili sistemde 0.0001100110011... diye tekrarlar ve kullanılan kesirli sayı türünün duyarlığına bağlı olarak belirli bir yerden sonra hatalıdır. (Tekrarladığını söylediğim o son sayıyı ikili sistemde yazdım, onlu değil...)
)

$(P
Bunu gösteren aşağıdaki örneği ilginç bulabilirsiniz. Bir değişkenin değerini bir döngü içinde her seferinde 0.001 arttıralım. Döngünün 1000 kere tekrarlanmasının ardından sonucun 1 olmasını bekleriz. Oysa öyle çıkmaz:
)

---
import std.stdio;

void main() {
    float sonuç = 0;

    // Bin kere 0.001 değerini ekliyoruz:
    int sayaç = 1;
    while (sayaç <= 1000) {
        sonuç += 0.001;
        ++sayaç;
    }

    if (sonuç == 1) {
        writeln("Beklendiği gibi 1");

    } else {
        writeln("FARKLI: ", sonuç);
    }
}
---

$(P
0.001 tam olarak ifade edilemeyen bir değer olduğundan, bu değerdeki hata miktarı sonucu döngünün her tekrarında etkilemektedir:
)

$(SHELL
FARKLI: 0.999991
)

$(P
$(I Not: Yukarıdaki $(C sayaç), döngü sayacı olarak kullanılmaktadır. Bu amaçla açıkça değişken tanımlamak aslında önerilmez. Onun yerine, daha ilerideki bir bölümde göreceğimiz $(LINK2 /ders/d/foreach_dongusu.html, $(C foreach) döngüsü) kullanılabilir.)
)

$(H5 Kesirli sayı karşılaştırmaları)

$(P
Tamsayılarda şu karşılaştırma işleçlerini kullanıyorduk: eşitlik ($(C ==)), eşit olmama ($(C !=)), küçüklük ($(C <)), büyüklük ($(C >)), küçük veya eşit olma ($(C <=)), büyük veya eşit olma ($(C >=)). Kesirli sayılarda başka karşılaştırma işleçleri de vardır.
)

$(P
Kesirli sayılarda geçersiz değeri gösteren $(C .nan) da bulunduğu için, onun diğer değerlerle küçük büyük olarak karşılaştırılması anlamsızdır. Örneğin $(C .nan)'ın mı yoksa 1'in mi daha büyük olduğu gibi bir soru yanıtlanamaz.
)

$(P
$(IX sırasızlık) Bu yüzden kesirli sayılarda başka bir karşılaştırma kavramı daha vardır: sırasızlık. Sırasızlık, değerlerden en az birisinin $(C .nan) olması demektir.)

$(P
Aşağıdaki tablo kesirli sayı karşılaştırma işleçlerini gösteriyor. İşleçlerin hepsi ikilidir ve örneğin $(C soldaki == sağdaki) şeklinde kullanılır. $(C false) ve $(C true) içeren sütunlar, işleçlerin hangi durumda ne sonuç verdiğini gösterir.
)

$(P
$(IX <>)
$(IX !<>)
Sonuncu sütun, ifadelerden birisinin $(C .nan) olması durumunda o işlecin kullanımının anlamlı olup olmadığını gösterir. Örneğin $(C 1.2 < real.nan) ifadesinin sonucu $(C false) çıksa bile, ifadelerden birisi $(C real.nan) olduğu için bu sonucun bir anlamı yoktur çünkü bunun tersi olan $(C real.nan < 1.2) ifadesi de $(C false) verir.
)

<table class="full" border="1" cellpadding="4" cellspacing="0">
<tr align="center">	<th scope="col">$(BR)İşleç</th>
<th scope="col">$(BR)Anlamı</th>
<th scope="col">Soldaki$(BR)Büyükse</th>
<th scope="col">Soldaki$(BR)Küçükse</th>
<th scope="col">İkisi$(BR)Eşitse</th>

<th scope="col">En Az Birisi$(BR).nan ise</th>
<th scope="col">.nan ile$(BR)Anlamlı</th>
</tr>
<tr align="center">	<td>==</td><td>eşittir</td>	<td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_YES evet)</td>

</tr>
<tr align="center">	<td>!=</td><td>eşit değildir</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>
</tr>
<tr align="center">	<td>&gt;</td><td>büyüktür</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_NO hayır)</td>

</tr>
<tr align="center">	<td>&gt;=</td><td>büyüktür veya eşittir</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_NO hayır)</td>
</tr>
<tr align="center">	<td>&lt;</td><td>küçüktür</td>	<td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_NO hayır)</td>

</tr>
<tr align="center">	<td>&lt;=</td><td>küçüktür veya eşittir</td>	<td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_NO hayır)</td>
</tr>
<tr align="center">	<td>!&lt;&gt;=</td><td>küçük, büyük, eşit değildir</td> <td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>

</tr>
<tr align="center">	<td>&lt;&gt;</td><td>küçüktür veya büyüktür</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_NO hayır)</td>
</tr>
<tr align="center">	<td>&lt;&gt;=</td><td>küçüktür, büyüktür, veya eşittir</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_NO hayır)</td>

</tr>
<tr align="center">	<td>!&lt;=</td><td>küçük değildir ve eşit değildir</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>
</tr>

<tr align="center">	<td>!&lt;</td><td>küçük değildir</td>	<td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>
</tr>
<tr align="center">	<td>!&gt;=</td><td>büyük değildir ve eşit değildir</td>	<td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>

</tr>
<tr align="center">	<td>!&gt;</td><td>büyük değildir</td>	<td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>
</tr>
<tr align="center">	<td>!&lt;&gt;</td><td>küçük değildir ve büyük değildir</td>	<td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_FALSE false)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_TRUE true)</td><td>$(UNORDERED_YES evet)</td>

</tr>
</table>

$(P
Her ne kadar $(C .nan) ile kullanımı anlamlı olsa da, değerlerden birisi $(C .nan) olduğunda $(C ==) işleci her zaman için $(C false) üretir. Her iki değer de $(C .nan) olduğunda bile sonuç $(C false) çıkar:
)

---
import std.stdio;

void main() {
    if (double.nan == double.nan) {
        writeln("eşitler");

    } else {
        writeln("eşit değiller");
    }
}
---

$(P
$(C double.nan)'ın kendisine eşit olacağı beklenebilir, ancak karşılaştırmanın sonucu yine de $(C false)'tur:
)

$(SHELL
eşit değiller
)

$(H6 $(IX isNan, std.math) $(C .nan) eşitlik karşılaştırması için $(C isNaN()))

$(P
Yukarıda gördüğümüz gibi, bir kesirli sayı değişkeninin $(C .nan)'a eşit olup olmadığı $(C ==) işleci ile karşılaştırılamaz:
)

---
    if (kesirli == double.nan) {    $(CODE_NOTE_WRONG YANLIŞ KARŞILAŞTIRMA)
        // ...
    }
---

$(P
O yüzden $(C std.math) modülündeki "nan değerinde mi?" sorusunun yanıtını veren $(C isNaN()) işlevinden yararlanmak gerekir:
)

---
import std.math;
// ...
    if (isNaN(kesirli)) {    $(CODE_NOTE doğru karşılaştırma)
        // ...
    }
---

$(P
Benzer biçimde, $(C .nan)'a eşit olmadığı da $(C !=) ile değil, $(C !isNaN()) ile denetlenmelidir.
)

$(PROBLEM_COK

$(PROBLEM
Yukarıda bin kere 0.001 ekleyen programı $(C float) yerine $(C double) (veya $(C real)) kullanacak biçimde değiştirin:

---
    $(HILITE double) sonuç = 0;
---

$(P
Bu problem, kesirli sayı türlerinin eşitlik karşılaştırmalarında kullanılmasının ne kadar yanıltıcı olabildiğini göstermektedir.
)

)

$(PROBLEM
Önceki bölümdeki hesap makinesini kesirli bir tür kullanacak şekilde değiştirin. Böylece hesap makineniz çok daha doğru sonuçlar verecektir. Denerken değerleri girmek için 1000, 1.23, veya 1.23e4 şeklinde yazabilirsiniz.
)

$(PROBLEM
Girişten 5 tane kesirli sayı alan bir program yazın. Bu sayıların önce iki katlarını yazsın, sonra da beşe bölümlerini. Bu problemi bir sonra anlatılacak olan dizilere hazırlık olarak soruyorum. Eğer bu programı şimdiye kadar öğrendiklerinizle yazarsanız, dizileri anlamanız daha kolay olacak.
)

)

Macros:
        SUBTITLE=Kesirli Sayılar

        DESCRIPTION=D dilinde kesirli sayıların tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial kesirli sayılar kayan noktalı sayılar

SOZLER=
$(duyarlik)
$(infinity)
$(kirpilma)
$(nitelik)
$(sirasizlik)
$(tasma)
