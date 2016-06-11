Ddoc

$(DERS_BOLUMU $(IX tamsayı) $(IX aritmetik işlemler) Tamsayılar ve Aritmetik İşlemler)

$(P
D'nin karar verme ile ilgili yapılarından $(C if)'i ve $(C while)'ı gördük. Bu bölümde temel türlerin sayısal olanlarıyla yapılan aritmetik işlemlere bakacağız. Böylece bundan sonraki bölümlerde çok daha becerikli ve ilginç programlar yazabileceksiniz.
)

$(P
Aritmetik işlemler aslında son derece basittirler çünkü zaten günlük hayatımızda her zaman karşımıza çıkarlar. Buna rağmen, temel türlerle ilgilenirken mutlaka bilinmesi gereken çok önemli kavramlar da vardır. $(I Tür uzunluğu), $(I taşma), ve $(I kırpılma) kavramlarını anlıyorsanız bütün konuyu bu tabloya bakarak geçebilirsiniz:
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">İşleç</th> <th scope="col">Etkisi</th> <th scope="col">Örnek kullanım</th>

</tr>
<tr align="center"><td>++</td>
    <td>değerini bir arttırır</td>
    <td>++değişken</td>
</tr>
<tr align="center"><td>--</td>
    <td>değerini bir azaltır</td>
    <td>--değişken</td>
</tr>
<tr align="center"><td>+</td>
    <td>iki değerin toplamı</td>
    <td>birinci&nbsp;+&nbsp;ikinci</td>
</tr>
<tr align="center"><td>-</td>
    <td>birinciden ikincinin çıkarılmışı</td>
    <td>birinci&nbsp;-&nbsp;ikinci</td>
</tr>
<tr align="center"><td>*</td>
    <td>iki değerin çarpımı</td>
    <td>birinci&nbsp;*&nbsp;ikinci</td>
</tr>
<tr align="center"><td>/</td>
    <td>birincinin ikinciye bölümü</td>
    <td>birinci&nbsp;/&nbsp;ikinci</td>
</tr>
<tr align="center"><td>%</td>
    <td>birincinin ikinciye bölümününden kalan</td>
    <td>birinci&nbsp;%&nbsp;ikinci</td>
</tr>
<tr align="center"><td>^^</td>
    <td>birincinin ikinci'nin değeri kadar üssü$(BR)(birincinin ikinci kere kendisiyle çarpımı)</td>
    <td>birinci&nbsp;^^&nbsp;ikinci</td>
</tr>
</table>

$(P
$(IX +=) $(IX -=) $(IX *=) $(IX /=) $(IX %=) $(IX ^^=) Tablodaki ikili işleçlerin yanına $(C =) karakteri gelenleri de vardır: $(C +=), $(C -=), $(C *=), $(C /=), $(C %=), ve $(C ^^=). Bunlar işlemin sonucunu soldaki değişkene atarlar:
)

---
    sayı += 10;
---

$(P
O ifade $(C sayı)'ya 10 ekler ve sonucu yine $(C sayı)'ya atar; sonuçta değerini 10 arttırmış olur. Şu ifadenin eşdeğeridir:
)

---
    sayı = sayı + 10;
---

$(P $(B Taşma:) Her değer her türe sığmaz ve taşabilir. Örneğin, 0 ile 255 arasında değerler tutabilen $(C ubyte)'a 260 değeri verilmeye kalkışılırsa değeri 4 olur. ($(I Not: C ve C++ gibi bazı dillerin tersine, taşma D'de işaretli türler için de yasaldır ve işaretsiz türlerle aynı davranışa sahiptir.))
)

$(P $(B Kırpılma:) Tamsayılar virgülden sonrasını tutamazlar. Örneğin 3/2 ifadesinin değeri 1 olur.)

$(P
Eğer bu kavramları örneğin başka dillerden biliyorsanız, bu kadarı yetebilir. İsterseniz geri kalanını okumayabilirsiniz, ama yine de sondaki problemleri atlamayın.
)

$(P
Bu bölüm ilgisiz bilgiler veriyor gibi gelebilir; çünkü aritmetik işlemler hepimizin  günlük hayatta sürekli olarak karşılaştığımız kavramlardır: Tanesi 10 lira olan bir şeyden iki tane alırsak 20 lira veririz, veya üçü 45 lira olan şeylerin tanesi 15 liradır.
)

