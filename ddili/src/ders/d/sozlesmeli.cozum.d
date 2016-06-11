Ddoc

$(COZUM_BOLUMU Sözleşmeli Programlama)

$(P
Birim testlerinin yazımına $(C main)'deki kodlar kopyalanarak başlanabilir. Aşağıdaki programa yalnızca ikinci takımın kazandığı durumun testi eklenmiş:
)

---
int puanEkle(in int goller1,
             in int goller2,
             ref int puan1,
             ref int puan2)
in {
    assert(goller1 >= 0);
    assert(goller2 >= 0);
    assert(puan1 >= 0);
    assert(puan2 >= 0);

} out (sonuç) {
    assert((sonuç >= 0) && (sonuç <= 2));

} body {
    int kazanan;

    if (goller1 > goller2) {
        puan1 += 3;
        kazanan = 1;

    } else if (goller1 < goller2) {
        puan2 += 3;
        kazanan = 2;

    } else {
        ++puan1;
        ++puan2;
        kazanan = 0;
    }

    return kazanan;
}

unittest {
    int birincininPuanı = 10;
    int ikincininPuanı = 7;
    int kazananTaraf;

    // Birinci takım kazanır
    kazananTaraf =
        puanEkle(3, 1, birincininPuanı, ikincininPuanı);
    assert(birincininPuanı == 13);
    assert(ikincininPuanı == 7);
    assert(kazananTaraf == 1);

    // Berabere
    kazananTaraf =
        puanEkle(2, 2, birincininPuanı, ikincininPuanı);
    assert(birincininPuanı == 14);
    assert(ikincininPuanı == 8);
    assert(kazananTaraf == 0);

    // İkinci takım kazanır
    kazananTaraf =
        puanEkle(0, 1, birincininPuanı, ikincininPuanı);
    assert(birincininPuanı == 14);
    assert(ikincininPuanı == 11);
    assert(kazananTaraf == 2);
}

void main() {
    // ...
}
---


Macros:
        SUBTITLE=Sözleşmeli Programlama

        DESCRIPTION=D dilinin kod güvenilirliğini arttıran olanağı 'sözleşmeli programlama' [contract programming] problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial sözleşmeli programlama contract programming design by contract problem çözüm
