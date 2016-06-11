Ddoc

$(DERS_BOLUMU $(IX çıktı düzeni) $(IX düzen, çıktı) Çıktı Düzeni)

$(P
Diğer bölümlerden farklı olarak, bu bölüm D dilinin iç olanaklarından birisini değil, çıktı düzeni için kullanılan $(C std.format) modülünü anlatmaktadır.
)

$(P
$(IX std) $(IX Phobos) Adı $(C std) ile başlayan bütün modüller gibi $(C std.format) da D'nin standart kütüphanesi olan Phobos'un bir parçasıdır. Çok büyük bir kütüphane olan Phobos bu kitapta bütünüyle kapsanamamaktadır.
)

$(P
D'nin giriş ve çıkış için kullandığı düzen belirteçlerinin temelde C dilindekiler gibi olduğunu ama bazı farkları bulunduğunu göreceksiniz.
)

$(P
Bir $(I ön hatırlatma) olarak bütün düzen dizgisi karakterleri aşağıdaki tablodaki gibidir:
)

$(MONO
$(B Ayar Karakterleri) (birden fazla kullanılabilir)
     -     sola dayalı
     +     işaretli
     #     $(I diğer) şekilde
     0     solda 0'lı
  $(I boşluk)   solda boşluklu

$(B Düzen Karakterleri)
     s     belirteçsiz gibi
     b     ikili
     d     onlu
     o     sekizli
    x,X    on altılı
    f,F    kesirli
    e,E    on üzerili kesirli
    a,A    on altılı kesirli
    g,G    e veya f gibi

     (     eleman düzeni başı
     )     eleman düzeni sonu
     |     eleman ayracı
)

$(P
Şimdiye kadar çıktı için $(C writeln) gibi işlevleri gerektiğinde birden fazla parametreyle kullanmıştık. Bu parametreler otomatik olarak karakter eşdeğerlerine dönüştürülerek sırayla çıkışa gönderiliyorlardı.
)

$(P
Bazen bu yeterli değildir. Çıktının belirli bir düzene uyması gerekebilir. Örneğin bir faturanın maddelerini yazdıran şu koda bakalım:
)

---
    faturaMaddeleri ~= 1.23;
    faturaMaddeleri ~= 45.6;

    for (int i = 0; i != faturaMaddeleri.length; ++i) {
        writeln("Madde ", i + 1, ": ", faturaMaddeleri[i]);
    }
---

$(P
Çıktısı:
)

$(SHELL
Madde 1: 1.23
Madde 2: 45.6
)

$(P
Oysa faturadaki değerlerin belirli bir düzende, örneğin her zaman için virgülden sonra iki haneyle ve geniş bir alanda sağa dayalı olarak yazılmaları okuma açısından önemli olabilir. ($(I Not: Ben bu bölümde günlük kullanıma uygun olarak "virgül" diyeceğim; ama kesirli sayılarda virgül yerine nokta karakteri kullanılır.)):
)

$(SHELL
Madde 1:     1.23
Madde 2:    45.60
)

$(P
İşte çıktı düzeni, böyle konularda yarar sağlar. Şimdiye kadar kullandığımız çıktı işlevlerinin isminde $(C f) harfi geçen karşılıkları da vardır: $(C writef()) ve $(C writefln()). İsimlerindeki $(C f) harfi "düzen, biçim" anlamına gelen "format"ın kısaltmasıdır. Bu işlevlerin ilk parametresi diğer parametrelerin nasıl yazdırılacaklarını belirleyen $(I düzen dizgisidir).
)

$(P
Örneğin, $(C writefln) yukarıdaki çıktıyı aşağıdaki gibi bir düzen dizgisi ile üretebilir:
)

---
    writefln("Madde %d:%9.02f", i + 1, faturaMaddeleri[i]);
---

$(P
Düzen dizgisi, normal karakterlerden ve özel düzen belirteçlerinden oluşur. Her düzen belirteci $(C %) karakteriyle başlar ve bir $(I düzen karakteri) ile biter. Yukarıdaki dizgide iki tane düzen belirteci var: $(C %d) ve $(C %9.02f).
)

