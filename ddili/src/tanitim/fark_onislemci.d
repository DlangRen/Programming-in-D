Ddoc

$(H4 D Olanaklarının C Önişlemcisiyle [preprocessor] Karşılaştırılması)

$(ESKI_KARSILASTIRMA)

$(P
Bu sayfadaki bilgiler $(LINK2 http://www.dlang.org/pretod.html, Digital Mars'ın sitesindeki aslından) alınmıştır.
)

$(P
C'nin yaratıldığı günlerde derleyici teknolojisi henüz çok geriydi. Derleme işleminin öncesine metin makroları işleyen bir adım eklemek, çok kolay bir ek olması yanında programcıya büyük kolaylıklar da sunmuştu. Fakat programların boyutları ve karmaşıklıkları arttıkça önişlemci olanaklarının üstesinden gelinemeyecek sorunları da ortaya çıkmaya başlamıştır. D'de önişlemci bulunmaz, ama başka olanakları sayesinde aynı sorunları daha etkin olarak çözer.
)

$(UL_FARK
$(FARK_INDEX baslik, Başlık dosyaları)
$(FARK_INDEX pragma_once, #pragma once)
$(FARK_INDEX pragma_pack, #pragma pack)
$(FARK_INDEX makro, Makrolar)
$(FARK_INDEX duruma_gore, Derlemeyi duruma göre yönlendirmek [conditional compilation])
$(FARK_INDEX kod_tekrari, Kod tekrarını azaltmak)
$(FARK_INDEX error_assert, $(CODE #error) ve derleme zamanı denetimleri)
$(FARK_INDEX katma, Şablon katmaları [mixin])
)

$(FARK baslik, Başlık dosyaları)

$(H6 C)

$(P
Başlık dosyalarını oldukları gibi metin halinde $(I $(CODE #include) etmek), C ve C++'da çok gündelik işlemlerdir. Bu yüzden derleyici başlık dosyalarında bulunan on binlerce satırı her seferinde baştan derlemek zorunda kalır. Başlık dosyalarının asıl yapmaya çalıştıkları; metin olarak eklenmek yerine, derleyiciye bazı isimleri bildirmektir. Bu D'de $(CODE import) deyimiyle yapılır. Bu durumda daha önceden zaten derlenmiş olan isimler öğrenilmiş olurlar. Böylelikle başlıkların birden fazla sayıda eklenmelerini önlemek için $(CODE #ifdef)'ler, $(CODE #pragma once)'lar, veya kullanımları çok kırılgan olan $(I precompiled headers) gibi çözümler gerekmemiş olur.
)

$(C_CODE
#include &lt;stdio.h&gt;
)

$(FARK_D
---
import std.c.stdio;
---
)

$(FARK pragma_once, #pragma once)

$(H6 C)

$(P
Başlık dosyalarının birden fazla $(CODE #include) edilmelerini önlemek gerekir. Bunun için başlık dosyalarına ya şu satır eklenir:
)

$(C_CODE
#pragma once
)

$(P
ya da daha taşınabilir olarak:
)

$(C_CODE
#ifndef __STDIO_INCLUDE
#define __STDIO_INCLUDE
... dosya içeriği
#endif
)

$(FARK_D
$(P
Tamamen gereksizdir; çünkü D, isimleri $(I sembol) olarak ekler. $(CODE import) bildirimi ne kadar çok yapılmış olursa olsun, isimler yalnızca bir kere eklenirler.
)
)

$(FARK pragma_pack, #pragma pack)

$(H6 C)

$(P
Yapı üyelerinin bellekte nasıl yerleştirileceklerini belirler.
)

$(FARK_D

$(P
D sınıflarında üyelerin bellek yerleşimlerine karışmak gerekmez; derleyici üyelerin ve hatta yerel değişkenlerin sıralarını istediği gibi değiştirme hakkına sahiptir; ama dış veri yapılarına denk olmaları gerekebileceği için, D'de yapı üyelerinin yerleşimleri de ayarlanabilir:
)

---
struct Foo
{
        align (4):        // 4 baytlık yerleşim kullanılır
        ...
}
---
)

$(FARK makro, Makrolar)

$(P
C'de önişlemci makroları esneklik de sağlayan çok güçlü olanaklardır; ama zayıflıkları da vardır:
)

$(UL

$(LI
Makroların kapsamları yoktur; tanımlandıkları noktadan kaynak dosyanın sonuna kadar etkilidirler. Etkileri .h dosyalarının aşar, ve içteki kapsamlara da geçer. $(CODE #include) edilmiş olan on binlerce satırda içinde tanımlanmış olan makroların etkileri bazen istenmeyen sonuçlar doğurur.
)

$(LI
Hata ayıklayıcının makrolardan haberi yoktur. Hata ayıklayıcının gördüğü kod, makroların açılmış halleri olduğu için; programcının gördüğü ile aynı değildir.
)

$(LI
Makrolar simgelerin ayrıştırılmalarını olanaksızlaştırabilirler; çünkü daha önce tanımlanmış bir makro, kodu bütünüyle değiştirmiş olabilir.
)

$(LI
Makroların bütünüyle metin temelli olmaları kullanımlarının tutarsız olmalarına ve dolayısıyla hataya açık olmalarına yol açar. (C++ şablonları bir ölçüde bunları önler.)
)

$(LI
Makroların görevlerinden birisi dildeki eksiklikleri gidermektir. Bunu başlık dosyalarını sarmalayan $(CODE #ifdef/#endif) satırlarında görüyoruz.
)

)

$(P
Makroların temel kullanımları ve bunların D'deki karşılıkları şöyledir:
)

$(OL

$(LI Sabit değerler

$(FARK_C
#define DEGER        5
)

$(FARK_D
---
const int DEĞER = 5;
---
)

)

$(LI Bir dizi sabit değer veya bayrak değerleri tanımlamak

$(FARK_C
int bayraklar:
#define BAYRAK_X        0x1
#define BAYRAK_Y        0x2
#define BAYRAK_Z        0x4
...
bayraklar |= BAYRAK_X;
)

$(FARK_D
---
enum BAYRAK { X = 0x1, Y = 0x2, Z = 0x4 };
BAYRAK bayraklar;
...
bayraklar |= BAYRAK.X;
---
)

)

$(LI ASCII (char) veya evrensel (wchar) karakterlere göre derlemek

$(FARK_C
#if UNICODE
    #define dchar        wchar_t
    #define TEXT(s)      L##s
#else
    #define dchar        char
    #define TEXT(s)      s
#endif

...
dchar m[] = TEXT("merhaba");
)

$(FARK_D
---
dchar[] m = "merhaba";
---
)

)

$(LI Eski derleyicilere uygun olarak derleme

$(FARK_C
#if PROTOTYPES
#define P(p)        p
#else
#define P(p)        ()
#endif
int func P((int x, int y));
)

$(FARK_D
$(P
D derleyicisinin açık kodlu olması farklı derleyici söz dizimleri sorunlarını da önler.
)
)

)

$(LI Türlere yeni isimler

$(FARK_C
#define INT         int
)

$(FARK_D
---
alias int INT;
---
)
)

$(LI Bildirimler ve tanımlar için tek başlık dosyası kullanmak

$(FARK_C
#define EXTERN extern
#include "bildirimler.h"
#undef EXTERN
#define EXTERN
#include "bildirimler.h"
)

$(P
$(CODE bildirimler.h) dosyasında:
)

$(C_CODE
EXTERN int foo;
)

$(FARK_D

$(P
D'de bildirim ve tanım aynıdır; aynı kaynak koddan hem bildirim hem de tanım elde etmek için $(CODE extern) anahtar sözcüğünü kullanmak gerekmez.
)

)

)

$(LI Hızlı iç [inline] fonksiyonlar

$(FARK_C
#define X(i)        ((i) = (i) / 3)
)

$(FARK_D
---
int X(ref int i) { return i = i / 3; }
---

$(P
Derleyici eniyileştiricisi fonksiyonu zaten $(I iç fonksiyon) olarak derler.
)
)

)

$(LI $(CODE assert) fonksiyonu için dosya ve satır bilgisi

$(FARK_C
#define assert(e)  ((e) || _assert(__LINE__, __FILE__))
)

$(FARK_D
$(P
$(CODE assert) dilin bir iç olanağıdır. Bu, derleyici eniyileştiricisinin $(CODE _assert())'in dönüş türünün olmadığı bilgisinden yararlanmasını da sağlar.
)
)

)

$(LI Fonksiyon çağırma çeşitleri [calling conventions]

$(FARK_C
#ifndef _CRTAPI1
#define _CRTAPI1 __cdecl
#endif
#ifndef _CRTAPI2
#define _CRTAPI2 __cdecl
#endif

int _CRTAPI2 fonksiyon();
)

$(FARK_D

$(P
Fonksiyonların nasıl çağrıldıkları gruplar halinde belirlenebilir:
)
---
extern (Windows)
{
    int bir_fonksiyon();
    int baska_bir_fonksiyon();
}
---
)

)

$(LI $(CODE __near) ve $(CODE __far) işaretçi yazımını gizlemek

$(FARK_C
#define LPSTR        char FAR *
)

$(FARK_D
$(P
D'de 16 bitlik kod, işaretçi boyutlarının karışık kullanımı, değişik işaretçi türleri desteklenmez.
)
)

)

$(LI Türden bağımsız temel kodlama

$(H6 C)

$(P
Hangi fonksiyonun kullanılacağını metni dönüştürerek belirlemek:
)

$(C_CODE
#ifdef UNICODE
int getValueW(wchar_t *p);
#define getValue getValueW
#else
int getValueA(char *p);
#define getValue getValueA
#endif
)

$(FARK_D

$(P
D isimlere yeni takma isimler vermeyi destekler:

---
version (UNICODE)
{
    int getValueW(wchar[] p);
    alias getValueW getValue;
}
else
{
    int getValueA(char[] p);
    alias getValueA getValue;
}
---
)

)

)

)


$(FARK duruma_gore, Derlemeyi duruma göre yönlendirmek [conditional compilation])

$(H6 C)

$(P
Derlemeyi yönlendirebilmek önişlemcinin güçlü yönlerindendir ama zayıflıkları da vardır:
)

$(UL
$(LI
Önişlemcinin kapsamlardan haberi olmaması, $(CODE #if/#endif) bloklarının kapsamlardan bağımsız ve düzensiz olarak yerleştirilmelerine olanak sağlar; kodu izlemek güçleşir.
)

$(LI
Derlemeyi yönlendirmek yine makrolar aracılığıyla yapıldığı için, kullanılan makro isimlerinin programdaki başka isimlerle çakışma olasılıkları yine de geçerlidir.
)

$(LI
$(CODE #if) ifadeleri diğer C ifadelerinden farklı olarak işletilirler.
)

$(LI
$(I Önişlemci dili) C'den temelde farklılıklar gösterir; örneğin boşluk karakterleri ve satır başları önişlemci için önemli oldukları halde derleyici için önemli olmayabilirler.
)

)

$(FARK_D
$(P
Derlemeyi yönlendirmek D'de dil tarafından sağlanır:
)

$(OL
$(LI
Farklı sürüm kodlarını farklı modüllere yerleştirmek
)

$(LI
Hata ayıklamaya yardımcı olan $(CODE debug) deyimi
)

$(LI
Tek kaynak koddan programın farklı sürümlerini üretmeye yarayan $(CODE version) deyimi
)

$(LI
$(CODE if(0)) deyimi
)

$(LI
Bir grup kod satırını bir grup açıklama satırına dönüştüren $(CODE /+ +/) açıklamaları
)
)
)

$(FARK kod_tekrari, Kod tekrarını azaltmak)

$(H6 C)

$(P
Bazen fonksiyonlar içinde tekrarlanan kodlarla karşılaşılabilir. Tekrarlanan kodların ayrı bir fonksiyona taşınması daha doğal olsa da, fonksiyon çağrısı bedelini önlemek için bazen makrolar kullanılır. Örneğin şu $(I bayt kod yorumlayıcısı) koduna bakalım:
)

$(C_CODE
unsigned char *ip;      // byte code instruction pointer
int *stack;
int spi;                // stack pointer
...
#define pop()     (stack[--spi])
#define push(i)   (stack[spi++] = (i))
while (1)
{
    switch (*ip++)
    {
        case ADD:
            op1 = pop();
            op2 = pop();
            result = op1 + op2;
            push(result);
            break;

        case SUB:
        ...
    }
}
)

$(P
Bu kodda çeşitli sorunlar vardır:
)

$(OL

$(LI
Makrolar ifade olarak açıldıkları için değişken tanımlayamazlar. Örneğin program yığıtından taşmaya karşı denetim eklemek gibi bir iş oldukça güçtür.
)

$(LI
Sembol tablosunda bulunmadıklarından, etkileri tanımlandıkları fonksiyonun dışına da taşar
)

$(LI
Makro parametreleri metin olarak geçirildiklerinden makronun parametreyi gereğinden fazla işletmemeye dikkat etmesi ve kodun anlamını korumak için parametreyi parantezler içine alması gerekir
)

$(LI
Hata ayıklayıcı makrolardan habersizdir
)

)

$(FARK_D

$(P
D'de kapsam fonksiyonları kullanılır:
)

---
ubyte* ip;           // byte code instruction pointer
int[] stack;         // operand stack
int spi;             // stack pointer
...

int pop()        { return stack[--spi]; }
void push(int i) { stack[spi++] = i; }

while (1)
{
    switch (*ip++)
    {
        case ADD:
            op1 = pop();
            op2 = pop();
            push(op1 + op2);
            break;

        case SUB:
        ...
    }
}
---

$(P
Bunun çözdüğü sorunlar şunlardır:
)

$(OL
$(LI
Kapsam fonksiyonları D fonksiyonları kadar güçlü olanaklara sahiptirler
)

$(LI
Kapsam fonksiyonunun ismi, tanımlandığı kapsamla sınırlıdır
)

$(LI
Parametreler değer olarak geçirildikleri için birden fazla işletilmeleri gibi sorunlar yoktur
)

$(LI
Kapsam fonksiyonları hata ayıklayıcı tarafından görülebilirler
)
)

$(P
Ek olarak, kapsam fonksiyonu çağrıları eniyileştirici tarafından yok edilince çağrı bedeli de önlenmiş olur.
)
)

$(FARK error_assert, $(CODE #error) ve derleme zamanı denetimleri)

$(P
Derleme zamanında yapılan denetimler sırasında derlemenin bir hata mesajıyla sonlandırılması sağlanabilir.
)

$(H6 C)

$(P
Bir yöntem, $(CODE #error) önişlemci komutunu kullanmaktır:
)

$(C_CODE
#if FOO || BAR
    ... derlenecek kod ...
#else
#error "FOO veya BAR'dan en az birisi gerekmektedir"
#endif
)

$(P
Önişlemci yetersizlikleri burada da geçerlidir: yalnızca tamsayı ifadeler geçerlidir, tür değişimlerine izin verilmez, $(CODE sizeof) kullanılamaz, sabitler kullanılamaz, vs.
)

$(P
Bunların bazılarını gidermek için bir $(CODE static_assert) (derleme zamanı denetimi) makrosu kullanılabilir (M.Wilson tarafından):
)

$(C_CODE
#define static_assert(_x)            \
do {                                 \
  typedef int ai[(_x) ? 1 : 0];      \
} while(0)
)

$(P
Kullanımı şöyledir:
)

$(C_CODE
void foo(T t)
{
    static_assert(sizeof(T) < 4);
    ...
}
)

$(P
Bu, koşul yanlış ($(CODE false)) olduğunda bir yazım hatasına dönüşür ve derleme bir hata mesajıyla sonlanır. $(I [Çevirenin notu: $(CODE false) olduğunda $(CODE ai) dizisinin boyu $(CODE 0) olur; bu da C kurallarına göre yasal değildir.])
)

$(FARK_D
$(P
$(CODE static assert) D'de bir dil olanağıdır ve bildirimlerin ve deyimlerin kullanılabildikleri her yerde kullanılabilir. Örnek:
)

---
version (FOO)
{
    class Bar
    {
        const int x = 5;
        static assert(Bar.x == 5 || Bar.x == 6);

        void foo(T t)
        {
            static assert(T.sizeof < 4);
            ...
        }
    }
}
else version (BAR)
{
    ...
}
else
{
    static assert(0);        // yasal olmayan bir sürüm
}
---
)

$(FARK katma, Şablon katmaları [mixin])

$(P
D'nin şablon katma olanağı, dışarıdan bakıldığında tıpkı C'nin önişlemcisinde olduğu gibi bir metin yerleştirme olanağına benzer. Yerleştirilen metin yine açıldığı yerde ayrıştırılır [parse], ama katmaların makrolardan üstün tarafları vardır:
)

$(OL

$(LI
Katmalar söz dizimine uyarlar ve ayrıştırma ağaçlarında [parse tree] yer alırlar. Makrolar ise hiçbir düzene bağlı olmadan metin yerleştirirler.
)

$(LI
Katmalar aynı dilin parçalarıdırlar. Makrolar ise C++'nın üstünde ayrı bir dildir; kendine ait ifade kuralları, türleri, sembol tabloları, ve kapsam kuralları vardır.
)

$(LI
Katmalar kısmi özelleme [partial specialization] kurallarına göre seçilirler; makrolarda aşırı yükleme yoktur.
)

$(LI
Katmalar kapsam oluştururlar; makrolar oluşturmazlar.
)

$(LI
Katmalar söz diziminden anlayan araç programlarla uyumludurlar; makrolar değildirler.
)

$(LI
Katmalarla ilgili bilgiler ve sembol tabloları hata ayıklayıcılara geçirilirler; makrolar metin yerleştirildikten sonra yok olurlar.
)

$(LI
Katmalarda birden fazla tanımın uygun olduğu durumlarda hangisinin kullanılacağının kuralları bellidir; makro tanımları çakışmak zorundadırlar.
)

$(LI
Katma isimlerinin başka katma isimleriyle çakışmaları standart bir algoritma yoluyla önlenmiştir; makrolarda kelime birleştirme yoluyla elle yapılır.
)

$(LI
Katma argümanları tek bir kere işletilirler; makro açılımlarında ise argümanlar kullanıldıkları her sefer işletilirler ve bu yüzden bulunması güç hatalara yol açabilirler.
)

$(LI
Katma argümanlarının etrafına koruyucu parantezler koymak gerekmez.
)

$(LI
Katmalar istendiği kadar uzunlukta normal D kodu olarak yazılırlar; makrolarda olduğu gibi satırları $(CODE \) karakteriyle  sonlandırmak gerekmez, $(CODE //) açıklamaları koyamamak gibi sorunlar yoktur, vs.
)

$(LI
Katmalar başka katmalar tanımlayabilirler; makrolar makro tanımlayamazlar.
)

)



Macros:
        SUBTITLE=C Önişlemcisi ile Farkları

        DESCRIPTION=D programlama dilinin C önişlemcisiyle farkları

        KEYWORDS=d programlama dili tanıtım bilgi karşılaştırma c dili önişlemci preprocessor
