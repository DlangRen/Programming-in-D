Ddoc

$(DERS_BOLUMU $(IX üçlü işleç) $(IX ?:) Üçlü İşleç $(CH4 ?:))

$(P
$(C ?:) işleci, temelde bir $(C if-else) deyimi gibi çalışır:
)

---
if (/* koşul */) {
    /* doğruluk işlemleri */

} else {
    /* doğru olmama işlemleri */
}
---

$(P
$(C if) deyimi, koşul doğru olduğunda doğruluk işlemlerini, aksi durumda diğer işlemleri işletir. Hatırlarsanız, $(C if) bir deyimdir ve bu yüzden kendi değeri yoktur; tek etkisi, programın işleyişini etkilemesidir.
)

$(P
$(C ?:) işleci ise bir $(I ifadedir) ve $(C if-else) ile aynı işi, ama bir değer üretecek şekilde gerçekleştirir. Yukarıdaki kodu $(C ?:) kullanarak şöyle yazabiliriz (bölüm açıklamalarını kısaltarak gösteriyorum):
)

---
/* koşul */ ? /* doğruluk işlemi */ : /* doğru olmama işlemi */
---

$(P
$(C ?:) işleci üç bölümündeki üç ifade yüzünden $(I üçlü işleç) olarak adlandırılır.
)

$(P
Bu işlecin değeri; koşula bağlı olarak ya doğruluk işleminin, ya da doğru olmama işleminin değeridir. İfade olduğu için, ifadelerin kullanılabildiği her yerde kullanılabilir.
)

$(P
Aşağıdaki örneklerde aynı işi hem $(C ?:) işleci ile, hem de $(C if) deyimi ile gerçekleştireceğim. $(C ?:) işlecinin bu örneklerdeki gibi durumlarda çok daha kısa olduğunu göreceksiniz.
)

$(UL

$(LI $(B İlkleme)

$(P
Artık yıl olduğunda 366, olmadığında 365 değeri ile ilklemek için:
)
---
    int günAdedi = artıkYıl ? 366 : 365;
---

$(P
Aynı işi $(C if) ile yapmak istesek; bir yol, baştan hiç ilklememek ve değeri sonra vermektir:
)

---
    int günAdedi;

    if (artıkYıl) {
        günAdedi = 366;

    } else {
        günAdedi = 365;
    }
---

$(P
$(C if) ile başka bir yol; baştan $(I artık yıl) değilmiş gibi ilklemek ve adedi sonra bir arttırmak olabilir:
)

---
    int günAdedi = 365;

    if (artıkYıl) {
        ++günAdedi;
    }
---

)

$(LI $(B Yazdırma)

$(P
Yazdırılan bir mesajın bir parçasını $(C ?:) ile duruma göre farklı yazdırmak:
)
---
    writeln("Bardağın yarısı ", iyimser ? "dolu" : "boş");
---

$(P
Aynı işi yapmak için mesajın baş tarafını önce yazdırabilir ve gerisini sonra $(C if) ile seçebiliriz:
)

---
    write("Bardağın yarısı ");

    if (iyimser) {
        writeln("dolu");

    } else {
        writeln("boş");
    }
---

$(P
$(C if) ile başka bir yol, bütün mesajı farklı olarak yazdırmaktır:
)

---
    if (iyimser) {
        writeln("Bardağın yarısı dolu");

    } else {
        writeln("Bardağın yarısı boş");
    }
---

)

$(LI $(B Hesap)

$(P
Tavla puanını mars olup olmama durumuna göre $(C ?:) ile 2 veya 1 arttırmak:
)
---
    tavlaPuanı += marsOldu ? 2 : 1;
---

$(P
$(C if) ile puanı duruma göre 2 veya 1 arttırmak:
)
---
    if (marsOldu) {
        tavlaPuanı += 2;

    } else {
        tavlaPuanı += 1;
    }
---

$(P
$(C if) ile başka bir yol; baştan bir arttırmak ve mars ise bir kere daha arttırmak olabilir:
)
---
    ++tavlaPuanı;

    if (marsOldu) {
        ++tavlaPuanı;
    }
---

)

)

$(P
Bu örneklerden görüldüğü gibi kod $(C ?:) işleci ile çok daha kısa olmaktadır.
)

$(H5 Üçlü işlecin türü)

