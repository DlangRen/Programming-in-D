Ddoc

$(DERS_BOLUMU $(CH4 auto) ve $(CH4 typeof))

$(H5 $(IX auto, değişken) $(C auto))

$(P
Bazen aynı ismin iki veya daha fazla modülde birden tanımlı olduğu durumlarla karşılaşılabilir. Örneğin birbirlerinden farklı iki kütüphanenin iki modülünde de $(C File) isminde bir tür bulunabilir. O ismi tanımlayan iki modülün birden eklenmesi durumunda da yalnızca $(C File) yazmak karışıklığa neden olur; derleyici hangi türün kullanılacağını bilemez.
)

$(P
Böyle durumlarda hangi modüldeki ismin kastedildiğini belirtmek için modülün ismini de yazmak gerekir. Örneğin $(C File) türü ile ilgili böyle bir isim çakışması olduğunu varsayarsak:
)

---
std.stdio.File dosya = std.stdio.File("ogrenci_bilgisi", "r");
---

$(P
O kullanımda uzun ismin hem de iki kere yazılması gerekmiştir: sol tarafta $(C dosya) nesnesinin türünü belirtmek için, sağ tarafta ise $(C File) nesnesini kurmak için.
)

$(P
Oysa derleyiciler çoğu durumda sol tarafın türünü sağ tarafın türüne bakarak anlayabilirler. Örneğin 42 gibi bir tamsayı değerle ilklenen bir değişkenin $(C int) olduğu, veya $(C std.stdio.File) kurularak oluşturulan bir nesnenin yine $(C std.stdio.File) türünden olduğu kolayca anlaşılabilir.
)

$(P
D'nin $(C auto) anahtar sözcüğü, sol tarafın türünün sağ taraftan anlaşılabildiği durumlarda sol tarafın yazımını kolaylaştırmak için kullanılır:
)

---
    $(HILITE auto) dosya = std.stdio.File("ogrenci_bilgisi", "r");
---

$(P
$(C auto)'yu her türle kullanabilirsiniz:
)

---
    auto sayı = 42;
    auto kesirliSayı = 1.2;
    auto selam = "Merhaba";
    auto vida = BisikletVitesDüzeneğininAyarVidası(10);
---

$(P
"auto", otomatik anlamına gelen "automatic"in kısaltmasıdır. Buna rağmen $(I türün otomatik olarak anlaşılması) kavramı ile ilgili değildir. Aslında değişkenlerin yaşam süreçleri ile ilgili olan $(C auto), tanım sırasında başka belirteç bulunmadığı zaman kullanılır.
)

$(P
Başka belirteçler de türün otomatik olarak anlaşılması için yeterlidir:
)

---
    immutable i = 42;
---

$(P
Zaten $(C immutable) yazılmış olduğu için türün değişmez bir $(C int) olduğu o yazımdan da otomatik olarak anlaşılır. ($(C immutable) anahtar sözcüğünü daha sonra göreceğiz.)
)

$(H5 $(IX typeof) $(C typeof))

$(P
Bu anahtar sözcük, "türü" anlamına gelen "type of" deyiminden türemiştir. Kendisine verilen ifadenin (değişken, nesne, hazır değer, vs.) türünü o ifadeyi hiç işletmeden üretir.
)

$(P
Örneğin zaten tanımlanmış olan $(C int) türünde $(C sayı) isminde bir değişken olduğunu varsayarsak:
)

---
    int sayı = 100;        // bu zaten 'int' olarak tanımlanmış

    typeof(sayı) sayı2;    // "sayı'nın türü" anlamında
    typeof(100) sayı3;     // "100 hazır değerinin türü" anlamında
---

$(P
Yukarıdaki son iki ifade, şu ikisinin eşdeğeridir:
)

---
    int sayı2;
    int sayı3;
---

$(P
Türlerin zaten bilindiği yukarıdaki gibi durumlarda $(C typeof)'un kullanılmasına gerek olmadığı açıktır. Bu anahtar sözcük özellikle daha sonra anlatılacak olan $(LINK2 /ders/d/sablonlar.html, şablon) ve $(LINK2 /ders/d/katmalar.html, katma $(ASIL mixin)) olanaklarının kullanımında yararlıdır.
)

$(PROBLEM_TEK

$(P
42 gibi bir hazır değerin D'nin tamsayı türlerinden $(C int) türünde olduğunu yukarıda okudunuz. (Yani $(C short), $(C long), vs. değil.) Bir program yazarak 1.2 gibi bir hazır değerin türünün D'nin kesirli sayı türlerinden hangisinden olduğunu bulun: $(C float) mu, $(C double) mı, yoksa $(C real) mi? Yeni öğrendiğiniz $(C typeof) ve $(LINK2 /ders/d/temel_turler.html, Temel Türler bölümünde) öğrendiğiniz $(C .stringof) işinize yarayabilir.
)

)

Macros:
        SUBTITLE=auto ve typeof Anahtar Sözcükleri

        DESCRIPTION=D dilinin yazım kolaylığı sağlayan auto anahtar sözcüğü

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial auto

SOZLER=
$(degisken)
$(hazir_veri)
$(ilklemek)
$(kurma)
$(nesne)
$(sinif)
$(sablon)
