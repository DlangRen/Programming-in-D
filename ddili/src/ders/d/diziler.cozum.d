Ddoc

$(COZUM_BOLUMU Diziler)

$(OL

$(LI

---
import std.stdio;
import std.algorithm;

void main() {
    write("Kaç sayı var? ");
    int adet;
    readf(" %s", &adet);

    double[] sayılar;
    sayılar.length = adet;

    int sayaç;
    while (sayaç < adet) {
        write("Sayı ", sayaç, ": ");
        readf(" %s", &sayılar[sayaç]);
        ++sayaç;
    }

    writeln("Sıralı olarak:");
    sort(sayılar);

    sayaç = 0;
    while (sayaç < adet) {
        write(sayılar[sayaç], " ");
        ++sayaç;
    }
    writeln();

    writeln("Ters sırada:");
    reverse(sayılar);

    sayaç = 0;
    while (sayaç < adet) {
        write(sayılar[sayaç], " ");
        ++sayaç;
    }
    writeln();
}
---

)

$(LI Açıklamalar kodun içinde:

---
import std.stdio;
import std.algorithm;

void main() {
    // Kaç tane sayı geleceğini baştan bilmediğimiz için
    // dinamik diziler kullanıyoruz
    int[] tekler;
    int[] çiftler;

    writeln("Lütfen tamsayılar girin (sonlandırmak için -1)");

    while (true) {

        // Sayıyı okuyoruz
        int sayı;
        readf(" %s", &sayı);

        // Sayı özellikle -1 olduğunda döngüden çıkıyoruz
        if (sayı == -1) {
            break;
        }

        // Tek veya çift olması durumuna göre farklı dizinin
        // sonuna yerleştiriyoruz; ikiye bölümünden kalan 0
        // ise çifttir, değilse tektir
        if ((sayı % 2) == 0) {
            çiftler ~= sayı;

        } else {
            tekler ~= sayı;
        }
    }

    // Önce tekleri ve çiftleri ayrı ayrı sıralıyoruz
    sort(tekler);
    sort(çiftler);

    // Ondan sonra birleştiriyoruz
    int[] sonuç;
    sonuç = tekler ~ çiftler;

    writeln("Önce tekler, sonra çiftler; sıralı olarak:");

    // Daha önce gördüğümüz gibi bir döngü kurarak dizinin
    // bütün elemanlarını çıkışa yazdırıyoruz
    int i;
    while (i < sonuç.length) {
        write(sonuç[i], " ");
        ++i;
    }

    writeln();
}
---

)

$(LI
Bu programda üç hata var. İki hata $(C while) döngüleriyle ilgili: her ikisinde de $(C <) işleci yerine $(C <=) kullanılmış. O yüzden program yasal olmayan bir indeks kullanarak dizinin dışına taşıyor.

$(P
Üçüncü hatayı kendiniz uğraşarak gidermeniz önemli olduğundan çözümü hemen vermek istemiyorum. Yukarıdaki iki hatayı giderdikten sonra programı tekrar derleyin ve neden sonucu yazdırmadığını bir sonraki paragrafı okumadan kendiniz çözmeye çalışın.
)

$(P
$(C i) sayacı hâlâ bir önceki döngüden çıkıldığındaki değerinde olduğundan, ikinci $(C while) döngüsünün koşulu hiçbir zaman sağlanmaz ve ikinci döngü bir kere bile tekrarlanmaz. Çözüm olarak ikinci döngüden önce bir $(C i = 0;) ifadesi yazmanız gerekir.
)

)

)

Macros:
        SUBTITLE=Diziler Problem Çözümü

        DESCRIPTION=Diziler Problem Çözümü

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial diziler problem çözüm
