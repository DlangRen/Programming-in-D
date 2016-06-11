Ddoc

$(DERS_BOLUMU $(IX koşullu derleme) Koşullu Derleme)

$(P
Programın bazı bölümlerinin belirli koşullara bağlı olarak farklı derlenmesi veya hiç derlenmemesi istenebilir. D'nin koşullu derleme olanakları bu konuda kullanılır.
)

$(P
Bu koşullar yalnızca derleme zamanında değerlendirilirler; programın çalışması sırasında etkileri yoktur. Çalışma zamanında etkili olan $(C if), $(C for), $(C while) gibi D olanakları koşullu derleme olanakları değildir.
)

$(P
Aslında önceki bölümlerde koşullu derleme olarak kabul edilebilecek olanaklarla karşılaşmıştık:
)

$(UL

$(LI Birim testi bloklarındaki kodlar yalnızca $(C -unittest) derleyici seçeneği kullanıldığında derlenir ve çalıştırılır.
)

$(LI Sözleşmeli programlama olanakları olan $(C in), $(C out), ve $(C invariant) blokları $(C -release) seçeneği kullanılmadığı zaman etkindir.
)

)

$(P
Yukarıdakiler programın doğruluğunu arttırma amacına yönelik yardımcı olanaklar olarak görülebilir. Derleyici seçeneklerine bağlı olarak kullanılıp kullanılmamaları, programın asıl davranışını zaten değiştirmemelidir.
)

$(UL

$(LI Şablon özellemeleri yalnızca belirtilen türler için etkilidir. O türler programda kullanılmadığında, özelleme kodu derlenmez ve programa dahil edilmez:

---
void değişTokuş(T)(ref T birinci, ref T ikinci) {
    T geçici = birinci;
    birinci = ikinci;
    ikinci = geçici;
}

unittest {
    auto bir = 'ğ';
    auto iki = 'ş';
    değişTokuş(bir, iki);

    assert(bir == 'ş');
    assert(iki == 'ğ');
}

void değişTokuş(T $(HILITE : uint))(ref T birinci, ref T ikinci) {
    birinci ^= ikinci;
    ikinci ^= birinci;
    birinci ^= ikinc;  // DİKKAT: sondaki i harfi unutulmuş!
}

void main() {
}
---

$(P
Yukarıdaki işlev şablonunun $(C uint) özellemesi, daha hızlı olacağı düşünüldüğü için $(C ^) bit işlecinden ($(I ya da) işleci) yararlanıyor. ($(I Not: Tam tersine, çoğu modern işlemcide bu yöntem geçici değişken kullanan yöntemden daha yavaştır.))
)

$(P
Sonundaki yazım hatasına rağmen yukarıdaki program derlenir ve çalışır. Bunun nedeni, $(C değişTokuş) işlevinin programda hiç $(C uint) türü için çağrılmamış olması ve bu yüzden $(C uint) özellemesinin hiç derlenmemiş olmasıdır.
)

$(P
O programdaki hata, işlev $(C uint) türü ile çağrılana kadar ortaya çıkmaz. Bunu, birim testlerinin önemini gösteren bir başka örnek olarak da görebilirsiniz. Birim testi de yazılmış olsa, o özellemedeki hata işlev yazıldığı sırada ortaya çıkar:
)

---
unittest {
    $(HILITE uint) i = 42;
    $(HILITE uint) j = 7;
    değişTokuş(i, j);

    assert(i == 7);
    assert(j == 42);
}
---

$(P
Görüldüğü gibi, şablon özellemelerinin de koşullu olarak derlendiklerini kabul edebiliriz.
)

)

)

$(P
D'nin koşullu derlemeyi destekleyen ve bütünüyle bu amaç için tasarlanmış olan başka olanakları da vardır:
)

$(UL
$(LI $(C debug))
$(LI $(C version))
$(LI $(C static if))
$(LI $(C is) ifadesi)
$(LI $(C __traits))
)

$(P
$(C is) ifadesini bir sonraki bölümde göreceğiz.
)

$(H5 $(IX debug) debug)

$(P
$(IX -debug, derleyici seçeneği) Program geliştirme aşamasında yararlı olan bir olanak $(C debug) belirtecidir. Bu belirteçle işaretlenmiş olan ifadeler ve deyimler yalnızca derleyiciye $(C -debug) seçeneği verildiğinde etkilidir:
)

---
debug $(I koşullu_derlenen_bir_ifade);

