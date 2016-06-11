Ddoc

$(COZUM_BOLUMU Başka Dizi Olanakları)

$(P
Aşağıdaki dilimdeki gibi $(I başından kısaltarak tüketmek), D'de çok yaygındır. Bu yöntem, daha ileride göreceğimiz Phobos aralıklarının da temelini oluşturur.
)

---
import std.stdio;

void main() {
    double[] dizi = [ 1, 20, 2, 30, 7, 11 ];

    double[] dilim = dizi;     // işimize dizinin bütün
                               // elemanlarına erişim
                               // sağlayan bir dilimle
                               // başlıyoruz

    while (dilim.length) {     // o dilimde eleman bulunduğu
                               // sürece ...

        if (dilim[0] > 10) {   // işlemlerde yalnızca ilk
            dilim[0] /= 2;     // elemanı kullanıyoruz
        }

        dilim = dilim[1 .. $]; // dilimi başından kısaltıyoruz
    }

    writeln(dizi);             // asıl dizi değişmiş oluyor
}
---


Macros:
        SUBTITLE=Başka Dizi Olanakları Problem Çözümü

        DESCRIPTION=Dizi dilimleri problem çözümü

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial dizi dilim problem çözüm
