Ddoc

$(DERS_BOLUMU $(IX isim alanı) İsim Alanı)

$(P
D'de her isim, tanımlandığı noktadan başlayarak hem içinde tanımlandığı kapsamda, hem de o kapsamın içindeki kapsamlarda geçerlidir. Her kapsam bir $(I isim alanı) tanımlar.
)

$(P
İçinde tanımlandığı kapsamdan çıkıldığında, isim artık geçersiz hale gelir ve derleyici tarafından tanınmaz:
)

---
void main() {
    int dışSayı;

    if (birKoşul) {       // ← yeni bir kapsam başlatır
        int içSayı = 1;
        dışSayı = 2;      // ← dışSayı içeride de geçerlidir

    }            // ← içSayı'nın geçerliliği burada son bulur

    içSayı = 3;  $(DERLEME_HATASI)
                 // içSayı'nın geçerli olduğu kapsamdan
                 // çıkılmıştır
}
---

$(P
$(C if) koşulunun kapsamı içinde tanımlanmış olan $(C içSayı) o kapsamın dışında geçersizdir. Öte yandan, $(C dışSayı) hem dışarıdaki hem de içerideki kapsamda geçerlidir.
)

$(P
Bir kapsamda tanımlanmış bir ismin içerdeki bir kapsamda tekrar tanımlanması yasal değildir:
)

---
    int $(HILITE uzunluk) = tekSayılar.length;

    if (birKoşul) {
        int $(HILITE uzunluk) = asalSayılar.length;  $(DERLEME_HATASI)
    }
---

$(H5 İsimleri kullanıldıkları ilk noktada tanımlamak)

$(P
Şimdiye kadarki örneklerde de gördüğünüz gibi, isimlerin kullanıldıkları ilk noktadan daha $(I önce) tanımlanmış olmaları gerekir:
)

---
    writeln(sayı);  $(DERLEME_HATASI)
                    //   sayı henüz bilinmiyor
    int sayı = 42;
---

$(P
O kodun çalışabilmesi için $(C sayı)'nın $(C writeln) işleminden daha önce tanımlanmış olması gerekir. Kaç satır önce tanımlanacağı programcıya bağlı olsa da, her ismin $(I kullanıldığı ilk noktaya en yakın yerde) tanımlanması programcılık açısından daha iyi kabul edilir.
)

$(P
Bunu kullanıcıdan aldığı sayıların ortalamalarını yazdıran bir programın $(C main) işlevinde görelim. Özellikle C dilinden gelen programcılar, kullanılan bütün isimleri kapsamların en başında tanımlamaya alışmışlardır:
)

---
    int adet;                                   // ← BURADA
    int[] sayılar;                              // ← BURADA
    double ortalamaDeğer;                       // ← BURADA

    write("Kaç sayı gireceksiniz? ");

    readf(" %s", &adet);

    if (adet >= 1) {
        sayılar.length = adet;

        // ... burada asıl işlemler yapılıyor olsun...

    } else {
        writeln("HATA: En az bir sayı girmelisiniz!");
    }
---

$(P
Bunun karşıtı olarak, isimleri olabildiğince geç tanımlamak önerilir. Aynı programı bu tavsiyeye uyarak şöyle yazabiliriz:
)

---
    write("Kaç sayı gireceksiniz? ");

    int adet;                                   // ← BURADA
    readf(" %s", &adet);

    if (adet >= 1) {
        int[] sayılar;                          // ← BURADA
        sayılar.length = adet;

        double ortalamaDeğer;                   // ← BURADA
        // ... burada asıl işlemler yapılıyor olsun...

    } else {
        writeln("HATA: En az bir sayı girmelisiniz!");
    }
---

$(P
Bütün değişkenleri bir arada en başta tanımlamak yapısal olarak daha iyi olsa da, değişkenleri geç tanımlamanın da bir kaç önemli yararı vardır:
)

$(UL
$(LI $(B Hız): Her değişken tanımının program hızı açısından bir bedeli vardır. D'de bütün değişkenler ilklendikleri için, belki de hiç kullanılmayacak olan değişkenleri en baştan ilklemek, o işlem için geçen zamanın boşa gitmesine neden olabilir.
)

$(LI $(B Hata riski): Değişkenlerin tanımları ile kullanımları arasına giren her satır, program hataları açısından ufak da olsa bir risk taşır: bir örnek olarak, $(C uzunluk) gibi genel bir ismi olan bir değişken aradaki satırlarda yanlışlıkla başka bir uzunluk kavramı için kullanılmış, ve asıl kullanılacağı yere gelindiğinde değeri çoktan değişmiş olabilir.
)

$(LI $(B Okuma kolaylığı): Kapsamdaki satırlar çoğaldıkça, alttaki satırlarda kullanılan bir değişkenin tanımının programın yazıldığı ekranın dışında kalma olasılığı artar; değişkenlerin tanımlarını görmek veya hatırlamak için sık sık metnin üst tarafına gitmek ve tekrar geri gelmek gerekebilir.
)

$(LI $(B Kod değişikliği): Program kodları sürekli olarak gelişim halindedirler: programa ekler yapılır, programın bazı olanakları silinir, farkedilen hataları giderilir, vs. Bu işlemler sırasında çoğu zaman bir grup satırın hep birden başka bir işlev olarak tanımlanması istenebilir.

$(P Böyle durumlarda, o kod satırlarında kullanılan bütün değişkenlerin kullanıldıkları ilk yerde tanımlanmış olmaları, hepsinin birden başka bir yere taşınmalarına olanak sağlar.
)

$(P
Örneğin yukarıdaki bu tavsiyeye uyan programın $(C if) kapsamındaki bütün satırlar hep birden programın başka bir noktasına taşınabilirler.
)

$(P
Oysa değişkenlerini C'deki gibi tanımlayan bir programda, taşınacak olan kod satırlarında kullanılan değişkenlerin de teker teker seçilerek ayrı ayrı taşınmaları gerekir.
)

)

)

Macros:
        SUBTITLE=İsim alanı

        DESCRIPTION=D dilinde kullanılan isimlerin geçerlilik alanları (kapsamları)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial isim alanı kapsam

SOZLER=
$(degisken)
$(emekli)
$(ilklemek)
$(isim_alani)
$(kapsam)
