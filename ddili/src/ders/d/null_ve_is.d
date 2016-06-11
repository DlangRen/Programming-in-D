Ddoc

$(DERS_BOLUMU $(IX null) $(IX is, işleç) $(IX !is) $(CH4 null) Değeri ve $(CH4 is) İşleci)

$(P
Önceki bölümlerde gördüğümüz gibi, referans türünden olan değişkenler hiçbir nesneye erişim sağlamadan da oluşturulabilirler:
)

---
    BirSınıf erişimSağlayan = new BirSınıf;

    BirSınıf değişken;  // erişim sağlamayan
---

$(P
Bir referans türü olduğu için yukarıdaki $(C değişken)'in bir kimliği vardır; ama erişim sağladığı bir nesne henüz yoktur. Böyle bir değişkenin bellekte şu şekilde durduğunu düşünebiliriz:
)

$(MONO
      değişken
   ───┬──────┬───
      │ null │
   ───┴──────┴───
)

$(P
Hiçbir nesneye erişim sağlamayan referansların değerleri $(C null)'dır. Bunu aşağıda anlatıyorum.
)

$(P
Böyle bir değişken kendisine bir nesne atanana kadar kullanılamaz bir durumdadır. Doğal olarak, erişim sağladığı bir $(C BirSınıf) nesnesi olmadığı için o değişken ile işlemler yapmamız beklenemez:
)

---
import std.stdio;

class BirSınıf {
    int üye;
}

void kullan(BirSınıf değişken) {
    writeln(değişken.üye);    $(CODE_NOTE_WRONG HATA)
}

void main() {
    BirSınıf değişken;
    kullan(değişken);
}
---

$(P
$(C kullan) işlevine verilen değişken hiçbir nesneye erişim sağlamadığından, olmayan nesnenin $(C üye)'sine erişilmeye çalışılması programın çökmesine neden olur:
)

$(SHELL
$ ./deneme
$(DARK_GRAY Segmentation fault)
)

$(P
$(IX segmentation fault) "Segmentation fault", programın geçerli olmayan bir bellek bölgesine erişmeye çalıştığı için işletim sistemi tarafından acil olarak sonlandırıldığını gösterir.
)

$(H5 $(C null) değeri)

$(P
Erişim sağladığı nesne henüz belli olmayan referans türü değişkenleri $(C null) özel değerine sahiptir. Bu değeri de herhangi başka bir değer gibi yazdırabiliriz:
)

---
    writeln(null);
---

$(P
Çıktısı:
)

$(SHELL
null
)

$(P
Değeri $(C null) olan bir değişken çok kısıtlı sayıda işlemde kullanılabilir:
)

$(OL
$(LI Erişim sağlaması için geçerli bir nesne atamak

---
    değişken = new BirSınıf;  // artık nesnesi var
---

$(P
O atamadan sonra artık $(C değişken)'in erişim sağladığı bir nesne vardır. $(C değişken) artık $(C BirSınıf) işlemleri için kullanılabilir.
)

)

$(LI $(C null) olup olmadığını denetlemek

---
    if (değişken == null)     $(DERLEME_HATASI)
---

$(P
Ne yazık ki, $(C ==) işleci asıl nesneleri karşılaştırdığı için; ve $(C null) bir değişkenin eriştirdiği geçerli bir nesne olmadığı için, o ifade derlenemez.
)

$(P
Bu yüzden, bir değişkenin $(C null) olup olmadığını denetlemek için $(C is) işleci kullanılır.
)

)

)

$(H5 $(C is) işleci)

$(P
$(C is), İngilizce'de "olmak" fiilinin "öyledir" kullanımındaki anlamına sahiptir. Bu bölümü ilgilendiren kullanımında ikili bir işleçtir, yani sol ve sağ tarafına iki değer alır. Bu iki değer aynıysa $(C true), değilse $(C false) üretir.
)

