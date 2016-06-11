Ddoc

$(DERS_BOLUMU $(IX eşleme tablosu) Eşleme Tabloları)

$(P
Eşleme tabloları üst düzey dillerin hepsinde bulunan veri yapılarıdır. Onları program içine gömülen minik veri tabanları olarak düşünülebilirsiniz. Programlarda çok kullanılan ve çok hızlı veri yapılarıdır.
)

$(P
$(LINK2 /ders/d/diziler.html, Dizileri) "elemanları yan yana duran topluluk" olarak tanımlamış ve elemanlarına $(I indeksle) erişildiğini görmüştük. Örneğin haftanın günlerinin isimlerini tutan bir dizi şöyle tanımlanabilir:
)

---
    string[] günİsimleri =
        [ "Pazartesi", "Salı", "Çarşamba", "Perşembe",
          "Cuma", "Cumartesi", "Pazar" ];
---

$(P
Belirli bir günün ismi o diziyi kullanarak şöyle yazdırılabilir:
)

---
    writeln(günİsimleri[1]);   // "Salı" yazar
---

$(P
Dizilerin elemanları sıra numarasıyla (indeksle) eriştiriyor olmaları, onların indekslerle elemanları $(I eşleştirdikleri) olarak açıklanabilir.
)

$(P
Ancak, diziler indeks türü olarak yalnızca tamsayı türler kullanabilirler. Örneğin "Salı" dizgisi bulunduğunda onun haftanın 1 numaralı günü olduğunu söyleyemezler çünkü "Salı" gibi bir dizgiyi indeks olarak kullanamazlar.
)

$(P
Eşleme tablolarının kullanışlılığı işte bu gibi durumlarda ortaya çıkar. Eşleme tabloları elemanlara yalnızca numara ile değil, herhangi bir türle erişilen veri yapılarıdır. Görevleri, herhangi bir indeks türündeki bir değeri herhangi başka bir türdeki değer ile $(I eşlemektir). Eşleme tabloları elemanlarını $(I indeks-değer) çiftleri olarak tutarlar. Aşağıda $(I eleman) yazdığım her yerde bir indeks-değer çiftini kastedeceğim.
)

$(P
Eşleme tabloları arka planda $(I hash table) veri yapısını kullandıkları için algoritma karmaşıklığı açısından dizilerden geri kalmazlar: son derece hızlı topluluklardır. Bunun anlamı, içlerindeki eleman sayısından bağımsız olarak, hemen her zaman için sabit zamanda erişim sağlamalarıdır.
)

$(P
Bu kadar hızlı çalışmalarının bedeli, içlerindeki elemanların sıraları konusunda bir şey bilinemiyor olmasıdır. Elemanların ne dizilerdeki gibi $(I yan yana) olduklarını, ne de örneğin $(I küçükten büyüğe doğru) sıralandıklarını söyleyebiliriz.
)

$(P
Diziler indeks değerleri için yer harcamazlar. Dizi elemanları bellekte yan yana durduklarından her elemanın indeks değeri onun başlangıçtan kaç eleman ötede olduğudur.
)

$(P
Öte yandan, eşleme tabloları hem indeksleri hem de değerleri saklamak zorundadırlar. Bu fark eşleme tablolarının bellekte daha fazla yer tutmalarına neden olsa da, onların $(I seyrek) indeks değerleri kullanabilmelerini de sağlar. Örneğin, 0 ve 999 gibi iki değer için diziler 1000 eleman saklamak zorunda oldukları halde eşleme tabloları yalnızca iki eleman saklarlar.
)

$(H5 Tanımlama)

$(P
Eşleme tablosu tanımı dizi tanımına çok benzer. Tek farkı, köşeli parantezler içine dizinin uzunluğu yerine dizinin indeks türünün gelmesidir. Söz dizimi aşağıdaki gibidir:
)

---
    $(I değer_türü)[$(I indeks_türü)] tablo_ismi;
---

$(P
Örneğin türü $(C string) olan gün isminden türü $(C int) olan gün sıra numarasına eşleyen bir eşleme tablosu şöyle tanımlanır:
)

---
    int[string] günSıraları;
---

$(P
O tanım gün ismine karşılık olarak gün numarasını veren, yani yukarıdaki $(C günİsimleri) dizisinin tersi olarak işleyen bir tablo olarak kullanılabilir. Bunu aşağıdaki kod örneklerinde göreceğiz.
)

$(P
Eşleme tablolarının en kullanışlı taraflarından birisi, indeks ve değer türü olarak daha sonra öğreneceğimiz $(I yapı) ve $(I sınıf) türleri de dahil olmak üzere her türün kullanılabilmesidir.
)

$(P
Dinamik dizilerde olduğu gibi, eşleme tablolarının uzunlukları da tanımlandıkları zaman belirlenmez. Tablo otomatik olarak büyür.
)

