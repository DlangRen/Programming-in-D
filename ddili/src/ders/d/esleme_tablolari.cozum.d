Ddoc

$(COZUM_BOLUMU Eşleme Tabloları)

$(OL

$(LI

$(UL

$(LI
Eşleme tablosunun $(C .keys) niteliği, bütün indeksleri içeren bir dizi döndürür. Bu dizinin elemanlarını bir $(C for) döngüsünde gezersek, ve her birisi için eşleme tablosunun $(C .remove) niteliğini kullanırsak bütün elemanlar eşleme tablosundan silinmiş olurlar ve sonuçta tablo boşalır:

---
import std.stdio;

void main() {
    string[int] isimleSayılar =
    [
        1   : "bir",
        10  : "on",
        100 : "yüz",
    ];

    writeln("Başlangıçtaki tablo büyüklüğü    : ",
            isimleSayılar.length);

    int[] indeksler = isimleSayılar.keys;

    /* foreach for'a benzer ama ondan daha kullanışlıdır.
     * foreach'i bir sonraki bölümde göreceğiz. */
    foreach (indeks; indeksler) {
        writeln(indeks, " indeksinin elemanını siliyorum");
        isimleSayılar.remove(indeks);
    }

    writeln("Sildikten sonraki tablo büyüklüğü: ",
            isimleSayılar.length);
}
---

$(P
O çözüm özellikle büyük tablolarda yavaş olacaktır. Aşağıdaki çözümlerin ikisi de tabloyu bir seferde boşaltırlar.
)

)

$(LI
Başka bir çözüm, eşleme tablosuna kendisiyle aynı türden boş bir tablo atamaktır:

---
    string[int] boşTablo;
    isimleSayılar = boşTablo;
---

)

$(LI
Her türün $(C .init) niteliği, o türün $(I ilk değeri) anlamındadır. Bir eşleme tablosunun ilk değeri de boş tablo olduğu için, bir önceki çözümün de eşdeğeri olan şunu kullanabiliriz:

---
    isimleSayılar = isimleSayılar.init;
---

)

)

)

$(LI
Burada öğrenci ismine karşılık birden fazla not tutmak istiyoruz. Yani bir $(I dizi) not... Eğer eşleme tablomuzu $(C string)'den $(C int[]) türüne eşleyecek şekilde tanımlarsak, isimle eriştiğimiz eleman, bir $(C int) dizisi olur. O dizinin sonuna not ekleyerek de amacımıza erişiriz:

---
import std.stdio;

void main() {
    /* Eşleme tablosunun indeks türü string; eleman türü ise
     * int[], yani bir int dizisi. Belirginleştirmek için
     * aralarında boşlukla tanımlıyorum: */
    int[] [string] notlar;

    /* Artık "emre" indeksine karşılık gelen elemanı bir int
     * dizisi gibi kullanabiliriz. */

    // Diziye notlar eklemek:
    notlar["emre"] ~= 90;
    notlar["emre"] ~= 85;

    // Diziyi yazdırmak
    writeln(notlar["emre"]);
}
---

$(P
Notları teker teker eklemek yerine hepsini bir dizi olarak da atayabiliriz:
)

---
import std.stdio;

void main() {
    int[][string] notlar;

    notlar["emre"] = [ 90, 85, 95 ];

    writeln(notlar["emre"]);
}
---

)

)

Macros:
        SUBTITLE=Eşleme Tabloları Çözümleri

        DESCRIPTION=D'nin dil olanaklarından olan eşleme tabloları (hash tables) dersinin problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial eşleme tablosu hash table çözüm
