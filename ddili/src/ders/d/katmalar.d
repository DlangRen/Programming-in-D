Ddoc

$(DERS_BOLUMU $(IX mixin) $(IX katma) Katmalar)

$(P
Katmalar, derleme zamanında şablonlar veya dizgiler tarafından üretilen kodların programın istenen noktalarına eklenmelerini sağlarlar.
)

$(H5 $(IX şablon katması) Şablon katmaları)

$(P
Şablonların belirli kalıplara göre kod üreten olanaklar olduklarını $(LINK2 /ders/d/sablonlar.html, Şablonlar) ve $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar) bölümlerinde görmüştük. Şablonlardan yararlanarak farklı parametre değerleri için işlev, yapı, birlik, sınıf, arayüz, ve yasal olduğu sürece her tür D kodunu oluşturabiliyorduk.
)

$(P
Şablon katmaları, bir şablon içinde tanımlanmış olan bütün kodların programın belirli bir noktasına, sanki oraya açıkça elle yazılmış gibi eklenmelerini sağlarlar. Bu açıdan, C ve C++ dillerindeki makrolar gibi işledikleri düşünülebilir.
)

$(P
$(C mixin) anahtar sözcüğü, şablonun belirli bir kullanımını programın herhangi bir noktasına yerleştirir. "Katmak", "içine karıştırmak" anlamına gelen "mix in"den türemiştir. $(C mixin) anahtar sözcüğünden sonra şablonun belirli parametre değerleri için bir kullanımı yazılır:
)

---
    mixin $(I bir_şablon)!($(I şablon_parametreleri))
---

$(P
O şablonun o parametrelerle kullanımı için üretilen kodlar, oldukları gibi $(C mixin) satırının bulunduğu noktaya yerleştirilirler. Aşağıdaki örnekte göreceğimiz gibi, $(C mixin) anahtar sözcüğü şablon katmalarının $(I tanımlarında) da kullanılır.
)

$(P
Örnek olarak bir köşe dizisini ve o köşeler üzerindeki işlemleri kapsayan bir şablon düşünelim:
)

---
$(CODE_NAME KöşeDizisiOlanağı)$(HILITE mixin) template KöşeDizisiOlanağı(T, size_t adet) {
    T[adet] köşeler;

    void köşeDeğiştir(size_t indeks, T köşe) {
        köşeler[indeks] = köşe;
    }

    void köşeleriGöster() {
        writeln("Bütün köşelerim:");

        foreach (i, köşe; köşeler) {
            writef("%s:%s ", i, köşe);
        }

        writeln();
    }
}
---

$(P
O şablon, dizi elemanlarının türü ve eleman adedi konusunda esneklik getirmektedir; tür ve eleman adedi ihtiyaca göre serbestçe seçilebilir.
)

$(P
O şablonun $(C int) ve $(C 2) parametreleri ile kullanımının istenmekte olduğu, bir $(C mixin) ile şöyle belirtilir:
)

---
    $(HILITE mixin) KöşeDizisiOlanağı!(int, 2);
---

$(P
Yukarıdaki $(C mixin), şablonun içindeki kodları kullanarak iki elemanlı $(C int) dizisini ve o diziyi kullanan iki işlevi oluşturur. Böylece, onları örneğin bir yapının üyeleri haline getirebiliriz:
)

---
$(CODE_NAME Çizgi)$(CODE_XREF KöşeDizisiOlanağı)struct Çizgi {
     mixin KöşeDizisiOlanağı!(int, 2);
}
---

$(P
Şablon içindeki kodlar, $(C T)'ye karşılık $(C int), ve $(C adet)'e karşılık $(C 2) olacak şekilde üretilirler ve $(C mixin) anahtar sözcüğünün bulunduğu yere yerleştirilirler. Böylece, $(C Çizgi) yapısı 2 elemanlı bir dizi ve o dizi ile işleyen iki işlev edinmiş olur:
)

---
$(CODE_XREF Çizgi)import std.stdio;

void main() {
    auto çizgi = Çizgi();
    çizgi.köşeDeğiştir(0, 100);
    çizgi.köşeDeğiştir(1, 200);
    çizgi.köşeleriGöster();
}
---

$(P
Program şu çıktıyı üretir:
)

$(SHELL
Bütün köşelerim:
0:100 1:200 
)

$(P
Aynı şablonu örneğin bir işlev içinde ve başka parametre değerleri ile de kullanabiliriz:
)

---
$(CODE_XREF KöşeDizisiOlanağı)struct Nokta {
    int x;
    int y;
}

void main() {
    $(HILITE mixin) KöşeDizisiOlanağı!($(HILITE Nokta), 5);

    köşeDeğiştir(3, Nokta(3, 3));
    köşeleriGöster();
}
---

