Ddoc

$(COZUM_BOLUMU Üçlü İşleç $(C ?:))

$(P
Soruda istendiği için $(C ?:) işlecini kullanıyoruz; siz burada $(C if) deyiminin daha kullanışlı olduğunu düşünebilirsiniz. Dikkat ederseniz, bu çözümde iki tane $(C ?:) işleci kullanılmaktadır:
)

---
import std.stdio;

void main() {
    write("Lütfen net miktarı girin: ");

    int net;
    readf(" %s", &net);

    writeln(net < 0 ? -net : net, " lira ",
            net < 0 ? "zarardasınız" : "kazançlısınız");
}
---

$(P
Program sıfır değeri için bile "kazançlısınız" yazmaktadır. Programı değiştirerek daha uygun bir mesaj yazmasını sağlayın.
)


Macros:
        SUBTITLE=Üçlü İşleç ?: Çözümü

        DESCRIPTION=D dilinin üçlü ?: işlecinin problem çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial ?: üçlü işleç problem çözüm
