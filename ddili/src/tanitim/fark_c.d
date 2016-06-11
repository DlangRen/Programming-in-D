Ddoc

$(H4 D'nin C ile Karşılaştırılması)

$(ESKI_KARSILASTIRMA)

$(P
Bu bölüm, C programcılarına yönelik olarak D dilinin C'den olan bazı farklılıklarını gösteriyor. Nesne yönelimli programlama konusundaki farklarını ise $(LINK2 /tanitim/fark_cpp.html, C++ karşılaştırmasında) okuyabilirsiniz.
)

$(P
Bu sayfadaki bilgiler $(LINK2 http://www.dlang.org/ctod.html, Digital Mars'ın sitesindeki aslından) alınmıştır.
)

$(UL_FARK
$(FARK_INDEX sizeof, Tür büyüklükleri)
$(FARK_INDEX minmax, Türlerin en küçük ve en büyük değerleri)
$(FARK_INDEX temel, Temel türler)
$(FARK_INDEX ozel, Özel kesirli sayı değerleri)
$(FARK_INDEX kalan, Kesirli sayı bölümünden kalan)
$(FARK_INDEX nan, Kesirli sayı karşılaştırmalarında NAN)
$(FARK_INDEX assert, Güvenli kodlamanın vazgeçilmez parçası $(CODE assert))
$(FARK_INDEX eleman_ilk, Dizi elemanlarını ilklemek)
$(FARK_INDEX dizi_ziyaret, Dizi elemanlarını sırayla ziyaret etmek)
$(FARK_INDEX dinamik_dizi, Değişken uzunlukta diziler)
$(FARK_INDEX dizgi_birlestir, Dizgileri birleştirmek)
$(FARK_INDEX format, Formatlı çıktı)
$(FARK_INDEX bildirim, Fonksiyonları önceden bildirmek)
$(FARK_INDEX void, Parametre almayan fonksiyonlar)
$(FARK_INDEX etiket, Etiket kullanan $(CODE break) ve $(CODE continue) deyimleri)
$(FARK_INDEX goto, $(CODE goto) deyimi)
$(FARK_INDEX typedef, $(CODE typedef struct))
$(FARK_INDEX dizgi_arama, Dizgi aramak)
$(FARK_INDEX alignment, Yapı üyelerinin bellek yerleşimleri [alignment])
$(FARK_INDEX isimsiz, İsimsiz $(CODE struct)'lar ve $(CODE union)'lar)
$(FARK_INDEX yapi_degisken, Yapıyı ve değişkeni bir arada tanımlamak)
$(FARK_INDEX offset, Yapı üyesinin başlangıçtan uzaklığı [offset])
$(FARK_INDEX birlik_ilk, Birlik ilkleme)
$(FARK_INDEX yapi_ilk, Yapı ilkleme)
$(FARK_INDEX dizi_ilk, Dizi ilkleme)
$(FARK_INDEX ozel_karakter, Dizgi sabitlerinde özel karakterler)
$(FARK_INDEX ascii, ASCII ve evrensel karakterler)
$(FARK_INDEX enum_dizgi, $(CODE enum)'ların dizgi karşılıkları)
$(FARK_INDEX typedef_yeni, $(CODE typedef)'le yeni tür oluşturmak)
$(FARK_INDEX yapi_esitlik, Yapılarda eşitlik karşılaştırması)
$(FARK_INDEX dizgi_esitlik, Dizgilerde eşitlik karşılaştırması)
$(FARK_INDEX dizi_sirala, Dizi sıralamak)
$(FARK_INDEX volatile, $(CODE volatile) bellek erişimi)
$(FARK_INDEX sabit_dizgi, Sabit dizgiler)
$(FARK_INDEX veri_yapisi_ziyaret, Veri yapılarını ziyaret etmek)
$(FARK_INDEX saga_kaydirma, İşaretsiz sayılarda sağa kaydırma)
$(FARK_INDEX kapama, Dinamik kapamalar [closures])
$(FARK_INDEX belirsiz_parametre, Belirsiz sayıda fonksiyon parametreleri)
)

$(FARK sizeof, Tür büyüklükleri)

$(FARK_C
sizeof(int)
sizeof(char *)
sizeof(double)
sizeof(struct Foo)
)

$(FARK_D
---
int.sizeof
(char *).sizeof
double.sizeof
Foo.sizeof
---
)


$(FARK minmax, Türlerin en küçük ve en büyük değerleri)

$(FARK_C
#include &lt;limits.h&gt;
#include &lt;math.h&gt;

CHAR_MAX
CHAR_MIN
ULONG_MAX
DBL_MIN
)

$(FARK_D
---
char.max
char.min
ulong.max
double.min
---
)


$(FARK temel, Temel türler)

$(H6 C'den D'ye)

$(C_CODE

                  bool  =>   bit 
                  char  =>   char 
           signed char  =>   byte 
         unsigned char  =>  ubyte 
                 short  =>   short 
        unsigned short  =>  ushort 
               wchar_t  =>  wchar 
                   int  =>   int 
              unsigned  =>  uint 
                  long  =>   int 
         unsigned long  =>  uint 
             long long  =>   long 
    unsigned long long  =>  ulong 
                 float  =>   float 
                double  =>   double 
           long double  =>   real 
_Imaginary long double  =>  ireal
  _Complex long double  =>  creal
)

$(P
$(CODE char) işaretsiz [unsigned] 8 bittir, $(CODE wchar) ise işaretsiz 16 bittir. İşaretli ve işaretsiz türler C'de değişik boyutta olabilirler, D'de aynıdırlar.)


$(FARK ozel, Özel kesirli sayı değerleri)

$(FARK_C
#include &lt;fp.h&gt; 

NAN 
INFINITY 

#include &lt;float.h&gt; 

DBL_DIG 
DBL_EPSILON 
DBL_MANT_DIG 
DBL_MAX_10_EXP 
DBL_MAX_EXP 
DBL_MIN_10_EXP 
DBL_MIN_EXP 
)

$(FARK_D
---
double.nan 
double.infinity 
double.dig 
double.epsilon 
double.mant_dig 
double.max_10_exp 
double.max_exp 
double.min_10_exp 
double.min_exp 
---
)


$(FARK kalan, Kesirli sayı bölümünden kalan)

$(FARK_C
#include &lt;math.h&gt; 

float f = fmodf(x,y); 
double d = fmod(x,y); 
long double r = fmodl(x,y); 
)

$(FARK_D
---
float f = x % y; 
double d = x % y; 
real r = x % y; 
---
)


$(FARK nan, Kesirli sayı karşılaştırmalarında NAN)

$(P
$(I Not A Number)'ın kısaltması olan $(CODE NAN), bir kesirli sayının bit gösterimi düzeyinde geçersiz olduğu anlamına gelir. C, $(CODE NAN) geçersiz değerinin sayı karşılaştırmalarında yer almasının nasıl bir sonuç vereceğini belirlemez.
)

$(FARK_C
#include &lt;math.h&gt; 

if (isnan(x) || isnan(y)) 
   sonuc = FALSE; 
else 
   sonuc = (x < y); 
)

$(FARK_D
---
sonuç = (x < y);        // x veya y 'nan' olduğunda 'false'tur
---
)


$(FARK assert, Güvenli kodlamanın vazgeçilmez parçası $(CODE assert))

$(P
C'de $(CODE assert) dilin parçası değildir ama $(CODE __FILE__) ve $(CODE __LINE__) makroları aracılığıyla kullanışlı bilgi verir. D'de ise $(CODE assert) dilin parçasıdır.
)

$(FARK_C
#include &lt;assert.h&gt; 

assert(e == 0); 
)

$(FARK_D
---
assert(e == 0); 
---
)


$(FARK eleman_ilk, Dizi elemanlarını ilklemek)

$(FARK_C
#define DIZI_UZUNLUGU        17 
int dizi[DIZI_UZUNLUGU]; 
for (i = 0; i < DIZI_UZUNLUGU; i++) 
   dizi[i] = deger; 
)

$(FARK_D
---
int dizi[17]; 
dizi[] = değer;
---
)


$(FARK dizi_ziyaret, Dizi elemanlarını sırayla ziyaret etmek)

$(P
C'de diziler kendi uzunluklarını bilmedikleri için uzunluk ya ayrı olarak tanımlanır, ya da $(CODE sizeof) işlecinden yararlanılır. D'de ise dizilerin uzunlukları dizinin bir niteliğidir [property].
)

$(FARK_C
#define DIZI_UZUNLUGU        17 
int dizi[DIZI_UZUNLUGU]; 
for (i = 0; i < DIZI_UZUNLUGU; i++) 
   fonksiyon(dizi[i]); 
)

$(P
veya
)

$(C_CODE
int dizi[17]; 
for (i = 0; i < sizeof(dizi) / sizeof(dizi[0]); i++) 
   fonksiyon(dizi[i]);
)

$(FARK_D
---
int dizi[17]; 
for (i = 0; i < dizi.length; i++) 
   fonksiyon(dizi[i]); 
---
)

$(P
veya daha da iyisi:
)

---
int dizi[17]; 
foreach (int değer; dizi)
   fonksiyon(değer); 
---


$(FARK dinamik_dizi, Değişken uzunlukta diziler)

$(P
C'de uzunluğu tutmak için ayrı bir değişken gerekir, ve dizinin uzunluğu değiştiğinde onun da değeri değiştirilir. D ise dinamik dizileri desteklediği için gereken bellek yönetimi de otomatik olarak halledilir.
)

$(FARK_C
#include &lt;stdlib.h&gt; 

int dizi_uzunlugu; 
int *dizi; 
int *yeni_dizi; 

yeni_dizi =
       (int *)realloc(dizi, (dizi_uzunlugu + 1) * sizeof(int));
if (!yeni_dizi) 
   error("bellek yetersiz"); 
dizi = yeni_dizi; 
dizi[dizi_uzunlugu++] = x; 
)

$(FARK_D
---
int[] dizi; 

dizi.length = dizi.length + 1;
dizi[dizi.length - 1] = x; 
---
)


$(FARK dizgi_birlestir, Dizgileri birleştirmek)

$(P
C'de bu konuda çok sorun vardır: belleğin ne zaman geri verileceği, NULL işaretçiler, dizgilerin uzunluklarını bulmak, ve genel olarak bellek yönetimi. D'de ise $(CODE char) ve $(CODE wchar) türleri için yüklenmiş olan $(CODE ~) işleci $(I birleştirmek), $(CODE ~=) işleci ise $(I sonuna eklemek) anlamına gelir.
)

$(FARK_C
#include &lt;string.h&gt; 

char *s1; 
char *s2; 
char *s; 

// s1 ve s2'yi ekle ve sonucu s'ye yerleştir
free(s); 
s = (char *)malloc((s1 ? strlen(s1) : 0) + 
                   (s2 ? strlen(s2) : 0) + 1); 
if (!s) 
   error("bellek yetersiz"); 
if (s1) 
   strcpy(s, s1); 
else 
   *s = 0; 
if (s2) 
   strcpy(s + strlen(s), s2); 

// s'ye "merhaba" dizgisini ekle
char merhaba[] = "merhaba"; 
char *yeni_s; 
size_t s_uzunluk = s ? strlen(s) : 0; 
yeni_s = (char *)realloc(s,
                         (s_uzunluk + sizeof(merhaba) + 1)
                                               * sizeof(char));
if (!yeni_s) 
   error("bellek yetersiz"); 
s = yeni_s; 
memcpy(s + s_uzunluk, merhaba, sizeof(merhaba)); 
)

$(FARK_D
---
char[] s1; 
char[] s2; 
char[] s; 

s = s1 ~ s2; 
s ~= "merhaba"; 
---
)


$(FARK format, Formatlı çıktı)

$(P
D'de $(CODE printf)'e ek olarak tür güvenliği getiren $(CODE writefln) vardır.
)

$(FARK_C
#include &lt;stdio.h&gt; 

printf("Arabaları %d kere çağırıyoruz!\n", kac_kere);
)

$(FARK_D
---
printf("Arabaları %d kere çağırıyoruz!\n", kaç_kere);
---

$(P
veya daha güvenli olarak
)
---
import std.stdio;

writefln("Arabaları %s kere çağırıyoruz!", kaç_kere);
---
)


$(FARK bildirim, Fonksiyonları önceden bildirmek)

$(P
C'de her fonksiyonun kullanılmadan önce bildirilmiş olması gerekir. D'de ise programa bir bütün olarak bakıldığı için, fonksiyon bildirimleri gereksiz olmalarının yanında yasal bile değillerdir. Hatalara elverişli bu külfetten kurtulmuş olarak fonksiyonları istediğimiz sırada yazabiliriz.
)

$(FARK_C
// bildirim
void ileride_tanimli_fonksiyon(); 

void fonksiyon() 
{   
   ileride_tanimli_fonksiyon(); 
} 

// tanim
void ileride_tanimli_fonksiyon() 
{   
   ... 
} 
)

$(FARK_D
---
void fonksiyon() 
{   
   ileride_tanımlı_fonksiyon(); 
} 

// tanım
void ileride_tanımlı_fonksiyon() 
{   
   ... 
} 
---
)


$(FARK void, Parametre almayan fonksiyonlar)

$(P
D'de bir fonksiyonun parametre almadığının açıkça belirtilmesine gerek yoktur; boş bırakılan parametre listesi zaten o anlama gelir.
)

$(FARK_C
void fonksiyon(void);
)

$(FARK_D
---
void fonksiyon()
{
   ...
}
---
)


$(FARK etiket, Etiket kullanan $(CODE break) ve $(CODE continue) deyimleri)

$(P
C'de $(CODE break) ve $(CODE continue) deyimleri en içteki döngüyü veya $(CODE switch)'i etkiler. En dıştaki döngüden de çıkmak istendiğinde $(CODE goto) kullanmak gerekir. D'de ise döngülere ve $(CODE switch)'lere de etiket verilebilir ve $(CODE break) ve $(CODE continue) deyimlerinde etiket belirtilerek istenen düzeydeki döngü veya $(CODE switch) belirtilebilir.
)

$(FARK_C
    for (i = 0; i < 10; i++) 
    {   
       for (j = 0; j < 10; j++) 
       {   
           if (j == 3) 
               goto Dis_Etiket; 
           if (j == 4) 
               goto Ic_Etiket; 
       } 
     Ic_Etiket: 
       ; 
    } 
Dis_Etiket: 
    ; 
)

$(FARK_D
---
Dış_Etiket: 
   for (i = 0; i < 10; i++) 
   {   
       for (j = 0; j < 10; j++) 
       {   
           if (j == 3) 
               break Dış_Etiket; 
           if (j == 4) 
               continue Dış_Etiket; 
       } 
   } 
   // 'break Dış_Etiket;' buraya getirir
---
)


$(FARK goto, $(CODE goto) deyimi)

$(P
$(CODE goto) deyimi C'de de önerilmez ama bazen mecbur kalınır. Her ne kadar D'de gerekmese de, istendiğinde kullanılabilsin diye $(CODE goto) D'de de vardır.
)



$(FARK typedef, $(CODE typedef struct))

$(P
Yapı tanımlarında $(CODE typedef) gerekmez.
)

$(FARK_C
typedef struct ABC { ... } ABC;
)

$(FARK_D
---
struct ABC { ... }
---
)


$(FARK dizgi_arama, Dizgi aramak)

$(P
Verilen bir dizgiyi bir dizgi listesinde aramak, oldukça yaygın bir işlemdir. Örneğin programın hangi komut satırı parametreleri ile çalıştırıldığını anlamak ve programın davranışını ona göre ayarlamak...
)

$(P
Bu işi C'de yapmak için birbirine denk üç veri yapısı kullanmak gerekir: $(CODE enum), dizgi tablosu, ve $(CODE switch) içindeki $(CODE case)'ler. Bu üçünü denk tutmak listedeki dizgi sayısı arttığında oldukça güçleşebilir ve hatalara açık durumlar doğurur. Dahası, bu bir sıralı arama algoritması olduğu için, büyük listelerde yavaş da kalabilir. Öyle olduğunda zaman da bir hızlı eşleme tablosu kurmak gerekebilir ve iş iyice karmaşıklaşır.
)

$(P
D ise $(CODE switch) deyimlerinde dizgilere izin vererek bu işlemi büyük ölçüde kolaylaştırır. Listeye yeni değerler eklemek son derece basit hale gelir ve gerektiği durumlarda daha hızlı algoritmalar kullanmak da derleyiciye bırakılmış olur.
)

$(FARK_C
#include &lt;string.h&gt; 
void islem_yap(char *s) 
{   
   enum Degerler { Merhaba, GuleGule, Belki, deger_adet }; 
   static char *tablo[] = { "merhaba", "güle güle", "belki" }; 
   int i; 

   for (i = 0; i < deger_adet; i++) 
   {   
       if (strcmp(s, tablo[i]) == 0) 
           break; 
   } 
   switch (i) 
   {   
       case Merhaba:   ... 
       case GuleGule: ... 
       case Belki:   ... 
       default:      ... 
   } 
}
)

$(FARK_D
---
void işlem_yap(char[] s) 
{   
   switch (s) 
   {   
       case "merhaba":   ... 
       case "güle güle": ... 
       case "belki":   ... 
       default:        ... 
   } 
} 
---
)


$(FARK alignment, Yapı üyelerinin bellek yerleşimleri [alignment])

$(P
C'de bunun bir yolu, istenen yerleşimi derleyici ayarlarıyla belirtmektir. Öyle yapınca, bütün yapılar etkilenmiş olurlar ve bütün kaynak dosyaların baştan derlenmeleri gerekir. Bu işi kolaylaştırmak için $(CODE #pragma)'lar kullanılır; ancak $(CODE #pragma)'lar maalesef derleyiciye bağlı ve taşınmaz olanaklardır. D'de bu konuda taşınabilir bir çözüm sunulmuştur.
)

$(FARK_C
#pragma pack(1) 
struct ABC 
{   
   ... 
}; 
#pragma pack() 
)

$(FARK_D
---
struct ABC 
{   
   int z;            // z varsayılan ayara göre yerleştirilecek

   align (1) int x;  // x byte sınırına yerleştirilecek
   align (4) 
   {   
     ...             // {} içinde tanımlanan üyeler dword
                     // sınırına yerleştirilecekler
   } 
   align (2):        // bu noktadan sonra word sınırına geçilir

   int y;            // y word sınırındadır
} 
---
)


$(FARK isimsiz, İsimsiz $(CODE struct)'lar ve $(CODE union)'lar)

$(P
Bazı durumlarda üyelerin yerleşimleri için yapılardan ve birliklerden [union] yararlanılır. C bunların isimsiz olarak tanımlanmalarına izin vermediği için kullanılmayacak isimler uydurmak gerekir. O isimlerden kurtulmak için de makrolardan yararlanılır. D ise bu yapıların isimsiz olarak tanımlanmalarına izin verir.
)

$(FARK_C
struct Foo 
{
   int i; 
   union Bar 
   {
      struct Abc { int x; long y; } _abc; 
      char *p; 
   } _bar; 
}; 

#define x _bar._abc.x 
#define y _bar._abc.y 
#define p _bar.p 

struct Foo f; 

f.i; 
f.x; 
f.y; 
f.p; 
)

$(FARK_D
---
struct Foo 
{
   int i; 
   union 
   {
      struct { int x; long y; } 
      char* p; 
   } 
} 

Foo f; 

f.i; 
f.x; 
f.y; 
f.p; 
---
)


$(FARK yapi_degisken, Yapıyı ve değişkeni bir arada tanımlamak)

$(P
D'de tür ve değişken aynı satırda tanımlanamaz.
)

$(FARK_C
struct Foo { int x; int y; } foo; 
)

$(P
veya iki satırda
)

$(C_CODE
struct Foo { int x; int y; };   // sonda ';' vardir
struct Foo foo; 
)

$(FARK_D
---
struct Foo { int x; int y; }    // sonda ';' yoktur
Foo foo;
---
)


$(FARK offset, Yapı üyesinin başlangıçtan uzaklığı [offset])

$(FARK_C
#include &lt;stddef.h&gt;
struct Foo { int x; int y; }; 

uzaklik = offsetof(Foo, y); 
)

$(FARK_D
---
struct Foo { int x; int y; } 

uzaklık = Foo.y.offsetof;
---
)


$(FARK birlik_ilk, Birlik ilkleme)

$(P
C'de birliğin $(I ilk üyesi) ilklenir. D'de ise hangi üyenin ilklendiğinin açıkça belirtilmesi gerekir.
)

$(FARK_C
union U { int a; long b; }; 
union U x = { 5 };                // 'a' 5'e esitlenir
)

$(FARK_D
---
union U { int a; long b; } 
U x = { a:5 };
---
)


$(FARK yapi_ilk, Yapı ilkleme)

$(P
C'de üyeler sırayla ilklenirler. Bu kural, küçük yapılarda fazla sorun çıkartmasa da yapı büyüdüğünde sorun haline gelebilir. Özellikle yeni üyelerin araya eklendiği durumlarda kod içinde daha önce yazılmış olan bütün ilkleme ifadelerinin bulunması ve değişiklikten sonra da doğru olarak ilklendiklerine dikkat edilmesi gerekir. D'de ise üyeler açıkça ilklenirler.
)

$(FARK_C
struct S { int a; int b; }; 
struct S x = { 5, 3 };
)

$(FARK_D
---
struct S { int a; int b; } 
S x = { b:3, a:5 };
---
)


$(FARK dizi_ilk, Dizi ilkleme)

$(P
C'de diziler değerlerin sırasına göre ilklenirler.
)

$(FARK_C
int a[3] = { 3,2,2 }; 
)

$(P
 İç diziler için $(CODE { }) parantezlerinin kullanımı isteğe bağlıdır.
)

$(C_CODE
int b[3][2] = { 2,3, {6,5}, 3,4 }; 
)

$(FARK_D

$(P
D'de ise hem sırayla ilklenebilirler, hem de hangi elemanın ilklendiği açıkça belirtilebilir. Şunların hepsi aynı sonucu verir:
)

---
int[3] a = [ 3, 2, 0 ]; 
int[3] a = [ 3, 2 ];          // C'de olduğu gibi, belirtilmeyen
                              // elemanların değeri 0'dır
int[3] a = [ 2:0, 0:3, 1:2 ]; 
int[3] a = [ 2:0, 0:3, 2 ];   // indeks belirtilmediğinde, bir
                              // önceki indeks değerinden devam
                              // edilir
---
)

$(P
Bu, özellikle dizi indekslerken $(CODE enum)'lar kullanıldığı durumlarda önemlidir.
)

---
enum renk { siyah, kırmızı, yeşil }
int[3] c = [ siyah:3, yeşil:2, kırmızı:5 ];
---

$(P
İç dizilerin ilklenmeleri de açıkça belirtilmek zorundadır:
)

---
int[2][3] b = [ [2,3], [6,5], [3,4] ]; 

int[2][3] b = [[2,6,3],[3,5,4]];            // hata 
---


$(FARK ozel_karakter, Dizgi sabitlerinde özel karakterler)

$(H6 C)

$(P
C'de $(CODE \) karakteri özel karakterleri belirlemek için kullanıldığı için, $(BR) $(CODE c:\klasor\dosya.c) gibi bir dosya ismi şöyle belirtilir:
)

$(C_CODE
char dosya[] = "c:\\klasor\\dosya.c";
)

$(P
Bu durum düzenli ifadeleri [regexp] daha da karmaşıklaştırır. Örneğin $(BR)$(CODE /"[^\\]*(\\.[^\\]*)*"/) ifadesi için:
)

$(C_CODE
char tirnak_icinde[] = "\"[^\\\\]*(\\\\.[^\\\\]*)*\"";
)

$(FARK_D

$(P
D'de ise dizgi içindeki karakterler olmaları gerektiği gibi yazılırlar; özel karakterler ayrı olarak...
)

---
char[] dosya = `c:\klasor\dosya.c`; 
char[] tırnak_içinde = r"[^\\]*(\\.[^\\]*)*";
---
)


$(FARK ascii, ASCII ve evrensel karakterler)

$(P
C'de $(CODE wchar_t) türü vardır ve sabit dizgilerin başında $(CODE L) karakteri kullanılır.
)

$(FARK_C
#include &lt;wchar.h&gt; 
char foo_ascii[] = "merhaba"; 
wchar_t foo_wchar[] = L"merhaba";
)

$(P
Ancak kodun hem ASCII hem de uluslararası karakterlere uyumlu olması istendiğinde makrolardan yararlanmak zorunda kalınır:
)

$(C_CODE
#include &lt;tchar.h&gt; 
tchar merhaba[] = TEXT("merhaba");
)

$(FARK_D

$(P
D'de ise ne tür dizgi kullanıldığı koddan anlaşılır.
)

---
char[] foo_ascii = "merhaba";   // ascii
wchar[] foo_wchar = "merhaba";  // wchar
---
)


$(FARK enum_dizgi, $(CODE enum)'ların dizgi karşılıkları)

$(FARK_C
enum RENKLER { kirmizi, mavi, yesil, deger_adet }; 
char *dizgiler[deger_adet] = {"kırmızı", "mavi", "yeşil" }; 
)

$(FARK_D
---
enum RENKLER { kırmızı, mavi, yeşil }

char[][RENKLER.max + 1] dizgiler = 
[
    RENKLER.kırmızı : "kırmızı",
    RENKLER.mavi    : "mavi", 
    RENKLER.yeşil   : "yeşil",
]; 
---
)


$(FARK typedef_yeni, $(CODE typedef)'le yeni tür oluşturmak)

$(H6 C)
$(P
C'de $(CODE typedef) yeni tür oluşturmaz; türe yeni bir isim verir.
)

$(C_CODE
typedef void *Cerez;
void foo(void *);
void bar(Cerez);

Cerez h;
foo(h);                        // farkedilmeyen kodlama hatasi
bar(h);                        // dogru kullanim
)

$(P
Böyle hatalardan kurtulmak için tür bir yapı içine alınır:
)

$(C_CODE
struct Cerez__ { void *deger; }
typedef struct Cerez__ *Cerez;
void foo(void *);
void bar(Cerez);

Cerez h;
foo(h);                        // simdi derleme hatasi
bar(h);                        // dogru kullanim
)

$(P
Tür için ilk değer atamak için makro tanımlamak, adlandırma yöntemleri geliştirmek, ve kodlamaya dikkat etmek gerekir:
)

$(C_CODE
#define CEREZ_ILK ((Cerez)-1)

Cerez h = CEREZ_ILK;
h = fonksiyon();
if (h != CEREZ_ILK)
    ...
)

$(P
Yapı kullanan çözüm daha da karmaşık hale gelir:
)

$(C_CODE
struct Cerez__ CEREZ_ILK;

void Cerez_ilk_degeri()        // bu fonksiyon en basta cagrilir
{
    CEREZ_ILK.value = (void *)-1;
}

Cerez h = CEREZ_ILK;
h = fonksiyon();
if (memcmp(&h,&CEREZ_ILK,sizeof(Cerez)) != 0)
    ...
)

$(FARK_D

$(P
$(CODE typedef) yeni tür oluşturduğu için C'deki gibi çözümler gerekmez.
)

---
typedef void* Cerez;
void foo(void*);
void bar(Cerez);

Cerez h;
foo(h);
bar(h);
---
)

$(P
İlklemek de çok daha basittir:
)

---
typedef void* Cerez = cast(void*)(-1);
Cerez h;
h = fonksiyon();
if (h != Cerez.init)
    ...
---


$(FARK yapi_esitlik, Yapılarda eşitlik karşılaştırması)

$(P
C'de yapı ataması çok basit olarak derleyici tarafından halledilir, ama eşitlik karşılaştırması için bir yardım gelmez. Bazen kullanılan $(CODE memcmp) ise her durumda çalışmayabilir, çünkü yapı üyeleri arasındaki olası doldurma bitlerinin [padding] hangi değerlerde olacakları standart tarafından tanımlanmamıştır. D'de ise karşılaştırma da atama kadar basittir.
)

$(FARK_C
#include &lt;string.h&gt;

struct A x, y;
...
x = y;
...
if (memcmp(&x, &y, sizeof(struct A)) == 0)
    ...
)

$(FARK_D
---
A x, y;
...
x = y;
...
if (x == y)
    ...
---
)


$(FARK dizgi_esitlik, Dizgilerde eşitlik karşılaştırması)

$(P
C'de dizgiler sonlarındaki $(CODE '\0') karakteri ile tanımlandıkları için, sonlandırma karakterini bulmayı gerektiren dizi işlemleri doğal olarak  yavaştır. D'de ise dizilerin (ve dolayısıyla dizgilerin) uzunlukları da bilindiği için eşitlik karşılaştırmaları çok daha hızlı bir şekilde gerçekleştirilebilir. D ayrıca sıralama karşılaştırmalarını da destekler.
)

$(FARK_C
char dizgi[] = "merhaba";

if (strcmp(dizgi, "selam") == 0)        // dizgiler esit mi?
    ...
)

$(FARK_D
---
char[] dizgi = "merhaba";

if (dizgi == "selam")
    ...

if (dizgi < "selam")
    ...
---
)


$(FARK dizi_sirala, Dizi sıralamak)

$(FARK_C
int karsilastir(const void *p1, const void *p2)
{
    tur *t1 = (tur *)p1;
    tur *t2 = (tur *)p2;

    return *t1 - *t2;
}

type dizi[10];
...
qsort(dizi, sizeof(dizi)/sizeof(dizi[0]),
        sizeof(dizi[0]), karsilastir);
)

$(FARK_D
---
type[] dizi;
...
dizi.sort;      // dizi olduğu yerde sıralanır
---
)


$(FARK volatile, $(CODE volatile) bellek erişimi)

$(P
Paylaşımlı bellek veya belleğe bağlı giriş/çıkış gibi işlemlerde karşılaşılan ve değeri derleyici farkında olmadan değişebilen bellek için $(CODE volatile) işaretçiler kulanılabilir. $(CODE volatile) D'de bir deyim türüdür ve deyimi etkiler.
)

$(FARK_C
volatile int *p = adres;

i = *p;
)

$(FARK_D
---
int* p = adres;

volatile { i = *p; }
---
)


$(FARK sabit_dizgi, Sabit dizgiler)

$(P
C'de sabit dizgiler birden fazla satıra taştığında satır sonlarında $(CODE \) karakteri gerekir. D'de gerekmez ve böylece başka yerlerden kopyalanan metin, olduğu gibi kullanılabilir.
)

$(FARK_C
"Bu sabit dizgi\n\
birden fazla\n\
satırda bulunuyor\n"
)

$(FARK_D
---
"Bu sabit dizgi
birden fazla
satırda bulunuyor
"
---
)


$(FARK veri_yapisi_ziyaret, Veri yapılarını ziyaret etmek)

$(P
Özyinelemeli bir veri yapısındaki elemanları ziyaret eden bir fonksiyon düşünün. Basit bir sembol tablosu olsun. Veri yapısı olarak bir ikili agaç dizisi olsun. Kodun bütün sembollere bakması ve tek olan sembolleri bulması gereksin...
)

$(P
Bu işlem için $(CODE eleman_ara) gibi bir yardımcı fonksiyon gerekir. Bu fonksiyonun ağacın dışında bulunması gereken bir yapıdan bilgi okuması, ve o yapıya bilgi yazması gerekir. Bu bilgi de $(CODE ElemanBilgisi) isimli bir yapıda tutuluyor olsun, ve etkin olması için fonksiyona işaretçi olarak geçirilsin:
)

$(FARK_C
struct Sembol
{
   char *numara;
   struct Sembol *sol;
   struct Sembol *sag;
};

struct ElemanBilgisi
{
   char *numara;
   struct Sembol *sm;
};

static void eleman_ara(struct ElemanBilgisi *p,
                       struct Sembol *s)
{
   while (s)
   {
      if (strcmp(p->numara,s->numara) == 0)
      {
         if (p->sm)
            error("birden fazla anlamı olan eleman: %s\n",
                   p->numara);
         p->sm = s;
      }

      if (s->sol)
         eleman_ara(p,s->sol);
      s = s->sag;
   }
}

struct Sembol *sembol_ara(Sembol *tablo[],
                          int sembol_adet,
                          char *numara)
{
   struct ElemanBilgisi pb;
   int i;

   pb.numara = numara;
   pb.sm = NULL;
   for (i = 0; i < sembol_adet; i++)
   {
      eleman_ara(pb, tablo[i]);
   }
   return pb.sm;
}
)

$(FARK_D

$(P
Aynı algoritma D'de aşağıdaki gibi yazılabilir. Kapsam fonksiyonları, dıştaki fonksiyondaki nesnelere erişebildikleri için $(CODE ElemanBilgisi) gibi bir türe gerek kalmaz. Yardımcı fonksiyon bütünüyle onu kullanan fonksiyonun içinde tanımlandığı için kod yerelliği açısından önemlidir. C ve D kodları arasında hız bakımından da ölçülebilir bir fark yoktur.
)

---
class Sembol
{   char[] numara;
    Sembol sol;
    Sembol sağ;
}

Sembol sembol_ara(Sembol[] tablo, char[] numara)
{   Sembol sm;

    void eleman_ara(Sembol s)
    {
        while (s)
        {
            if (numara == s.numara)
            {
                if (sm)
                    error(
                       "birden fazla anlamı olan eleman: %s\n",
                       numara );
                sm = s;
            }

            if (s.sol)
                eleman_ara(s.sol);
            s = s.sağ;
        }
    }

    for (int i = 0; i < tablo.length; i++)
    {
        eleman_ara(tablo[i]);
    }
    return sm;
}
---
)


$(FARK saga_kaydirma, İşaretsiz sayılarda sağa kaydırma)

$(H6 C)

$(P
Sağa kaydırma işleçleri $(CODE >>) ve $(CODE >>=), işlemlerini sol tarafın türüne göre ya işaretli olarak ya da işaretsiz olarak yaparlar. Türün $(CODE int) olduğu durumda da işaretsiz bir sonuç elde etmek için tür değişimi kullanmak gerekir:
)

$(C_CODE
int i, j;
...
j = (unsigned)i >> 3;
)

$(P
Sağa kaydırılan bir $(CODE int) ise bu doğru çalışır, ama örneğin $(CODE typedef) yoluyla gizlenmiş bir $(CODE long) ise, üst bitlerin farkında olunmadan kaybedilme riski doğar:
)

$(C_CODE
benim_int i, j;
...
j = (unsigned)i >> 3;
)

$(FARK_D

$(P
$(CODE >>) ve $(CODE >>=) işleçleri D'de de aynı şekilde çalışırlar, ama D'de kaydırmayı tür ne olursa olsun işaretsiz olarak yapan $(CODE >>>) ve $(CODE >>>=) işleçleri de vardır:
)

---
benim_int i, j;
...
j = i >>> 3;
---
)


$(FARK kapama, Dinamik kapamalar [closures])

$(H6 C)

$(P
Esnek bir topluluk veri yapısı düşünün. Esnek kabul edilebilmesi için, dışarıdan verilen bir fonksiyonu elemanların hepsine teker teker uygulasın. Bunu, ismi $(I uygula) olan ve bir fonksiyon işaretçisi yanında bir de topluluktaki elemanlardan birisini alan bir fonksiyon olarak düşünebiliriz.
)

$(P
Ek olarak, yapılan işle ilgili bilgi tutmak için ve o bilginin türü esnek olabilsin diye $(CODE void*) bir de $(I kapsam) yapısı alması gerekir. Bu örnekte $(CODE int)'lerden oluşan bir topluluk, ve o topluluktaki en büyük elemanı bulmaya çalışan bir kullanıcı kodu var:
)

$(C_CODE
void uygula(
      void *p, int *dizi, int uzunluk, void (*fp)(void *, int))
{
    for (int i = 0; i < uzunluk; i++)
        fp(p, dizi[i]);
}

struct Topluluk
{
    int dizi[10];
};

void en_buyugunu_bul(void *p, int i)
{
    int *p_en_buyuk = (int *)p;

    if (i > *p_en_buyuk)
        *p_en_buyuk = i;
}

void fonksiyon(struct Topluluk *t)
{
    int en_buyuk = INT_MIN;

    uygula(&en_buyuk,
           t->dizi, sizeof(t->dizi)/sizeof(t->dizi[0]),
           en_buyugunu_bul);
}
)

$(FARK_D

$(P
D'de ise işle ilgili bilgiyi aktarmak için $(I temsilcilerden) [delegate], kapsam içindeki bilgiye erişebilmek ve yerelliği arttırmak için de kapsam fonksiyonlarından yararlanılır. Tür dönüşümlerine gerek kalmadığı için, onların getireceği olası hatalar da ortadan kalkmış olur:
)

---
class Topluluk
{
    int[10] dizi;

    void uygula(void delegate(int) fp)
    {
        for (int i = 0; i < dizi.length; i++)
            fp(dizi[i]);
    }
}

void fonksiyon(Topluluk c)
{
    int en_buyuk = int.min;

    void en_buyugunu_bul(int i)
    {
        if (i > en_buyuk)
            en_buyuk = i;
    }

    c.uygula(en_buyugunu_bul);
}
---
)

$(P
Başka bir yöntem ise $(I fonksiyon sabiti) kullanmaktır; böylece gereksiz fonksiyon isimleri bulmak da gerekmemiş olur:
)

---
void fonksiyon(Topluluk t)
{
    int en_buyuk = int.min;

    t.uygula(
         delegate(int i) { if (i > en_buyuk) en_buyuk = i; } );
}
---

$(FARK belirsiz_parametre, Belirsiz sayıda fonksiyon parametreleri)

$(P
Kaç tane oldukları baştan bilinmeyen parametrelerinin hepsinin toplamını bulan bir fonksiyon yazmaya çalışalım.
)

$(FARK_C
#include &lt;stdio.h&gt;
#include &lt;stdarg.h&gt;

int toplam(int uzunluk, ...)
{   int i;
    int t = 0;
    va_list ap;

    va_start(ap, uzunluk);
    for (i = 0; i < uzunluk; i++)
        t += va_arg(ap, int);
    va_end(ap);
    return t;
}

int main()
{
    int i;

    i = toplam(3, 8,7,6);
    printf("toplam = %d\n", i);

    return 0;
} 
)

$(P
Bunda iki sorun vardır: Birincisi, $(CODE toplam) fonksiyonuna kaç tane sayı olduğunun bildirilmesi gerekir; ikincisi, gönderilen parametrelerin gerçekten $(CODE int) olup olmadıklarını anlamanın hiçbir yolu yoktur.
)

$(FARK_D

$(P
Dizi türündeki bir parametreyi izleyen $(CODE ...) karakterleri, o diziden sonra gelen bütün parametrelerin o dizinin elemanları olarak sunulacaklarını belirler. Parametrelerin gerçekten dizinin türüne uyup uymadıkları denetlenir, ve kaç tane parametre bulunduğu dizinin $(CODE length) niteliğinden anlaşılabilir:
)

---
import std.stdio;

int toplam(int[] değerler ...)
{
    int t = 0;

    foreach (int x; değerler)
        t += x;
    return t;
}

int main()
{
    int i;

    i = toplam(8,7,6);
    writefln("toplam = %d", i);

    return 0;
}
---
)



Macros:
        SUBTITLE=C ile Farkları

        DESCRIPTION=D programlama dilinin C dilinden farkları

        KEYWORDS=d programlama dili tanıtım bilgi karşılaştırma c dili fark
