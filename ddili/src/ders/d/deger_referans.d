Ddoc

$(DERS_BOLUMU $(IX değer türü) $(IX referans türü) Değerler ve Referanslar)

$(P
Değer türü ile referans türü arasındaki fark, özellikle daha sonra göreceğimiz yapıları ve sınıfları anlamada yararlı olacak.
)

$(P
Bu bölümde ayrıca değişkenlerin adreslerini bildiren $(C &) işlecini de tanıtacağım.
)

$(P
En sonda da şu iki önemli kavramı gösteren bir tablo vereceğim:
)

$(UL
$(LI değer karşılaştırması)
$(LI adres karşılaştırması)
)

$(H5 Değer türü)

$(P
Bunun tanımı son derece basittir: Değişkenleri değer taşıyan türlere değer türü denir. Örneğin bütün tamsayı ve kesirli sayı türleri değer türleridir çünkü bu türlerden olan her değişkenin kendi değeri vardır. Pek açık olmasa da sabit uzunluklu diziler de değer türleridir.
)

$(P
Örneğin, $(C int) türünden olan bir değişken bir tamsayı değer taşır:
)

---
    int hız = 123;
---

$(P
$(C hız) değişkeninin büyüklüğü $(C int)'in büyüklüğü olan 4 bayttır. Belleği soldan sağa doğru bir şerit halinde devam ediyormuş gibi gösterirsek, o değişkenin bellekte şu şekilde yaşadığını düşünebiliriz:
)

$(MONO
        hız
   ───┬─────┬───
      │ 123 │
   ───┴─────┴───
)

$(P
Değer türlerinin değişkenleri kopyalandıklarında kendi özel değerlerini edinirler:
)

---
    int yeniHız = hız;
---

$(P
Yeni değişkene bellekte kendisine ait bir yer ayrılır ve $(C yeniHız)'ın da kendi değeri olur:
)

$(MONO
        hız           yeniHız
   ───┬─────┬───   ───┬─────┬───
      │ 123 │         │ 123 │
   ───┴─────┴───   ───┴─────┴───
)

$(P
Doğal olarak, artık bu değişkenlerde yapılan değişiklikler birbirlerinden bağımsızdır:
)

---
    hız = 200;
---

$(P
Diğer değişkenin değeri değişmez:
)

$(MONO
        hız           yeniHız
   ───┬─────┬───   ───┬─────┬───
      │ 200 │         │ 123 │
   ───┴─────┴───   ───┴─────┴───
)

$(H6 $(C assert) hatırlatması)

$(P
Bu bölümde kavramların doğruluklarını göstermek için $(LINK2 /ders/d/assert.html, $(C assert) ve $(C enforce) bölümünde) gördüğümüz $(C assert) denetimlerinden yararlanacağım. Aşağıdaki örneklerde kullandığım $(C assert) denetimlerini "bu doğrudur" demişim gibi kabul edin.
)

$(P
Örneğin aşağıdaki $(C assert(hız == yeniHız)) ifadesi, "hız, yeniHız'a eşittir" anlamına geliyor.
)

$(H6 Değer kimliği)

$(P
Yukarıdaki gösterimlerden de anlaşılabileceği gibi, değişkenlerin eşitlikleri iki anlamda ele alınabilir:
)

$(UL
$(LI $(B Değer eşitliği): Şimdiye kadar bir çok örnekte kullandığımız $(C ==) işleci, değişkenlerin değerlerini karşılaştırır. Birbirlerinden farklı olan iki değişkenin bu açıdan $(I eşit olmaları), onların değerlerinin eşit olmaları anlamına gelir.
)
$(LI $(B Değer kimliği): Kendi değerlerine sahip olmaları açısından bakıldığında, $(C hız) ve $(C yeniHız)'ın ayrı kimlikleri vardır. Değerleri eşit olsalar bile, birisinde yapılan değişiklik diğerini etkilemez.
)

)


---
    int hız = 123;
    int yeniHız = hız;
    assert(hız == yeniHız);
    hız = 200;
    assert(hız != yeniHız);
---

$(H6 Adres alma işleci $(C &))

$(P
Daha önce $(C readf) kullanımında gördüğümüz gibi, bu işleç değişkenin adresini döndürür. Okuduğu bilgiyi hangi değişkene yazacağını $(C readf)'e o değişkenin adresini vererek bildiriyorduk.
)