$(P
$(I Not: Baştan elemansız olarak tanımlanan bir eşleme tablosu boş değil, $(LINK2 /ders/d/null_ve_is.html, $(C null))'dır. Bu ayrımın $(LINK2 /ders/d/islev_parametreleri.html, işlevlere parametre olarak geçirilen eşleme tabloları) açısından büyük önemi vardır. Bu kavramları ilerideki bölümlerde göreceğiz.)
)

$(H5 Tabloya eleman ekleme)

$(P
Belirli bir indeks değerine karşılık gelen değer atama işleci ile belirlenir:
)

---
    günSıraları["Pazartesi"] $(HILITE =) 0;  // "Pazartesi"yi 0 ile eşler
    günSıraları["Salı"] $(HILITE =) 1;       // "Salı"yı 1 ile eşler
---

$(P
Eşleme ilişkisi tablonun otomatik olarak büyümesi için de yeterlidir. Yukarıdaki işlemler sonucunda tabloda artık iki eleman vardır. Bunu bütün tabloyu yazdırarak görebiliriz:
)

---
    writeln(günSıraları);
---

$(P
Çıktısı, "Pazartesi" ve "Salı" indekslerine karşılık 0 ve 1 değerlerinin bulunduğunu gösterir:
)

$(SHELL
["Pazartesi":0, "Salı":1]
)

$(P
Her indeks değerine karşılık tek değer bulunabilir. Bu yüzden, var olan bir indekse karşılık yeni bir değer atandığında tablo büyümez, var olan elemanın değeri değişir:
)

---
    günSıraları["Salı"] = 222;
    writeln(günSıraları);
---

$(P
Çıktısı:
)

$(SHELL
["Pazartesi":0, "Salı":222]
)

$(H5 İlkleme)

$(P
$(IX :, eşleme tablosu) Gün sıraları kavramında olduğu gibi, eşleme bilgisi bazen tablo kurulduğu sırada bilinir. Eşlemeleri teker teker atayarak kurmak yerine bu bilgiyi tabloyu tanımladığımız zaman da verebiliriz. Eşleme tabloları da dizi söz diziminde olduğu gibi ilklenir. Farklı olarak, indeks ile değeri arasına $(C :) karakteri yazılır:
)

---
    int[string] günSıraları =
        [ "Pazartesi" : 0, "Salı" : 1, "Çarşamba" : 2,
          "Perşembe"  : 3, "Cuma" : 4, "Cumartesi": 5,
          "Pazar"     : 6 ];

    writeln(günSıraları["Salı"]);    // "1" yazar
---

$(H5 $(IX remove) Tablodan eleman çıkartma)

$(P
Elemanlar, buradaki kullanımında "çıkart, at" anlamına gelen $(C .remove) ile çıkartılırlar:
)

---
    günSıraları.remove("Salı");
    writeln(günSıraları["Salı"]);  // ← çalışma zamanı HATASI
---

$(P
Son satır, tabloda artık bulunmayan bir elemana erişmeye çalıştığı için çalışma zamanında bir hata atılmasına ve o hatanın yakalanmaması durumunda da programın sonlanmasına neden olur. Hata düzeneğini $(LINK2 /ders/d/hatalar.html, ilerideki bir bölümde) göreceğiz.
)

$(P
$(IX clear) Elemanların hepsini birden çıkartmak gerektiğinde $(C .clear) kullanılır:
)

---
    günSıraları.clear;    // Tablo boşalır
---

$(H5 $(IX in, eşleme tablosu) Eleman sorgulama)

$(P
Tabloda bulunmayan bir elemana erişmek bir hata atılmasına neden olduğundan, sorgulamak için $(C in) işleci kullanılır. Bu kullanım "içinde var mı?" sorusunu yanıtlar:
)

---
    if ("mor" $(HILITE in) renkKodları) {
        // evet, renkKodları'nda "mor" indeksli değer var

    } else {
        // hayır, yok
    }
---

$(P
Bazen elemanın bulunup bulunmadığını açıkça sorgulamak yerine eleman bulunmadığı durumda standart bir değer kullanmak istenebilir. Örneğin, $(C renkKodları) tablosunda bulunmayan renklere karşılık -1 gibi bir değer kabul edilmiş olabilir. Bu gibi durumlarda $(C .get()) kullanılır. Tabloda varsa mevcut değeri, yoksa $(C .get())'e verilen ikinci parametrenin değerini döndürür:
)

---
    int[string] renkKodları = [ "mavi" : 10, "yeşil" : 20 ];
    writeln(renkKodları.get("mor", $(HILITE -1)));
---

$(P
Tabloda $(STRING "mor") indeksli eleman bulunmadığından $(C .get()) ikinci parametresinin değeri olan -1'i döndürür:
)

$(SHELL
-1
)

$(H5 Nitelikler)

$(UL

$(LI $(IX .length) $(C .length) eleman sayısını verir.)

$(LI $(IX .keys) $(C .keys) bütün indeksleri dinamik dizi olarak verir.)

$(LI $(IX .byKey) $(C .byKey) bütün indeksleri bir aralık olarak sunar; bunun kullanımını bir sonraki bölümde göreceğiz.)

$(LI $(IX .values) $(C .values) bütün eleman değerlerini dinamik dizi olarak verir.)

$(LI $(IX .byValue) $(C .byValue) bütün eleman değerlerini bir aralık olarak sunar; bunun kullanımını bir sonraki bölümde göreceğiz.)

$(LI $(IX .byKeyValue) $(C .byKeyValue) bütün indeksleri ve değerleri bir aralık olarak sunar.)

$(LI $(IX .rehash) $(C .rehash) ancak gerçekten gereken durumlarda tablonun daha etkin çalışmasını sağlayabilir. Örneğin, tabloya çok sayıda eleman eklendikten sonra ve daha tablonun asıl kullanımı başlamadan önce bu nitelik çağrılırsa tablonun erişim işlemleri bazı programlarda daha hızlı olabilir.)

$(LI $(IX .sizeof, eşleme tablosu) $(C .sizeof) tablonun $(I referansının) büyüklüğüdür (tablodaki eleman adediyle ilgisi yoktur ve her tablo için aynıdır).)

$(LI $(IX .get) $(C .get) varsa elemanın değerini, yoksa ikinci parametresinin değerini döndürür.)

$(LI $(IX .remove) $(C .remove) belirtilen indeksli elemanı tablodan çıkartır.)

$(LI $(IX .clear) $(C .clear) tabloyu boşaltır.)

)

$(H5 Örnek)

$(P
Girilen rengin İngilizcesini veren bir program şöyle yazılabilir:
)

---
import std.stdio;
import std.string;

void main() {
    string[string] renkler = [ "siyah"   : "black",
                               "beyaz"   : "white",
                               "kırmızı" : "red",
                               "yeşil"   : "green",
                               "mavi"    : "blue" ];

    writeln("Ben bu ", renkler.length,
            " rengin İngilizcelerini öğrendim: ",
            renkler.keys);

    write("Haydi sorun: ");
    string türkçesi = strip(readln());

    if (türkçesi in renkler) {
        writefln("İngilizcesi \"%s\"", renkler[türkçesi]);

    } else {
        writeln("Onu bilmiyorum.");
    }
}
---

$(PROBLEM_COK

$(PROBLEM
Bir eşleme tablosunu bütünüyle boşaltmak için $(C .clear)'den başka ne yöntemler düşünülebilir? (Bunun en doğal yolu $(C .clear)'dir.) En az üç yöntem düşünülebilir:

$(UL

$(LI Elemanları bir döngü içinde teker teker tablodan çıkartmak)

$(LI Boş bir eşleme tablosu atamak)

$(LI Bir öncekine benzer şekilde, tablonun $(C .init) niteliğini atamak

$(P
$(IX .init, değişkeni sıfırlamak) $(I Not: Her türün $(C .init) niteliği, o türün ilk değeri olarak kullanılan değerdir:)
)

---
    sayı = int.init;    // int için 0 olur
---
)

)

)

$(PROBLEM
Dizilerde olduğu gibi, eşleme tablolarında da her indekse karşılık tek değer bulunabilir. Bu, bazı durumlarda kısıtlayıcıdır.

$(P
Her öğrenci için birden fazla not tutmak istiyor olalım. Örneğin "emre" için 90, 85, 95, vs. notlarını barındırmak isteyelim.
)

$(P
Bir eşleme tablosu kullanmak, notlara $(C notlar["emre"]) şeklinde öğrencinin ismiyle erişme konusunda yardımcı olur. Ancak, notları tabloya aşağıdaki şekilde yerleştirmek işe yaramaz:
)
---
    int[string] notlar;
    notlar["emre"] = 90;
    notlar["emre"] = 85;   // ← Olmaz: öncekinin üstüne yazar
---

$(P
Ne yapabilirsiniz? Her öğrenci için birden fazla not tutabilen bir eşleme tablosu tanımlayın.
)

)

)

Macros:
        SUBTITLE=Eşleme Tabloları

        DESCRIPTION=D'nin dil olanaklarından olan eşleme tablolarının (hash tables) tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial eşleme tablosu hash table

SOZLER=
$(dizi)
$(eleman)
$(esleme_tablosu)
$(ilklemek)
$(indeks)
$(islec)
$(referans)
$(topluluk)
$(ust_duzey)