$(P
O $(C mixin), $(C main)'in içine yerel bir dizi ve yerel iki işlev yerleştirir. Çıktısı:
)

$(SHELL
Bütün köşelerim:
0:Nokta(0,0) 1:Nokta(0,0) 2:Nokta(0,0) 3:Nokta(3,3) 4:Nokta(0,0) 
)

$(H6 $(IX yerel import) $(IX import, yerel) Şablon katmaları yerel $(C import) kullanmalıdır)

$(P
Şablon katmalarının oldukları gibi kod içine yerleştirilmeleri kendi kullandıkları modüller açısından bir sorun oluşturur: Şablonun kendi yararlandığı modüller şablonun sonradan eklendiği noktalarda mevcut olmayabilirler.
)

$(P
Örneğin, aşağıdaki şablonun $(C a) isimli bir modülde tanımlı olduğunu düşünelim. Doğal olarak, bu şablon yararlanmakta olduğu $(C format())'ın tanımlandığı $(C std.string) modülünü ekleyecektir:
)

---
module a;

$(HILITE import std.string;)    $(CODE_NOTE yanlış yerde)

mixin template A(T) {
    string a() {
        T[] dizi;
        // ...
        return format("%(%s, %)", dizi);
    }
}
---

$(P
Ancak, $(C std.string) modülü o şablonu kullanan ortamda eklenmiş değilse $(C format())'ın tanımının bilinmediği yönünde bir derleme hatası alınır. Örneğin, $(C a) modülünü kullanan aşağıdaki program derlenemez:
)

---
import a;

void main() {
    mixin A!int;    $(DERLEME_HATASI)
}
---

$(SHELL
Error: $(HILITE undefined identifier format)
Error: mixin deneme.main.A!int error instantiating
)

$(P
O yüzden, şablon katmalarının kullandıkları modüller yerel kapsamlarda eklenmelidirler:
)

---
module a;

mixin template A(T) {
    string a() {
        $(HILITE import std.string;)    $(CODE_NOTE doğru yerde)

        T[] dizi;
        // ...
        return format("%(%s, %)", dizi);
    }
}
---

$(P
Şablon tanımının içinde olduğu sürece, $(C import) bildirimi $(C a()) işlevinin dışında da bulunabilir.
)

$(H6 $(IX this, şablon parametresi) Sarmalayan türü katmanın içinde edinmek)

$(P
Bazı durumlarda katmanın kendisi içine katıldığı türü edinmek zorunda kalabilir. Bunun için daha önce $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar bölümünde) gördüğümüz $(C this) şablon parametrelerinden yararlanılır:
)

---
mixin template ŞablonKatması(T) {
    void birİşlev$(HILITE (this AsılTür))() {
        import std.stdio;
        writefln("İçine katıldığım asıl tür: %s",
                 $(HILITE AsılTür).stringof);
    }
}

struct BirYapı {
    mixin ŞablonKatması!(int);
}

void main() {
    auto a = BirYapı();
    a.birİşlev();
}
---

$(P
Çıktısı, katılan işlevin asıl türü $(C BirYapı) olarak edindiğini gösteriyor:
)

$(SHELL
İçine katıldığım asıl tür: BirYapı
)

$(H5 $(IX dizgi katması) $(IX string katması) Dizgi katmaları)

$(P
D'nin güçlü bir olanağı değerleri derleme sırasında bilinen dizgilerin de kod olarak programın içine yerleştirilebilmeleridir.
)

$(P
İçinde yasal D kodları bulunan her dizgi $(C mixin) anahtar sözcüğü ile programa eklenebilir. Bu kullanımda dizginin parantez içinde belirtilmesi gerekir:
)

---
    mixin $(HILITE $(PARANTEZ_AC))$(I derleme_zamanında_oluşturulan_dizgi)$(HILITE $(PARANTEZ_KAPA))
---

$(P
Örneğin, $(I merhaba dünya) programını bir dizgi katması ile şöyle yazabiliriz:
)

---
import std.stdio;

void main() {
    mixin (`writeln("merhaba dünya");`);
}
---

$(P
Dizgi içindeki kod $(C mixin) satırına eklenir, program derlenir, ve beklediğimiz çıktıyı verir:
)

$(SHELL
merhaba dünya
)

$(P
Bunun etkisini göstermek için biraz daha ileri gidebilir ve bütün programı bile bir dizgi katması olarak yazabiliriz:
)

---
mixin (
`import std.stdio; void main() { writeln("merhaba dünya"); }`
);
---

