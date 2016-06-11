Ddoc

$(DERS_BOLUMU $(IX gösterge) Göstergeler)

$(P
Göstergeler başka değişkenlere erişim sağlamak için kullanılırlar. Değerleri, erişim sağladıkları değişkenlerin adresleridir.
)

$(P
Göstergeler her türden değişkeni, nesneyi, ve hatta başka göstergeleri de gösterebilirler. Ben bu bölümde kısa olsun diye, bunların hepsinin yerine $(I değişken) sözünü kullanacağım.
)

$(P
Göstergeler mikro işlemcilerin en temel olanaklarındandır ve sistem programcılığının önemli bir parçasıdır.
)

$(P
D'nin gösterge kavramı ve kullanımı C'den geçmiştir. C öğrenenlerin anlamakta en çok zorlandıkları olanak göstergeler olduğu halde, D'de göstergelerin çok daha kolay öğrenileceğini düşünüyorum. Bunun nedeni, göstergelerin amaçlarından bazılarının D'nin başka olanakları tarafından zaten karşılanıyor olmasıdır. Bu yüzden, hem bir çok durumda gösterge kullanılması gerekmez
 hem de başka D olanaklarının zaten anlaşılmış olması göstergelerin anlaşılmalarını da kolaylaştırır.
)

$(P
Bu bölümde özellikle basit olarak seçtiğim örnekler göstergelerin kullanım amaçlarını anlatma konusunda yetersiz kalabilirler. Yazımlarını ve kullanımlarını öğrenirken bunu gözardı edebilirsiniz. En sonda vereceğim örneklerin daha anlamlı olacaklarını düşünüyorum.
)

$(P
Ek olarak, örneklerde basitçe $(C gösterge) diye seçtiğim isimlerin kullanışsız olduklarını aklınızda bulundurun. Kendi programlarınızda her ismi anlamlı ve açıklayıcı olarak seçmeye özen gösterin.
)

$(H5 $(IX referans kavramı) Referans kavramı)

$(P
Göstergelere geçmeden önce göstergelerin temel amacı olan $(I referans) kavramını şimdiye kadarki bölümlerden tanıdığımız D olanakları ile kısaca hatırlayalım.
)

