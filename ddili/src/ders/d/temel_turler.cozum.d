Ddoc

$(COZUM_BOLUMU Temel Türler)

$(P
$(C int) yerine başka bir tür ismi kullanmak yeter. İki tanesi:
)

---
import std.stdio;

void main() {
    writeln("Tür                 : ", short.stringof);
    writeln("Bayt olarak uzunluğu: ", short.sizeof);
    writeln("En küçük değeri     : ", short.min);
    writeln("En büyük değeri     : ", short.max);
    writeln("İlk değeri          : ", short.init);

    writeln();

    writeln("Tür                 : ", ulong.stringof);
    writeln("Bayt olarak uzunluğu: ", ulong.sizeof);
    writeln("En küçük değeri     : ", ulong.min);
    writeln("En büyük değeri     : ", ulong.max);
    writeln("İlk değeri          : ", ulong.init);
}
---

Macros:
        SUBTITLE=Temel Türler Problem Çözümü

        DESCRIPTION=İlk D programlama dili dersi çözümleri: Temel Türler

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial temel tür problem çözüm