debug {
    // ... koşullu derlenen ifadeler ve deyimler ...

} else {
    // ... diğer durumda derlenen ifadeler ve deyimler ...
}
---

$(P
$(C else) bloğu isteğe bağlıdır.
)

$(P
Yukarıdaki tek ifade de blok içindeki ifadeler de ancak $(C -debug) derleyici seçeneği etkin olduğunda derlenir.
)

$(P
Şimdiye kadarki programların hemen hemen hepsinde programın nasıl işlediğini gösteren ve çıkışa "ekliyorum", "çıkartıyorum" gibi mesajlar yazdıran satırlar kullandık. Algoritmaların işleyişlerini böylece görsel hale getiriyor ve olası hatalarını bulabiliyorduk. "debug", $(I hata gidermek) anlamına gelir ve bu konuda yararlıdır.
)

$(P
Bunun bir örneği olarak $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) gördüğümüz $(C ikiliAra) işlevine bakalım. O algoritmanın açıklama satırlarını çıkartıyorum ve bilerek hatalı olarak yazıyorum:
)

---
import std.stdio;

// DİKKAT! Bu algoritma hatalıdır
size_t ikiliAra(const int[] değerler, in int değer) {
    if (değerler.length == 0) {
        return size_t.max;
    }

    immutable ortaNokta = değerler.length / 2;

    if (değer == değerler[ortaNokta]) {
        return ortaNokta;

    } else if (değer < değerler[ortaNokta]) {
        return ikiliAra(değerler[0 .. ortaNokta], değer);

    } else {
        return ikiliAra(değerler[ortaNokta + 1 .. $], değer);
    }
}

void main() {
    auto sayılar = [ -100, 0, 1, 2, 7, 10, 42, 365, 1000 ];

    auto indeks = ikiliAra(sayılar, 42);
    writeln("Konum: ", indeks);
}
---

$(P
Yukarıdaki program 42'nin aslında 6 olan konumunu yanlış bildirir:
)

$(SHELL_SMALL
Konum: 1    $(SHELL_NOTE_WRONG yanlış sonuç)
)

$(P
Bu hatayı bulmanın bir yolu, işlevin önemli noktalarına işlemler hakkında bilgiler veren satırlar eklemektir:
)

---
size_t ikiliAra(const int[] değerler, in int değer) {
    $(HILITE writeln)(değerler, " içinde ", değer, " arıyorum");

    if (değerler.length == 0) {
        $(HILITE writeln)(değer, " bulunamadı");
        return size_t.max;
    }

    immutable ortaNokta = değerler.length / 2;

    $(HILITE writeln)("bakılan konum: ", ortaNokta);

    if (değer == değerler[ortaNokta]) {
        $(HILITE writeln)(değer, ", ", ortaNokta, " konumunda bulundu");
        return ortaNokta;

    } else if (değer < değerler[ortaNokta]) {
        $(HILITE writeln)("ilk yarıda olması gerek");
        return ikiliAra(değerler[0 .. ortaNokta], değer);

    } else {
        $(HILITE writeln)("son yarıda olması gerek");
        return ikiliAra(değerler[ortaNokta + 1 .. $], değer);
    }
}
---

$(P
Programın şimdiki çıktısı algoritmanın işleyiş adımlarını da gösterir:
)

$(SHELL_SMALL
[-100,0,1,2,7,10,42,365,1000] içinde 42 arıyorum
bakılan konum: 4
son yarıda olması gerek
[10,42,365,1000] içinde 42 arıyorum
bakılan konum: 2
ilk yarıda olması gerek
[10,42] içinde 42 arıyorum
bakılan konum: 1
42, 1 konumunda bulundu
Konum: 1
)

$(P
Hatanın bu çıktıdan yararlanılarak bulunduğunu ve giderildiğini varsayalım. Hata giderildikten sonra artık $(C writefln) satırlarına gerek kalmaz, üstelik silinmeleri gerekir. Buna rağmen, o satırları silmek de bir israf olarak görülebilir çünkü belki de ileride tekrar gerekebilirler.
)

$(P
Onun yerine, bu satırların başına $(C debug) anahtar sözcüğü yazılabilir:
)

---
        $(HILITE debug) writeln(değer, " bulunamadı");
---

$(P
O satırlar artık yalnızca $(C -debug) derleyici seçeneği kullanıldığında etkin olacaktır:
)

$(SHELL_SMALL
dmd deneme.d -ofdeneme -w $(HILITE -debug)
)