$(P $(I Not: $(C is)'in örneğin şablon olanağında tekli işleç olarak kullanıldığı durumlar da vardır.)
)

$(P
İki değerden birisinin $(C null) olabildiği durumlarda $(C ==) işlecinin kullanılamadığını yukarıda gördük. Onun yerine $(C is)'i kullanmak gerekir. "Bu değişken null ise" koşulunu denetlemeye yarar:
)

---
    if (değişken $(HILITE is) null) {
        // hiçbir nesneye erişim sağlamıyor
    }
---

$(P
$(C is), başka türlerle de kullanılabilir. Örneğin iki tamsayı değişkenin değerleri şöyle karşılaştırılabilir:
)

---
    if (hız is yeniHız) {
        // ikisi aynı değerde

    } else {
        // ikisi farklı değerde
    }
---

$(P
Dilimlerde de iki dilimin aynı elemanlara erişim sağlayıp sağlamadıklarını denetler:
)

---
    if (dilim is dilim2) {
        // aynı elemanları paylaşıyorlar
    }
---

$(H5 $(C !is) işleci)

$(P
$(C ==) ve $(C !=) işleçlerine benzer şekilde, $(C is)'in tersi $(C !is) işlecidir. Değerler eşit olmadığında $(C true) üretir:
)

---
    if (hız !is yeniHız) {
        // farklı değerlere sahipler
    }
---

$(H5 $(C null) değer atamak)

$(P
Referans türünden olan bir değişkene $(C null) değerini atamak, o değişkenin artık hiçbir nesneye erişim sağlamamasına neden olur.
)

$(P
Eğer bu atama sonucunda asıl nesneye erişen başka referans değişkeni kalmamışsa, asıl nesne çöp toplayıcı tarafından sonlandırılacaktır. Hiçbir referans tarafından erişilmiyor olması, o nesnenin artık kullanılmadığını gösterir.
)

$(P
Örnek olarak, $(LINK2 /ders/d/deger_referans.html, önceki bir bölümde) gördüğümüz iki değişkenin aynı nesneye eriştikleri duruma bakalım:
)

---
    auto değişken = new BirSınıf;
    auto değişken2 = değişken;
---

$(MONO
  (isimsiz BirSınıf nesnesi)    değişken    değişken2
 ───┬───────────────────┬───  ───┬───┬───  ───┬───┬───
    │        ...        │        │ o │        │ o │
 ───┴───────────────────┴───  ───┴─│─┴───  ───┴─│─┴───
              ▲                    │            │
              │                    │            │
              └────────────────────┴────────────┘
)

$(P
Bu değişkenlerden birisine $(C null) atamak, onun bu değerle ilişkisini keser:
)

---
    değişken = null;
---

$(P
$(C BirSınıf) nesnesine artık yalnızca $(C değişken2) tarafından erişilmektedir:
)

$(MONO
  (isimsiz BirSınıf nesnesi)    değişken     değişken2
 ───┬───────────────────┬───  ───┬────┬───  ───┬───┬───
    │        ...        │        │null│        │ o │
 ───┴───────────────────┴───  ───┴────┴───  ───┴─│─┴───
              ▲                                  │
              │                                  │
              └──────────────────────────────────┘
)

$(P
İsimsiz $(C BirSınıf) nesnesine erişen son referans olan $(C değişken2)'ye de $(C null) atanması, asıl nesnenin sonlanmasına neden olur:
)

---
    değişken2 = null;
---

$(P
Çöp toplayıcı asıl nesneyi türüne göre ya hemen, ya da ilerideki bir zamanda sonlandıracaktır. Program açısından artık o nesne yoktur çünkü o nesneye erişen referans kalmamıştır:
)

$(MONO
                                değişken      değişken2
 ───┬───────────────────┬───  ───┬────┬───  ───┬────┬───
    │                   │        │null│        │null│
 ───┴───────────────────┴───  ───┴────┴───  ───┴────┴──
)

$(P
$(LINK2 /ders/d/esleme_tablolari.html, Eşleme tabloları bölümünün) birinci problemi, bir eşleme tablosunu boşaltan üç yöntem gösteriyordu. Şimdi o yöntemlere bir dördüncüsünü ekleyebiliriz; eşleme tablosu değişkenine $(C null) değer atamak, değişkenin erişim sağladığı asıl tablo ile ilişkisini keser:
)

---
    string[int] isimleSayılar;
    // ...
    isimleSayılar = null;     // artık hiçbir elemana erişim
                              // sağlamaz
---

$(P
Yukarıdaki $(C BirSınıf) örneğine benzer şekilde, eğer $(C isimleSayılar) asıl tabloya erişim sağlayan son referans idiyse, asıl tablonun elemanları çöp toplayıcı tarafından sonlandırılacaklardır.
)

$(P
Bir dilimin de artık hiçbir elemana erişim sağlaması istenmiyorsa $(C null) atanabilir:
)

---
    int[] dilim = dizi[ 10 .. 20 ];
    // ...
    dilim = null;     // artık hiçbir elemana erişim sağlamaz
---

$(H5 Özet)

$(UL
$(LI $(C null), hiçbir değere erişim sağlamayan referans değeridir)
$(LI $(C null) referanslar yalnızca iki işlemde kullanılabilirler: değer atamak, $(C null) olup olmadığını denetlemek)
$(LI $(C ==) işleci asıl nesneye erişmeyi gerektirebileceği için, $(C null) olma olasılığı bulunan referanslar $(C is) ile denetlenmelidir)
$(LI $(C is)'in tersi $(C !is)'dir)
$(LI $(C null) atanan referans artık hiçbir elemana erişim sağlamaz)
$(LI Hiçbir referansın erişim sağlamadığı nesneler çöp toplayıcı tarafından sonlandırılırlar)
)

Macros:
        SUBTITLE=null ve is

        DESCRIPTION=D dilinde hiçbir nesneye erişim sağlamayan değer null, ve bu değeri denetleyen is ve !is işleçleri.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial nesne referans türü null is !is

SOZLER=
$(cokme)
$(cop_toplayici)
$(deger_turu)
$(dilim)
$(esleme_tablosu)
$(nesne)
$(referans_turu)
$(sonlandirici)
$(sablon)
