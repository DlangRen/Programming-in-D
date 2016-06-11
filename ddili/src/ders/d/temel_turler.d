Ddoc

$(DERS_BOLUMU $(IX tür) $(IX tip) $(IX temel tür) Temel Türler)

$(P
Bir bilgisayarın beyninin $(I mikro işlemci) olduğunu gördük. Bir programdaki işlemlerin çoğunu mikro işlemci yapar. Kendi yapmadığı işleri de bilgisayarın yan birimlerine devreder.
)

$(P
Bilgisayarlarda en küçük bilgi miktarı, 0 veya 1 değerini tutabilen ve $(I bit) adı verilen yapıdır.
)

$(P
Yalnızca 0 ve 1 değerini tutabilen bir veri türünün kullanımı çok kısıtlı olduğu için, mikro işlemciler birden fazla bitin yan yana getirilmesinden oluşan daha kullanışlı veri türleri tanımlamışlardır: örneğin 8 bitten oluşan $(I bayt) veya 32, 64, vs. bitten oluşan daha büyük veri türleri... Eğer türlerden N bitlik olanı bir mikro işlemcinin en etkin olarak kullandığı tür ise, o mikro işlemcinin $(I N bitlik) olduğu söylenir: "32 bitlik işlemci", "64 bitlik işlemci", gibi...
)

$(P
Mikro işlemcinin tanımladığı veri türleri de kendi başlarına yeterli değillerdir; çünkü örneğin $(I öğrenci ismi) gibi veya $(I oyun kağıdı) gibi özel bilgileri tutamazlar. Mikro işlemcinin sunduğu bu genel amaçlı veri türlerini daha kullanışlı türlere çevirmek programlama dillerinin görevidir. D'nin temel türleri bile tek başlarına kullanıldıklarında $(I oyun kağıdı) gibi bir kavramı destekleyemezler. O tür kavramlar ileride anlatılacak olan $(I yapılarla) ve $(I sınıflarla) ifade edilirler.
)

$(P
D'nin temel türleri çoğunlukla diğer dillerdeki temel türlere benzerler. Ek olarak, D'de belki de ancak bilimsel hesaplarda işe yarayan bazı ek türler de bulunur.
)

$(P
$(IX bool)
$(IX byte)
$(IX ubyte)
$(IX short)
$(IX ushort)
$(IX int)
$(IX uint)
$(IX long)
$(IX ulong)
$(IX float)
$(IX double)
$(IX real)
$(IX ifloat)
$(IX idouble)
$(IX ireal)
$(IX cfloat)
$(IX cdouble)
$(IX creal)
$(IX char)
$(IX wchar)
$(IX dchar)
Tabloda kullanılan terimlerin açıklamalarını aşağıda bulacaksınız.
)

	<table class="full" border="1" cellpadding="4" cellspacing="0"><caption>D'nin Temel Veri Türleri</caption>
	<tr><th scope="col">Tür</th> <th scope="col">Açıklama</th> <th scope="col">İlk Değeri</th>

	</tr>
	<tr>		<td>bool</td>

		<td>Bool değeri</td>
		<td>false</td>
	</tr>
	<tr>		<td>byte</td>
		<td>işaretli 8 bit</td>
		<td>0</td>

	</tr>
	<tr>		<td>ubyte</td>
		<td>işaretsiz 8 bit</td>
		<td>0</td>
	</tr>
	<tr>		<td>short</td>

		<td>işaretli 16 bit</td>
		<td>0</td>
	</tr>
	<tr>		<td>ushort</td>
		<td>işaretsiz 16 bit</td>
		<td>0</td>

	</tr>
	<tr>		<td>int</td>
		<td>işaretli 32 bit</td>
		<td>0</td>
	</tr>
	<tr>		<td>uint</td>

		<td>işaretsiz 32 bit</td>
		<td>0</td>
	</tr>
	<tr>		<td>long</td>
		<td>işaretli 64 bit</td>
		<td>0L</td>

	</tr>
	<tr>		<td>ulong</td>
		<td>işaretsiz 64 bit</td>
		<td>0L</td>
	</tr>
	<tr>		<td>float</td>
		<td>32 bit kayan noktalı sayı</td>
		<td>float.nan</td>
	</tr>
	<tr>		<td>double</td>

		<td>64 bit kayan noktalı sayı</td>
		<td>double.nan</td>
	</tr>
	<tr>		<td>real</td>
		<td>ya donanımın (mikro işlemcinin) tanımladığı en büyük kayan noktalı sayı türüdür (örneğin, x86 mikro işlemcilerinde 80 bit), ya da double'dır; hangisi daha büyükse...</td>

		<td>real.nan</td>
	</tr>
	<tr>		<td>ifloat</td>
		<td>sanal float değer</td>
		<td>float.nan * 1.0i</td>
	</tr>

	<tr>		<td>idouble</td>
		<td>sanal double değer</td>
		<td>double.nan * 1.0i</td>
	</tr>
	<tr>		<td>ireal</td>
		<td>sanal real değer</td>

		<td>real.nan * 1.0i</td>
	</tr>
	<tr>		<td>cfloat</td>
		<td>iki float'tan oluşan karmaşık sayı</td>
		<td>float.nan + float.nan * 1.0i</td>
	</tr>

	<tr>		<td>cdouble</td>
		<td>iki double'dan oluşan karmaşık sayı</td>
		<td>double.nan + double.nan * 1.0i</td>
	</tr>
	<tr>		<td>creal</td>
		<td>iki real'den oluşan karmaşık sayı</td>

		<td>real.nan + real.nan * 1.0i</td>
	</tr>
	<tr>		<td>char</td>
		<td>UTF-8 kod birimi</td>
		<td>0xFF</td>
	</tr>

	<tr>		<td>wchar</td>
		<td>UTF-16 kod birimi</td>
		<td>0xFFFF</td>
	</tr>
	<tr>		<td>dchar</td>
		<td>UTF-32 kod birimi ve Unicode kod noktası</td>

		<td>0x0000FFFF</td>
	</tr>
	</table>