$(P
Böylece programın normal işleyişi sırasında çıktıya hiçbir bilgi yazdırılmayacak, bir hata görüldüğünde ise $(C -debug) kullanılarak algoritmanın işleyişi hakkında bilgi alınabilecektir.
)

$(H6 $(C debug($(I isim))))

$(P
$(C debug) belirtecinin çok yerde kullanılması durumunda programın çıktısı çok kalabalıklaşabilir. Böyle durumlarda $(C debug) belirteçlerine isimler verebilir ve onların yalnızca komut satırında belirtilenlerinin etkinleşmelerini sağlayabiliriz:
)

---
        $(HILITE debug(ikili_arama)) writeln(değer, " bulunamadı");
---

$(P
İsimli $(C debug) belirteçlerini etkinleştirmek için komut satırında $(C -debug=$(I isim)) yazılır:
)

$(SHELL_SMALL
dmd deneme.d -ofdeneme -w $(HILITE -debug=ikili_arama)
)

$(P
İsimli $(C debug) belirteçleri de birden fazla ifade için kullanılabilir:
)

---
    debug(ikili_arama) {
        // ... koşullu derlenen ifadeler ve deyimler ...
    }
---

$(P
Aynı anda birden çok isimli $(C debug) belirteci de belirtilebilir:
)

$(SHELL_SMALL
$ dmd deneme.d -ofdeneme -w $(HILITE -debug=ikili_arama) $(HILITE -debug=yigin_yapisi)
)

$(P
O durumda hem $(C ikili_arama), hem de $(C yigin_yapisi) isimli $(C debug) blokları etkin olur.
)

$(H6 $(C debug($(I düzey))))

$(P
Bazen $(C debug) belirteçlerine isimler vermek yerine, hata ayıklama düzeylerini belirleyen sayısal değerler verilebilir. Örneğin, artan her düzey daha derinlemesine bilgi elde etmek için yararlı olabilir:
)

---
$(HILITE debug) import std.stdio;

void birİşlev(string dosyaİsmi, int[] sayılar) {
    $(HILITE debug(1)) writeln("birİşlev işlevine girildi");

    $(HILITE debug(2)) {
        writeln("işlev parametreleri: ");
        writeln("  isim: ", dosyaİsmi);

        foreach (i, sayı; sayılar) {
            writefln("  %4s: %s", i, sayı);
        }
    }

    // ... asıl işlemler ...
}
---

$(P
Derleyiciye bildirilen $(C debug) düzeyi, o düzey ve daha düşük olanlarının etkinleşmesini sağlar:
)

$(SHELL_SMALL
$ dmd deneme.d -ofdeneme -w $(HILITE -debug=1)
$ ./deneme 
$(DARK_GRAY birİşlev işlevine girildi)
)

$(P
Daha derinlemesine bilgi almak istendiğinde:
)

$(SHELL_SMALL
$ dmd deneme.d -ofdeneme -w $(HILITE -debug=2)
$ ./deneme 
$(DARK_GRAY birİşlev işlevine girildi
işlev parametreleri: 
  isim: deneme.txt
     0: 10
     1: 4
     2: 100)
)

$(H5 $(IX version) $(C version($(I isim))), ve $(C version($(I düzey))))

$(P
$(C version), $(C debug) olanağına çok benzer ve kod içinde aynı biçimde kullanılır:
)

---
    version(denemeSürümü) /* ... bir ifade ... */;

    version(okulSürümü) {
        // ... okullara satılan sürümle ilgili ifadeler ...

    } else {
        // ... başka sürümlerle ilgili ifadeler ...
    }

    version(1) birDeğişken = 5;

    version(2) {
        // ... sürüm 2 ile ilgili bir olanak ...
    }
---

$(P
Bütünüyle aynı biçimde çalışıyor olsa da, $(C debug)'dan farkı, programın farklı sürümlerini oluşturma amacıyla kullanılmasıdır.
)

$(P
$(IX -version, derleyici seçeneği) Yine $(C debug)'da olduğu gibi, aynı anda birden fazla $(C version) bloğu etkinleştirilebilir:
)

$(SHELL_SMALL
$ dmd deneme.d -ofdeneme -w $(HILITE -version=kayit) $(HILITE -version=hassas_hesap)
)

