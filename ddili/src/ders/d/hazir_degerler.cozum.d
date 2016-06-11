Ddoc

$(COZUM_BOLUMU Hazır Değerler)

$(OL

$(LI
Buradaki sorun, sağ taraftaki hazır değerin bir $(C int)'e sığmayacak kadar büyük olması ve o yüzden de türünün derleyici tarafından $(C long) olarak belirlenmesidir. Bu yüzden soldaki $(C int) türündeki değişkene uymaz. Burada en az iki çözüm vardır.

$(P
Bir çözüm, açıkça $(C int) yazmak yerine, değişkenin türü için $(C auto) kullanmak ve tür seçimini derleyiciye bırakmaktır:
)

---
    auto miktar = 10_000_000_000;
---

$(P
Böylece $(C miktar) değişkeninin değeri de $(C long) olarak seçilir.
)

$(P
Diğer çözüm, değişkenin türünü de açıkça $(C long) yazmaktır:
)

---
    long miktar = 10_000_000_000;
---

)

$(LI
Burada satırın başına götüren $(C '\r') karakteri kullanılabilir. Böylece hep aynı satırın üstüne yazılır.

---
import std.stdio;

void main() {
    for (int sayı = 0; ; ++sayı) {
        write("\rSayı: ", sayı);
    }
}
---

$(P
Yukarıdaki programın çıktısı hem fazla hızlı hem de $(C stdout)'un ara belleğinin dolup boşalmasına bağlı olarak tutarsız olabilir. Aşağıdaki program her yazmadan sonra hem $(C flush()) ile çıkış ara belleğini boşaltır, hem de 10 milisaniye bekler:
)

---
import std.stdio;
import core.thread;

void main() {
    for (int sayı = 0; ; ++sayı) {
        write("\rSayı: ", sayı);
        stdout.flush();
        Thread.sleep(10.msecs);
    }
}
---

$(P
Normalde çıkış ara belleğinin açıkça boşaltılmasına gerek yoktur. Ara bellek yeni satıra geçmeden önce veya girişten bilgi okunmadan önce de otomatik olarak boşaltılır.
)

)

)


Macros:
        SUBTITLE=Hazır Değerler Problem Çözümü

        DESCRIPTION=Hazır değerler bölümünün problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial hazır değer problem çözüm
