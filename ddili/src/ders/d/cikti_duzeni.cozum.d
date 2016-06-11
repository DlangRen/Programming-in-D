Ddoc

$(COZUM_BOLUMU Çıktı Düzeni)

$(OL

$(LI Bunun düzen belirteciyle nasıl yapıldığını zaten gördünüz. Hiçbir hesap yapmaya gerek kalmadan:

---
import std.stdio;

void main() {
    writeln("(Programdan çıkmak için 0 giriniz.)");

    while (true) {
        write("Lütfen bir sayı giriniz: ");
        long sayı;
        readf(" %s", &sayı);

        if (sayı == 0) {
            break;
        }

        writefln("%1$d <=> %1$#x", sayı);
    }
}
---

)

$(LI
$(C %) karakterinin kendisini yazdırmak için çift yazmak gerektiğini hatırlayarak:

---
import std.stdio;

void main() {
    write("Yüzde değeri? ");
    double yüzde;
    readf(" %s", &yüzde);

    writefln("%%%.2f", yüzde);
}
---

)

)

Macros:
        SUBTITLE=Çıktı Düzeni Problem Çözümü

        DESCRIPTION=Çıktı Düzeni bölümü problem çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial çıktı düzeni format çözüm
