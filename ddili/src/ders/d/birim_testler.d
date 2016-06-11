Ddoc

$(DERS_BOLUMU $(IX birim testleri) $(IX test) Birim Testleri)

$(P
Programcılığın kaçınılmaz uğraşlarından birisi hata ayıklamaktır.
)

$(P
$(IX hata, nedenleri) Her kullanıcının yakından tanıdığı gibi, içinde bilgisayar programı çalışan her cihaz yazılım hataları içerir. Yazılım hataları, kol saati gibi basit elektronik aletlerden uzay aracı gibi büyük sistemlere kadar her yerde bulunur.
)

$(H5 Hata nedenleri)

$(P
Yazılım hatalarının çok çeşitli nedenleri vardır. Programın fikir aşamasından başlayarak kodlanmasına doğru kabaca sıralarsak:
)

$(UL

$(LI
Programdan istenenler açık bir şekilde ortaya konmamış olabilir. Hatta, belki de programın tam olarak ne yapacağı başından belli değildir.
)

$(LI
Programcı programdan istenenleri yanlış anlamış olabilir.
)

$(LI
Programlama dili programdan istenenleri ifade etmekte yetersiz kalabilir. Bir insana Türkçe anlatırken bile anlaşmazlıklar yaşandığını göz önüne alırsak, bilgisayar dilinin karmaşık söz dizimleri ve kuralları istenenlerin tam olarak ifade edilmesi için yeterli olmayabilir.
)

$(LI
Programcının varsayımları yanlış çıkabilir. Örneğin, pi sayısı olarak 3.14 değerinin yeterli olduğu varsayılmış olabilir.
)

$(LI
Programcının bilgisi herhangi bir konuda yetersiz veya yanlış olabilir. Örneğin, kesirli sayıların eşitlik karşılaştırmalarında kullanılmalarının güvensiz olduğunu bilmiyordur.
)

$(LI
Program baştan düşünülmemiş olan bir durumla karşılaşabilir. Örneğin, bir klasördeki dosyalardan birisi program o listeyi bir döngüde kullanırken silinmiş veya o dosyanın ismi değiştirilmiş olabilir.
)

$(LI
Programcı kodu yazarken dikkatsizlik yapabilir. Örneğin, bir işlem sırasında $(C toplamFiyat) yerine $(C toptanFiyat) yazabilir.
)

$(LI vs.)

)

$(P
Ne yazık ki, günümüzde henüz tam olarak sağlam kod üreten yazılım geliştirme yöntemleri bulunamamıştır. Bu konu, sürekli olarak çözüm bulunmaya çalışılan ve her beş on yılda bir ümit verici yöntemlerin ortaya çıktığı bir konudur.
)

$(H5 Hatanın farkedildiği zaman)

$(P
Yazılım hatasının ne zaman farkına varıldığı da çeşitlilik gösterir. En erkenden en geçe doğru sıralayarak:
)

$(UL
$(LI Kod yazılırken

$(UL
$(LI Programı yazan kişi tarafından
)

$(LI Başka bir programcı tarafından; örneğin $(I çiftli programlama) $(ASIL pair programming) yöntemi uygulandığında, yapılan bir yazım hatasını programı yazan kişinin yanındaki programcı farkedebilir
)

$(LI Derleyici tarafından; derleyicinin verdiği hata mesajları veya uyarılar çoğunlukla programcı hatalarını gösterirler
)

$(LI Programın programcı tarafından oluşturulması sırasında $(B birim testleri) tarafından
)
)

)

$(LI Kod incelenirken

$(UL
$(LI Kaynak kodu inceleyen araç programlar tarafından
)

$(LI Kodu inceleyen başka programcılar tarafından $(I kod incelemesi) $(ASIL code review) sırasında
)
)

)

$(LI Program kullanımdayken

$(UL
$(LI Programın işleyişini inceleyen araç programlar tarafından (örneğin Linux ortamlarındaki açık kodlu 'valgrind' programı ile)
)

$(LI Sürümden önce test edilirken, ya $(C assert) denetimlerinin başarısızlığından ya da programın gözlemlenen davranışından
)

$(LI Sürümden önce $(I beta) kullanıcıları tarafından test edilirken
)

$(LI Sürümdeyken son kullanıcılar tarafından)

)

)

)

