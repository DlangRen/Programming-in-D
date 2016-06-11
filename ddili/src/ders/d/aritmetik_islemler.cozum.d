Ddoc

$(COZUM_BOLUMU Tamsayılar ve Aritmetik İşlemler)

$(OL

$(LI
$(C /) işlecini bölüm için, $(C %) işlecini de kalan için kullanabiliriz:

---
import std.stdio;

void main() {
    int birinci_sayı;
    write("Birinci sayı: ");
    readf(" %s", &birinci_sayı);

    int ikinci_sayı;
    write("İkinci sayı : ");
    readf(" %s", &ikinci_sayı);

    int bölüm = birinci_sayı / ikinci_sayı;
    int kalan = birinci_sayı % ikinci_sayı;

    writeln(birinci_sayı, " = ",
            ikinci_sayı, " * ", bölüm, " + ", kalan);
}
---

)

$(LI
Kalanın 0 olup olmadığını $(C if) koşulu ile denetleyebiliriz:

---
import std.stdio;

void main() {
    int birinci_sayı;
    write("Birinci sayı: ");
    readf(" %s", &birinci_sayı);

    int ikinci_sayı;
    write("İkinci sayı : ");
    readf(" %s", &ikinci_sayı);

    int bölüm = birinci_sayı / ikinci_sayı;
    int kalan = birinci_sayı % ikinci_sayı;

    // Burada artık writeln kullanamayacağımıza dikkat
    // edin. Satırı daha sonra sonlandırmak zorundayız.
    write(birinci_sayı, " = ", ikinci_sayı, " * ", bölüm);

    // Bu kısmını ancak kalan 0 olmadığı zaman yazdırıyoruz
    if (kalan != 0) {
        write(" + ", kalan);
    }

    // Artık satırı sonlandırıyoruz
    writeln();
}
---

)

$(LI

---
import std.stdio;

void main() {
    while (true) {
        write("0: Çık, 1: Toplama, 2: Çıkarma, ",
              "3: Çarpma, 4: Bölme - İşlem? ");

        int işlem;
        readf(" %s", &işlem);

        // Önce işlemi denetleyelim
        if ((işlem < 0) || (işlem > 4)) {
            writeln("Bu işlemi daha öğrenmedim");
            continue;
        }

        if (işlem == 0){
            writeln("Güle güle!");
            break;
        }

        // Eğer bu noktaya gelmişsek, bildiğimiz 4 işlemden
        // birisi ile ilgilendiğimizden eminiz. Artık
        // kullanıcıdan 2 sayıyı isteyebiliriz:

        int birinci;
        int ikinci;

        write("Birinci sayı? ");
        readf(" %s", &birinci);

        write(" İkinci sayı? ");
        readf(" %s", &ikinci);

        // İşlemin sonucunu bu değişkene yerleştireceğiz
        int sonuç;

        if (işlem == 1) {
            sonuç = birinci + ikinci;

        } else if (işlem == 2) {
            sonuç = birinci - ikinci;

        } else if (işlem == 3) {
            sonuç = birinci * ikinci;

        } else if (işlem == 4) {
            sonuç = birinci / ikinci;

        }  else {
            writeln(
                "Programda bir hata var! ",
                "Bu noktaya kesinlikle gelmemeliydik...");
            break;
        }

        writeln("       Sonuç: ", sonuç);
    }
}
---

)

$(LI

---
import std.stdio;

void main() {
    int sayı = 1;

    while (sayı <= 10) {
        if (sayı != 7) {
            writeln(sayı);
        }

        ++sayı;
    }
}
---

)

)

Macros:
        SUBTITLE=Aritmetik İşlemler Problem Çözümü

        DESCRIPTION=Aritmetik İşlemler Problem Çözümü

        KEYWORDS=d programlama dili bölümler öğrenmek tutorial aritmetik işlemler problem çözüm