$(H6 $(C foreach)'in $(C ref) değişkenleri)

$(P
$(LINK2 /ders/d/foreach_dongusu.html, $(C foreach) Döngüsü bölümünde) gördüğümüz gibi, döngü değişkenleri normalde elemanların $(I kopyalarıdır):
)

---
import std.stdio;

void main() {
    int[] dizi = [ 1, 11, 111 ];

    foreach (sayı; dizi) {
        sayı = 0;     // ← kopya değişir; asıl eleman değişmez
    }

    writeln("Döngüden sonra elemanlar: ", dizi);
}
---

$(P
Yukarıdaki döngü içinde sıfırlanmakta olan $(C sayı) değişkeni her seferinde dizi elemanlarından birisinin $(I kopyasıdır). Onun değiştirilmesi dizideki asıl elemanı etkilemez:
)

$(SHELL_SMALL
Döngüden sonra elemanlar: 1 11 111
)

$(P
Dizideki elemanların kendilerinin değişmeleri istendiğinde $(C foreach) değişkeni $(C ref) olarak tanımlanır:
)

---
    foreach ($(HILITE ref) sayı; dizi) {
        sayı = 0;     // ← asıl eleman değişir
    }
---

$(P
$(C sayı) bu sefer dizideki asıl elemanın takma ismi gibi işlem görür ve dizideki asıl elemanlar değişir:
)

$(SHELL_SMALL
Döngüden sonra elemanlar: 0 0 0
)

$(H6 $(C ref) işlev parametreleri)

$(P
$(LINK2 /ders/d/islev_parametreleri.html, İşlev Parametreleri bölümünde) gördüğümüz gibi, $(I değer türünden) olan işlev parametreleri normalde başka değişkenlerin kopyalarıdır:
)

---
import std.stdio;

void yarımEkle(double değer) {
    değer += 0.5;        // ← main'deki değer değişmez
}

void main() {
    double değer = 1.5;

    yarımEkle(değer);

    writeln("İşlevden sonraki değer: ", değer);
}
---

$(P
İşlev parametresi $(C ref) olarak tanımlanmadığından, işlev içindeki atama yalnızca işlevin yerel değişkeni olan $(C değer)'i etkiler. $(C main)'deki $(C değer) değişmez:
)

$(SHELL_SMALL
İşlevden sonraki değer: 1.5
)

$(P
İşlev parametresinin, işlevin çağrıldığı yerdeki değişkenin takma ismi olması için $(C ref) anahtar sözcüğü kullanılır:
)

---
void yarımEkle($(HILITE ref) double değer) {
    değer += 0.5;
}
---

$(P
Bu sefer $(C main) içindeki $(C değer) etkilenmiş olur:
)

$(SHELL_SMALL
İşlevden sonraki değer: 2
)

$(H6 Referans türleri)

$(P
D'de bazı türler referans türleridir. Bu türlerden olan değişkenler sahip olmadıkları başka değerlere erişim sağlarlar:
)

$(UL
$(LI Sınıf değişkenleri)
$(LI Dinamik diziler)
$(LI Eşleme tabloları)
)

$(P
Referans kavramını $(LINK2 /ders/d/deger_referans.html, Değerler ve Referanslar bölümünde) görmüştük. Burada o bölüme dahil etmediğim sınıflar üzerinde bir örnek göstermek istiyorum:
)

---
import std.stdio;

class TükenmezKalem {
    double mürekkep;

    this() {
        mürekkep = 15;
    }

    void kullan(double miktar) {
        mürekkep -= miktar;
    }
}

void main() {
    auto kalem = new TükenmezKalem;
    auto başkaKalem = kalem;  // ← şimdi ikisi de aynı nesneye
                              //   erişim sağlarlar

    writefln("Önce : %s %s",
             kalem.mürekkep, başkaKalem.mürekkep);

    kalem.kullan(1);          // ← aynı nesne kullanılır
    başkaKalem.kullan(2);     // ← aynı nesne kullanılır

    writefln("Sonra: %s %s",
             kalem.mürekkep, başkaKalem.mürekkep);
}
---

$(P
Sınıflar referans türleri olduklarından, farklı sınıf değişkenleri olan $(C kalem) ve $(C başkaKalem) tek $(C TükenmezKalem) nesnesine erişim sağlamaktadır. Sonuçta, iki değişkenin kullanılması da aynı nesneyi etkiler:
)

$(SHELL_SMALL
Önce : 15 15
Sonra: 12 12
)

$(P
Bu sınıf nesnesinin ve ona erişim sağlayan iki sınıf değişkeninin bellekte şu şekilde durduklarını düşünebiliriz:
)

$(MONO
   (TükenmezKalem nesnesi)       kalem      başkaKalem
 ───┬───────────────────┬───  ───┬───┬───  ───┬───┬───
    │      mürekkep     │        │ o │        │ o │
 ───┴───────────────────┴───  ───┴─│─┴───  ───┴─│─┴───
              ▲                    │            │
              │                    │            │
              └────────────────────┴────────────┘
)

$(P
Referans kavramı yukarıdaki şekildeki gibidir: Referanslar asıl değişkenleri $(I gösterirler).
)

$(P
Programlama dillerindeki referans ve gösterge kavramları perde arkasında mikro işlemcilerin $(I gösterme) amacıyla kullanılan yazmaçları ile gerçekleştirilir.
)

$(P
D'nin yukarıda hatırlattığım üst düzey olanakları da perde arkasında göstergelerle gerçekleştirilmiştir. Bu yüzden hem zaten çok etkin çalışırlar hem de açıkça gösterge kullanmaya gerek bırakmazlar. Buna rağmen, başka sistem programlama dillerinde de olduğu gibi, göstergeler D programcılığında da mutlaka bilinmelidir.
)

$(H5 $(IX *, gösterge tanımı) Tanımlanması)

$(P
D'nin gösterge söz dizimi aynı C'de olduğu gibidir. Bu, C bilen programcılar için bir kolaylık olarak görülse de, özellikle $(C *) işlecinin farklı anlamlara sahip olması C'de olduğu gibi D'de de öğrenmeyi güçleştirebilir.
)

$(P
Biraz aşağıda anlatacağım $(I her türü gösterebilen gösterge) dışındaki göstergeler ancak belirli türden bir değişkeni gösterebilirler. Örneğin bir $(C int) göstergesi yalnızca $(C int) türünden olan değişkenleri gösterebilir.
)

$(P
Bir gösterge tanımlanırken, önce hangi türden değer göstereceği sonra da bir $(C *) karakteri yazılır:
)

---
    $(I $(D_KEYWORD göstereceği_tür)) * $(I göstergenin_ismi);
---

$(P
Bir $(C int)'i gösterecek olan bir gösterge şöyle tanımlanabilir:
)

---
    int * benimGöstergem;
---

$(P
Böyle bir tanımda $(C *) karakterini "göstergesi" diye okuyabilirsiniz. $(C benimGöstergem)'in türü bir $(C int*)'dır; yani bir "int göstergesidir". $(C *) karakterinden önceki ve sonraki boşlukların yazılmaları isteğe bağlıdır ve aşağıdaki gibi kullanımlar da çok yaygındır:
)

---
    int* benimGöstergem;
    int *benimGöstergem;
---

$(P
Tek başına tür ismi olarak "int göstergesi" anlamında kullanıldığında, boşluksuz olarak $(C int*) olarak yazılması da çok yaygındır.
)

$(H5 $(IX &, adres) Göstergenin değeri ve adres alma işleci $(C &))

$(P
Göstergeler de değişkendir ve her değişkenin olduğu gibi onların da değerleri vardır. Değer atanmayan göstergelerin varsayılan değeri, hiçbir değişkene erişim sağlamama değeri olan $(C null)'dır.
)

$(P
Bir göstergenin hangi değişkeni gösterdiği (yani $(I erişim sağladığı)), göstergenin değer olarak o değişkenin adresini taşıması ile sağlanır. Başka bir deyişle, gösterge o adresteki değişkeni gösterir.
)

$(P
Şimdiye kadar $(C readf) işlevi ile çok kullandığımız $(C &) işlecini $(LINK2 /ders/d/deger_referans.html, Değerler ve Referanslar bölümünden) de hatırlayacaksınız. Bu işleç, önüne yazıldığı değişkenin adresini alır. Bu adres değeri, gösterge değeri olarak kullanılabilir:
)

---
    int beygirGücü = 180;
    int * benimGöstergem = $(HILITE &)beygirGücü;
---

$(P
Yukarıdaki ifadede göstergenin $(C beygirGücü)'nün adresi ile ilklenmesi, $(C benimGöstergem)'in $(C beygirGücü)'nü $(I göstermesini) sağlar.
)

$(P
Göstergenin değeri $(C beygirGücü)'nün adresi ile aynıdır:
)

---
    writeln("beygirGücü'nün adresi   : ", &beygirGücü);
    writeln("benimGöstergem'in değeri: ", benimGöstergem);
---

$(SHELL_SMALL
beygirGücü'nün adresi   : 7FFF2CE73F10
benimGöstergem'in değeri: 7FFF2CE73F10
)

$(P $(I Not: Adres değeri siz denediğinizde farklı olacaktır. $(C beygirGücü), programın işletim sisteminden aldığı daha büyük bir belleğin bir yerinde bulunur. Bu yer programın her çalıştırılışında büyük olasılıkla farklı bir adreste bulunacaktır.)
)

$(P
Bir göstergenin değerinin erişim sağladığı değişkenin adresi olduğunu ve böylece o değişkeni $(I gösterdiğini) referanslara benzer biçimde şöyle düşünebiliriz:
)

$(MONO
  7FFF2CE73F10 adresindeki        başka bir adresteki
         beygirGücü                 benimGöstergem
───┬──────────────────┬───     ───┬────────────────┬───
   │        180       │           │  7FFF2CE73F10  │
───┴──────────────────┴───     ───┴────────│───────┴───
             ▲                             │
             │                             │
             └─────────────────────────────┘
)

$(P
$(C beygirGücü)'nün değeri 180, $(C benimGöstergem)'in değeri de $(C beygirGücü)'nün adresidir.
)

$(P
Göstergeler de değişken olduklarından, onların adreslerini de $(C &) işleci ile öğrenebiliriz:
)

---
    writeln("benimGöstergem'in adresi: ", &benimGöstergem);
---

$(SHELL_SMALL
benimGöstergem'in adresi: 7FFF2CE73F18
)

$(P
$(C beygirGücü) ile $(C benimGöstergem)'in adreslerinin arasındaki farkın bu örnekte 8 olduğuna bakarak ve $(C beygirGücü)'nün türü olan $(C int)'in büyüklüğünün 4 bayt olduğunu hatırlayarak bu iki değişkenin bellekte 4 bayt ötede bulundukları sonucunu çıkartabiliriz.
)

$(P
$(I Gösterme) kavramını belirtmek için kullandığım oku da kaldırırsak, bir şerit gibi soldan sağa doğru uzadığını hayal ettiğimiz belleği şimdi şöyle düşünebiliriz:
)


$(MONO
    7FFF2CE73F10     7FFF2CE73F14     7FFF2CE73F18
    :                :                :                :
 ───┬────────────────┬────────────────┬────────────────┬───
    │      180       │     (boş)      │  7FFF2CE73F10  │
 ───┴────────────────┴────────────────┴────────────────┴───
)

$(P
Kaynak kodda geçen değişken ismi, işlev ismi, anahtar sözcük, vs. gibi isimler D gibi derlemeli diller ile oluşturulan programların içinde bulunmazlar. Örneğin, programcının isim vererek tanımladığı ve kullandığı değişkenler program içinde mikro işlemcinin anladığı adreslere ve değerlere dönüşürler.
)

$(P $(I Not: Programda kullanılan isimler hata ayıklayıcıda yararlanılmak üzere programın) debug $(I halinde de bulunurlar ama o isimlerin programın işleyişiyle ilgileri yoktur.)
)

$(H5 $(IX *, erişim işleci) Erişim işleci $(C *))

$(P
Çarpma işleminden tanıdığımız $(C *) karakterinin gösterge tanımlarken tür isminden sonra yazıldığını yukarıda gördük. Göstergeleri öğrenirken karşılaşılan bir güçlük, bu karakterin göstergenin gösterdiği değişkene erişmek için de kullanılmasıdır.
)

$(P
Bir göstergenin isminden önce yazıldığında, $(I göstergenin erişim sağladığı değer) anlamına gelir:
)

---
    writeln("Gösterdiği değer: ", $(HILITE *)benimGöstergem);
---

$(SHELL_SMALL
Gösterdiği değer: 180
)

$(H5 $(IX ., gösterge) Gösterdiğinin üyesine erişim için $(C .) (nokta) işleci)

$(P $(I Not: Eğer göstergeleri C'den tanıyorsanız, bu işleç C'deki $(C ->) işleci ile aynıdır.)
)

$(P
$(C *) işlecinin gösterilen değişkene erişim için kullanıldığını gördük. Bu, temel türleri gösteren göstergeler için yeterli derecede kullanışlıdır: $(C *benimGöstergem) yazılarak gösterilen değere kolayca erişilir.
)

$(P
Gösterilen değişken yapı veya sınıf nesnesi olduğunda ise bu yazım sıkıntılı hale gelir. Örnek olarak $(C x) ve $(C y) üyeleri ile iki boyutlu düzlemdeki bir noktayı ifade eden bir yapıya bakalım:
)

---
struct Konum {
    int x;
    int y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}
---

$(P
O türden bir değişkeni gösteren bir göstergeyi aşağıdaki gibi tanımlayabiliriz ve gösterdiğine erişebiliriz:
)

---
    auto merkez = Konum(0, 0);
    Konum * gösterge = $(HILITE &)merkez;     // tanım
    writeln($(HILITE *)gösterge);             // erişim
---

$(P
$(C toString) işlevi tanımlanmış olduğundan, o kullanım $(C Konum) nesnesini yazdırmak için yeterlidir:
)

$(SHELL_SMALL
(0,0)
)

$(P
Ancak, gösterilen nesnenin bir üyesine erişmek için $(C *) işleci kullanıldığında kod karmaşıklaşır:
)

---
    // 10 birim sağa ötele
    (*gösterge).x += 10;
---

$(P
O ifade $(C merkez) nesnesinin $(C x) üyesinin değerini değiştirmektedir. Bunu şu adımlarla açıklayabiliriz:
)

$(UL
$(LI $(C gösterge): $(C merkez)'i gösteren gösterge)

$(LI $(C $(HILITE *)gösterge): Nesneye erişim; yani $(C merkez)'in kendisi)

$(LI $(C $(HILITE &#40;)*gösterge$(HILITE &#41;)): Nokta karakteri gösterge'ye değil, onun gösterdiğine uygulansın diye gereken parantezler)

$(LI $(C (*gösterge)$(HILITE .x)): Gösterdiği nesnenin $(C x) üyesi)
)

$(P
Gösterilen nesnenin üyesine erişim böyle karışık bir şekilde yazılmak zorunda kalınmasın diye, $(C .) (nokta) işleci göstergenin kendisine uygulanır ama $(I gösterdiğinin üyesine) erişim sağlar. Yukarıdaki ifadeyi çok daha kısa olarak şöyle yazabiliriz:
)

---
    $(HILITE gösterge.x) += 10;
---

$(P
Daha basit olan $(C gösterge.x) ifadesi yine $(C merkez)'in $(C x) üyesine eriştirmiştir:
)

$(SHELL_SMALL
(10,0)
)

$(P
Bunun sınıflardaki kullanımla aynı olduğuna dikkat edin. Bir sınıf $(I değişkenine) doğrudan uygulanan $(C .) (nokta) işleci aslında sınıf $(I nesnesinin) üyesine erişim sağlar:
)

---
class SınıfTürü {
    int üye;
}

// ...

    // Solda değişken, sağda nesne
    SınıfTürü değişken = new SınıfTürü;

    // Değişkene uygulanır ama nesnenin üyesine erişir
    değişken.üye = 42;
---

$(P
$(LINK2 /ders/d/siniflar.html, Sınıflar bölümünden) hatırlayacağınız gibi, yukarıdaki koddaki nesne, $(C new) ile sağda isimsiz olarak oluşturulur. $(C değişken), o nesneye erişim sağlayan bir sınıf değişkenidir. Değişkene uygulanan $(C .) (nokta) işleci aslında asıl nesnenin üyesine erişim sağlar.
)

$(P
Aynı durumun göstergelerde de bulunması sınıf değişkenleri ile göstergelerin temelde benzer biçimde gerçekleştirildiklerini ortaya koyar.
)

$(P
Bu kullanımın hem sınıflarda hem de göstergelerde bir istisnası vardır. $(C .) (nokta) işleciyle erişilen $(C .sizeof) gibi tür nitelikleri türün kendisine uygulanır, nesneye değil:
)

---
    char c;
    char * g;

    writeln(g.sizeof);  // göstergenin uzunluğu, char'ın değil
---

$(SHELL_SMALL
8
)

$(H5 Gösterge değerinin değiştirilmesi)

$(P
Göstergelerin değerleri arttırılabilir ve azaltılabilir, ve göstergeler toplama ve çıkarma işlemlerinde kullanılabilir:
)

---
    ++birGösterge;
    --birGösterge;
    birGösterge += 2;
    birGösterge -= 2;
    writeln(birGösterge + 3);
    writeln(birGösterge - 3);
---

$(P
Aritmetik işlemlerden alıştığımızdan farklı olarak, bu işlemler göstergenin değerini belirtilen miktar kadar değiştirmezler. Göstergenin değeri, $(I belirtilen miktar kadar sonraki (veya önceki)) değişkeni gösterecek biçimde değişir.
)

$(P
Örneğin, göstergenin değerinin $(C ++) işleciyle arttırılması o göstergenin bellekte bir sonra bulunan değişkeni göstermesini sağlar:
)

---
    ++birGösterge;  // daha önce gösterdiğinden bir sonraki
                    // değişkeni göstermeye başlar
---

$(P
Bunun sağlanabilmesi için göstergenin değerinin türün büyüklüğü kadar arttırılması gerekir. Örneğin, $(C int)'in büyüklüğü 4 olduğundan $(C int*) türündeki bir göstergenin değeri $(C ++) işlemi sonucunda 4 artar.
)

$(P $(B Uyarı): Göstergelerin programa ait olmayan adresleri göstermeleri tanımsız davranıştır. Erişmek için kullanılmasa bile, bir göstergenin var olmayan bir değişkeni göstermesi hatalıdır. ($(I Not: Bunun tek istisnası, bir dizinin sonuncu elemanından sonraki hayali elemanın gösterilebilmesidir. Bunu aşağıda açıklıyorum.))
)

$(P
Örneğin, yukarıda tek $(C int) olarak tanımlanmış olan $(C beygirGücü) değişkenini gösteren göstergenin arttırılması yasal değildir:
)

---
    ++benimGöstergem;       $(CODE_NOTE_WRONG tanımsız davranış)
---

$(P
Tanımsız davranış, o işlemin sonucunda ne olacağının belirsiz olması anlamına gelir. O işlem sonucunda programın çökeceği sistemler bulunabilir. Modern bilgisayarlardaki mikro işlemcilerde ise göstergenin değeri büyük olasılıkla 4 sonraki bellek adresine sahip olacak ve gösterge yukarıda "(boş)" olarak işaretlenmiş olan alanı gösterecektir.
)

$(P
O yüzden, göstergelerin değerlerinin arttırılması veya azaltılması ancak yan yana bulunduklarından emin olunan değişkenler gösterildiğinde kullanılmalıdır. Diziler (ve dizgiler) bu tanıma uyarlar: Bir dizinin elemanları bellekte yan yanadır (yani $(I art ardadır)).
)

$(P
Dizi elemanını gösteren bir göstergenin değerinin $(C ++) işleci ile artırılması onun bir sonraki elemanı göstermesini sağlar:
)

---
import std.stdio;
import std.string;
import std.conv;

enum Renk { kırmızı, sarı, mavi }

struct KurşunKalem {
    Renk renk;
    double uzunluk;

    string toString() const {
        return format("%s santimlik %s bir kalem",
                      uzunluk, renk);
    }
}

void main() {
    writeln("KurşunKalem nesnelerinin büyüklüğü: ",
            KurşunKalem.sizeof, " bayt");

    KurşunKalem[] kalemler = [ KurşunKalem(Renk.kırmızı, 11),
                               KurşunKalem(Renk.sarı, 12),
                               KurşunKalem(Renk.mavi, 13) ];

    $(HILITE KurşunKalem * gösterge) = $(HILITE &)kalemler[0];            // (1)

    for (int i = 0; i != kalemler.length; ++i) {
        writeln("gösterge değeri: ", $(HILITE gösterge));       // (2)

        writeln("kalem: ", $(HILITE *gösterge));                // (3)
        $(HILITE ++gösterge);                                   // (4)
    }
}
---

$(OL
$(LI Tanımlanması: Dizinin ilk elemanının adresi ile ilklenmektedir)
$(LI Değerinin kullanılması: Değeri, gösterdiği elemanın adresidir)
$(LI Gösterdiği nesneye erişim)
$(LI Bir sonraki nesneyi göstermesi)
)

$(P
Çıktısı:
)

$(SHELL
KurşunKalem nesnelerinin büyüklüğü: 12 bayt
gösterge değeri: 114FC0
kalem: 11 santimlik kırmızı bir kalem
gösterge değeri: 114FCC
kalem: 12 santimlik sarı bir kalem
gösterge değeri: 114FD8
kalem: 13 santimlik mavi bir kalem
)

$(P
Dikkat ederseniz, yukarıdaki döngü $(C kalemler.length) kere tekrarlanmakta ve o yüzden gösterge hep var olan bir elemanı göstermektedir.
)

$(H5 Göstergeler risklidir)

$(P
Göstergelerin doğru olarak kullanılıp kullanılmadıkları konusunda denetim sağlanamaz. Ne derleyici, ne de çalışma zamanındaki denetimler bunu garantileyebilirler. Bir göstergenin değerinin her zaman için geçerli olması programcının sorumluluğundadır.
)

$(P
O yüzden, göstergeleri kullanmayı düşünmeden önce D'nin üst düzey ve güvenli olanaklarının yeterli olup olmadıklarına bakmanızı öneririm.
)

$(H5 $(IX eleman, sonuncudan sonraki) Dizinin son elemanından bir sonrası)

$(P
Dizinin sonuncu elemanından hemen sonraki hayali elemanın gösterilmesi yasaldır.
)

$(P
Bu, dilimlerden alışık olduğumuz aralık kavramına benzeyen yöntemlerde kullanışlıdır. Hatırlarsanız, dilim aralıklarının ikinci indeksi işlem yapılacak olan elemanlardan $(I bir sonrasını) gösterir:
)

---
    int[] sayılar = [ 0, 1, 2, 3 ];
    writeln(sayılar[1 .. 3]);   // 1 ve 2 dahil, 3 hariç
---

$(P
Bu yöntem göstergelerle de kullanılabilir. Başlangıç göstergesinin ilk elemanı göstermesi ve bitiş göstergesinin son elemandan sonraki elemanı göstermesi yaygın bir işlev tasarımıdır.
)

$(P
Bunu bir işlevin parametrelerinde görelim:
)

---
import std.stdio;

// Kendisine verilen aralıktaki değerleri 10 katına çıkartır
void onKatı(int * baş, int * son) {
    while (baş != son) {
        *baş *= 10;
        ++baş;
    }
}

void main() {
    int[] sayılar = [ 0, 1, 2, 3 ];
    int * baş = &sayılar[1];  // ikinci elemanın adresi
    onKatı(baş, baş + 2);     // ondan iki sonrakinin adresi
    writeln(sayılar);
}
---

$(P
$(C baş + 2) değeri, $(C baş)'ın gösterdiğinden 2 sonraki elemanın, yani indeksi 3 olan elemanın adresi anlamına gelir.
)

$(P
Yukarıdaki $(C onKatı) işlevi, iki gösterge almaktadır; bunlardan ilkinin gösterdiği $(C int)'i kullanmakta ama ikincisinin gösterdiği $(C int)'e hiçbir zaman erişmemektedir. İkinci göstergeyi, işlem yapacağı $(C int)'lerin dışını belirten bir değer olarak kullanmaktadır. $(C son)'un gösterdiği elemanı kullanmadığı için de dizinin yalnızca 1 ve 2 numaralı indeksli elemanları değişmiştir:
)

$(SHELL_SMALL
0 10 20 3
)

$(P
Yukarıdaki gibi işlevler $(C for) döngüleri ile de gerçekleştirilebilir:
)

---
    for ( ; baş != son; ++baş) {
        *baş *= 10;
    }
---

$(P
Dikkat ederseniz, $(C for) döngüsünün hazırlık bölümü boş bırakılmıştır. Bu işlev yeni bir gösterge kullanmak yerine doğrudan $(C baş) parametresini arttırmaktadır.
)

$(P
Aralık bildiren çift göstergeler $(C foreach) deyimi ile de uyumlu olarak kullanılabilir:
)

---
    foreach (gösterge; baş .. son) {
        *gösterge *= 10;
    }
---

$(P
Bu gibi bir yöntemde bir dizinin elemanlarının $(I hepsinin birden) kullanılabilmesi için ikinci göstergenin dizinin sonuncu elemanından bir sonrayı göstermesi gerekir:
)

---
    // ikinci gösterge dizinin sonuncu elemanından sonraki
    // hayali bir elemanı gösteriyor:
    onKatı(baş, baş + sayılar.length);
---

$(P
Dizilerin son elemanlarından sonraki $(I aslında var olmayan) bir elemanın gösterilmesi işte bu yüzden yasaldır.
)

$(H5 $(IX []) Dizi erişim işleci $(C []) ile kullanımı)

$(P
D'de hiç gerekmese de göstergeler bir dizinin elemanlarına erişir gibi de kullanılabilirler:
)

---
    double[] kesirliler = [ 0.0, 1.1, 2.2, 3.3, 4.4 ];

    double * gösterge = &kesirliler[2];

    *gösterge = -100;          // gösterdiğine erişim
    gösterge$(HILITE [1]) = -200;        // dizi gibi erişim

    writeln(kesirliler);
---

$(P
Çıktısı:
)

$(SHELL_SMALL
0 1.1 -100 -200 4.4
)

$(P
Böyle bir kullanımda göstergenin göstermekte olduğu değişken sanki bir dilimin ilk elemanıymış gibi düşünülür ve $(C []) işleci o hayali dilimin belirtilen elemanına erişim sağlar. Yukarıdaki programdaki $(C gösterge), $(C kesirliler) dizisinin 2 indeksli elemanını göstermektedir. $(C gösterge[1]) kullanımı, sanki hayali bir dilim varmış gibi o dilimin 1 indeksli elemanına, yani asıl dizinin 3 indeksli elemanına erişim sağlar.
)

$(P
Karışık görünse de bu kullanımın temelinde çok basit bir dönüşüm yatar. Derleyici $(C gösterge[indeks]) gibi bir yazımı perde arkasında $(C *(gösterge&nbsp;+&nbsp;indeks)) ifadesine dönüştürür:
)

---
    gösterge[1] = -200;      // dizi gibi erişim
    *(gösterge + 1) = -200;  // üsttekiyle aynı elemana erişim
---

$(P
Yukarıda da belirttiğim gibi, bu kullanımın geçerli bir değişkeni gösterip göstermediği denetlenemez. Güvenli olabilmesi için bunun yerine dilim kullanılmalıdır:
)

---
    double[] dilim = kesirliler[2 .. 4];
    dilim[0] = -100;
    dilim[1] = -200;
---

$(P
O dilimin yalnızca iki elemanı bulunduğuna dikkat edin. Dilim, asıl dizinin 2 ve 3 indeksli elemanlarına erişim sağlamaktadır. İndeksi 4 olan eleman dilimin dışındadır.
)

$(P
Dilimler güvenlidir; eleman erişimi hataları çalışma zamanında yakalanır:
)

---
    dilim[2] = -300;   // HATA: dilimin dışına erişim
---

$(P
Dilimin 2 indeksli elemanı bulunmadığından bir hata atılır ve böylece programın yanlış sonuçlarla devam etmesi önlenmiş olur:
)

$(SHELL_SMALL
core.exception.RangeError@deneme(8391): Range violation
)

$(H5 $(IX dilim, gösterge) Göstergeden dilim elde etmek)

$(P
Dizi erişim işleciyle sorunsuz olarak kullanılabiliyor olmaları göstergelerin dilimlerle eşdeğer oldukları düşüncesini doğurabilir ancak bu doğru değildir. Göstergeler hem dilimlerin aksine eleman adedini bilmezler hem de aslında tek değişken gösterebildiklerinden dilimler kadar kullanışlı ve güvenli değillerdir.
)

$(P
Buna rağmen, art arda kaç eleman bulunduğunun bilindiği durumlarda göstergelerden dilim oluşturulabilir. Böylece riskli göstergeler yerine kullanışlı ve güvenli dilimlerden yararlanılmış olur.
)

$(P
Aşağıdaki koddaki $(C nesnelerOluştur)'un bir C kütüphanesinin bir işlevi olduğunu varsayalım. Bu işlev $(C Yapı) türünden belirtilen adet nesne oluşturuyor olsun ve bu nesnelerden ilkinin adresini döndürüyor olsun:
)

---
    Yapı * gösterge = nesnelerOluştur(10);
---

$(P
Belirli bir göstergenin göstermekte olduğu elemanlara erişim sağlayacak olan dilim oluşturan söz dizimi aşağıdaki gibidir:
)

---
    /* ... */ dilim = gösterge[0 .. adet];
---

$(P
Buna göre, $(C nesnelerOluştur)'un oluşturduğu ve ilkinin adresini döndürdüğü 10 elemana erişim sağlayan bir dilim aşağıdaki gibi oluşturulur:
)

---
    Yapı[] dilim = gösterge[0 .. 10];
---

$(P
Artık $(C dilim) programda normal bir D dilimi gibi kullanılmaya hazırdır:
)

---
    writeln(dilim[1]);    // İkinci elemanı yazdırır
---

$(H5 $(IX void*) Her türü gösterebilen $(C void*))

$(P
D'de hemen hemen hiç gerekmese de, yine C'den gelen bir olanak, $(I herhangi türden) değişkenleri gösterebilen göstergelerdir. Bunlar $(I void göstergesi) olarak tanımlanırlar:
)

---
    int tamsayı = 42;
    double kesirli = 1.25;
    void * herTürüGösterebilen;

    herTürüGösterebilen = &tamsayı;
    herTürüGösterebilen = &kesirli;
---

$(P
Yukarıdaki koddaki $(C void*) türünden olan gösterge hem bir $(C int)'i hem de bir $(C double)'ı gösterebilmektedir. O satırların ikisi de yasaldır ve hatasız olarak derlenir.
)

$(P
$(C void*) türünden olan göstergeler kısıtlıdır. Getirdikleri esnekliğin bir sonucu olarak, gösterdikleri değişkenlere kendileri erişim sağlayamazlar çünkü gösterilen asıl tür bilinmediğinden gösterilen elemanın kaç baytlık olduğu da bilinemez:
)

---
    *herTürüGösterebilen = 43;     $(DERLEME_HATASI)
---

$(P
Böyle işlemlerde kullanılabilmesi için, $(C void*)'nin değerinin önce doğru türü gösteren bir göstergeye aktarılması gerekir:
)

---
    int tamsayı = 42;                         // (1)
    void * herTürüGösterebilen = &tamsayı;    // (2)

    // ...

    int * tamsayıGöstergesi = cast(int*)herTürüGösterebilen; // (3)
    *tamsayıGöstergesi = 43;                  // (4)
---

$(P
Yukarıdaki örnek kodu şu adımlarla açıklayabiliriz:
)

$(OL
$(LI Asıl değişken)
$(LI Değişkenin değerinin bir $(C void*) içinde saklanması)
$(LI Daha sonra o değerin doğru türü gösteren bir göstergeye aktarılması)
$(LI Değişkenin değerinin doğru türü gösteren gösterge ile erişilerek değiştirilmesi)
)

$(P
$(C void*) türündeki bir göstergenin değeri arttırılabilir veya azaltılabilir. $(C void*) aritmetik işlemlerde $(C ubyte) gibi tek baytlık bir türün göstergesiymiş gibi işlem görür:
)

---
    ++herTürüGösterebilen;    // değeri 1 artar
---

$(P
D'de $(C void*) çoğunlukla C kütüphaneleri kullanılırken gerekir. $(C interface), sınıf, şablon, vs. gibi üst düzey olanakları bulunmayan C kütüphaneleri $(C void*) türünden yararlanmış olabilirler.
)

$(H5 Mantıksal ifadelerde kullanılmaları)

$(P
Göstergeler otomatik olarak $(C bool) türüne dönüşebilirler. Bu onların değerlerinin mantıksal ifadelerde kullanılabilmesini sağlar. $(C null) değere sahip olan göstergeler mantıksal ifadelerde $(C false) değerini alırlar, diğerleri de $(C true) değerini. Yani hiçbir değişkeni göstermeyen göstergeler $(C false)'tur.
)

$(P
Çıkışa nesne yazdıran bir işlev düşünelim. Bu işlev, kaç bayt yazdığını da bir çıkış parametresi ile bildiriyor olsun. Ancak, o bilgiyi yalnızca özellikle istendiğinde veriyor olsun. Bunun isteğe bağlı olması işleve gönderilen göstergenin $(C null) olup olmaması ile sağlanabilir:
)

---
void bilgiVer(KurşunKalem kalem, size_t * baytAdedi) {
    immutable bilgi = format("Kalem: %s", kalem);
    writeln(bilgi);

    $(HILITE if (baytAdedi)) {
        *baytAdedi = bilgi.length;
    }
}
---

$(P
Kaç bayt yazıldığı bilgisinin gerekmediği durumlarda gösterge olarak $(C null) değeri gönderilebilir:
)

---
    bilgiVer(KurşunKalem(Renk.sarı, 7), $(HILITE null));
---

$(P
Bayt adedinin önemli olduğu durumlarda ise $(C null) olmayan bir değer:
)

---
    size_t baytAdedi;
    bilgiVer(KurşunKalem(Renk.mavi, 8), $(HILITE &baytAdedi));
    writeln("Çıkışa ", baytAdedi, " bayt yazılmış");
---

$(P
Bunu yalnızca bir örnek olarak kabul edin. Bayt adedinin işlevden her durumda döndürülmesi daha uygun bir tasarım olarak kabul edilebilir:
)

---
size_t bilgiVer(KurşunKalem kalem) {
    immutable bilgi = format("Kalem: %s", kalem);
    writeln(bilgi);

    return bilgi.length;
}
---

$(H5 $(IX new) $(C new) bazı türler için adres döndürür)

$(P
Şimdiye kadar sınıf nesneleri oluştururken karşılaştığımız $(C new)'ü yapı nesneleri, diziler, ve temel tür değişkenleri oluşturmak için de kullanabiliriz. $(C new) ile oluşturulan değişkenlere $(I dinamik değişken) denir.)

$(P
$(C new) önce bellekten değişken için gereken büyüklükte bir yer ayırır. Ondan sonra bu yerde bir değişken $(I kurar). Bu değişkenlerin kendi isimleri bulunmadığından onlara ancak $(C new)'ün döndürmüş olduğu referans ile erişilir.
)

$(P
Bu referans değişkenin türüne bağlı olarak farklı çeşittendir:
)

$(UL

$(LI Sınıf nesnelerinde şimdiye kadar çok gördüğümüz gibi bir $(I sınıf değişkenidir):

---
    Sınıf sınıfDeğişkeni = new Sınıf;
---

)

$(LI Yapı nesnelerinde ve temel türlerde bir $(I göstergedir):

---
    Yapı $(HILITE *) yapıGöstergesi = new Yapı;
    int $(HILITE *) intGöstergesi = new int;
---

)

$(LI Dizilerde ise bir $(I dinamik dizidir):

---
    int[] dinamikDizi = new int[100];
---

)

)

$(P
$(LINK2 /ders/d/auto.html, $(C auto) ve $(C typeof) bölümünden) hatırlayacağınız gibi, sol taraftaki tür isimleri yerine normalde $(C auto) anahtar sözcüğü kullanıldığından çoğunlukla bu ayrıma dikkat etmek gerekmez:
)

---
    auto sınıfDeğişkeni = new Sınıf;
    auto yapıGöstergesi = new Yapı;
    auto intGöstergesi = new int;
    auto dinamikDizi = new int[100];
---

$(P
Herhangi bir ifadenin tür isminin $(C typeof(Tür).stringof) yöntemiyle yazdırılabildiğini hatırlarsanız, $(C new)'ün değişik türler için ne döndürdüğü küçük bir programla şöyle görülebilir:
)

---
import std.stdio;

struct Yapı {
}

class Sınıf {
}

void main() {
    writeln(typeof(new int   ).stringof);
    writeln(typeof(new int[5]).stringof);
    writeln(typeof(new Yapı  ).stringof);
    writeln(typeof(new Sınıf ).stringof);
}
---

$(P
Çıktıdan anlaşıldığı gibi, $(C new) temel tür ve yapılar için gösterge türünde bir değer döndürmektedir:
)

$(SHELL_SMALL
int*
int[]
Yapı*
Sınıf
)

$(P
Eğer $(C new) ile oluşturulan dinamik değişkenin türü bir $(LINK2 /ders/d/deger_referans.html, değer türü) ise, o değişkenin yaşam süreci, programda ona eriştiren en az bir referans (örneğin, bir gösterge) bulunduğu sürece uzar. (Bu, referans türleri için varsayılan durumdur.)
)

$(H5 $(IX .ptr, dizi elemanı) $(IX gösterge, dizi elemanı) Dizilerin $(C .ptr) niteliği)

$(P
Dizilerin (ve dilimlerin) $(C .ptr) niteliği ilk elemanın adresini döndürür. Bu değerin türü eleman türünü gösteren bir göstergedir:
)

---
    int[] sayılar = [ 7, 12 ];

    int * ilkElemanınAdresi = sayılar$(HILITE .ptr);
    writeln("İlk eleman: ", *ilkElemanınAdresi);
---

$(P
Bu değer de C kütüphanelerini kullanırken yararlı olabilir. Bazı C işlevleri bellekte art arda bulunan elemanların ilkinin adresini alırlar.
)

$(P
Dizgilerin de dizi olduklarını hatırlarsanız, onların $(C .ptr) niteliği de ilk karakterlerinin adresini verir. Burada dikkat edilmesi gereken bir konu, dizgi elemanlarının $(I harf) değil, o harflerin Unicode kodlamasındaki karşılıkları olduklarıdır. Örneğin, ş harfi bir $(C char[]) veya $(C string) içinde iki tane $(C char) olarak bulunur.
)

$(P
$(C .ptr) niteliğinin döndürdüğü adres ile erişildiğinde, Unicode kodlamasında kullanılan karakterler ayrı ayrı gözlemlenebilirler. Bunu örnekler bölümünde göreceğiz.
)

$(H5 $(IX in, işleç) Eşleme tablolarının $(C in) işleci)

$(P
Aslında göstergeleri $(LINK2 /ders/d/esleme_tablolari.html, Eşleme Tabloları bölümünde) gördüğümüz $(C in) işleci ile de kullanmıştık. Orada henüz göstergeleri anlatmamış olduğumdan $(C in) işlecinin dönüş türünü $(I geçiştirmiş) ve o değeri üstü kapalı olarak bir mantıksal ifadede kullanmıştım:
)

---
    if ("mor" in renkKodları) {
        // evet, renkKodları'nda "mor" indeksli eleman varmış

    } else {
        // hayır, yokmuş...
    }
---

$(P
Aslında $(C in) işleci tabloda bulunuyorsa elemanın adresini, bulunmuyorsa $(C null) değerini döndürür. Yukarıdaki koşul da bu değerin $(C false)'a veya $(C true)'ya otomatik olarak dönüşmesi temeline dayanır.
)

$(P
$(C in)'in dönüş değerini bir göstergeye atarsak, tabloda bulunduğu durumlarda o elemana etkin biçimde erişebiliriz:
)

---
import std.stdio;

void main() {
    // Tamsayıdan string'e dönüşüm tablosu
    string[int] sayılar =
        [ 0 : "sıfır", 1 : "bir", 2 : "iki", 3 : "üç" ];

    int sayı = 2;
    auto $(HILITE eleman) = sayı in sayılar;               // (1)

    if ($(HILITE eleman)) {                                // (2)
        writeln("Biliyorum: ", $(HILITE *eleman));         // (3)

    } else {
        writeln(sayı, " sayısının yazılışını bilmiyorum");
    }
}
---

$(P
Yukarıdaki koddaki $(C eleman) göstergesi $(C in) işleci ile ilklenmekte (1) ve değeri bir mantıksal ifadede kullanılmaktadır (2). Değeri $(C null) olmadığında da gösterdiği değişkene erişilmektedir (3). Hatırlarsanız, $(C null) değerinin gösterdiği geçerli bir nesne olmadığı için, değeri $(C null) olan bir göstergenin gösterdiğine erişilemez.
)

$(P
Orada $(C eleman)'ın türü, eşleme tablosunun $(I değer türünde) bir göstergedir. Bu tablodaki değerler $(C string) olduklarından $(C in)'in dönüş türü $(C string*)'dir. Dolayısıyla, $(C auto) yerine tür açık olarak aşağıdaki gibi de yazılabilir:
)

---
    $(HILITE string *) eleman = sayı in sayılar;
---

$(H5 Ne zaman kullanmalı)

$(H6 Kütüphaneler gerektirdiğinde)

$(P
$(C readf) işlevinde de gördüğümüz gibi, kullandığımız bir kütüphane bizden bir gösterge bekliyor olabilir. Her ne kadar D kütüphanelerinde az sayıda olacaklarını düşünsek de, bu tür işlevlerle karşılaştığımızda onlara istedikleri türde gösterge göndermemiz gerekir.
)

$(P
Örneğin, bir C kütüphanesi olan gtk'den uyarlanmış olan gtkD'nin bazı işlevlerinin bazı parametreleri göstergedir:
)

---
    GdkGeometry boyutlar;
    // ... boyutlar nesnesinin üyelerinin kurulması ...

    pencere.setGeometryHints(/* ... */, $(HILITE &)boyutlar, /* ... */);
---

$(H6 Değer türünden değişkenleri göstermek için)

$(P
Yine kesinlikle gerekmese de, değer türünden olan bir değişkenin hangisiyle işlem yapılacağını bir gösterge ile belirleyebiliriz. Örnek olarak yazı-tura deneyi yapan bir programa bakalım:
)

---
import std.stdio;
import std.random;

void main() {
    size_t yazıAdedi = 0;
    size_t turaAdedi = 0;

    foreach (i; 0 .. 100) {
        size_t * hangisi = (uniform(0, 2) == 1)
                           ? &yazıAdedi
                           : &turaAdedi;
        ++(*hangisi);
    }

    writefln("yazı: %s  tura: %s", yazıAdedi, turaAdedi);
}
---

$(P
Tabii aynı işlemi gösterge kullanmadan da gerçekleştirebiliriz:
)

---
        uniform(0, 2) ? ++yazıAdedi : ++turaAdedi;
---

$(P
Veya bir $(C if) koşuluyla:
)

---
        if (uniform(0, 2)) {
            ++yazıAdedi;

        } else {
            ++turaAdedi;
        }
---

$(H6 Veri yapılarının üyelerinde)

$(P
Bazı veri yapılarının temeli göstergelere dayanır.
)

$(P
Dizilerin elemanlarının yan yana bulunmalarının aksine, bazı veri yapılarının elemanları bellekte birbirlerinden ayrı olarak dururlar. Bunun bir nedeni, elemanların veri yapısına farklı zamanlarda eklenmeleri olabilir. Böyle veri yapıları elemanların birbirlerini $(I göstermeleri) temeli üzerine kuruludur.
)

$(P
Örneğin, bağlı liste veri yapısının her düğümü kendisinden bir sonraki düğümü $(I gösterir). İkili ağaç veri yapısının düğümleri de sol ve sağ dallardaki düğümleri $(I gösterirler). Başka veri yapılarında da gösterge kullanımına çok rastlanır.
)

$(P
D'de veri yapıları referans türleri kullanarak da gerçekleştirilebilseler de göstergeler bazı durumlarda daha doğal olabilirler.
)

$(P
Gösterge üye örneklerini biraz aşağıda göreceğiz.
)

$(H6 Belleğe doğrudan erişmek gerektiğinde)

$(P
Göstergeler belleğe doğrudan ve bayt düzeyinde erişim sağlarlar. Hataya açık olduklarını akılda tutmak gerekir. Ek olarak, programa ait olmayan belleğe erişmek tanımsız davranıştır.
)

$(H5 Örnekler)

$(H6 Basit bir bağlı liste)

$(P
Bağlı liste veri yapısının elemanları $(I düğümler) halinde tutulurlar. Liste, her düğümün kendisinden bir sonraki düğümü $(I göstermesi) düşüncesi üzerine kuruludur. Sonuncu düğüm hiçbir düğümü göstermez (değeri $(C null)'dır):
)

$(MONO
   ilk düğüm            düğüm                  son düğüm
 ┌────────┬───┐     ┌────────┬───┐          ┌────────┬────┐
 │ eleman │ o────▶  │ eleman │ o────▶  ...  │ eleman │null│
 └────────┴───┘     └────────┴───┘          └────────┴────┘
)

$(P
Yukarıdaki şekil yanıltıcı olabilir: Düğümlerin bellekte art arda bulundukları sanılmamalıdır; düğümler normalde belleğin herhangi bir yerinde bulunabilirler. Önemli olan, her düğümün kendisinden bir sonraki düğümü gösteriyor olmasıdır.
)

$(P
Bu şekle uygun olarak, bir $(C int) listesinin düğümünü şöyle tanımlayabiliriz:
)

---
struct Düğüm {
    int eleman;
    Düğüm * sonraki;

    // ...
}
---

$(P $(IX özyinelemeli tür) $(I Not: Kendi türünden nesneleri gösterdiği için bunun) özyinelemeli $(I bir yapı olduğunu söyleyebiliriz.)
)

$(P
Bütün düğümlerin bir liste olarak düşünülmesi de yalnızca başlangıç düğümünü gösteren bir gösterge ile sağlanabilir:
)

---
struct Liste {
    Düğüm * baş;

    // ...
}
---

$(P
Bu bölümün amacından fazla uzaklaşmamak için burada yalnızca listenin başına eleman ekleyen işlevi göstermek istiyorum:
)

---
struct Liste {
    Düğüm * baş;

    void başınaEkle(int eleman) {
        baş = new Düğüm(eleman, baş);
    }

    // ...
}
---

$(P
Bu kodun en önemli noktası $(C başınaEkle) işlevini oluşturan satırdır. O satır yeni elemanı listenin başına ekler ve böylece bu yapının bir $(I bağlı liste) olmasını sağlar. ($(I Not: Aslında sonuna ekleme işlemi daha doğal ve kullanışlıdır. Bunu problemler bölümünde göreceğiz.))
)

$(P
Yukarıdaki satırda sağ tarafta dinamik bir $(C Düğüm) nesnesi oluşturuluyor. Bu yeni nesne kurulurken, $(C sonraki) üyesi olarak listenin şu andaki başı kullanılıyor. Listenin yeni başı olarak da bu yeni düğümün adresi kullanılınca, listenin başına eleman eklenmiş oluyor.
)

$(P
Bu küçük veri yapısını deneyen küçük bir program:
)

---
import std.stdio;
import std.conv;
import std.string;

struct Düğüm {
    int eleman;
    Düğüm * sonraki;

    string toString() const {
        string sonuç = to!string(eleman);

        if (sonraki) {
            sonuç ~= " -> " ~ to!string(*sonraki);
        }

        return sonuç;
    }
}

struct Liste {
    Düğüm * baş;

    void başınaEkle(int eleman) {
        baş = new Düğüm(eleman, baş);
    }

    string toString() const {
        return format("(%s)", baş ? to!string(*baş) : "");
    }
}

void main() {
    Liste sayılar;

    writeln("önce : ", sayılar);

    foreach (sayı; 0 .. 10) {
        sayılar.başınaEkle(sayı);
    }

    writeln("sonra: ", sayılar);
}
---

$(P
Çıktısı:
)

$(SHELL_SMALL
önce : ()
sonra: (9 -> 8 -> 7 -> 6 -> 5 -> 4 -> 3 -> 2 -> 1 -> 0)
)

$(H6 $(IX bellek erişimi, gösterge) $(C ubyte) göstergesi ile belleğin incelenmesi)

$(P
Belleğin adresleme birimi bayttır. Her adreste tek baytlık bilgi bulunur. Her değişken, kendi türü için gereken sayıda bayt $(I üzerinde) kurulur. Göstergeler belleğe bayt bayt erişme olanağı sunarlar.
)

$(P
Belleğe bayt olarak erişmek için en uygun tür $(C ubyte*)'dir. Bir değişkenin adresi bir $(C ubyte) göstergesine atanır ve bu gösterge ilerletilerek o değişkeni oluşturan baytların tümü gözlemlenebilir.
)

$(P
Burada açıklayıcı olsun diye değeri on altılı düzende yazılmış olan bir tamsayı olsun:
)

---
    int birSayı = 0x01_02_03_04;
---

$(P
Bu değişkeni gösteren bir göstergenin şu şekilde tanımlandığını gördük:
)

---
    int * adresi = &birSayı;
---

$(P
O göstergenin değeri, $(C birSayı)'nın bellekte bulunduğu yerin adresidir. Göstergenin değerini tür dönüşümü ile bir $(C ubyte) göstergesine de atayabiliriz:
)

---
    ubyte * baytGöstergesi = cast(ubyte*)adresi;
---

$(P
Bu adresteki $(C int)'i oluşturan 4 baytı şöyle yazdırabiliriz:
)

---
    writeln(baytGöstergesi[0]);
    writeln(baytGöstergesi[1]);
    writeln(baytGöstergesi[2]);
    writeln(baytGöstergesi[3]);
---

$(P
Eğer sizin mikro işlemciniz de benimki gibi $(I küçük soncul) ise, $(C int)'i oluşturan baytların bellekte $(I ters) sırada durduklarını görebilirsiniz:
)

$(SHELL_SMALL
4
3
2
1
)

$(P
Değişkenleri oluşturan baytları gözlemleme işini kolaylaştırmak için bir işlev şablonu yazabiliriz:
)

---
$(CODE_NAME baytlarınıGöster)import std.stdio;

void baytlarınıGöster(T)(ref T değişken) {
    const ubyte * baş = cast(ubyte*)&değişken;    // (1)

    writefln("tür    : %s", T.stringof);
    writefln("değer  : %s", değişken);
    writefln("adres  : %s", baş);                 // (2)
    writef  ("baytlar: ");

    writefln("%(%02x %)", baş[0 .. T.sizeof]);    // (3)

    writeln();
}
---

$(OL
$(LI Değişkenin adresinin bir $(C ubyte) göstergesine atanması)
$(LI Göstergenin değerinin, yani değişkenin başlangıç adresinin yazdırılması)
$(LI Türün büyüklüğünün $(C .sizeof) niteliği ile edinilmesi ve göstergenin gösterdiği baytların yazdırılması ($(C baş) göstergesinden dilim elde edildiğine ve o dilimin yazdırıldığına dikkat edin.))
)

$(P
Baytlar $(C *) işleci ile erişerek şöyle de yazılabilirdi:
)

---
    foreach (bayt; baş .. baş + T.sizeof) {
        writef("%02x ", *bayt);
    }
---

$(P
$(C bayt) göstergesinin değeri o döngüde $(C baş&nbsp;..&nbsp;baş + T.sizeof) aralığında değişir. $(C baş&nbsp;+&nbsp;T.sizeof) değerinin aralık dışında kaldığına ve ona hiçbir zaman erişilmediğine dikkat edin.
)

$(P
O işlev şablonunu değişik türlerle çağırabiliriz:
)

---
$(CODE_XREF baytlarınıGöster)struct Yapı {
    int birinci;
    int ikinci;
}

class Sınıf {
    int i;
    int j;

    this(int i, int j) {
        this.i = i;
        this.j = j;
    }
}

void main() {
    int tamsayı = 0x11223344;
    baytlarınıGöster(tamsayı);

    double kesirli = double.nan;
    baytlarınıGöster(kesirli);

    string dizgi = "merhaba dünya";
    baytlarınıGöster(dizgi);

    int[3] dizi = [ 1, 2, 3 ];
    baytlarınıGöster(dizi);

    auto yapıNesnesi = Yapı(0xaa, 0xbb);
    baytlarınıGöster(yapıNesnesi);

    auto sınıfDeğişkeni = new Sınıf(1, 2);
    baytlarınıGöster(sınıfDeğişkeni);
}
---

$(P
Çıktısı aydınlatıcı olabilir:
)

$(SHELL_SMALL
tür    : int
değer  : 287454020
adres  : BFFD6D0C
baytlar: 44 33 22 11                             $(SHELL_NOTE (1))

tür    : double
değer  : nan
adres  : BFFD6D14
baytlar: 00 00 00 00 00 00 f8 7f                 $(SHELL_NOTE (2))

tür    : string
değer  : merhaba dünya
adres  : BFFD6D1C
baytlar: 0e 00 00 00 e8 c0 06 08                 $(SHELL_NOTE (3))

tür    : int[3u]
değer  : 1 2 3
adres  : BFFD6D24
baytlar: 01 00 00 00 02 00 00 00 03 00 00 00     $(SHELL_NOTE (1))

tür    : Yapı
değer  : Yapı(170, 187)
adres  : BFFD6D34
baytlar: aa 00 00 00 bb 00 00 00                 $(SHELL_NOTE (1))

tür    : Sınıf
değer  : deneme.Sınıf
adres  : BFFD6D3C
baytlar: c0 ec be 00                             $(SHELL_NOTE (4))
)

$(P $(B Gözlemler:)
)

$(OL
$(LI Bazı türlerin baytları beklediğimiz gibidir: $(C int)'in, sabit uzunluklu dizinin ($(C int[3u])), ve yapı nesnesinin değerlerinin baytları bellekte ters sırada bulunmaktadır.)

$(LI $(C double.nan) özel değerini oluşturan baytları ters sırada düşününce bu değerin 0x7ff8000000000000 özel bit dizisi ile ifade edildiğini öğreniyoruz.)

$(LI $(C string) 8 bayttan oluşmaktadır; onun değeri olan "merhaba dünya"nın o kadar küçük bir alana sığması olanaksızdır. Bu, $(C string) türünün perde arkasında bir yapı gibi tanımlanmış olmasından gelir. Derleyicinin bir iç türü olduğunu vurgulamak için ismini $(C __) ile başlatarak, örneğin şöyle bir yapı olduğunu düşünebiliriz:

---
struct __string {
    size_t uzunluk;
    char * ptr;    // asıl karakterler
}
---

$(P
Bu tahmini destekleyen bulguyu $(C string)'i oluşturan baytlarda görüyoruz: Dikkat ederseniz, "merhaba dünya" dizgisindeki toplam 13 harf, içlerindeki ü'nün UTF-8 kodlamasında iki baytla ifade edilmesi nedeniyle 14 bayttan oluşur. $(C string)'in yukarıda görülen ilk 4 baytı olan 0x0000000e'nin değerinin onlu sistemde 14 olması bu gözlemi doğruluyor.
)

)

$(LI Benzer şekilde, sınıf nesnesini oluşturan $(C i) ve $(C j) üyelerinin 4 bayta sığmaları olanaksızdır; iki $(C int) için 8 bayt gerektiğini biliyoruz. O çıktı, sınıf değişkenlerinin sınıf nesnesini gösterecek şekilde tek bir göstergeden oluştuğu şüphesini uyandırır:

---
struct __Sınıf_DeğişkenTürü {
    __Sınıf_AsılNesneTürü * nesne;
}
---

)

)

$(P
Şimdi biraz daha esnek bir işlev düşünelim. Belirli bir değişkenin baytları yerine, belirli bir adresteki belirli sayıdaki baytı gösteren bir işlev yazalım:
)

---
$(CODE_NAME belleğiGöster)import std.stdio;
import std.ascii;

void belleğiGöster(T)(T * bellek, size_t uzunluk) {
    const ubyte * baş = cast(ubyte*)bellek;

    foreach (adres; baş .. baş + uzunluk) {
        char karakter = (isPrintable(*adres) ? *adres : '.');

        writefln("%s:  %02x  %s", adres, *adres, karakter);
    }
}
---

$(P
$(C std.ascii) modülünde tanımlı olan $(C isPrintable), kendisine verilen bayt değerinin ASCII tablosunun görüntülenebilen bir karakteri olup olmadığını bildirir. Bazı bayt değerlerinin tesadüfen uç birimin kontrol karakterlerine karşılık gelerek uç birimin çalışmasını bozmalarını önlemek için "$(C isPrintable) olmayan" karakterler yerine $(C '.') karakterini yazdırıyoruz.
)

$(P
Bu işlevi $(C string)'in $(C .ptr) niteliğinin gösterdiği karakterlere erişmek için kullanabiliriz:
)

---
$(CODE_XREF belleğiGöster)import std.stdio;

void main() {
    string dizgi = "merhaba dünya";
    belleğiGöster(dizgi.ptr, dizgi.length);
}
---

$(P
Çıktıdan anlaşıldığına göre ü harfi için iki bayt kullanılmaktadır:
)

$(SHELL_SMALL
8067F18:  6d  m
8067F19:  65  e
8067F1A:  72  r
8067F1B:  68  h
8067F1C:  61  a
8067F1D:  62  b
8067F1E:  61  a
8067F1F:  20   
8067F20:  64  d
8067F21:  c3  .
8067F22:  bc  .
8067F23:  6e  n
8067F24:  79  y
8067F25:  61  a
)

$(PROBLEM_COK

$(PROBLEM
Kendisine verilen iki $(C int)'in değerlerini değiş tokuş etmeye çalışan şu işlevi parametrelerinde $(C ref) kullanmadan düzeltin:

---
void değişTokuş(int birinci, int ikinci) {
    int geçici = birinci;
    birinci = ikinci;
    ikinci = geçici;
}

void main() {
    int i = 1;
    int j = 2;

    değişTokuş(i, j);

    // Değerleri değişsin
    assert(i == 2);
    assert(j == 1);
}
---

$(P
O programı çalıştırdığınızda $(C assert) denetimlerinin başarısız olduklarını göreceksiniz.
)

)

$(PROBLEM
Bu bölümde gösterilen liste yapısını şablona dönüştürün ve böylece $(C int)'ten başka türlerle de kullanılabilmesini sağlayın.
)

$(PROBLEM
Bağlı listede yeni elemanların sona eklenmeleri daha doğal bir işlemdir. Ben daha kısa olduğu için bu bölümde başına eklemeyi seçtim. Yeni elemanların listenin başına değil, sonuna eklenmelerini sağlayın.

$(P
Bunun için listenin sonuncu elemanını gösteren bir gösterge yararlı olabilir.
)

)

)

Macros:
        SUBTITLE=Göstergeler

        DESCRIPTION=Başka değişkenlere erişim sağlamak amacıyla kullanılan göstergeler (pointer)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial gösterge göstergeler pointer

SOZLER=
$(bagli_liste)
$(bayt_sirasi)
$(buyuk_soncul)
$(gosterge)
$(kucuk_soncul)
$(referans)
$(tanimsiz_davranis)
$(yazmac)
