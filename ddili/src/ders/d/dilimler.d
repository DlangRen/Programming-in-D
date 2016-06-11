Ddoc

$(DERS_BOLUMU $(IX dilim) $(IX dizi) Başka Dizi Olanakları)

$(P
Elemanları bir araya getirmeye yarayan dizileri $(LINK2 /ders/d/diziler.html, Diziler bölümünde) görmüştük. O bölümü kısa tutmak için özellikle sonraya bıraktığım başka dizi olanaklarını burada göstereceğim.
)

$(P
Ama önce karışıklığa neden olabileceğini düşündüğüm bazı terimleri listelemek istiyorum:
)

$(UL

$(LI $(B Dizi:) Yan yana duran ve sıra numarasıyla erişilen elemanlardan oluşan topluluktur; bundan başkaca anlam taşımaz.
)

$(LI
$(B Sabit uzunluklu dizi (statik dizi):) Eleman adedi değiştirilemeyen dizidir; kendi elemanlarına sahiptir.
)

$(LI
$(B Dinamik dizi:) Eleman adedi değiştirilebilen dizidir; kendi elemanları yoktur, sahip olmadığı elemanlara erişim sağlar.
)

$(LI $(B Dilim:) Dinamik dizilerin başka bir ismidir.
)

)

$(P
Bu bölümde özellikle $(I dilim) dediğim zaman dilimleri (yani dinamik dizileri), yalnızca $(I dizi) dediğim zaman da fark gözetmeden dilimleri ve sabit uzunluklu dizileri kasdetmiş olacağım.
)

$(H5 Dilimler)

$(P
Dilimler aslında dinamik dizilerle aynı olanaktır. Bu olanağa; dizi gibi kullanılabilme özelliği nedeniyle bazen $(I dinamik dizi), başka dizinin bir parçasına erişim sağlama özelliği nedeniyle de bazen $(I dilim) denir. Var olan başka bir dizinin elemanlarının bir bölümünü sanki daha küçük farklı bir diziymiş gibi kullandırmaya yarar.
)

$(P
$(IX .., dilim elemanı aralığı) Dilimler, elemanları bir başlangıç indeksinden bir bitiş indeksine kadar belirlemeye yarayan $(I aralık) söz dizimiyle tanımlanırlar:
)

---
  $(I aralığın_başı) .. $(I aralığın_sonundan_bir_sonrası)
---

$(P
Başlangıç indeksi aralığa dahildir; bitiş indeksi aralığın dışındadır:
)

---
/* ... */ = ayGünleri[0 .. 3];  // 0, 1, ve 2 dahil; 3 hariç
---

$(P $(I Not: Burada anlatılan aralıklar Phobos kütüphanesinin aralık kavramından farklıdır. Sınıf ve yapı arayüzleriyle ilgili olan Phobos aralıklarını daha ilerideki bir bölümde göstereceğim.
))

$(P
Örnek olarak $(C ayGünleri) dizisini dörde $(I dilimleyerek) birbirinden farklı dört çeyrek diziymiş gibi şöyle kullanabiliriz:
)

