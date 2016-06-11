Ddoc

$(COZUM_BOLUMU $(C switch) ve $(C case))

$(OL

$(LI

---
import std.stdio;
import std.string;

void main() {
    string işlem;
    double birinci;
    double ikinci;

    write("İşlem? ");
    işlem = strip(readln());

    write("İki sayıyı aralarında boşlukla yazın: ");
    readf(" %s %s", &birinci, &ikinci);

    double sonuç;

    final switch (işlem) {

    case "topla":
        sonuç = birinci + ikinci;
        break;

    case "çıkart":
        sonuç = birinci - ikinci;
        break;

    case "çarp":
        sonuç = birinci * ikinci;
        break;

    case "böl":
        sonuç = birinci / ikinci;
        break;
    }

    writeln(sonuç);
}
---

)

$(LI $(C case) değerlerinin virgüllerle belirlenebilmesi olanağını kullanarak:

---
    final switch (işlem) {

    case "topla"$(HILITE, "+"):
        sonuç = birinci + ikinci;
        break;

    case "çıkart"$(HILITE, "-"):
        sonuç = birinci - ikinci;
        break;

    case "çarp"$(HILITE, "*"):
        sonuç = birinci * ikinci;
        break;

    case "böl"$(HILITE, "/"):
        sonuç = birinci / ikinci;
        break;
    }
---

)

$(LI Bu durumda $(C default) bölümünü eklemek gerekeceği için $(C final switch) kullanamayız. Programın değişen yerleri:

---
// ...

    switch (işlem) {

    // ...

    default:
        throw new Exception("Geçersiz işlem");
    }

// ...
---

)

)

Macros:
        SUBTITLE=switch ve case Problem Çözümleri

        DESCRIPTION=D dilinin çoklu koşul olanağını gerçekleştiren switch ve case deyimi bölümünün problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial switch case koşul problem çözüm