$(P
Bu örneklerdeki $(C mixin)'lere gerek olmadığı açıktır. O kodların şimdiye kadar hep yaptığımız gibi programa açıkça yazılmaları daha mantıklı olacaktır.
)

$(P
Dizgi katmalarının gücü, kodun derleme zamanında otomatik olarak oluşturulabilmesinden gelir. Derleme zamanında oluşturulabildiği sürece, $(C mixin) ifadesi işlevlerin döndürdüğü dizgilerden bile yararlanabilir. Aşağıdaki örnek $(C mixin)'e verilecek olan kod dizgilerini CTFE'den yararlanarak bir işleve oluşturtmaktadır:
)

---
import std.stdio;

string yazdırmaDeyimi(string mesaj) {
    return `writeln("` ~ mesaj ~ `");`;
}

void main() {
    mixin (yazdırmaDeyimi("merhaba dünya"));
    mixin (yazdırmaDeyimi("selam dünya"));
}
---

$(P
Yukarıdaki program, $(C yazdırmaDeyimi)'nin oluşturduğu iki dizgiyi $(C mixin) satırlarının yerlerine yerleştirir ve program o kodlarla derlenir. Burada dikkatinizi çekmek istediğim nokta, $(C writeln) işlevlerinin $(C yazdırmaDeyimi)'nin içinde çağrılmadıklarıdır. $(C yazdırmaDeyimi)'nin yaptığı, yalnızca içinde $(STRING "writeln") geçen dizgiler döndürmektir.
)

$(P
O dizgiler $(C mixin)'lerin bulundukları satırlara kod olarak yerleştirilirler. Sonuçta derlenen program, şunun eşdeğeridir:
)

---
import std.stdio;

void main() {
    writeln("merhaba dünya");
    writeln("selam dünya");
}
---

$(P
$(C mixin)'li program, sanki o iki $(C writeln) satırı varmış gibi derlenir ve çalışır:
)

$(SHELL
merhaba dünya
selam dünya
)

$(H5 $(IX isim alanı, katma) Katmaların isim alanları)

$(P
Şablon katmaları isim çakışmalarını önlemeye yönelik korumalar getirirler.
)

$(P
Örneğin, aşağıdaki programda $(C main())'in kapsamı içinde iki farklı $(C i) tanımı bulunmaktadır: Biri $(C main()) içinde açıkça tanımlanan, diğeri de $(C Şablon)'un kod içine katılması ile gelen. Şablon katması sonucunda oluşan isim çakışmaları durumunda şablonun getirdiği tanım değil, katmayı kapsayan isim alanındaki tanım kullanılır:
)

---
import std.stdio;

template Şablon() {
    $(HILITE int i;)

    void yazdır() {
        writeln(i);    // Her zaman için Şablon içindeki i'dir
    }
}

void main() {
    $(HILITE int i;)
    mixin Şablon;

    i = 42;        // main içindeki i'yi değiştirir
    writeln(i);    // main içindeki i'yi yazdırır
    yazdır();      // Şablon'un getirdiği i'yi yazdırır
}
---

$(P
Yukarıdaki açıklama satırlarından da anlaşılacağı gibi, her şablon katması kendi içeriğini sarmalayan bir isim alanı tanımlar ve şablon içindeki kodlar öncelikle o isim alanındaki isimleri kullanırlar. Bunu $(C yazdır())'ın davranışında görüyoruz:
)

