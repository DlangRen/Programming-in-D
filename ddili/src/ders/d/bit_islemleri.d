Ddoc

$(DERS_BOLUMU $(IX bit işlemi) Bit İşlemleri)

$(P
Bu bölümde mikro işlemcinin en küçük bilgi birimi olan bitlerle yapılan işlemleri tanıyacağız. Bit işlemleri mikro işlemcinin en temel olanaklarındandır.
)

$(P
Bu işlemler hem alt düzey programcılık açısından bilinmelidir, hem de parametre olarak $(I bayrak) alan işlevler için gereklidir. Bayrak alan işlevlere özellikle C kütüphanelerinden uyarlanmış olan D kütüphanelerinde rastlanabilir.
)

$(H5 Verinin en alt düzeyde gerçekleştirilmesi)

$(P
D gibi bir programlama dili aslında bir soyutlamadır. Program içinde tanımladığımız $(C Öğrenci) gibi bir kullanıcı türünün bilgisayarın iç yapısı ile doğrudan bir ilgisi yoktur. Programlama dillerinin amaçlarından birisi, donanımın anladığı dil ile insanın anladığı dil arasında aracılık yapmaktır.
)

$(P
Bu yüzden her ne kadar D dilini kullanırken donanımla ilgili kavramlarla ilgilenmek gerekmese de, üst düzey kavramların en alt düzeyde elektronik devre elemanlarına nasıl bağlı olduklarını anlamak önemlidir. Bu konularda başka kaynaklarda çok miktarda bilgi bulabileceğinizi bildiğim için bu başlığı olabildiğince kısa tutacağım.
)

$(H6 $(IX transistör) Transistör)

$(P
Modern elektronik aletlerin işlem yapma yetenekleri büyük ölçüde transistör denen elektronik devre elemanı ile sağlanır. Transistörün bir özelliği, devrenin başka tarafındaki sinyallerle kontrol edilebilmesidir. Bir anlamda elektronik devrenin kendi durumundan haberinin olmasını ve kendi durumunu değiştirebilmesini sağlar.
)

$(P
$(IX bit) Transistörler hem mikro işlemcinin içinde hem de bilgisayarın ana belleğinde çok büyük sayılarda bulunurlar. Programlama dili aracılığıyla ifade ettiğimiz işlemleri ve verileri en alt düzeyde gerçekleştiren elemanlardır.
)

$(H6 Bit)

$(P
Bilgisayarlarda en küçük bilgi birimi bittir. Bit en alt düzeyde bir kaç tane transistörün belirli bir düzende bir araya getirilmesi ile gerçekleştirilir ve veri olarak iki farklı değerden birisini depolayabilir: 0 veya 1. Depoladığı veriyi tekrar değiştirilene kadar veya enerji kaynağı kesilene kadar korur.
)

$(P
$(IX bayt) Bilgisayarlar veriye bit düzeyinde doğrudan erişim sağlamazlar. Bunun nedeni, her bitin adreslenebilmesinin bilgisayarın karmaşıklığını ve maliyetini çok arttıracak olması ve tek bitlik kavramların desteklenmeye değmeyecek kadar nadir olmalarıdır.
)

$(H6 Bayt)

$(P
Bayt, birbirleriyle ilişkilendirilen 8 bitin bir araya gelmesinden oluşur. Bilgisayarlarda adreslenebilen, yani ayrı ayrı erişilebilen en küçük veri bayttır. Bellekten tek seferde en az bir bayt veri okunabilir ve belleğe en az bir bayt veri yazılabilir.
)

$(P
Bu yüzden, yalnızca $(C false) ve $(C true) diye iki farklı değer alan ve aslında tek bitlik bilgi taşıyan $(C bool) türü bile 1 bayt olarak gerçekleştirilir. Bunu $(C bool.sizeof) değerine bakarak kolayca görebiliriz:
)

---
    writeln(bool.stringof, ' ', bool.sizeof, " bayttır");
---

$(SHELL_SMALL
bool 1 bayttır
)

$(H6 $(IX yazmaç) Yazmaç)

$(P
Mikro işlemcinin kendi içinde bulunan depolama ve işlem birimleri yazmaçlardır. Yazmaçlar oldukça kısıtlı ama çok hızlı işlemler sunarlar.
)

$(P
Yazmaçlar her işlemcinin bit genişliğine bağlı olan sayıda bayttan oluşurlar. Örneğin, 32 bitlik işlemcilerde yazmaçlar 4 bayttan, 64 bitlik işlemcilerde de 8 bayttan oluşur. Yazmaç büyüklüğü hem mikro işlemcinin etkin olarak işleyebildiği bilgi miktarını hem de en fazla ne kadar bellek adresleyebildiğini belirler.
)

$(P
Programlama dili aracılığıyla gerçekleştirilen her iş eninde sonunda bir veya daha fazla yazmaç tarafından halledilir.
)

$(H5 $(IX ikili sayı sistemi) İkili sayı sistemi)

$(P
Günlük hayatta kullandığımız onlu sayı sisteminde 10 rakam vardır: 0123456789. Bilgisayar donanımlarında kullanılan ikili sayı sisteminde ise iki rakam vardır: 0 ve 1. Bu, bitin iki değer alabilmesinden gelir. Bitler örneğin üç farklı değer alabilseler, bilgisayarlar üçlü sayı sistemini kullanırlardı.
)

$(P
Günlük hayatta kullandığımız sayıların basamakları birler, onlar, yüzler, binler, vs. diye artarak adlandırılır. Örneğin, 1023 gibi bir sayı şöyle ifade edilebilir:
)

$(MONO
1023 == 1 adet 1000, 0 adet 100, 2 adet 10, ve 3 adet 1
)