$(P
Bunlara ek olarak $(I hiçbir türden olmama) kavramını ifade eden $(C void) anahtar sözcüğü de vardır. $(C cent) ve $(C ucent) anahtar sözcükleri, işaretli ve işaretsiz 128 bitlik veri türlerini temsil etmek üzere ilerisi için ayrılmışlardır.
)

$(P
Aksine bir neden bulunmadığı sürece genel bir kural olarak tam değerler için $(C int) kullanabilirsiniz. Kesirli değerleri olan kavramlar için de öncelikle $(C double) türü uygundur.
)

$(P Tablodaki terimlerin açıklamaları aşağıdaki gibidir:)

$(UL

$(LI
$(B Bool değer:) Mantıksal ifadelerde kullanılan ve "doğruluk" durumunda $(C true), "doğru olmama" durumunda $(C false) değerini alan türdür
)

$(LI
$(B İşaretli tür:) Hem eksi hem artı değerler alabilen türdür; Örneğin -128'den 127'ye kadar değer alabilen $(C byte). İsimleri eksi $(I işaretinden) gelir.
)

$(LI
$(B İşaretsiz tür:) Yalnızca artı değerler alabilen türdür; Örneğin 0'dan 255'e kadar değer alabilen $(C ubyte). Bu türlerin başındaki $(C u) harfi, "işaretsiz" anlamına gelen "unsigned"ın baş harfidir.
)

$(LI
$(B Kayan noktalı sayı:) Kabaca, 1.25 gibi kesirli değerleri tutabilen türdür; hesapların hassasiyeti türlerin bit sayısıyla doğru orantılıdır (yüksek bit sayısı yüksek hassasiyet sağlar); bunların dışındaki türler kesirli değerler alamazlar; örneğin $(C int), yalnızca tamsayı değerler alabilir
)

$(LI
$(B Karmaşık sayı:) Matematikte geçen karmaşık sayı değerlerini alabilen türdür
)

$(LI
$(B Sanal değer:) Karmaşık sayıların salt sanal değerlerini taşıyabilen türdür; tabloda İlk Değer sütununda geçen $(C i), matematikte -1'in kare kökü olan sayıdır
)

$(LI
$(IX .nan) $(B nan:) "Not a number"ın kısaltmasıdır ve $(I geçersiz kesirli sayı değeri) anlamına gelir
)

)

$(H5 Tür nitelikleri)

$(P D'de türlerin $(I nitelikleri) vardır. Niteliklere türün isminden sonra bir nokta ve nitelik ismiyle erişilir. Örneğin $(C int)'in $(C .sizeof) niteliğine $(C int.sizeof) diye erişilir. Tür niteliklerinin yalnızca bazılarını burada göreceğiz; gerisini sonraki bölümlere bırakacağız:
)