$(P
Hata ne kadar erken farkedilirse hem zararı o kadar az olur, hem de o kadar az sayıda insanın zamanını almış olur. Bu yüzden en iyisi, hatanın kodun yazıldığı sırada yakalanmasıdır. Geç farkedilen hata ise başka programcıların, programı test edenlerin, ve çok sayıdaki kullanıcının da zamanını alır.
)

$(P
Son kullanıcıya gidene kadar farkedilmemiş olan bir hatanın kodun hangi noktasından kaynaklandığını bulmak da çoğu durumda oldukça zordur. Bu noktaya kadar farkedilmemiş olan bir hata, bazen aylarca sürebilen uğraşlar sonucunda temizlenebilir.
)

$(H5 Hata yakalamada birim testleri)

$(P
Kodu yazan programcı olmazsa zaten kod olmaz. Ayrıca, derlemeli bir dil olduğu için D programları zaten derleyici kullanmadan oluşturulamazlar. Bunları bir kenara bıraktığımızda, program hatalarını yakalamada en erken ve bu yüzden de en etkin yöntem olarak birim testleri kalır.
)

$(P
Birim testleri, modern programcılığın ayrılmaz araçlarındandır. Kod hatalarını azaltma konusunda en etkili yöntemlerdendir. Birim testleri olmayan kod, hatalı kod olarak kabul edilir.
)

$(P
Ne yazık ki bunun tersi doğru değildir: birim testlerinin olması, kodun hatasız olduğunu kanıtlamaz; ama hata oranını çok büyük ölçüde azaltır.
)

$(P
Birim testleri ayrıca kodun rahatça ve güvenle geliştirilebilmesini de sağlarlar. Kod üzerinde değişiklik yapmak, örneğin yeni olanaklar eklemek, doğal olarak o kodun eski olanaklarının artık hatalı hale gelmelerine neden olabilir. Kodun geliştirilmesi sırasında ortaya çıkan böyle hatalar, ya çok sonraki sürüm testleri sırasında farkedilirler, ya da daha kötüsü, program son kullanıcılar tarafından kullanılırken.
)

$(P
Bu tür hatalar kodun yeniden düzenlenmesinden çekinilmesine ve kodun gittikçe $(I çürümesine) $(ASIL code rot) neden olurlar. Örneğin bazı satırların aslında yeni bir işlev olarak yazılmasının gerektiği bir durumda, yeni hatalardan korkulduğu için koda dokunulmaz ve $(I kod tekrarı) gibi zararlı durumlara düşülebilir.
)

$(P
Programcı kültüründe duyulan "bozuk değilse düzeltme" ("if it isn't broken, don't fix it") gibi sözler, hep bu korkunun ürünüdür. Bu gibi sözler, yazılmış olan koda dokunmamayı erdem olarak gösterdikleri için zaman geçtikçe kodun çürümesine ve üzerinde değişiklik yapılamaz hale gelmesine neden olurlar.
)

$(P
Modern programcılıkta bu düşüncelerin yeri yoktur. Tam tersine, kod çürümesinin önüne geçmek için kodun gerektikçe serbestçe geliştirilmesi önerilir: "acımasızca geliştir" ("refactor mercilessly"). İşte bu yararlı yaklaşımın en güçlü silahı birim testleridir.
)

$(P
Birim testi, programı oluşturan en alt birimlerin birbirlerinden olabildiğince bağımsız olarak test edilmeleri anlamına gelir. Alt birimlerin bağımsız olarak testlerden geçmeleri, o birimlerin birlikte çalışmaları sırasında oluşacak hataların olasılığını büyük ölçüde azaltır. Eğer parçalar doğru çalışıyorsa, bütünün de doğru çalışma olasılığı artar.
)

$(P
Birim testleri başka bazı dillerde JUnit, CppUnit, Unittest++, vs. gibi kütüphane olanakları olarak gerçekleştirilmişlerdir. D'de ise birim testleri dilin iç olanakları arasındadır. Her iki yaklaşımın da üstün olduğu yanlar gösterilebilir. D birim testleri konusunda bazı kütüphanelerin sunduğu bazı olanakları içermez. Bu yüzden birim testleri için ayrı bir kütüphaneden yararlanmak da düşünülebilir.
)

