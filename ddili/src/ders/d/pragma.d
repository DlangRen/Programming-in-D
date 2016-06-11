Ddoc

$(DERS_BOLUMU $(IX pragma) Pragmalar)

$(P
Pragma derleyiciyle etkileşme yöntemlerinden birisidir. Hem derleyiciye bilgi vermeye hem de ondan bilgi almaya yarar. Pragmalar şablonlardan başka kodlarda yararlı olsalar da, özellikle $(C pragma(msg)) şablonların hatalarını ayıklarken kullanışlıdır.
)

$(P
Her derleyici kendi özel pragmalarını tanımlayabilir ama aşağıdaki pragmalar standarttır:
)

$(H5 $(C pragma(msg)))

$(P
Derleme zamanında $(C stderr) çıkış akımına mesaj yazdırmaya yarar; çalışma zamanına bir etkisi yoktur.
)

$(P
Örneğin, aşağıdaki $(C pragma(msg)) bir işlev şablonunun tam olarak hangi parametrelerle çağrıldığını bildirmektedir:
)

---
import std.string;

void işlev(A, B)(A a, B b) {
    pragma($(HILITE msg), format("Şablon parametreleri: '%s' ve '%s'",
                       A.stringof, B.stringof));
    // ...
}

void main() {
    işlev(42, 1.5);
    işlev("merhaba", 'a');
}
---

$(SHELL
Şablon parametreleri: 'int' ve 'double'
Şablon parametreleri: 'string' ve 'char'
)

$(H5 $(C pragma(lib)))

$(P
Programın bağlanması gereken kütüphaneleri bildirmek için kullanılır. Programı sistemde kurulu olan bir kütüphaneyle bağlamanın en kolay yolu budur.
)

$(P
Örneğin, $(C curl) kütüphanesini kullanan aşağıdaki program kütüphaneyi derleme satırında belirtmek gerekmeden oluşturulabilir:
)

---
import std.stdio;
import std.net.curl;

pragma($(HILITE lib), "curl");

void main() {
    // Kitabın bu bölümünü indirmek:
    writeln(get("ddili.org/ders/d/pragma.html"));
}
---

$(H5 $(IX inline) $(IX kod içi işlev) $(IX işlev, kod içi) $(IX eniyileştirme, derleyici) $(C pragma(inline)))

$(P
İşlev içeriğinin kod içine $(I açılıp açılmayacağını) belirler.
)

$(P
Her işlev çağrısının bir masrafı vardır. Bu masraf, işlevin varsa parametrelerinin kopyalanmaları, varsa dönüş değerinin çağırana döndürülmesi, ve sonlandıktan sonra hangi noktadan devam edileceğinin hesabının tutulması ile ilgilidir.
)

$(P
Bu masraf çoğu durumda işlevin kendisinin ve çağıran tarafın diğer işlemlerinin masrafları yanında dikkate alınmayacak kadar küçüktür. Ancak, bazı durumlarda salt işlev çağrısı bile programın hızını ölçülebilir derecede yavaşlatabilir. Bu, özellikle işlev içeriğinin göreceli olarak hızlı olduğu ve yine göreceli olarak $(I küçük) bir döngüden çok sayıda çağrıldığı durumlarda görülebilir.
)

$(P
Aşağıdaki program küçük bir işlevi yine küçük bir döngü içinden çağırmakta ve bir sayacın değerini işlevin dönüş değerine bağlı olarak arttırmaktadır:
)

---
import std.stdio;
import std.datetime;

// Oldukça hızlı bir işlev içeriği:
ubyte hesapla(ubyte i) {
    return cast(ubyte)(i * 42);
}

void main() {
    size_t sayaç = 0;

    StopWatch kronometre;
    kronometre.start();

    // Çok sayıda tekrarlanan küçük bir döngü:
    foreach (i; 0 .. 100_000_000) {
        const parametre = cast(ubyte)i;

        if ($(HILITE hesapla(parametre)) == parametre) {
            ++sayaç;
        }
    }

    kronometre.stop();

    writefln("%s milisaniye", kronometre.peek.msecs);
}
---

$(P
$(IX StopWatch, std.datetime) Bu program döngünün ne kadar sürede işletildiğini $(C std.datetime.StopWatch) ile ölçmektedir:
)

$(SHELL
$(HILITE 674) milisaniye
)

$(P
$(IX -inline, derleyici seçeneği) $(C -inline) derleyici seçeneği, işlev içeriklerinin kod içine $(I açılmalarına) dayanan bir eniyileştirmeyi etkinleştirir:
)

$(SHELL
$ dmd deneme.d -w $(HILITE -inline)
)

$(P
İşlevin kod içine açılması, içeriğinin çağrıldığı noktaya sanki oraya elle yazılmış gibi yerleştirilmesi anlamına gelir. Yukarıdaki döngü bu eniyileştirme uygulandığında aşağıdaki eşdeğeri gibi derlenecektir:
)

---
    // Döngünün hesapla()'nın kod içine açıldığındaki eşdeğeri:
    foreach (i; 0 .. 100_000_000) {
        const parametre = cast(ubyte)i;

        const sonuç = $(HILITE cast(ubyte)(parametre * 42));
        if (sonuç == parametre) {
            ++sayaç;
        }
    }
