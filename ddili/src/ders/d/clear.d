Ddoc

$(DERS_BOLUMU $(CH4 destroy) ve $(CH4 scoped))

$(P
$(LINK2 /ders/d/yasam_surecleri.html, Yaşam Süreçleri ve Temel İşlemler bölümünde) değişkenlerin kurma işlemiyle başlayan ve sonlandırma işlemiyle biten yaşam süreçlerini görmüştük.
)

$(P
Daha sonraki bölümlerde de nesnelerin kurulması sırasında gereken işlemlerin $(C this) isimli kurucu işlevde, sonlandırılması sırasında gereken işlemlerin de $(C ~this) isimli sonlandırıcı işlevde tanımlandıklarını öğrenmiştik.
)

$(P
Sonlandırıcı işlev, yapılarda ve başka $(I değer türlerinde) nesnenin yaşamı sona ererken $(I hemen) işletilir. Sınıflarda ve başka referans türlerinde ise çöp toplayıcı tarafından $(I sonraki bir zamanda) işletilir.
)

$(P
Burada önemli bir ayrım vardır: bir sınıf nesnesinin yaşamının sona ermesi ile sonlandırıcı işlevinin işletilmesi aynı zamanda gerçekleşmez. Nesnenin yaşamı, örneğin geçerli olduğu kapsamdan çıkıldığı an sona erer. Sonlandırıcı işlevi ise çöp toplayıcı tarafından belirsiz bir zaman sonra otomatik olarak işletilir.
)

$(P
Sonlandırıcı işlevlerin görevlerinden bazıları, nesne için kullanılmış olan sistem kaynaklarını geri vermektir. Örneğin $(C std.stdio.File) yapısı, işletim sisteminden kendi işi için almış olduğu dosya kaynağını sonlandırıcı işlevinde geri verir. Artık sonlanmakta olduğu için zaten o kaynağı kullanması söz konusu değildir.
)

$(P
Sınıfların sonlandırıcılarının çöp toplayıcı tarafından tam olarak ne zaman çağrılacakları belli olmadığı için, bazen kaynakların sisteme geri verilmeleri gecikebilir ve yeni nesneler için kaynak kalmayabilir.
)

$(H5 Sınıf sonlandırıcı işlevlerinin geç işletilmesini gösteren bir örnek)

$(P
Sınıfların sonlandırıcı işlevlerinin ilerideki belirsiz bir zamanda işletildiklerini göstermek için bir sınıf tanımlayalım. Bu sınıfın kurucu işlevi sınıfın $(C static) bir sayacını arttırsın ve sonlandırıcı işlevi de o sayacı azaltsın. Hatırlarsanız, $(C static) üyelerden bir tane bulunur: Sınıfın bütün nesneleri o tek üyeyi ortaklaşa kullanırlar. Böylece o sayacın değerine bakarak sınıfın nesnelerinden kaç tanesinin henüz sonlandırılmadıklarını anlayabileceğiz.
)

---
$(CODE_NAME YaşamıGözlenen)class YaşamıGözlenen {
    int[] dizi;       // ← her nesnenin kendisine aittir

    static int sayaç; // ← bütün nesneler tarafından
                      //   paylaşılır

    this() {
        /* Her nesne bellekte çok yer tutsun diye bu diziyi
         * çok sayıda int'lik hale getiriyoruz. Nesnelerin
         * böyle büyük olmalarının sonucunda çöp
         * toplayıcının bellek açmak için onları daha sık
         * sonlandıracağını umuyoruz. */
        dizi.length = 30_000;

        /* Bir nesne daha kurulmuş olduğundan nesne sayacını
         * bir arttırıyoruz. */
        ++sayaç;
    }

    ~this() {
        /* Bir nesne daha sonlandırılmış olduğundan nesne
         * sayacını bir azaltıyoruz. */
        --sayaç;
    }
}
---

$(P
O sınıfın nesnelerini bir döngü içinde oluşturan bir program:
)

---
$(CODE_XREF YaşamıGözlenen)import std.stdio;

