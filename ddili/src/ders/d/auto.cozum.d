Ddoc

$(COZUM_BOLUMU $(C auto) ve $(C typeof))

$(P
Türünü bulmak istediğimiz hazır değeri $(C typeof)'a vererek türünü üretebiliriz, ve o türün $(C .stringof) niteliği ile de türün ismini yazdırabiliriz:
)

---
import std.stdio;

void main() {
    writeln(typeof(1.2).stringof);
}
---

$(P
Çıktısı:
)

$(SHELL
double
)


Macros:
        SUBTITLE=auto ve typeof Problem Çözümü

        DESCRIPTION=auto ve typeof bölümü problem çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial auto typeof problem çözüm
