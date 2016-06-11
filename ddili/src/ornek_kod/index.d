Ddoc

$(H3 Örnek Kodlar)

$(P
Buradaki küçük D programları, dilin özellikleri ve söz dizimi hakkında hızlıca bir fikir verme amacı taşıyorlar.
)

$(H5 Merhaba dünya)

$(P
Klasik "merhaba dünya" programı.
)

---
import std.stdio;

void main()
{
    writeln("Merhaba dünya!");
}
---

$(UL

$(LI
D'de başlık dosyası yerine $(I modül) kavramı var. $(CODE import) anahtar sözcüğü ile $(CODE std.stdio) modülünün kullanıldığı belirtiliyor.
)

$(LI
$(CODE writeln) standart çıkışa bir satır yazdırmak için kullanılıyor.
)

$(LI
D'de hem $(CODE void main), hem de $(CODE int main) yasal. C ve C++'daki bu konudaki tarihsel karışıklık D'de yok...
)

)

$(H5 Türkçe harfler)

$(P
D'nin en güzel taraflarından birisi, kaynak kodlarda Unicode karakterlerin de kullanılabilmesi.
)

---
import std.stdio;

void main()
{
    Türkçe_harf_dene();
}

void Türkçe_harf_dene()
{
    writeln("ğüşiöçıĞÜŞİÖÇI");
}
---

$(UL

$(LI
Dosyayı UTF-8 olarak kaydetmek yeterli.
)

$(LI
C'nin ve C++'nın tersine, isimlerin önceden bildirilmesi gerekmiyor. Programda $(CODE Türkçe_harf_dene) işlevini çağırabilmek için onu önceden bildirmek gerekmedi.
)

)

$(H5 Aralıklar ve UFCS)

$(P
D'de eleman erişimi aralık soyutlaması ile sağlanır. Aşağıdaki program sonsuz bir FibonacciSerisi aralığı tanımlamakta ve onu Phobos algoritması $(C take()) ile kullanarak yalnızca ilk 10 değeri yazdırmaktadır:
)

---
import std.stdio;
import std.range;

struct FibonacciSerisi
{
    int baştaki = 0;
    int sonraki = 1;

    enum empty = false;

    int front() const @property
    {
        return baştaki;
    }

    void popFront()
    {
        int ikiSonraki = baştaki + sonraki;
        baştaki = sonraki;
        sonraki = ikiSonraki;
    }
}

void main()
{
    FibonacciSerisi().take(10).writeln();

    /*
     * Yukarıdaki satırda UFCS (uniform function call syntax)
     * olanağının yararını görüyoruz. Aynı satır daha
     * alışılmış işlev çağrısı söz dizimi ile de
     * işletilebilirdi:
     *
     *  writeln(take(FibonacciSerisi(), 10));
     */
}
---

$(P
Çıktısı:
)

$(SHELL
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
)

$(H5 İç işlevler ve isimsiz işlevler)

$(P
İşlevler başka işlevlerin içerisinde tanımlanabilirler. Hatta, isimsiz olarak ifadeler içerisinde bile tanımlanabilirler.  $(ASIL lambda functions, function literals, veya delegates)
)

---
import std.stdio;

void main()
{
    /*
     * Örnek olsun diye bir iç işlev kullanılıyor; onun yerine
     * serbest işlev da olurdu.
     *
     * Bu işlevin üç parametresi:
     *
     * baş:   hesaplanacak ilk değer
     * son:   hesaplanacak son değerden bir sonrası
     * hesap: parametre olarak tek bir int alan ve int
     *        döndüren bir temsilci
     */
    void içİşlev(int baş, int son, int delegate(int) hesap)
    {
        foreach (i; baş..son) {
            /* Parametre olarak verilen fonksiyonu kullanarak
             * bir hesap yapıyoruz*/
            immutable sonuç = hesap(i);
            writefln("%s: %s", i, sonuç);
        }
    }

    writeln("kareler:");

    /*
     * Yukarıdaki iç işlevin burada isimsiz bir işlev ile
     * çağrılmakta olduğunu görüyoruz.
     *
     * Burada üçüncü parametre bir 'işlev hazır değeridir'
     * (lambda function). Parametre olarak gönderilen işlevi
     * hemen ifadenin içinde tanımlıyoruz.
     *
     * Parametre almayan bir fonksiyon sabiti olsa daha da
     * kısa olarak yazılabilirdi:
     *
     *  içİşlev(3, 10, { return 5; } );
     */
    içİşlev(3, 10, (int sayı){ return sayı * sayı; } );

    writeln("iki katlar:");

    /* Bu çağrı ise D'nin => söz diziminden yararlanıyor. */
    içİşlev(1, 7, sayı => sayı * 2);
}
---

$(P
Çıktısı:
)

$(SHELL
kareler:
3: 9
4: 16
5: 25
6: 36
7: 49
8: 64
9: 81
iki katlar:
1: 2
2: 4
3: 6
4: 8
5: 10
6: 12
)

Macros:
        SUBTITLE=Örnek Kodlar

        DESCRIPTION=D programlama diliyle yazılmış küçük örnek programlar

        KEYWORDS=örnek program kod merhaba dünya

       BREADCRUMBS=$(BREADCRUMBS_INDEX)