void main() {
    foreach (i; 0 .. 20) {
        auto değişken = new YaşamıGözlenen;  // ← baş
        write(YaşamıGözlenen.sayaç, ' ');
    } // ← son

    writeln();
}
---

$(P
O programda oluşan her $(C YaşamıGözlenen) nesnesinin yaşamı aslında çok kısadır: $(C new) anahtar sözcüğüyle başlar, ve $(C foreach) döngüsünün kapama parantezinde son bulur. Yaşamları sona eren bu nesneler çöp toplayıcının sorumluluğuna girerler.
)

$(P
Programdaki $(COMMENT baş) ve $(COMMENT son) açıklamaları her nesnenin yaşamının başladığı ve sona erdiği noktayı gösteriyor. Nesnelerin sonlandırıcı işlevlerinin, yaşamlarının sona erdiği an işletilmediklerini sayacın değerine bakarak görebiliyoruz:
)

$(SHELL
1 2 3 4 5 6 7 1 2 3 4 5 6 7 1 2 3 4 5 6 
)

$(P
Yukarıdaki çıktıdan anlaşıldığına göre, çöp toplayıcının bellek ayırma algoritması, bu deneyde bu sınıfın sonlandırıcısını en fazla 7 nesne için ertelemiştir. ($(I Not: Bu çıktı çöp toplayıcının yürüttüğü algoritmaya, boş bellek miktarına ve başka etkenlere bağlı olarak farklı olabilir.))
)

$(H5 $(IX destroy) $(IX sonlandırıcı, işletilmesi) Nesnenin sonlandırıcısını işletmek için $(C destroy()))

$(P
"Ortadan kaldır" anlamına gelen $(C destroy()) nesnenin sonlandırıcı işlevini çağırır:
)

---
$(CODE_XREF YaşamıGözlenen)void main() {
    foreach (i; 0 .. 20) {
        auto değişken = new YaşamıGözlenen;
        write(YaşamıGözlenen.sayaç, ' ');
        $(HILITE destroy(değişken));
    }

    writeln();
}
---

$(P
$(C YaşamıGözlenen.sayaç)'ın değeri $(C new) satırında kurucu işlevin işletilmesi sonucunda arttırılır ve 1 olur. Değerinin yazdırıldığı satırdan hemen sonraki $(C destroy()) satırında da sonlandırıcı işlev tarafından tekrar sıfıra indirilir. O yüzden yazdırıldığı satırda hep 1 olduğunu görüyoruz:
)

$(SHELL
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
)

$(P
Açıkça sonlandırılan nesneler geçersiz kabul edilmelidirler ve artık kullanılmamalıdırlar:
)

---
    destroy(değişken);
    // ...
    // Dikkat: Geçersiz bir nesneye erişiliyor
    writeln(değişken.dizi);
---

$(P
Normalde referans türleri ile kullanılan $(C destroy), gerektiğinde $(C struct) nesnelerinin erkenden sonlandırılmaları için de kullanılabilir.
)

$(H5 Ne zaman kullanmalı)

$(P
Yukarıdaki örnekte gördüğümüz gibi, kaynakların çöp toplayıcının kararına kalmadan hemen geri verilmesi gerektiğinde kullanılır.
)

$(H5 Örnek)

$(P
$(LINK2 /ders/d/ozel_islevler.html, Kurucu ve Diğer Özel İşlevler bölümünde) $(C XmlElemanı) isminde bir yapı tanımlamıştık. O yapı, XML elemanlarını $(C &lt;etiket&gt;değer&lt;/etiket&gt;) şeklinde yazdırmak için kullanılıyordu. XML elemanlarının kapama etiketlerinin yazdırılması sonlandırıcı işlevin göreviydi:
)

---
struct XmlElemanı {
    // ...

    ~this() {
        writeln(girinti, "</", isim, '>');
    }
}
---

$(P
O yapıyı kullanan bir programla aşağıdaki çıktıyı elde etmiştik:
)

