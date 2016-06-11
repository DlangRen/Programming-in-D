Ddoc

$(COZUM_BOLUMU while Döngüsü)

$(OL

$(LI
$(C sayı)'nın ilk değeri 0 olduğu için $(C while) döngüsünün mantıksal ifadesi en baştan $(C false) oluyor ve döngüye bir kere bile girilmiyor. Bunun için programcılıkta çok kullanılan bir yöntem, döngüye girmeyi sağlayacak bir ilk değer kullanmaktır:

---
    int sayı = 3;
---

)

$(LI

Bu programda açıkça ilk değerler verilmiyor çünkü sayıların 0 olan ilk değerleri her iki döngüye de mutlaka girileceğini garanti ediyorlar:

---
import std.stdio;

void main() {
    int gizli_sayı;

    while ((gizli_sayı < 1) || (gizli_sayı > 10)) {
        write("1-10 aralığındaki gizli sayıyı bildirin: ");
        readf(" %s", &gizli_sayı);
    }

    int tahmin;

    while (tahmin != gizli_sayı) {
        write("Tahmin? ");
        readf(" %s", &tahmin);
    }

    writeln("Doğru!");
}
---

)

)

Macros:
        SUBTITLE=while Döngüsü Problem Çözümleri

        DESCRIPTION=D.ershane D programlama dili dersi çözümleri: while Döngüsü

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial while döngüsü problem çözüm
