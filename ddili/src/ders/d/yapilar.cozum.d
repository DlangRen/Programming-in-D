Ddoc

$(COZUM_BOLUMU Yapılar)

$(OL

$(LI
Aksine bir neden olmadığı için, en basit olarak iki tane karakter ile:

---
struct OyunKağıdı {
    dchar renk;
    dchar değer;
}
---

)

$(LI
Yine çok basit olarak, yapı nesnesinin üyelerini yan yana çıkışa göndermek yeterli olur:

---
void oyunKağıdıYazdır(in OyunKağıdı kağıt) {
    write(kağıt.renk, kağıt.değer);
}
---

)

$(LI
Eğer $(C yeniSeri) isminde başka bir işlevin yazılmış olduğunu kabul edersek, $(C yeniDeste) işlevini de onu her renk için dört kere çağırarak kolayca yazabiliriz:

---
OyunKağıdı[] yeniDeste()
out (sonuç) {
    assert(sonuç.length == 52);

} body {
    OyunKağıdı[] deste;

    deste ~= yeniSeri('♠');
    deste ~= yeniSeri('♡');
    deste ~= yeniSeri('♢');
    deste ~= yeniSeri('♣');

    return deste;
}
---

$(P
İşin diğer bölümü yararlandığımız $(C yeniSeri) tarafından halledilir. Bu işlev verilen renk bilgisini bir dizginin bütün elemanlarıyla sırayla birleştirerek bir seri oluşturuyor:
)

---
OyunKağıdı[] yeniSeri(in dchar renk)
in {
    assert((renk == '♠') ||
           (renk == '♡') ||
           (renk == '♢') ||
           (renk == '♣'));

} out (sonuç) {
    assert(sonuç.length == 13);

} body {
    OyunKağıdı[] seri;

    foreach (değer; "234567890JQKA") {
        seri ~= OyunKağıdı(renk, değer);
    }

    return seri;
}
---

$(P
Program hatalarını önlemek için işlevlerin giriş koşullarını ve çıkış garantilerini de yazdığıma dikkat edin.
)

)

$(LI
Rasgele seçilen iki elemanı değiş tokuş etmek, sonuçta destenin karışmasını da sağlar. Rastgele seçim sırasında, küçük de olsa aynı elemanı seçme olasılığı da vardır. Ama bu önemli bir sorun oluşturmaz, çünkü elemanı kendisiyle değiştirmenin etkisi yoktur.

---
void karıştır(OyunKağıdı[] deste, in int değişTokuşAdedi) {
    /* Not: Daha etkin bir yöntem, desteyi başından sonuna
     *      kadar ilerlemek ve her elemanı destenin sonuna
     *      doğru rasgele bir elemanla değiştirmektir.
     *
     * En doğrusu, zaten aynı algoritmayı uygulayan
     * std.algorithm.randomShuffle işlevini çağırmaktır. Bu
     * karıştır() işlevini bütünüyle kaldırıp main() içinde
     * açıklandığı gibi randomShuffle()'ı çağırmak daha doğru
     * olur. */
    foreach (i; 0 .. değişTokuşAdedi) {

        // Rasgele iki tanesini seç
        immutable birinci = uniform(0, deste.length);
        immutable ikinci = uniform(0, deste.length);

        // Değiş tokuş et
        swap(deste[birinci], deste[ikinci]);
    }
}
---

$(P
O işlevde $(C std.algorithm) modülündeki $(C swap) işlevinden yararlandım. $(C swap), kendisine verilen iki değeri değiş tokuş eder. Temelde şu işlev gibi çalışır:
)

---
void değişTokuş(ref OyunKağıdı soldaki,
                ref OyunKağıdı sağdaki) {
    immutable geçici = soldaki;
    soldaki = sağdaki;
    sağdaki = geçici;
}
---

)

)

$(P
Programın tamamı şöyle:
)

---
import std.stdio;
import std.random;
import std.algorithm;

struct OyunKağıdı {
    dchar renk;
    dchar değer;
}

void oyunKağıdıYazdır(in OyunKağıdı kağıt) {
    write(kağıt.renk, kağıt.değer);
}

OyunKağıdı[] yeniSeri(in dchar renk)
in {
    assert((renk == '♠') ||
           (renk == '♡') ||
           (renk == '♢') ||
           (renk == '♣'));

} out (sonuç) {
    assert(sonuç.length == 13);

} body {
    OyunKağıdı[] seri;

    foreach (değer; "234567890JQKA") {
        seri ~= OyunKağıdı(renk, değer);
    }

    return seri;
}

OyunKağıdı[] yeniDeste()
out (sonuç) {
    assert(sonuç.length == 52);

} body {
    OyunKağıdı[] deste;

    deste ~= yeniSeri('♠');
    deste ~= yeniSeri('♡');
    deste ~= yeniSeri('♢');
    deste ~= yeniSeri('♣');

    return deste;
}

void karıştır(OyunKağıdı[] deste, in int değişTokuşAdedi) {
    /* Not: Daha etkin bir yöntem, desteyi başından sonuna
     *      kadar ilerlemek ve her elemanı destenin sonuna
     *      doğru rasgele bir elemanla değiştirmektir.
     *
     * En doğrusu, zaten aynı algoritmayı uygulayan
     * std.algorithm.randomShuffle işlevini çağırmaktır. Bu
     * karıştır() işlevini bütünüyle kaldırıp main() içinde
     * açıklandığı gibi randomShuffle()'ı çağırmak daha doğru
     * olur. */
    foreach (i; 0 .. değişTokuşAdedi) {

        // Rasgele iki tanesini seç
        immutable birinci = uniform(0, deste.length);
        immutable ikinci = uniform(0, deste.length);

        // Değiş tokuş et
        swap(deste[birinci], deste[ikinci]);
    }
}

void main() {
    OyunKağıdı[] deste = yeniDeste();

    karıştır(deste, 100);
    /* Not: Yukarıdaki karıştır() çağrısı yerine aşağıdaki
     *      randomShuffle() daha doğru olur:
     *
     * randomShuffle(deste);
     */
    foreach (kağıt; deste) {
        oyunKağıdıYazdır(kağıt);
        write(' ');
    }

    writeln();
}
---

Macros:
        SUBTITLE=Yapılar

        DESCRIPTION=D dilinin kullanıcı türleri tanımlaya yarayan olanağı 'struct' problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial yapı yapılar struct kullanıcı türleri problem çözüm