$(SHELL_SMALL
&lt;dersler&gt;
  &lt;ders0&gt;
    &lt;not&gt;
      72
    &lt;/not&gt;   $(SHELL_NOTE Kapama etiketleri doğru satırlarda beliriyor)
    &lt;not&gt;
      97
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;not&gt;
      90
    &lt;/not&gt;   $(SHELL_NOTE)
  &lt;/ders0&gt;   $(SHELL_NOTE)
  &lt;ders1&gt;
    &lt;not&gt;
      77
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;not&gt;
      87
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;not&gt;
      56
    &lt;/not&gt;   $(SHELL_NOTE)
  &lt;/ders1&gt;   $(SHELL_NOTE)
&lt;/dersler&gt;   $(SHELL_NOTE)
)

$(P
O çıktının doğru belirmesinin nedeni, $(C XmlElemanı)'nın bir yapı olmasıdır. Yapıların sonlandırıcıları hemen çağrıldıklarından, istenen çıktı, nesneleri uygun kapsamlara yerleştirerek elde edilir:
)

---
void $(CODE_DONT_TEST)main() {
    const $(HILITE dersler) = XmlElemanı("dersler", 0);

    foreach (dersNumarası; 0 .. 2) {
        const $(HILITE ders) =
            XmlElemanı("ders" ~ to!string(dersNumarası), 1);

        foreach (i; 0 .. 3) {
            const $(HILITE not) = XmlElemanı("not", 2);
            const rasgeleNot = uniform(50, 101);

            writeln(girintiDizgisi(3), rasgeleNot);

        } // ← not sonlanır

    } // ← ders sonlanır

} // ← dersler sonlanır
---

$(P
Nesneler açıklama satırları ile belirtilen noktalarda sonlandıkça XML kapama etiketlerini de çıkışa yazdırırlar.
)

$(P
Sınıfların farkını görmek için aynı programı bu sefer $(C XmlElemanı) bir sınıf olacak şekilde yazalım:
)

---
import std.stdio;
import std.array;
import std.random;
import std.conv;

string girintiDizgisi(in int girintiAdımı) {
    return replicate(" ", girintiAdımı * 2);
}

$(HILITE class) XmlElemanı {
    string isim;
    string girinti;

    this(in string isim, in int düzey) {
        this.isim = isim;
        this.girinti = girintiDizgisi(düzey);

        writeln(girinti, '<', isim, '>');
    }

    ~this() {
        writeln(girinti, "</", isim, '>');
    }
}

void main() {
    const dersler = $(HILITE new) XmlElemanı("dersler", 0);

    foreach (dersNumarası; 0 .. 2) {
        const ders = $(HILITE new) XmlElemanı(
            "ders" ~ to!string(dersNumarası), 1);

        foreach (i; 0 .. 3) {
            const not = $(HILITE new) XmlElemanı("not", 2);
            const rasgeleNot = uniform(50, 101);

            writeln(girintiDizgisi(3), rasgeleNot);
        }
    }
}
---

$(P
Referans türleri olan sınıfların sonlandırıcı işlevleri çöp toplayıcıya bırakılmış olduğu için programın çıktısı artık istenen düzende değildir:
)

$(SHELL_SMALL
&lt;dersler&gt;
  &lt;ders0&gt;
    &lt;not&gt;
      57
    &lt;not&gt;
      98
    &lt;not&gt;
      87
  &lt;ders1&gt;
    &lt;not&gt;
      84
    &lt;not&gt;
      60
    &lt;not&gt;
      99
    &lt;/not&gt;   $(SHELL_NOTE Kapama etiketlerinin hepsi en sonda beliriyor)
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;/not&gt;   $(SHELL_NOTE)
  &lt;/ders1&gt;   $(SHELL_NOTE)
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;/not&gt;   $(SHELL_NOTE)
  &lt;/ders0&gt;   $(SHELL_NOTE)
&lt;/dersler&gt;   $(SHELL_NOTE)
)