$(P
Ne yazık ki işler bilgisayarda bu kadar basit olmayabilir. Sayıların bilgisayarda nasıl saklandıklarını bilmezsek, örneğin 3 milyar borcu olan bir firmanın 3 milyar daha borç alması sonucunda borcunun 1.7 milyara $(I düştüğünü) görebiliriz. Başka bir örnek olarak, 1 kutusu 4 çocuğa yeten dondurmadan 11 çocuk için 2 tane yetecek diye hesaplayabiliriz.
)

$(P
Bu bölüm size öncekilerden daha teknik gelebilir ama tamsayıların bilgisayarda nasıl ifade edildiklerinin bir programcı tarafından mutlaka bilinmesi gerekir.
)

$(H6 Tamsayılar)

$(P
Tamsayılar ancak tam değerler alabilen türlerdir: -2, 0, 10, vs. Bu türler 2.5 gibi kesirli değerler tutamazlar. Daha önce temel türler tablosunda da gördüğünüz tamsayı türleri şunlardır:
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">$(BR)Tür</th> <th scope="col">Bit$(BR)Uzunluğu</th> <th scope="col">İlk$(BR)Değeri</th>

</tr>
<tr align="right"><td>byte</td>
    <td>8</td>
    <td>0</td>

</tr>
<tr align="right"> <td>ubyte</td>
    <td>8</td>
    <td>0</td>
</tr>
<tr align="right"> <td>short</td>

    <td>16</td>
    <td>0</td>
</tr>
<tr align="right"> <td>ushort</td>
    <td>16</td>
    <td>0</td>

</tr>
<tr align="right"> <td>int</td>
    <td>32</td>
    <td>0</td>
</tr>
<tr align="right"> <td>uint</td>

    <td>32</td>
    <td>0</td>
</tr>
<tr align="right"> <td>long</td>
    <td>64</td>
    <td>0L</td>

</tr>
<tr align="right"> <td>ulong</td>
    <td>64</td>
    <td>0L</td>
</tr>
</table>

$(P
Hatırlarsanız, tür isimlerinin başındaki $(C u) karakteri "unsigned"dan geliyordu ve "işaretsiz" demekti. O türler $(I eksi işareti olmayan) türlerdir ve yalnızca sıfır ve daha büyük değerler alabilirler.
)

$(H6 $(IX bit) Bitler ve tür uzunlukları)

$(P
Günümüzdeki bilgisayar sistemlerinde en küçük bilgi parçası bittir. Bit, elektronik düzeyde ve devrelerin belirli noktalarında $(I elektrik geriliminin var olup olmaması) kavramıyla belirlendiği için, ancak iki durumdan birisinde bulunabilir. Bu durumlar 0 ve 1 değerleri olarak kabul edilmişlerdir. Yani sonuçta bir bit, iki değişik değer saklayabilir.
)

$(P
Yalnızca iki durumla ifade edilebilen kavramlarla fazla karşılaşmadığımız için bitin kullanışlılığı da azdır: yazı veya tura, odada ışıkların açık olup olmadığı, vs. gibi iki durumu olan kavramlar...
)

$(P
Biraz ileri giderek iki biti bir araya getirirsek, ikisinin birlikte saklayabilecekleri toplam değer adedi artar. İkisinin ayrı ayrı 0 veya 1 durumunda olmalarına göre toplam 4 olasılık vardır. Soldaki rakam birinci biti, sağdaki rakam da ikinci biti gösteriyor olsun: 00, 01, 10, ve 11. Yani bir bit eklemeyle toplam durum sayısı ikiye katlanmış olur. Bit eklemenin etkisini daha iyi görebilmek için bir adım daha atabiliriz: Üç bit, toplam 8 değişik durumda bulunabilir: 000, 001, 010, 011, 100, 101, 110, 111.
)

$(P
Bu sekiz durumun hangi tamsayı değerlerine karşılık gelecekleri tamamen anlaşmalara ve geleneklere kalmıştır. Yoksa örneğin 000 durumu 42 değerini, 001 durumu 123 değerini, vs. gösteriyor da olabilirdi. Tabii bu kadar ilgisiz değerler kullanışlı olmayacaklarından, 3 bitlik bir türü örnek alırsak, bu 8 durumun işaretli ve işaretsiz olarak kullanılmasında aldığı değerler şu tablodakine benzer:
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0">
<tr align="right"><th scope="col">Bitlerin$(BR)Durumu</th> <th scope="col">İşaretsiz$(BR)Değer</th>  <th scope="col">İşaretli$(BR)Değer</th></tr>
<tr align="right"><td>000</td> <td>0</td> <td>0</td> </tr>
<tr align="right"><td>001</td> <td>1</td> <td>1</td> </tr>
<tr align="right"><td>010</td> <td>2</td> <td>2</td> </tr>
<tr align="right"><td>011</td> <td>3</td> <td>3</td> </tr>
<tr align="right"><td>100</td> <td>4</td> <td>-4</td> </tr>
<tr align="right"><td>101</td> <td>5</td> <td>-3</td> </tr>
<tr align="right"><td>110</td> <td>6</td> <td>-2</td> </tr>
<tr align="right"><td>111</td> <td>7</td> <td>-1</td> </tr>
</table>

$(P
Burada görmenizi istediğim, 3 bitten nasıl 8 farklı değer elde edilebildiğidir.
)

$(P
Görüldüğü gibi, eklenen her bit, saklanabilecek bilgi miktarını iki katına çıkartmaktadır. Bunu devam ettirirsek; bitlerin bir araya getirilmelerinden oluşturulan değişik uzunluktaki türlerin saklayabildikleri farklı değer miktarlarını, bir önceki bit uzunluğunun saklayabileceği değer miktarını 2 ile çarparak şöyle görebiliriz:
)

<table class="wide" style="font-size:.9em" border="1" cellpadding="4" cellspacing="0">
<tr align="right"><th scope="col">Bit$(BR)Adedi</th> <th scope="col">Saklanabilecek$(BR)Farklı Değer Adedi</th><th scope="col">$(BR)D&nbsp;Türü</th><th scope="col">En Küçük$(BR)Değeri</th><th scope="col">En Büyük$(BR)Değeri</th>  </tr>
<tr align="right"><td>1</td><td>2</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>2</td><td>4</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>3</td><td>8</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>4</td><td>16</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>5</td><td>32</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>6</td><td>64</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>7</td><td>128</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>8</td><td>256</td> <td>byte$(BR)ubyte</td><td>-128$(BR)0</td><td>127$(BR)255</td></tr>
<tr align="right"><td>...</td><td>...</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>16</td><td>65,536</td> <td>short$(BR)ushort</td><td>-32768$(BR)0</td><td>32767$(BR)65535</td></tr>
<tr align="right"><td>...</td><td>...</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>32</td><td>4,294,967,296</td> <td>int$(BR)uint</td><td>-2147483648$(BR)0</td><td>2147483647$(BR)4294967295</td></tr>
<tr align="right"><td>...</td><td>...</td> <td></td><td></td><td></td></tr>
<tr align="right"><td>64</td><td>18,446,744,073,709,551,616</td> <td>long$(BR)ulong</td><td>-9223372036854775808$(BR)0</td><td>9223372036854775807$(BR)18446744073709551615</td></tr>
<tr align="right"><td>...</td><td>...</td> <td></td><td></td><td></td></tr>
</table>

$(P
Bazı tablo satırlarını atladım ve aynı sayıda bitten oluşan D türlerinin işaretli ve işaretsiz olanlarını aynı satırda gösterdim (örneğin $(C int) ve $(C uint) 32 bitlik satırdalar).
)

$(H6 Hangi durumda hangi tür)

$(P
Üç bitlik bir tür toplam 8 değer taşıyabildiği için örneğin ancak $(I atılan zarın sonucu) veya $(I haftanın gün sayısı) gibi kavramları ifade etmek için kullanılabilir. (D'de 3 bitlik tür yoktur; örnek olarak kullanıyorum.)
)

$(P
Öte yandan, $(C uint) çok büyük bir tür olsa da, dünyadaki bütün insanları kapsayacak bir kimlik kartı numarası gibi bir kavram için kullanılamaz, çünkü $(C uint) dünyadaki insan nüfusu olan 7 milyardan daha az sayıda değer saklayabilir. $(C long) ve $(C ulong)'un Türkçe'de nasıl okunduğunu bile bilemeyeceğim toplam değer adedi ise çoğu kavram için fazlasıyla yeterlidir.
)

$(P
Temel bir kural olarak, özel bir neden yoksa, tamsayılar için öncelikle $(C int)'i düşünebilirsiniz.
)

$(H6 $(IX taşma) Taşma)

$(P
Türlerin bit sayılarıyla belirlenen bu kısıtlamaları, onlarla yapılan işlemlerde beklenmedik sonuçlar verebilir. Örneğin değerleri 3 milyar olan iki $(C uint)'in toplamı gerçekte 6 milyar olsa da, en fazla 4 milyar kadar değer saklayabilen $(C uint)'e sığmaz. Bu durumda sonuç $(C uint)'ten $(I taşmış) olur; programda hiçbir uyarı verilmeden 6 milyarın ancak 4 milyardan geri kalanı, yani 2 milyar kadarı sonuç değişkeninde kalır. (Aslında 6 milyar eksi 4.3 milyar, yani yaklaşık olarak 1.7 milyar...)
)

$(H6 $(IX kırpılma) Kırpılma)

$(P
Tamsayılar kesirli değerler tutamadıkları için ne kadar önemli olsa da, virgülden sonraki bilgiyi kaybederler. Örneğin 1 kutusu 4 çocuğa yeten dondurmadan 11 çocuk için 2.75 kutu gerekiyor olsa bile, bu değer bir tamsayı tür içinde ancak 2 olarak saklanabilir.
)

$(P
Taşmaya ve kırpılmaya karşı alabileceğiniz bazı önlemleri işlemlerin tanıtımından sonra vereceğim. Önce aritmetik işlemleri tanıyalım.
)

$(H6 Tür nitelikleri hatırlatması)

$(P
Temel türlerin tanıtıldığı bölümde tür niteliklerini görmüştük: $(C .min), türün alabileceği en küçük değeri; $(C .max) da en büyük değeri veriyordu.
)

$(H6 $(IX ++, arttırma) $(IX arttırma) Arttırma: $(C ++))

$(P
Tek bir değişkenle kullanılır. Değişkenin isminden önce yazılır ve o değişkenin değerini 1 arttırır:
)

---
import std.stdio;

void main() {
    int sayı = 10;
    ++sayı;
    writeln("Yeni değeri: ", sayı);
}
---

$(SHELL
Yeni değeri: 11
)

$(P
Arttırma işleci, biraz aşağıda göreceğiniz $(I atamalı toplama) işlecinin 1 değeri ile kullanılmasının eşdeğeridir:
)

---
    sayı += 1;      // ++sayı ifadesinin aynısı
---

$(P
Arttırma işleminin sonucu; eğer türün taşıyabileceği en yüksek değeri aşıyorsa, o zaman $(I taşar) ve türün alabildiği en düşük değere dönüşür. Bunu denemek için önceki değeri $(C int.max) olan bir değişkeni arttırırsak, yeni değerinin $(C int.min) olduğunu görürüz:
)

---
import std.stdio;

void main() {
    writeln("en düşük int değeri   : ", int.min);
    writeln("en yüksek int değeri  : ", int.max);

    int sayı = int.max;
    writeln("sayının önceki değeri : ", sayı);
    ++sayı;
    writeln("sayının sonraki değeri: ", sayı);
}
---

$(SHELL
en düşük int değeri   : -2147483648
en yüksek int değeri  : 2147483647
sayının önceki değeri : 2147483647
sayının sonraki değeri: -2147483648
)

$(P
Bu çok önemli bir konudur; çünkü sayı hiçbir uyarı verilmeden, en yüksek değerinden en düşük değerine geçmektedir; hem de $(I arttırma) işlemi sonucunda!
)

$(P
Buna $(I taşma) denir. Benzer taşma davranışlarını azaltma, toplama, ve çıkarma işlemlerinde de göreceğiz.
)

$(H6 $(IX --, azaltma) $(IX azaltma) Azaltma: $(C --))

$(P
Tek bir değişkenle kullanılır. Değişkenin isminden önce yazılır ve o değişkenin değerini 1 azaltır:
)

---
    --sayı;   // değeri bir azalır
---

$(P
Azaltma işleci, biraz aşağıda göreceğiniz $(I atamalı çıkarma) işlecinin 1 değeri ile kullanılmasının eşdeğeridir:
)

---
    sayı -= 1;      // --sayı ifadesinin aynısı
---


$(P
$(C ++) işlecine benzer şekilde, eğer değişkenin değeri baştan o türün en düşük değerindeyse, yeni değeri o türün en yüksek değeri olur. Buna da $(I taşma) denir.
)

$(H6 $(IX +, toplama) $(IX toplama) Toplama: +)

$(P
İki ifadeyle kullanılır ve aralarına yazıldığı iki ifadenin toplamını verir:
)

---
import std.stdio;

void main() {
    int birinci = 12;
    int ikinci = 100;

    writeln("Sonuç: ", birinci + ikinci);
    writeln("Sabit ifadeyle: ", 1000 + ikinci);
}
---

$(SHELL
Sonuç: 112
Sabit ifadeyle: 1100
)

$(P
Eğer iki ifadenin toplamı o türde saklanabilecek en yüksek değerden fazlaysa, yine $(I taşma) oluşur ve değerlerin ikisinden de daha küçük bir sonuç elde edilir:
)

---
import std.stdio;

void main() {
    // İki tane 3 milyar
    uint birinci = 3000000000;
    uint ikinci = 3000000000;

    writeln("uint'in en yüksek değeri: ", uint.max);
    writeln("                 birinci: ", birinci);
    writeln("                  ikinci: ", ikinci);
    writeln("                  toplam: ", birinci + ikinci);
    writeln("TAŞMA! Sonuç 6 milyar olmadı!");
}
---

$(SHELL
uint'in en yüksek değeri: 4294967295
                 birinci: 3000000000
                  ikinci: 3000000000
                  toplam: 1705032704
TAŞMA! Sonuç 6 milyar olmadı!
)

$(H6 $(IX -, çıkarma) $(IX çıkarma) Çıkarma: $(C -))

$(P
İki ifadeyle kullanılır ve birinci ile ikincinin farkını verir:
)

---
import std.stdio;

void main() {
    int sayı_1 = 10;
    int sayı_2 = 20;

    writeln(sayı_1 - sayı_2);
    writeln(sayı_2 - sayı_1);
}
---

$(SHELL
-10
10
)

$(P
Eğer sonucu tutan değişken işaretsizse ve sonuç eksi bir değer alırsa, yine garip sonuçlar doğar. Yukarıdaki programı $(C uint) için tekrar yazarsak:
)

---
import std.stdio;

void main() {
    uint sayı_1 = 10;
    uint sayı_2 = 20;

    writeln("SORUN! uint eksi değer tutamaz:");
    writeln(sayı_1 - sayı_2);
    writeln(sayı_2 - sayı_1);
}
---

$(SHELL
SORUN! uint eksi değer tutamaz:
4294967286
10
)

$(P
Eninde sonunda farkları alınacak kavramlar için hep işaretli türlerden seçmek iyi bir karardır. Yine, özel bir neden yoksa normalde $(C int)'i seçebilirsiniz.
)

$(H6 $(IX *, çarpma) $(IX çarpma) Çarpma: $(C *))

$(P
İki ifadenin değerlerini çarpar. Yine taşmaya maruzdur:
)

---
import std.stdio;

void main() {
    uint sayı_1 = 6;
    uint sayı_2 = 7;

    writeln(sayı_1 * sayı_2);
}
---

$(SHELL
42
)

$(H6 $(IX /) $(IX bölme) Bölme: $(C /))

$(P
Birinci ifadeyi ikinci ifadeye böler. Tamsayılar kesirli sayı tutamayacakları için, eğer varsa sonucun kesirli kısmı atılır. Buna $(I kırpılma) denir. Örneğin bu yüzden aşağıdaki program 3.5 değil, 3 yazmaktadır:
)

---
import std.stdio;

void main() {
    writeln(7 / 2);
}
---

$(SHELL
3
)

$(P
Virgülden sonrasının önemli olduğu hesaplarda tamsayı türleri değil, $(I kesirli sayı türleri) kullanılır. Kesirli sayı türlerini bir sonraki bölümde göreceğiz.
)

$(H6 $(IX %) $(IX kalan) Kalan: %)

$(P
Birinci ifadeyi ikinci ifadeye böler ve kalanını verir. Örneğin 10'un 6'ya bölümünden kalan 4'tür:
)

---
import std.stdio;

void main() {
    writeln(10 % 6);
}
---

$(SHELL
4
)

$(P
Bu işleç bir sayının tek veya çift olduğunu anlamada kullanılır. Tek sayıların ikiye bölümünden kalan her zaman için 1 olduğundan, kalanın 0 olup olmadığına bakarak sayının tek veya çift olduğu kolayca anlaşılır:
)

---
    if ((sayı % 2) == 0) {
        writeln("çift sayı");
    } else {
        writeln("tek sayı");
    }
---

$(H6 $(IX ^^) $(IX üs alma) Üs alma: ^^)

$(P
Birinci ifadenin ikinci ifade ile belirtilen üssünü alır. Örneğin 3 üssü 4, 3'ün 4 kere kendisiyle çarpımıdır:
)

---
import std.stdio;

void main() {
    writeln(3 ^^ 4);
}
---

$(SHELL
81
)

$(H6 $(IX atamalı aritmetik işleci) Atamalı aritmetik işleçleri)

$(P
Yukarıda gösterilen ve iki ifade alan aritmetik işleçlerin atamalı olanları da vardır. Bunlar işlemi gerçekleştirdikten sonra ek olarak sonucu sol taraftaki değişkene atarlar:
)

---
import std.stdio;

void main() {
    int sayı = 10;

    sayı += 20;  // sayı = sayı + 20 ile aynı şey; şimdi 30
    sayı -= 5;   // sayı = sayı - 5  ile aynı şey; şimdi 25
    sayı *= 2;   // sayı = sayı * 2  ile aynı şey; şimdi 50
    sayı /= 3;   // sayı = sayı / 3  ile aynı şey; şimdi 16
    sayı %= 7;   // sayı = sayı % 7  ile aynı şey; şimdi  2
    sayı ^^= 6;  // sayı = sayı ^^ 6 ile aynı şey; şimdi 64

    writeln(sayı);
}
---

$(SHELL
64
)

$(H6 $(IX -, eksi işareti) $(IX eksi işareti) Eksi işareti: $(C -))

$(P
Önüne yazıldığı ifadenin değerini artıysa eksi, eksiyse artı yapar:
)

---
import std.stdio;

void main() {
    int sayı_1 = 1;
    int sayı_2 = -2;

    writeln(-sayı_1);
    writeln(-sayı_2);
}
---

$(SHELL
-1
2
)

$(P
Bu işlecin sonucunun türü, değişkenin türü ile aynıdır. $(C uint) gibi işaretsiz türler eksi değerler tutamadıkları için, bu işlecin onlarla kullanılması şaşırtıcı sonuçlar doğurabilir:
)

---
    $(HILITE uint) sayı = 1;
    writeln("eksi işaretlisi: ", -sayı);
---

$(P
$(C -sayı) ifadesinin türü de $(C uint)'tir ve o yüzden eksi değer alamaz:
)

$(SHELL
eksi işaretlisi: 4294967295
)

$(H6 $(IX +, artı işareti) $(IX artı işareti) Artı işareti: $(C +))

$(P
Matematikte sayıların önüne yazılan + işareti gibi bunun da hiçbir etkisi yoktur. İfadenin değeri eksiyse yine eksi, artıysa yine artı kalır:
)

---
import std.stdio;

void main() {
    int sayı_1 = 1;
    int sayı_2 = -2;

    writeln(+sayı_1);
    writeln(+sayı_2);
}
---

$(SHELL
1
-2
)

$(H6 $(IX ++, arttırma, önceki değerli) $(IX önceki değerli arttırma) $(IX sonek arttırma) $(IX arttırma, sonek) Önceki değerli (sonek) arttırma: $(C ++))

$(P
$(I Not: Özel bir nedeni yoksa normal arttırma işlecini kullanmanızı öneririm.)
)

$(P
Normal arttırma işlecinden farklı olarak ifadeden sonra yazılır. Yukarıda anlatılan $(C ++) işlecinde olduğu gibi ifadenin değerini bir arttırır, ama içinde geçtiği ifadede $(I önceki değeri) olarak kullanılır. Bunun etkisini görmek için normal $(C ++) işleciyle karşılaştıralım:
)

---
import std.stdio;

void main() {
    int normal_arttırılan = 1;
    writeln(++normal_arttırılan);           // 2 yazılır
    writeln(normal_arttırılan);             // 2 yazılır

    int önceki_değerli_arttırılan = 1;

    // Değeri arttırılır ama ifadede önceki değeri kullanılır:
    writeln(önceki_değerli_arttırılan++);   // 1 yazılır
    writeln(önceki_değerli_arttırılan);     // 2 yazılır
}
---

$(SHELL
2
2
1
2
)

$(P
Yukarıdaki arttırma işleminin olduğu satır şunun eşdeğeridir:
)

---
    int önceki_değeri = önceki_değerli_arttırılan;
    ++önceki_değerli_arttırılan;
    writeln(önceki_değeri);                 // 1 yazılır
---

$(P
Yani bir anlamda, sayı arttırılmıştır, ama içinde bulunduğu ifadede $(I önceki değeri) kullanılmıştır.
)

$(H6 $(IX --, azaltma, önceki değerli) $(IX önceki değerli azaltma) $(IX sonek azaltma) $(IX azaltma, sonek) Önceki değerli (sonek) azaltma: $(C --))

$(P
$(I Not: Özel bir nedeni yoksa normal azaltma işlecini kullanmanızı öneririm.)
)

$(P
Önceki değerli arttırma $(C ++) ile aynı şekilde davranır ama arttırmak yerine azaltır.
)

$(H6 İşleç öncelikleri)

$(P
Yukarıdaki işleçleri hep tek başlarına ve bir veya iki ifade ile gördük. Oysa mantıksal ifadelerde olduğu gibi, birden fazla aritmetik işleci bir arada kullanarak daha karmaşık işlemler oluşturabiliriz:
)

---
int sayı = 77;
int sonuç = (((sayı + 8) * 3) / (sayı - 1)) % 5;
---

$(P
Mantıksal ifadelerde olduğu gibi, bu işleçlerin de D tarafından belirlenmiş olan öncelikleri vardır. Örneğin, $(C *) işlecinin önceliği $(C +) işlecininkinden yüksek olduğundan, parantezler kullanılmadığında $(C sayı + 8 * 3) ifadesi önce $(C *) işlemi uygulanacağı için $(C sayı + 24) olarak hesaplanır. Bu da yukarıdakinden farklı bir işlemdir.
)

$(P
O yüzden, parantezler kullanarak hem işlemleri doğru sırada uygulatmış olursunuz, hem de kodu okuyan kişilere kodu anlamalarında yardımcı olmuş olursunuz.
)

$(P
İşleç öncelikleri tablosunu $(LINK2 /ders/d/islec_oncelikleri.html, ilerideki bir bölümde) göreceğiz.
)

$(H6 Taşma olduğunu belirlemek)

$(P
$(IX core.checkedint) $(IX checkedint) $(IX adds) $(IX addu) $(IX subs) $(IX subu) $(IX muls) $(IX mulu) $(IX negs) Her ne kadar henüz görmediğimiz $(LINK2 /ders/d/islevler.html, işlev) ve $(LINK2 /ders/d/islev_parametreleri.html, $(C ref) parametre) olanaklarını kullansa da, taşma durumunu bildirebilen $(LINK2 http://dlang.org/phobos/core_checkedint.html, $(C core.checkedint) modülünü) burada tanıtmak istiyorum. Bu modül $(C +) ve $(C -) gibi işleçleri değil, şu işlevleri kullanır: işaretli ve işaretsiz toplama için $(C adds) ve $(C addu), işaretli ve işaretsiz çıkarma için $(C subs) ve $(C subu), işaretli ve işaretsiz çarpma için $(C muls) ve $(C mulu), ve ters işaretlisini almak için $(C negs).
)

$(P
Örneğin, $(C a) ve $(C b)'nin $(C int) türünde iki değişken olduklarını varsayarsak, toplamlarının taşıp taşmadığını aşağıdaki kod ile denetleyebiliriz:
)

---
    // Aşağıdaki 'adds' işlevi sırasında sonuç taşmışsa bu
    // değişkenin değeri 'true' olur:
    bool taştı_mı = false;
    int sonuç = adds(a, b, $(HILITE taştı_mı));

    if (taştı_mı) {
        // 'sonuç'u kullanamayız çünkü taşmış
        // ...

    } else {
        // 'sonuç'u kullanabiliriz
        // ...
    }
---

$(H6 Taşmaya karşı önlemler)

$(P
Eğer bir işlemin sonucu seçilen türe sığmıyorsa, zaten yapılacak bir şey yoktur. Ama bazen sonuç sığacak olsa da ara işlemler sırasında oluşabilecek taşmalar nedeniyle yanlış sonuçlar elde edilebilir.
)

$(P
Bir örneğe bakalım: kenarları 40'a 60 kilometre olan bir alanın her 1000 metre karesine bir elma ağacı dikmek istiyoruz. Kaç ağaç gerekir?
)

$(P
Bu problemi kağıt kalemle çözünce sonucun 40000 çarpı 60000 bölü 1000 olarak 2.4 milyon olduğunu görürüz. Bunu hesaplayan bir programa bakalım:
)

---
import std.stdio;

void main() {
    int en  = 40000;
    int boy = 60000;
    int ağaç_başına_yer = 1000;

    int gereken_ağaç = en * boy / ağaç_başına_yer;

    writeln("Gereken elma ağacı: ", gereken_ağaç);
}
---

$(SHELL
Gereken elma ağacı: -1894967
)

$(P
Bırakın yakın olmayı, bu sonuç sıfırdan bile küçüktür! Bu sorunun nedeni, programdaki $(C en&nbsp;*&nbsp;boy) alt işleminin bir $(C int)'e sığamayacak kadar büyük olduğu için taşması, ve bu yüzden de geri kalan $(C /&nbsp;ağaç_başına_yer) işleminin de yanlış çıkmasıdır.
)

$(P
Buradaki ara işlem sırasında oluşan taşmayı değişken sıralarını değiştirerek giderebiliriz:
)

---
int gereken_ağaç = en / ağaç_başına_yer * boy;
---

$(P
Şimdi hesap doğru çıkar:
)

$(SHELL
Gereken elma ağacı: 2400000
)

$(P
Bu ifadenin doğru çalışmasının nedeni, şimdiki ara işlem olan $(C en&nbsp;/&nbsp;ağaç_başına_yer) ifadesinin değerinin 40 olduğu için artık $(C int)'ten taşmamasıdır.
)

$(P
Aslında böyle bir durumda en doğru çözüm; bir tamsayı türü değil, kesirli sayı türlerinden birisini kullanmaktır: $(C float), $(C double), veya $(C real).
)

$(H6 Kırpılmaya karşı önlemler)

$(P
Benzer şekilde, ara işlemlerin sırasını değiştirerek kırpılmanın da etkisini azaltabiliriz. Bunun ilginç bir örneğini, aynı sayıya bölüp yine aynı sayıyla çarptığımızda görebiliriz: 10/9*9 işleminin sonucunun 10 çıkmasını bekleriz. Oysa:
)

---
import std.stdio;

void main() {
    writeln(10 / 9 * 9);
}
---

$(SHELL
9
)

$(P
Yine, işlemlerin sırasını değiştirince kırpılma olmayacağı için sonuç doğru çıkar:
)

---
writeln(10 * 9 / 9);
---

$(SHELL
10
)

$(P
Burada da en iyi çözüm belki de bir kesirli sayı türü kullanmaktır.
)

$(PROBLEM_COK
$(PROBLEM
Yazacağınız program kullanıcıdan iki tamsayı alsın ve birincinin içinde ikinciden kaç tane bulunduğunu ve artanını versin. Örneğin 7 ve 3 değerleri girilince çıkışa şunu yazsın:

$(SHELL
7 = 3 * 2 + 1
)
)

$(PROBLEM
Aynı programı, kalan 0 olduğunda daha kısa sonuç verecek şekilde değiştirin. Örneğin 10 ve 5 verince gereksizce "10 = 5 * 2 + 0" yazmak yerine, yalnızca yeterli bilgiyi versin:

$(SHELL
10 = 5 * 2
)
)

$(PROBLEM
Dört işlemi destekleyen basit bir hesap makinesi yazın. İşlemi bir menüden seçtirsin ve girilen iki değere o işlemi uygulasın. Bu programda taşma ve kırpılma sorunlarını gözardı edebilirsiniz.
)

$(PROBLEM
Yazacağınız program 1'den 10'a kadar bütün sayıları ayrı satırlarda olacak şekilde yazdırsın. Ama, bir istisna olarak 7 değerini yazdırmasın. Programda şu şekilde tekrarlanan $(C writeln) ifadeleri kullan$(B ma)yın:

---
import std.stdio;

void main() {
    // Böyle yapmayın!
    writeln(1);
    writeln(2);
    writeln(3);
    writeln(4);
    writeln(5);
    writeln(6);
    writeln(8);
    writeln(9);
    writeln(10);
}
---

$(P
Onun yerine, bir döngü içinde değeri arttırılan bir değişken düşünün ve 7'yi yazdırmama koşuluna da dikkat edin. Burada herhalde $(I eşit olmama) koşulunu denetleyen $(C !=) işlecini kullanmak zorunda kalacaksınız.
)
)

)


Macros:
        SUBTITLE=Aritmetik İşlemler

        DESCRIPTION=D dilinde aritmetik işlemlerin tanıtılması

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial aritmetik işlemler

SOZLER= 
$(arttirma)
$(atama)
$(azaltma)
$(bit)
$(ifade)
$(isaretli_tur)
$(isaretsiz_tur)
$(islec)
$(kalan)
$(kirpilma)
$(nitelik)
$(onceki_degerli_arttirma)
$(onceki_degerli_azaltma)
$(tasma)