$(P
$(C ?:) işlecinin değeri denetlenen koşula bağlı olarak ya doğruluk ifadesinin ya da doğru olmama ifadesinin değeridir. Bu iki ifadenin $(I ortak) bir türlerinin bulunması şarttır.
)

$(P
$(IX ortak tür) Ortak tür, oldukça karmaşık bir yöntemle ve iki tür arasındaki $(LINK2 /ders/d/tur_donusumleri.html, tür dönüşümü) ve $(LINK2 /ders/d/tureme.html, türeme) ilişkilerine de bağlı olarak seçilir. Ek olarak, ortak türün $(I çeşidi) $(LINK2 /ders/d/deger_sol_sag.html, ya sol değerdir ya da sağ değer). Bu kavramları ilerideki bölümlerde göreceğiz.
)

$(P
Şimdilik, ortak türü $(I açıkça tür dönüşümü gerektirmeden her iki değeri de tutabilen bir tür) olarak kabul edin. Örneğin, $(C int) ve $(C long) türleri için ortak bir tür vardır çünkü her ikisi de $(C long) türü ile ifade edilebilir. Öte yandan, $(C int) ve $(C string) türlerinin ortak bir türü yoktur çünkü ikisi de diğerine otomatik olarak dönüşemez.
)

$(P
Hatırlarsanız, bir ifadenin türü $(C typeof) ve $(C .stringof) ile öğrenilebilir. Bu yöntem üçlü ifade için seçilen ortak türü öğrenmek için de kullanılabilir:
)

---
    int i;
    double d;

    auto sonuç = birKoşul ? i : d;
    writeln(typeof(sonuç)$(HILITE .stringof));
---

$(P
$(C double) türü $(C int) değerlerini ifade edebildiğinden (ve bunun tersi doğru olmadığından), yukarıdaki üçlü ifadenin türü $(C double) olarak seçilmiştir:
)

$(SHELL
double
)

$(P
Geçerli olmayan bir örnek olarak bir forum sitesinin oluşturduğu bir mesaja bakalım. Bağlı olan kullanıcı sayısı 1 olduğunda mesaj "Tek" kelimesi ile yazılsın: "$(B Tek) kullanıcı bağlı". Kullanıcı sayısı 1'den farklı olduğunda ise rakamla gösterilsin: "$(B 3) kullanıcı bağlı".
)

$(P
"Tek" ve 3 arasındaki seçim $(C ?:) işleciyle doğrudan yapılamaz:
)

---
    writeln((adet == 1) ? "Tek" : adet,    $(DERLEME_HATASI)
            " kullanıcı bağlı");
---

$(P
Ne yazık ki o kod yasal değildir çünkü koşul sonucunda seçilecek iki ifadenin ortak türü yoktur: $(STRING "Tek") bir $(C string) olduğu halde, $(C adet) bir $(C int)'tir.
)

$(P
Çözüm olarak $(C adet)'i de $(C string)'e dönüştürebiliriz. $(C std.conv) modülünde bulunan $(C to!string) işlevi kendisine verilen ifadenin $(C string) karşılığını üretir:
)

---
import std.conv;
// ...
    writeln((adet == 1) ? "Tek" : to!string(adet),
            " kullanıcı bağlı");
---

$(P
Bu durumda $(C ?:) işlecinin her iki ifadesi de $(C string) olduğundan kod hatasız olarak derlenir ve çalışır.
)

$(PROBLEM_TEK

$(P
Program kullanıcıdan bir tamsayı değer alsın; bu değerin sıfırdan küçük olması $(I zararda olmak), sıfırdan büyük olması da $(I kazançlı olmak) anlamına gelsin.
)

$(P
Program verilen değere göre sonu "zarardasınız" veya "kazançlısınız" ile biten bir mesaj yazdırsın. Örneğin "100 lira zarardasınız" veya "70 lira kazançlısınız". Daha uygun görseniz bile bu bölümle ilgili olabilmesi için $(C if) koşulunu kullanmayın.
)

)


Macros:
        SUBTITLE=Üçlü İşleç ?:

        DESCRIPTION=D dilinin üçlü ?: işlecinin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial ?: üçlü işleç

SOZLER=
$(deyim)
$(ifade)
$(ilklemek)
$(islec)