$(P
Değişkenlerin adreslerini başka amaçlar için de kullanabiliriz. Bir örnek olarak iki farklı değişkenin adresini yazdıran bir kod şöyle yazılabilir:
)

---
    int hız = 123;
    int yeniHız = hız;

    writeln("hız    : ", hız,     " adresi: ", $(HILITE &)hız);
    writeln("yeniHız: ", yeniHız, " adresi: ", $(HILITE &)yeniHız);
---

$(P
$(C hız) ve $(C yeniHız) değişkenlerinin değerleri aynıdır, ama yukarıda da gösterildiği gibi bu değerler belleğin farklı adreslerinde bulunmaktadırlar:
)

$(SHELL
hız    : 123 adresi: BF9A78F0
yeniHız: 123 adresi: BF9A78F4
)

$(P $(I Not: Programı her çalıştırdığınızda farklı adresler görmeniz normaldir. Bu değişkenler işletim sisteminden alınan belleğin boş yerlerine yerleştirilirler.)
)

$(P
Değişken adresleri normalde on altılı sayı sisteminde yazdırılır.
)

$(P
Ayrıca, adreslerin $(C int)'in uzunluğu olan 4 kadar farklı olmalarına bakarak o değişkenlerin bellekte yan yana durduklarını da anlayabiliriz.
)

$(H5 $(IX değişken, referans) Referans değişkenleri)

$(P
$(I Referans türlerini) anlatmaya geçmeden önce referans değişkenlerini tanıtmam gerekiyor.
)

$(P
Referans değişkenleri, başka değişkenlerin takma isimleri gibi kullanılan değişkenlerdir. Her ne kadar kendileri değişken gibi olsalar da, kendi özel değerleri yoktur. Böyle bir değişkende yapılan bir değişiklik asıl değişkeni etkiler.
)

$(P
Referans değişkenlerini aslında şimdiye kadar iki konuda görmüş ama üzerinde fazla durmamıştık:
)

$(UL

$(LI $(B $(C foreach) döngüsünde $(C ref) ile): Bir grup elemana $(C foreach) döngüsünde sırayla erişilirken $(C ref) anahtar sözcüğü kullanıldığında; eleman, dizi elemanının $(I kendisi) anlamına geliyordu. Kullanılmadığında ise dizi elemanının $(I kopyası) oluyordu.

$(P
Bunu, $(C &) işleci ile de gösterebiliriz. Adresleri aynı ise, iki farklı değişken aslında belleğin aynı yerindeki bir değere erişim sağlıyorlar demektir:
)

---
    int[] dilim = [ 0, 1, 2, 3, 4 ];

    foreach (i, $(HILITE ref) eleman; dilim) {
        assert(&eleman == &dilim[i]);
    }
---

$(P
Her ne kadar farklı iki değişken olsalar da, $(C &) işleci ile alınan adreslerinin eşit olmaları, döngünün her tekrarında tanımlanan $(C eleman) ve $(C dilim[i])'nin değer kimliği açısından aslında aynı olduklarını gösterir.
)

$(P
Bir başka deyişle, $(C eleman), $(C dilim[i])'nin takma ismidir. Daha başka bir deyişle, $(C eleman) ile $(C dilim[i]) aynı değere erişim sağlarlar. Birisinde yapılan değişiklik, asıl değeri etkiler.
)

$(P
$(C eleman) takma ismi, sırayla asıl dizi elemanlarının takma ismi haline gelir. Bu durumu döngünün $(C i)'nin örneğin 3 olduğu tekrarı için şöyle gösterebiliriz:
)

$(MONO
   dilim[0] dilim[1] dilim[2] dilim[3] dilim[4]
       ⇢        ⇢        ⇢    (eleman)
──┬────────┬────────┬────────┬────────┬─────────┬──
  │    0   │    1   │    2   │    3   │    4    │
──┴────────┴────────┴────────┴────────┴─────────┴──
)

)

$(LI $(B $(C ref) ve $(C out) işlev parametrelerinde): İşlev parametreleri $(C ref) veya $(C out) olarak tanımlandıklarında işleve gönderilen asıl değişkenin takma ismi gibi işlem görürler.

$(P
Bunu görmek için böyle iki parametre alan bir işlevin iki parametresine de aynı değişkeni gönderelim. Aynı değer kimliğine sahip olduklarını yine $(C &) işleci ile gösterebiliriz:
)

---
import std.stdio;

void main() {
    int asılDeğişken;
    writeln("asılDeğişken'in adresi : ", &asılDeğişken);
    işlev(asılDeğişken, asılDeğişken);
}

void işlev($(HILITE ref) int refParametre, $(HILITE out) int outParametre) {
    writeln("refParametre'nin adresi: ", &refParametre);
    writeln("outParametre'nin adresi: ", &outParametre);
    assert($(HILITE &)refParametre == $(HILITE &)outParametre);
}
---

$(P
Her ne kadar farklı parametre olarak tanımlansalar da, $(C refParametre) ve $(C outParametre) aslında aynı değere erişim sağlarlar çünkü zaten ikisi de $(C main) içindeki $(C asılDeğişken)'in takma ismidir:
)

$(SHELL
asılDeğişken'in adresi : 7FFF1DC7D7D8
refParametre'nin adresi: 7FFF1DC7D7D8
outParametre'nin adresi: 7FFF1DC7D7D8
)

)

)