$(UL

$(LI $(IX .stringof) $(C .stringof) türün okunaklı ismidir)

$(LI $(IX .sizeof) $(C .sizeof) türün bayt olarak uzunluğudur; türün kaç bitten oluştuğunu hesaplamak için bu değeri bir bayttaki bit sayısı olan 8 ile çarpmak gerekir)

$(LI $(IX .min) $(C .min) "en az" anlamına gelen "minimum"un kısaltmasıdır; türün alabileceği en küçük değerdir)

$(LI $(IX .max) $(C .max) "en çok" anlamına gelen "maximum"un kısaltmasıdır; türün alabileceği en büyük değerdir)

$(LI $(IX .init) $(IX ilk değer) $(IX varsayılan değer, tür) $(C .init) "ilk değer" anlamına gelen "initial value"nun kısasıdır"; belirli bir tür için özel bir değer belirtilmediğinde kullanılan değer budur)

)

$(P
Bu nitelikleri $(C int) türü üzerinde gösteren bir program şöyle yazılabilir:
)

---
import std.stdio;

void main() {
    writeln("Tür                 : ", int.stringof);
    writeln("Bayt olarak uzunluğu: ", int.sizeof);
    writeln("En küçük değeri     : ", int.min);
    writeln("En büyük değeri     : ", int.max);
    writeln("İlk değeri          : ", int.init);
}
---

$(P
Programın çıktısı:
)

$(SHELL
Tür                 : int
Bayt olarak uzunluğu: 4
En küçük değeri     : -2147483648
En büyük değeri     : 2147483647
İlk değeri          : 0
)

$(H5 $(IX size_t) $(C size_t))

$(P
Programlarda $(C size_t) türü ile de karşılaşacaksınız. $(C size_t) bütünüyle farklı bir tür değildir; ortama bağlı olarak $(C ulong) veya başka bir işaretsiz temel türün takma ismidir. İsmi "size type"tan gelir ve "büyüklük türü" anlamındadır. $(I Adet) gibi saymayla ilgili olan kavramları temsil ederken kullanılır.
)

$(P
Asıl türünün sisteme göre farklı olmasının nedeni, $(C size_t)'nin programın kullanabileceği en büyük bellek miktarını tutabilecek kadar büyük bir tür olmasının gerekmesidir: 32 bitlik sistemlerde $(C uint) ve 64 bitlik sistemlerde $(C ulong). Bu yüzden, 32 bitlik sistemlerdeki en büyük tamsayı türü $(C size_t) değil, $(C ulong)'dur.
)

$(P
Bu türün sizin ortamınızda hangi temel türün takma ismi olduğunu yine $(C .stringof) niteliği ile öğrenebilirsiniz:
)

---
import std.stdio;

void main() {
    writeln(size_t.stringof);
}
---

$(P
Yukarıdaki programı denediğim ortamda şu çıktıyı alıyorum:
)

$(SHELL
ulong
)

$(PROBLEM_TEK

$(P
Diğer türlerin de niteliklerini yazdırın.
)

$(P
$(I Not: İlerisi için düşünüldükleri için geçersiz olan $(C cent) ve $(C ucent) türlerini hiçbir durumda kullanamazsınız. Bir istisna olarak, $(I hiçbir türden olmamayı) temsil eden $(C void) türünün ise $(C .min), $(C .max), ve $(C .init) nitelikleri yoktur.)
)

$(P
$(I Ek olarak, $(C .min) niteliği kesirli sayı türleriyle kullanılamaz. Eğer bu problemde bir kesirli sayı türünü $(C .min) niteliği ile kullanırsanız derleyici bir hata verecektir. Daha sonra $(LINK2 /ders/d/kesirli_sayilar.html, Kesirli Sayılar bölümünde) göreceğimiz gibi, kesirli sayı türlerinin en küçük değeri için $(C .max) niteliğinin eksi işaretlisini kullanmak gerekir (örneğin, $(C -double.max)).)
)

)


Macros:
        SUBTITLE=Temel Türler

        DESCRIPTION=D dilinin temel türleri

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial temel türler

SOZLER=
$(bayt)
$(bit)
$(emekliye_ayrılmıştır)
$(isaretli_tur)
$(isaretsiz_tur)
$(kayan_noktali)
$(mikro_islemci)
$(nitelik)
$(sanal_sayi)
$(sinif)
$(yapi)
