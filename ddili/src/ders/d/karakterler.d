Ddoc

$(DERS_BOLUMU $(IX karakter) Karakterler)

$(P
Karakterler yazıları oluşturan en alt birimlerdir: harfler, rakamlar, noktalama işaretleri, boşluk karakteri, vs. Önceki bölümdeki dizilere ek olarak bu bölümde de karakterleri tanıyınca iki bölüm sonra anlatılacak olan $(I dizgi) kavramını anlamak kolay olacak.
)

$(P
Bilgisayar veri türleri temelde bitlerden oluştuklarından, karakterler de bitlerin birleşimlerinden oluşan tamsayı değerler olarak ifade edilirler. Örneğin, küçük harf $(C 'a')nın tamsayı değeri 97'dir ve $(C '1') rakamının tamsayı değeri 49'dur. Bu değerler tamamen anlaşmalara bağlı olarak atanmışlardır ve kökleri ASCII kod tablosuna dayanır.
)

$(P
Karakterler bazı dillerde geleneksel olarak 256 farklı değer tutabilen $(C char) türüyle gösterilirler. Eğer $(C char) türünü başka dillerden tanıyorsanız onun her harfi barındıracak kadar büyük bir tür olmadığını biliyorsunuzdur. D'de üç farklı karakter türü bulunur. Buna açıklık getirmek için bu konunun tarihçesini gözden geçirelim.
)

$(H5 Tarihçe)

$(H6 $(IX ASCII) ASCII Tablosu)

$(P
Donanımın çok kısıtlı olduğu günlerde tasarlanan ilk ASCII tablosu 7 bitlik değerlerden oluşuyordu ve bu yüzden ancak 128 karakter değeri barındırabiliyordu. Bu değerler İngiliz alfabesini oluşturan 26 harfin küçük ve büyük olanlarını, rakamları, sık kullanılan noktalama işaretlerini, programların çıktılarını uç birimlerde gösterirken kullanılan kontrol karakterlerini, vs. ifade etmek için yeterliydi.
)

$(P
Örnek olarak, $(STRING "merhaba") metnindeki karakterlerin ASCII kodları sırasıyla şöyledir (bu gösterimlerde okumayı kolaylaştırmak için bayt değerleri arasında virgül kullanıyorum):
)

$(MONO
109,101,114,104,97,98,97
)

$(P
Her bir değer bir harfe karşılık gelir. Örneğin, iki $(C 'a') harfi için iki adet 97 değeri kullanılmıştır.
)

$(P
Donanımdaki gelişmeler doğrultusunda ASCII tablosundaki kodlar daha sonra 8 bite çıkartılarak 256 karakter destekleyen $(I Genişletilmiş $(ASIL Extended) ASCII) tablosu tanımlanmıştır.
)

$(H6 $(IX kod tablosu) IBM Kod Tabloları)

$(P
IBM firması ASCII tablosuna dayanan ve 128 ve daha büyük karakter değerlerini dünya dillerine ayıran bir dizi kod tablosu tanımladı. Bu kod tabloları sayesinde İngiliz alfabesinden başka alfabelerin de desteklenmeleri sağlanmış oldu. Örneğin, Türk alfabesine özgü karakterler IBM'in 857 numaralı kod tablosunda yer aldılar.
)

$(P
Her ne kadar ASCII'den çok daha yararlı olsalar da, kod tablolarının önemli sorunları vardır: Yazının doğru olarak görüntülenebilmesi için yazıldığı zaman hangi kod tablosunun kullanıldığının bilinmesi gerekir çünkü farklı kod tablolarındaki kodlar farklı karakterlere karşılık gelirler. Örneğin, 857 numaralı kod tablosunda $(C 'Ğ') olan karakter 437 numaralı kod tablosu ile görüntülendiğinde $(C 'ª') karakteri olarak belirir. Başka bir sorun, yazı içinde birden fazla dilin karakteri kullanıldığında kod tablolarının yetersiz kalmalarıdır. Ayrıca, 128'den fazla özel karakteri olan diller zaten 8 bitlik bir tabloda ifade edilemezler.
)

$(H6 ISO/IEC 8859 Kod Tabloları)

