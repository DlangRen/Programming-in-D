Ddoc

$(DERS_BOLUMU $(IX tür dönüşümü) $(IX dönüşüm, tür) Tür Dönüşümleri)

$(P
İşlemlerde kullanılan değişken ve nesne türlerinin hem o işlemlerle hem de birbirleriyle uyumlu olmaları gerekir. Yoksa anlamsız veya yanlış sonuçlar doğabilir. D'nin de aralarında bulunduğu bazı diller türlerin uyumluluklarını derleme zamanında denetlerler. Böyle dillere "türleri derleme zamanında belli olan" anlamında "statically typed" dil denir.
)

$(P
Anlamsız işlem örneği olarak, bir toplama işleminde sanki bir sayıymış gibi dizgi kullanmaya çalışan şu koda bakalım:
)

---
    char[] dizgi;
    writeln(dizgi + 5);    $(DERLEME_HATASI)
---

$(P
Derleyici o kodu tür uyuşmazlığı nedeniyle reddeder. Bu yazıyı yazdığım sırada kullandığım derleyici, türlerin uyumsuz olduğunu bildiren şu hatayı veriyor:
)

$(SHELL
Error: $(HILITE incompatible types) for ((dizgi) + (5)): 'char[]' and 'int'
)

$(P
O hata mesajı, $(C ((dizgi) + (5))) ifadesinde uyumsuz türler olduğunu belirtir: $(C char[]) ve $(C int).
)

$(P
Tür uyumsuzluğu, $(I farklı tür) demek değildir. Çünkü farklı türlerin güvenle kullanılabildiği işlemler de vardır. Örneğin $(C double) türündeki bir değişkene $(C int) türünde bir değer eklenmesinde bir sakınca yoktur:
)

---
    double toplam = 1.25;
    int artış = 3;
    toplam += artış;
---

$(P
$(C toplam) ve $(C artış) farklı türlerden oldukları halde o işlemde bir yanlışlık yoktur; çünkü bir kesirli sayı değişkeninin bir $(C int) değer kadar arttırılmasında bir uyumsuzluk yoktur.
)

$(H5 $(IX otomatik tür dönüşümü) Otomatik tür dönüşümleri)

$(P
Her ne kadar bir $(C double) değerin bir $(C int) değer kadar arttırılmasında bir sakınca olmasa da, o işlemin mikro işlemcide yine de belirli bir türde yapılması gerekir. $(LINK2 /ders/d/kesirli_sayilar.html, Kesirli Sayılar bölümünden) hatırlayacağınız gibi; 64 bitlik olan $(C double), 32 bitlik olan $(C int)'ten daha $(I büyük) (veya $(I geniş)) bir türdür. Bir $(C int)'e sığabilen her değer bir $(C double)'a da sığabilir.
)

$(P
Birbirinden farklı türler kullanılan işlemlerle karşılaştığında, derleyici önce değerlerden birisini diğer türe dönüştürür, ve işlemi ondan sonra gerçekleştirir. Bu dönüşümde kullanılan tür, değer kaybına neden olmayacak şekilde seçilir. Örneğin $(C double) türü $(C int) türünün bütün değerlerini tutabilir, ama bunun tersi doğru değildir. O yüzden yukarıdaki $(C toplam += artış) işlemi $(C double) türünde güvenle gerçekleştirilebilir.
)

$(P
Dönüştürülen değer, her zaman için isimsiz ve geçici bir değişken veya nesnedir. Asıl değerin kendisi değişmez. Örneğin yukarıdaki $(C +=) işlemi sırasında $(C artış)'ın kendi türü değiştirilmez, ama $(C artış)'ın değerine eşit olan geçici bir değer kullanılır. Yukarıdaki işlemde perde arkasında neler olduğunu şöyle gösterebiliriz:
)

---
    {
        double $(I aslında_isimsiz_olan_double_bir_deger) = artış;
        toplam += $(I aslında_isimsiz_olan_double_bir_deger);
    }
---

$(P
Derleyici, $(C int) değeri önce $(C double) türündeki geçici bir ara değere dönüştürür ve işlemde o dönüştürdüğü değeri kullanır. Bu örnekteki geçici değer yalnızca $(C +=) işlemi süresince yaşar.
)