$(P
Her belirteç, düzen dizgisinden sonra verilen parametrelerle sıra ile eşleşir. Örneğin $(C %d) ile $(C i&nbsp;+&nbsp;1), ve $(C %9.02f) ile $(C faturaMaddeleri[i])... Her belirteç, eşleştiği parametrenin çıktı düzenini belirler. (Düzen belirteçlerinde parametre numaraları da kullanılabilir. Bunu aşağıda göstereceğim.)
)

$(P
Düzen dizgisi içinde bulunan ve belirteçlere ait olmayan karakterler, oldukları gibi yazdırılırlar. Yukarıdaki dizgi içindeki $(I normal) karakterleri işaretli olarak şöyle gösterebiliriz: $(C "$(HILITE Madde&nbsp;)%d$(HILITE :)%9.02f").
)

$(P
Düzen belirteci, çoğunun belirtilmesi gerekmeyen altı parçadan oluşur. Bu bölümlerden birisi olan $(I numara)'yı daha aşağıda göstereceğim. Diğer beş bölüm şunlardır ($(I Not: okumayı kolaylaştırmak için aralarında boşluk kullanıyorum; bu bölümler aslında bitişik olarak yazılırlar)):
)

$(MONO
    %  $(I$(C ayar_karakterleri  genişlik  duyarlık  düzen_karakteri))
)

$(P
Baştaki $(C %) karakterinin ve sondaki düzen karakterinin yazılması şarttır, diğerleri ise isteğe bağlıdır.
)

$(P
% karakterinin böyle özel bir anlamı olduğu için, çıktıda % karakterinin kendisi yazdırılmak istendiğinde $(C %%) şeklinde çift olarak yazılır.
)

$(H5 $(I düzen_karakteri))

$(P $(IX %b) $(C b): Tamsayı, ikili sayı düzeninde yazdırılır.
)

$(P $(IX %o, çıkış) $(C o): Tamsayı, sekizli sayı düzeninde yazdırılır.
)

$(P $(IX %x, çıkış) $(IX %X) $(C x) ve $(C X): Tamsayı, on altılı sayı düzeninde yazdırılır; $(C x) için küçük harfler, $(C X) için büyük harfler kullanılır.
)

$(P $(IX %d, çıkış) $(C d): Tamsayı, onlu sistemde yazdırılır; eğer işaretli bir türse ve değeri sıfırdan küçükse, başına eksi işareti gelir; aksi durumda işaretsiz bir tür gibi yazdırılır.
)

---
    int değer = 12;

    writefln("İkili    : %b", değer);
    writefln("Sekizli  : %o", değer);
    writefln("On altılı: %x", değer);
    writefln("Ondalık  : %d", değer);
---

$(SHELL
İkili    : 1100
Sekizli  : 14
On altılı: c
Ondalık  : 12
)

$(P $(IX %e) $(C e): Kesirli sayı, aşağıdaki bölümlerden oluşacak şekilde yazdırılır.
)

