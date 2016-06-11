Ddoc

$(COZUM_BOLUMU $(C foreach) Döngüsü)

$(P
$(C isimle) tablosunun tersi olarak çalışabilmesi için indeks türü yerine eleman türü, eleman türü yerine de indeks türü kullanmak gerekir. Yani $(C int[string])... Asıl dizginin elemanlarını $(C foreach) ile gezerek indeks olarak eleman değerini, eleman olarak da indeks değerini kullanırsak, ters yönde çalışan bir eşleme tablosu elde ederiz:
)

---
import std.stdio;

void main() {
    string[int] isimle = [ 1:"bir", 7:"yedi", 20:"yirmi" ];

    int[string] rakamla;

    foreach (indeks, eleman; isimle) {
        rakamla[eleman] = indeks;
    }

    writeln(rakamla["yirmi"]);
}
---


Macros:
        SUBTITLE=foreach Döngüsü Problem Çözümleri

        DESCRIPTION=D dilinin foreach döngüsü bölümünün problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial foreach döngüsü döngü problem çözüm
