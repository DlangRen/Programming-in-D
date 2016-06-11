Ddoc

$(COZUM_BOLUMU $(C enum))

$(P
Açıklamalar kodun içerisinde:
)

---
import std.stdio;
import std.conv;

enum İşlem { çıkış, toplama, çıkarma, çarpma, bölme }

void main() {
    // Programın desteklediği işlemleri yazdırıyoruz
    write("İşlemler - ");
    for (İşlem işlem; işlem <= İşlem.max; ++işlem) {
        writef("%d:%s ", işlem, işlem);
    }
    writeln();

    // Kullanıcı isteyene kadar programda kalmak için sonsuz
    // döngü kullanıyoruz.
    while (true) {
        write("İşlem? ");

        // Girişten yine de enum'un asıl türü olan int olarak
        // okumak zorundayız
        int işlemKodu;
        readf(" %s", &işlemKodu);

        /* Bu noktadan sonra sihirli sabitler yerine enum
         * değerler kullanacağız.
         *
         * Girişten int olarak okuduğumuz için bu int değerin
         * türünü İşlem'e dönüştürüyoruz
         *
         * (Tür dönüşümlerini ayrıntılı olarak daha sonraki
         * bir bölümde göreceğiz.) */
        İşlem işlem = cast(İşlem)işlemKodu;

        if ((işlem < İşlem.min) || (işlem > İşlem.max)) {
            writeln("HATA: Geçersiz işlem");
            continue;
        }

        if (işlem == İşlem.çıkış) {
            writeln("Güle güle!");
            break;
        }

        double birinci;
        double ikinci;
        double sonuç;

        write("Birinci sayı? ");
        readf(" %s", &birinci);

        write(" İkinci sayı? ");
        readf(" %s", &ikinci);

        switch (işlem) {

        case İşlem.toplama:
            sonuç = birinci + ikinci;
            break;

        case İşlem.çıkarma:
            sonuç = birinci - ikinci;
            break;

        case İşlem.çarpma:
            sonuç = birinci * ikinci;
            break;

        case İşlem.bölme:
            sonuç = birinci / ikinci;
            break;

        default:
            throw new Exception(
                "HATA: Bu satıra hiç gelinmemeliydi.");
        }

        writeln("       Sonuç: ", sonuç);
    }
}
---


Macros:
        SUBTITLE=enum Çözümü

        DESCRIPTION=enum Problem Çözümü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial enum numaralandırma numara problem çözüm
