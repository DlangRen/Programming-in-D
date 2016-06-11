Ddoc

$(COZUM_BOLUMU Dosyalar)

---
import std.stdio;
import std.string;

void main() {
    write("Lütfen dosya ismini yazınız: ");
    string girişDosyasıİsmi = strip(readln());
    File giriş = File(girişDosyasıİsmi, "r");

    string çıkışDosyasıİsmi = girişDosyasıİsmi ~ ".bak";
    File çıkış = File(çıkışDosyasıİsmi, "w");

    while (!giriş.eof()) {
        string satır = strip(giriş.readln());

        if (satır.length != 0) {
            çıkış.writeln(satır);
        }
    }

    writeln(çıkışDosyasıİsmi, " dosyasını oluşturdum.");
}
---


Macros:
        SUBTITLE=Dosyalar Problem Çözümü

        DESCRIPTION=Dosyalar bölümü problem çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial dosya problem çözüm