---

$(P
Bu işlev çağrısının böylece ortadan kalkması programı denediğim ortamda %40 kadar bir zaman kazancı sağlamaktadır:
)

$(SHELL
$(HILITE 407) milisaniye
)

$(P
İşlevlerin kod içine açılmaları her ne kadar büyük bir kazanç gibi görünse de, bu eniyileştirme her duruma uygun değildir çünkü açılan işlevler kodun fazla büyümesine ve mikro işlemcinin kod ön belleğinden taşmasına neden olabilir. Bunun sonucunda da kod tam tersine $(I daha yavaş) işleyebilir. Bu yüzden, işlevlerin kod içine açılmalarının kararı normalde $(C -inline) seçeneği ile derleyiciye bırakılır.
)

$(P
Buna rağmen, bazı durumlarda derleyiciye bu konudaki kararında yardım edilmesi yararlı olabilir. $(C inline) pragması bu amaçla kullanılır:
)

$(UL

$(LI $(C pragma(inline, false)): $(C -inline) derleyici seçeneği kullanılmış bile olsa belirli işlevlerin kod içine açıl$(I ma)maları gerektiğini bildirir.)

$(LI $(C pragma(inline, true)): $(C -inline) derleyici seçeneği kullanıldığında belirli işlevlerin kesinlikle kod içine açılmaları gerektiğini bildirir. Bu eniyileştirmenin uygulanamadığı durumlarda derleme hataları oluşur. (Buna rağmen, bu pragmanın tam olarak nasıl işlediği derleyiciden derleyiciye değişebilir.))

$(LI $(C pragma(inline)): Kod içine açma kararını $(C -inline) seçeneğinin komut satırında belirtilmiş veya belirtilmemiş olmasına göre tekrar derleyiciye bırakır.)

)

$(P
Bu pragmalar, içinde geçtikleri işlevi etkileyebildikleri gibi, birden fazla işlev üzerinde etkili olabilmek için kapsam parantezleriyle veya iki nokta üst üste karakteriyle de kullanılabilirler:
)

---
pragma(inline, false)
$(HILITE {)
    // Bu kapsamda tanımlanan işlevler kod içine açılmazlar
    // ...
$(HILITE })

int foo() {
    pragma(inline, true);  // Bu işlev kod içine açılmalıdır
    // ...
}

pragma(inline, true)$(HILITE :)
// Bu bölümde tanımlanan işlevler kod içine açılmalıdırlar
// ...

pragma(inline)$(HILITE :)
// Bu bölümde tanımlanan işlevlerin kod içine açılıp
// açılmayacaklarının kararı tekrar derleyici bırakılmıştır
// ...
---

$(P
$(IX -O, derleyici seçeneği) Programların daha hızlı işlemelerini sağlayan bir başka derleyici seçeneği $(C -O)'dur. Bu seçenek derleyicinin başka eniyileştirme algoritmaları işletmesini sağlar. Ancak, bunun sonucunda derleme süreleri fazla uzayabilir.
)

$(H5 $(IX startaddress) $(C pragma(startaddress)))

$(P
Programın başlangıç adresini belirtmeye yarar. Başlangıç adresi zaten D'nin $(I çalışma ortamı) tarafından belirlendiğinden normalde bu pragmaya gerek olmaz.
)

$(H5 $(IX mangle, pragma) $(IX isim, özgün) $(IX özgün isim) $(C pragma(mangle)))

$(P
Özgün isim üretirken normal yöntemle üretilecek olandan farklı bir isim kullanılmasını belirler. Özgün isimler bağlayıcının işlevleri ve o işlevleri çağıranları tanıyabilmesi için önemlidir. Bu pragma özellikle D kodunun tesadüfen bir anahtar sözcüğe karşılık gelen bir kütüphane işlevini çağırması gereken durumlarda yararlıdır.
)

$(P
Örneğin, $(C body) bir D anahtar sözcüğü olduğundan bir C kütüphanesinin $(C body) ismindeki bir işlevi D kodundan çağrılamaz. İşlevin farklı bir isimle çağrılması ama yine de kütüphanenin $(C body) isimli işlevine bağlanması gerekir:
)

---
/* Bir C kütüphanesinin 'body' ismindeki işlevi ancak 'c_body'
 * gibi bir isimle çağrılabilir. Ancak, bu isim yine de 'body'
 * olarak bağlanmalıdır: */
pragma($(HILITE mangle), "body")
extern(C) string c_body(string);

void main() {
    /* D kodu işlevi c_body() diye çağırır ama bağlayıcı yine
     * de doğru ismi olan 'body'yi kullanacaktır: */
    auto s = $(HILITE c_body)("merhaba");
}
---

Macros:
        SUBTITLE=Pragmalar

        DESCRIPTION=Derleyiciyle etkileşme yöntemlerinden birisi olan pragmalar

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial pragma

SOZLER=
$(eniyilestirme)
$(kod_ici_islev)
$(mikro_islemci)
$(onbellek)
