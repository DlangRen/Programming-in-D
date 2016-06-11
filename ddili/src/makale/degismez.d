Ddoc

$(H4 $(CODE const) ve $(CODE immutable) Kavramları)

$(P
  $(B Çeviren:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Tarih:) 13 Temmuz 2009
$(BR)
  $(B İngilizcesi:) $(LINK2 http://www.dlang.org/const3.html, Const and Immutable)
)

$(P
$(I [Çevirenin notu: "constant" ve "immutable" sözcüklerinin hem İngilizce hem Türkçe karşılıkları temelde aynıdır: sabit, değişmez. Türkçe'de $(CODE const) başka programlama dillerinde zaten "sabit" olarak geçtiği için ben burada da aynı karşılığı kullanıyorum. Böylece $(CODE immutable)'a "değişmez" kalıyor.])
)

$(P
Bir veri yapısını veya bir arayüz fonksiyonunu incelerken hangi verilerin değişmeyeceklerini, hangilerinin değişebileceklerini, ve değişimlerin kimin tarafından yapılabileceğini bilmek çok önemlidir. Bunu sağlayan düzeneklerden birisi, dilin tür sistemidir. D'de her veri $(CODE const) veya $(CODE immutable) olarak belirtilebilir. Özellikle belirtilmemişse veri $(I değişebilir) demektir.
)

$(P
$(CODE immutable), verinin $(I değişemez) olduğunu bildirir. Bu tür veriler, ilk değerlerini aldıktan programın sonuna kadar aynı değerde kalırlar. Bunlar ROM'a veya donanımın $(I değiştirilemez) olarak işaretlediği bellek bölgelerine yerleştirilmiş olabilirler. Verinin değişemez olduğunun baştan biliniyor olması; derleyici için eniyileme olanaklarının artmasının yanında, fonksiyonel programlama açısından da yararlıdır.
)

$(P
$(CODE const), verinin $(CODE const) olarak belirlenen referans yoluyla değiştirilemeyeceğini bildirir. Aynı veri, başka bir referans aracılığıyla değiştirilebilir durumda olabilir. $(CODE const), fonksiyonların verileri değiştirmeyecekleri sözü vermeleri için kullanılır.
)

$(P
$(CODE const) ve $(CODE immutable) $(I geçişlidirler); onlar aracılığıyla erişilen başka veriler de yine $(CODE const) veya $(CODE immutable)'dırlar.
)

$(H6 $(CODE immutable) depolama türü)

$(P
$(CODE immutable)'ın en basit kullanımı sabit değerler oluşturmaktır.
)

---
immutable int x = 3;     // x 3'tür
x = 4;                   // hata: x değiştirilemez
char[x] s;               // s, uzunluğu 3 olan bir char dizisidir
---

$(P
Verinin türü, ilkleme için kullanılan değerden çıkarsanabilir:
)

---
immutable y = 4;        // y'nin türü int'tir
y = 5;                  // hata: y değiştirilemez
---

$(P
Eğer ilkleme değeri henüz mevcut değilse, değişmez veri daha sonraki bir noktada kendisiyle ilgili kurucuda ilklenebilir.
)

---
immutable int z;
void deneme()
{
    z = 3;              // hata: z değiştirilemez
}
static this()
{
    z = 3;    // olur: ilkleme değeri z'nin tanımlandığı
              // noktada bilinmiyorsa burada ilklenir
}
---

$(P
Yerel olmayan bir $(CODE immutable) verinin ilk değerinin derleme zamanında hesaplanabilen bir türden olması gerekir.
)

---
int foo(int f) { return f * 3; }
int i = 5;
immutable x = 3 * 4;      // olur: 12
immutable y = i + 1;      // hata: derleme zamanında işletilmez
immutable z = foo(2) + 1; // olur: foo(2) derleme zamanında 7
                          // olarak hesaplanır
---

$(P
$(CODE static) olmayan yerel $(CODE immutable) veriler çalışma zamanında ilklenirler.
)

---
int foo(int f)
{
  immutable x = f + 1;  // çalışma zamanında işletilir
  x = 3;                // hata: x değiştirilemez
}
---

$(P
Değişmezlik geçişli olduğu için $(CODE immutable) yoluyla erişilen veri de değişmezdir.
)

---
immutable char[] s = "foo";
s[0] = 'a';  // hata: s bir immutable veri referansıdır
s = "bar";   // hata: s değiştirilemez
---

$(P
$(CODE immutable) veriler $(I soldeğer)lerdir [lvalue]. Yani adresleri alınabilir ve bellekte yer tutarlar.
)

$(H6 $(CODE const) depolama türü)

$(P
$(CODE const) bildirimi ile $(CODE immutable) bildirimi arasında şunlardan başka fark yoktur:
)

$(UL
$(LI Veri, $(CODE const) olarak bildirilmiş referansı yoluyla değiştirilemez, ama aynı veri $(CODE const) olmayan başka bir referans yoluyla değiştirilebilir.
)

$(LI $(CODE const) bildiriminin kendi türü de $(CODE const)'tır.
)
)

$(H6 $(CODE immutable) türler)

$(P
Değeri değişmeyecek olan verilerin türleri $(CODE immutable) olarak bildirilebilir. $(CODE immutable) anahtar sözcüğü bir $(I tür kurucusu) olarak düşünülebilir:
)

---
immutable(char)[] s = "merhaba";
---

$(P
$(CODE immutable) anahtar sözcüğü, o kullanımda parantez içindeki türü etkiler. Orada $(CODE s)'ye yeni değerler atanabiliyor olsa da, $(CODE s)'nin içindeki değerler değiştirilemez:
)

---
s[0] = 'b';  // hata: s[] değiştirilemez
s = null;    // olur: s'nin kendisi immutable değil
---

$(P
$(CODE immutable) geçişlidir; kendisi yoluyla erişilen veri de değiştirilemez:
)

---
immutable(char*)** p = ...;
p = ...;        // olur: p immutable değil
*p = ...;       // olur: *p immutable değil
**p = ...;      // hata: **p değiştirilemez
***p = ...;     // hata: ***p değiştirilemez
---

$(P
Depolama türü olarak kullanılan $(CODE immutable), bütün bildirimin türü için kullanılan tür kurucusu $(CODE immutable)'ın eşdeğeridir:
)

---
immutable int x = 3;   // x'in türü immutable(int) olur
immutable(int) y = 3;  // y değiştirilemez
---

$(H6 Değiştirilemeyen veri oluşturmak)

$(P
Bunun bir yolu, değiştirilemeyen değerler kullanmaktır. Örneğin dizgi sabitleri değiştirilemezler:
)

---
auto s = "merhaba";   // s'nin türü immutable(char)[] olur
char[] p = "dünya";   // hata: immutable, değiştirilebilen bir
                      //       türe otomatik olarak dönüşemez
---

$(P
Diğer yol, tür değişiminde $(CODE immutable) kullanmaktır. Ama böyle yapıldığında, veriyi değiştirebilecek başka referansların bulunmadığını sağlamak programcının sorumluluğundadır.
)

---
char[] s = ...;
immutable(char)[] p = cast(immutable)s;    // tanımsız davranış

immutable(char)[] p = cast(immutable)s.dup;
 // olur: p, .dup ile kopyalanan yeni kopyanın tek referansıdır
---

$(P
Dizilerin $(CODE immutable) kopyalarını almanın kolay yolu, $(CODE .idup) dizi niteliğini kullanmaktır:
)

---
auto p = s.idup;
p[0] = ...;          // hata: p[] değiştirilemez
---

$(H6 $(CODE immutable)'ın tür değişimi ile kaldırılması)

$(P
Değişmezlik tür dönüşümü ile kaldırılabilir:
)

---
immutable int* p = ...;
int* q = cast(int*)p;
---

$(P
Ama bu, verinin artık değiştirilebileceği anlamına gelmez:
)

---
*q = 3; // derleyici izin verir ama tanımsız davranıştır
---

$(P
Bazı durumlarda $(CODE immutable)'ın kaldırılabilmesi gerekebilir. Örneğin kaynak kodlarına sahip olmadığımız bir kütüphane, $(CODE immutable) olması gereken fonksiyon parametrelerini $(CODE immutable) olarak bildirmemiş olabilir. O kütüphane fonksiyonlarını çağırabilmek için $(CODE immutable)'ı tür dönüşümü yoluyla kaldırmak zorunda kalırız; ancak bu durumda sorumluluk tamamen programcıya aittir; derleyici o veri için artık denetim sağlayamaz.
)

$(H6 $(CODE immutable) üye fonksiyonlar)

$(P
Üye fonksiyonları $(CODE immutable) olarak bildirmek, o nesnenin o üye fonksiyon içindeyken değiştirilemeyeceği anlamına gelir. Bu, nesne içinde tanımlı bütün verileri ve onların $(CODE this) yoluyla erişildiği durumları kapsar:
)

---
struct S
{   int x;

    immutable void foo()
    {
        x = 4;            // hata: x değiştirilemez
        this.x = 4;       // hata: x değiştirilemez
    }
}
---

$(P
$(CODE const) ve $(CODE immutable) belirteçleri üye fonksiyonların parametre listesinden sonra da yazılabilirler:
)

---
struct S
{
    void bar() immutable
    {
    }
}
---

$(H6 $(CODE const) türler)

$(P
$(CODE const) türler de $(CODE immutable) türler gibidirler; ama bu türden olan veriler $(CODE const) olmayan referanslar yoluyla değiştirilebilirler.
)

$(H6 $(CODE const) üye fonksiyonlar)

$(P
$(CODE const) üye fonksiyonlar içindeyken nesnenin $(CODE this) yoluyla erişilen üyeleri değiştirilemez.
)

$(H6 Otomatik dönüşümler)

$(P
Değişken (normal) türler ve $(CODE immutable) türler otomatik olarak $(CODE const)'a dönüşürler. Değişken türler $(CODE immutable) türlere, $(CODE immutable) türler de değişken türlere otomatik olarak dönüşmezler.
)

$(H6 D'deki $(CODE const) ve $(CODE immutable)'ın C++'daki $(CODE const) ile karşılaştırılması)



<table border="2" cellpadding="4" cellspacing="0">
<caption>const ve immutable Karşılaştırması</caption>

<thead>
<tr>  <th scope="col">Olanak</th>
<th scope="col">D</th>
<th scope="col">C++98</th>

</tr>
</thead>

<tbody>

<tr>  <td>const anahtar sözcüğü</td>
<td>var</td>
<td>var</td>

</tr>

<tr>  <td>immutable anahtar sözcüğü</td>
<td>var</td>
<td>yok</td>
</tr>

<tr>  <td>const yazımı</td>

<td>Fonksiyon bildirimi gibi:
---
// const int
// const işaretçisi
// işaretçisi:
const(int*)* p;
---
  </td>
  <td>Sonda:

$(C_CODE
// const int
// const işaretçisi
// işaretçisi:
const int *const *p;
)
  </td>
  </tr>

  <tr>  <td>const geçişliliği</td>
  <td>var:
---
// const int
// const işaretçisi
// const işaretçisi:
const int** p;
**p = 3; // hata
---
   </td>
  <td>yok:

$(C_CODE
// int
// işaretçisi
// const işaretçisi:
int** const p;
**p = 3;  // olur
)
   </td>
  </tr>

  <tr>  <td>const'ı kaldırmak</td>
  <td>var:
---
// const int işaretçisi:
const(int)* p;

int* q = cast(int*)p; //olur
---
  </td>
  <td>var:
$(C_CODE
// const int işaretçisi:
const int* p;
int* q = const_cast&lt;int*&gt;p;
                     // olur
)
  </td>

  </tr>

  <tr>  <td>const'ı kaldırdıktan sonra değişiklik</td>
  <td>yok:
---
// const int işaretçisi:
const(int)* p;
int* q = cast(int*)p;
*q = 3; // tanımsız davranış
---
  </td>
  <td>var:
$(C_CODE
// const int işaretçisi:
const int* p;
int* q = const_cast&lt;int*&gt;p;
*q = 3;   // olur
)
  </td>
  </tr>

  <tr>  <td>fonksiyon yüklemede üst düzey const'ın etkisi</td>

  <td>var:
---
void foo(int x);
void foo(const int x);//olur
---
  </td>
  <td>yok:
$(C_CODE
void foo(int x);
void foo(const int x);//hata
)
  </td>
  </tr>

  <tr>  <td>aynı const'a değişken olarak da erişebilmek</td>
  <td>var:
---
void foo(const int* x,
         int* y)
{
   bar(*x); // bar(3)
   *y = 4;
   bar(*x); // bar(4)
}
...
int i = 3;
foo(&i, &i);
---
  </td>
  <td>var:
$(C_CODE
void foo(const int* x,
         int* y)
{
   bar(*x); // bar(3)
   *y = 4;
   bar(*x); // bar(4)
}
...
int i = 3;
foo(&i, &i);
)
  </td>
  </tr>

  <tr>        <td>aynı immutable'a değişken olarak da erişebilmek</td>

        <td>yok:
---
void foo(immutable int* x,
         int* y)
{
  bar(*x);// bar(3)

  *y = 4; // tanımsız
          // davranış

  bar(*x);// bar(??)
}
...
int i = 3;
foo(cast(immutable)&i, &i);
---
        </td>
        <td>immutable desteklenmez</td>
        </tr>

        <tr>        <td>dizgi sabitlerinin türü</td>
        <td>
---
immutable(char)[]
---
</td>
        <td>
$(C_CODE
const char[N]
)
</td>
        </tr>


        <tr>        <td>dizgi sabitinin değişken dizgiye otomatik dönüşümü</td>

        <td>izin verilmez</td>
        <td>izin verilir ama emekliye ayrılmış [deprecated] bir olanaktır</td>
        </tr>

        </tbody>
        </table>






Macros:
        SUBTITLE="const ve immutable Kavramları", Walter Bright

        DESCRIPTION=D'nin birbirlerini bütünleyen const ve immutable kavramları.

        KEYWORDS=d programlama dili makale d const immutable sabit değişmez
