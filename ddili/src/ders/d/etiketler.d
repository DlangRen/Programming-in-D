Ddoc

$(DERS_BOLUMU $(IX etiket) $(IX goto) Etiketler ve $(CH4 goto))

$(P
$(IX :, etiket) Etiketler kod satırlarına isimler vermeye ve program akışını bu isimli satırlara yöneltmeye yararlar.
)

$(P
Etiketin isminden ve $(C :) karakterinden oluşurlar:
)

---
bitiş:   // ← bir etiket
---

$(P
Yukarıdaki etiket, tanımlandığı satıra $(I bitiş) ismini verir.
)

$(P
$(I Not: Aslında etiketler herhangi iki deyimin arasında da bulunabilirler ve bulundukları o noktayı isimlendirmiş olurlar. Ancak bu kullanım yaygın değildir:)
)

---
    birİfade(); $(HILITE bitiş:) başkaİfade();
---

$(H5 $(C goto))

$(P
İngilizce'de "git" anlamına gelen $(C goto), program akışını ismi belirtilen satıra yönlendirir:
)

---
void birİşlev(bool koşul) {
    writeln("birinci");

    if (koşul) {
        $(HILITE goto) bitiş;
    }

    writeln("ikinci");

bitiş:

    writeln("üçüncü");
}
---

$(P
Yukarıdaki işlev, $(C koşul)'un $(C true) olduğu durumlarda doğrudan $(C bitiş) isimli satıra gider, ve "ikinci" yazdırılmaz:
)

$(SHELL_SMALL
birinci
üçüncü
)

$(P
Etiketler ve $(C goto) D'ye C'den geçmiştir. $(C goto), yapısal programlamaya aykırı olduğu için C'de bile kaçınılması önerilen bir olanaktır. Doğrudan belirli satırlara yönlendiren $(C goto)'lar yerine $(C while), $(C for), ve diğer yapısal deyimlerin kullanılması önerilir.
)

$(P
Örneğin yukarıdaki kodun eşdeğeri, şimdiye kadar çoğu kodda gördüğümüz gibi, $(C goto) kullanmadan şöyle yazılabilir:
)

---
void birİşlev(bool koşul) {
    writeln("birinci");

    if (!koşul) {
        writeln("ikinci");
    }

    writeln("üçüncü");
}
---

$(P
Buna rağmen $(C goto)'nun C dilinde iki tane geçerli kullanımı vardır. Bu kullanımların ikisi de D'de gereksizdir.
)

