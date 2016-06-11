Ddoc

$(COZUM_BOLUMU if Koşulu)

$(OL

$(LI
Bu programda $(C writeln("Tabağı kaldırıyorum")) ifadesi sanki $(C else) kapsamındaymış gibi içerletilerek yazılmış. Oysa $(C else)'ten sonra küme parantezleri kullanılmadığı için, kurallar gereği bu $(C else) kapsamında tek bir ifade vardır: $(C writeln("Baklava yiyorum")).

$(P
Programdaki boşlukların önemi de olmadığı için (yazım hatalarına neden olmadıkları sürece) tabaklı ifade aslında $(C main) içinde serbest bir ifadedir ve hiçbir koşula bağlı olmadan her zaman için işletilir. İçerletildiği için okuyanı yanıltabiliyor. Eğer tabaklı ifade de $(C else) kapsamında olacaksa, o zaman küme parantezlerini unutmamak gerekir:
)

---
import std.stdio;

void main() {
    bool limonata_var = true;

    if (limonata_var) {
        writeln("Limonata içiyorum");
        writeln("Bardağı yıkıyorum");

    } else $(HILITE {)
        writeln("Baklava yiyorum");
        writeln("Tabağı kaldırıyorum");
    $(HILITE })
}
---

)

$(LI
Bu oyundaki koşulları tasarlamak için birden çok çözüm düşünebiliriz. Ben iki tane göstereceğim. Önce soruda verilen bilgiyi bire bir uygulayarak:

---
import std.stdio;

void main() {
    write("Zar kaç geldi? ");
    int zar;
    readf(" %s", &zar);

    if (zar == 1) {
        writeln("Siz kazandınız");

    } else if (zar == 2) {
        writeln("Siz kazandınız");

    } else if (zar == 3) {
        writeln("Siz kazandınız");

    } else if (zar == 4) {
        writeln("Ben kazandım");

    } else if (zar == 5) {
        writeln("Ben kazandım");

    } else if (zar == 6) {
        writeln("Ben kazandım");

    } else {
        writeln("HATA: Geçersiz değer: ", zar);
    }
}
---

$(P
Ne yazık ki o programda çok tekrar bulunuyor. Aynı sonucu başka biçimde de elde edebiliriz. Bir tanesi:
)

---
import std.stdio;

void main() {
    write("Zar kaç geldi? ");
    int zar;
    readf(" %s", &zar);

    if ((zar == 1) || (zar == 2) || (zar == 3)) {
        writeln("Siz kazandınız");

    } else if ((zar == 4) || (zar == 5) || (zar == 6)) {
        writeln("Ben kazandım");

    } else {
        writeln("HATA: Geçersiz değer: ", zar);
    }
}
---

)

$(LI
Artık yukarıda gösterilen çözümleri kullanamayız. Kimse 1000 değişik değeri öyle açıkça yazmaz: aşırı emek gerektirir, doğruluğundan emin olunamaz, okuyan bir şey anlamaz, vs. O yüzden burada "bu sayı iki sınırın arasında mı" karşılaştırmasını kullanırız:

---
    if ((sayı >= 1) && (sayı <= 500))
---

)

)

Macros:
        SUBTITLE=if Koşulu Problem Çözümleri

        DESCRIPTION=D.ershane D programlama dili dersi çözümleri: if Koşulu

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial if koşulu deyimi problem çözüm