$(P
Uluslararası standartlaştırma çalışmaları sonucunda ISO/IEC 8859 standart karakter kodları tanımlanmış ve örneğin Türk alfabesinin özel harfleri 8859-9 tablosunda yer almışlardır. Yapısal olarak IBM'in tablolarının eşdeğeri olduklarından IBM'in kod tablolarının sorunları bu standartta da bulunur. Hatta, Felemenkçe'nin ĳ karakteri gibi bazı karakterler bu tablolarda yer bulamamışlardır.
)

$(H6 $(IX unicode) Unicode)

$(P
Unicode standardı bu sorunları çözer. Unicode, dünya dillerindeki ve yazı sistemlerindeki harflerin, karakterlerin, ve yazım işaretlerinin yüz binden fazlasını tanımlar ve her birisine farklı bir kod verir. Böylece, Unicode'un tanımladığı kodları kullanan metinler bütün dünya karakterlerini hiçbir karışıklık ve kısıtlama olmadan bir arada bulundurabilirler.
)

$(H5 $(IX kodlama, unicode) Unicode kodlama çeşitleri)

$(P
Unicode, her bir karaktere bir kod değeri verir. Örnek olarak, $(C 'Ğ') harfinin Unicode'daki değeri 286'dır. Unicode'un desteklediği karakter sayısı o kadar fazla olunca, karakterleri ifade eden değerler de doğal olarak artık 8 bitle ifade edilemezler. Örneğin, kod değeri 255'ten büyük olduğundan $(C 'Ğ')nin en az 2 baytla gösterilmesi gerekir.
)

$(P
Karakterlerin elektronik ortamda nasıl ifade edildiklerine $(I karakter kodlaması) denir. Yukarıda $(STRING "merhaba") dizgisinin karakterlerinin ASCII kodlarıyla nasıl ifade edildiklerini görmüştük. Şimdi Unicode karakterlerinin standart kodlamalarından üçünü göreceğiz.
)

$(P
$(IX UTF-32) $(B UTF-32:) Bu kodlama her Unicode karakteri için 32 bit (4 bayt) kullanır. $(STRING "merhaba")nın UTF-32 kodlaması da ASCII kodlamasıyla aynıdır. Tek fark, her karakter için 4 bayt kullanılmasıdır:
)

$(MONO
0,0,0,109, 0,0,0,101, 0,0,0,114, 0,0,0,104, 0,0,0,97,
0,0,0,98, 0,0,0,97
)

$(P
Başka bir örnek olarak, ifade edilecek metnin örneğin $(STRING "aĞ") olduğunu düşünürsek:
)

$(MONO
0,0,0,97, 0,0,1,30
)

$(P
$(I Not: Baytların sıraları farklı platformlarda farklı olabilir.)
)

$(P
$(C 'a')da bir ve $(C 'Ğ')de iki adet anlamlı bayt olduğundan toplam beş adet de sıfır bulunmaktadır. Bu sıfırlar her karaktere 4 bayt verebilmek için gereken $(I doldurma baytları) olarak düşünülebilir.
)

$(P
Dikkat ederseniz, bu kodlama her zaman için ASCII kodlamasının 4 katı yer tutmaktadır. Metin içindeki karakterlerin büyük bir bölümünün İngiliz alfabesindeki karakterlerden oluştuğu durumlarda, çoğu karakter için 3 tane de 0 kullanılacağından bu kodlama duruma göre fazla savurgan olabilir.
)

$(P
Öte yandan, karakterlerin her birisinin tam olarak 4 bayt yer tutuyor olmasının getirdiği yararlar da vardır. Örneğin, bir sonraki Unicode karakteri hiç hesap gerektirmeden her zaman için tam dört bayt ötededir.
)

$(P
$(IX UTF-16) $(B UTF-16:) Bu kodlama, Unicode karakterlerinin çoğunu 16 bitle (2 bayt) gösterir. İki bayt yaklaşık olarak 65 bin değer tutabildiğinden, yaklaşık yüz bin Unicode karakterinin geri kalan 35 bin kadarı için daha fazla bayt kullanmak gerekir.
)

$(P
Örnek olarak $(STRING "aĞ") UTF-16'da aşağıdaki 4 bayt olarak kodlanır:
)