$(P
Bütün sonlandırıcı işlevler işletilmişlerdir ama kapama etiketleri beklenen yerlerde değildir. ($(I Not: Aslında çöp toplayıcı bütün nesnelerin sonlandırılacakları garantisini vermez. Örneğin programın çıktısında hiçbir kapama parantezi bulunmayabilir.))
)

$(P
$(C XmlElemanı)'nın sonlandırıcı işlevinin doğru noktalarda işletilmesini sağlamak için $(C destroy()) çağrılır:
)

---
void $(CODE_DONT_TEST)main() {
    const dersler = new XmlElemanı("dersler", 0);

    foreach (dersNumarası; 0 .. 2) {
        const ders = new XmlElemanı(
            "ders" ~ to!string(dersNumarası), 1);

        foreach (i; 0 .. 3) {
            const not = new XmlElemanı("not", 2);
            const rasgeleNot = uniform(50, 101);

            writeln(girintiDizgisi(3), rasgeleNot);

            $(HILITE destroy(not));
        }

        $(HILITE destroy(ders));
    }

    $(HILITE destroy(dersler));
}
---

$(P
Sonuçta, nesneler kapsamlardan çıkılırken sonlandırıldıkları için programın çıktısı yapı tanımında olduğu gibi düzgündür:
)

$(SHELL_SMALL
&lt;dersler&gt;
  &lt;ders0&gt;
    &lt;not&gt;
      66
    &lt;/not&gt;   $(SHELL_NOTE Kapama etiketleri doğru satırlarda belirmiş)
    &lt;not&gt;
      75
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;not&gt;
      68
    &lt;/not&gt;   $(SHELL_NOTE)
  &lt;/ders0&gt;   $(SHELL_NOTE)
  &lt;ders1&gt;
    &lt;not&gt;
      73
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;not&gt;
      62
    &lt;/not&gt;   $(SHELL_NOTE)
    &lt;not&gt;
      100
    &lt;/not&gt;   $(SHELL_NOTE)
  &lt;/ders1&gt;   $(SHELL_NOTE)
&lt;/dersler&gt;   $(SHELL_NOTE)
)

$(H5 $(IX scoped) Sonlandırıcı işlevi otomatik olarak çağırmak için $(C scoped))

$(P
Yukarıdaki programın bir yetersizliği vardır: Kapsamlardan daha $(C destroy()) satırlarına gelinemeden atılmış olan bir hata nedeniyle çıkılmış olabilir. Eğer $(C destroy()) satırlarının kesinlikle işletilmeleri gerekiyorsa, bunun bir çözümü $(LINK2 /ders/d/hatalar.html, Hatalar bölümünde) gördüğümüz $(C scope) ve diğer olanaklardan yararlanmaktır.
)

$(P
Başka bir yöntem, sınıf nesnesini $(C new) yerine $(C std.typecons.scoped) ile kurmaktır. $(C scoped()), sınıf değişkenini perde arkasında bir yapı nesnesi ile sarmalar. O yapı nesnesinin sonlandırıcısı kapsamdan çıkılırken otomatik olarak çağrıldığında sınıf nesnesinin sonlandırıcısını da çağırır.
)

$(P
$(C scoped)'un etkisi, yaşam süreçleri açısından sınıf nesnelerini yapı nesnelerine benzetmesidir.
)

$(P
Aşağıdaki değişikliklerden sonra program yine beklenen sonucu üretir:
)

---
$(HILITE import std.typecons;)
// ...
void $(CODE_DONT_TEST)main() {
    const dersler = $(HILITE scoped!)XmlElemanı("dersler", 0);

    foreach (dersNumarası; 0 .. 2) {
        const ders = $(HILITE scoped!)XmlElemanı(
            "ders" ~ to!string(dersNumarası), 1);

        foreach (i; 0 .. 3) {
            const not = $(HILITE scoped!)XmlElemanı("not", 2);
            const rasgeleNot = uniform(50, 101);

            writeln(girintiDizgisi(3), rasgeleNot);
        }
    }
}
---

$(P
$(C destroy()) satırlarının çıkartılmış olduklarına dikkat edin.
)

