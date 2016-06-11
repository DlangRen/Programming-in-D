Ddoc

$(COZUM_BOLUMU Kesirli Sayılar)

$(OL

$(LI
$(C float) yerine $(C double) kullanıldığında farklı biçimde şaşırtıcı olan bir sonuçla karşılaşılır:

---
// ...

    $(HILITE double) sonuç = 0;

// ...

    if ($(HILITE sonuç == 1)) {
        writeln("Beklendiği gibi 1");

    } else {
        writeln("FARKLI: ", sonuç);
    }
---

$(P
$(C sonuç == 1) karşılaştırması doğru çıkmadığı halde sonuç 1 olarak yazdırılmaktadır:
)

$(SHELL
FARKLI: 1
)

$(P
Bu şaşırtıcı durum, kesirli sayılar için normalde kullanılan çıktı düzeniyle ilgilidir. Virgülden sonraki kısım daha fazla haneyle yazdırıldığında değerin aslında tam 1 olmadığı görülür. (Çıktı düzenini $(LINK2 /ders/d/cikti_duzeni.html, ilerideki bir bölümde) göreceğiz:)
)

---
        write$(HILITE f)ln("FARKLI: %.20f", sonuç);
---

$(SHELL
FARKLI: 1.00000000000000066613
)

)

$(LI Önceki bölümdeki hesap makinesi programındaki üç satırdaki $(C int)'leri $(C double) yapmak yeter:

---
        double birinci;
        double ikinci;

        // ...

        double sonuç;
---

)

$(LI
Problemde 5 yerine daha fazla sayı girilmesi istenseydi programın nasıl daha da içinden çıkılmaz bir hale geleceğini görüyor musunuz:

---
import std.stdio;

void main() {
    double sayı_1;
    double sayı_2;
    double sayı_3;
    double sayı_4;
    double sayı_5;

    write("Sayı 1: ");
    readf(" %s", &sayı_1);
    write("Sayı 2: ");
    readf(" %s", &sayı_2);
    write("Sayı 3: ");
    readf(" %s", &sayı_3);
    write("Sayı 4: ");
    readf(" %s", &sayı_4);
    write("Sayı 5: ");
    readf(" %s", &sayı_5);

    writeln("İki katları:");
    writeln(sayı_1 * 2);
    writeln(sayı_2 * 2);
    writeln(sayı_3 * 2);
    writeln(sayı_4 * 2);
    writeln(sayı_5 * 2);

    writeln("Beşte birleri:");
    writeln(sayı_1 / 5);
    writeln(sayı_2 / 5);
    writeln(sayı_3 / 5);
    writeln(sayı_4 / 5);
    writeln(sayı_5 / 5);
}
---

)

)

Macros:
        SUBTITLE=Kesirli Sayılar Problem Çözümü

        DESCRIPTION=Kesirli Sayılar Problem Çözümü

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial kesirli sayılar problem çözüm