$(H5 $(IX tür, referans) Referans türü)

$(P
Bazı türlerden olan değişkenler kendi kimlikleri olduğu halde kendileri değer taşımazlar; değer taşıyan başka değişkenlere erişim sağlarlar. Böyle türlere referans türü denir.
)

$(P
Bu kavramı daha önce dizi dilimlerinde görmüştük. Dilimler, var olan başka bir dizinin elemanlarına erişim sağlayan türlerdir; kendi elemanları yoktur:
)

---
    // İsmi burada 'dizi' olarak yazılmış olsa da aslında bu
    // değişken de dilimdir; bütün elemanlara erişim sağlar.
    int[] dizi = [ 0, 1, 2, 3, 4 ];

    // Baştaki ve sondaki elemanı dışlayarak ortadaki üçüne
    // erişim sağlayan bir dilim:
    int[] dilim = dizi[1 .. $ - 1];

    // Şimdi dilim[0] ile dizi[1] aynı değere erişirler:
    assert($(HILITE &)dilim[0] == $(HILITE &)dizi[1]);

    // Gerçekten de dilim[0]'da yapılan değişiklik dizi[1]'i
    // etkiler:
    dilim[0] = 42;
    assert(dizi[1] == 42);
---

$(P
Referans değişkenlerinin tersine, referans türleri yalnızca takma isim değildirler. Bunu görmek için aynı dilimin kopyası olan bir dilim daha oluşturalım:
)

---
    int[] dilim2 = dilim;
---

$(P
Bu iki dilim kendi adresleri olan, bir başka deyişle kendi kimlikleri olan değişkenlerdir; $(C dilim2) ile $(C dilim) farklı adreslerde yaşarlar:
)

---
    assert(&dilim != &dilim2);
---

$(P
İşte $(I referans değişkenleri) ile $(I referans türlerinin) ayrımı buna dayanır:
)

$(UL

$(LI Referans değişkenlerinin kendi kimlikleri yoktur, başka b değişkenlerin takma isimleridirler.)

$(LI Referans türünden olan değişkenler ise kendi kimlikleri olan değişkenlerdir ama yine başka değerlere erişim sağlarlar.)

)

$(P
Örneğin yukarıdaki $(C dilim) ve $(C dilim2)'yi bellek üzerinde şöyle gösterebiliriz:
)

$(MONO
                                 dilim        dilim2
 ───┬───┬───┬───┬───┬───┬───  ───┬───┬───  ───┬───┬───
    │ 0 │$(HILITE &nbsp;1&nbsp;)│$(HILITE &nbsp;2&nbsp;)│$(HILITE &nbsp;3&nbsp;)│ 4 │        │ o │        │ o │
 ───┴───┴───┴───┴───┴───┴───  ───┴─│─┴───  ───┴─│─┴───
              ▲                    │            │
              │                    │            │
              └────────────────────┴────────────┘
)

$(P
İki dilimin erişim sağladıkları asıl elemanlar işaretli olarak gösteriliyor.
)

$(P
D'nin güçlü bir olanağı olan sınıfları daha ilerideki bölümlerde göreceğiz. D'yi C++'dan ayıran önemli farklardan birisi, D'nin sınıflarının referans türleri olmalarıdır. Yalnızca bunu göstermiş olmak için çok basit bir sınıf tanımlayacağım:
)