$(H6 D'de gerekmeyen, sonlandırıcı bölge)

$(P
$(C goto)'nun C'deki geçerli bir kullanımı, işlevlerin sonlarına yazılan ve o işlevde ayrılmış olan kaynakların geri verilmesi gibi işlemleri içeren sonlandırıcı bölgedir:
)

$(C_CODE
// --- C kodu ---

int birIslev() {
    // ...

    if (hata) {
        goto bitis;
    }

    // ...

bitis:
    $(COMMENT // ... sonlandirma islemleri buraya yazilir ...)

    return hata;
}
)

$(P
D'de kaynak yönetimi için başka olanaklar bulunduğu için bu kullanım D'de gereksizdir. D'de sonlandırma işlemleri; çöp toplayıcı, sonlandırıcı işlevler, hata atma düzeneğinin $(C catch) ve $(C finally) blokları, $(C scope()) deyimleri, vs. gibi olanaklarla sağlanır.
)

$(P $(I Not: Bu kullanıma C++'ta da gerek yoktur.)
)

$(H6 D'de gerekmeyen, iç içe döngülerde kullanımı)

$(P
$(C goto)'nun C'deki diğer geçerli kullanımı, iç içe döngülerin daha dışta olanlarını etkilemektir.
)

$(P
Döngüyü kırmak için kullanılan $(C break), ve döngüyü hemen ilerletmek için kullanılan $(C continue), yalnızca en içteki döngüyü etkiler. C'de ve C++'ta dıştaki döngüyü kırmanın bir yolu, döngüden sonraki bir etikete gitmektir; dıştaki döngüyü ilerletmenin bir yolu da, onun hemen içindeki bir etikete gitmektir:
)

$(C_CODE
// --- C kodu ---

    while (birKosul) {

        while (baskaKosul) {

            $(COMMENT // yalnizca icteki donguyu etkiler)
            continue;

            $(COMMENT // yalnizca icteki donguyu etkiler)
            break;

            $(COMMENT // distaki icin 'continue' gibi calisir)
            goto distakiniIlerlet;

            $(COMMENT // distaki icin 'break' gibi calisir)
            goto distakindenCik;
        }

    distakiniIlerlet:
        ;
    }
distakindenCik:
)

$(P $(I Not: Bu kullanıma C++ programlarında da rastlanabilir.)
)

$(P
Aynı durum iç içe bulunan $(C switch) deyimlerinde de vardır; $(C break) yalnızca içteki $(C switch)'i etkilediğinden dıştakinden de çıkmak için $(C goto) kullanılabilir.
)

$(P
D'de $(C goto)'nun bu kullanımına da gerek yoktur. Onun yerine biraz aşağıda göstereceğim döngü etiketleri kullanılır.
)

$(H6 $(C goto)'nun kurucu işlevleri atlama sorunu)

$(P
Kurucu işlevler nesnelerin kuruldukları satırlarda çağrılırlar. Bunun nedenlerinden birisi, nesnenin kurulması için gereken bilginin henüz mevcut olmaması olabilir. Bir başka neden, belki de hiç kullanılmayacak olan bir nesneyi kurmak için gereksizce zaman ve kaynak harcamamaktır.
)

$(P
Nesnelerin kuruldukları satırlar $(C goto) ile atlandığında, henüz kurulmadıklarından hatalı sonuçlar doğuran nesnelerle karşılaşılabilir:
)

---
    if (koşul) {
        goto birEtiket;    // kurucu işlevi atlar
    }

    auto nesne = Yapı(42); // nesnenin kurulduğu satır

birEtiket:

    nesne.birİşlem();      // HATA: belki de hazır olmayan nesne
---

$(P
Derleyici bu hatayı önler:
)

$(SHELL
Error: goto skips declaration of variable deneme.main.s
)

$(H5 $(IX döngü etiketi) Döngü etiketleri)

$(P
D'de döngülerden hemen önce etiketler tanımlanabilir. $(C continue) ve $(C break) anahtar sözcüklerinde de etiket belirtilebilir ve o döngülerin etkilenmeleri sağlanabilir:
)

---
$(HILITE dışDöngü:)
    while (birKoşul) {

        while (başkaKoşul) {

            // içteki döngüyü ilerletir
            continue;

            // içteki döngüden çıkar
            break;

            // dıştaki döngüyü ilerletir
            continue $(HILITE dışDöngü);

            // dıştaki döngüden çıkar
            break $(HILITE dışDöngü);
        }
    }
---

$(P
Aynısı $(C switch) deyimleri için de geçerlidir. $(C break) deyimlerinin dıştaki bir $(C switch)'i etkilemesi için o $(C switch) deyiminden önce de etiket tanımlanabilir.
)

$(H5 $(C case) bölümlerinde kullanımı)

$(P
$(C goto)'nun $(C case) bölümlerinde nasıl kullanıldıklarını $(LINK2 /ders/d/switch_case.html, $(C switch) ve $(C case) bölümünde) görmüştük:
)

$(UL

$(LI $(IX goto case) $(IX case, goto) $(C goto case), bir sonraki $(C case)'e atlanmasını sağlar.)

$(LI $(IX goto default) $(IX default, goto) $(C goto default), $(C default) bölümüne atlanmasını sağlar.)

$(LI $(C goto case $(I ifade)), ifadeye uyan $(C case)'e atlanmasını sağlar.)

)

$(H5 Özet)

$(UL

$(LI
$(C goto)'nun riskli kullanımlarına D'de gerek yoktur.
)

$(LI
İç içe döngülerden veya $(C switch) deyimlerinden hangisinin etkileneceğini belirtmek için $(C break) ve $(C continue) deyimlerinde etiket kullanılabilir.
)

$(LI
$(C case) bölümlerindeki $(C goto)'lar diğer $(C case) ve $(C default) bölümlerine atlanmasını sağlarlar.
)

)

Macros:
        SUBTITLE=Etiketler

        DESCRIPTION=D'nin kod satırlarına isimler vermeye yarayan etiketleri, ve program akışını o satırlara yönlendiren goto anahtar sözcüğü, ve goto'nun kullanılmasına D'de gerek olmadığının gösterilmesi

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial etiket label goto while for foreach döngü break continue

SOZLER=
$(etiket)
$(kurucu_islev)
$(sonlandirici_islev)