$(P
D'de birim testleri, önceki bölümde gördüğümüz $(C assert) denetimlerinin $(C unittest) blokları içinde kullanılmalarından oluşurlar. Ben burada yalnızca D'nin bu iç olanağını göstereceğim.
)

$(H5 $(IX -unittest, derleyici seçeneği) Birim testlerini başlatmak)

$(P
Programın asıl işleyişi ile ilgili olmadıkları için, birim testlerinin yalnızca programın geliştirilmesi aşamasında çalıştırılmaları gerekir. Birim testleri derleyici veya geliştirme ortamı tarafından, ve ancak özellikle istendiğinde başlatılır.
)

$(P
Birim testlerinin nasıl başlatıldıkları kullanılan derleyiciye ve geliştirme ortamına göre değişir. Ben burada örnek olarak Digital Mars'ın derleyicisi olan $(C dmd)'nin $(C &#8209;unittest) seçeneğini göstereceğim.
)

$(P
Programın $(C deneme.d) isimli bir kaynak dosyaya yazıldığını varsayarsak komut satırına $(C &#8209;unittest) seçeneğini eklemek birim testlerini etkinleştirmek için yeterlidir:
)

$(SHELL
dmd deneme.d -w $(HILITE -unittest)
)

$(P
Bu şekilde oluşturulan program çalıştırıldığında önce birim testleri işletilir ve ancak onlar başarıyla tamamlanmışsa programın işleyişi $(C main) ile devam eder.
)

$(H5 $(IX unittest) $(C unittest) blokları)

$(P
Birim testlerini oluşturan kodlar bu blokların içine yazılır. Bu kodların programın normal işleyişi ile ilgileri yoktur; yalnızca programı ve özellikle işlevleri denemek için kullanılırlar:
)

---
unittest {
    /* ... birim testleri ve testler için gereken kodlar ... */
}
---

$(P
$(C unittest) bloklarını sanki işlev tanımlıyor gibi kendi başlarına yazabilirsiniz. Ama daha iyisi, bu blokları denetledikleri işlevlerin hemen altına yazmaktır.
)

$(P
Örnek olarak, bir önceki bölümde gördüğümüz ve kendisine verilen sayıya Türkçe ses uyumuna uygun olarak $(I da eki) döndüren işleve bakalım. Bu işlevin doğru çalışmasını denetlemek için, $(C unittest) bloğuna bu işlevin döndürmesini beklediğimiz koşullar yazarız:
)

---
dstring daEki(in int sayı) {
    // ...
}

$(HILITE unittest) {
    assert(daEki(1) == "de");
    assert(daEki(5) == "te");
    assert(daEki(9) == "da");
}
---

$(P
Oradaki üç koşul; 1, 5, ve 9 sayıları için sırasıyla "de", "te", ve "da" döndürüldüğünü denetler.
)

$(P
Her ne kadar testlerin temeli $(C assert) denetimleri olsa da, $(C unittest) bloklarının içinde her türlü D olanağını kullanabilirsiniz. Örneğin, bir dizgi içindeki belirli bir harfi o dizginin en başında olacak şekilde döndüren bir işlevin testleri şöyle yazılabilir:
)

---
dstring harfBaşa(dstring dizgi, in dchar harf) {
    // ...
}

unittest {
    immutable dizgi = "merhaba"d;

    assert(harfBaşa(dizgi, 'm') == "merhaba");
    assert(harfBaşa(dizgi, 'e') == "emrhaba");
    assert(harfBaşa(dizgi, 'a') == "aamerhb");
}
---

$(P
Oradaki üç $(C assert) denetimi $(C harfBaşa) işlevinin nasıl çalışmasının beklendiğini denetliyorlar.
)

$(P
Bu örneklerde görüldüğü gibi, birim testleri aynı zamanda işlevlerin belgeleri ve örnek kodları olarak da kullanışlıdırlar. Yalnızca birim testine bakarak işlevin kullanılışı hakkında hızlıca fikir edinebiliriz.
)

$(H5 $(IX assertThrown, std.exception) $(IX assertNotThrown, std.exception) Hata atılıp atılmadığının denetlenmesi)

$(P
Kodun belirli durumlar karşısında hata atıp atmadığının da denetlenmesi gerekebilir. $(C std.exception) modülü bu konuda yardımcı olan iki işlev içerir:
)

$(UL

$(LI $(C assertThrown): Belirli bir hata türünün atıldığını denetler)

$(LI $(C assertNotThrown): Belirli bir hata türünün atıl$(I ma)dığını denetler)

)

$(P
Örneğin, iki dilim parametresinin eşit uzunlukta olduğunu şart koşan ve boş dilimlerle de hatasız çalışması gereken bir işlev aşağıdaki gibi denetlenebilir:
)

---
import std.exception;

int[] ortalama(int[] a, int[] b) {
    // ...
}

unittest {
    /* Eşit uzunluklu olmayan dilimlerde hata atılmalıdır */
    assertThrown(ortalama([1], [1, 2]));

    /* Boş dilimlerde hata atılmamalıdır */
    assertNotThrown(ortalama([], []));
}
---

$(P
$(C assertThrown) normalde türüne bakmaksızın herhangi bir hatanın atıldığını denetler; gerektiğinde özel bir hata türünün atıldığını da denetleyebilir. Benzer biçimde, $(C assertNotThrown) da normalde hiçbir hatanın atılmadığını denetler ama gerektiğinde o da belirli bir hata türünün atılmadığını denetleyebilir. Özel hata türü bu işlevlere şablon parametresi olarak bildirilir:
)

---
    /* Eşit uzunluklu olmayan dilimlerde UzunlukHatası
     * atılmalıdır */
    assertThrown$(HILITE !UzunlukHatası)(ortalama([1], [1, 2]));

    /* Boş dilimlerde RangeError atılmamalıdır (yine de başka
     * türden hata atılabilir) */
    assertNotThrown$(HILITE !RangeError)(ortalama([], []));
---

$(P
Şablonları $(LINK2 /ders/d/sablonlar.html, ilerideki bir bölümde) göreceğiz.
)

$(P
Bu işlevlerin temel amacı kodu kısaltmak ve okunurluğu arttırmaktır. Yoksa, aşağıdaki $(C assertThrown) satırı aslında hemen altındaki uzun kodun eşdeğeridir:
)

---
    assertThrown(ortalama([1], [1, 2]));

// ...

    /* Yukarıdaki satırın eşdeğeri */
    {
        auto atıldı_mı = false;

        try {
            ortalama([1], [1, 2]);

        } catch (Exception hata) {
            atıldı_mı = true;
        }

        assert(atıldı_mı);
    }
---

$(H5 $(IX TDD) $(IX test yönelimli programlama) Test yönelimli programlama: $(I önce test, sonra kod))

$(P
Modern programcılık yöntemlerinden olan $(I test yönelimli programlama) ("test driven development" - TDD), birim testlerinin kod yazılmadan $(I önce) yazılmasını öngörür. Bu yöntemde asıl olan birim testleridir. Kodun yazılması, birim testlerinin başarıya ulaşmalarını sağlayan ikincil bir uğraştır.
)

$(P
Yukarıdaki $(C daEki) işlevine bu bakış açısıyla yaklaşarak onu önce birim testleriyle şöyle yazmamız gerekir:
)

---
dstring daEki(in int sayı) {
    return "bilerek hatalı";
}

unittest {
    assert(daEki(1) == "de");
    assert(daEki(5) == "te");
    assert(daEki(9) == "da");
}

void main() {
}
---

$(P
Her ne kadar o işlevin hatalı olduğu açık olsa da, önce programın birim testlerinin doğru olarak çalıştıklarını, yani beklendiği gibi hata attıklarını görmek isteriz:
)

$(SHELL
$ dmd deneme.d -w -O -unittest
$ ./deneme 
$(DARK_GRAY core.exception.AssertError@deneme(8): $(HILITE unittest failure))
)

$(P
İşlev ancak ondan sonra ve bu testleri geçecek şekilde yazılır:
)

---
$(CODE_NAME daEki)dstring daEki(in int sayı) {
    dstring ek;

    immutable sonHane = sayı % 10;

    final switch (sonHane) {

    case 1:
    case 2:
    case 7:
    case 8:
        ek = "de";
        break;

    case 3:
    case 4:
    case 5:
        ek = "te";
        break;

    case 6:
    case 9:
    case 0:
        ek = "da";
        break;
    }

    return ek;
}

unittest {
    assert(daEki(1) == "de");
    assert(daEki(5) == "te");
    assert(daEki(9) == "da");
}

void main() {
}
---

$(P
Artık program bu testleri geçer, ve bizim de $(C daEki) işlevi konusunda güvenimiz gelişir. Bu işlevde daha sonradan yapılacak olası geliştirmeler, $(C unittest) bloğuna yazdığımız koşulları korumak zorundadırlar. Böylelikle kodu geliştirmeye güvenle devam edebiliriz.
)

$(H5 Bazen de $(I önce hata, sonra test, ve en sonunda kod))

$(P
Birim testleri bütün durumları kapsayamazlar. Örneğin yukarıdaki testlerde üç farklı eki üreten üç sayı değeri seçilmiş, ve $(C daEki) işlevi bu üç testten geçtiği için başarılı kabul edilmiştir.
)

$(P
Bu yüzden, her ne kadar çok etkili yöntemler olsalar da, birim testleri bütün hataları yakalayamazlar ve bazı hatalar bazen son kullanıcılara kadar saklı kalabilir.
)

$(P
$(C daEki) işlevi için bunun örneğini $(C assert) bölümünün problemlerinde de görmüştük. O problemde olduğu gibi, bu işlev 50 gibi bir değer geldiğinde hatalıdır:
)

---
$(CODE_XREF daEki)import std.stdio;

void main() {
    writefln("%s'%s", 50, daEki(50));
}
---

$(P
Çıktısı:
)

$(SHELL
$ ./deneme
$(DARK_GRAY 50'da)
)

$(P
İşlev yalnızca son haneye baktığı için 50 için "de" yerine hatalı olarak "da" döndürmektedir.
)

$(P
Test yönelimli programlama işlevi hemen düzeltmek yerine öncelikle bu hatalı durumu yakalayan bir birim testinin eklenmesini önerir. Çünkü hatanın birim testlerinin gözünden kaçarak programın kullanımı sırasında ortaya çıkmış olması, birim testlerinin bir yetersizliği olarak görülür. Buna uygun olarak bu durumu yakalayan bir test örneğin şöyle yazılabilir:
)

---
unittest {
    assert(daEki(1) == "de");
    assert(daEki(5) == "te");
    assert(daEki(9) == "da");
    $(HILITE assert(daEki(50) == "de");)
}
---

$(P
Program bu sefer bu birim testi denetimi nedeniyle sonlanır:
)

$(SHELL
$ ./deneme 
$(DARK_GRAY core.exception.AssertError@deneme(39): unittest failure)
)

$(P
Artık bu hatalı durumu denetleyen bir test bulunduğu için, işlevde ileride yapılabilecek geliştirmelerin tekrardan böyle bir hataya neden olmasının önüne geçilmiş olur.
)

$(P
Kod ancak bu birim testi yazıldıktan sonra, ve o testi geçirmek için yazılır.
)

$(P $(I Not: Bu işlev, sonu "bin" ve "milyon" gibi okunarak biten başka sayılarla da sorunlu olduğu için burada kapsamlı bir çözüm bulmaya çalışmayacağım.)
)

$(PROBLEM_TEK

$(P
Yukarıda sözü geçen $(C harfBaşa) işlevini, birim testlerini geçecek şekilde gerçekleştirin:
)

---
dstring harfBaşa(dstring dizgi, in dchar harf) {
    dstring sonuç;
    return sonuç;
}

unittest {
    dstring dizgi = "merhaba"d;

    assert(harfBaşa(dizgi, 'm') == "merhaba");
    assert(harfBaşa(dizgi, 'e') == "emrhaba");
    assert(harfBaşa(dizgi, 'a') == "aamerhb");
}

void main() {
}
---

$(P
O tanımdan başlayın; ilk test yüzünden hata atıldığını görün; ve işlevi hatayı giderecek şekilde yazın.
)

)

Macros:
        SUBTITLE=Birim Testleri

        DESCRIPTION=D dilinin kod güvenilirliğini arttıran olanağı 'birim testleri' [unit tests]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial birim testi testler unit test unittest

SOZLER=
$(birim_testi)
$(blok)
$(derleyici)
$(ic_olanak)
$(ifade)
$(kutuphane)