$(P
Bazı $(C version) isimleri hazır olarak tanımlıdır. Tam listesini $(LINK2 http://dlang.org/version.html, Conditional Compilation sayfasında) bulacağınız bu isimleri aşağıdaki tabloda özetliyorum:
)

<table class="full" border="1" cellpadding="4" cellspacing="0"><caption>Öntanımlı $(C version) belirteçleri</caption>

<tr><td>Derleyici</td> <td>$(B DigitalMars GNU LDC SDC)</td></tr>

<tr><td>İşletim sistemi</td> <td>$(B Windows Win32 Win64 linux OSX Posix FreeBSD
OpenBSD
NetBSD
DragonFlyBSD
BSD
Solaris
AIX
Haiku
SkyOS
SysV3
SysV4
Hurd)</td></tr>

<tr><td>Mikro işlemci sonculluğu</td><td>$(B LittleEndian BigEndian)</td></tr>
<tr><td>Derleyici seçenekleri</td> <td> $(B D_Coverage D_Ddoc D_InlineAsm_X86 D_InlineAsm_X86_64 D_LP64 D_PIC D_X32
D_HardFloat
D_SoftFloat
D_SIMD
D_Version2
D_NoBoundsChecks
unittest
assert
)</td></tr>

<tr><td>Mikro işlemci mimarisi</td> <td>$(B X86 X86_64)</td></tr>
<tr><td>Platform</td> <td>$(B Android
Cygwin
MinGW
ARM
ARM_Thumb
ARM_Soft
ARM_SoftFP
ARM_HardFP
ARM64
PPC
PPC_SoftFP
PPC_HardFP
PPC64
IA64
MIPS
MIPS32
MIPS64
MIPS_O32
MIPS_N32
MIPS_O64
MIPS_N64
MIPS_EABI
MIPS_NoFloat
MIPS_SoftFloat
MIPS_HardFloat
SPARC
SPARC_V8Plus
SPARC_SoftFP
SPARC_HardFP
SPARC64
S390
S390X
HPPA
HPPA64
SH
SH64
Alpha
Alpha_SoftFP
Alpha_HardFP
)</td></tr>
<tr><td>...</td> <td>...</td></tr>
</table>

$(P
İki tane de özel $(C version) ismi vardır:
)

$(UL
$(LI $(IX none, version) $(C none): Bu isim hiçbir zaman tanımlı değildir; kod bloklarını etkisizleştirmek için kullanılabilir.)
$(LI $(IX all, version) $(C all): Bu isim her zaman tanımlıdır; $(C none)'ın tersi olarak kullanılır.)
)

$(P
O tanımlardan yararlanarak programınızın farklı olanaklarla derlenmesini sağlayabilirsiniz. Kullanım örneği olarak $(C std.ascii) modülünde tanımlı olan $(C newline)'a bakalım. $(I Satır sonu) anlamına gelen kodları belirleyen $(C newline) dizisi, üzerinde derlenmekte olduğu işletim sistemine göre farklı kodlardan oluşmaktadır:
)

---
version(Windows) {
    immutable newline = "\r\n";

} else version(Posix) {
    immutable newline = "\n";

} else {
    static assert(0, "Unsupported OS");
}
---

$(H5 $(C debug)'a ve $(C version)'a isim atamak)

$(P
$(C debug) ve $(C version)'a sanki değişkenmişler gibi isim atanabilir. Değişkenlerden farklı olarak, atama işlemi değer değiştirmez, değer olarak belirtilen $(C debug) veya $(C version) ismini $(I de) etkinleştirir.
)

---
import std.stdio;

debug(hepsi) {
    debug $(HILITE =) ikili_arama;
    debug $(HILITE =) yigin_yapisi;
    version $(HILITE =) denemeSürümü;
    version $(HILITE =) okulSürümü;
}

void main() {
    debug(ikili_arama) writeln("ikili_arama etkin");
    debug(yigin_yapisi) writeln("yigin_yapisi etkin");

    version(denemeSürümü) writeln("deneme sürümü");
    version(okulSürümü) writeln("okul sürümü");
}
---

$(P
Yukarıdaki koddaki $(C debug(hepsi)) bloğu içindeki atamalar o isimlerin de etkinleşmelerini sağlar. Böylece bu program için derleme satırında dört $(C debug) ve $(C version) seçeneği ayrı ayrı seçilebileceği gibi, $(C -debug=hepsi) kullanıldığında; $(C ikili_arama), $(C yigin_yapisi), $(C denemeSürümü), ve $(C okulSürümü) sanki komut satırında bildirilmişler gibi etkinleşirler:
)

$(SHELL_SMALL
$ dmd deneme.d -ofdeneme -w -debug=hepsi
$ ./deneme 
$(DARK_GRAY ikili_arama etkin
yigin_yapisi etkin
deneme sürümü
okul sürümü)
)

$(H5 $(IX static if) $(C static if))

$(P
Programın çalışması sırasındaki kararlarda çok kullandığımız $(C if) koşulunun derleme zamanındaki eşdeğeri $(C static if)'tir.
)

$(P
$(C if) koşulunda olduğu gibi, $(C static if) koşulu da bir mantıksal ifade ile kullanılır. $(C static if) bloğundaki kodlar bu mantıksal ifade $(C true) olduğunda derlenir ve programa dahil edilir, $(C false) olduğunda ise o kodlar sanki hiç yazılmamışlar gibi etkisizleşirler. Yine $(C if)'e benzer şekilde, $(C else static if) ve $(C else) blokları da bulunabilir.
)

$(P
Derleme zamanında işletildiğinden, mantıksal ifadenin sonucunun derleme zamanında biliniyor olması şarttır.
)

$(P
$(C static if) her kapsamda kullanılabilir: Modül dosyasında en üst düzeyde veya yapı, sınıf, şablon, işlev, vs. kapsamlarında. Koşul sağlandığında blok içindeki kodlar yazıldıkları satırlarda programa dahil edilirler.
)

$(P
$(C static if) şablon tanımlarında, $(C is) ifadesi ile birlikte, ve $(C __traits) olanağı ile çok kullanılır.
)

$(P
$(C static if)'in $(C is) ifadesi ile birlikte kullanım örneklerini bir sonraki bölümde göreceğiz. Burada çok basit bir şablon tanımında kullanalım:
)

---
import std.stdio;

struct VeriYapısı(T) {
    static if (is (T == $(HILITE float))) {
        alias SonuçTürü = $(HILITE double);

    } else static if (is (T == $(HILITE double))) {
        alias SonuçTürü = $(HILITE real);

    } else {
        static assert(false, T.stringof ~ " desteklenmiyor");
    }

    SonuçTürü işlem() {
        writefln("%s için sonuç türü olarak %s kullanıyorum.",
                 T.stringof, SonuçTürü.stringof);
        SonuçTürü sonuç;
        // ...
        return sonuç;
    }
}

void main() {
    auto f = VeriYapısı!float();
    f.işlem();

    auto d = VeriYapısı!double();
    d.işlem();
}
---

$(P
$(C VeriYapısı) yalnızca $(C float) ve $(C double) türleriyle kullanılabilen bir tür. İşlem sonucunu hep bir adım daha hassas olan türde gerçekleştirmek için $(C float) ile kullanıldığında $(C double), $(C double) ile kullanıldığında ise $(C real) seçiyor:
)

$(SHELL
float için sonuç türü olarak double kullanıyorum.
double için sonuç türü olarak real kullanıyorum.
)

$(P
$(C static if) zincirleri oluştururken $(C else static if) yazmak gerektiğine dikkat edin. Yanlışlıkla $(C else if) yazıldığında, $(C static if)'in $(C else) bloğu olarak $(C if) kullanılacak demektir ve $(C if) de doğal olarak çalışma zamanında işletilecektir.
)

$(H5 $(IX static assert) $(C static assert))

$(P
Aslında bir koşullu derleme olanağı olarak kabul edilmese de bu olanağı $(C static if)'e benzerliği nedeniyle burada tanıtmaya karar verdim.
)

$(P
Çalışma zamanında kullanmaya alıştığımız $(C assert)'le aynı biçimde ama derleme zamanında işletilir. Mantıksal ifadesi $(C false) olduğunda derlemenin bir hata ile sonlandırılmasını sağlar.
)

$(P
$(C static if) gibi $(C static assert) de programda herhangi bir kapsamda bulunabilir.
)

$(P
$(C static assert) kullanımının bir örneğini yukarıdaki programda gördük: $(C float) veya $(C double) türlerinden başka bir tür belirtildiğinde derleme $(C static assert(false)) nedeniyle sonlanır:
)

---
    auto i = VeriYapısı!$(HILITE int)();
---

$(P
Derleme hatası:
)

$(SHELL
Error: static assert  "int desteklenmiyor"
)

$(P
Başka bir örnek olarak belirli bir algoritmanın yalnızca belirli büyüklükteki türlerle doğru olarak çalışabildiğini varsayalım. Bu koşulu bir $(C static assert) ile denetleyebiliriz:
)

---
T birAlgoritma(T)(T değer) {
    // Bu algoritma ancak büyüklüğü dördün katı olan türlerle
    // çalışabilir
    static assert((T.sizeof % 4) == 0);

    // ...
}
---

$(P
O işlev şablonu örneğin $(C char) ile çağrıldığında programın derlenmesi bir hata ile sonlanır:
)

$(SHELL_SMALL
Error: static assert  (1LU == 0LU) is false
)

$(P
Böylece algoritmanın uygunsuz bir türle kullanılmasının ve olasılıkla hatalı çalışmasının önüne geçilmektedir.
)

$(P
$(C static assert) de $(C is) ifadesi dahil olmak üzere derleme zamanında oluşturulabilen her mantıksal ifade ile kullanılabilir.
)

$(H5 $(IX tür niteliği) $(IX nitelik, tür) Tür nitelikleri)

$(P
$(IX __traits) $(IX std.traits) $(C __traits) anahtar sözcüğü ve $(C std.traits) modülü türlerin nitelikleriyle ilgili bilgileri derleme zamanında edinmeye yarar.
)

$(P
$(C __traits), derleyicinin koddan edinmiş olduğu bilgileri sorgulamaya yarar. Söz dizimi aşağıdaki gibidir:
)

---
    __traits($(I sözcük), $(I parametreler))
---

$(P
$(I sözcük), $(C __traits)'in hangi amaçla kullanıldığını belirtir. $(I parametreler) ise bir veya daha fazla sayıda olmak üzere tür ismi veya ifadedir. Parametrelerin anlamları kullanılan sözcüğe bağlıdır.
)

$(P
$(C __traits)'in sunduğu bilgiler dilin başka olanakları tarafından edinilemeyen ve çoğunlukla derleyicinin toplamış olduğu bilgilerdir. Bu bilgiler özellikle şablon kodlarında ve koşullu derleme sırasında yararlıdır.
)

$(P
Örneğin, "aritmetik mi" anlamına gelen $(C isArithmetic), $(C T) gibi bir şablon parametresinin aritmetik bir tür olup olmamasına göre farklı kod üretmek için kullanılabilir:
)

---
    static if (__traits($(HILITE isArithmetic), T)) {
        // ... aritmetik bir türmüş ...

    } else {
        // ... değilmiş ...
    }
---

$(P
$(C std.traits) modülü de tür nitelikleriyle ilgili bilgileri şablon olanakları olarak yine derleme zamanında sunar. Örneğin, $(C std.traits.isSomeChar), kendisine verilen şablon parametresi bir karakter türü olduğunda $(C true) üretir:
)

---
import std.traits;

// ...

    static if ($(HILITE isSomeChar)!T) {
        // ... herhangi bir karakter türüymüş ...

    } else {
        // ... bir karakter türü değilmiş ...
    }
---

$(P
Daha fazla bilgi için $(LINK2 http://dlang.org/traits.html, $(C __traits) belgesine) ve $(LINK2 http://dlang.org/phobos/std_traits.html, $(C std.traits) belgesine) başvurabilirsiniz.
)

$(H5 Özet)

$(UL

$(LI
$(C debug) olarak tanımlanmış olan kodlar yalnızca $(C -debug) derleyici seçeneği etkin olduğunda programa dahil edilirler.
)

$(LI
$(C version) ile tanımlanmış olan kodlar programın $(C -version) derleme seçeneği ile belirlenen sürümüne dahil olurlar.
)

$(LI
$(C static if) derleme zamanında işleyen $(C if) deyimi gibidir; kodların derleme zamanındaki koşullara göre programa dahil edilmesini sağlar.
)

$(LI
$(C static assert) programla ilgili varsayımları derleme zamanında denetler.
)

$(LI $(C __traits) ve $(C std.traits) türler hakkında derleme sırasında bilgi edinmeye yarar.)

)

Macros:
        SUBTITLE=Koşullu Derleme

        DESCRIPTION=Kaynak kodun hangi bölümlerinin programa dahil edileceğinin derleme sırasında belirlenmesi

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial koşullu derleme debug version static if static assert

SOZLER=
$(bayt_sirasi)
$(cokuzlu)
$(gosterge)
$(hata_ayiklama)
$(indeks)
$(statik)
$(surum)