---
class BirSınıf {
    int üye;
}
---

$(P
Sınıf nesneleri, daha önce hata atarken de kullandığımız $(C new) ile oluşturulurlar:
)

---
    auto değişken = new BirSınıf;
---

$(P
Bu durumda $(C değişken), $(C new) işleciyle oluşturulmuş olan isimsiz bir $(C BirSınıf) nesnesine erişim sağlayan bir referanstır:
)

$(MONO
  (isimsiz BirSınıf nesnesi)    değişken
 ───┬───────────────────┬───  ───┬───┬───
    │        ...        │        │ o │
 ───┴───────────────────┴───  ───┴─│─┴───
              ▲                    │
              │                    │
              └────────────────────┘
)

$(P
Dilimlere benzer şekilde, $(C değişken) kopyalandığında kopyası da aynı nesneye erişim sağlar ama kopyanın farklı adresi vardır:
)

---
    auto değişken = new BirSınıf;
    auto değişken2 = değişken;
    assert(değişken == değişken2);
    assert(&değişken != &değişken2);
---

$(P
Yukarıda görüldüğü gibi, erişim sağlama açısından eşit olsalar da, adresleri farklı olduğu için farklı değişkenlerdir:
)

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
Böyle iki farklı $(C BirSınıf) nesnesinin gerçekten de aynı nesneye erişim sağladıklarını bir de şöyle gösterebiliriz:
)

---
    auto değişken = new BirSınıf;
    değişken.üye = 1;

    auto değişken2 = değişken;   // aynı nesneyi paylaşırlar
    değişken2.üye = 2;

    assert(değişken.üye == 2);   // değişken'in de erişim
                                 // sağladığı nesne
                                 // değişmiştir
---

$(P
$(C değişken2) yoluyla 2 değerini alan üye, $(C değişken)'in de erişim sağladığı nesnenin üyesidir.
)

$(P
Başka bir referans türü, eşleme tablolarıdır. Eşleme tabloları da atandıklarında aynı asıl tabloya erişim sağlarlar:
)

---
    string[int] isimleSayılar =
    [
        1   : "bir",
        10  : "on",
        100 : "yüz",
    ];

    // Aynı asıl tabloyu paylaşmaya başlarlar:
    string[int] isimleSayılar2 = isimleSayılar;

    // Örneğin ikincisine eklenen eleman ...
    isimleSayılar2[4] = "dört";

    // ... birincisinde de görünür.
    assert(isimleSayılar[4] == "dört");
---

$(P
Bir sonraki bölümde göreceğimiz gibi, baştaki eşleme tablosu $(C null) ise eleman paylaşımı yoktur.
)

$(H6 Atama işleminin farkı)

$(P
Değer türlerinde ve referans değişkenlerinde atama işleminin sonucunda $(I asıl değer) değişir:
)

---
void main() {
    int sayı = 8;

    yarıyaBöl(sayı);      // asıl değer değişir
    assert(sayı == 4);
}

void yarıyaBöl($(HILITE ref) int bölünen) {
    bölünen /= 2;
}
---

$(P
Referans türlerinde ise atama işlemi, $(I hangi asıl nesneye erişim sağlandığını) değiştirir. Örneğin aşağıdaki kodda $(C dilim3)'e yapılan atama işlemi onun eriştirdiği elemanların değerlerini değiştirmez; $(C dilim3)'ün başka elemanları göstermesini sağlar:
)

---
void main() {
    int[] dilim1 = [ 10, 11, 12, 13, 14 ];
    int[] dilim2 = [ 20, 21, 22 ];

    int[] dilim3 = dilim1[1 .. 3]; // 1 ve 2 indeksli elemanlara
                                   // eriştirir

    dilim3[0] = 777;
    assert(dilim1 == [ 10, 777, 12, 13, 14 ]);

    // Bu atama işlemi dilim3'ün eriştirdiği elemanları
    // değiştirmez, dilim3'ün artık başka elemanlara
    // erişim sağlamasına neden olur
    $(HILITE dilim3 =) dilim2[$ - 1 .. $];  // sonuncu elemana eriştirir

    dilim3[0] = 888;
    assert(dilim2 == [ 20, 21, 888 ]);
}
---

