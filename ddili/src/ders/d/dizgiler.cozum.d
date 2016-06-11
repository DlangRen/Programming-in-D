Ddoc

$(COZUM_BOLUMU Dizgiler)

$(OL

$(LI
Kütüphane başvuru belgelerinin amaçları öğretmek değildir. Kütüphane belgelerini caydırıcı derecede kısa ve anlaşılmaz bulabilirsiniz. Siz de zamanla alışacaksınız ve uzun yazılardan çok öz belgeler yeğleyeceksiniz.
)

$(LI

---
import std.stdio;
import std.string;

void main() {
    write("Adınız? ");
    string ad = capitalize(strip(readln()));

    write("Soyadınız? ");
    string soyad = capitalize(strip(readln()));

    string adSoyad = ad ~ " " ~ soyad;
    writeln(adSoyad);
}
---

)

$(LI

---
import std.stdio;
import std.string;

void main() {
    write("Satırı giriniz: ");
    string satır = strip(readln());

    ptrdiff_t ilk_a = indexOf(satır, 'a');

    if (ilk_a == -1) {
        writeln("Bu satırda a harfi yok.");

    } else {
        ptrdiff_t son_a = lastIndexOf(satır, 'a');
        writeln(satır[ilk_a .. son_a + 1]);
    }
}
---

)

)

Macros:
        SUBTITLE=Dizgiler Problem Çözümü

        DESCRIPTION=D programlama dili dersi çözümleri: Dizgiler

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial dizgiler dizgi problem çözüm
