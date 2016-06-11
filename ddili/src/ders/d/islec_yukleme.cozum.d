Ddoc

$(COZUM_BOLUMU İşleç Yükleme)

$(P
Aşağıdaki gerçekleştirme bütün birim testlerinden geçiyor. Tasarım kararlarını kod açıklamaları içine yazdım.
)

$(P
Bu yapının bazı işleçleri daha etkin olarak tasarlanabilirdi. Ek olarak, payı ve paydayı sadeleştirmek de gerekir. Pay ve payda değerleri örneğin 20 ve 60 olarak kalmak yerine en büyük ortak bölenlerine bölündükten sonra 1 ve 3 olarak saklanmalıdır. Yoksa, çoğu işlem payın ve paydanın gittikçe büyümelerine neden olmakta.
)

---
import std.exception;
import std.conv;

struct Kesir {
    long pay;
    long payda;

    /* Kurucu işlev kolaylık olsun diye paydanın
     * belirtilmesini gerektirmiyor ve 1 varsayıyor. */
    this(long pay, long payda = 1) {
        enforce(payda != 0, "Payda sıfır olamaz");

        this.pay = pay;
        this.payda = payda;

        /* Paydanın eksi değer almasını başından önlemek daha
         * sonraki işlemleri basitleştirecek. */
        if (this.payda < 0) {
            this.pay = -this.pay;
            this.payda = -this.payda;
        }
    }

    /* Tekli - işleci: Kesirin eksi değerli olanını
     * döndürür. */
    Kesir opUnary(string işleç)() const
            if (işleç == "-") {
        /* İsimsiz bir nesne üretiyor ve döndürüyor. */
        return Kesir(-pay, payda);
    }

    /* ++ işleci: Kesirin değerini bir arttırır. */
    ref Kesir opUnary(string işleç)()
            if (işleç == "++") {
        /* Burada 'this += Kesir(1)' de kullanılabilirdi. */
        pay += payda;
        return this;
    }

    /* -- işleci: Kesirin değerini bir azaltır. */
    ref Kesir opUnary(string işleç)()
            if (işleç == "--") {
        /* Burada 'this -= Kesir(1)' de kullanılabilirdi. */
        pay -= payda;
        return this;
    }

    /* += işleci: Kesirin değerini arttırır. */
    ref Kesir opOpAssign(string işleç)(in Kesir sağdaki)
            if (işleç == "+") {
        /* Toplama formülü: a/b + c/d = (a*d + c*b)/(b*d) */
        pay = (pay * sağdaki.payda) + (sağdaki.pay * payda);
        payda *= sağdaki.payda;
        return this;
    }

    /* -= işleci: Kesirin değerini azaltır. */
    ref Kesir opOpAssign(string işleç)(in Kesir sağdaki)
            if (işleç == "-") {
        /* Burada zaten tanımlanmış olan += ve tekli -
         * işleçlerinden yararlanılıyor. Bunun yerine bu işleç
         * de += işlecine benzer biçimde ve çıkarma formülü
         * açıkça gerçekleştirilerek tanımlanabilirdi:
         *
         * Çıkarma formülü: a/b - c/d = (a*d - c*b)/(b*d)
         */
        this += -sağdaki;
        return this;
    }

    /* *= işleci: Kesiri sağdaki ile çarpar. */
    ref Kesir opOpAssign(string işleç)(in Kesir sağdaki)
            if (işleç == "*") {
        /* Çarpma formülü: a/b * c/d = (a*c)/(b*d) */
        pay *= sağdaki.pay;
        payda *= sağdaki.payda;
        return this;
    }

    /* /= işleci: Kesiri sağdakine böler. */
    ref Kesir opOpAssign(string işleç)(in Kesir sağdaki)
            if (işleç == "/") {
        enforce(sağdaki.pay != 0, "Sıfırla bölme hatası");

        /* Bölme formülü: (a/b) / (c/d) = (a*d)/(b*c) */
        pay *= sağdaki.payda;
        payda *= sağdaki.pay;
        return this;
    }

    /* + işleci: Bu kesirle sağdakinin toplamını üretir. */
    Kesir opBinary(string işleç)(in Kesir sağdaki) const
            if (işleç == "+") {
        /* Önce bu nesnenin bir kopyası alınıyor ve zaten
         * tanımlanmış olan += işleci o kopyaya
         * uygulanıyor. */
        Kesir sonuç = this;
        sonuç += sağdaki;
        return sonuç;
    }

    /* - işleci: Bu kesirle sağdakinin farkını üretir. */
    Kesir opBinary(string işleç)(in Kesir sağdaki) const
            if (işleç == "-") {
        /* Zaten tanımlanmış olan -= işleci kullanılıyor. */
        Kesir sonuç = this;
        sonuç -= sağdaki;
        return sonuç;
    }

    /* * işleci: Bu kesirle sağdakinin çarpımını üretir. */
    Kesir opBinary(string işleç)(in Kesir sağdaki) const
            if (işleç == "*") {
        /* Zaten tanımlanmış olan *= işleci kullanılıyor. */
        Kesir sonuç = this;
        sonuç *= sağdaki;
        return sonuç;
    }

    /* / işleci: Bu kesirin sağdakine bölümünü üretir. */
    Kesir opBinary(string işleç)(in Kesir sağdaki) const
            if (işleç == "/") {
        /* Zaten tanımlanmış olan /= işleci kullanılıyor. */
        Kesir sonuç = this;
        sonuç /= sağdaki;
        return sonuç;
    }

    /* double türünde eşdeğer üretme işleci. */
    double opCast(T : double)() const {
        /* Basit bir bölme işlemi. Ancak, long türünde bölme
         * işlemi virgülden sonrasını kırpacağından burada
         * pay/payda yazılamazdı. */
        return to!double(pay) / payda;
    }

