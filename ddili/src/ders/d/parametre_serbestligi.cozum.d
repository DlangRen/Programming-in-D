Ddoc

$(COZUM_BOLUMU Parametre Serbestliği)

$(P
$(C hesapla) işlevinin belirsiz sayıda $(C Hesap) nesnesi alabilmesi için parametre listesinin bir $(C Hesap) dilimini ve $(C ...) karakterlerini içermesi gerekir:
)

---
double[] hesapla(in Hesap[] hesaplar...) {
    double[] sonuçlar;

    foreach (hesap; hesaplar) {
        final switch (hesap.işlem) {

        case İşlem.toplama:
            sonuçlar ~= hesap.birinci + hesap.ikinci;
            break;

        case İşlem.çıkarma:
            sonuçlar ~= hesap.birinci - hesap.ikinci;
            break;

        case İşlem.çarpma:
            sonuçlar ~= hesap.birinci * hesap.ikinci;
            break;

        case İşlem.bölme:
            sonuçlar ~= hesap.birinci / hesap.ikinci;
            break;
        }
    }

    return sonuçlar;
}
---

$(P
İşleve gönderilen bütün parametre değerleri $(C hesaplar) dizisinde bulunur. Bütün hesap nesnelerini bir döngüde teker teker kullanarak sonuçları da bir $(C double) dizisine yerleştiriyoruz ve işlevin sonucu olarak döndürüyoruz.
)

$(P
Bütün program:
)

---
import std.stdio;

enum İşlem { toplama, çıkarma, çarpma, bölme }

struct Hesap {
    İşlem işlem;
    double birinci;
    double ikinci;
}

double[] hesapla(Hesap[] hesaplar...) {
    double[] sonuçlar;

    foreach (hesap; hesaplar) {
        final switch (hesap.işlem) {

        case İşlem.toplama:
            sonuçlar ~= hesap.birinci + hesap.ikinci;
            break;

        case İşlem.çıkarma:
            sonuçlar ~= hesap.birinci - hesap.ikinci;
            break;

        case İşlem.çarpma:
            sonuçlar ~= hesap.birinci * hesap.ikinci;
            break;

        case İşlem.bölme:
            sonuçlar ~= hesap.birinci / hesap.ikinci;
            break;
        }
    }

    return sonuçlar;
}

void main() {
    writeln(hesapla(Hesap(İşlem.toplama, 1.1, 2.2),
                    Hesap(İşlem.çıkarma, 3.3, 4.4),
                    Hesap(İşlem.çarpma, 5.5, 6.6),
                    Hesap(İşlem.bölme, 7.7, 8.8)));
}
---

$(P
Çıktısı:
)

$(SHELL
[3.3, -1.1, 36.3, 0.875]
)


Macros:
        SUBTITLE=Parametre Serbestliği

        DESCRIPTION=D'nin işlevlerin kullanışlılığını arttıran olanaklarından olan parametrelere varsayılan değerler verme ve işlevleri belirsiz sayıda parametre [variadic] ile çağrılabilme olanakları ile ilgili dersin problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial belirsiz sayıda parametre variadic varsayılan parametre değeri problem çözüm
