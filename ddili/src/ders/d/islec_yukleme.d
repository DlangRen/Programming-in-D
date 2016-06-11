Ddoc

$(DERS_BOLUMU $(IX işleç yükleme) $(IX yükleme, işleç) İşleç Yükleme)

$(P
İşleç yükleme olanağını bu bölümde yapılar üzerinde göreceğiz. Burada anlatılanlar daha sonra göreceğimiz sınıflar için de hemen hemen aynen geçerlidir. En belirgin fark, $(LINK2 /ders/d/ozel_islevler.html, Kurucu ve Diğer Özel İşlevler bölümünde) gördüğümüz atama işleci $(C opAssign)'ın sınıflar için tanımlanamıyor olmasıdır.
)

$(P
İşleç yükleme çok sayıda kavram içerir (şablonlar, $(C auto ref), vs.). Bu kavramların bazılarını kitabın ilerideki bölümlerinde göreceğimizden bu bölüm size bu aşamada diğer bölümlerden daha zor gelebilir.
)

$(P
İşleç yükleme, işleçlerin kendi türlerimizle nasıl çalışacaklarını belirleme olanağıdır.
)

$(P
Yapıların ve üye işlevlerin yararlarını önceki bölümlerde görmüştük. Bunun bir örneği, $(C GününSaati) nesnelerine $(C Süre) nesnelerini ekleyebilmekti. Kodu kısa tutmak için yalnızca bu bölümü ilgilendiren üyelerini gösteriyorum:
)

---
struct Süre {
    int dakika;
}

struct GününSaati {
    int saat;
    int dakika;

    void $(HILITE ekle)(in Süre süre) {
        dakika += süre.dakika;

        saat += dakika / 60;
        dakika %= 60;
        saat %= 24;
    }
}

void main() {
    auto yemekZamanı = GününSaati(12, 0);
    yemekZamanı$(HILITE .ekle)(Süre(10));
}
---

$(P
Üye işlevlerin yararı, yapıyı ilgilendiren işlemlerin yapının içinde tanımlanabilmeleridir. Üye değişkenler ve üye işlevler bir arada tanımlanınca yapının üyelerinin bütün işlevler tarafından doğru olarak kullanıldıkları daha kolay denetlenebilir.
)

$(P
Yapıların bütün bu yararlarına karşın, temel türlerin işleç kullanımı konusunda yapılara karşı üstünlükleri vardır: Temel türler özel tanımlar gerekmeden işleçlerle rahatça kullanılabilirler:
)

---
    int ağırlık = 50;
    ağırlık $(HILITE +=) 10;                     // işleçle
---

$(P
Şimdiye kadar öğrendiğimiz bilgiler doğrultusunda benzer işlemleri yapılar için ancak üye işlevlerle gerçekleştirebiliyoruz:
)

---
    auto yemekZamanı = GününSaati(12, 0);
    yemekZamanı$(HILITE .ekle)(Süre(10));        // üye işlevle
---

$(P
İşleç yükleme, yapıları da temel türler gibi işleçlerle kullanabilme olanağı sunar. Örneğin, $(C GününSaati) yapısı için tanımlayabileceğimiz $(C +=) işleci, yukarıdaki işlemin yazımını kolaylaştırır ve daha okunaklı hale getirir:
)

---
    yemekZamanı $(HILITE +=) Süre(10);           // yapı için de işleçle
---

$(P
Yüklenebilecek bütün işleçlere geçmeden önce bu kullanımın nasıl sağlandığını göstermek istiyorum. Daha önce ismini $(C ekle) olarak yazdığımız işlevi D'nin özel olarak belirlediği $(C opOpAssign(string işleç)) ismiyle tanımlamak ve bu tanımın $(STRING "+") karakteri için yapılmakta olduğunu belirtmek gerekir. Biraz aşağıda açıklanacağı gibi, bu aslında $(C +=) işleci içindir.
)

$(P
Aşağıdaki tanımın şimdiye kadar gördüğümüz işlev tanımlarına benzemediğini farkedeceksiniz. Bunun nedeni, $(C opOpAssign)'ın aslında bir $(I işlev şablonu) olmasıdır. Şablonları daha ilerideki bölümlerde göreceğiz; şimdilik işleç yükleme konusunda bu söz dizimini bir kalıp olarak uygulamak gerektiğini kabul etmenizi rica ediyorum:
)

---
struct GününSaati {
// ...
    ref GününSaati opOpAssign(string işleç)(in Süre süre)  // (1)
            if (işleç == "+") {                            // (2)
        dakika += süre.dakika;

        saat += dakika / 60;
        dakika %= 60;
        saat %= 24;

        return this;
    }
}
---

$(P
Yukarıdaki şablon tanımı iki parçadan oluşur:
)