---
    int[12] ayGünleri =
        [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

    int[] ilkÇeyrek    = ayGünleri[0 .. 3];
    int[] ikinciÇeyrek = ayGünleri[3 .. 6];
    int[] üçüncüÇeyrek = ayGünleri[6 .. 9];
    int[] sonÇeyrek    = ayGünleri[9 .. 12];
---

$(P
O kodda tanımlanan son dört değişken dilimdir; her birisi asıl dizinin dört değişik bölgesine erişim sağlamaktadır. Buradaki önemli nokta, o dilimlerin kendilerine ait elemanlarının bulunmadığıdır. Onlar asıl dizinin elemanlarına erişim sağlarlar. Bir dilimdeki bir elemanın değiştirilmesi asıl dizideki asıl elemanı etkiler. Bunu görmek için dört çeyreğin ilk elemanlarına dört farklı değer verelim ve asıl diziyi yazdıralım:
)

---
    ilkÇeyrek[0] =    1;
    ikinciÇeyrek[0] = 2;
    üçüncüÇeyrek[0] = 3;
    sonÇeyrek[0] =    4;

    writeln(ayGünleri);
---

$(P
Değişen elemanları sarıyla gösteriyorum:
)

$(SHELL
[$(HILITE 1), 28, 31, $(HILITE 2), 31, 30, $(HILITE 3), 31, 30, $(HILITE 4), 30, 31]
)

$(P
Dikkat ederseniz, her dilim kendisinin 0 numaralı elemanını değiştirdiğinde o dilimin asıl dizide erişim sağladığı ilk eleman değişmiştir.
)

$(P
Dizi indekslerinin 0'dan başladıklarını ve dizinin uzunluğundan bir eksiğine kadar olduklarını daha önce görmüştük. Örneğin 3 elemanlı bir dizinin yasal indeksleri 0, 1, ve 2'dir. Dilim söz diziminde bitiş indeksi $(I aralığın sonundan bir sonrası) anlamına gelir. Bu yüzden, dizinin son elemanını da aralığa dahil etmek gerektiğinde ikinci indeks olarak dizinin uzunluğu kullanılır. Örneğin uzunluğu 3 olan bir dizinin bütün elemanlarına erişim sağlamak için $(C dizi[0..3]) yazılır.
)

$(P
Aralık söz dizimindeki doğal bir kısıtlama, başlangıç indeksinin bitiş indeksinden büyük olamayacağıdır:
)

---
    int[3] dizi = [ 0, 1, 2 ];
    int[] dilim = dizi[2 .. 1];  // ← çalışma zamanı HATASI
---

$(P
Başlangıç indeksinin bitiş indeksine eşit olması ise yasaldır ve $(I boş dilim) anlamına gelir:
)

---
    int[] dilim = birDizi[indeks .. indeks];
    writeln("Dilimin uzunluğu: ", dilim.length);
---

$(P
$(C indeks)'in yasal bir indeks değeri olduğunu kabul edersek, çıktısı:
)

$(SHELL
Dilimin uzunluğu: 0
)

$(H5 $(C dizi.length) yerine $(C $))

$(P
$(IX $, dilim uzunluğu) Dizi elemanlarını $(C []) işleci ile indekslerken bazen dizinin uzunluğundan da yararlanmak gerekebilir. Bu konuda kolaylık olarak ve yalnızca $(C []) işleci içindeyken, $(C dizi.length) yazmak yerine kısaca $(C $) karakteri kullanılabilir:
)

---
    writeln(dizi[dizi.length - 1]);   // dizinin son elemanı
    writeln(dizi[$ - 1]);             // aynı şey
---

$(H5 Kopyasını almak için $(C .dup))

$(P
$(IX .dup) $(IX kopyalama, dizi) $(IX dizi kopyalama) İsmi "kopyala" anlamına gelen "duplicate"in kısası olan $(C .dup) niteliği, var olan bir dizinin elemanlarının kopyasından oluşan yeni bir dizi üretir:
)

---
    double[] dizi = [ 1.25, 3.75 ];
    double[] kopyası = dizi.dup;
---

$(P
Bir örnek olarak Şubat'ın 29 gün çektiği senelerdeki ayların gün sayılarını tutan bir dizi oluşturmak isteyelim. Bir yöntem, önce normal senelerdeki $(C ayGünleri)'nin bir kopyasını almak ve o kopya dizideki Şubat'ın gün sayısını bir arttırmaktır:
)

---
import std.stdio;

void main() {
    int[12] ayGünleri =
        [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

    int[] artıkYıl = ayGünleri$(HILITE .dup);

    ++artıkYıl[1];   // yeni dizideki Şubat'ın gün sayısını
                     // arttırır

    writeln("Normal: ", ayGünleri);
    writeln("Artık : ", artıkYıl);
}
---

$(P
Çıktısı:
)

$(SHELL_SMALL
Normal: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
Artık : [31, $(HILITE 29), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
)

$(H5 $(IX atama, dilim ve dizi) Atama işlemi)

$(P
$(I Değerini değiştirme) olarak bildiğimiz atama işlemi, sabit uzunluklu dizilerde de aynı anlamdadır; elemanların değerleri değişir:
)

---
    int[3] a = [ 1, 1, 1 ];
    int[3] b = [ 2, 2, 2 ];

    a = b;        // a'nın elemanları da 2 olur
    writeln(a);
---

$(P
Çıktısı:
)

$(SHELL
[2, 2, 2]
)

$(P
Dilimlerle kullanıldığında ise atama işleminin anlamı çok farklıdır: Dilimin, erişim sağlamakta olduğu elemanları bırakmasına ve yeni elemanlara erişim sağlamaya başlamasına neden olur:
)

---
    int[] tekler = [ 1, 3, 5, 7, 9, 11 ];
    int[] çiftler = [ 2, 4, 6, 8, 10 ];

    int[] dilim;     // henüz hiçbir elemana erişim sağlamıyor

    $(HILITE dilim = )tekler[2 .. $ - 2];
    writeln(dilim);

    $(HILITE dilim = )çiftler[1 .. $ - 1];
    writeln(dilim);
---

$(P
Yukarıdaki koddaki $(C dilim) başlangıçta hiçbir dizinin elemanına erişim sağlamazken önce $(C tekler)'in bazı elemanlarına, sonra da $(C çiftler)'in bazı elemanlarına erişim sağlar:
)

$(SHELL
[5, 7]
[4, 6, 8]
)

$(H5 Uzunluğun artması paylaşımı sonlandırabilir)

$(P
Sabit dizilere eleman eklenemediği için bu konu yalnızca dilimlerle ilgilidir.
)

$(P
Aynı elemana aynı anda birden fazla dilimle erişilebilir. Örneğin aşağıdaki sekiz elemanın ilk ikisi üç dilim tarafından paylaşılmaktadır:
)

---
import std.stdio;

void main() {
    int[] dilim = [ 1, 3, 5, 7, 9, 11, 13, 15 ];
    int[] yarısı = dilim[0 .. $ / 2];
    int[] çeyreği = dilim[0 .. $ / 4];

    çeyreği[1] = 0;    // tek dilimde değişiklik

    writeln(çeyreği);
    writeln(yarısı);
    writeln(dilim);
}
---

$(P
$(C çeyreği) diliminin ikinci elemanında yapılan değişiklik asıl elemanı değiştirdiği için, bu etki dilimlerin hepsi tarafından görülür:
)

$(SHELL
[1, $(HILITE 0)]
[1, $(HILITE 0), 5, 7]
[1, $(HILITE 0), 5, 7, 9, 11, 13, 15]
)

$(P
Bu açıdan bakıldığında dilimlerin elemanlara $(I paylaşımlı) olarak erişim sağladıkları söylenebilir. Bu paylaşımın getirdiği bir soru işareti, dilimlerden birisine eleman eklendiğinde ne olacağıdır. Dilimler aynı asıl elemanlara erişim sağladıklarından, kısa olan dilime eklenecek elemanlar için yer yoktur. (Aksi taktirde, yeni elemanlar başka dilimlerin elemanları üzerine yazılırlar.)
)

$(P
$(IX eleman üzerine yazma) D, yeni eklenen bir elemanın başka dilimlerin üzerine yazılmasına izin vermez ve uzunluğun artması için yer bulunmadığında paylaşımı sona erdirir. Yeri olmayan dilim paylaşımdan ayrılır. Bu işlem sırasında o dilimin erişim sağlamakta olduğu bütün elemanlar otomatik olarak kopyalanırlar ve uzayan dilim artık bu yeni elemanlara erişim sağlamaya başlar.
)

$(P
Bunu görmek için yukarıdaki programdaki $(C çeyreği) diliminin elemanını değiştirmeden önce ona yeni bir eleman ekleyelim:
)

---
    çeyreği ~= 42;    // sonunda yeni elemana yer olmadığı
                      // için bu dilim bu noktada paylaşımdan
                      // ayrılır

    çeyreği[1] = 0;   // o yüzden bu işlem diğer dilimleri
                      // etkilemez
---

$(P
Eklenen eleman dilimin uzunluğunu arttırdığı için dilim artık kopyalanan yeni elemanlara erişim sağlamaya başlar. $(C çeyreği)'nin elemanında yapılan değişikliğin $(C dilim) ve $(C yarısı) dilimlerini artık etkilemediği programın şimdiki çıktısında görülüyor:
)

$(SHELL
[1, $(HILITE 0), 42]
[1, 3, 5, 7]
[1, 3, 5, 7, 9, 11, 13, 15]
)

$(P
Dilimin uzunluğunun açıkça arttırılması da eleman paylaşımından ayrılmasına neden olur:
)

---
    ++çeyreği.length;       // paylaşımdan ayrılır
---

$(P
veya
)

---
    çeyreği.length += 5;    // paylaşımdan ayrılır
---

$(P
Öte yandan, bir dilimin uzunluğunun kısaltılması eleman paylaşımını sonlandırmaz. Uzunluğun kısaltılması, yalnızca $(I artık daha az elemana erişim sağlama) anlamına gelir:
)

---
    int[] a = [ 1, 11, 111 ];
    int[] d = a;

    d = d[1 .. $];     // başından kısaltıyoruz
    d[0] = 42;         // elemanı dilim yoluyla değiştiriyoruz

    writeln(a);        // diğer dilimi yazdırıyoruz
---

$(P
Çıktısından görüldüğü gibi, $(C d) yoluyla yapılan değişiklik $(C a)'nın eriştirdiği elemanı da etkilemiştir; yani paylaşım devam etmektedir:
)

$(SHELL
[1, $(HILITE 42), 111]
)

$(P
Uzunluğun başka ifadeler yoluyla kısaltılması da paylaşımı sonlandırmaz:
)

---
    d = d[0 .. $ - 1];         // sonundan kısaltmak
    --d.length;                // aynı şey
    d.length = d.length - 1;   // aynı şey
---

$(P
Eleman paylaşımı devam eder.
)

$(H6 $(IX .capacity) $(IX sığa) $(IX kapasite) Paylaşımın sonlanıp sonlanmayacağını belirlemek için $(C capacity))

$(P
Bu konuda dikkat edilmesi gereken bir karışıklık, uzunluğun artmasının paylaşımı her zaman için sonlandırmamasıdır. En uzun olan dilimin sonunda yeni elemanlara yer bulunduğu zaman paylaşım sonlanmaz:
)

---
import std.stdio;

void main() {
    int[] dilim = [ 1, 3, 5, 7, 9, 11, 13, 15 ];
    int[] yarısı = dilim[0 .. $ / 2];
    int[] çeyreği = dilim[0 .. $ / 4];

    dilim ~= 42;      // en uzun dilime ekleniyor
    $(HILITE dilim[1] = 0);

    writeln(çeyreği);
    writeln(yarısı);
    writeln(dilim);
}
---

$(P
Çıktıda görüldüğü gibi, uzunluğu artmış olmasına rağmen en uzun olan dilime eleman eklenmesi paylaşımı sonlandırmamıştır. Yapılan değişiklik bütün dilimleri etkilemiştir:
)

$(SHELL
[1, $(HILITE 0)]
[1, $(HILITE 0), 5, 7]
[1, $(HILITE 0), 5, 7, 9, 11, 13, 15, 42]
)

$(P
Bir dilime yeni bir eleman eklendiğinde paylaşımın sonlanıp sonlanmayacağı $(C capacity) niteliği ile belirlenir. (Aslında $(C capacity) bir işlev olarak gerçekleştirilmiştir ancak bu ayrımın burada önemi yoktur.)
)

$(P
Dilime ileride eklenecek olan yeni elemanlar için önceden ayrılmış olan alana o dilimin $(I sığası) denir. $(C capacity) değerinin anlamı aşağıdaki gibidir:
)

$(UL

$(LI
Değeri 0 ise, bu dilim en uzun dilim değildir. Bu durumda yeni bir eleman eklendiğinde dilimin bütün elemanları başka yere kopyalanırlar ve paylaşım sonlanır.
)

$(LI
Değeri sıfırdan farklı ise bu en uzun dilimdir. Bu durumda $(C capacity)'nin anlamı, başka yere kopyalanmaları gerekmeden dilimin en fazla kaç eleman barındıracağıdır. Dilime eklenebilecek yeni eleman sayısı, $(C capacity)'den mevcut eleman adedi çıkartılarak bulunur. Dilimin uzunluğu $(C capacity) değerine eşit ise, bir eleman daha eklendiğinde elemanlar başka yere kopyalanacaklar demektir.
)

)

$(P
Buna uygun olarak, eleman eklendiğinde paylaşımın sonlanıp sonlanmayacağı aşağıdaki gibi bir kodla belirlenebilir:
)

---
    if (dilim.capacity == 0) {
        /* Yeni bir eleman eklendiğinde bu dilimin bütün
         * elemanları başka bir yere kopyalanacaklar
         * demektir. */

        // ...

    } else {
        /* Bu dilimde yeni elemanlar için yer olabilir. Kaç
         * elemanlık yer olduğunu hesaplayalım: */
        auto kaçElemanDaha = dilim.capacity - dilim.length;

        // ...
    }
---

$(P
Sığayla ilgili ilginç bir durum, $(I bütün elemanlara) erişim sağlayan birden fazla dilim olduğunda ortaya çıkar. Böyle bir durumda her dilim sığası olduğunu bildirir:
)

---
import std.stdio;

void main() {
    // Bütün elemanlara eriştiren üç dilim
    int[] d0 = [ 1, 2, 3, 4 ];
    int[] d1 = d0;
    int[] d2 = d0;

    writeln(d0.capacity);
    writeln(d1.capacity);
    writeln(d2.capacity);
}
---

$(P
Üçünün de sığası vardır:
)

$(SHELL
7
7
7
)

$(P
Ancak, dilimlerden birisine eleman eklendiği an diğerleri sığalarını yitirirler:
)

---
    $(HILITE d1 ~= 42);    $(CODE_NOTE artık d1 en uzundur)

    writeln(d0.capacity);
    writeln(d1.capacity);
    writeln(d2.capacity);
---

$(P
Eleman eklenen dilim en uzun dilim haline geldiğinden artık yalnızca onun sığası vardır:
)

$(SHELL
0
7        $(SHELL_NOTE artık yalnızca d1'in sığası var)
0
)

$(H6 $(IX .reserve) Elemanlar için yer ayırmak)

$(P
Hem eleman kopyalamanın hem de elemanlar için yeni yer ayırmanın az da olsa bir süre bedeli vardır. Bu yüzden, eleman eklemek pahalı bir işlem olabilir. Eleman adedinin baştan bilindiği durumlarda böyle bir bedelin önüne geçmek için tek seferde yer ayırmak mümkündür:
)

---
import std.stdio;

void main() {
    int[] dilim;

    dilim$(HILITE .reserve(20));
    writeln(dilim.capacity);

    foreach (eleman; 0 .. $(HILITE 17)) {
        dilim ~= eleman;    $(CODE_NOTE bu elemanlar taşınmazlar)
    }
}
---

$(SHELL
31        $(SHELL_NOTE En az 20 elemanlık sığa)
)

$(P
$(C dilim)'in elemanları ancak 31'den fazla eleman olduğunda başka bir yere taşınacaklardır.
)

$(H5 $(IX bütün elemanlar üzerinde işlem) $(IX eleman, hepsi ile işlem) Bütün elemanlar üzerindeki işlemler)

$(P
Bu olanak hem sabit uzunluklu dizilerle hem de dilimlerle kullanılabilir.
)

$(P
Dizi isminden sonra yazılan içi boş $(C []) karakterleri $(I bütün elemanlar) anlamına gelir. Bu olanak, elemanların her birisiyle yapılması istenen işlemlerde büyük kolaylık sağlar.
)

$(P
$(I Not: Bu bölümdeki kodların en son denendikleri derleyici olan dmd 2.071 bu işlemleri henüz dilimler için tam olarak desteklemiyordu. O yüzden, bu başlık altındaki bazı örneklerde yalnızca sabit uzunluklu diziler kullanılmaktadır.)
)

---
import std.stdio;

void main() {
    double[3] a = [ 10, 20, 30 ];
    double[3] b = [  2,  3,  4 ];

    double[3] sonuç = $(HILITE a[] + b[]);

    writeln(sonuç);
}
---

$(P
Çıktısı:
)

$(SHELL
[12, 23, 34]
)

$(P
O programdaki toplama işlemi, $(C a) ve $(C b) dizilerinin birbirlerine karşılık gelen elemanlarını ayrı ayrı toplar: önce ilk elemanlar kendi aralarında, sonra ikinci elemanlar kendi aralarında, vs. O yüzden böyle işlemlerde kullanılan dizilerin uzunluklarının eşit olmaları şarttır.
)

$(P
Yukarıdaki programdaki $(C +) işleci yerine; daha önce gördüğünüz $(C +), $(C -), $(C *), $(C /), $(C %), ve $(C ^^) aritmetik işleçlerini; ilerideki bölümlerde karşılaşacağınız $(C ^), $(C &), ve $(C |) ikili bit işleçlerini; ve bir dizinin önüne yazılan tekli $(C -) ve $(C ~) işleçlerini kullanabilirsiniz.
)

$(P
Bu işleçlerin atamalı olanları da kullanılabilir: $(C =), $(C +=), $(C -=), $(C *=), $(C /=), $(C %=), $(C ^^=), $(C ^=), $(C &=), ve $(C |=).
)

$(P
Bu olanak yalnızca iki diziyi ilgilendiren işlemler için değildir; bir dizi yanında onun elemanlarıyla uyumlu olan bir ifade de kullanılabilir. Örneğin bir dizinin bütün elemanlarını dörde bölmek için:
)

---
    double[3] a = [ 10, 20, 30 ];
    $(HILITE a[]) /= 4;

    writeln(a);
---

$(P
Çıktısı:
)

$(SHELL
[2.5, 5, 7.5]
)

$(P
Bütün elemanlarını belirli bir değere eşitlemek için:
)

---
    $(HILITE a[]) = 42;
    writeln(a);
---

$(P
Çıktısı:
)

$(SHELL
[42, 42, 42]
)

$(P
Bu olanağın dilimlerle kullanımında hataya açık bir durum vardır. Sonuçta eleman değerlerinde bir fark görülmese bile aşağıdaki iki ifade aslında anlamsal açıdan çok farklıdır:
)

---
    dilim2 = dilim1;      // ← dilim1'in elemanlarına erişim
                          //   sağlamaya başlar

    dilim3[] = dilim1;    // ← zaten erişim sağlamakta olduğu
                          //   elemanların değerleri değişir
---

$(P
$(C dilim2)'nin doğrudan atama işleciyle kullanılıyor olması, onun artık $(C dilim1)'in elemanlarına erişim sağlamaya başlamasına neden olur. Oysa $(C dilim3[]) ifadesi $(I dilim3'ün bütün elemanları) anlamını taşıdığı için, onun bütün elemanlarının değerleri $(C dilim1)'in elemanlarının değerlerini alırlar. Bu yüzden, unutulan bir $(C []) işlecinin etkisi çok büyük olabilir.
)

$(P
Bunu aşağıdaki programda görebiliriz:
)

---
import std.stdio;

void main() {
    double[] dilim1 = [ 1, 1, 1 ];
    double[] dilim2 = [ 2, 2, 2 ];
    double[] dilim3 = [ 3, 3, 3 ];

    dilim2 = dilim1;      // ← dilim1'in elemanlarına erişim
                          //   sağlamaya başlar

    dilim3[] = dilim1;    // ← zaten erişim sağlamakta olduğu
                          //   elemanların değerleri değişir

    writeln("dilim1 önce : ", dilim1);
    writeln("dilim2 önce : ", dilim2);
    writeln("dilim3 önce : ", dilim3);

    $(HILITE dilim2[0] = 42);       // ← erişimini dilim1'le paylaşmakta
                          //   olduğu eleman değişir

    dilim3[0] = 43;       // ← kendi elemanı değişir

    writeln("dilim1 sonra: ", dilim1);
    writeln("dilim2 sonra: ", dilim2);
    writeln("dilim3 sonra: ", dilim3);
}
---

$(P
$(C dilim2)'de yapılan değişiklik $(C dilim1)'i de etkilemiştir:
)

$(SHELL
dilim1 önce : [1, 1, 1]
dilim2 önce : [1, 1, 1]
dilim3 önce : [1, 1, 1]
dilim1 sonra: [$(HILITE 42), 1, 1]
dilim2 sonra: [$(HILITE 42), 1, 1]
dilim3 sonra: [43, 1, 1]
)

$(P
Buradaki tehlike; $(C dilim2) atanırken $(C []) işlecinin belki de unutulmuş olmasının etkisinin, belki de o yüzden istenmeden paylaşılmaya başlanmış olan eleman değişene kadar farkedilememiş olmasıdır.
)

$(P
Bu gibi tehlikeler yüzünden bu işlemleri dilimlerle kullanırken dikkatli olmak gerekir.
)

$(H5 $(IX çok boyutlu dizi) Çok boyutlu diziler)

$(P
Şimdiye kadar gördüğümüz dizi işlemlerinde eleman türü olarak hep $(C int) ve $(C double) gibi temel türler kullandık. Eleman türü olarak aslında başka türler, örneğin diziler de kullanılabilir. Böylece $(I dizi dizisi) gibi daha karmaşık topluluklar tanımlayabiliriz. Elemanlarının türü dizi olan dizilere $(I çok boyutlu dizi) denir.
)

$(P
Şimdiye kadar gördüğümüz dizilerin elemanlarını hep soldan sağa doğru yazmıştık. İki boyutlu dizi kavramını anlamayı kolaylaştırmak için bir diziyi bir kere de yukarıdan aşağıya doğru yazalım:
)

---
    int[] dizi = [
                   10,
                   20,
                   30,
                   40
                 ];
---

$(P
Kodu güzelleştirmek için kullanılan boşlukların ve fazladan satırların derleyicinin gözünde etkisiz olduklarını biliyorsunuz. Yukarıdaki dizi önceden olduğu gibi tek satırda da yazılabilirdi ve aynı anlama gelirdi.
)

$(P
Şimdi o dizinin her bir elemanını $(C int[]) türünde bir değerle değiştirelim:
)

---
  /* ... */ dizi = [
                     [ 10, 11, 12 ],
                     [ 20, 21, 22 ],
                     [ 30, 31, 32 ],
                     [ 40, 41, 42 ]
                   ];
---

$(P
Yaptığımız tek değişiklik, $(C int) yerine $(C int[]) türünde elemanlar yazmak oldu. Kodun yasal olması için eleman türünü artık $(C int) olarak değil, $(C int[]) olarak belirlememiz gerekir:
)

---
    $(HILITE int[])[] dizi = [
                     [ 10, 11, 12 ],
                     [ 20, 21, 22 ],
                     [ 30, 31, 32 ],
                     [ 40, 41, 42 ]
                   ];
---

$(P
Satır ve sütunlardan oluştukları için yukarıdaki gibi dizilere $(I iki boyutlu dizi) denir.
)

$(P
Elemanları $(I int dizisi) olan yukarıdaki dizinin kullanımı şimdiye kadar öğrendiklerimizden farklı değildir. Her bir elemanının $(C int[]) türünde olduğunu hatırlamak ve $(C int[]) türüne uyan işlemlerde kullanmak yeter:
)

---
dizi ~= [ 50, 51 ]; // yeni bir eleman (yani dilim) ekler
dizi[0] ~= 13;      // ilk elemanına (yani ilk dilimine) ekler
---

$(P
Aynı dizinin şimdiki hali:
)

$(SHELL_SMALL
[[10, 11, 12, $(HILITE 13)], [20, 21, 22], [30, 31, 32], [40, 41, 42], $(HILITE [50, 51])]
)

$(P
Dizinin kendisi veya elemanları sabit uzunluklu da olabilir:
)

---
    int[2][3][4] dizi;  // 2 sütun, 3 satır, 4 düzlem
---

$(P
Yukarıdaki tanımı $(I iki sütunlu üç satırdan oluşan dört düzlem) diye düşünebilirsiniz. Öyle bir dizi, örneğin bir macera oyununda ve her katında 2x3=6 oda bulunan 4 katlı bir bina ile ilgili bir kavram için kullanılıyor olabilir.
)

$(P
Örneğin öyle bir binanın ikinci katının ilk odasında bulunan eşyaların sayısı şöyle arttırılabilir:
)

---
    // ikinci katın indeksi 1'dir ve o katın ilk odasına
    // [0][0] ile erişilir
    ++eşyaSayıları[1][0][0];
---

$(P
Yukarıdaki söz dizimlerine ek olarak, $(I dilim dilimi) oluşturmak için $(C new) ifadesi de kullanılabilir. Aşağıdaki örnek yalnızca iki boyut belirtiyor:
)

---
import std.stdio;

void main() {
    int[][] d = new int[][](2, 3);
    writeln(d);
}
---

$(P
Yukarıdaki $(C new) ifadesi 2 adet 3 elemanlı dizi oluşturur ve onlara erişim sağlayan bir dilim döndürür. Çıktısı:
)

$(SHELL
[[0, 0, 0], [0, 0, 0]]
)

$(H5 Özet)

$(UL

$(LI
Sabit uzunluklu dizilerin kendi elemanları vardır; dilimler ise kendilerine ait olmayan elemanlara erişim sağlarlar.
)

$(LI
$(C []) işleci içindeyken $(C $(I dizi_ismi).length) yazmak yerine kısaca $(C $) yazılabilir.
)

$(LI
$(C .dup) niteliği, elemanların kopyalarından oluşan yeni bir dizi üretir.
)

$(LI
Atama işlemi, sabit dizilerde eleman değerlerini değiştirir; dilimlerde ise başka elemanlara erişim sağlanmasına neden olur.
)

$(LI
Uzayan dilim paylaşımdan $(I ayrılabilir) ve yeni kopyalanmış olan elemanlara erişim sağlamaya başlayabilir. Bunun olup olmayacağı $(C capacity()) ile belirlenir.
)

$(LI
$(C dizi[]) yazımı $(I dizinin bütün elemanları) anlamına gelir; kendisine uygulanan işlem her bir elemanına ayrı ayrı uygulanır.
)

$(LI
Elemanları dizi olan dizilere çok boyutlu dizi denir.
)

)

$(PROBLEM_TEK

$(P
Bir $(C double) dizisini başından sonuna doğru ilerleyin ve değerleri 10'dan büyük olanların değerlerini yarıya indirin. Örneğin elinizde şu dizi varsa:
)

---
    double[] dizi = [ 1, 20, 2, 30, 7, 11 ];
---

$(P
elemanlarının değerleri şuna dönüşsün:
)

$(SHELL
[1, $(HILITE 10), 2, $(HILITE 15), 7, $(HILITE 5.5)]
)

$(P
Çeşitli çözümleri olsa da, bunu yalnızca dilim olanakları ile başarmaya çalışın. İşe bütün diziye erişim sağlayan bir dilimle başlayabilirsiniz. Ondan sonra o dilimi her seferinde baş tarafından tek eleman kısaltabilir ve dilimin hep ilk elemanını kullanabilirsiniz.
)

$(P
Şu ifade dilimi başından tek eleman kısaltır:
)

---
        dilim = dilim[1 .. $];
---

)

Macros:
        SUBTITLE=Başka Dizi Olanakları

        DESCRIPTION=D dilim ve dizilerinin tanıtılması

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial dizgi dilim

SOZLER=
$(aralik)
$(atama)
$(dilim)
$(dinamik)
$(dizi)
$(ifade)
$(indeks)
$(nitelik)
$(phobos)
$(referans)
$(siga)
$(topluluk)
