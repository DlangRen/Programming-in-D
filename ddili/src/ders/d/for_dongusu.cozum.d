Ddoc

$(COZUM_BOLUMU $(C for) Döngüsü)

$(OL

$(LI

---
import std.stdio;

void main() {
    for (int satır = 0; satır != 9; ++satır) {
        for (int sütun = 0; sütun != 9; ++sütun) {
            write(satır, ',', sütun, ' ');
        }

        writeln();
    }
}
---

)

$(LI Üçgen:

---
import std.stdio;

void main() {
    for (int satır = 0; satır != 5; ++satır) {
        int uzunluk = satır + 1;

        for (int i = 0; i != uzunluk; ++i) {
            write('*');
        }

        writeln();
    }
}
---

$(P
Paralelkenar:
)

---
import std.stdio;

void main() {
    for (int satır = 0; satır != 5; ++satır) {
        for (int i = 0; i != satır; ++i) {
            write(' ');
        }

        writeln("********");
    }
}
---

$(P
Baklava dilimi çizdirebilir misiniz?
)

$(SHELL
   *
  ***
 *****
*******
 *****
  ***
   *
)

)

)


Macros:
        SUBTITLE=for Döngüsü Problem Çözümü

        DESCRIPTION=for döngüsü bölümü problem çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial for döngü problem çözüm