$(P
Atama işlecinin referans türlerindeki bu etkisini bir de $(C BirSınıf) türünde görelim:
)

---
    auto değişken1 = new BirSınıf;
    değişken1.üye = 1;

    auto değişken2 = new BirSınıf;
    değişken2.üye = 2;

    auto $(HILITE kopya = değişken1);
    kopya.üye = 3;

    $(HILITE kopya = değişken2);
    kopya.üye = 4;

    assert(değişken1.üye == 3);
    assert(değişken2.üye == 4);
---

$(P
Oradaki atama işlemleri sonucunda $(C kopya) önce $(C değişken1)'in nesnesine, sonra da $(C değişken2)'nin nesnesine erişim sağlar. $(C kopya) yoluyla değeri değiştirilen $(C üye) ilk seferde $(C değişken1)'inkidir, sonra ise $(C değişken2)'ninkidir.
)

$(H6 Referans türleri hiçbir değere erişim sağlamıyor olabilirler)

$(P
Referans $(I değişkenlerinde) mutlaka bir asıl değer vardır; onların yaşam süreçleri erişim sağladıkları bir asıl değer olmadan başlamaz. Referans $(I türlerinin) değişkenleri ise, henüz hiçbir değere erişim sağlamayacak şekilde oluşturulabilirler.)

$(P
Örneğin bir $(C BirSınıf) değişkeni, erişim sağladığı nesne henüz belli olmadan şöyle tanımlanabilir:
)

---
    BirSınıf değişken;
---

$(P
Böyle değişkenler $(C null) özel değerine eşittirler. Bu özel değeri ve $(C is) anahtar sözcüğünü $(LINK2 /ders/d/null_ve_is.html, daha sonraki bir bölümde) göreceğiz.
)

$(H5 Sabit uzunluklu diziler $(I değer türü), dinamik diziler $(I referans türü))

$(P
D'nin iki dizi türü bu konuda farklılık gösterir.
)

$(P
Dinamik diziler (dilimler), yukarıdaki örneklerde de görüldüğü gibi referans türleridir. Dinamik diziler kendilerine ait olmayan elemanlara erişim sağlarlar. Temel işlemler açısından referans olarak davranırlar.
)

$(P
Sabit uzunluklu diziler ise değer türleridir. Kendi elemanlarına sahiptirler ve değer türü olarak davranırlar:
)

---
    int[3] dizi1 = [ 10, 20, 30 ];

    // dizi2'nin elemanları dizi1'inkilerden farklı olur
    auto dizi2 = dizi1;
    dizi2[0] = 11;

    // İlk dizi değişmez
    assert(dizi1[0] == 10);
---

$(P
Tanımlandığı zaman uzunluğu da belirlendiği için $(C dizi1) sabit uzunluklu bir dizidir. $(C auto) anahtar sözcüğü nedeniyle $(C dizi2) de aynı türü edinir. Her ikisi de kendi elemanlarına sahiptirler. Birisinde yapılan değişiklik diğerini etkilemez.
)

$(H5 Deney)

$(P
Yukarıda anlatılan farklı türlerin değişkenlerine ve onların adreslerine $(C ==) işlecini uygulayınca ortaya şöyle bir tablo çıkıyor:
)

$(MONO
                    Değişken Türü                    a == b  &amp;a == &amp;b
=====================================================================
             aynı değerli değişkenler (değer türü)     true    false
           farklı değerli değişkenler (değer türü)    false    false
                            ref değişkenli foreach     true     true
                    ref olmayan değişkenli foreach     true    false
                             out parametreli işlev     true     true
                             ref parametreli işlev     true     true
                              in parametreli işlev     true    false
                   aynı elemanlara erişen dilimler     true    false
                 farklı elemanlara erişen dilimler    false    false
  aynı nesneye erişen BirSınıf'lar (referans türü)     true    false
farklı nesneye erişen BirSınıf'lar (referans türü)    false    false
)

$(P
O tablo aşağıdaki programla üretilmiştir:
)

---
import std.stdio;
import std.array;

int modülDeğişkeni = 9;

class BirSınıf {
    int üye;
}

void başlıkÇiz() {
    immutable dchar[] başlık =
        "                    Değişken Türü"
        "                    a == b  &a == &b";

    writeln();
    writeln(başlık);
    writeln(replicate("=", başlık.length));
}

