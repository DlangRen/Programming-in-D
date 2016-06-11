Ddoc

$(DERS_BOLUMU $(IX do-while) $(IX döngü, do-while) $(CH4 do-while) Döngüsü)

$(P
$(LINK2 /ders/d/for_dongusu.html, $(C for) döngüsü) bölümünde $(LINK2 /ders/d/while_dongusu.html, $(C while))'ın işleyiş adımlarını da görmüştük:
)

$(MONO
hazırlık

koşul denetimi
asıl işlemler
ilerletilmesi

koşul denetimi
asıl işlemler
ilerletilmesi

...
)

$(P
$(C do-while)'ın $(C while)'dan farkı, koşul denetiminin sonda olması ve bu sayede işlemlerin en az bir kere işletilmeleridir:
)

$(MONO
hazırlık (while'dan daha az durumda gerekir)

asıl işlemler
ilerletilmesi
koşul denetimi    $(SHELL_NOTE koşul denetimi sonda)

asıl işlemler
ilerletilmesi
koşul denetimi    $(SHELL_NOTE koşul denetimi sonda)

...
)

$(P
Örneğin, tuttuğu sayının tahmin edilmesini bekleyen bir programda $(C do-while) döngüsü daha doğal gelebilir:
)

---
import std.stdio;
import std.random;

void main() {
    int sayı = uniform(1, 101);

    writeln("1'den 100'e kadar bir sayı tuttum.");

    int tahmin;

    do {
        write("Tahmininiz nedir? ");

        readf(" %s", &tahmin);

        if (sayı < tahmin) {
            write("tuttuğum sayı daha küçük; ");

        } else if (sayı > tahmin) {
            write("tuttuğum sayı daha büyük; ");
        }

    } while (tahmin != sayı);

    writeln("Doğru!");
}
---

$(P
$(C uniform), $(C std.random) modülünde bulunan bir işlevdir. Belirtilen aralıkta eşit dağılımlı rasgele sayılar üretir. Yukarıdaki kullanımında; aralığı  belirleyen ikinci değer, çıkacak sayılar arasında değildir. Diğer kullanımlarını öğrenmek için $(LINK2 http://dlang.org/phobos/std_random.html, std.random modülünün belgesine) bakabilirsiniz.
)

$(PROBLEM_TEK

$(P
Aynı oyunu bilgisayara oynatın; tuttuğunuz sayıyı en fazla 7 tahminde bulacaktır.
)

)

Macros:
        SUBTITLE=do-while Döngüsü

        DESCRIPTION=do-while döngüsünün tanıtılması ve while döngüsüne benzerliğinin gösterilmesi

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial do-while while

SOZLER=
$(dongu)