    /* Sıra karşılaştırması: Bu kesir önce ise eksi, sonra ise
     * artı, ikisi de eşit iseler sıfır üretir. */
    int opCmp(const ref Kesir sağdaki) const {
        immutable sonuç = this - sağdaki;
        /* long türündeki pay dönüş türü olan int'e otomatik
         * olarak dönüştürülemeyeceğinden 'to' ile açıkça tür
         * dönüşümü gerekir. */
        return to!int(sonuç.pay);
    }

    /* Eşitlik karşılaştırması: Eşit iseler true üretir.
     *
     * Eşitlik karşılaştırması işlecinin bu tür için özel
     * olarak tanımlanması gerekmektedir çünkü derleyicinin
     * otomatik olarak işlettiği ve üyelerin teker teker
     * karşılaştırılmalarından oluşan opEquals Kesir türü için
     * yeterli değildir.
     *
     * Örneğin, derleyicinin opEquals'ı her ikisinin değeri de
     * 0.5 olan Kesir(1,2) ve Kesir(2,4)'ün eşit olmadıklarına
     * karar verirdi. */
    bool opEquals(const ref Kesir sağdaki) const {
        /* opCmp'ın değerinin 0 olup olmadığına bakmak
         * yeterlidir. */
        return opCmp(sağdaki) == 0;
    }
}

unittest {
    /* Payda 0 olduğunda hata atılmalı. */
    assertThrown(Kesir(42, 0));

    /* 1/3 değeriyle başlayacağız. */
    auto a = Kesir(1, 3);

    /* -1/3 */
    assert(-a == Kesir(-1, 3));

    /* 1/3 + 1 == 4/3 */
    ++a;
    assert(a == Kesir(4, 3));

    /* 4/3 - 1 == 1/3 */
    --a;
    assert(a == Kesir(1, 3));

    /* 1/3 + 2/3 == 3/3 */
    a += Kesir(2, 3);
    assert(a == Kesir(1));

    /* 3/3 - 2/3 == 1/3 */
    a -= Kesir(2, 3);
    assert(a == Kesir(1, 3));

    /* 1/3 * 8 == 8/3 */
    a *= Kesir(8);
    assert(a == Kesir(8, 3));

    /* 8/3 / 16/9 == 3/2 */
    a /= Kesir(16, 9);
    assert(a == Kesir(3, 2));

    /* double türünde bir değere dönüştürülebilmeli.
     *
     * Hatırlarsanız, double türü her değeri tam olarak ifade
     * edemez. 1.5 değeri tam olarak ifade edilebildiği için
     * bu testi bu noktada uyguladım. */
    assert(to!double(a) == 1.5);

    /* 1.5 + 2.5 == 4 */
    assert(a + Kesir(5, 2) == Kesir(4, 1));

    /* 1.5 - 0.75 == 0.75 */
    assert(a - Kesir(3, 4) == Kesir(3, 4));

    /* 1.5 * 10 == 15 */
    assert(a * Kesir(10) == Kesir(15, 1));

    /* 1.5 / 4 == 3/8 */
    assert(a / Kesir(4) == Kesir(3, 8));

    /* Sıfırla bölmek hata atmalı. */
    assertThrown(Kesir(42, 1) / Kesir(0));

    /* Payı az olan öncedir. */
    assert(Kesir(3, 5) < Kesir(4, 5));

    /* Paydası büyük olan öncedir. */
    assert(Kesir(3, 9) < Kesir(3, 8));
    assert(Kesir(1, 1_000) > Kesir(1, 10_000));

    /* Değeri küçük olan öncedir. */
    assert(Kesir(10, 100) < Kesir(1, 2));

    /* Eksi değer öncedir. */
    assert(Kesir(-1, 2) < Kesir(0));
    assert(Kesir(1, -2) < Kesir(0));

    /* Aynı değerler hem <= hem de >= olmalı.  */
    assert(Kesir(-1, -2) <= Kesir(1, 2));
    assert(Kesir(1, 2) <= Kesir(-1, -2));
    assert(Kesir(3, 7) <= Kesir(9, 21));
    assert(Kesir(3, 7) >= Kesir(9, 21));

    /* Değerleri aynı olanlar eşit olmalı. */
    assert(Kesir(1, 3) == Kesir(20, 60));

    /* Karışık işaretler aynı sonucu üretmeli. */
    assert(Kesir(-1, 2) == Kesir(1, -2));
    assert(Kesir(1, 2) == Kesir(-1, -2));
}

void main() {
}
---

$(P
Bölümde de kısaca değinildiği gibi, $(C mixin) olanağı bazı işleçlerin tanımlarını birleştirmek için kullanılabilir. Örneğin, aşağıdaki tanım dört aritmetik işlecin hepsini birden tanımlar:
)

---
    /* İkili aritmetik işleçleri. */
    Kesir opBinary(string işleç)(in Kesir sağdaki) const
            if ((işleç == "+") || (işleç == "-") ||
                (işleç == "*") || (işleç == "/")) {
        /* Önce bu nesnenin bir kopyası alınıyor ve zaten
         * tanımlanmış olan atamalı işleç o kopyaya
         * uygulanıyor. */
        Kesir sonuç = this;
        mixin ("sonuç " ~ işleç ~ "= sağdaki;");
        return sonuç;
    }
---


Macros:
        SUBTITLE=İşleç Yükleme

        DESCRIPTION=D'de türlerin kullanışlılığını arttıran olanaklarından işleç yükleme [operator overloading] ile ilgili problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işleç yükleme overloading problem çözüm