$(MONO
0,97, 1,30
)

$(P
$(I Not: Baytların sıraları farklı ortamlarda farklı olabilir.)
)

$(P
Bu kodlama çoğu belgede UTF-32'den daha az yer tutar ama nadir kullanılan bazı karakterler için ikiden fazla bayt kullandığından işlenmesi daha karmaşıktır.
)

$(P
$(IX UTF-8) $(B UTF-8:) Bu kodlama, karakterleri en az 1 ve en fazla 4 baytla ifade eder. Eğer karakter ASCII tablosundaki karakterlerden biriyse, tek baytla ve aynen ASCII tablosundaki değeriyle ifade edilir. Bunların dışındaki karakterlerin bazıları 2, bazıları 3, diğerleri de 4 bayt olarak ifade edilirler. Türk alfabesinin İngiliz alfabesinde bulunmayan özel karakterleri 2 baytlık gruptadırlar.
)

$(P
Çoğu belge için UTF-8 bütün kodlamalar arasında en az yer tutan kodlamadır. Başka bir yararı, ASCII tablosundaki kodlara aynen karşılık geldiğinden, ASCII kodlanarak yazılmış ve İngiliz alfabesini kullanan belgeler de otomatik olarak UTF-8 düzenine uyarlar. Bu kodlamada hiç savurganlık yoktur; bütün karakterler gerçekten gereken sayıda baytla ifade edilirler. Örneğin, $(STRING "aĞ")ın UTF-8 kodlaması aşağıdaki gibidir:
)

$(MONO
97, 196,158
)

