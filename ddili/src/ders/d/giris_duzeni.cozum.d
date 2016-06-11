Ddoc

$(COZUM_BOLUMU Giriş Düzeni)

$(P
Tarihin yazımındaki her bir tamsayının yerine $(C %s) yerleştirmek işimize yarayan düzen dizgisini oluşturmaya yeter:
)

---
import std.stdio;

void main() {
    int yıl;
    int ay;
    int gün;

    readf("%s.%s.%s", &yıl, &ay, &gün);

    writeln("Ay: ", ay);
}
---


Macros:
        SUBTITLE=Giriş Düzeni Problem Çözümü

        DESCRIPTION=Giriş Düzeni bölümü problem çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial giriş düzeni format çözüm