void bilgiSatırı(const dchar[] başlık,
                 bool değerEşitliği,
                 bool adresEşitliği) {
    writefln("%50s%9s%9s",
             başlık, değerEşitliği, adresEşitliği);
}

void main() {
    başlıkÇiz();

    int sayı1 = 12;
    int sayı2 = 12;
    bilgiSatırı("aynı değerli değişkenler (değer türü)",
                sayı1 == sayı2,
                &sayı1 == &sayı2);

    int sayı3 = 3;
    bilgiSatırı("farklı değerli değişkenler (değer türü)",
                sayı1 == sayı3,
                &sayı1 == &sayı3);

    int[] dilim = [ 4 ];
    foreach (i, ref eleman; dilim) {
        bilgiSatırı("ref değişkenli foreach",
                    eleman == dilim[i],
                    &eleman == &dilim[i]);
    }

    foreach (i, eleman; dilim) {
        bilgiSatırı("ref olmayan değişkenli foreach",
                    eleman == dilim[i],
                    &eleman == &dilim[i]);
    }

    outParametre(modülDeğişkeni);
    refParametre(modülDeğişkeni);
    inParametre(modülDeğişkeni);

    int[] uzunDilim = [ 5, 6, 7 ];
    int[] dilim1 = uzunDilim;
    int[] dilim2 = dilim1;
    bilgiSatırı("aynı elemanlara erişen dilimler",
                dilim1 == dilim2,
                &dilim1 == &dilim2);

    int[] dilim3 = dilim1[0 .. $ - 1];
    bilgiSatırı("farklı elemanlara erişen dilimler",
                dilim1 == dilim3,
                &dilim1 == &dilim3);

    auto değişken1 = new BirSınıf;
    auto değişken2 = değişken1;
    bilgiSatırı(
        "aynı nesneye erişen BirSınıf'lar (referans türü)",
        değişken1 == değişken2,
        &değişken1 == &değişken2);

    auto değişken3 = new BirSınıf;
    bilgiSatırı(
        "farklı nesneye erişen BirSınıf'lar (referans türü)",
        değişken1 == değişken3,
        &değişken1 == &değişken3);
}

void outParametre(out int parametre) {
    bilgiSatırı("out parametreli işlev",
                parametre == modülDeğişkeni,
                &parametre == &modülDeğişkeni);
}

void refParametre(ref int parametre) {
    bilgiSatırı("ref parametreli işlev",
                parametre == modülDeğişkeni,
                &parametre == &modülDeğişkeni);
}

void inParametre(in int parametre) {
    bilgiSatırı("in parametreli işlev",
                parametre == modülDeğişkeni,
                &parametre == &modülDeğişkeni);
}
---

$(P
Notlar:
)

$(UL

$(LI
$(IX modül değişkeni) $(IX değişken, modül) Programda işlev parametrelerini karşılaştırmak için bir de modül değişkeni kullanılıyor. Modül değişkenleri işlevlerin dışında tanımlanırlar ve içinde tanımlandıkları modüldeki bütün kodlar tarafından erişilebilirler.
)

$(LI
$(IX replicate, std.array) $(C std.array) modülünün $(C replicate()) işlevi kendisine verilen aralığı (yukarıdaki $(STRING "=")) belirtilen sayıda tekrarlar.
)

)

$(H5 Özet)

$(UL
$(LI Değer türlerinden olan her değişkenin kendi değeri ve kendi adresi vardır.)
$(LI Referans değişkenlerinin ne değerleri vardır ne de adresleri; takma isim gibidirler.)
$(LI Referans türlerinden olan değişkenlerin kendi adresleri vardır; ama erişim sağladıkları değer kendilerinin değildir.)
$(LI Referans türlerinde atama işlemi değer değiştirmez, hangi asıl nesneye erişildiğini değiştirir.)
$(LI Referans türlerinden olan değişkenler $(C null) olabilirler.)
)

Macros:
        SUBTITLE=Değerler ve Referanslar

        DESCRIPTION=D dilinde değer türlerinin ve referans türlerinin karşılaştırılmaları; ve adres alma işleci olan &amp;

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial nesne değer türü referans türü

SOZLER=
$(cop_toplayici)
$(deger)
$(deger_turu)
$(dilim)
$(esleme_tablosu)
$(nesne)
$(referans)
$(referans_turu)
$(sinif)
$(yapi)