$(H5 D'nin karakter türleri)

$(P
$(IX char)
$(IX wchar)
$(IX dchar)
D'de karakterleri ifade etmek için 3 farklı tür vardır. Bunlar yukarıda anlatılan Unicode kodlama yöntemlerine karşılık gelirler. Temel türlerin tanıtıldığı sayfada gösterildikleri gibi:
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">Tür</th> <th scope="col">Açıklama</th> <th scope="col">İlk Değeri</th>

</tr>
<tr>
 <td>char</td>
 <td>işaretsiz 8 bit UTF-8 karakter değeri</td>
 <td>0xFF</td>
</tr>

<tr>
 <td>wchar</td>
 <td>işaretsiz 16 bit UTF-16 karakter değeri</td>
 <td>0xFFFF</td>
</tr>
<tr>
 <td>dchar</td>
 <td>işaretsiz 32 bit UTF-32 karakter değeri</td>
 <td>0x0000FFFF</td>
</tr>
</table>

$(P
Başka bazı programlama dillerinden farklı olarak, D'de her karakter aynı uzunlukta olmayabilir. Örneğin, $(C 'Ğ') harfi Unicode'da en az 2 baytla gösterilebildiğinden 8 bitlik $(C char) türüne sığmaz. Öte yandan, $(C dchar) 4 bayttan oluştuğundan her Unicode karakterini tutabilir.
)

$(H5 $(IX hazır değer, karakter) $(IX karakter sabiti) Karakter sabitleri)

$(P
Karakterleri program içinde tek olarak belirtmek gerektiğinde etraflarına tek tırnak işaretleri koyulur:
)

---
    char  a_harfi = 'a';
    wchar büyük_yumuşak_g = 'Ğ';
---

$(P
Karakter sabitleri için çift tırnak kullanılamaz çünkü o zaman iki bölüm sonra göreceğimiz $(I dizgi) sabiti anlamına gelir: $(C 'a') karakter değeridir, $(STRING "a") tek karakterli bir dizgidir.
)

$(P
Türk alfabesindeki bazı harflerin Unicode kodları 2 bayttan oluştuklarından $(C char) türündeki değişkenlere atanamazlar.
)

$(P
Karakterleri sabit olarak program içine yazmanın bir çok yolu vardır:
)

$(UL
$(LI En doğal olarak, klavyeden doğrudan karakterin tuşuna basmak
)

$(LI Çalışma ortamındaki başka bir programdan veya bir metinden kopyalamak. Örneğin, bir internet sitesinden veya çalışma ortamında karakter seçmeye yarayan bir programdan kopyalanabilir (Linux ortamlarında bu programın ismi $(I Character Map)'tir (uç birimlerde $(C charmap)).)
)

$(LI Karakterlerin bazılarını standart kısa isimleriyle yazmak. Bunun söz dizimi $(C \&$(I karakter_ismi);) biçimindedir. Örneğin, avro karakterinin ismi $(C euro)'dur ve programda değeri şöyle yazılabilir:

---
   wchar para_sembolü = '\&euro;';
---

$(P
Diğer isimli karakterleri D'nin $(LINK2 http://dlang.org/entity.html, isimli karakterler listesinde) bulabilirsiniz.
)

)

$(LI Karakterleri tamsayı Unicode değerleriyle belirtmek:

---
    char a = 97;
    wchar Ğ = 286;
---

)

$(LI ASCII tablosundaki karakterleri değerleriyle $(C \$(I sekizli_düzende_kod)) veya $(C \x$(I on_altılı_düzende_kod)) söz dizimleriyle yazmak:

---
    char soru_işareti_sekizli = '\77';
    char soru_işareti_on_altılı = '\x3f';
---

)

$(LI Karakterleri Unicode değerleriyle yazmak. $(C wchar) için $(C \u$(I dört_haneli_kod)) söz dizimini, $(C dchar) için de $(C \U$(I sekiz_haneli_kod)) söz dizimini kullanabilirsiniz ($(C u) ve $(C U) karakterlerinin farklı olduklarına dikkat edin). Bu yazımda karakterin kodunun on altılı sayı sisteminde $(ASIL hexadecimal) yazılması gerekir:

---
    wchar Ğ_w = '\u011e';
    dchar Ğ_d = '\U0000011e';
---

)

)

$(P
Bu yöntemler karakterleri çift tırnak içinde bir arada yazdığınız durumlarda da geçerlidir. Örneğin, aşağıdaki iki satır aynı çıktıyı verirler:
)

---
    writeln("Ağ fiyatı: 10.25€");
    writeln("\x41\u011f fiyatı: 10.25\&euro;");
---


$(H5 Kontrol karakterleri)

$(P
$(IX kontrol karakteri) Bazı karakterler yalnızca metin düzeniyle ilgilidirler; kendilerine özgü görünümleri yoktur. Örneğin, uç birime yeni bir satıra geçileceğini bildiren $(I yeni satır) karakterinin gösterilecek bir şekli yoktur; yalnızca yeni bir satıra geçilmesini sağlar. Böyle karakterlere $(I kontrol karakteri) denir. Kontrol karakterleri $(C \$(I özel_harf)) söz dizimiyle ifade edilirler.
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">

<tr><th scope="col">Yazım</th> <th scope="col">İsim</th> <th scope="col">Açıklama</th>

</tr>
<tr>
 <td>\n</td>
 <td>yeni&nbsp;satır</td>
 <td>Yeni satıra geçirir</td>
</tr>
<tr>
 <td>\r</td>
 <td>satır&nbsp;başı</td>
 <td>Satırın başına götürür</td>
</tr>
<tr>
 <td>\t</td>
 <td>sekme</td>
 <td>Bir sonraki sekme noktasına kadar boşluk bırakır</td>
</tr>
</table>

$(P
Örneğin, çıktıda otomatik olarak yeni satır açmayan $(C write) bile $(C \n) karakterlerini yeni satır açmak için kullanır. Yazdırılacak metnin içinde istenen noktalara $(C \n) karakterleri yerleştirmek o noktalarda yeni satır açılmasını sağlar:
)

---
    write("birinci satır\nikinci satır\nüçüncü satır\n");
---

$(P
Çıktısı:
)

$(SHELL
birinci satır
ikinci satır
üçüncü satır
)

$(H5 $(IX ') $(IX \) Tek tırnak ve ters bölü)

$(P
Tek tırnak karakterinin kendisini tek tırnaklar arasında yazamayız çünkü derleyici ikinci tırnağı gördüğünde tırnakları kapattığımızı düşünür: $(C '''). İlk ikisi açma ve kapama tırnakları olarak algılanırlar, üçüncüsü de tek başına algılanır ve yazım hatasına neden olur.
)

$(P
Ters bölü karakteri de başka özel karakterleri ifade etmek için kullanıldığından, derleyici onu bir özel karakterin başlangıcı olarak algılar: $(C '\'). Derleyici $(C \') yazımını bir özel karakter olarak algılar ve baştaki tek tırnakla eşlemek için bir tane daha tek tırnak arar ve bulamaz.
)

$(P
Bu iki karakteri sabit olarak yazmak gerektiğinde başlarına bir ters bölü daha yazılır:
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">Yazım</th> <th scope="col">İsim</th> <th scope="col">Açıklama</th>

</tr>
<tr>
 <td>\'</td>
 <td>tek&nbsp;tırnak</td>
 <td>Tek tırnağın karakter olarak tanımlanmasına olanak verir: '\''</td>
</tr>
<tr>
 <td>\\</td>
 <td>ters&nbsp;bölü</td>
 <td>Ters bölü karakterinin yazılmasına olanak verir: '\\' veya "\\"</td>
</tr>
</table>


$(H5 $(IX std.uni) std.uni modülü)

$(P
$(C std.uni) modülü Unicode karakterleriyle ilgili yardımcı işlevler içerir. Bu modüldeki işlevleri $(LINK2 http://dlang.org/phobos/std_uni.html, kendi belgesinde) bulabilirsiniz.
)

$(P
$(C is) ile başlayan işlevler karakterle ilgili sorular cevaplarlar: cevap yanlışsa $(C false), doğruysa $(C true) döndürürler. Bu işlevler mantıksal ifadelerde kullanışlıdırlar:
)

$(UL
$(LI $(C isLower): Küçük harf mi?
)
$(LI $(C isUpper): Büyük harf mi?
)
$(LI $(C isAlpha): Herhangi bir harf mi?
)
$(LI $(C isWhite): Herhangi bir boşluk karakteri mi?
)
)

$(P
$(C to) ile başlayan işlevler verilen karakteri kullanarak yeni bir karakter üretirler:
)

$(UL
$(LI $(C toLower): Küçük harfini üretir
)
$(LI $(C toUpper): Büyük harfini üretir
)
)

$(P
Aşağıdaki program bütün bu işlevleri kullanmaktadır:
)

---
import std.stdio;
import std.uni;

void main() {
    writeln("ğ küçük müdür? ", isLower('ğ'));
    writeln("Ş küçük müdür? ", isLower('Ş'));

    writeln("İ büyük müdür? ", isUpper('İ'));
    writeln("ç büyük müdür? ", isUpper('ç'));

    writeln("z harf midir? ",       isAlpha('z'));
    writeln("\&euro; harf midir? ", isAlpha('\&euro;'));

    writeln("'yeni satır' boşluk mudur? ", isWhite('\n'));
    writeln("alt çizgi boşluk mudur? ",    isWhite('_'));

    writeln("Ğ'nin küçüğü: ", toLower('Ğ'));
    writeln("İ'nin küçüğü: ", toLower('İ'));

    writeln("ş'nin büyüğü: ", toUpper('ş'));
    writeln("ı'nın büyüğü: ", toUpper('ı'));
}
---

$(P
Çıktısı:
)

$(SHELL
ğ küçük müdür? true
Ş küçük müdür? false
İ büyük müdür? true
ç büyük müdür? false
z harf midir? true
€ harf midir? false
'yeni satır' boşluk mudur? true
alt çizgi boşluk mudur? false
Ğ'nin küçüğü: ğ
İ'nin küçüğü: i
ş'nin büyüğü: Ş
ı'nın büyüğü: I
)

$(H5 Türk alfabesinin şanssız harfleri: ı ve i)

$(P
$(C 'ı') ve $(C 'i') harflerinin küçük ve büyük biçimleri Türk alfabesinde tutarlıdır: noktalıysa noktalı, noktasızsa noktasız. Oysa çoğu yabancı alfabede bu konuda bir tutarsızlık vardır: noktalı $(C 'i')nin büyüğü noktasız $(C 'I')dır.
)

$(P
Bilgisayar sistemlerinin temelleri İngiliz alfabesiyle başladığından $(C 'i')nin büyüğü $(C 'I), $(C 'I')nın küçüğü ise $(C 'i')dir. Bu yüzden bu iki harf için özel dikkat göstermek gerekir:
)

---
import std.stdio;
import std.uni;

void main() {
    writeln("i'nin büyüğü: ", toUpper('i'));
    writeln("I'nın küçüğü: ", toLower('I'));
}
---

$(P
İstenmeyen çıktısı:
)

$(SHELL
i'nin büyüğü: I
I'nın küçüğü: i
)

$(P
Karakter kodları kullanılarak yapılan küçük-büyük dönüşümleri ve harf sıralamaları aslında bütün alfabeler için sorunludur.
)

$(P
Örneğin, $(C 'I')nın küçüğünün $(C 'i') olarak dönüştürülmesi Azeri ve Kelt alfabeleri için de yanlıştır.
)

$(P
Benzer sorunlar harflerin sıralanmalarında da bulunur. Örneğin, $(C 'ğ') gibi Türk alfabesine özgü harfler $(C 'z')den sonra sıralandıkları gibi, $(C 'á') gibi aksanlı harfler İngiliz alfabesinde bile $(C 'z')den sonra gelirler.
)

$(H5 $(IX giriş, karakter okuma) Girişten karakter okumadaki sorunlar)

$(P
Unicode karakterleri girişten okunurken beklenmedik sonuçlarla karşılaşılabilir. Bunlar genellikle $(I karakter) ile ne kastedildiğinin açık olmamasındandır. Daha ileriye gitmeden önce bu sorunu gösteren bir programa bakalım:
)

---
import std.stdio;

void main() {
    char harf;
    write("Lütfen bir harf girin: ");
    readf(" %s", &harf);
    writeln("Okuduğum harf: ", harf);
}
---

$(P
Yukarıdaki programı Unicode kodlaması kullanılmayan bir ortamda çalıştırdığınızda programın girişinden aldığı Türkçe harfleri belki de doğru olarak yazdırdığını görebilirsiniz.
)

$(P
Öte yandan, aynı programı çoğu Linux uç biriminde olduğu gibi bir Unicode ortamında çalıştırdığınızda, yazdırılan harfin sizin yazdığınızla aynı olmadığını görürsünüz. Örneğin, UTF-8 kodlaması kullanan bir uç birimde ASCII tablosunda bulunmayan bir harf girilmiş olsun:
)

$(SHELL
Lütfen bir harf girin: ğ
Okuduğum harf:           $(SHELL_NOTE girilen harf görünmüyor)
)

$(P
Bunun nedeni, UTF-8 kodlaması kullanan uç birimin ASCII tablosunda bulunmayan $(C 'ğ') gibi harfleri birden fazla kod ile temsil etmesi, ve $(C readf)'in $(C char) okurken bu kodlardan yalnızca birincisini alıyor olmasıdır. O $(C char) da asıl karakteri temsil etmeye yetmediğinden, $(C writeln)'ın yazdırdığı $(I eksik kodlanmış olan harf) uç birimde gösterilememektedir.
)

$(P
$(C char) olarak okunduğunda harfin kendisinin değil, onu oluşturan kodların okunmakta olduklarını harfi iki farklı $(C char) olarak okuyarak görebiliriz:
)

---
import std.stdio;

void main() {
    char birinci_kod;
    char ikinci_kod;

    write("Lütfen bir harf girin: ");
    readf(" %s", &birinci_kod);
    readf(" %s", &ikinci_kod);

    writeln("Okuduğum harf: ", birinci_kod, ikinci_kod);
}
---

$(P
Program girişten iki $(C char) okumakta ve onları aynı sırada çıkışa yazdırmaktadır. O $(C char) değerlerinin art arda uç birime gönderilmiş olmaları, bu sefer harfin UTF-8 kodlamasını standart çıkış tarafında tamamlamakta ve karakter doğru olarak gösterilmektedir:
)

$(SHELL
Lütfen bir harf girin: ğ
Okuduğum harf: ğ
)

$(P
Bu sonuçlar standart giriş ve çıkışın $(C char) akımları olmalarından kaynaklanır. Karakterlerin iki bölüm sonra göreceğimiz dizgiler aracılığıyla aslında çok daha rahat okunduklarını göreceksiniz.
)

$(H5 D'nin Unicode desteği)

$(P
Unicode çok büyük ve karmaşık bir standarttır. D, Unicode'un oldukça kullanışlı bir alt kümesini destekler.
)

$(P
Unicode ile kodlanmış olan bir metin en aşağıdan en yukarıya doğru şu düzeylerden oluşur:
)

$(UL

$(LI $(IX kod birimi) $(B Kod birimi) $(ASIL code unit): UTF kodlamalarını oluşturan kod değerleridir. Unicode karakterleri, kodlamaya ve karakterin kendisine bağlı olarak bir veya daha fazla kod biriminden oluşabilirler. Örneğin, UTF-8 kodlamasında $(C 'a') karakteri tek kod biriminden, $(C 'ğ') karakteri ise iki kod biriminden oluşur.

$(P
D'nin $(C char), $(C wchar), ve $(C dchar) türleri sırasıyla UTF-8, UTF-16, ve UTF-32 kod birimlerini ifade ederler.
)

)

$(LI $(IX kod noktası) $(B Kod noktası) $(ASIL code point): Unicode'un tanımlamış olduğu her harf, im, vs. bir kod noktasıdır. Örneğin, $(C 'a') ve $(C 'ğ') iki farklı kod noktasıdır.

$(P
Bu kod noktaları kodlamaya bağlı olarak bir veya daha fazla kod birimi ile ifade edilirler. Yukarıda da değindiğim gibi, UTF-8 kodlamasında $(C 'a') tek kod birimi ile, $(C 'ğ') ise iki kod birimi ile ifade edilir. Öte yandan, her ikisi de UTF-16 ve UTF-32 kodlamalarında tek kod birimi ile ifade edilirler.)

$(P
D'de kod noktalarını tam olarak destekleyen tür $(C dchar)'dır. $(C char) ve $(C wchar) ise yalnızca kod birimi türü olarak kullanılmaya elverişlidirler.
)

)

$(LI $(B Karakter) $(ASIL character): yazı sistemlerinde kullanılmak üzere Unicode'un tanımlamış olduğu bütün şekiller, imler, ve konuşma dilinde "karakter" veya "harf" dediğimiz her şey bu tanıma girer.

$(P
Bu konuda Unicode'un getirdiği bir karışıklık, bazı karakterlerin birden fazla kod noktasından oluşabilmeleridir. Örneğin, $(C 'ğ') harfini ifade etmenin iki yolu vardır:)

$(UL

$(LI Tek başına $(C 'ğ') kod noktası olarak)

$(LI Art arda gelen $(C 'g') ve $(C '˘') kod noktaları olarak ($(C 'g') ve sonrasında gelen $(I birleştirici) $(ASIL combining) breve şapkası))
)

$(P
Farklı kod noktalarından oluştuklarından, tek kod noktası olan $(C 'ğ') karakteri ile art arda gelen $(C 'g') ve $(C '˘') karakterlerinin ilgileri yoktur.
)

)

)

$(H5 Özet)

$(UL

$(LI Unicode, dünya yazı sistemlerindeki bütün karakterleri destekler.)

$(LI $(C char) UTF-8 kodlaması içindir; karakterleri ifade etmeye genelde elverişli olmasa da ASCII tablosunu destekler.)

$(LI $(C wchar) UTF-16 kodlaması içindir; karakterleri ifade etmeye genelde elverişli olmasa da özel durumlarda birden fazla alfabe karakterini destekler.)

$(LI $(C dchar) UTF-32 kodlaması içindir; 32 bit olması nedeniyle bütün Unicode karakterlerini destekler ve $(I kod noktası) olarak kullanılabilir.)

)

Macros:
        SUBTITLE=Karakterler

        DESCRIPTION=D dilinde karakterlerin ve Unicode kodlama çeşitlerinin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial karakter char wchar dchar utf-8 utf-16 utf-32 unicode ascii

SOZLER=
$(bayt)
$(bit)
$(dizgi)
$(karakter)
$(karakter_kodlamasi)
$(kod_tablosu)
$(kontrol_karakteri)
$(uc_birim)