$(UL
$(LI virgülden önce tek hane)
$(LI $(I duyarlık) 0 değilse virgül)
$(LI virgülden sonra $(I duyarlık) adet hane (varsayılan duyarlık 6'dır))
$(LI $(C e) karakteri ("10 üzeri" anlamında))
$(LI üs sıfırdan küçükse $(C -), değilse $(C +) karakteri)
$(LI en az iki hane olarak üs değeri)
)

$(P $(IX %E) $(C E): $(C e) ile aynı düzende, ama çıktıda $(C E) harfiyle
)

$(P $(IX %f, çıkış) $(IX %F) $(C f) ve $(C F): Kesirli sayı, onlu sistemde yazdırılır; virgülden önce en az bir hane bulunur; varsayılan duyarlık 6'dır.
)

$(P $(IX %g) $(C g): Kesirli sayı, eğer üs değeri -5 ile $(I duyarlık) arasında olacaksa, $(C f) gibi; değilse $(C e) gibi yazdırılır. $(I duyarlık) virgülden sonrasını değil, belirgin hane sayısını belirtir; virgülden sonra belirgin hane yoksa virgül de yazdırılmaz; virgülden sonra en sağdaki sıfırlar yazdırılmazlar.
)

$(P $(IX %G) $(C G): $(C g) ile aynı düzende, ama $(C E) veya $(C F) kullanılmış gibi yazdırılır
)

$(P $(IX %a) $(C a): Kesirli sayı, on altılı sistemde ve aşağıdaki bölümlerden oluşacak şekilde yazdırılır:
)

$(UL
$(LI $(C 0x) karakterleri)
$(LI tek on altılı hane)
$(LI $(I duyarlık) 0 değilse virgül)
$(LI virgülden sonra $(I duyarlık) adet hane, veya $(I duyarlık) belirtilmemişse gerektiği kadar hane)
$(LI $(C p) karakteri ("2 üzeri" anlamında))
$(LI üssün değerine göre $(C -) veya $(C +) karakteri)
$(LI en az bir hane olarak üs değeri; (0 değerinin üs değeri 0'dır))
)

$(P $(IX %A) $(C A): $(C a) ile aynı düzende, ama çıktıda $(C 0X) ve $(C P) karakterleriyle
)

---
    double değer = 123.456789;

    writefln("e ile: %e", değer);
    writefln("f ile: %f", değer);
    writefln("g ile: %g", değer);
    writefln("a ile: %a", değer);
---

$(SHELL
e ile: 1.234568e+02
f ile: 123.456789
g ile: 123.457
a ile: 0x1.edd3c07ee0b0bp+6
)

$(P $(IX %s, çıkış) $(C s): Parametrenin değeri; düzen dizgisi kullanılmadığı zamandaki gibi, türüne uygun olan şekilde yazdırılır:
)

$(UL

$(LI $(C bool) türler $(C true) veya $(C false) olarak
)
$(LI tamsayılar $(C %d) gibi
)
$(LI kesirli sayılar $(C %g) gibi
)
$(LI dizgiler UTF-8 kodlamasıyla; $(I duyarlık), en fazla kaç bayt kullanılacağını belirler (UTF-8 kodlamasında karakter sayısıyla bayt sayısının eşit olmayabileceklerini hatırlayın; örneğin "ağ" dizgisi toplam 3 bayt uzunluğunda 2 karakterden oluşur)
)
$(LI yapı ve sınıf nesneleri, türün $(C toString()) üye işlevinin ürettiği dizgi olarak; $(I duyarlık), en fazla kaç bayt kullanılacağını belirler
)
$(LI diziler, elemanları yan yana sıralanarak
)

)

---
    bool b = true;
    int i = 365;
    double d = 9.87;
    string s = "düzenli";
    auto n = File("deneme_dosyasi", "r");
    int[] dz = [ 2, 4, 6, 8 ];

    writefln("bool  : %s", b);
    writefln("int   : %s", i);
    writefln("double: %s", d);
    writefln("string: %s", s);
    writefln("nesne : %s", n);
    writefln("dizi  : %s", dz);
---

$(SHELL
bool  : true
int   : 365
double: 9.87
string: düzenli
nesne : File(55738FA0)
dizi  : [2, 4, 6, 8]
)

$(H5 $(IX genişlik, çıktı) $(I genişlik))

$(P
$(IX *, çıktı düzeni) Değer için çıktıda ayrılan alanın genişliğini belirler. Eğer genişlik olarak $(C *) kullanılmışsa, genişlik değeri bir sonraki parametrenin değeri olarak alınır. Eğer eksi bir sayıysa, $(C -) ayar karakteri kullanılmış gibi çalışır.
)

---
    int değer = 100;

    writefln("On karakterlik alanda :%10s", değer);
    writefln("Beş karakterlik alanda:%5s", değer);
---

$(SHELL
On karakterlik alanda :       100
Beş karakterlik alanda:  100
)

$(H5 $(IX duyarlık, çıktı) $(I duyarlık))

$(P
Eğer belirtilmişse, nokta karakterinden sonra yazılır. Kesirli sayı türünden olan değerlerin çıktıda kullanılacak olan duyarlığını belirler. Eğer duyarlık olarak $(C *) kullanılmışsa, duyarlık değeri bir sonraki parametrenin değeri olarak alınır (o değer $(C int) olmak zorundadır). Duyarlık eksi bir sayıysa gözardı edilir.
)

---
    double kesirli = 1234.56789;

    writefln("%.8g", kesirli);
    writefln("%.3g", kesirli);
    writefln("%.8f", kesirli);
    writefln("%.3f", kesirli);
---

$(SHELL
1234.5679
1.23e+03
1234.56789000
1234.568
)

---
    auto sayı = 0.123456789;
    writefln("Sayı: %.*g", 4, sayı);
---

$(SHELL
Sayı: 0.1235
)

$(H5 $(IX ayar karakteri, çıktı) $(I ayar_karakterleri))

$(P
Birden fazla ayar karakteri kullanabilirsiniz.
)

$(P $(C -): parametre değeri; kendisine ayrılan alanda sola dayalı olarak yazdırılır; bu ayar, $(C 0) ayar karakterini geçersiz kılar
)

---
    int değer = 123;

    writefln("normalde sağa dayalı:|%10d|", değer);
    writefln("sola dayalı         :|%-10d|", değer);
---

$(SHELL
normalde sağa dayalı:|       123|
sola dayalı         :|123       |
)

$(P $(C +): değer artı ise başına $(C +) karakteri yazdırılır; bu ayar, $(I boşluk) ayar karakterini geçersiz kılar
)

---
    writefln("eksi değerde etkili değil: %+d", -50);
    writefln("artı değer, + ile        : %+d", 50);
    writefln("artı değer, + olmadan    : %d", 50);
---

$(SHELL
eksi değerde etkili değil: -50
artı değer, + ile        : +50
artı değer, + olmadan    : 50
)

$(P $(C #): kullanılan $(I düzen_karakteri)'ne bağlı olarak, değeri $(I başka şekilde) yazdırır
)

$(UL
$(LI $(C o) için: sekizli sayının ilk karakteri her zaman için 0 olarak yazdırılır)
$(LI $(C x) ve $(C X) için: sayı sıfır değilse, başına $(C 0x) veya $(C 0X) gelir)
$(LI kesirli sayılarda: virgülden sonra hane olmasa da virgül yazdırılır)
$(LI $(C g) ve $(C G) için: virgülden sonra sağdaki sıfırlar atılmaz)
)

---
    writefln("Sekizli sıfırla başlar        : %#o", 1000);
    writefln("On altılının başına 0x gelir  : %#x", 1000);

    writefln("Gerekmese de virgüllü olur    : %#g", 1f);
    writefln("Sağdaki sıfırlar da yazdırılır: %#g", 1.2);
---

$(SHELL
Sekizli sıfırla başlar        : 01750
On altılının başına 0x gelir  : 0x3e8
Gerekmese de virgüllü olur    : 1.00000
Sağdaki sıfırlar da yazdırılır: 1.20000
)

$(P $(C 0): sayılarda (değer $(C nan) veya $(C infinity) değilse), sol tarafa değer için ayrılan alan dolacak kadar 0 yazdırılır; $(I duyarlık) da belirtilmişse bu ayar etkisizdir
)

---
    writefln("Sekiz genişlikte: %08d", 42);
---

$(SHELL
Sekiz genişlikte: 00000042
)

$(P $(I boşluk) karakteri: değer artı ise, eksi değerlerle alt alta düzgün dursun diye başına tek bir boşluk karakteri yazdırılır)

---
    writefln("Eksi değerde etkisi yok: % d", -34);
    writefln("Artı değer, boşluklu   : % d", 56);
    writefln("Artı değer, boşluksuz  : %d", 56);
---

$(SHELL
Eksi değerde etkisi yok: -34
Artı değer, boşluklu   :  56
Artı değer, boşluksuz  : 56
)

$(H5 $(IX %1$) $(IX parametre numaraları, çıktı) $(IX numaralı parametre, çıktı) $(IX $, çıktı düzeni) Parametre numaraları)

$(P
Yukarıda düzen dizgisi içindeki düzen belirteçlerinin parametrelerle teker teker ve sırayla eşleştirildiklerini gördük. Aslında düzen belirtecinde parametre numarası da kullanılabilir. Bu, belirtecin hangi parametre ile ilgili olduğunu belirler. Parametreler 1'den başlayarak artan sırada numaralanırlar. Parametre numarası $(C %) karakterinden hemen sonra ve $(C $) karakteri ile birlikte yazılır:
)

$(MONO
    %  $(I$(C $(HILITE numara$)  ayar_karakterleri  genişlik  duyarlık  düzen_karakteri))
)

$(P
Bunun bir yararı, aynı parametrenin birden fazla yerde yazdırılabilmesidir:
)

---
    writefln("%1$d %1$x %1$o %1$b", 42);
---

$(P
Yukarıdaki düzen dizgisi 1 numaralı parametreyi dört düzen belirteci yoluyla onlu, on altılı, sekizli, ve ikili sayı sistemlerinde yazdırmaktadır:
)

$(SHELL
42 2a 52 101010
)

$(P
Parametre numaralarının bir diğer kullanım alanı, aynı parametrelerin farklı düzen dizgileriyle kullanılabilmesi ve bu sayede mesajların farklı konuşma dillerinin yazım kurallarına uydurulabilmesidir. Örneğin belirli bir dersteki öğrenci sayısı Türkçe olarak şöyle bildiriliyor olsun:
)

---
    writefln("%s sınıfında %s öğrenci var.", sınıf, adet);
---

$(SHELL
1A sınıfında 20 öğrenci var.
)

$(P
Programın örneğin İngilizce'yi de desteklemesi gerektiğini düşünelim. Bu durumda düzen dizgisinin dile uygun olarak daha önceden seçilmiş olması gerekir. Aşağıdaki yöntem bu iş için üçlü işleçten yararlanıyor:
)

---
    auto düzenDizgisi = (dil == "tr"
                         ? "%s sınıfında %s öğrenci var."
                         : "There are %s students in room %s.");

    writefln(düzenDizgisi, sınıf, adet);
---

$(P
Ne yazık ki, parametreler düzen belirteçleriyle birer birer eşleştirildiklerinde sınıf ve adet bilgileri İngilizce mesajda ters sırada çıkarlar. Sınıf bilgisi adet yerinde, adet bilgisi de sınıf yerindedir:
)

$(SHELL
There are 1A students in room 20. $(SHELL_NOTE_WRONG Yanlış: Adet 1A, sınıf 20!)
)

$(P
Bunun önüne geçmek için düzen dizgisinde hangi belirtecin hangi parametreye karşılık geldiği $(C 1$) ve $(C 2$) biçiminde parametre numaralarıyla belirtilebilir:
)

---
    auto düzenDizgisi = (dil == "tr"
                         ? "%1$s sınıfında %2$s öğrenci var."
                         : "There are %2$s students in room %1$s.");

    writefln(düzenDizgisi, sınıf, adet);
---

$(P
Artık mesajın hem Türkçesi hem de İngilizcesi düzgündür:
)

$(SHELL
1A sınıfında 20 öğrenci var.
)

$(SHELL
There are 20 students in room 1A.
)

$(H5 $(IX %$(PARANTEZ_AC)) $(IX %$(PARANTEZ_KAPA)) Eleman düzeni)

$(P
$(STRING %$(PARANTEZ_AC)) ve $(STRING %$(PARANTEZ_KAPA)) arasındaki düzen belirteçleri bir topluluktaki (veya aralıktaki) elemanlara teker teker uygulanır:
)

---
    auto sayılar = [ 1, 2, 3, 4 ];
    writefln("%(%s%)", sayılar);
---

$(P
Yukarıdaki düzen dizgisi üç parçadan oluşuyor:
)

$(UL
$(LI $(STRING %$(PARANTEZ_AC)): Eleman düzeni başı)
$(LI $(STRING %s): Her elemanın düzeni)
$(LI $(STRING %$(PARANTEZ_KAPA)): Eleman düzeni sonu)
)

$(P
Her birisine $(STRING %s) düzeni uygulandığında bütün elemanlar çıktıda art arda belirirler:
)

$(SHELL
1234
)

$(P
Eleman düzeninin başı ile sonu arasındaki $(I normal) karakterler her eleman için tekrarlanırlar. Örneğin, $(STRING {%s},) belirteci her elemanın küme parantezleri arasında ve virgüllerle ayrılarak yazdırılmasını sağlar:
)

---
    writefln("%({%s},%)", sayılar);
---

$(P
Ancak, düzen belirtecinin sağındaki $(I normal) karakterlerin ayraç oldukları kabul edilir ve onlar normalde yalnızca elemanlar arasına yazdırılırlar. Bu yüzden, yukarıdaki örnekteki $(C },) karakterleri sonuncu elemandan sonra yazdırılmazlar:
)

$(SHELL
{1},{2},{3},{4  $(SHELL_NOTE '}' ve ',' karakterleri son eleman için yazdırılmamış)
)

$(P
$(IX %|) Sağdaki karakterlerin hangilerinin ayraç oldukları ve hangilerinin sonuncu elemandan sonra da yazdırılmalarının gerektiği $(STRING %|) ile belirtilir. Bu belirtecin solundaki karakterler sonuncu eleman için de yazdırılırlar, sağındaki karakterler ise yazdırılmazlar. Örneğin, aşağıdaki düzen dizgisi $(C }) karakterini sonuncu elemandan sonra da yazdırır ama $(C ,) karakterini yazdırmaz:
)
---
    writefln("%({%s}%|,%)", sayılar);
---

$(SHELL
{1},{2},{3},{4}  $(SHELL_NOTE '}' karakteri son eleman için de yazdırılmış)
)

$(P
Tek başlarına yazdırılan dizgilerden farklı olarak, eleman olarak yazdırılan dizgiler normalde çift tırnaklar arasında yazdırılırlar:
)

---
    auto sebzeler = [ "ıspanak", "kuşkonmaz", "enginar" ];
    writefln("%(%s, %)", sebzeler);
---

$(SHELL
"ıspanak", "kuşkonmaz", "enginar"
)

$(P
$(IX %-$(PARANTEZ_AC)) Bunun istenmediği durumlarda eleman düzeni $(STRING %$(PARANTEZ_AC)) ile değil, $(STRING %-$(PARANTEZ_AC)) ile başlatılır:
)

---
    writefln("%-(%s, %)", sebzeler);
---

$(SHELL
ıspanak, kuşkonmaz, enginar
)

$(P
Aynısı karakterler için de geçerlidir. $(STRING %$(PARANTEZ_AC)) kullanıldığında karakterler tek tırnak içinde yazdırılır:
)

---
    writefln("%(%s%)", "merhaba");
---

$(SHELL
'm''e''r''h''a''b''a'
)

$(P
$(STRING %-$(PARANTEZ_AC)) kullanıldığında ise tırnaksız olarak yazdırılır:
)

---
    writefln("%-(%s%)", "merhaba");
---

$(SHELL
merhaba
)

$(P
Eşleme tablolarında eleman düzeninde iki belirteç kullanılmalıdır: Birincisi anahtarı, ikincisi de değeri temsil eder. Örneğin, aşağıdaki $(STRING %s&nbsp;(%s)) belirteci önce anahtarın parantezsiz olarak, sonra da değerin parantez içinde yazdırılmasını sağlar:
)

---
    auto yazıyla = [ 1 : "bir", 10 : "on", 100 : "yüz" ];
    writefln("%-(%s (%s)%|, %)", yazıyla);
---

$(P
$(STRING %|) belirtecinin sağında belirtilen virgülün son eleman için yazdırılmadığına da dikkat edin:
)

$(SHELL
1 (bir), 100 (yüz), 10 (on)
)

$(H5 $(IX format, std.string) $(C format))

$(P
Yukarıda anlatılan bütün olanaklar $(C std.string) modülünün $(C format) işlevi için de geçerlidir. $(C format) aynı $(C writef) gibi işler ama oluşturduğu bilgiyi çıkışa yazdırmak yerine bir dizgi olarak döndürür:
)

---
import std.stdio;
import std.string;

void main() {
    write("Adınız ne? ");
    auto isim = strip(readln());

    auto sonuç = $(HILITE format)("Merhaba %s!", isim);
}
---

$(P
Böylece, oluşturulan dizgi daha sonraki ifadelerde kullanılabilir.
)

$(PROBLEM_COK

$(PROBLEM
Girilen tamsayıyı on altılı düzende yazdıran bir program yazın.
)

$(PROBLEM
Girilen kesirli sayıyı bir $(I yüzde) değeri olarak ve virgülden sonra 2 haneyle yazdıran bir program yazın. Örneğin 1.2345 girildiğinde ekrana yalnızca $(C %1.23) yazsın.
)

)

Macros:
        SUBTITLE=Çıktı Düzeni

        DESCRIPTION=Phobos'un std.format modülünün çıktı düzeni için nasıl kullanıldığı

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial çıktı düzen format

SOZLER=
$(duzen)
$(ic_olanak)
$(isaretli_tur)
$(isaretsiz_tur)
$(islev)
$(parametre)
$(parametre_degeri)
$(phobos)
