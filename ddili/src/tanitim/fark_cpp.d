Ddoc

$(H4 D'nin C++ ile Karşılaştırılması)

$(ESKI_KARSILASTIRMA)

$(P
Bu bölüm, C++ programcılarına yönelik olarak D dilinin nesne yönelimli olanaklarını C++'takilerle karşılaştırır. Daha alt düzey ve daha genel olanaklarını $(LINK2 /tanitim/fark_c.html, C karşılaştırmasında) okuyabilirsiniz.
)

$(P
Bu sayfadaki bilgiler $(LINK2 http://www.dlang.org/cpptod.html, Digital Mars'ın sitesindeki aslından) alınmıştır.
)

$(UL_FARK
$(FARK_INDEX kurucular, Kurucular)
$(FARK_INDEX ust_sinif_ilk, Üst sınıf ilkleme)
$(FARK_INDEX yapi_karsilastir, Yapılarda eşitlik karşılaştırması)
$(FARK_INDEX typedef_yeni, $(CODE typedef)'le yeni tür oluşturmak)
$(FARK_INDEX friend, $(CODE friend) sınıflar)
$(FARK_INDEX islec_yukleme, İşleç yükleme [operator overloading])
$(FARK_INDEX namespace_using, İsim alanı kısaltan $(CODE using) bildirimleri)
$(FARK_INDEX raii, RAII (Resource Acquisition Is Initialization))
$(FARK_INDEX nitelik, Nitelikler [properties])
$(FARK_INDEX sablon_ozyineleme, Özyinelemeli şablonlar)
$(FARK_INDEX sablon_meta, Meta şablonlar)
$(FARK_INDEX tur_ozellik, Tür özellikleri [type traits])
)

$(FARK kurucular, Kurucular)

$(P
C++'ta kurucu fonksiyonlar sınıfla aynı isimdedirler; D'de ise $(CODE this) anahtar sözcüğü ile belirtilirler.
)

$(FARK_CPP
class Foo
{
        Foo(int x); 
};
)

$(FARK_D
---
class Foo
{
        this(int x) { } 
}
---
)


$(FARK ust_sinif_ilk, Üst sınıf ilkleme)

$(H6 C++)

$(P
Üst sınıflar ilk değer listesinde ilklenirler.
)

$(C_CODE
class A { A() {... } };
class B : A
{
     B(int x)
        : A()                // ust sinif kurucusu cagrilir
     {        ...
     }
};
)

$(FARK_D

$(P
Üst sınıfın kurucusu $(CODE super()) şeklinde çağrılır.
)

---
class A { this() { ... } }
class B : A
{
     this(int x)
     {        ...
        super();        // üst sınıf kurucusu çağrılır
        ...
     }
}
---
)

$(P
Böylece üst sınıf, alt sınıf kurucusunun herhangi bir noktasında kurulabilir. Ayrıca D'de bir kurucu fonksiyon içerisinden başka bir kurucu fonksiyon çağrılabilir:
)

---
class A
{       int a;
        int b;
        this() { a = 7; b = foo(); } 
        this(int x)
        {
            this();
            a = x;
        }
}
---

$(P
Hatta üyeler daha kurucu çağrılmadan bile sabit değerlerle ilklenebilirler. Aşağıdaki kod yukarıdakinin eşdeğeridir:
)

---
class A
{       int a = 7;
        int b;
        this() { b = foo(); } 
        this(int x)
        {
            this();
            a = x;
        }
}
---


$(FARK yapi_karsilastir, Yapılarda eşitlik karşılaştırması)

$(H6 C++)

$(P
C++'da yapı ataması çok basit olarak derleyici tarafından halledilir, ama eşitlik karşılaştırması için bir yardım gelmez.
)

$(C_CODE
#include &lt;string.h&gt;

struct A x, y;

inline bool operator==(const A& x, const A& y)
{
    return (memcmp(&x, &y, sizeof(struct A)) == 0); 
}
...
if (x == y)
    ...
)

$(P
$(CODE operator==) işlecinin her tür için ayrı ayrı tanımlanması gerekir. Ayrıca kod içinde $(CODE ==) kullanımını görmek işleç fonksiyonu hakkında hiçbir fikir vermez, herhangi bir şekilde tanımlanmış olabilir.
)

$(P
$(CODE memcmp) ise her durumda çalışmayabilir, çünkü yapı üyeleri arasındaki olası doldurma bitlerinin [padding] hangi değerlerde olacakları standart tarafından tanımlanmamıştır.
)

$(P
O yüzden üyelerin teker teker karşılaştırılmaları gerekir ama bu da güvensizdir, çünkü sınıfa eklenen yeni bir üyenin bu fonksiyona da eklenmesinin unutulmaması gerekir.
)

$(FARK_D

$(P
D'de ise karşılaştırma da atama kadar basittir:
)

---
A x, y;
...
if (x == y) 
    ...
---
)


$(FARK typedef_yeni, $(CODE typedef)'le yeni tür oluşturmak)

$(H6 C++)
$(P
C++'da $(CODE typedef) yeni tür oluşturmaz; türe yeni bir isim verir.
)

$(C_CODE
#define CEREZ_ILK        ((Cerez)(-1))
typedef void *Cerez;
void foo(void *);
void bar(Cerez);

Cerez h = CEREZ_ILK;
foo(h);                        // farkedilmeyen kodlama hatasi
bar(h);                        // dogru kullanim
)

$(P
Böyle hatalardan kurtulmak için tür bir yapı içine alınır:
)

$(C_CODE
#define CEREZ_ILK        ((void *)(-1)) 
struct Cerez
{   void *isaretci;

    // ilk deger
    Cerez() { isaretci = CEREZ_ILK; }

    Cerez(int i) { isaretci = (void *)i; }

    // sarmalanan tUre dOnUsUm
    operator void*() { return isaretci; }
};
void bar(Cerez);

Cerez h;
bar(h);
h = fonksiyon();
if (h != CEREZ_ILK)
    ...
)

$(FARK_D

$(P
$(CODE typedef) yeni tür oluşturduğu için C++'daki gibi çözümler gerekmez.
)

---
typedef void* Cerez = cast(void*)-1; 
void bar(Cerez);

Cerez h;
bar(h);
h = fonksiyon();
if (h != Cerez.init)
    ...
---
)


$(FARK friend, $(CODE friend) sınıflar)

$(H6 C++)

$(P
Bazı durumlarda başka sınıfın özel üyelerine erişmesi gereken sınıflar gerekebilir.
)

$(C_CODE
class A
{
    private:
        int a;

    public:
        int foo(B *j);
        friend class B;
        friend int abc(A *);
};

class B
{
    private:
        int b;

    public:
        int bar(A *j);
        friend class A;
};

int A::foo(B *j) { return j-&gt;b; }
int B::bar(A *j) { return j-&gt;a; } 

int abc(A *p) { return p-&gt;a; }
)

$(FARK_D

$(P
D'de ise aynı modülün içinde tanımlanmış olmak, birbirlerinin üyelerine erişebilmek için yeterlidir. Birbirleriyle yakından ilgili olan sınıfların aynı modülde bulunmaları nasıl doğalsa, birbirlerinin üyelerine erişmeleri de doğal kabul edilir.
)

---
module X;

class A
{
    private:
        static int a;

    public:
        int foo(B j) { return j.b; }
}

class B
{
    private:
        static int b;

    public:
        int bar(A j) { return j.a; } 
}

int abc(A p) { return p.a; }
---
)


$(FARK islec_yukleme, İşleç yükleme [operator overloading])

$(H6 C++)

$(P
Aritmetik işlemlerde kullanılabilen bir sınıf için karşılaştırma işleçleri tanımlamak isteyelim. Toplam sekiz fonksiyon gerekir:
)

$(C_CODE
struct A
{
        int operator <  (int i);
        int operator <= (int i);
        int operator &gt;  (int i);
        int operator &gt;= (int i);
};

int operator <  (int i, A &a) { return a &gt;  i; }
int operator <= (int i, A &a) { return a &gt;= i; }
int operator &gt;  (int i, A &a) { return a <  i; }
int operator &gt;= (int i, A &a) { return a <= i; } 
)

$(FARK_D

$(P
D, karşılaştırma işleçlerinin önemini ve birbirleriyle olan doğal ilişkilerini kabul eder, ve tek bir fonksiyon gerektirir:
)

---
struct A
{
        int opCmp(int i); 
}
---

$(P
Derleyici bütün $(CODE &lt;), $(CODE &lt;=), $(CODE &gt;), ve $(CODE &gt;=) işleçlerinin ve sol tarafın nesne olmadığı serbest fonksiyonların hepsini; programcının tanımladığı bu tek karşılaştırma fonksiyonundan çıkarsar.
)

$(P
Derleyici diğer işleç yüklemelerinde de benzer yardımlar sunar ve programcının aynı sonucu elde etmesi için çok daha az kod yazması gerekir.
)

)


$(FARK namespace_using, İsim alanı kısaltan $(CODE using) bildirimleri)

$(P
D'de isim alanlarının ve başlık dosyalarının yerine modüller kullanılır. $(CODE using) bildirimleri yerine $(CODE alias)'lar vardır.
)

$(FARK_CPP
namespace foo
{
    int x;
}
using foo::x;
)

$(FARK_D
---
/** foo.d modülü **/
module foo;
int x;

/** Başka bir modül **/ 
import foo;
alias foo.x x;
---
)

$(P
Aslında $(CODE alias)'ın başka kullanımları da vardır: isimlere yeni adlar verir, şablon üyelerinden ve iç içe sınıflardan bahsederken kolaylık sağlar.
)

$(FARK raii, RAII (Resource Acquisition Is Initialization))

$(H6 C++)

$(P
Bozucu fonksiyonlar, kapsamlardan hata atıldığı durumlarda çıkılırken bile çağrıldıkları için; C++'da kaynaklar bozucu fonksiyonlarda geri verilmek zorundadırlar.
)

$(C_CODE
class Dosya
{   Cerez *h;

    ~Dosya()
    {
        h-&gt;geri_ver(); 
    }
};
)

$(FARK_D

$(P
Kaynak sorunlarının başında gelen bellek yönetimi D'de normalde çöp toplayıcı tarafından halledilir. Diğer bir tür kaynak, iş parçacıklarında [thread] yararlanılan bayraklar ve kilitlerdir; bunlar da normalde D dilinin iş parçacıklarına verdiği destekle halledilir.
)

$(P
Bunların dışında gereken RAII durumlarında da $(I kapsam) [scope] sınıflarından yararlanılır. Kapsam sınıflarının bozucu fonksiyonları C++'da olduğu gibi, kapsamlardan çıkılırken çağrılırlar.
)

---
scope class Dosya
{   Çerez h;

    ~this()
    {
        h.geri_ver();
    }
}

void deneme()
{
    if (...)
    {   scope f = new Dosya();
        ...
    } // Kapsamdan bir hata atılarak bile çıkılmış olsa
      // f.~this() bu kapama parantezinde çağrılır
}
---
)


$(FARK nitelik, Nitelikler [properties])

$(H6 C++)

$(P
Sınıfların $(I nitelik) olarak adlandırabileceğimiz üyeleri geleneksel olarak değerlerini okumak için $(CODE get), değerlerini değiştirmek için de $(CODE set) fonksiyonları yoluyla kullanılırlar.
)

$(C_CODE
class Abc
{
  public:
    void set_bir_nitelik(int yeni_deger)
    {
        bir_nitelik = yeni_deger;
    }

    int get_bir_nitelik() { return bir_nitelik; }

  private:
    int bir_nitelik;
};

Abc a;
a.set_bir_nitelik(3);
int x = a.get_bir_nitelik();
)

$(FARK_D

$(P
Nitelikler üye nesne yazımıyla kullanılırlar ama atama veya okuma arka planda fonksiyonlar tarafından hallediliyor olabilir:
)

---
class Abc
{
    // değeri değiştir
    void bir_nitelik(int yeni_değer)
    {
        benim_değerim = yeni_değer;
    }

    // değeri döndür
    int bir_nitelik() { return benim_değerim; }

  private:
    int benim_değerim;
}
---

$(P
Sanki bir üye nesneymiş gibi kullanılır:
)

---
Abc a;
a.bir_nitelik = 3;     // a.bir_nitelik(3) ile aynı şey
int x = a.bir_nitelik; // int x = a.bir_nitelik() ile aynı şey
---
)

$(P
Bu sayede, başlangıçta gerçekten üye nesne olarak tasarlanmış olan bir üyenin daha sonradan fonksiyonlar tarafından halledilmesi gerekse; kullanıcı kodunda hiçbir değişiklik yapmadan, salt sınıf tanımını değiştirmek yeterli olur.
)


$(FARK sablon_ozyineleme, Özyinelemeli şablonlar)

$(H6 C++)

$(P
Şablonların ileri düzey kullanımlarından birisi, onları özyinelemeli olarak kullanmak ve özyinelemeyi özel bir şablon tanımıyla [specialization] sonlandırmaktır. Örneğin faktöriyel hesaplayan bir şablon şöyle yazılabilir:
)

$(C_CODE
template&lt;int n&gt; class faktoriyel
{
    public:
        enum { sonuc = n * faktoriyel&lt;n - 1&gt;::sonuc }; 
};

template&lt;&gt; class faktoriyel&lt;1&gt;
{
    public:
        enum { sonuc = 1 };
};

void deneme()
{
    printf("%d\n", faktoriyel&lt;4&gt;::sonuc); // 24 yazar
}
)

$(FARK_D

$(P
D'de de temelde aynıdır ama tek olan şablon üyelerinin üst kapsamda görünebilmeleri olanağı yoluyla daha basittir:
)

---
template faktöriyel(int n)
{
    enum { faktöriyel = n * .faktöriyel!(n-1) }
}

template faktöriyel(int n : 1)
{
    enum { faktöriyel = 1 }
}

void deneme()
{
    writefln("%d", faktöriyel!(4));        // 24 yazar
}
---
)


$(FARK sablon_meta, Meta şablonlar)

$(P
Problem: En az $(CODE bit_adedi) kadar bitten oluşan işaretli bir türe $(CODE typedef) yoluyla yeni bir isim verin.
)

$(H6 C++)

$(P
Bu kod Dr. Carlo Pescio'nun $(LINK2 http://www.eptacom.net/pubblicazioni/pub_eng/paramint.html, Template Metaprogramming: Make parameterized integers portable with this novel technique) adlı yazısından basitleştirilerek uyarlanmıştır.
)

$(P
Derlemeyi şablon parametrelerine bağlı bir ifadenin sonucuna göre yönlendirmek C++'da mümkün değildir. Bu yüzden, şablonu ifadenin çeşitli değerleri için özel olarak tanımlamak gerekir. Daha kötüsü, özel tanımları "küçüktür veya eşittir" gibi koşullara göre yapmak da mümkün olmadığı için, ifade değerini bir arttırmak gibi özyinelemeli yöntemlerden yararlanmak gerekir. Derleyicinin uygun bir özel tanım bulamaması durumunda da ya derleyici göçer, ya da anlaşılması hemen hemen imkansız bir hata mesajı verilir.
)

$(P
C++'da şablon $(CODE typedef)'leri olmadığı için de bazen makrolardan da yararlanmak gerekebilir.
)

$(C_CODE
#include &lt;limits.h&gt;

template&lt; int bit_adedi &gt; struct Sayi
{
    typedef Sayi&lt; bit_adedi + 1 &gt; :: int_tUrU int_tUrU ;
} ;

struct Sayi&lt; 8 &gt;
{
    typedef signed char int_tUrU ;
} ;

struct Sayi&lt; 16 &gt; 
{
    typedef short int_tUrU ;
} ;

struct Sayi&lt; 32 &gt; 
{
    typedef int int_tUrU ;
} ;

struct Sayi&lt; 64 &gt;
{
    typedef long long int_tUrU ;
} ;

// Temel turlerin istenen bit adedini tam karsilamadigi
// durumlarda, bu metaprogram bit_adedi'ni bir derleyici
// hatasi olusana veya INT_MAX'e varilana kadar oteler.
// Sablonun INT_MAX ozel tanimi int_tUrU'nu tanimlamadigi
// icin de sonunda mutlaka bir derleme hata mesaji alinir.
struct Sayi&lt; INT_MAX &gt;
{
} ;

// Yazim kolayligi acisindan
#define Sayi( bit_adedi ) Sayi&lt; bit_adedi &gt; :: int_tUrU 

#include &lt;stdio.h&gt;

int main()
{
    Sayi( 8 ) i ;
    Sayi( 16 ) j ;
    Sayi( 29 ) k ;
    Sayi( 64 ) l ;
    printf("%d %d %d %d\n",
        sizeof(i), sizeof(j), sizeof(k), sizeof(l)); 
    return 0 ;
}
)

$(H6 Boost'un C++ çözümü)

$(P
Bu da David Abrahams'ın $(LINK2 http://boost.org, Boost kütüphanesini) kullanan çözümü:
)

$(C_CODE
#include &lt;boost/mpl/if.hpp&gt;
#include &lt;boost/mpl/assert.hpp&gt;

template &lt;int bit_adedi&gt; struct Sayi
    : mpl::if_c&lt;(bit_adedi &lt;= 8), signed char
    , mpl::if_c&lt;(bit_adedi &lt;= 16), short
    , mpl::if_c&lt;(bit_adedi &lt;= 32), long
    , long long&gt;::type &gt;::type &gt;
{
    BOOST_MPL_ASSERT_RELATION(bit_adedi, &lt;=, 64);
}

#include &lt;stdio.h&gt;

int main()
{
    Sayi&lt; 8 &gt; i ;
    Sayi&lt; 16 &gt; j ;
    Sayi&lt; 29 &gt; k ;
    Sayi&lt; 64 &gt; l ;
    printf("%d %d %d %d\n",
        sizeof(i), sizeof(j), sizeof(k), sizeof(l)); 
    return 0 ;
}
)

$(FARK_D

$(P
Özyinelemeli şablonlar kullanılabilse de, D'de çok daha iyi bir yol vardır ve C++'daki çözümlere kıyasla burada neler olduğunu anlamak da çok kolaydır. Derlenmesi çok hızlıdır, ve hata mesajları da çok daha anlaşılırdır:
)

---
import std.stdio;

template Sayi(int bit_adedi)
{
    static if (bit_adedi <= 8)
        alias byte Sayi;
    else static if (bit_adedi <= 16)
        alias short Sayi;
    else static if (bit_adedi <= 32)
        alias int Sayi;
    else static if (bit_adedi <= 64)
        alias long Sayi;
    else
        static assert(0);
}

int main()
{
    Sayi!(8) i ;
    Sayi!(16) j ;
    Sayi!(29) k ;
    Sayi!(64) l ;
    writefln("%d %d %d %d",
        i.sizeof, j.sizeof, k.sizeof, l.sizeof); 
    return 0;
}
---
)


$(FARK tur_ozellik, Tür özellikleri [type traits])

$(P
Tür özellikleri derleme zamanında kullanışlıdırlar.
)

$(H6 C++)

$(P
Parametresinin bir fonksiyon olup olmadığını anlayan bu şablon, David Vandevoorde ve Nicolai M. Josuttis'in $(LINK2 http://www.amazon.com/exec/obidos/ASIN/0201734842/ref=ase_classicempire/102-2957199-2585768, C++ Templates: The Complete Guide) kitaplarının 353'üncü sayfasından uyarlanmıştır:
)

$(C_CODE
template&lt;typename T&gt; class Fonksiyondur
{
    private:
        typedef char Bir;
        typedef struct { char a[2]; } Iki;
        template&lt;typename U&gt; static Bir oyle_mi(...);
        template&lt;typename U&gt; static Iki oyle_mi(U (*)[1]);
    public:
        enum {
          Evet = sizeof(Fonksiyondur&lt;T&gt;::oyle_mi&lt;T&gt;(0)) == 1
        };
};

void deneme()
{
    typedef int (fp)(int);

    assert(Fonksiyondur&lt;fp&gt;::Evet == 1);
}
)

$(P
Bu çözüm $(LINK2 http://www.dlang.org/glossary.html#sfinae, SFINAE (Substitution Failure Is Not An Error)) kuralından yararlanır ve oldukça ileri düzey şablon olanakları kullanır. $(I [Çevirenin notu: C++ dilinin bir özelliği olan SFINAE, şablon parametresi çıkarsarken yasal olmayan türlerle karşılaşıldığında derleyicinin hata vermek yerine, o özel tanımı gözardı edeceğini söyleyen kuraldır.])
)

$(FARK_D

$(P
SFINAE D'de çok basit bir yolla yapılabilir:
)

---
template Fonksiyondur(T)
{
    static if ( is(T[]) )
        const int Fonksiyondur = 0;
    else
        const int Fonksiyondur = 1;
}

void deneme()
{
    typedef int fp(int);

    assert(Fonksiyondur!(fp) == 1);
}
---

$(P
Daha da iyisi, bir türün bir fonksiyon olup olmadığını anlamak için şablon yöntemlerine başvurmaya gerek de yoktur. D'nin $(CODE is) ifadesi bu soruyu doğrudan yanıtlar:
)

---
void deneme()
{
    alias int fp(int);

    assert( is(fp == function) );
}
---
)

Macros:
        SUBTITLE=C++ ile Farkları

        DESCRIPTION=D programlama dilinin C++ dilinden nesne yönelimli ve başka olanakları açısından farklılıkları

        KEYWORDS=d programlama dili tanıtım bilgi karşılaştırma c++ cpp dili fark