$(OL

$(LI $(C opOpAssign(string işleç)): Bunun aynen yazılması gerekir. ($(C opOpAssign)'dan başka işleç işlevlerinin de bulunduğunu aşağıda göreceğiz.)
)

$(LI $(C if (işleç == $(STRING "+"))): $(C opOpAssign) birden fazla işlecin tanımında kullanılabildiği için hangi işleç karakterinin tanımlanmakta olduğu bu söz dizimiyle belirtilir. Aslında bir $(I şablon kısıtlaması) olan bu söz diziminin ayrıntılarını da daha sonraki bir bölümde göreceğiz.
)

)

$(P
$(C ekle) işlevinden farklı olarak, dönüş türünün bu tanımda $(C void) olmadığına dikkat edin. İşleçlerin dönüş türlerini biraz aşağıda açıklayacağım.
)

$(P
Derleyici, $(C GününSaati) nesnelerinin $(C +=) işleciyle kullanıldığı yerlerde perde arkasında $(C opOpAssign!$(STRING "+")) işlevini çağırır:
)

---
    yemekZamanı += Süre(10);

    // Aşağıdaki satır üsttekinin eşdeğeridir:
    yemekZamanı.opOpAssign!"+"(Süre(10));
---

$(P
$(C opOpAssign)'dan sonra yazılan $(C !$(STRING "+")), $(C opOpAssign)'ın $(C +) karakteri için tanımı olan işlevin çağrılmakta olduğu anlamına gelir. Şablonlarla ilgili olan bu söz dizimini de daha sonraki bir bölümde göreceğiz.
)

$(P
Kod içindeki $(C +=) işlecine karşılık gelen yukarıdaki üye işlevde $(STRING "+=") değil, $(STRING "+") kullanıldığına dikkat edin. $(C opOpAssign)'ın isminde geçen ve "değer ata" anlamına gelen "assign" zaten atama kavramını içerir. Sonuçta, $(C opOpAssign!$(STRING "+")), atamalı toplama işlemi olan $(C +=) işlecinin tanımıdır.
)

$(P
İşleçlerin davranışlarını bizim belirleyebiliyor olmamız bize çoğu işleç için istediğimiz şeyi yapma serbestisi verir. Örneğin, yukarıdaki işleci süre ekleyecek şekilde değil, tam tersine süre azaltacak şekilde de tanımlayabilirdik. Oysa kodu okuyanlar $(C +=) işlecini gördüklerinde doğal olarak $(I değerin artmasını) bekleyeceklerdir.
)

$(P
Genel beklentilere uyulması işleçlerin dönüş türleri için de önemlidir.
)

$(P
İşleçleri doğal davranışları dışında yazdığınızda bunun herkesi yanıltacağını ve programda hatalara neden olacağını aklınızda bulundurun.
)

$(H5 Yüklenebilen işleçler)

$(P
İşleçler kullanım çeşitlerine göre farklı yüklenirler.
)

$(H6 $(IX tekli işleç) $(IX işleç, tekli) $(IX opUnary) Tekli işleçler)

$(P
Tek nesneyle işleyen işleçlere tekli işleç denir:
)

---
    ++ağırlık;
---

$(P
Yukarıdaki $(C ++) işleci tekli işleçtir çünkü işini yaparken tek değişken kullanmaktadır ve onun değerini bir arttırmaktadır.
)

$(P
Bu işleçler $(C opUnary) üye işlev ismiyle tanımlanırlar. $(C opUnary) parametre almaz çünkü yalnızca işlecin üzerinde uygulandığı nesneyi (yani $(C this)'i) etkiler.
)

$(P
İşlev tanımında kullanılması gereken işleç dizgileri şunlardır:
)

$(TABLE full,
$(HEAD3 İşleç, Anlamı, İşleç Dizgisi)
$(ROW3 $(IX -, eksi işareti) -nesne, ters işaretlisini üret, "-")
$(ROW3 $(IX +, artı işareti) +nesne, aynı işaretlisini üret, "+")
$(ROW3 $(IX ~, tersini alma) ~nesne, bit düzeyinde tersini al, "~")
$(ROW3 $(IX *, erişim işleci) *nesne, gösterdiğine eriş, "*")
$(ROW3 $(IX ++, arttırma) ++nesne, bir arttır, "++")
$(ROW3 $(IX --, azaltma) --nesne, bir azalt, "--")
)

$(P
Örneğin $(C ++) işlecini $(C Süre) için şöyle tanımlayabiliriz:
)

---
struct Süre {
    int dakika;

    ref Süre opUnary(string işleç)()
            if (işleç == "++") {
        ++dakika;
        return this;
    }
}
---

$(P
İşlecin dönüş türünün $(C ref) olarak işaretlendiğine dikkat edin. İşleçlerin dönüş türlerini aşağıda açıklayacağım.
)

$(P
$(C Süre) nesneleri bu sayede artık $(C ++) işleci ile arttırılabilirler:
)

---
    auto süre = Süre(20);
    ++süre;
---

$(P
$(IX ++, arttırma, önceki değerli) $(IX --, azaltma, önceki değerli) $(IX önceki değerli arttırma) $(IX önceki değerli azaltma) $(IX arttırma, sonek) $(IX azaltma, sonek) Önceki değerli (sonek) arttırma ve önceki değerli (sonek) azaltma işleçleri olan $(C nesne++) ve $(C nesne--) kullanımları yüklenemez. O kullanımlardaki önceki değerleri derleyici otomatik olarak üretir. Örneğin, $(C süre++) kullanımının eşdeğeri şudur:
)

---
    /* Önceki değer derleyici tarafından otomatik olarak
     * kopyalanır: */
    Süre __öncekiDeğer__ = süre;

    /* Tanımlanmış olan normal ++ işleci çağrılır: */
    ++süre;

    /* Daha sonra bütün ifadede __öncekiDeğer__ kullanılır. */
---

$(P
Bazı programlama dillerinden farklı olarak, $(I önceki değerin) programda kullanılmadığı durumlarda yukarıdaki kopyanın D'de bir masrafı yoktur. İfadenin kullanılmadığı durumlarda $(I önceki değerli arttırma) işleçleri normal arttırma işleçleriyle değiştirilirler:
)

---
    /* Aşağıdaki ifadenin değeri programda kullanılmamaktadır.
     * İfadenin tek etkisi, 'i'nin değerini arttırmaktır. */
    i++;
---

$(P
$(C i)'nin $(I önceki değeri) programda kullanılmadığından derleyici o ifadenin yerine aşağıdakini yerleştirir:
)

---
    /* Derleyicinin kullandığı ifade: */
    ++i;
---

$(P
Ek olarak, eğer aşağıda göreceğimiz $(C opBinary) yüklemesi $(C süre += 1) kullanımını destekliyorsa, $(C ++süre) ve $(C süre++) kullanımları için $(C opUnary) gerekmez; derleyici onların yerine $(C süre += 1) ifadesinden yararlanır. Benzer biçimde, $(C süre -= 1) yüklemesi de $(C --süre) ve $(C süre--) kullanımlarını karşılar.
)

$(H6 $(IX ikili işleç) $(IX işleç, ikili) İkili işleçler)

$(P
İki nesne kullanan işleçlere ikili işleç denir:
)

---
    toplamAğırlık $(HILITE =) kutuAğırlığı $(HILITE +) çikolataAğırlığı;
---

$(P
Yukarıdaki satırda iki farklı ikili işleç görülüyor: $(C +) işleci solundaki ve sağındaki değerleri toplar, $(C =) işleci de sağındakinin değerini solundakine atar.
)

$(P
$(IX +, toplama)
$(IX -, çıkarma)
$(IX *, çarpma)
$(IX /)
$(IX %)
$(IX ^^)
$(IX &, ve)
$(IX |)
$(IX ^, ya da)
$(IX <<)
$(IX >>)
$(IX >>>)
$(IX ~, birleştirme)
$(IX in, işleç)
$(IX ==)
$(IX !=)
$(IX <, küçüktür)
$(IX <=)
$(IX >, büyüktür)
$(IX >=)
$(IX =)
$(IX +=)
$(IX -=)
$(IX *=)
$(IX /=)
$(IX %=)
$(IX ^^=)
$(IX &=)
$(IX |=)
$(IX ^=)
$(IX <<=)
$(IX >>=)
$(IX >>>=)
$(IX ~=)
$(IX opBinary)
$(IX opAssign)
$(IX opOpAssign)
$(IX opBinaryRight)
İşleçleri gruplandırmak için aşağıdaki tabloda işleçlerin çeşitlerini de belirttim. "=" ile işaretli olanlar sağ tarafın değerini sol tarafa atarlar.
)

$(TABLE full,
$(HEAD5 $(BR)İşleç, $(BR)Anlamı, $(BR)İşlev İsmi, Sağ Taraf için$(BR)İşlev İsmi, $(BR)Çeşit)
$(ROW5 +, topla, 	opBinary, 	opBinaryRight, aritmetik)
$(ROW5 -, çıkar, 	opBinary, 	opBinaryRight, aritmetik)
$(ROW5 *, çarp, 	opBinary, 	opBinaryRight, aritmetik)
$(ROW5 /, böl, 	opBinary, 	opBinaryRight, aritmetik)
$(ROW5 %, kalanını hesapla, 	opBinary, 	opBinaryRight, aritmetik)
$(ROW5 ^^, üssünü al, 	opBinary, 	opBinaryRight, aritmetik)
$(ROW5 &, bit işlemi $(I ve), 	opBinary, 	opBinaryRight, bit)
$(ROW5 |, bit işlemi $(I veya), 	opBinary, 	opBinaryRight, bit)
$(ROW5 ^, bit işlemi $(I ya da), 	opBinary, 	opBinaryRight, bit)
$(ROW5 <<, sola kaydır, 	opBinary, 	opBinaryRight, bit)
$(ROW5 >>, sağa kaydır, 	opBinary, 	opBinaryRight, bit)
$(ROW5 >>>, işaretsiz sağa kaydır, 	opBinary, 	opBinaryRight, bit)
$(ROW5 ~, birleştir, 	opBinary, 	opBinaryRight, )
$(ROW5 in, içinde mi?, 	opBinary, 	opBinaryRight, )
$(ROW5 ==, eşittir, 	opEquals, 	-, mantıksal)
$(ROW5 !=, eşit değildir, 	opEquals, 	-, mantıksal)
$(ROW5 <, öncedir, 	opCmp, 	-, sıralama)
$(ROW5 <=, sonra değildir, 	opCmp, 	-, sıralama)
$(ROW5 >, sonradır, 	opCmp, 	-, sıralama)
$(ROW5 >=, önce değildir, 	opCmp, 	-, sıralama)
$(ROW5 =, ata, 	opAssign, 	-, =)
$(ROW5 +=, arttır, 	opOpAssign, 	-, =)
$(ROW5 -=, azalt, 	opOpAssign, 	-, =)
$(ROW5 *=, katını ata, 	opOpAssign, 	-, =)
$(ROW5 /=, bölümünü ata, 	opOpAssign, 	-, =)
$(ROW5 %=, kalanını ata, 	opOpAssign, 	-, =)
$(ROW5 ^^=, üssünü ata, 	opOpAssign, 	-, =)
$(ROW5 &=, & sonucunu ata, 	opOpAssign, 	-, =)
$(ROW5 |=, | sonucunu ata, 	opOpAssign, 	-, =)
$(ROW5 ^=, ^ sonucunu ata, 	opOpAssign, 	-, =)
$(ROW5 <<=, << sonucunu ata, 	opOpAssign, 	-, =)
$(ROW5 >>=, >> sonucunu ata, 	opOpAssign, 	-, =)
$(ROW5 >>>=, >>> sonucunu ata, 	opOpAssign, 	-, =)
$(ROW5 ~=, sonuna ekle, 	opOpAssign, 	-, =)
)

$(P
Tabloda $(I sağ taraf için) olarak belirtilen işlev isimleri, nesne işlecin sağ tarafında da kullanılabildiğinde işletilir. Kodda şöyle bir ikili işleç bulunduğunu düşünelim:
)

---
    x $(I işleç) y
---

$(P
Derleyici hangi üye işlevi işleteceğine karar vermek için yukarıdaki ifadeyi şu iki üye işlev çağrısına dönüştürür:
)

---
    x.opBinary!"işleç"(y);       // x'in solda olduğu durumun tanımı
    y.opBinaryRight!"işleç"(x);  // y'nin sağda olduğu durumun tanımı
---

$(P
O işlev çağrılarından daha uygun olanı seçilir ve işletilir.
)

$(P
Çoğu durumda $(C opBinaryRight)'ın tanımlanmasına gerek yoktur. Bu durum $(C in) işlecinde tam tersidir: $(C in) için çoğunlukla $(C opBinaryRight) tanımlanır.
)

$(P
Aşağıdaki örneklerde üye işlevleri tanımlarken parametre ismini $(C sağdaki) olarak seçtim. Bununla parametrenin $(I işlecin sağındaki nesne) olduğunu vurguluyorum:
)

---
    x $(I işleç) y
---

$(P
O ifade kullanıldığında üye işlevin $(C sağdaki) ismindeki parametresi $(C y)'yi temsil edecektir.
)

$(P
İkili işleçlerin nasıl yüklendiklerini daha aşağıdaki başlıklarda açıklayacağım.
)

$(H6 Dizi ve dilim işleçleri)

$(P
Aşağıdaki işleçler bir türün topluluk olarak kullanılabilmesini sağlarlar.
)

$(TABLE full,
$(HEAD3 Anlamı, İşlev İsmi, Örnek kullanım)
$(ROW3 eleman erişimi, opIndex, topluluk[i])
$(ROW3 elemana atama, opIndexAssign, topluluk[i] = 7)
$(ROW3 eleman üzerinde tekli işlem, opIndexUnary, ++topluluk[i])
$(ROW3 atamalı eleman işlemi, opIndexOpAssign, topluluk[i] *= 2)
$(ROW3 eleman adedi, opDollar, topluluk[$ - 1])
$(ROW3 bütün elemanlara eriştiren dilim, opSlice, topluluk[])
$(ROW3 bazı elemanlara eriştiren dilim, opSlice(size_t, size_t), topluluk[i..j])
)

$(P
Bu işleçleri aşağıda kendi başlıkları altında göreceğiz.
)

$(P
Aşağıdaki tablodaki işleçler D'nin önceki sürümlerinden kalma olduklarından kullanımları $(I önerilmez). Onların yerine yukarıdaki tablodaki işleçler kullanılır.
)

$(TABLE full,
$(HEAD3 Anlamı, İşlev İsmi, Örnek kullanım)
$(ROW3 bütün elemanlar üzerinde tekli işlem, opSliceUnary (önerilmez), ++topluluk[])
$(ROW3 bazı elemanlar üzerinde tekli işlem, opSliceUnary (önerilmez), ++topluluk[i..j])
$(ROW3 bütün elemanlara atama, opSliceAssign (önerilmez), topluluk[] = 42)
$(ROW3 bazı elemanlara atama, opSliceAssign (önerilmez), topluluk[i..j] = 7)
$(ROW3 bütün elemanlar üzerinde atamalı işlem, opSliceOpAssign (önerilmez), topluluk[] *= 2)
$(ROW3 bazı elemanlar üzerinde atamalı işlem, opSliceOpAssign (önerilmez), topluluk[i..j] *= 2)
)

$(H6 Diğer işleçler)

$(P
Yukarıdaki işleçlere ek olarak aşağıdaki işleçler de yüklenebilir:
)

$(TABLE full,
$(HEAD3 Anlamı, İşlev İsmi, Örnek kullanım)
$(ROW3 işlev çağrısı, opCall, nesne(42))
$(ROW3 tür dönüşümü işleci, opCast, to!int(nesne))
$(ROW3 var olmayan üye işlev için sevk, opDispatch, nesne.varOlmayanİşlev())
)

$(P
Bu işleçleri daha aşağıda kendi başlıkları altında açıklayacağım.
)

$(H5 Birden fazla işleci aynı zamanda tanımlamak)

$(P
Örnekleri kısa tutmak için yukarıda yalnızca $(C ++), $(C +) ve $(C +=) işleçlerini kullandık. En az bir işlecinin yüklenmesi gereken bir türün başka işleçlerinin de yüklenmelerinin gerekeceği beklenebilir. Örneğin, aşağıdaki $(C Süre) türü için $(C --) ve $(C -=) işleçleri de tanımlanmaktadır:
)

---
struct Süre {
    int dakika;

    ref Süre opUnary(string işleç)()
            if (işleç == "++") {
        $(HILITE ++)dakika;
        return this;
    }

    ref Süre opUnary(string işleç)()
            if (işleç == "--") {
        $(HILITE --)dakika;
        return this;
    }

    ref Süre opOpAssign(string işleç)(in int miktar)
            if (işleç == "+") {
        dakika $(HILITE +)= miktar;
        return this;
    }

    ref Süre opOpAssign(string işleç)(in int miktar)
            if (işleç == "-") {
        dakika $(HILITE -)= miktar;
        return this;
    }
}

unittest {
    auto süre = Süre(10);

    ++süre;
    assert(süre.dakika == 11);

    --süre;
    assert(süre.dakika == 10);

    süre += 5;
    assert(süre.dakika == 15);

    süre -= 3;
    assert(süre.dakika == 12);
}

void main() {
}
---

$(P
Yukarıdaki işleç yüklemelerinde kod tekrarı bulunmaktadır. Benzer işlevlerin farklı olan karakterlerini sarı ile işaretledim. Bu kod tekrarı D'nin $(I dizgi katmaları) ($(C mixin)) olanağı ile giderilebilir. Daha ilerideki bölümlerde daha ayrıntılı olarak öğreneceğimiz $(C mixin) anahtar sözcüğünün işleç yüklemedeki yararını burada kısaca görelim.
)

$(P
$(C mixin), kendisine verilen dizgiyi bulunduğu yere kaynak kod olarak yerleştirir. Örneğin, $(C işleç)'in $(STRING "++") olduğu durumda aşağıdaki iki satır eşdeğerdir:
)

---
    mixin (işleç ~ "dakika;");
    ++dakika;                     // üsttekinin eşdeğeri
---

$(P
Dolayısıyla, bu olanaktan yararlanan aşağıdaki yapı yukarıdakinin eşdeğeridir:
)

---
struct Süre {
    int dakika;

    ref Süre opUnary(string işleç)()
            if ((işleç == "++") || (işleç == "--")) {
        $(HILITE mixin) (işleç ~ "dakika;");
        return this;
    }

    ref Süre opOpAssign(string işleç)(in int miktar)
            if ((işleç == "+") || (işleç == "-")) {
        $(HILITE mixin) ("dakika " ~ işleç ~ "= miktar;");
        return this;
    }
}
---

$(P
$(C Süre) nesnelerinin belirli bir miktar ile çarpılmalarının veya bölünmelerinin de desteklenmesi istendiğinde yapılması gereken, o işleç karakterlerini de şablon kısıtlamalarına eklemektir:
)

---
struct Süre {
// ...

    ref Süre opOpAssign(string işleç)(in int miktar)
            if ((işleç == "+") || (işleç == "-") ||
                $(HILITE (işleç == "*") || (işleç == "/"))) {
        mixin ("dakika " ~ işleç ~ "= miktar;");
        return this;
    }
}

unittest {
    auto süre = Süre(12);

    süre $(HILITE *=) 4;
    assert(süre.dakika == 48);

    süre $(HILITE /=) 2;
    assert(süre.dakika == 24);
}
---

$(P
Şablon kısıtlamaları bu durumda isteğe bağlıdır; özellikle gerekmedikçe yazılmayabilirler:
)

---
    ref Süre opOpAssign(string işleç)(in int miktar)
            /* kısıtlama yok */ {
        mixin ("dakika " ~ işleç ~ "= miktar;");
        return this;
    }
---

$(H5 $(IX dönüş türü, işleç) İşleçlerin dönüş türleri)

$(P
İşleçleri kendi türleriniz için tanımlarken o işleçlerin hem davranışlarının hem de dönüş türlerinin temel türlerdeki gibi olmalarına dikkat edin. Bu, kodun anlaşılırlığı ve hataların önlenmesi açısından önemlidir.
)

$(P
Temel türlerle kullanılan hiçbir işlecin dönüş türü $(C void) değildir. Bu, bazı işleçler için barizdir. Örneğin, iki $(C int) değerin $(C a&nbsp;+&nbsp;b) biçiminde toplanmalarının sonucunun yine $(C int) türünde bir değer olduğu açıktır:
)

---
    int a = 1;
    int b = 2;
    int c = a + b;    // c, işlecin değeri ile ilklenir
---

$(P
Başka bazı işleçlerin dönüş değerleri ve türleri ise bariz olmayabilir. Örneğin, $(C ++i) gibi bir işlecin bile değeri vardır:
)

---
    int i = 1;
    writeln(++i);    // 2 yazar
---

$(P
$(C ++) işleci $(C i)'yi arttırmakla kalmaz, ayrıca $(C i)'nin yeni değerini de döndürür. Üstelik, $(C ++) işlecinin döndürdüğü değer $(C i)'nin yeni değeri değil, aslında $(C i)'nin $(I ta kendisidir). Bunu $(C ++i) işleminin sonucunun adresini yazdırarak gösterebiliriz:
)

---
    int i = 1;
    writeln("i'nin adresi                   : ", &i);
    writeln("++i ifadesinin sonucunun adresi: ", &(++i));
---

$(P
Çıktısı, iki adresin aynı olduklarını gösterir:
)

$(SHELL
i'nin adresi                   : 7FFFAFECB2A8
++i ifadesinin sonucunun adresi: 7FFFAFECB2A8
)

$(P
Tanımladığınız işleçlerin dönüş türlerinin aşağıdaki listedekilere uymalarına özen göstermenizi öneririm:
)

$(UL

$(LI $(B Nesneyi değiştiren işleçler)

$(P
$(C opAssign) istisna olmak üzere, nesnede değişiklik yapan işleçlerin nesnenin kendisini döndürmeleri uygundur. Bunu yukarıdaki $(C GününSaati.opOpAssign!$(STRING "+")) ve $(C Süre.opUnary!$(STRING "++")) işleçlerinde gördük.
)

$(P
Nesnenin kendisini döndürmek için şu adımlar uygulanır:
)

$(OL
$(LI Dönüş türü olarak türün kendisi yazılır ve başına "referans" anlamına gelen $(C ref) anahtar sözcüğü eklenir.)

$(LI İşlevden $(I bu nesneyi döndür) anlamında $(C return this) ile çıkılır.)
)

$(P
Nesneyi değiştiren işleçler şunlardır: $(C opUnary!$(STRING "++")), $(C opUnary!$(STRING "--")), ve bütün $(C opOpAssign) yüklemeleri.
)

)

$(LI $(B Mantıksal işleçler)

$(P
$(C ==) ve $(C !=) işleçlerini temsil eden $(C opEquals) $(C bool) döndürmelidir. $(C in) işleci ise normalde $(I içerilen nesneyi) döndürse de, istendiğinde o da basitçe $(C bool) döndürebilir.
)

)

$(LI $(B Sıralama işleçleri)

$(P
Nesnelerin sıralanmalarında yararlanılan ve $(C <), $(C <=), $(C >), ve $(C >=) işleçlerinin davranışını belirleyen $(C opCmp) $(C int) döndürmelidir.
)

)

$(LI $(B Yeni nesne üreten işleçler)

$(P
Bazı işleçlerin yeni nesne oluşturmaları ve o nesneyi döndürmeleri gerekir:
)

$(UL

$(LI Tekli işleçler $(C -), $(C +), ve $(C ~); ve ikili $(C ~) işleci.)

$(LI Aritmetik işleçler $(C +), $(C -), $(C *), $(C /), $(C %), ve $(C ^^).)

$(LI Bit işleçleri $(C &), $(C |), $(C ^), $(C <<), $(C >>), ve $(C >>>).)

$(LI $(C opAssign), bir önceki bölümde de gösterildiği gibi, $(C return this) ile bu nesnenin bir kopyasını döndürür.

$(P $(I Not: Bir eniyileştirme olarak bu işleç büyük yapılarda $(C const ref) de döndürebilir. Ben bu kitapta bu eniyileştirmeyi uygulamayacağım.)
)

)

)

$(P
Yeni nesne üreten işleç örneği olarak $(C Süre) nesnelerini birbirleriyle toplamayı sağlayan $(C opBinary!$(STRING "+")) yüklemesine bakalım:
)

---
struct Süre {
    int dakika;

    Süre opBinary(string işleç)(in Süre sağdaki) const
            if (işleç == "+") {
        return Süre(dakika + sağdaki.dakika);  // yeni nesne
    }
}
---

$(P
O tanımdan sonra programlarımızda artık $(C Süre) nesnelerini $(C +) işleciyle toplayabiliriz:
)

---
    auto gitmeSüresi = Süre(10);
    auto dönmeSüresi = Süre(11);
    Süre toplamSüre;
    // ...
    toplamSüre = gitmeSüresi $(HILITE +) dönmeSüresi;
---

$(P
Derleyici o ifadeyi dönüştürür ve perde arkasında $(C gitmeSüresi) nesnesi üzerinde bir üye işlev olarak çağırır:
)

---
    // üsttekinin eşdeğeridir:
    toplamSüre = gitmeSüresi.opBinary!"+"(dönmeSüresi);
---

)

$(LI $(C opDollar)

$(P
Eleman adedi bilgisini döndürdüğünden en uygun tür $(C size_t)'dir. Buna rağmen, özellikle gerektiğinde $(C int) gibi başka tamsayı türlerini de döndürebilir.
)

)

$(LI $(B Serbest işleçler)

$(P
Bazı işleçlerin dönüş türleri bütünüyle o yapının tasarımına bağlıdır: Tekli $(C *) işleci, $(C opCall), $(C opCast), $(C opDispatch), $(C opSlice), ve bütün $(C opIndex) işleçleri.
)

)

)

$(H5 $(IX opEquals) Eşitlik karşılaştırmaları için $(C opEquals))

$(P
$(C ==) ve $(C !=) işleçlerinin davranışını belirler.
)

$(P
$(C opEquals) işlecinin dönüş türü $(C bool)'dur.
)

$(P
Yapılarda $(C opEquals) işlevinin parametresi $(C in) olarak işaretlenebilir. Ancak, çok büyük yapılarda hız kaybını önlemek için $(C opEquals), parametresi $(C auto ref const) olan bir şablon olarak da tanımlanabilir (boş parantezler bu tanımın bir şablon olmasını sağlarlar):
)

---
    bool opEquals$(HILITE ())(auto ref const GününSaati sağdaki) const {
        // ...
    }
---

$(P
$(LINK2 /ders/d/deger_sol_sag.html, Sol Değerler ve Sağ Değerler bölümünde) gördüğümüz gibi, $(C auto ref) $(I sol değerlerin) referans olarak, $(I sağ değerlerin) ise kopyalanarak geçirilmelerini sağlar. Ancak, D'de $(I sağ değerler) kopyalanmak yerine taşındıklarından yukarıdaki işlev bildirimi hem $(I sol değerler) hem de $(I sağ değerler) için hızlı işler.
)

$(P
Karışıklıklara önlemek için $(C opEquals) ve $(C opCmp) birbirleriyle tutarlı olmalıdır. $(C opEquals)'ın $(C true) döndürdüğü iki nesne için $(C opCmp) sıfır döndürmelidir.
)

$(P
$(C opEquals) üye işlevi $(C ==) ve $(C !=) işleçlerinin ikisini de karşılar. Programcı işlevi $(C ==) işleci için tanımlar; derleyici de $(C !=) işleci için onun tersini kullanır:
)

---
    x == y;
    x.opEquals(y);       // üsttekinin eşdeğeri

    x != y;
    !(x.opEquals(y));    // üsttekinin eşdeğeri
---

$(P
Normalde $(C opEquals) işlevini yapılar için tanımlamaya gerek yoktur; derleyici bütün üyelerin eşitliklerini sırayla otomatik olarak karşılaştırır ve nesnelerin eşit olup olmadıklarına öyle karar verir.
)

$(P
Bazen nesnelerin eşitliklerinin özel olarak belirlenmeleri gerekebilir. Örneğin bazı üyeler eşitlik karşılaştırması için önemsiz olabilirler veya bir türün nesnelerinin eşit kabul edilmeleri özel bir kurala bağlı olabilir, vs.
)

$(P
Bunu göstermek için $(C GününSaati) yapısı için dakika bilgisini gözardı eden bir $(C opEquals) tanımlayalım:
)

---
struct GününSaati {
    int saat;
    int dakika;

    bool opEquals(in GününSaati sağdaki) const {
        return saat == sağdaki.saat;
    }
}
// ...
    assert(GününSaati(20, 10) $(HILITE ==) GününSaati(20, 59));
---

$(P
Eşitlik karşılaştırmasında yalnızca saat bilgisine bakıldığı için 20:10 ve 20:59 zamanları eşit çıkmaktadır. ($(I Not: Bunun karışıklık doğuracağı açıktır; gösterim amacıyla basit bir örnek olarak kabul edelim.))
)

$(H5 $(IX opCmp) Sıra karşılaştırmaları için $(C opCmp))

$(P
Sıralama işleçleri nesnelerin öncelik/sonralık ilişkilerini belirler. Sıralama ile ilgili olan $(C <), $(C <=), $(C >), ve $(C >=) işleçlerinin hepsi birden $(C opCmp) üye işlevi tarafından karşılanır.
)

$(P
Yapılarda $(C opCmp) işlevinin parametresi $(C in) olarak işaretlenebilir. Ancak, $(C opEquals)'da olduğu gibi, çok büyük yapılarda hız kaybını önlemek için $(C opCmp), parametresi $(C auto ref const) olan bir şablon olarak da tanımlanabilir:
)

---
    int opCmp$(HILITE ())(auto ref const GününSaati sağdaki) const {
        // ...
    }
---

$(P
Karışıklıkları önlemek için $(C opEquals) ve $(C opCmp) birbirleriyle tutarlı olmalıdır. $(C opEquals)'ın $(C true) döndürdüğü iki nesne için $(C opCmp) sıfır döndürmelidir.
)

$(P
Bu dört işleçten birisinin şu şekilde kullanıldığını düşünelim:
)

---
    if (x $(I işleç) y) {  $(CODE_NOTE $(I işleç) <, <=, >, veya >= olabilir)
---

$(P
Derleyici o ifadeyi aşağıdaki mantıksal ifadeye dönüştürür ve onun sonucunu kullanır:
)

---
    if (x.opCmp(y) $(I işleç) 0) {
---

$(P
Örnek olarak,
)

---
    if (x $(HILITE <=) y) {
---

$(P
ifadesi şuna dönüştürülür:
)

---
    if (x.opCmp(y) $(HILITE <=) 0) {
---

$(P
Kendi yazdığımız bu işlevin bu kurala göre doğru çalışabilmesi için işlevin şu değerleri döndürmesi gerekir:
)

$(UL
$(LI Soldaki nesne önce olduğunda $(I eksi) bir değer.)
$(LI Sağdaki nesne önce olduğunda $(I artı) bir değer.)
$(LI İki nesne eşit olduklarında $(I sıfır) değeri.)
)

$(P
Bu sonuçlardan anlaşılacağı gibi, $(C opCmp)'ın dönüş türü $(C bool) değil, $(C int)'tir.
)

$(P
$(C GününSaati) nesnelerinin sıralama ilişkilerini öncelikle saat değerine, saatleri eşit olduğunda da dakika değerlerine bakacak şekilde şöyle belirleyebiliriz:
)

---
    int opCmp(in GününSaati sağdaki) const {
        /* Not: Buradaki çıkarma işlemleri sonucun alttan
         * taşabileceği durumlarda hatalıdır. (Metin içindeki
         * uyarıyı okuyunuz.) */

        return (saat == sağdaki.saat
                ? dakika - sağdaki.dakika
                : saat - sağdaki.saat);
    }
---

$(P
Saat değerleri aynı olduğunda dakika değerlerinin farkı, saatler farklı olduğunda da saatlerin farkı döndürülüyor. Bu tanım, zaman sıralamasında $(I soldaki) nesne önce olduğunda $(I eksi) bir değer, $(I sağdaki) nesne önce olduğunda $(I artı) bir değer döndürür.
)

$(P
$(B Uyarı:) Yasal değerlerinin taşmaya neden olabildiği türlerde $(C opCmp) işlecinin çıkarma işlemi ile gerçekleştirilmesi hatalıdır. Örneğin, aşağıdaki $(C -2) değerine sahip olan nesne $(C int.max) değerine sahip olan nesneden daha $(I büyük) çıkmaktadır:
)

---
struct S {
    int i;

    int opCmp(in S rhs) const {
        return i - rhs.i;          $(CODE_NOTE_WRONG HATA)
    }
}

void main() {
    assert(S(-2) $(HILITE >) S(int.max));    $(CODE_NOTE_WRONG yanlış sonuç)
}
---

$(P
Öte yandan, çıkarma işleminin $(C GününSaati) yapısında kullanılmasında bir sakınca yoktur çünkü o türün hiçbir üyesinin yasal değerleri çıkarma işleminde taşmaya neden olmaz.
)

$(P
$(IX cmp, std.algorithm) $(IX sıralama) Bütün dizgi türleri ve aralıklar dahil olmak üzere dilimleri karşılaştırırken $(C std.algorithm.cmp) işlevinden yararlanabilirsiniz. $(C cmp()) iki dilimin sıra değerlerine uygun olarak eksi bir değer, sıfır, veya artı bir değer döndürür. Bu değer doğrudan $(C opCmp) işlevinin dönüş değeri olarak kullanılabilir:
)

---
import std.algorithm;

struct S {
    string isim;

    int opCmp(in S rhs) const {
        return $(HILITE cmp)(isim, rhs.isim);
    }
}
---

$(P
$(C opCmp)'un tanımlanmış olması bu türün $(C std.algorithm.sort) gibi sıralama algoritmalarıyla kullanılabilmesini de sağlar. $(C sort) sıralamayı belirlemek için nesneleri karşılaştırırken perde arkasında hep $(C opCmp) işletilir. Aşağıdaki program 10 adet rasgele zaman değeri oluşturuyor ve onları $(C sort) ile sıralıyor:
)

---
import std.random;
import std.stdio;
import std.string;
import std.algorithm;

struct GününSaati {
    int saat;
    int dakika;

    int opCmp(in GününSaati sağdaki) const {
        return (saat == sağdaki.saat
                ? dakika - sağdaki.dakika
                : saat - sağdaki.saat);
    }

    string toString() const {
        return format("%02s:%02s", saat, dakika);
    }
}

void main() {
    GününSaati[] zamanlar;

    foreach (i; 0 .. 10) {
        zamanlar ~= GününSaati(uniform(0, 24), uniform(0, 60));
    }

    sort(zamanlar);

    writeln(zamanlar);
}
---

$(P
Beklendiği gibi, çıktıdaki saat değerleri zamana göre sıralanmışlardır:
)

$(SHELL
[03:40,04:10,09:06,10:03,10:09,11:04,13:42,16:40,18:03,21:08]
)

$(H5 $(IX opCall) $(IX ()) İşlev gibi çağırmak için $(C opCall))

$(P
İşlev çağırırken kullanılan parantezler de işleçtir. Bu işlecin türün $(I ismi) ile kullanımını bir önceki bölümde $(C static opCall) olanağında görmüştük. O kullanım yapı nesnelerinin varsayılan olarak kurulmalarını sağlıyordu.
)

$(P
$(C opCall) türün $(I nesnelerinin) de işlev gibi kullanılabilmelerini sağlar:
)

---
    BirTür nesne;
    nesne$(HILITE ());
---

$(P
O kodda $(C nesne) bir işlev gibi çağrılmaktadır. Bu kullanım $(C static) $(I olmayan) $(C opCall) üye işlevleri tarafından belirlenir.
)

$(P
Bunun bir örneği olarak bir doğrusal denklemin $(I x) değerlerine karşılık $(I y) değerlerini hesaplayan bir yapı düşünelim:
)

$(MONO
    $(I y) = $(I a)$(I x) + $(I b)
)

$(P
O hesaptaki $(I y) değerlerini $(C opCall) işlevi içinde şöyle hesaplayabiliriz:
)

---
struct DoğrusalDenklem {
    double a;
    double b;

    double opCall(double x) const {
        return a * x + b;
    }
}
---

$(P
O işlev sayesinde yapının nesneleri işlev gibi kullanılabilir ve verilen $(I x) değerlerine karşılık $(I y) değerleri hesaplanabilir:
)

---
    DoğrusalDenklem denklem = { 1.2, 3.4 };
    // nesne işlev gibi kullanılıyor:
    double y = denklem(5.6);
---

$(P
$(I Not: $(C opCall) işlevi tanımlanmış olan yapıları $(C Tür(parametreler)) yazımıyla kuramayız çünkü o yazım da bir $(C opCall) çağrısı olarak kabul edilir. O yüzden, yukarıdaki nesnenin $(C {&nbsp;}) yazımıyla kurulması gerekmiştir. $(C DoğrusalDenklem(1.2, 3.4)) yazımı gerçekten gerektiğinde iki $(C double) parametre alan bir $(C static opCall) işlevi tanımlanmalıdır.)
)

$(P
İlk satırda nesne kurulurken denklemin çarpanı olarak 1.2, ekleneni olarak da 3.4 değerinin kullanılacağı belirleniyor. Bunun sonucunda $(C denklem) nesnesi, $(I y&nbsp;=&nbsp;1.2x&nbsp;+&nbsp;3.4) denklemini ifade etmeye başlar. Ondan sonra nesneyi artık bir işlev gibi kullanarak $(I x) değerlerini parametre olarak gönderiyor ve dönüş değeri olarak $(I y) değerlerini elde ediyoruz.
)

$(P
Bunun yararı, çarpan ve eklenen değerlerin baştan bir kere belirlenebilmesidir. Nesne o bilgiyi kendi içinde barındırır ve sonradan işlev gibi kullanıldığında yararlanır.
)

$(P
Başka çarpan ve eklenen değerleri ile kurulan bir nesneyi bu sefer de bir döngü içinde kullanan bir örneğe bakalım:
)

---
    DoğrusalDenklem denklem = { 0.01, 0.4 };

    for (double x = 0.0; x <= 1.0; x += 0.125) {
        writefln("%f: %f", x, denklem(x));
    }
---

$(P
O da $(I y&nbsp;=&nbsp;0.01x&nbsp;+&nbsp;0.4) denklemini $(I x)'in 0.0 ile 1.0 aralığındaki her 0.125 adımı için hesaplar.
)

$(H5 $(IX opIndex) $(IX opIndexAssign) $(IX opIndexUnary) $(IX opIndexOpAssign)$(IX opDollar) Dizi erişim işleçleri)

$(P
$(C opIndex), $(C opIndexAssign), $(C opIndexUnary), $(C opIndexOpAssign), ve $(C opDollar) nesneyi $(C nesne[konum]) biçiminde dizi gibi kullanma olanağı sağlarlar.
)

$(P
Dizilerden farklı olarak, bu işleçler çok boyutlu indeksleri de desteklerler. Çok boyutlu indeksler köşeli parantezler içinde birden fazla konum değeri ile sağlanır. Örneğin, iki boyutlu dizi gibi işleyen bir tür $(C nesne[konum0, konum1]) söz dizimini destekleyebilir. Bu bölümde bu işleçleri yalnızca tek boyutlu olarak kullanacağız ve çok boyutlu örneklerini $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar bölümünde) göreceğiz.
)

$(P
Aşağıdaki satırlardaki $(C kuyruk), biraz aşağıda tanıyacağımız $(C ÇiftUçluKuyruk) türünün bir nesnesi, $(C e) ise $(C int) türünde bir değişkendir.
)

$(P
$(C opIndex) eleman erişimi amacıyla kullanılır. Köşeli parantezler içindeki konum değeri işlevin parametresi haline gelir:
)

---
    e = kuyruk[3];                      // 3 numaralı eleman
    e = kuyruk.opIndex(3);              // üsttekinin eşdeğeri
---

$(P
$(C opIndexAssign) atama amacıyla kullanılır. İlk parametresi atanan değer, sonraki parametresi de köşeli parantezler içindeki konum değeridir:
)

---
    kuyruk[5] = 55;                     // 5 numaralı elemana 55 ata
    kuyruk.opIndexAssign(55, 5);        // üsttekinin eşdeğeri
---

$(P
$(C opIndexUnary), $(C opUnary)'nin benzeridir. Farkı, işlemin belirtilen konumdaki $(I eleman) üzerinde işleyecek olmasıdır:
)

---
    ++kuyruk[4];                        // 4 numaralı elemanı arttır
    kuyruk.opIndexUnary!"++"(4);        // üsttekinin eşdeğeri
---

$(P
$(C opIndexOpAssign), $(C opOpAssign)'ın benzeridir. Farkı, atamalı işlemin belirtilen konumdaki $(I eleman) üzerinde işleyecek olmasıdır:
)

---
    kuyruk[6] += 66;                    // 6 numaralı elemana 66 ekle
    kuyruk.opIndexOpAssign!"+"(66, 6);  // üsttekinin eşdeğeri
---

$(P
$(C opDollar), dilimlerden tanınan $(C $) karakterini tanımlar. İçerilen eleman adedini döndürmek içindir:
)

---
    e = kuyruk[$ - 1];                  // sonuncu eleman
    e = kuyruk[kuyruk.opDollar() - 1];  // üsttekinin eşdeğeri
---

$(H6 Eleman erişimi işleçleri örneği)

$(P
$(I Çift uçlu kuyruk) $(ASIL double-ended queue, veya kısaca deque) bir dizi gibi işleyen ama başa eleman eklemenin de sona eleman eklemek kadar hızlı olduğu bir veri yapısıdır. (Dizilerde ise başa eleman eklemek bütün elemanların yeni bir diziye taşınmalarını gerektirdiğinden yavaş bir işlemdir.)
)

$(P
Çift uçlu kuyruk veri yapısını gerçekleştirmenin bir yolu, perde arkasında iki adet diziden yararlanmak ama bunlardan birincisini ters sırada kullanmaktır. Başa eklenen eleman aslında birinci dizinin sonuna eklenir ve böylece o işlem de sona eklemek kadar hızlı olur.
)

$(P
Bu veri yapısını gerçekleştiren aşağıdaki yapı bu bölümde gördüğümüz erişim işleçlerinin hepsini tanımlamaktadır:
)

---
$(CODE_NAME ÇiftUçluKuyruk)import std.stdio;
import std.string;
import std.conv;

$(CODE_COMMENT_OUT)struct ÇiftUçluKuyruk
$(CODE_COMMENT_OUT){
private:

    /* Elemanlar bu iki üyenin hayalî olarak uç uca
     * gelmesinden oluşurlar. Ancak, 'baş' ters sırada
     * kullanılır: İlk eleman baş[$-1]'dir, ikinci eleman
     * baş[$-2]'dir, vs.
     *
     *   baş[$-1], baş[$-2], ... baş[0], son[0], ... son[$-1]
     */
    int[] baş;    // baş taraftaki elemanlar
    int[] son;    // son taraftaki elemanlar

    /* Belirtilen konumdaki elemanın hangi dilimde olduğunu
     * bulur ve o elemana bir referans döndürür. */
    ref inout(int) eleman(size_t konum) inout {
        return (konum < baş.length
                ? baş[$ - 1 - konum]
                : son[konum - baş.length]);
    }

public:

    string toString() const {
        string sonuç;

        foreach_reverse (eleman; baş) {
            sonuç ~= format("%s ", to!string(eleman));
        }

        foreach (eleman; son) {
            sonuç ~= format("%s ", to!string(eleman));
        }

        return sonuç;
    }

    /* Not: Sonraki bölümlerde göreceğimiz olanaklardan
     * yararlanıldığında toString() çok daha etkin olarak
     * aşağıdaki gibi de yazılabilir: */
    version (none) {
        void toString(void delegate(const(char)[]) hedef) const {
            import std.format;
            import std.range;

            formattedWrite(
                hedef, "%(%s %)", chain(baş.retro, son));
        }
    }

    /* Başa eleman ekler. */
    void başınaEkle(int değer) {
        baş ~= değer;
    }

    /* Sona eleman ekler.
     *
     * Örnek: kuyruk ~= değer
     */
    ref ÇiftUçluKuyruk opOpAssign(string işleç)(int değer)
            if (işleç == "~") {
        son ~= değer;
        return this;
    }

    /* Belirtilen elemanı döndürür.
     *
     * Örnek: kuyruk[konum]
     */
    inout(int) opIndex(size_t konum) inout {
        return eleman(konum);
    }

    /* Tekli işleci belirtilen elemana uygular.
     *
     * Örnek: ++kuyruk[konum]
     */
    int opIndexUnary(string işleç)(size_t konum) {
        mixin ("return " ~ işleç ~ "eleman(konum);");
    }

    /* Belirtilen elemana belirtilen değeri atar.
     *
     * Örnek: kuyruk[konum] = değer
     */
    int opIndexAssign(int değer, size_t konum) {
        return eleman(konum) = değer;
    }

    /* Belirtilen değeri belirtilen işlemde kullanır ve sonucu
     * belirtilen elemana atar.
     *
     * Örnek: kuyruk[konum] += değer
     */
    int opIndexOpAssign(string işleç)(int değer, size_t konum) {
        mixin ("return eleman(konum) " ~ işleç ~ "= değer;");
    }

    /* Uzunluk anlamına gelen $ karakterini tanımlar.
     *
     * Örnek: kuyruk[$ - 1]
     */
    size_t opDollar() const {
        return baş.length + son.length;
    }
$(CODE_COMMENT_OUT)}

void $(CODE_DONT_TEST)main() {
    auto kuyruk = ÇiftUçluKuyruk();

    foreach (i; 0 .. 10) {
        if (i % 2) {
            kuyruk.başınaEkle(i);

        } else {
            kuyruk ~= i;
        }
    }

    writefln("Üç numaralı eleman: %s",
             kuyruk[3]);    // erişim
    ++kuyruk[4];            // arttırım
    kuyruk[5] = 55;         // atama
    kuyruk[6] += 66;        // atamalı arttırım

    (kuyruk ~= 100) ~= 200;

    writeln(kuyruk);
}
---

$(P
$(C opOpAssign) işlevinin dönüş türünün de yukarıdaki ilkeler doğrultusunda $(C ref) olarak işaretlendiğine dikkat edin. $(C ~=) işleci bu sayede zincirleme olarak kullanılabilmektedir:
)

---
    (kuyruk ~= 100) ~= 200;
---

$(P
O ifadelerin sonucunda 100 ve 200 değerleri aynı kuyruk nesnesine eklenmiş olurlar:
)

$(SHELL
Üç numaralı eleman: 3
9 7 5 3 2 55 68 4 6 8 100 200 
)

$(H5 $(IX opSlice) Dilim işleçleri)

$(P
$(C opSlice) nesneyi $(C []) işleciyle kullanma olanağı verir.
)

$(P
$(IX opSliceUnary) $(IX opSliceAssign) $(IX opSliceOpAssign) Bu işlece ek olarak $(C opSliceUnary), $(C opSliceAssign), ve $(C opSliceOpAssign) işleçleri de vardır ama onların kullanımları önerilmez.
)

$(P
D, birden fazla boyutta dilimlemeyi destekler. Çok boyutlu bir dizi dilimleme örneğini ilerideki $(LINK2 /ders/d/sablonlar_ayrintili.html, Ayrıntılı Şablonlar bölümünde) göreceğiz. O bölümde anlatılacak olan yöntemler tek boyutta da kullanılabilseler de, hem yukarıdaki indeksleme işleçlerine uymazlar hem de henüz görmediğimiz şablonlar olarak tanımlanırlar. Bu yüzden, bu bölümde $(C opSlice)'ın şablon olmayan ve yalnızca tek boyutta kullanılabilen bir kullanımını göreceğiz. ($(C opSlice)'ın bu kullanımı da önerilmez.)
)

$(P
$(C opSlice)'ın iki farklı kullanımı vardır:
)

$(UL

$(LI $(I Bütün elemanlar) anlamına gelen $(C kuyruk[]) biçiminde köşeli parantezlerin içinin boş olduğu kullanım
)

$(LI $(I Belirtilen aralıktaki elemanlar) anlamına gelen $(C kuyruk[baş .. son]) biçiminde köşeli parantezlerin içinde bir sayı aralığı belirtilen kullanım)

)

$(P
Hem elemanları bir araya getiren $(I topluluk) kavramıyla hem de o elemanlara erişim sağlayan $(I aralık) kavramıyla ilgili olduklarından bu işleçler diğerlerinden daha karmaşık gelebilirler. Topluluk ve aralık kavramlarını ilerideki bölümlerde daha ayrıntılı olarak göreceğiz.
)

$(P
Şablon olmayan ve yalnızca tek boyutta işleyen $(C opSlice)'ın buradaki kullanımı, topluluktaki belirli bir aralıktaki elemanları temsil eden bir nesne döndürür. O aralıktaki elemanlara uygulanan işleçleri tanımlamak o nesnenin görevidir. Örneğin, aşağıdaki kullanım perde arkasında önce $(C opSlice) yüklemesinden yararlanarak bir aralık nesnesi üretir, sonra $(C opOpAssign!$(STRING "*")) işlecini o aralık nesnesi üzerinde işletir:
)

---
    kuyruk[] *= 10;             // bütün elemanları 10'la çarp

    // Üsttekinin eşdeğeri:
    {
        auto aralık = kuyruk.opSlice();
        aralık.opOpAssign!"*"(10);
    }
---

$(P
Buna uygun olarak, $(C ÇiftUçluKuyruk) türünün $(C opSlice) işlevleri özel bir $(C Aralık) nesnesi döndürür:
)

---
import std.exception;

struct ÇiftUçluKuyruk {
$(CODE_XREF ÇiftUçluKuyruk)// ...

    /* Bütün elemanları kapsayan bir aralık döndürür.
     * ('Aralık' yapısı aşağıda tanımlanıyor.)
     *
     * Örnek: kuyruk[]
     */
    inout(Aralık) $(HILITE opSlice)() inout {
        return inout(Aralık)(baş[], son[]);
    }

    /* Belirli elemanları kapsayan bir aralık döndürür.
     *
     * Örnek: kuyruk[ilkKonum .. sonKonum]
     */
    inout(Aralık) $(HILITE opSlice)(size_t ilkKonum, size_t sonKonum) inout {
        enforce(sonKonum <= opDollar());
        enforce(ilkKonum <= sonKonum);

        /* Belirtilen aralığın 'baş' ve 'son' dilimlerinin
         * hangi bölgelerine karşılık geldiklerini hesaplamaya
         * çalışıyoruz. */

        if (ilkKonum < baş.length) {
            if (sonKonum < baş.length) {
                /* Aralık bütünüyle 'baş' içinde. */
                return inout(Aralık)(
                    baş[$ - sonKonum .. $ - ilkKonum],
                    []);

            } else {
                /* Aralığın bir bölümü 'baş' içinde, geri
                 * kalanı 'son' içinde. */
                return inout(Aralık)(
                    baş[0 .. $ - ilkKonum],
                    son[0 .. sonKonum - baş.length]);
            }

        } else {
            /* Aralık bütünüyle 'son' içinde. */
            return inout(Aralık)(
                [],
                son[ilkKonum - baş.length .. sonKonum - baş.length]);
        }
    }

    /* Kuyruğun belirli bir aralığını temsil eder. opUnary,
     * opAssign, ve opOpAssign işleçlerinin tanımları bu yapı
     * içindedir. */
    struct $(HILITE Aralık) {
        int[] başAralık;    // 'baş' içindeki elemanlar
        int[] sonAralık;    // 'son' içindeki elemanlar

        /* Belirtilen tekli işleci elemanlara uygular. */
        Aralık opUnary(string işleç)() {
            mixin (işleç ~ "başAralık[];");
            mixin (işleç ~ "sonAralık[];");
            return this;
        }

        /* Belirtilen değeri elemanlara atar. */
        Aralık opAssign(int değer) {
            başAralık[] = değer;
            sonAralık[] = değer;
            return this;
        }

        /* Belirtilen değeri her eleman için belirtilen
         * işlemde kullanır ve sonucu o elemana atar. */
        Aralık opOpAssign(string işleç)(int değer) {
            mixin ("başAralık[] " ~ işleç ~ "= değer;");
            mixin ("sonAralık[] " ~ işleç ~ "= değer;");
            return this;
        }
    }
}

void $(CODE_DONT_TEST)main() {
    auto kuyruk = ÇiftUçluKuyruk();

    foreach (i; 0 .. 10) {
        if (i % 2) {
            kuyruk.başınaEkle(i);

        } else {
            kuyruk ~= i;
        }
    }

    writeln(kuyruk);
    kuyruk$(HILITE []) *= 10;
    kuyruk$(HILITE [3 .. 7]) = -1;
    writeln(kuyruk);
}
---

$(P
Çıktısı:
)

$(SHELL
9 7 5 3 1 0 2 4 6 8 
90 70 50 -1 -1 -1 -1 40 60 80 
)

$(H5 $(IX opCast) $(IX tür dönüşümü) Tür dönüşümü işleci $(C opCast))

$(P
$(C opCast) elle açıkça yapılan tür dönüşümünü belirler ve dönüştürülecek her tür için ayrı ayrı yüklenebilir. Daha önceki bölümlerden hatırlayacağınız gibi, açıkça tür dönüşümü hem $(C to) işlevi ile hem de $(C cast) işleciyle sağlanabilir.
)

$(P
Bu işleç de şablon olarak tanımlanır ama kalıbı farklıdır: Hangi dönüşümün tanımlanmakta olduğu $(C (T&nbsp;:&nbsp;dönüştürülecek_tür)) söz dizimiyle belirtilir:
)

---
    $(I dönüştürülecek_tür) opCast(T : $(I dönüştürülecek_tür))() {
        // ...
    }
---

$(P
Yine şimdilik bir kalıp olarak kabul etmenizi istediğim bu söz dizimini de daha sonraki $(LINK2 /ders/d/sablonlar.html, Şablonlar bölümünde) göreceğiz.
)

$(P
$(C Süre)'nin saat ve dakikadan oluşan bir tür olduğunu kabul edelim. Bu türün nesnelerini $(C double) türüne dönüştüren işlev aşağıdaki gibi tanımlanabilir:
)

---
import std.stdio;
import std.conv;

struct Süre {
    int saat;
    int dakika;

    double opCast(T : double)() const {
        return saat + (to!double(dakika) / 60);
    }
}

void main() {
    auto süre = Süre(2, 30);
    double kesirli = to!double(süre); // cast(double)süre de olabilirdi
    writeln(kesirli);
}
---

$(P
Yukarıdaki tür dönüşümü satırında derleyici üye işlevi perde arkasında şöyle çağırır:
)

---
    double kesirli = süre.opCast!double();
---

$(P
$(C double) türüne dönüştüren yukarıdaki işleç iki saat otuz dakikaya karşılık 2.5 değerini üretmektedir:
)

$(SHELL
2.5
)

$(H5 $(IX opDispatch) $(IX sevk işleci) Sevk işleci $(C opDispatch))

$(P
Nesnenin var olmayan bir üyesine erişildiğinde çağrılacak olan üye işlevdir. Var olmayan üyelere yapılan bütün erişimler bu işlece $(I sevk edilir).
)

$(P
Var olmayan üyenin ismi $(C opDispatch)'in bir şablon parametresi olarak belirir.
)

$(P
Bu işleci çok basit olarak gösteren bir örnek:
)

---
import std.stdio;

struct BirTür {
    void opDispatch(string isim, T)(T parametre) {
        writefln("BirTür.opDispatch - isim: %s, değer: %s",
                 isim, parametre);
    }
}

void main() {
    BirTür nesne;
    nesne.varOlmayanİşlev(42);
    nesne.varOlmayanBaşkaİşlev(100);
}
---

$(P
Var olmayan üyelerine erişildiği halde derleme hatası alınmaz. Bütün o çağrılar $(C opDispatch) işlevinin çağrılmasını sağlarlar. Birinci şablon parametresi işlevin ismidir. Çağrılan noktada kullanılan parametreler de $(C opDispatch)'in parametreleri haline gelirler:
)

$(SHELL
BirTür.opDispatch - isim: varOlmayanİşlev, değer: 42
BirTür.opDispatch - isim: varOlmayanBaşkaİşlev, değer: 100
)

$(P
$(C isim) şablon parametre değeri normalde $(C opDispatch) içinde kullanılabilir ve işlemler onun değerine bağlı olarak seçilebilirler:
)

---
   switch (isim) {
       // ...
   }
---

$(H5 $(IX in, işleç yükleme) $(IX !in) İçerme sorgusu için $(C opBinaryRight!"in"))

$(P
Eşleme tablolarından tanıdığımız $(C in) işlecini nesneler için de tanımlama olanağı sağlar.
)

$(P
Diğer işleçlerden farklı olarak, bu işleç için nesnenin sağda yazıldığı durum daha doğaldır:
)

---
        if (zaman in öğleTatili) {
---

$(P
O yüzden bu işleç için daha çok $(C opBinaryRight!$(STRING "in")) yüklenir ve derleyici perde arkasında o üye işlevi çağırır:
)

---
                                        // üsttekinin eşdeğeri
        if (öğleTatili.opBinaryRight!"in"(zaman)) {
---

$(P
$(C !in) işleci ise bir değerin eşleme tablosunda $(I bulunmadığını) belirlemek için kullanılır:
)

---
        if (a !in b) {
---

$(P
$(C !in) yüklenemez çünkü derleyici perde arkasında $(C in) işlecinin sonucunun tersini kullanır:
)

---
        if (!(a in b)) {    // üsttekinin eşdeğeri
---

$(H6 $(C in) işleci örneği)

$(P
Bu örnek daha önce gördüğümüz $(C Süre) ve $(C GününSaati) yapılarına ek olarak bir de $(C ZamanAralığı) yapısı tanımlıyor. Bu yapı için tanımlanan $(C in) işleci belirli bir zamanın belirli bir aralıkta olup olmadığını bildirmek için kullanılacak.
)

$(P
Bu örnekte de yalnızca gerektiği kadar üye işlev kullandım.
)

$(P
$(C GününSaati) nesnesinin $(C for) döngüsünde nasıl temel türler kadar rahat kullanıldığına özellikle dikkat edin. O döngü işleç yüklemenin yararını gösteriyor.
)

---
import std.stdio;
import std.string;

struct Süre {
    int dakika;
}

struct GününSaati {
    int saat;
    int dakika;

    ref GününSaati opOpAssign(string işleç)(in Süre süre)
            if (işleç == "+") {
        dakika += süre.dakika;

        saat += dakika / 60;
        dakika %= 60;
        saat %= 24;

        return this;
    }

    int opCmp(in GününSaati sağdaki) const {
        return (saat == sağdaki.saat
                ? dakika - sağdaki.dakika
                : saat - sağdaki.saat);
    }

    string toString() const {
        return format("%02s:%02s", saat, dakika);
    }
}

struct ZamanAralığı {
    GününSaati baş;
    GününSaati son;    // son aralığın dışında kabul edilir

    bool opBinaryRight(string işleç)(GününSaati zaman) const
            if (işleç == "in") {
        return (zaman >= baş) && (zaman < son);
    }
}

void main() {
    auto öğleTatili = ZamanAralığı(GününSaati(12, 00),
                                   GününSaati(13, 00));

    for (auto zaman = GününSaati(11, 30);
         zaman < GününSaati(13, 30);
         zaman += Süre(15)) {

        if (zaman in öğleTatili) {
            writeln(zaman, " öğle tatilinde");

        } else {
            writeln(zaman, " öğle tatili dışında");
        }
    }
}
---

$(P
Çıktısı:
)

$(SHELL
11:30 öğle tatili dışında
11:45 öğle tatili dışında
12:00 öğle tatilinde
12:15 öğle tatilinde
12:30 öğle tatilinde
12:45 öğle tatilinde
13:00 öğle tatili dışında
13:15 öğle tatili dışında
)

$(PROBLEM_TEK

$(P
Payını ve paydasını $(C long) türünde iki üye olarak tutan bir kesirli sayı türü tanımlayın. Böyle bir yapının bir yararı, $(C float), $(C double), ve $(C real)'deki değer kayıplarının bulunmamasıdır. Örneğin, 1.0/3 gibi bir $(C double) değerin 3 ile çarpılmasının sonucu 1.0 olmadığı halde 1/3'ü temsil eden $(C Kesirli) bir nesnenin 3 ile çarpılmasının sonucu tam olarak 1'dir:

)

---
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

    /* ... işleçleri siz tanımlayın ... */
}
---

$(P
Bu yapı için işleçler tanımlayarak olabildiğince temel türler gibi işlemesini sağlayın. Yapının tanımı tamamlandığında aşağıdaki birim testi bloğu hatasız işletilebilsin. O blokta şu işlemler bulunuyor:
)

$(UL

$(LI Payda sıfır olduğunda hata atılıyor. (Bu, yukarıdaki kurucudaki $(C enforce) ile zaten sağlanıyor.))

$(LI Değerin eksi işaretlisini üretmek: Örneğin, 1/3 değerinin eksilisi olarak -1/3 değeri elde ediliyor.)

$(LI $(C ++) ve $(C --) ile değer bir arttırılıyor veya azaltılıyor.)

$(LI Dört işlem destekleniyor: Hem $(C +=), $(C -=), $(C *=), ve $(C /=) ile tek nesnenin değeri değiştirilebiliyor hem de iki nesne $(C +), $(C -), $(C *), ve $(C /) aritmetik işlemlerinde kullanılabiliyor. (Kurucuda olduğu gibi, sıfıra bölme işlemi de denetlenmeli ve önlenmelidir.)

$(P
Hatırlatma olarak, a/b ve c/d gibi iki kesirli arasındaki aritmetik işlem formülleri şöyledir:
)

$(UL
$(LI Toplama: a/b + c/d = (a*d + c*b)/(b*d))
$(LI Çıkarma: a/b - c/d = (a*d - c*b)/(b*d))
$(LI Çarpma: a/b * c/d = (a*c)/(b*d))
$(LI Bölme: (a/b) / (c/d) = (a*d)/(b*c))
)

)

$(LI Nesnenin değeri $(C double)'a dönüştürülebiliyor.)

$(LI Sıralama ve eşitlik karşılaştırmaları pay ve paydaların tam değerlerine göre değil, o üyelerin ifade ettikleri değerlere göre uygulanıyorlar. Örneğin 1/3 ve 20/60 kesirli değerleri eşit kabul ediliyorlar.
)

)

---
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
---

)

Macros:
        SUBTITLE=İşleç Yükleme

        DESCRIPTION=D'de türlerin kullanışlılığını arttıran olanaklarından işleç yükleme [operator overloading]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işleç yükleme overloading

SOZLER=
$(atama)
$(eniyilestirme)
$(islec)
$(kisitlama)
$(kurma)
$(sag_deger)
$(sol_deger)
$(sablon)
$(yukleme)