$(SHELL
42
0     $(SHELL_NOTE yazdır()'ın yazdırdığı)
)

$(P
Birden fazla şablonun aynı ismi tanımlaması ise derleyicinin kendi başına karar veremeyeceği bir isim çakışmasıdır. Bunu görmek için aynı şablonu iki kere katmayı deneyelim:
)

---
template Şablon() {
    int i;
}

void main() {
    mixin Şablon;
    mixin Şablon;

    i = 42;        $(DERLEME_HATASI)
}
---

$(P
Derleme hatası hangi $(C i)'den bahsedildiğinin bilinemediğini bildirir:
)

$(SHELL
Error: deneme.main.Şablon!().i at ... $(HILITE conflicts with)
deneme.main.Şablon!().i at ...
)

$(P
Bu gibi isim çakışmalarını gidermenin yolu şablon katmalarına koda eklendikleri noktada isim alanı atamak ve onların içerdikleri isimleri bu isim alanları ile kullanmaktır:
)

---
    mixin Şablon $(HILITE A);    // A.i'yi tanımlar
    mixin Şablon $(HILITE B);    // B.i'yi tanımlar

    $(HILITE A.)i = 42;          // ← hangi i olduğu bellidir
---

$(P
Bu olanaklar dizgi katmalarında bulunmaz. Buna rağmen, bütün işi verilen bir dizgiyi şablon katması haline getiren bir şablondan yararlanarak bunun da üstesinden gelinebilir.
)

$(P
Bunu görmek için önce yukarıdaki isim çakışması sorununu bu sefer de bir dizgi katması ile yaşayalım:
)

---
void main() {
    mixin ("int i;");
    mixin ("int i;");    $(DERLEME_HATASI)

    i = 42;
}
---

$(P
Bu durumdaki derleme hatası $(C i)'nin zaten tanımlanmış olduğunu bildirir:
)

$(SHELL
Error: declaration deneme.main.i is $(HILITE already defined)
)

$(P
Bu sorunu gidermenin bir yolu dizgi katmasını şablon katmasına dönüştüren aşağıdaki gibi basit bir şablon kullanmaktır:
)

---
template ŞablonKatmasıOlarak(string dizgi) {
    mixin (dizgi);
}

void main() {
    mixin ŞablonKatmasıOlarak!("int i;") A;    // A.i'yi tanımlar
    mixin ŞablonKatmasıOlarak!("int i;") B;    // B.i'yi tanımlar

    A.i = 42;        // ← hangi i olduğu bellidir
}
---

$(H5 $(IX işleç yükleme, mixin) İşleç yüklemedeki kullanımı)

$(P
Bazı işleçlerin şablon söz dizimi ile tanımlandıklarını $(LINK2 /ders/d/islec_yukleme.html, İşleç Yükleme bölümünde) görmüştük. O söz dizimlerini o bölümde bir kalıp olarak kabul etmenizi rica etmiş ve onların şablonlarla ilgili bölümlerden sonra açıklığa kavuşacaklarını söylemiştim.
)

$(P
İşleç yüklemeyle ilgili olan üye işlevlerin şablonlar olarak tanımlanmalarının nedeni, işleçleri belirleyen şablon parametrelerinin $(C string) türünde olmaları ve bu yüzden dizgi katmalarından yararlanabilmeleridir. Bunun örneklerini hem o bölümde hem de o bölümün problem çözümlerinde görmüştük.
)

$(H5 Örnek)

$(P
($(I Not: Kıstasların bu örnekte olduğu gibi dizgi olarak belirtilmeleri isimsiz işlevlerin $(C =>) söz dizimlerinden daha eski bir olanaktır. Bu örnekteki dizgi kullanımı Phobos'ta hâlâ geçerli olsa da $(C =>) söz dizimi daha kullanışlıdır.))
)

$(P
Kendisine verilen sayılardan belirli bir koşula uyanlarını seçen ve bir dizi olarak döndüren bir işlev şablonuna bakalım:
)

---
int[] seç($(HILITE string koşul))(in int[] sayılar) {
    int[] sonuç;

    foreach (eleman; sayılar) {
        if ($(HILITE mixin (koşul))) {
            sonuç ~= eleman;
        }
    }

    return sonuç;
}
---

$(P
O işlev şablonu seçme koşulunu şablon parametresi olarak almakta ve $(C if) deyiminin parantezinin içine o koşulu olduğu gibi kod olarak yerleştirmektedir.
)

$(P
O ifadenin örneğin elemanların 7'den küçük olanlarını seçmesi için $(C if) deyimi içine şöyle bir ifadenin yazılması gerekir:
)

---
        if (eleman < 7) {
---

$(P
Yukarıdaki $(C seç) şablonu bize o koşulu programda bir dizgi olarak bildirme olanağı vermiş olur:
)

---
    int[] sayılar = [ 1, 8, 6, -2, 10 ];
    int[] seçilenler = seç!$(HILITE "eleman < 7")(sayılar);
---

$(P
Önemli bir ayrıntı olarak, $(C seç) şablonuna parametre olarak verilen dizginin içinde kullanılan değişken isminin $(C seç) işlevi içinde tanımlanan değişken ismi ile aynı olması şarttır ve o değişken isminin ne olduğu $(C seç) işlevinin belgelerinde belirtilmek zorundadır. O işlevi kullanan programcılar da o isme uymak zorundadırlar.
)

$(P
Bu amaçla kullanılan değişken isimleri konusunda Phobos'ta bir standart gelişmeye başlamıştır. Benim seçtiğim "eleman" gibi uzun bir isim değil; a, b, n diye tek harflik isimler kullanılır.
)

macros:
        SUBTITLE=Katmalar

        DESCRIPTION=Şablonlar aracılığıyla üretilen kodların programın belirli noktalarına yerleştirilmesini sağlayan "şablon katmaları", ve derleme zamanında oluşturulan dizgiler kod olarak kullanma olanağı sağlayan "dizgi katmaları".

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial şablon dizgi katma mixin

SOZLER=
$(katma)
$(sablon)