$(P
$(IX RAII) $(IX vekil) $(C scoped()), asıl sınıf nesnesini sarmalayan özel bir yapı nesnesi döndürür. Döndürülen nesne asıl nesnenin $(I vekili) $(ASIL proxy) olarak görev görür. (Aslında, yukarıdaki $(C dersler) nesnesinin türü $(C XmlElemanı) değil, $(C Scoped)'dur.)
)

$(P
Kendisi otomatik olarak sonlandırılırken vekil nesne sarmaladığı sınıf nesnesini de $(C destroy()) ile sonlandırır. (Bu, RAII yönteminin bir uygulamasıdır. $(C scoped()) bunu ilerideki bölümlerde göreceğimiz $(LINK2 /ders/d/sablonlar.html, şablon) ve $(LINK2 /ders/d/alias_this.html, $(C alias this)) olanaklarından yararlanarak gerçekleştirir.)
)

$(P
Vekil nesnelerinin kullanımlarının asıl nesne kadar doğal olması istenir. Bu yüzden, $(C scoped())'un döndürdüğü nesne sanki asıl türdenmiş gibi kullanılabilir. Örneğin, asıl türün üye işlevleri vekil nesne üzerinde çağrılabilirler:
)

---
import std.typecons;

class C {
    void foo() {
    }
}

void main() {
    auto v= scoped!C();
    v$(HILITE .foo());    // Vekil nesnesi v, C gibi kullanılıyor
}
---

$(P
Ancak, bu kolaylığın bir bedeli vardır: Vekil nesnesi asıl nesneye referans döndürdükten hemen sonra sonlanmış ve döndürülen referans o yüzden geçersiz kalmış olabilir. Bu durum asıl sınıf türü sol tarafta açıkça belirtildiğinde ortaya çıkabilir:
)

---
    $(HILITE C) c = scoped!C();    $(CODE_NOTE_WRONG HATALI)
    c.foo();             $(CODE_NOTE_WRONG Sonlanmış bir nesneye erişir)
---

$(P
Yukarıdaki $(C c) vekil nesnesi değil, açıkça $(C C) olarak tanımlandığından asıl nesneye erişim sağlamakta olan bir sınıf değişkenidir. Ne yazık ki bu durumda sağ tarafta kurulmuş olan vekil nesnesi kurulduğu ifadenin sonunda sonlandırılacaktır. Sonuçta, geçersiz bir nesneye erişim sağlamakta olan $(C c)'nin kullanılması tanımsız davranıştır. Örneğin, program bir çalışma zamanı hatasıyla çökebilir:
)

$(SHELL
Segmentation fault
)

$(P
O yüzden, $(C scoped()) değişkenlerini asıl tür ile tanımlamayın:
)

---
    $(HILITE C)         a = scoped!C();    $(CODE_NOTE_WRONG HATALI)
    auto      b = scoped!C();    $(CODE_NOTE doğru)
    const     c = scoped!C();    $(CODE_NOTE doğru)
    immutable d = scoped!C();    $(CODE_NOTE doğru)
---

$(H5 Özet)

$(UL

$(LI Bir sınıf nesnesinin sonlandırıcı işlevinin istenen bir anda çağrılması için $(C destroy()) işlevi kullanılır.)

$(LI $(C scoped()) ile kurulan sınıf nesnelerinin sonlandırıcıları kapsamdan çıkılırken otomatik olarak çağrılır.)

$(LI $(C scoped()) değişkenlerini asıl türün ismiyle tanımlamak hatalıdır.)

)

Macros:
        SUBTITLE=destroy ve scoped

        DESCRIPTION=Sınıf nesnelerinin sonlandırıcılarını çağıran destroy() işlevi ve destroy()'u sınıf nesneleri için otomatik olarak çağıran std.typecons.scoped

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial sınıf class sınıflar clear destroy scoped sonlandırma destructor

SOZLER=
$(cop_toplayici)
$(deger_turu)
$(kurma)
$(kurucu_islev)
$(referans_turu)
$(sonlandirici_islev)
$(sonlandirma)
$(vekil)