$(P
Dikkat ederseniz, sola doğru ilerlendiğinde her basamağın değeri 10 kat artmaktadır: 1, 10, 100, 1000, vs.
)

$(P
Aynı tanımı ikili sayı sistemine taşıyınca, ikili sistemde yazılmış olan sayıların basamaklarının da birler, ikiler, dörtler, sekizler, vs. şeklinde artması gerektiğini görürüz. Yani sola doğru ilerlendiğinde her basamağın değeri 2 kat artmalıdır: 1, 2, 4, 8, vs. Örneğin, 1011 gibi bir $(I ikili) sayı şöyle ifade edilebilir:
)

$(MONO
1011 == 1 adet 8, 0 adet 4, 1 adet 2, ve 1 adet 1
)

$(P
Basamaklar numaralanırken, en sağdaki basamağa (en düşük değerli olan basamağa) $(I 0 numaralı basamak) denir. Buna göre, ikili sayı sisteminde yazılmış olan 32 bitlik işaretsiz bir değerin bütün basamaklarını ve basamak değerlerini şöyle gösterebiliriz:
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0"><tr><th scope="col">Basamak<br/>Numarası</th> <th scope="col"><br/>Değeri</th></tr>
<tr align="right"><td>31</td><td>2,147,483,648</td></tr>
<tr align="right"><td>30</td><td>1,073,741,824</td></tr>
<tr align="right"><td>29</td><td>536,870,912</td></tr>
<tr align="right"><td>28</td><td>268,435,456</td></tr>
<tr align="right"><td>27</td><td>134,217,728</td></tr>
<tr align="right"><td>26</td><td>67,108,864</td></tr>
<tr align="right"><td>25</td><td>33,554,432</td></tr>
<tr align="right"><td>24</td><td>16,777,216</td></tr>
<tr align="right"><td>23</td><td>8,388,608</td></tr>
<tr align="right"><td>22</td><td>4,194,304</td></tr>
<tr align="right"><td>21</td><td>2,097,152</td></tr>
<tr align="right"><td>20</td><td>1,048,576</td></tr>
<tr align="right"><td>19</td><td>524,288</td></tr>
<tr align="right"><td>18</td><td>262,144</td></tr>
<tr align="right"><td>17</td><td>131,072</td></tr>
<tr align="right"><td>16</td><td>65,536</td></tr>
<tr align="right"><td>15</td><td>32,768</td></tr>
<tr align="right"><td>14</td><td>16,384</td></tr>
<tr align="right"><td>13</td><td>8,192</td></tr>
<tr align="right"><td>12</td><td>4,096</td></tr>
<tr align="right"><td>11</td><td>2,048</td></tr>
<tr align="right"><td>10</td><td>1,024</td></tr>
<tr align="right"><td>9</td><td>512</td></tr>
<tr align="right"><td>8</td><td>256</td></tr>
<tr align="right"><td>7</td><td>128</td></tr>
<tr align="right"><td>6</td><td>64</td></tr>
<tr align="right"><td>5</td><td>32</td></tr>
<tr align="right"><td>4</td><td>16</td></tr>
<tr align="right"><td>3</td><td>8</td></tr>
<tr align="right"><td>2</td><td>4</td></tr>
<tr align="right"><td>1</td><td>2</td></tr>
<tr align="right"><td>0</td><td>1</td></tr>
</table>

$(P
Yüksek değerli bitlere $(I üst) bit, düşük değerli bitlere $(I alt) bit denir.
)

$(P
İkili sistemde yazılan hazır değerlerin $(C 0b) ile başladıklarını $(LINK2 /ders/d/hazir_degerler.html, Hazır Değerler bölümünde) görmüştük. İkili sistemde değerler yazarak bu tabloya nasıl uyduklarına bakabiliriz. Okumayı kolaylaştırmak için alt çizgi karakterlerinden de yararlanarak:
)

---
import std.stdio;

void main() {
    //             1073741824                     4 1
    //             ↓                              ↓ ↓
    int sayı = 0b_01000000_00000000_00000000_00000101;
    writeln(sayı);
}
---

$(P
Çıktısı:
)

$(SHELL_SMALL
1073741829
)

$(P
Dikkat ederseniz, o hazır değerin içinde rakamı 1 olan yalnızca 3 adet basamak vardır. Yazdırılan değerin bu basamakların yukarıdaki tablodaki değerlerinin toplamı olduğunu görüyoruz: 1073741824 + 4 + 1 == 1073741829.
)

$(H6 $(IX işaret biti)  İşaretli türlerin $(I işaret) biti)

$(P
En üst bit işaretli türlerde sayının artı veya eksi olduğunu bildirmek için kullanılır:
)

---
    int sayı = 0b_10000000_00000000_00000000_00000000;
    writeln(sayı);
---

$(SHELL_SMALL
-2147483648
)

$(P
En üst bitin diğerlerinden bağımsız olduğunu düşünmeyin. Örneğin, yukarıdaki sayı diğer bitlerinin 0 olmalarına bakarak -0 değeri olarak düşünülmemelidir (zaten tamsayılarda -0 diye bir değer yoktur). Bunun ayrıntısına burada girmeyeceğim ve bunun D'nin de kullandığı $(I ikiye tümleyen) sayı gösterimi ile ilgili olduğunu söylemekle yetineceğim.
)

$(P
Burada önemli olan, yukarıdaki tabloda gösterilen en yüksek 2,147,483,648 değerinin yalnızca $(I işaretsiz) türlerde geçerli olduğunu bilmenizdir. Aynı deneyi $(C uint) ile yaptığımızda tablodaki değeri görürüz:
)

---
    $(HILITE uint) sayı = 0b_10000000_00000000_00000000_00000000;
    writeln(sayı);
---

$(SHELL_SMALL
2147483648
)

$(P
Bu yüzden, aksine bir neden olmadığı sürece aşağıda gösterilenler gibi bit işlemlerinde her zaman için işaretsiz türler kullanılır: $(C ubyte), $(C uint), ve $(C ulong).
)

$(H5 $(IX on altılı sayı sistemi) On altılı sayı sistemi)

$(P
Yukarıdaki hazır değerlerden de görülebileceği gibi, ikili sayı sistemi okunaklı değildir. Hem çok yer kaplar hem de yalnızca 0 ve 1'lerden oluştuğu için okunması ve anlaşılması zordur.
)

$(P
Daha kullanışlı olduğu için on altılı sayı sistemi yaygınlaşmıştır.
)

$(P
On altılı sayı sisteminde toplam 16 rakam vardır. Alfabelerde 10'dan fazla rakam bulunmadığı için Latin alfabesinden de 6 harf alınmış ve bu sistemin rakamları olarak 0123456789abcdef kabul edilmiştir. O sıralamadan bekleneceği gibi; a, b, c, d, e, ve f harfleri sırasıyla  10, 11, 12, 13, 14, ve 15 değerlerindedir. abcdef harfleri yerine isteğe bağlı olarak ABCDEF harfleri de kullanılabilir.
)

$(P
Yukarıdaki sayı sistemlerine benzer biçimde, bu sistemde sola doğru ilerlendiğinde her basamağın değeri 16 kat artar: 1, 16, 256, 4096, vs. Örneğin, on altılı sistemdeki 8 basamaklı bir sayının basamak değerleri şöyledir:
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0"><tr><th scope="col">Basamak<br/>Numarası</th> <th scope="col"><br/>Değeri</th></tr>
<tr align="right"><td>7</td><td>268,435,456</td></tr>
<tr align="right"><td>6</td><td>16,777,216</td></tr>
<tr align="right"><td>5</td><td>1,048,576</td></tr>
<tr align="right"><td>4</td><td>65,536</td></tr>
<tr align="right"><td>3</td><td>4,096</td></tr>
<tr align="right"><td>2</td><td>256</td></tr>
<tr align="right"><td>1</td><td>16</td></tr>
<tr align="right"><td>0</td><td>1</td></tr>
</table>

$(P
On altılı hazır değerlerin $(C 0x) ile yazıldıklarını hatırlayarak bir deneme:
)

---
    //         1048576 4096 1
    //               ↓  ↓  ↓
    uint sayı = 0x_0030_a00f;
    writeln(sayı);
---

$(SHELL_SMALL
3186703
)

$(P
Bunun nedenini sayı içindeki sıfır olmayan basamakların katkılarına bakarak anlayabiliriz: 3 adet 1048576, a adet 4096, ve f adet 1. a'nın 10 ve f'nin 15 olduklarını hatırlayarak hesaplarsak: 3145728 + 40960 + 15 == 3186703.
)

$(P
On altılı ve ikili sistemde yazılan sayılar kolayca birbirlerine dönüştürülebilirler. On altılı sistemdeki bir sayıyı ikili sisteme dönüştürmek için, sayının her basamağı ikili sistemde dört basamak olarak yazılır. Birbirlerine karşılık gelen değerler şöyledir:
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0"><tr><th scope="col" align="center">On altılı</th> <th scope="col">İkili</th>  <th scope="col">Onlu</th></tr>
<tr align="center"><td>0</td><td>0000</td><td>0</td></tr>
<tr align="center"><td>1</td><td>0001</td><td>1</td></tr>
<tr align="center"><td>2</td><td>0010</td><td>2</td></tr>
<tr align="center"><td>3</td><td>0011</td><td>3</td></tr>
<tr align="center"><td>4</td><td>0100</td><td>4</td></tr>
<tr align="center"><td>5</td><td>0101</td><td>5</td></tr>
<tr align="center"><td>6</td><td>0110</td><td>6</td></tr>
<tr align="center"><td>7</td><td>0111</td><td>7</td></tr>
<tr align="center"><td>8</td><td>1000</td><td>8</td></tr>
<tr align="center"><td>9</td><td>1001</td><td>9</td></tr>
<tr align="center"><td>a</td><td>1010</td><td>10</td></tr>
<tr align="center"><td>b</td><td>1011</td><td>11</td></tr>
<tr align="center"><td>c</td><td>1100</td><td>12</td></tr>
<tr align="center"><td>d</td><td>1101</td><td>13</td></tr>
<tr align="center"><td>e</td><td>1110</td><td>14</td></tr>
<tr align="center"><td>f</td><td>1111</td><td>15</td></tr>
</table>

$(P
Örneğin, yukarıda kullandığımız 0x0030a00f on altılı değerini ikili olarak şöyle yazabiliriz:
)

---
    // on altılı:      0    0    3    0    a    0    0    f
    uint ikili = 0b_0000_0000_0011_0000_1010_0000_0000_1111;
---

$(P
İkili sistemden on altılı sisteme dönüştürmek için de ikili sayının her dört basamağı on altılı sistemde tek basamak olarak yazılır. Yukarıda ilk kullandığımız ikili değer için:
)
---
    // ikili:          0100 0000 0000 0000 0000 0000 0000 0101
    uint on_altılı = 0x___4____0____0____0____0____0____0____5;
---

$(H5 Bit işlemleri)

$(P
Değerlerin bitlerle nasıl ifade edildiklerini ve ikili veya on altılı olarak nasıl yazıldıklarını gördük. Şimdi değerleri bit düzeyinde değiştiren işlemlere geçebiliriz.
)

$(P
Her ne kadar bit düzeyindeki işlemlerden bahsediyor olsak da, bitlere doğrudan erişilemediğinden bu işlemler en az 8 biti birden etkilemek zorundadırlar. Örneğin, $(C ubyte) türündeki bir ifadenin 8 bitinin hepsi de, ama ayrı ayrı olarak bit işlemine dahil edilir.
)

$(P
Ben üst bitin özel anlamı nedeniyle işaretli türleri gözardı edeceğim ve bu örneklerde $(C uint) türünü kullanacağım. Siz buradaki işlemleri $(C ubyte) ve $(C ulong) türleriyle, ve işaret bitinin önemini hatırlamak şartıyla $(C byte), $(C int), ve $(C long) türleriyle de deneyebilirsiniz.
)

$(P
Önce aşağıdaki işlemleri açıklamada yardımcı olacak bir işlev yazalım. Kendisine verilen sayıyı ikili, on altılı, ve onlu sistemde göstersin:
)

---
import std.stdio;

void göster(uint sayı) {
    writefln("%032b %08x %10s", sayı, sayı, sayı);
}

void main() {
    göster(123456789);
}
---

$(P
Sırasıyla ikili, on altılı, ve onlu:
)

$(SHELL_SMALL
00000111010110111100110100010101 075bcd15  123456789
)

$(H6 $(IX ~, tersini alma) $(IX tersi, bit işleci) Tersini alma işleci $(C ~))

$(P
Bu işleç önüne yazıldığı ifadenin bitleri ters olanını üretir. 1 olan bitler 0, 0 olanlar 1 olur:
)

---
    uint değer = 123456789;
    write("  "); göster(değer);
    writeln("~ --------------------------------");
    write("  "); göster($(HILITE ~)değer);
---

$(P
Bu işlecin etkisi ikili gösteriminde çok kolay anlaşılıyor. Her bit tersine dönmüştür:
)

$(SHELL_SMALL
  00000111010110111100110100010101 075bcd15  123456789
~ --------------------------------
  11111000101001000011001011101010 f8a432ea 4171510506
)

$(P
Bu işlecin bit düzeyindeki etkisini şöyle özetleyebiliriz:
)

$(MONO
~0 → 1
~1 → 0
)

$(H6 $(IX &, ve) $(IX ve, bit işleci) $(I Ve) işleci $(C &))

$(P
İki ifadenin arasına yazılır. İki ifadenin aynı numaralı bitlerine sırayla bakılır. Sonuç olarak her iki ifadede de 1 olan bitler için 1 değeri, diğerleri için 0 değeri üretilir.
)

---
    uint soldaki = 123456789;
    uint sağdaki = 987654321;

    write("  "); göster(soldaki);
    write("  "); göster(sağdaki);
    writeln("& --------------------------------");
    write("  "); göster(soldaki $(HILITE &) sağdaki);
---

$(P
Mikro işlemci bu işlemde her iki ifadenin 31, 30, 29, vs. numaralı bitlerini ayrı ayrı kullanır.
)

$(P
Çıktıda önce soldaki ifadeyi, sonra da sağdaki ifadeyi görüyoruz. Kesikli çizginin altında da bit işleminin sonucu yazdırılıyor:
)

$(SHELL_SMALL
  00000111010110111100110100010101 075bcd15  123456789
  00111010110111100110100010110001 3ade68b1  987654321
& --------------------------------
  00000010010110100100100000010001 025a4811   39471121
)

$(P
Dikkat ederseniz, kesikli çizginin altına yazdırdığım sonuç değerde 1 olan bitler çizginin üstündeki her iki ifadede de 1 değerine sahip olan bitlerdir.
)

$(P
Bu işleç bu yüzden $(I ve işleci) olarak isimlendirilmiştir: soldaki $(I ve) sağdaki bit 1 olduğunda 1 değerini üretir. Bunu bir tablo ile gösterebiliriz. İki bitin 0 ve 1 oldukları dört farklı durumda ancak iki bitin de 1 oldukları durum 1 sonucunu verir:
)

$(MONO
0 & 0 → 0
0 & 1 → 0
1 & 0 → 0
1 & 1 → 1
)

$(P
Gözlemler:
)

$(UL
$(LI Bir taraf 0 ise diğer taraftan bağımsız olarak sonuç 0'dır; 0 ile $(I "ve"lemek), $(I sıfırlamak) anlamına gelir.)
$(LI Bir taraf 1 ise sonuç diğerinin değeridir; 1 ile $(I "ve"lemek) etkisizdir.)
)

$(H6 $(IX |) $(IX veya, bit işleci) $(I Veya) işleci $(C |))

$(P
İki ifadenin arasına yazılır. İki ifadenin aynı numaralı bitlerine sırayla bakılır. Her iki ifadede de 0 olan bitlere karşılık 0 değeri üretilir; diğerlerinin sonucu 1 olur:
)

---
    uint soldaki = 123456789;
    uint sağdaki = 987654321;

    write("  "); göster(soldaki);
    write("  "); göster(sağdaki);
    writeln("| --------------------------------");
    write("  "); göster(soldaki $(HILITE |) sağdaki);
---

$(SHELL_SMALL
  00000111010110111100110100010101 075bcd15  123456789
  00111010110111100110100010110001 3ade68b1  987654321
| --------------------------------
  00111111110111111110110110110101 3fdfedb5 1071639989
)

$(P
Dikkat ederseniz, sonuçta 0 olan bitler her iki ifadede de 0 olan bitlerdir. Bitin soldaki $(I veya) sağdaki ifadede 1 olması, sonucun da 1 olması için yeterlidir:
)

$(MONO
0 | 0 → 0
0 | 1 → 1
1 | 0 → 1
1 | 1 → 1
)

$(P
Gözlemler:
)

$(UL
$(LI Bir taraf 0 ise sonuç diğerinin değeridir; 0 ile $(I "veya"lamak) etkisizdir.)
$(LI Bir taraf 1 ise diğer taraftan bağımsız olarak sonuç 1'dir; 1 ile $(I "veya"lamak) 1 yapmak anlamına gelir.)
)

$(H6 $(IX ^, ya da) $(IX ya da, bit işleci) $(I Ya da) işleci $(C ^))

$(P
İki ifadenin arasına yazılır. İki ifadenin aynı numaralı bitlerine sırayla bakılır. İki ifadede farklı olan bitlere karşılık 1 değeri üretilir; diğerlerinin sonucu 0 olur:
)

---
    uint soldaki = 123456789;
    uint sağdaki = 987654321;

    write("  "); göster(soldaki);
    write("  "); göster(sağdaki);
    writeln("^ --------------------------------");
    write("  "); göster(soldaki $(HILITE ^) sağdaki);
---

$(SHELL_SMALL
  00000111010110111100110100010101 075bcd15  123456789
  00111010110111100110100010110001 3ade68b1  987654321
^ --------------------------------
  00111101100001011010010110100100 3d85a5a4 1032168868
)

$(P
Dikkat ederseniz, sonuçta 1 olan bitler soldaki ve sağdaki ifadelerde farklı olan bitlerdir. İkisinde de 0 veya ikisinde de 1 olan bitlere karşılık 0 üretilir.
)

$(MONO
0 ^ 0 → 0
0 ^ 1 → 1
1 ^ 0 → 1
1 ^ 1 → 0
)

$(P
Gözlem:
)

$(UL
$(LI Kendisiyle $(I "ya da"lamak) sıfırlamak anlamına gelir)
)

$(P
Değeri ne olursa olsun, aynı değişkenin kendisiyle $(I "ya da")lanması 0 sonucunu üretir:
)

---
    uint değer = 123456789;

    göster(değer ^ değer);
---

$(SHELL_SMALL
00000000000000000000000000000000 00000000          0
)

$(H6 $(IX >>) $(IX sağa kaydırma, bit işleci) Sağa kaydırma işleci $(C >>))

$(P
İfadenin değerini oluşturan bitleri belirtilen sayıda basamak kadar sağa kaydırır. Kaydırılacak yerleri olmayan en sağdaki bitler $(I düşerler) ve değerleri kaybedilir. Sol taraftan yeni gelen bitler işaretsiz türlerde 0 olur.
)

$(P
Bu örnek bitleri 2 basamak kaydırıyor:
)

---
    uint değer = 123456789;
    göster(değer);
    göster(değer $(HILITE >>) 2);
---

$(P
Hem sağdan kaybedilecek olan bitleri hem de soldan yeni gelecek olan bitleri işaretli olarak gösteriyorum:
)

$(SHELL_SMALL
000001110101101111001101000101$(HILITE 01) 075bcd15  123456789
$(HILITE 00)000001110101101111001101000101 01d6f345   30864197
)

$(P
Dikkat ederseniz, alt satırdaki bitler üst satırdaki bitlerin iki bit sağa kaydırılması ile elde edilmiştir.
)

$(P
$(IX işaret genişletilmesi) Bitler sağa kaydırılırken sol tarafa yeni gelenlerin 0 olduklarını gördünüz. Bu, işaretsiz türlerde böyledir. İşaretli türlerde ise $(I işaret genişletilmesi) (sign extension) denen bir yöntem uygulanır ve sayının en soldaki biti ne ise soldan hep o bitin değerinde bitler gelir.
)

$(P
Bu etkiyi göstermek için $(C int) türünde ve özellikle üst biti 1 olan bir değer seçelim:
)

---
    $(HILITE int) değer = 0x80010300;
    göster(değer);
    göster(değer >> 3);
---

$(P
Asıl sayıda üst bit 1 olduğu için yeni gelen bitler de 1 olur:
)

$(SHELL_SMALL
$(U 1)0000000000000010000001100000$(HILITE 000) 80010300 2147549952
$(HILITE 111)10000000000000010000001100000 f0002060 4026540128
)

$(P
Üst bitin 0 olduğu bir değerde yeni gelen bitler de 0 olur:
)

---
    $(HILITE int) değer = 0x40010300;
    göster(değer);
    göster(değer >> 3);
---

$(SHELL_SMALL
$(U 0)1000000000000010000001100000$(HILITE 000) 40010300 1073808128
$(HILITE 000)01000000000000010000001100000 08002060  134226016
)

$(H6 $(IX >>>) $(IX işaretsiz sağa kaydırma, bit işleci) İşaretsiz sağa kaydırma işleci $(C >>>))

$(P
Bu işleç sağa kaydırma işlecine benzer biçimde çalışır. Tek farkı $(I işaret genişletilmesinin) uygulanmamasıdır. Türden ve en soldaki bitten bağımsız olarak soldan her zaman için 0 gelir:
)

---
    int değer = 0x80010300;
    göster(değer);
    göster(değer $(HILITE >>>) 3);
---

$(SHELL_SMALL
10000000000000010000001100000$(HILITE 000) 80010300 2147549952
$(HILITE 000)10000000000000010000001100000 10002060  268443744
)

$(H6 $(IX <<) $(IX sola kaydırma, bit işleci) Sola kaydırma işleci $(C <<))

$(P
Sağa kaydırma işlecinin tersi olarak bitleri belirtilen basamak kadar sola kaydırır:
)

---
    uint değer = 123456789;
    göster(değer);
    göster(değer $(HILITE <<) 4);
---

$(P
En soldaki bit değerleri kaybedilir ve sağ taraftan 0 değerli bitler gelir:
)

$(SHELL_SMALL
$(HILITE 0000)0111010110111100110100010101 075bcd15  123456789
0111010110111100110100010101$(HILITE 0000) 75bcd150 1975308624
)

$(H6 $(IX atamalı bit işleci) Atamalı bit işleçleri)

$(P
Yukarıdaki işleçlerin ikili olanlarının atamalı karşılıkları da vardır: $(C &=), $(C |=), $(C ^=), $(C >>=), $(C >>>=), ve $(C <<=). $(LINK2 /ders/d/aritmetik_islemler.html, Tamsayılar ve Aritmetik İşlemler bölümünde) gördüğümüz atamalı aritmetik işleçlerine benzer biçimde, bunlar işlemi gerçekleştirdikten sonra sonucu soldaki ifadeye atarlar.
)

$(P
Örnek olarak $(C &=) işlecini kullanalım:
)

---
    değer = değer & 123;
    değer &= 123;         // üsttekiyle aynı şey
---

$(H5 Anlamları)

$(P
Bu işleçlerin bit düzeyinde nasıl işledikleri işlemlerin hangi anlamlarda görülmeleri gerektiği konusunda yeterli olmayabilir. Burada bu anlamlara dikkat çekmek istiyorum.
)

$(H6 $(C |) işleci birleşim kümesidir)

$(P
İki ifadenin 1 olan bitlerinin birleşimini verir. Uç bir örnek olarak, bitleri birer basamak atlayarak 1 olan ve birbirlerini tutmayan iki ifadenin birleşimi, sonucun bütün bitlerinin 1 olmasını sağlar:
)

---
    uint soldaki = 0xaaaaaaaa;
    uint sağdaki = 0x55555555;

    write("  "); göster(soldaki);
    write("  "); göster(sağdaki);
    writeln("| --------------------------------");
    write("  "); göster(soldaki | sağdaki);
---

$(SHELL_SMALL
  10101010101010101010101010101010 aaaaaaaa 2863311530
  01010101010101010101010101010101 55555555 1431655765
| --------------------------------
  11111111111111111111111111111111 ffffffff 4294967295
)

$(H6 $(C &) işleci kesişim kümesidir)

$(P
İki ifadenin 1 olan bitlerinin kesişimini verir. Uç bir örnek olarak, yukarıdaki iki ifadenin 1 olan hiçbir biti diğerini tutmadığı için, kesişimlerinin bütün bitleri 0'dır:
)

---
    uint soldaki = 0xaaaaaaaa;
    uint sağdaki = 0x55555555;

    write("  "); göster(soldaki);
    write("  "); göster(sağdaki);
    writeln("& --------------------------------");
    write("  "); göster(soldaki & sağdaki);
---

$(SHELL_SMALL
  10101010101010101010101010101010 aaaaaaaa 2863311530
  01010101010101010101010101010101 55555555 1431655765
& --------------------------------
  00000000000000000000000000000000 00000000          0
)

$(H6 $(C |=) işleci belirli bitleri 1 yapar)

$(P
İfadelerden bir taraftakini $(I asıl değişken) olarak düşünürsek, diğer ifadeyi de $(I 1 yapılacak olan bitleri seçen) ifade olarak görebiliriz:
)

---
    uint ifade = 0x00ff00ff;
    uint birYapılacakBitler = 0x10001000;

    write("önce       :  "); göster(ifade);
    write("1 olacaklar:  "); göster(birYapılacakBitler);

    ifade $(HILITE |=) birYapılacakBitler;
    write("sonra      :  "); göster(ifade);
---

$(P
Etkilenen bitlerin önceki ve sonraki durumlarını işaretli olarak gösterdim:
)

$(SHELL_SMALL
önce       :  000$(HILITE 0)000011111111000$(HILITE 0)000011111111 00ff00ff   16711935
1 olacaklar:  00010000000000000001000000000000 10001000  268439552
sonra      :  000$(HILITE 1)000011111111000$(HILITE 1)000011111111 10ff10ff  285151487
)

$(P
$(C birYapılacakBitler) değeri, bir anlamda hangi bitlerin 1 yapılacakları bilgisini taşımış ve asıl ifadenin o bitlerini 1 yapmış ve diğerlerine dokunmamıştır.
)

$(H6 $(C &=) işleci belirli bitleri siler)

$(P
İfadelerden bir taraftakini $(I asıl değişken) olarak düşünürsek, diğer ifadeyi de $(I silinecek olan bitleri seçen) ifade olarak görebiliriz:
)

---
    uint ifade = 0x00ff00ff;
    uint sıfırYapılacakBitler = 0xffefffef;

    write("önce        :  "); göster(ifade);
    write("silinecekler:  "); göster(sıfırYapılacakBitler);

    ifade $(HILITE &=) sıfırYapılacakBitler;
    write("sonra       :  "); göster(ifade);
---

$(P
Etkilenen bitlerin önceki ve sonraki durumlarını yine işaretli olarak gösteriyorum:
)

$(SHELL_SMALL
önce        :  00000000111$(HILITE 1)111100000000111$(HILITE 1)1111 00ff00ff   16711935
silinecekler:  11111111111011111111111111101111 ffefffef 4293918703
sonra       :  00000000111$(HILITE 0)111100000000111$(HILITE 0)1111 00ef00ef   15663343
)

$(P
$(C sıfırYapılacakBitler) değeri, hangi bitlerin sıfırlanacakları bilgisini taşımış ve asıl ifadenin o bitlerini sıfırlamıştır.
)

$(H6 $(C &) işleci belirli bir bitin 1 olup olmadığını sorgular)

$(P
Eğer ifadelerden birisinin tek bir biti 1 ise diğer ifadede o bitin 1 olup olmadığı sorgulanabilir:
)

---
    uint ifade = 123456789;
    uint sorgulananBit = 0x00010000;

    göster(ifade);
    göster(sorgulananBit);
    writeln(ifade $(HILITE &) sorgulananBit ? "evet, 1" : "1 değil");
---

$(P
Asıl ifadenin hangi bitinin sorgulandığını işaretli olarak gösteriyorum:
)

$(SHELL_SMALL
000001110101101$(HILITE 1)1100110100010101 075bcd15  123456789
00000000000000010000000000000000 00010000      65536
evet, 1
)

$(P
Başka bir bitini sorgulayalım:
)

---
    uint sorgulananBit = 0x00001000;
---

$(SHELL_SMALL
0000011101011011110$(HILITE 0)110100010101 075bcd15  123456789
00000000000000000001000000000000 00001000       4096
1 değil
)

$(P
Sorgulama ifadesinde birden fazla 1 kullanarak o bitlerin $(I hepsinin birden) asıl ifadede 1 olup olmadıkları da sorgulanabilir.
)

$(H6 Sağa kaydırmak ikiye bölmektir)

$(P
Sağa bir bit kaydırmak değerin yarıya inmesine neden olur. Bunu yukarıdaki basamak değerleri tablosunda görebilirsiniz: bir sağdaki bit her zaman için soldakinin yarısı değerdedir.
)

$(P
Sağa birden fazla sayıda kaydırmak o kadar sayıda yarıya bölmek anlamına gelir. Örneğin 3 bit kaydırmak, 3 kere 2'ye bölmek, yani sonuçta 8'e bölmek anlamına gelir:
)

---
    uint değer = 8000;

    writeln(değer >> 3);
---

$(SHELL_SMALL
1000
)

$(P
Ayrıntısına girmediğim $(I ikiye tümleyen) sisteminde sağa kaydırmak işaretli türlerde de ikiye bölmektir:
)

---
    $(HILITE int) değer = -8000;

    writeln(değer >> 3);
---

$(SHELL_SMALL
-1000
)

$(H6 Sola kaydırmak iki katını almaktır)

$(P
Basamaklar tablosundaki her bitin, bir sağındakinin iki katı olması nedeniyle, bir bit sola kaydırmak 2 ile çarpmak anlamına gelir:
)

---
    uint değer = 10;

    writeln(değer << 5);
---

$(P
Beş kere 2 ile çarpmak 32 ile çarpmanın eşdeğeridir:
)

$(SHELL_SMALL
320
)

$(H5 Bazı kullanımları)

$(H6 $(IX bayrak) Bayraklar)

$(P
Bayraklar birbirlerinden bağımsız olarak bir arada tutulan tek bitlik verilerdir. Tek bitlik oldukları için var/yok, olsun/olmasın, geçerli/geçersiz gibi iki değerli kavramları ifade ederler.
)

$(P
Her ne kadar böyle tek bitlik bilgilerin yaygın olmadıklarını söylemiş olsam da bazen bir arada kullanılırlar. Bayraklar özellikle C kütüphanelerinde yaygındır. C'den uyarlanan D kütüphanelerinde bulunmaları da beklenebilir.
)

$(P
Bayraklar bir $(C enum) türünün birbirleriyle örtüşmeyen tek bitlik değerleri olarak tanımlanırlar.
)

$(P
Bir örnek olarak araba yarışıyla ilgili bir oyun programı düşünelim. Bu programın gerçekçiliği kullanıcı seçimlerine göre belirlensin:
)

$(UL
$(LI Benzin, kullanıma göre azalabilsin.)
$(LI Çarpışmalar hasar bırakabilsin.)
$(LI Lastikler kullanıma göre eskiyebilsin.)
$(LI Lastikler yolda iz bırakabilsin.)
)

$(P
Oyun sırasında bunlardan hangilerinin etkin olacakları bayrak değerleriyle belirtilebilir:
)

---
enum Gerçekçilik {
    benzinBiter        = 1 << 0,
    hasarOluşur        = 1 << 1,
    lastiklerEskir     = 1 << 2,
    lastikİzleriOluşur = 1 << 3
}
---

$(P
Dikkat ederseniz, o $(C enum) değerlerinin hepsi de birbirleriyle çakışmayan tek bitten oluşmaktadırlar. Her değer 1'in farklı sayıda sola ötelenmesi ile elde edilmiştir. Bit değerlerinin şöyle olduklarını görebiliriz:
)

$(MONO
benzinBiter        : ...0001
hasarOluşur        : ...0010
lastiklerEskir     : ...0100
lastikİzleriOluşur : ...1000
)

$(P
Hiçbir bit diğerlerininkiyle çakışmadığı için bu değerler $(C |) ile birleştirilebilir ve hep birden tek bir değişkende bulundurulabilir. Örneğin, yalnızca lastiklerle ilgili ayarların etkin olmaları istendiğinde değer şöyle kurulabilir:
)

---
    Gerçekçilik ayarlar = Gerçekçilik.lastiklerEskir
                          |
                          Gerçekçilik.lastikİzleriOluşur;
    writefln("%b", ayarlar);
---

$(P
Bu iki bayrağın bitleri aynı değer içinde yan yana bulunurlar:
)

$(SHELL_SMALL
1100
)

$(P
Daha sonradan, programın asıl işleyişi sırasında bu bayrakların etkin olup olmadıkları $(C &) işleci ile denetlenir:
)

---
    if (ayarlar & Gerçekçilik.benzinBiter) {
        // ... benzinin azalmasıyla ilgili kodlar ...
    }

    if (ayarlar & Gerçekçilik.lastiklerEskir) {
        // ... lastiklerin eskimesiyle ilgili kodlar ...
    }
---

$(P
$(C &) işlecinin sonucu, ancak belirtilen bayrak $(C ayarlar) içinde de 1 ise 1 sonucunu verir.
)

$(P
$(C if) koşuluyla kullanılabilmesinin bir nedeni de $(LINK2 /ders/d/tur_donusumleri.html, Tür Dönüşümleri bölümünden) hatırlayacağınız gibi, sıfır olmayan değerlerin otomatik olarak $(C true)'ya dönüşmesidir. $(C &) işlecinin sonucu 0 olduğunda $(C false), farklı bir değer olduğunda da $(C true) değerine dönüşür ve bayrağın etkin olup olmadığı böylece anlaşılmış olur.
)

$(H6 $(IX maske) Maskeleme)

$(P
Bazı kütüphanelerde ve sistemlerde belirli bir tamsayı değer içine birden fazla bilgi yerleştirilmiş olabilir. Örneğin, 32 bitlik bir değerin üst 3 bitinin belirli bir anlamı ve alt 29 bitinin başka bir anlamı bulunabilir. Bu veriler maskeleme yöntemiyle birbirlerinden ayrılabilirler.
)

$(P
Bunun bir örneğini IPv4 adreslerinde görebiliriz. IPv4 adresleri ağ paketleri içinde 32 bitlik tek bir değer olarak bulunurlar. Bu 32 bitin 8'er bitlik 4 parçası günlük kullanımdan alışık olduğumuz noktalı adres gösterimi değerleridir. Örneğin, 192.168.1.2 gibi bir adres, 32 bit olarak 0xc0a80102 değeridir:
)

$(MONO
c0 == 12 * 16 + 0 = 192
a8 == 10 * 16 + 8 = 168
01 ==  0 * 16 + 1 =   1
02 ==  0 * 16 + 2 =   2
)

$(P
Maske, ilgilenilen veri ile örtüşen sayıda 1'lerden oluşur. Asıl değişken bu maske ile $(I "ve"lendiğinde), yani $(C &) işleci ile kullanıldığında verinin değerleri elde edilir. Örneğin, 0x000000ff gibi bir maske değeri ifadenin alt 8 bitini olduğu gibi korur, diğer bitlerini sıfırlar:
)

---
    uint değer = 123456789;
    uint maske = 0x000000ff;

    write("değer: "); göster(değer);
    write("maske: "); göster(maske);
    write("sonuç: "); göster(değer & maske);
---

$(P
Maskenin seçerek koruduğu bitleri işaretli olarak gösteriyorum. Diğer bütün bitler sıfırlanmıştır:
)

$(SHELL_SMALL
değer: 000001110101101111001101$(HILITE 00010101) 075bcd15  123456789
maske: 00000000000000000000000011111111 000000ff        255
sonuç: 000000000000000000000000$(HILITE 00010101) 00000015         21
)

$(P
Bu yöntemi 0xc0a80102 IPv4 adresine ve en üst 8 biti seçecek bir maskeyle uyguladığımızda noktalı gösterimdeki ilk adres değerini elde ederiz:
)

---
    uint değer = 0xc0a80102;
    uint maske = 0xff000000;

    write("değer: "); göster(değer);
    write("maske: "); göster(maske);
    write("sonuç: "); göster(değer & maske);
---

$(P
Maskenin üst bitleri 1 olduğundan, değerin de üst bitleri seçilmiş olur:
)

$(SHELL_SMALL
değer: $(HILITE 11000000)101010000000000100000010 c0a80102 3232235778
maske: 11111111000000000000000000000000 ff000000 4278190080
sonuç: $(HILITE 11000000)000000000000000000000000 c0000000 3221225472
)

$(P
Ancak, sonucun onlu gösterimi beklediğimiz gibi 192 değil, 3221225472 olmuştur. Bunun nedeni, maskelenen 8 bitin değerin en sağ tarafına kaydırılmalarının da gerekmesidir. O 8 biti 24 bit sağa kaydırırsak birlikte ifade ettikleri değeri elde ederiz:
)

---
    uint değer = 0xc0a80102;
    uint maske = 0xff000000;

    write("değer: "); göster(değer);
    write("maske: "); göster(maske);
    write("sonuç: "); göster((değer & maske) $(HILITE >> 24));
---

$(SHELL_SMALL
değer: $(HILITE 11000000)101010000000000100000010 c0a80102 3232235778
maske: 11111111000000000000000000000000 ff000000 4278190080
sonuç: 000000000000000000000000$(HILITE 11000000) 000000c0        $(HILITE 192)
)

$(PROBLEM_COK

$(PROBLEM
Verilen IPv4 adresinin noktalı gösterimini döndüren bir işlev yazın:

---
string noktalıOlarak(uint ipAdresi) {
    // ...
}

unittest {
    assert(noktalıOlarak(0xc0a80102) == "192.168.1.2");
}
---

)

$(PROBLEM
Verilen 4 değeri 32 bitlik IPv4 adresine dönüştüren bir işlev yazın:

---
uint ipAdresi(ubyte bayt3,    // en yüksek değerli bayt
              ubyte bayt2,
              ubyte bayt1,
              ubyte bayt0) {  // en düşük değerli bayt
    // ...
}

unittest {
    assert(ipAdresi(192, 168, 1, 2) == 0xc0a80102);
}
---

)

$(PROBLEM
Maske oluşturan bir işlev yazın. Belirtilen bit ile başlayan ve belirtilen uzunlukta olan maske oluştursun:

---
uint maskeYap(int düşükBit, int uzunluk) {
    // ...
}

unittest {
    assert(maskeYap(2, 5) ==
           0b_0000_0000_0000_0000_0000_0000_0111_1100);
    //                                            ↑
    //                             başlangıç biti 2
    //                             ve 5 bitten oluşuyor
}
---

)

)

Macros:
        SUBTITLE=Bit İşlemleri

        DESCRIPTION=D'nin en alt düzey işlem olanaklarından olan bit işlemleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial bit bayt bit işlemleri

SOZLER=
$(bayrak)
$(bayt)
$(bit)
$(ifade)
$(ikili_sistem)
$(isaretli_tur)
$(isaretsiz_tur)
$(on_altili_sistem)
$(yazmac)
