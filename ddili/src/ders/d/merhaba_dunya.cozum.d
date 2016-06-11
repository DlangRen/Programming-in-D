Ddoc

$(COZUM_BOLUMU Merhaba Dünya)

$(OL

$(LI

---
import std.stdio;

void main() {
    writeln("Başka bir şey... :p");
}
---

)

$(LI

---
import std.stdio;

void main() {
    writeln("Bir satır...");
    writeln("Başka bir satır...");
}
---

)

$(LI
Bu program $(C writeln) satırının sonunda noktalı virgül olmadığı için derlenemez:

---
import std.stdio;

void main() {
    writeln("Merhaba dünya!")    $(DERLEME_HATASI)
}
---

)

)

Macros:
        SUBTITLE=Merhaba Dünya Problem Çözümleri

        DESCRIPTION=İlk D programlama dili dersi çözümleri: Merhaba Dünya!

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial merhaba dünya problem çözüm