$(P
Böyle otomatik dönüşümler aritmetik işlemlerle sınırlı değildir. Birbirinin aynısı olmayan türlerin kullanıldığı başka durumlarda da otomatik tür dönüşümleri uygulanır. Eğer kullanılan türler bir dönüşüm sonucunda birlikte kullanılabiliyorlarsa, derleyici gerektikçe değerleri otomatik olarak dönüştürür. Örneğin $(C int) türünde parametre alan bir işleve $(C byte) türünde bir değer gönderilebilir:
)

---
void birİşlem(int sayı) {
    // ...
}

void main() {
    byte küçükDeğer = 7;
    birİşlem(küçükDeğer);    // otomatik tür dönüşümü
}
---

$(P
Orada da önce $(C küçükDeğer)'e eşit geçici bir $(C int) oluşturulur, ve $(C birİşlem) o geçici $(C int) değeri ile çağrılır.
)

$(H6 $(IX tamsayı terfisi) $(IX terfi, tamsayı) $(IX int terfisi) $(C int) terfileri)

$(P
Aşağıdaki tabloda sol taraftaki türler çoğu aritmetik işlemde doğrudan kullanılmazlar, önce otomatik olarak sağ taraftaki türlere dönüştürülürler:
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">Hangi Türden</th> <th scope="col">Hangi Türe</th>
</tr>

        <tr align="center">
	<td>bool</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>byte</td>
	<td>int</td>
	</tr>

	<tr align="center">
	<td>ubyte</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>short</td>
	<td>int</td>
	</tr>

	<tr align="center">
	<td>ushort</td>
	<td>int</td>
	</tr>

	<tr align="center">
	<td>char</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>wchar</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>dchar</td>
	<td>uint</td>
	</tr>
</table>

$(P
$(C int) terfileri $(C enum) türlerine de uygulanır.
)

$(P
Bu terfilerin nedeni mikro işlemcinin doğal türünün $(C int) olmasıdır. Örneğin, aşağıdaki her iki değişken de $(C ubyte) oldukları halde toplama işlemi o değişkenlerin değerleri $(C int) türüne terfi edildikten sonra gerçekleştirilir:
)

---
    ubyte a = 1;
    ubyte b = 2;
    writeln(typeof(a + b).stringof);  // işlem ubyte değildir
---

$(P
Çıktısı:
)

$(SHELL
int
)

$(P
Terfi edilen $(C a) ve $(C b) değişkenleri değildir. Toplama işleminde kullanılabilsinler diye yalnızca onların değerleri geçici değerler olarak terfi edilirler.
)

$(H6 $(IX aritmetik dönüşüm) Aritmetik dönüşümler)

$(P
Aritmetik işlemlerde kullanılan değerler güvenli yönde, yani küçük türden büyük türe doğru gerçekleştirilirler. Bu kadarını akılda tutmak çoğu durumda yeterli olsa da aslında bu kurallar oldukça karışıktır, ve işaretli türlerden işaretsiz türlere yapılan dönüşümlerde de hataya yol açabilirler.
)

$(P
Dönüşüm kuralları şöyledir:
)

$(OL

$(LI Değerlerden birisi $(C real) ise diğeri $(C real)'e dönüştürülür)

$(LI Değilse ama birisi $(C double) ise diğeri $(C double)'a dönüştürülür)

$(LI Değilse ama birisi $(C float) ise diğeri $(C float)'a dönüştürülür)

$(LI Değilse yukarıdaki $(C int) terfisi dönüşümleri uygulanır ve sonra şu işlemlere geçilir:

$(OL
$(LI Eğer iki tür de aynı ise durulur)
$(LI Eğer her ikisi de işaretli ise, veya her ikisi de işaretsiz ise; küçük tür büyük türe dönüştürülür)
$(LI Eğer işaretli tür işaretsiz türden büyükse, işaretsiz olan işaretliye dönüştürülür)
$(LI Hiçbirisi değilse işaretli tür işaretsiz türe dönüştürülür)
)
)
)

$(P
Yukarıdaki son kural ne yazık ki hatalara yol açabilir:
)

---
    int    a = 0;
    int    b = 1;
    size_t c = 0;
    writeln(a - b + c);  // Şaşırtıcı sonuç!
---

$(P
Çıktısı şaşırtıcı biçimde $(C size_t.max) olur:
)

$(SHELL
18446744073709551615
)

$(P
Yukarıdaki son kural nedeniyle ifade $(C int) türünde değil, $(C size_t) türünde gerçekleştirilir. $(C size_t) de işaretsiz bir tür olduğundan -1 değerini taşıyamaz ve sonuç alttan taşarak $(C size_t.max) olur.
)


$(H6 $(IX sabit uzunluklu dizi, dilime dönüşüm) $(IX statik dizi, dilime dönüşüm) Dilim dönüşümleri)

$(P
Bir kolaylık olarak, sabit uzunluklu diziler işlev çağrılarında otomatik olarak dilimlere dönüşebilirler:
)

---
import std.stdio;

void foo() {
    $(HILITE int[2]) dizi = [ 1, 2 ];

    // Sabit uzunluklu dizi dilim olarak geçiriliyor:
    bar(dizi);
}

void bar($(HILITE int[]) dilim) {
    writeln(dilim);
}

void main() {
    foo();
}
---

$(P
$(C bar())'ın parametresi bütün elemanlara erişim sağlayan bir dilimdir:
)

$(SHELL
[1, 2]
)

$(P
$(B Uyarı:) Eğer işlev, dilimi sonradan kullanmak üzere saklıyorsa $(I yerel) bir sabit uzunluklu dizinin o işleve geçirilmesi yanlıştır. Örneğin, aşağıdaki programda $(C bar())'ın sonradan kullanılmak üzere sakladığı dilim $(C foo())'dan çıkıldığında geçerli değildir:
)

---
import std.stdio;

void foo() {
    int[2] dizi = [ 1, 2 ];

    // Sabit uzunluklu dizi dilim olarak geçiriliyor:
    bar(dizi);

}  // ← NOT: 'dizi' bu noktadan sonra geçerli değildir

int[] saklananDilim;

void bar(int[] dilim) {
    // Yakında geçersiz olacak bir dilim saklamaktadır:
    saklananDilim = dilim;
    writefln("bar içinde : %s", saklananDilim);
}

void main() {
    foo();

    /* HATA: Artık dizi elemanı olmayan belleğe erişir */
    writefln("main içinde: %s", saklananDilim);
}
---

$(P
Böyle bir hatanın sonucunda programın davranışı tanımsızdır. Örneğin, $(C dizi)'nin elemanlarının bulunduğu belleğin çoktan başka amaçlarla kullanıldığı gözlemlenebilir:
)

$(SHELL
bar içinde : [1, 2]        $(SHELL_NOTE asıl elemanlar)
main içinde: [4396640, 0]  $(SHELL_NOTE_WRONG tanımsız davranışın gözlemlenmesi)
)

$(H6 $(C const) dönüşümleri)

$(P
Her referans türü kendisinin $(C const) olanına otomatik olarak dönüşür. Bu güvenli bir dönüşümdür çünkü hem zaten türün büyüklüğünde bir değişiklik olmaz hem de $(C const) değerler değiştirilemezler:
)

---
char[] parantezİçinde($(HILITE const char[]) metin) {
    return "{" ~ metin ~ "}";
}

void main() {
    $(HILITE char[]) birSöz;
    birSöz ~= "merhaba dünya";
    parantezİçinde(birSöz);
}
---

$(P
O kodda sabit olmayan $(C birSöz), sabit parametre alan işleve güvenle gönderilebilir, çünkü değerler sabit referanslar aracılığıyla değiştirilemezler.
)

$(P
Bunun tersi doğru değildir. $(C const) bir referans türü, $(C const) olmayan bir türe dönüşmez:
)

---
char[] parantezİçinde(const char[] metin) {
    char[] parametreDeğeri = metin;  $(DERLEME_HATASI)
// ...
}
---

$(P
Bu konu yalnızca referans değişkenleri ve referans türleri ile ilgilidir. Çünkü değer türlerinde zaten değer kopyalandığı için, kopyanın $(C const) olan asıl nesneyi değiştirmesi söz konusu olamaz:
)

---
    const int köşeAdedi = 4;
    int kopyası = köşeAdedi;      // derlenir (değer türü)
---

$(P
Yukarıdaki durumda $(C const) türden $(C const) olmayan türe dönüşüm yasaldır çünkü dönüştürülen değer asıl değerin bir kopyası haline gelir.
)

$(H6 $(C immutable) dönüşümleri)

$(P
$(C immutable) belirteci kesinlikle değişmezlik gerektirdiğinden ne $(C immutable) türlere dönüşümler ne de $(C immutable) türlerden dönüşümler otomatiktir:
)

---
    string a = "merhaba";
    char[] b = a;          $(DERLEME_HATASI)
    string c = b;          $(DERLEME_HATASI)
---

$(P
$(C const) dönüşümlerde olduğu gibi bu konu da yalnızca referans türleriyle ilgilidir. Değer türlerinin değerleri kopyalandıklarından, değer türlerinde her iki yöne doğru dönüşümler de otomatiktir:
)

---
    immutable a = 10;
    int b = a;           // derlenir (değer türü)
---

$(H6 $(C enum) dönüşümleri)

$(P
$(LINK2 /ders/d/enum.html, $(C enum) bölümünden) hatırlayacağınız gibi, $(C enum) türleri $(I isimli değerler) kullanma olanağı sunarlar:
)

---
    enum OyunKağıdıRengi { maça, kupa, karo, sinek }
---

$(P
Değerleri özellikle belirtilmediği için o tanımda değerler sıfırdan başlayarak ve birer birer arttırılarak atanır. Buna göre örneğin $(C OyunKağıdıRengi.sinek)'in değeri 3 olur.
)

$(P
Böyle isimli $(C enum) değerleri, otomatik olarak tamsayı türlere dönüşürler. Örneğin aşağıdaki koddaki toplama işlemi sırasında $(C OyunKağıdıRengi.kupa) 1 değerini alır ve sonuç 11 olur:
)

---
    int sonuç = 10 + OyunKağıdıRengi.kupa;
    assert(sonuç == 11);
---

$(P
Bunun tersi doğru değildir: tamsayı değerler $(C enum) türlerine otomatik olarak dönüşmezler. Örneğin aşağıdaki kodda $(C renk) değişkeninin 2 değerinin karşılığı olan $(C OyunKağıdıRengi.karo) değerini almasını bekleyebiliriz; ama derlenemez:
)

---
    OyunKağıdıRengi renk = 2;   $(DERLEME_HATASI)
---

$(P
Tamsayıdan $(C enum) değerlere dönüşümün açıkça yapılması gerekir. Bunu aşağıda göreceğiz.
)

$(H6 $(IX bool, otomatik dönüşüm) $(C bool) dönüşümleri)

$(P
$(C false) 0'a, $(C true) da 1'e otomatik olarak dönüşür:
)

---
    int birKoşul = false;
    assert(birKoşul == 0);

    int başkaKoşul = true;
    assert(başkaKoşul == 1);
---

$(P
$(I Hazır değer) kullanıldığında bunun tersi ancak iki özel değer için doğrudur: 0 hazır değeri $(C false)'a, 1 hazır değeri de $(C true)'ya otomatik olarak dönüşür:
)

---
    bool birDurum = 0;
    assert(!birDurum);     // false

    bool başkaDurum = 1;
    assert(başkaDurum);    // true
---

$(P
Sıfır ve bir dışındaki hazır değerler otomatik olarak dönüşmezler:
)

---
    bool b = 2;    $(DERLEME_HATASI)
---

$(P
Bazı deyimlerin mantıksal ifadelerden yararlandıklarını biliyorsunuz: $(C if), $(C while), vs. Aslında böyle deyimlerde yalnızca $(C bool) değil, başka türler de kullanılabilir. Başka türler kullanıldığında sıfır değeri $(C false)'a, sıfırdan başka değerler de $(C true)'ya otomatik olarak dönüşürler:
)

---
    int i;
    // ...

    if (i) {    // ← int, mantıksal ifade yerine kullanılıyor
        // ... 'i' sıfır değilmiş

    } else {
        // ... 'i' sıfırmış
    }
---

$(P
Benzer biçimde, $(C null) değerler otomatik olarak $(C false)'a, $(C null) olmayan değerler de $(C true)'ya dönüşürler. Bu, referansların $(C null) olup olmadıklarının denetlenmesinde kolaylık sağlar:
)

---
    int[] a;
    // ...

    if (a) {    // ← otomatik bool dönüşümü
        // ... null değil; 'a' kullanılabilir ...

    } else {
        // ... null; 'a' kullanılamaz ...
    }
---

$(H5 $(IX açıkça yapılan tür dönüşümü) Açıkça yapılan tür dönüşümleri)

$(P
Bazı durumlarda bazı tür dönüşümlerinin elle açıkça yapılması gerekebilir çünkü bazı dönüşümler veri kaybı tehlikesi ve güvensizlik nedeniyle otomatik değillerdir:
)

$(UL
$(LI Büyük türden küçük türe dönüşümler)
$(LI $(C const) türden değişebilen türe dönüşümler)
$(LI $(C immutable) dönüşümleri)
$(LI Tamsayılardan $(C enum) değerlere dönüşümler)
$(LI vs.)
)

$(P
Programcının isteği ile açıkça yapılan tür dönüşümleri için aşağıdaki yöntemler kullanılabilir:
)

$(UL
$(LI Kurma söz dizimi)
$(LI $(C std.conv.to) işlevi)
$(LI $(C std.exception.assumeUnique) işlevi)
$(LI $(C cast) işleci)
)

$(H6 $(IX kurucu, tür dönüşümü) Kurma söz dizimi)

$(P
Yapı ve sınıf nesnelerinin kurma söz dizimi başka türlerle de kullanılabilir:
)

---
    $(I HedefTür)(değer)
---

$(P
Örneğin, aşağıdaki $(I dönüşüm) bir $(C int) değerinden bir $(C double) değeri elde etmektedir (örneğin, sonucun virgülden sonrasını kaybetmemek için):
)

---
    int i;
    // ...
    const sonuç = $(HILITE double(i)) / 2;
---

$(H6 $(IX to, std.conv) Çoğu dönüşüm için $(C to()))

$(P
Daha önce hep değerleri $(C string) türüne dönüştürmek için $(C to!string) olarak kullandığımız $(C to) aslında mümkün olan her dönüşümü sağlayabilir. Söz dizimi şöyledir:
)

---
    to!($(I HedefTür))(değer)
---

$(P
Aslında bir şablon olan $(C to), şablonların daha ileride göreceğimiz kısa söz diziminden de yararlanabildiği için hedef türün tek sözcükle belirtilebildiği durumlarda hedef tür parantezsiz olarak da yazılabilir:
)

---
    to!$(I HedefTür)(değer)
---

$(P
$(C to)'nun kullanımını görmek için bir $(C double) değerini $(C short) türüne ve bir $(C string) değerini de $(C int) türüne dönüştürmeye çalışan aşağıdaki koda bakalım:
)

---
void main() {
    double d = -1.75;

    short s = d;     $(DERLEME_HATASI)
    int i = "42";    $(DERLEME_HATASI)
}
---

$(P
Her $(C double) değer $(C short) olarak ifade edilemeyeceğinden ve her dizgi $(C int) olarak kabul edilebilecek karakterler içermediğinden o dönüşümler otomatik değildir. Programcı, uygun olan durumlarda bu dönüşümleri açıkça $(C to) ile gerçekleştirebilir:
)

---
import std.conv;

void main() {
    double d = -1.75;

    short s = to!short(d);
    assert(s == -1);

    int i = to!int("42");
    assert(i == 42);
}
---

$(P
Dikkat ederseniz $(C short) türü kesirli değer alamadığı için $(C s)'nin değeri -1 olarak dönüştürülebilmiştir.
)

$(P
$(C to()) güvenlidir: Mümkün olmayan dönüşümlerde hata atar.
)

$(H6 $(IX assumeUnique, std.exception) Hızlı $(C immutable) dönüşümleri için $(C assumeUnique()))

$(P
$(C to()), $(C immutable) dönüşümlerini de gerçekleştirebilir:
)

---
    int[] dilim = [ 10, 20, 30 ];
    auto değişmez = to!($(HILITE immutable int[]))(dilim);
---

$(P
Yukarıdaki koddaki değiştirilebilen elemanlardan oluşan $(C dilim)'e ek olarak $(C immutable) bir dilim daha oluşturulmaktadır. $(C değişmez)'in elemanlarının gerçekten değişmemelerinin sağlanabilmesi için $(C dilim) ile aynı elemanları paylaşmaması gerekir. Aksi taktirde, $(C dilim) yoluyla yapılan değişiklikler $(C değişmez)'in elemanlarının da değişmesine ve böylece $(C immutable) belirtecine aykırı duruma düşmesine neden olurdu.
)

$(P
Bu yüzden $(C to()), $(C immutable) dönüşümlerini asıl değerin kopyasını alarak gerçekleştirir. Aynı durum dizilerin $(C .idup) niteliği için de geçerlidir; hatırlarsanız $(C .idup)'un ismi "kopyala" anlamına gelen "duplicate"ten türemiştir. $(C değişmez)'in elemanlarının $(C dilim)'inkilerden farklı olduklarını ilk elemanlarının adreslerinin farklı olmasına bakarak gösterebiliriz:
)

---
    assert(&(dilim[0]) $(HILITE !=) &(değişmez[0]));
---

$(P
Bazen bu kopya gereksiz olabilir ve nadiren de olsa program hızını etkileyebilir. Bunun bir örneğini görmek için değişmez bir tamsayı dilimi bekleyen bir işleve bakalım:
)

---
void işlev(immutable int[] koordinatlar) {
    // ...
}

void main() {
    int[] sayılar;
    sayılar ~= 10;
    // ... çeşitli değişiklikler ...
    sayılar[0] = 42;

    işlev(sayılar);    $(DERLEME_HATASI)
}
---

$(P
Yukarıdaki kod, $(C sayılar) parametresi işlevin gerekçesini yerine getirmediği için derlenemez çünkü programın derlenebilmesi için $(C işlev())'e $(C immutable) bir dilim verilmesi şarttır. Bunun bir yolunun $(C to()) olduğunu gördük:
)

---
import std.conv;
// ...
    auto değişmezSayılar = to!($(HILITE immutable int[]))(sayılar);
    işlev(değişmezSayılar);
---

$(P
Ancak, eğer $(C sayılar) dilimi yalnızca bu parametreyi oluşturmak için gerekmişse ve $(C işlev()) çağrıldıktan sonra bir daha hiç kullanılmayacaksa, elemanların $(C değişmezSayılar) dilimine kopyalanmaları gereksiz olacaktır. $(C assumeUnique()), bir dilimin elemanlarının belirli bir noktadan sonra değişmez olarak işaretlenmelerini sağlar:
)

---
import std.exception;
// ...
    auto değişmezSayılar = assumeUnique(sayılar);
    işlev(değişmezSayılar);
    assert(sayılar is null);    // asıl dilim null olur
---

$(P
"Tek kopya olduğunu varsay" anlamına gelen $(C assumeUnique()) eleman kopyalamaz; aynı elemanlara $(C immutable) olarak erişim sağlayan yeni bir dilim döndürür. Elemanların asıl dilim aracılığıyla yanlışlıkla değiştirilmelerini önlemek için de asıl dilimi $(C null)'a eşitler.
)

$(H6 $(IX cast) $(C cast) işleci)

$(P
$(C to())'nun ve $(C assumeUnique())'in kendi gerçekleştirmelerinde de yararlandıkları alt düzey dönüşüm işleci $(C cast) işlecidir.
)

$(P
Hedef tür $(C cast) parantezinin içine yazılır:
)

---
    cast($(I HedefTür))değer
---

$(P
$(C cast), $(C to())'nun güvenle gerçekleştiremediği dönüşümleri de yapacak kadar güçlüdür. Örneğin, aşağıdaki dönüşümler $(C to())'nun çalışma zamanında hata atmasına neden olur:
)

---
    OyunKağıdıRengi renk = to!OyunKağıdıRengi(7); $(CODE_NOTE_WRONG hata atar)
    bool b = to!bool(2);                          $(CODE_NOTE_WRONG hata atar)
---

$(P
Örneğin, atılan hata dönüştürülmek istenen 7 değerinin $(C OyunKağıdıRengi) türünde bir karşılığı olmadığını bildirir:
)

$(SHELL
std.conv.ConvException@phobos/std/conv.d(1778): Value (7)
$(HILITE does not match any member) value of enum 'OyunKağıdıRengi'
)

$(P
Bir tamsayının $(C OyunKağıdıRengi) değeri olarak kullanılabileceğinden veya bir tamsayı değerin $(C bool) anlamında kullanılabileceğinden ancak programcı emin olabilir. Bu gibi durumlarda $(C cast) işlecinden yararlanılmalıdır:
)

---
    // Olasılıkla hatalı ama mümkün:
    OyunKağıdıRengi renk = cast(OyunKağıdıRengi)7;

    bool b = cast(bool)2;
    assert(b);
---

$(P
Gösterge türleri arasındaki dönüşümler $(C cast) ile yapılmak zorundadır:
)

---
    $(HILITE void *) v;
    // ...
    int * p = cast($(HILITE int*))v;
---

$(P
Yaygın olmasa da, bazı C kütüphane arayüzleri gösterge değerlerinin gösterge olmayan değişkenlerde tutulmalarını gerektirebilir. Asıl gösterge değeri sonuçta tekrar elde edilebildiği sürece böyle dönüşümler de $(C cast) ile gerçekleştirilir:
)

---
    size_t saklananGöstergeDeğeri = cast($(HILITE size_t))p;
    // ...
    int * p2 = cast($(HILITE int*))saklananGöstergeDeğeri;
---

$(H5 Özet)

$(UL
$(LI Otomatik tür dönüşümleri güvenli yönde yapılır: Küçük türden büyük türe doğru ve değişebilen türden değişmez türe doğru.)

$(LI Ancak, işaretsiz türlere doğru yapılan dönüşümler o türler eksi değerler tutamadıkları için şaşırtıcı sonuçlar doğurabilirler.)

$(LI $(C enum) türler tamsayı türlere otomatik olarak dönüşürler ama tamsayılar $(C enum) türlere otomatik olarak dönüşmezler.)

$(LI $(C false) 0'a, $(C true) da 1'e otomatik olarak dönüşür. Benzer biçimde, sıfır değerler $(C false)'a, sıfır olmayan değerler de $(C true)'ya otomatik olarak dönüşür.)

$(LI $(C null) referanslar otomatik olarak $(C false) değerine, $(C null) olmayan referanslar da $(C true) değerine dönüşürler.)

$(LI Bazı tür dönüşümleri için kurma söz dizimi kullanılabilir.)

$(LI Açıkça yapılan çoğu dönüşüm için $(C to()) kullanılır.)

$(LI Kopyalamadan $(C immutable)'a dönüştürmek için $(C assumeUnique()) kullanılır.)

$(LI $(C cast) en alt düzey ve en güçlü dönüşüm işlecidir.)

)

Macros:
        SUBTITLE=Tür Dönüşümleri

        DESCRIPTION=D dilinde otomatik ve elle açıkça yapılan tür dönüşümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial tür dönüşümleri

SOZLER=
$(acikca_elle_yapilan)
$(degismez)
$(derleyici)
$(dinamik)
$(gecici)
$(hazir_deger)
$(isaretli_tur)
$(isaretsiz_tur)
$(mikro_islemci)
$(otomatik)
$(referans_turu)
$(sabit)
$(soz_dizimi)
$(statik)
$(tanimsiz_davranis)
$(tur_donusumu)
