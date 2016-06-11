Ddoc

$(DERS_BOLUMU $(IX const) $(IX immutable) $(IX değişmezlik) Değişmezlik)

$(P
Değişkenlerin programla ilgili olan kavramları temsil ettiklerini gördük. Temsil ettikleri kavramlar arasındaki etkileşimleri bu değişkenlerin değerlerini değiştirerek sağlarız:
)

---
    // Parayı öde
    toplamFiyat = fiyatıHesapla(fiyatListesi);
    cüzdandakiMiktar $(HILITE -=) toplamFiyat;
    bakkaldakiMiktar $(HILITE +=) toplamFiyat;
---

$(P
Bu açıdan bakıldığında değişkenler olmadan olmaz; $(I değişebilme) kavramı programların iş yapabilmeleri için önemlidir. Buna rağmen, değişimin uygun olmadığı durumlar da vardır:
)

$(UL

$(LI Bazı kavramlar zaten $(I değişmezdirler). Örneğin haftadaki gün sayısı 7'dir, matematikteki $(I pi) (π) sabittir, bir programın desteklediği dil sayısı programın çalıştığı sürece değişmeyecektir (örneğin yalnızca Türkçe ve İngilizce'dir), vs.
)

$(LI Koddaki bütün işlemlerin her değişkeni değiştirebilecek kadar esnek olmaları, hangi işlemlerin hangi değişkenleri değiştirdiklerini fazla serbest bıraktığı için kodun okunması ve geliştirilmesi güçleşir.

$(P
Örneğin $(C emekliEt(banka, çalışan)) gibi bir işlev çağrısı sonucunda $(C çalışan)'ın $(C banka)'dan emekli edildiğini anlayabiliriz. Ancak, bu işlevden dönüldüğünde bu iki değişkenin değişip değişmeyeceklerini bilmek de önemlidir. Yoksa her işlev çağrısına şüpheyle bakmaya başlarız.
)

$(P
Herhalde $(C banka)'nın eleman sayısı azalacaktır; peki $(C çalışan) değişkeni de değişecek midir; örneğin bu işlev $(C çalışan) değişkeninin içindeki bir $(C enum) değişkeni de $(C ÇalışmaDurumu.emekli) olarak değiştirecek midir?
)

)

)

$(P
Bazı kavramların bazı işlemler sırasında değişmeyecekleri güvencesine gerek duyarız. Bazı başka dillerde bulunmayan bu $(I kesinlikle değişmezlik) kavramı hata çeşitlerinden bazılarının olasılığını düşüren yararlı bir olanaktır.
)

$(P
$(I Değişmezlik) kavramlarını belirleyen iki anahtar sözcüğün İngilizce'deki anlamları da birbirlerine çok yakındır: $(C const), "sabit, değişmez" anlamına gelen "constant"ın kısasıdır. $(C immutable) ise, "değişebilen" anlamına gelen "mutable"ın karşıt anlamlısıdır. İkisi de "değişmezlik" anlamını taşıyor olsalar da, $(C immutable) ve $(C const) sözcüklerinin görevleri farklıdır ve bazı durumlarda birbirleriyle uyumsuzdurlar.
)

$(P
$(IX tür nitelendirici) $(IX nitelendirici, tür) $(C const), $(C immutable), $(C inout), ve $(C shared) $(I tür nitelendiricisidirler). ($(LINK2 /ders/d/islev_parametreleri.html, $(C inout)) ve $(LINK2 /ders/d/es_zamanli_shared.html, $(C shared)) anahtar sözcüklerini ilerideki bölümlerde göreceğiz.)
)

$(H5 Değişmezler)

$(P
Her ne kadar kulağa anlamsız gelse de, bu başlık yerine "Değişmez değişken" de  düşünebilirdi. Böyle anlamsız ifadeler İngilizce kaynaklarda da bulunur: "constant variable" veya "immutable variable" da kulağa aynı derecede yanlış gelen terimlerdir.
)

$(P
Kesinlikle değişmeyecek olan değişkenler üç farklı biçimde tanımlanabilirler.
)

$(H6 $(IX enum) $(C enum) değişkenler)

$(P
Bazı sabit değişkenlerin $(C enum) olarak tanımlanabildiklerini $(LINK2 /ders/d/enum.html, $(C enum) bölümünde) görmüştük:
)

---
    enum dosyaİsmi = "liste.txt";
---

$(P
Derleme zamanında hesaplanabildikleri sürece $(C enum) değişkenler işlev çağrılarının sonuçları ile de ilklenebilirler:
)

---
int satırAdedi() {
    return 42;
}

int sütunAdedi() {
    return 7;
}

string isim() {
    return "liste";
}

void main() {
    enum dosyaİsmi = isim() ~ ".txt";
    enum toplamKare = satırAdedi() * sütunAdedi();
}
---

$(P
Derleyici $(C enum) değişkenlerin değiştirilmelerine izin vermez:
)

---
    ++toplamKare;    $(DERLEME_HATASI)
---

$(P
Değişmezlik kavramını sağlayan çok etkili bir olanak olmasına karşın $(C enum) ancak değerleri derleme zamanında bilinen veya hesaplanabilen sabitler için kullanılabilir.
)

$(P
Bekleneceği gibi, program derlenirken $(C enum) değişkenlerin yerlerine onların değerleri kullanılır. Örneğin, şöyle bir $(C enum) tanımı ve onu kullanan iki ifade olsun:
)

---
    enum i = 42;
    writeln(i);
    foo(i);
---

$(P
Yukarıdaki kod, $(C i)'nin yerine onun değeri olan $(C 42)'nin yazılmasının eşdeğeridir:
)

---
    writeln(42);
    foo(42);
---

$(P
Bir $(C enum) değişkenin yerine değerinin kullanılıyor olması $(C int) gibi basit türler için normal olarak kabul edilmelidir. Ancak, $(C enum) değişkenlerin dizi veya eşleme tablosu olarak kullanılmalarının gizli bir bedeli vardır:
)

---
    enum a = [ 42, 100 ];
    writeln(a);
    foo(a);
---

$(P
$(C a)'nın yerine değerini yerleştirdiğimizde derleyicinin derleyeceği asıl kodun aşağıdaki gibi olduğunu görürüz:
)

---
    writeln([ 42, 100 ]);    // bir dizi oluşturulur
    foo([ 42, 100 ]);        // başka bir dizi oluşturulur
---

$(P
Yukarıdaki koddaki gizli bedel, her ifade için farklı bir dizi oluşturuluyor olmasıdır. Bu yüzden, birden fazla yerde kullanılacak olan dizilerin ve eşleme tablolarının $(C immutable) değişkenler olarak tanımlanmaları çoğu duruma daha uygundur.
)

$(P
$(C enum) değişkenler işlev çağrılarının sonuçları ile de ilklenebilirler:
)

---
    enum a = diziYap();    // derleme zamanında çağrılır
---

$(P
Bu, D'nin $(I derleme zamanında işlev işletme (CTFE)) olanağı sayesindedir. Bu olanağı $(LINK2 /ders/d/islevler_diger.html, ilerideki bir bölümde) göreceğiz.
)


$(H6 $(IX değişken, immutable) $(C immutable) değişkenler)

$(P
Bu anahtar sözcük de programın çalışması sırasında değişkenin  $(I kesinlikle) değişmeyeceğini bildirir. $(C enum)'dan farklı olarak, $(C immutable) olarak işaretlenen değişkenlerin değerleri çalışma zamanında da hesaplanabilir.
)

$(P
Aşağıdaki program $(C enum) ve $(C immutable) anahtar sözcüklerinin kullanımlarının farklarını gösteriyor. Tuttuğu sayıyı kullanıcının tahmin etmesini bekleyen bu programda tutulan sayı derleme zamanında bilinemediği için $(C enum) olarak tanımlanamaz. Ancak, bir kere seçildikten sonra değerinin değişmesi istenmeyeceğinden ve hatta değişmesi bir hata olarak kabul edileceğinden bu değişkenin $(C immutable) olarak işaretlenmesi uygun olur.
)

$(P
Aşağıdaki program kullanıcının tahminini okurken yine bir önceki bölümde tanımladığımız $(C sayıOku) işlevinden yararlanıyor:
)

---
import std.stdio;
import std.random;

int sayıOku(string mesaj) {
    int sayı;
    write(mesaj, "? ");
    readf(" %s", &sayı);
    return sayı;
}

void main() {
    enum enAz = 1;
    enum enÇok = 10;

    $(HILITE immutable) sayı = uniform(enAz, enÇok + 1);

    writefln("%s ile %s arasında bir sayı tuttum.",
             enAz, enÇok);

    auto doğru_mu = false;
    while (!doğru_mu) {
        $(HILITE immutable) tahmin = sayıOku("Tahmininiz");
        doğru_mu = (tahmin == sayı);
    }

    writeln("Doğru!");
}
---

$(P
Gözlemler:
)

$(UL

$(LI $(C enAz)'ın ve $(C enÇok)'un değerleri programın derlenmesi sırasında bilindiklerinden ve bir anlamda bu programın davranışının değişmez parçaları olduklarından $(C enum) olarak tanımlanmışlardır.
)

$(LI Rasgele seçilmiş olan $(C sayı) değerinin ve kullanıcıdan okunan her $(C tahmin) değerinin programın işleyişi sırasında değişmeleri doğru olmayacağından onlar $(C immutable) olarak tanımlanmışlardır.
)

$(LI O değişkenlerin tanımları sırasında türlerinin açıkça belirtilmediğine dikkat edin. $(C auto)'da olduğu gibi, $(C enum) ve $(C immutable) anahtar sözcükleri de türün sağ tarafın değerinden çıkarsanması için yeterlidir.
)

)

$(P
Program içinde açıkça $(C immutable(int)) diye parantezle yazılması gerekmese de $(C immutable) türün bir parçasıdır. Aşağıdaki program üç farklı biçimde tanımlanmış olan değişkenlerin türlerinin tam isimlerinin aynı olduklarını gösteriyor:
)

---
import std.stdio;

void main() {
    immutable      çıkarsanarak = 0;
    immutable int  türüyle      = 1;
    immutable(int) tamOlarak    = 2;

    writeln(typeof(çıkarsanarak).stringof);
    writeln(typeof(türüyle).stringof);
    writeln(typeof(tamOlarak).stringof);
}
---

$(P
Üçünün de asıl tür ismi $(C immutable)'ı da içerir ve parantezlidir:
)

$(SHELL
immutable(int)
immutable(int)
immutable(int)
)

$(P
Parantezlerin içindeki tür önemlidir. Bunu aşağıda dilimin veya elemanlarının değişmezliği konusunda göreceğiz.
)

$(H6 $(IX değişken, const) $(C const) değişkenler)

$(P
Bu anahtar sözcüğün değişkenler üzerinde $(C immutable)'dan bir farkı yoktur. $(C const) değişkenler de değiştirilemezler:
)

---
    $(HILITE const) yarısı = toplam / 2;
    yarısı = 10;    $(DERLEME_HATASI)
---

$(P
Değişkenlerin değişmezliğini belirlerken $(C const) yerine $(C immutable) kullanmanızı öneririm çünkü $(C immutable) değişkenler, parametrenin özellikle $(C immutable) olmasını isteyen işlevlere de gönderilebilirler. Bunu aşağıda göreceğiz.
)

$(H5 Değişmez parametreler)

$(P
İşlevlerin parametrelerinde değişiklik yapmayacakları sözünü vermeleri ve derleyicinin bunu garanti etmesi programcılık açısından çok yararlıdır. Bunun nasıl sağlanacağına geçmeden önce dilim elemanlarının işlevler tarafından değiştirilebildiklerini görelim.
)

$(P
$(LINK2 /ders/d/dilimler.html, Başka Dizi Olanakları bölümünden) hatırlayacağınız gibi, dilimler kendi elemanlarına sahip değillerdir, o elemanlara yalnızca erişim sağlarlar. Belirli bir anda aynı elemana erişim sağlamakta olan birden fazla dilim bulunabilir.
)

$(P
Bu başlık altındaki örneklerde dilimlerden yararlanıyorum. Burada anlatılanlar eşleme tabloları için de geçerlidir çünkü onlar da $(I referans türleridir).
)

$(P
İşlev parametresi olan bir dilim, işlevin çağrıldığı yerdeki dilimin kendisi değil, bir kopyasıdır:
)

---
import std.stdio;

void main() {
    int[] dilim = [ 10, 20, 30, 40 ];  // 1
    yarıla(dilim);
    writeln(dilim);
}

void yarıla(int[] sayılar) {           // 2
    foreach (ref sayı; sayılar) {
        sayı /= 2;
    }
}
---

$(P
Yukarıdaki $(C yarıla) işlevinin işletildiği sırada aynı dört elemana erişim sağlamakta olan iki farklı dilim vardır:
)

$(OL

$(LI $(C main)'in içinde tanımlanmış olan ve $(C yarıla)'ya parametre olarak gönderilen $(C dilim) isimli dilim
)

$(LI $(C yarıla)'nın parametre değeri olarak almış olduğu ve $(C main)'deki dilimle aynı dört elemana erişim sağlamakta olan $(C sayılar) isimli dilim
)

)

$(P
$(C foreach) döngüsünde $(C ref) anahtar sözcüğü de kullanılmış olduğundan o dört elemanın değerleri yarılanmış olur:
)

$(SHELL
[5, 10, 15, 20]
)

$(P
Bu örnekte de görüldüğü gibi, $(C yarıla) gibi işlevlerin kendilerine gönderilen dilimlerin elemanlarını değiştirebilmeleri kullanışlıdır çünkü zaten elemanları değiştirmek için yazılmışlardır.
)

$(P
Derleyici, $(C immutable) değişkenlerin böyle işlevlere gönderilmelerine izin vermez:
)

---
    $(HILITE immutable) int[] dilim = [ 10, 20, 30, 40 ];
    yarıla(dilim);    $(DERLEME_HATASI)
---

$(P
Derleme hatası, $(C immutable(int[])) türündeki bir değişkenin $(C int[]) türündeki bir parametre değeri olarak kullanılamayacağını bildirir:
)

$(SHELL
Error: function deneme.yarıla ($(HILITE int[]) sayılar) is not callable
using argument types ($(HILITE immutable(int[])))
)

$(H6 $(IX parametre, const) $(C const) parametreler)

$(P
$(C immutable) değişkenlerin $(C yarıla)'da olduğu gibi parametrelerinde değişiklik yapan işlevlere gönderilmelerinin engellenmesi önemlidir. Ancak, parametrelerinde değişiklik yapmayan ve hatta yapmaması gereken başka işlevlere gönderilememeleri büyük bir kısıtlama olarak görülmelidir:
)

---
import std.stdio;

void main() {
    immutable int[] dilim = [ 10, 20, 30, 40 ];
    yazdır(dilim);    $(DERLEME_HATASI)
}

void yazdır(int[] dilim) {
    writefln("%s eleman: ", dilim.length);

    foreach (i, eleman; dilim) {
        writefln("%s: %s", i, eleman);
    }
}
---

$(P
Elemanların değiştirilemiyor olmaları onların yazdırılmalarına engel olmamalıdır. $(C const) parametreler bu konuda yararlıdırlar.
)

$(P
$(C const) anahtar sözcüğü bir değişkenin $(I belirli bir referans) (örneğin dilim) yoluyla değiştirilmeyeceğini belirler. Parametreyi $(C const) olarak işaretlemek, o dilimin elemanlarının işlev içerisinde değiştirilemeyeceğini garanti eder. Böyle bir garanti sağlandığı için program artık derlenir:
)

---
    yazdır(dilim);    // şimdi derlenir
// ...
void yazdır($(HILITE const) int[] dilim)
---

$(P
İşlev nasıl olsa değiştirmeyeceğine söz vermiş olduğundan, hem $(I değişebilen) değişkenler hem de $(C immutable) değişkenler işlevlere $(C const) parametreler olarak gönderilebilirler:
)

---
    immutable int[] dilim = [ 10, 20, 30, 40 ];
    yazdır(dilim);               // şimdi derlenir

    int[] değişebilenDilim = [ 7, 8 ];
    yazdır(değişebilenDilim);    // bu satır da derlenir
---

$(P
İşlev tarafından değiştirilmediği halde $(C const) olarak tanımlanmayan bir parametre işlevin kullanışlılığını düşürür. Ek olarak, işlev parametrelerinin $(C const) olarak işaretlenmeleri programcı açısından yararlı bir bilgidir. Değişkenin belirli bir kapsam içinde değişmeyecek olduğunu bilmek kodun anlaşılmasını kolaylaştırır. Olası hataları da önler: Değişmeyecek olduğu düşünüldüğü için $(C const) olarak tanımlanmış olan bir değişkeni sonradan değiştirmeye çalışmaya derleyici izin vermez:
)

---
void yazdır($(HILITE const) int[] dilim) {
    dilim[0] = 42;    $(DERLEME_HATASI)
---

$(P
O durumda programcı ya yanlışlığı farkeder ya da tasarımı gözden geçirerek $(C const)'ın kaldırılması gerektiğine karar verir.
)

$(P
$(C const) parametrelerin hem değişebilen hem de $(C immutable) değişkenleri kabul edebilmelerinin ilginç bir etkisi vardır. Bunu aşağıdaki "$(C const) parametre mi, $(C immutable) parametre mi?" başlığı altında göreceğiz.
)

$(H6 $(IX parametre, immutable) $(C immutable) parametreler)

$(P
$(C const) parametre yerine kullanılan asıl değişkenin $(I değişebilen) veya $(C immutable) olabildiğini gördük. $(C const) parametreler bu anlamda esneklik getirirler.
)

$(P
Parametrenin $(C immutable) olarak işaretlenmesi ise asıl değişkenin de kesinlikle $(C immutable) olması şartını getirir. Bu açıdan bakıldığında $(C immutable) parametreler işlevin çağrıldığı nokta üzerinde kuvvetli bir talepte bulunmaktadırlar:
)

---
void birİşlem($(HILITE immutable) int[] dilim) {
    // ...
}

void main() {
    immutable int[] değişmezDilim = [ 1, 2 ];
    int[] değişebilenDilim = [ 8, 9 ];

    birİşlem(değişmezDilim);       // bu derlenir
    birİşlem(değişebilenDilim);    $(DERLEME_HATASI)
}
---

$(P
O yüzden $(C immutable) parametreleri ancak gerçekten gereken durumlarda düşünmenizi öneririm. Şimdiye kadar öğrendiklerimiz arasında $(C immutable) parametreler yalnızca dizgi türlerinde üstü kapalı olarak geçerler. Bunu biraz aşağıda göstereceğim.
)

$(P
$(C const) veya $(C immutable) olarak işaretlenmiş olan parametrelerin, işlevin çağrıldığı yerdeki asıl değişkeni değiştirmeme sözü verdiklerini gördük. Bu konu yalnızca referans türünden olan değişkenlerle ilgilidir.
)

$(P
Referans ve değer türlerini bir sonraki bölümde daha ayrıntılı olarak göreceğiz. Bu bölüme kadar gördüğümüz türler arasında dilimler ve eşleme tabloları referans türleri, diğerleri ise değer türleridir.
)

$(H6 $(IX parametre, const veya immutable) $(C const) parametre mi, $(C immutable) parametre mi?)

$(P
Yukarıdaki iki başlığa bakıldığında esneklik getirdiği için $(C const) belirtecinin yeğlenmesinin doğru olacağı sonucuna varılabilir. Bu her zaman doğru değildir.
)

$(P
$(C const) belirteci asıl değişkenin $(I değişebilen) mi yoksa $(C immutable) mı olduğu bilgisini işlev içerisinde belirsiz hale getirir. Bunu derleyici de bilemez.
)

$(P
Bunun bir etkisi, $(C const) parametrelerin $(C immutable) parametre alan başka işlevlere doğrudan gönderilemeyecekleridir. Örneğin, aşağıdaki koddaki $(C foo) işlevi $(C const) parametresini $(C bar)'a gönderemez:
)

---
void main() {
    /* Asıl değişken immutable */
    immutable int[] dilim = [ 10, 20, 30, 40 ];
    foo(dilim);
}

/* Daha kullanışlı olabilmek için parametresini const olarak
 * alan bir işlev. */
void foo(const int[] dilim) {
    bar(dilim);    $(DERLEME_HATASI)
}

/* Parametresini belki de geçerli bir nedenle immutable olarak
 * alan bir işlev. */
void bar(immutable int[] dilim) {
    // ...
}
---

$(P
$(C bar), parametresinin $(C immutable) olmasını şart koşmaktadır. Öte yandan, $(C foo)'nun $(C const) parametresi olan $(C dilim)'in aslında $(C immutable) bir değişkene mi yoksa değişebilen bir değişkene mi bağlı olduğu bilinemez.
)

$(P
$(I Not: Yukarıdaki kullanıma bakıldığında $(C main) içindeki asıl değişkenin $(C immutable) olduğu açıktır. Buna rağmen, derleyici her işlevi ayrı ayrı derlediği için $(C foo)'nun $(C const) parametresinin aslında $(C immutable) olduğunu bilmesi olanaksızdır. Derleyicinin gözünde $(C dilim) değişebilen de olabilir $(C immutable) da.
)
)

$(P
Böyle bir durumda bir çözüm, $(C bar)'ı parametrenin değişmez bir kopyası ile çağırmaktır:
)

---
void foo(const int[] dilim) {
    bar(dilim$(HILITE .idup));
}
---

$(P
Kod artık derlenebiliyor olsa da asıl değişkenin zaten $(C immutable) olduğu durumda bile kopyasının alınıyor olması gereksizdir.
)

$(P
Bütün bunlara bakıldığında belki de $(C foo)'nun parametresini $(C const) olarak almasının her zaman için doğru olmadığı düşünülebilir. Çünkü parametresini baştan $(C immutable) olarak seçmiş olsa kod kopyaya gerek kalmadan derlenebilir:
)

---
void foo(immutable int[] dilim) {  // Bu sefer immutable
    bar(dilim);    // Artık kopya gerekmez
}
---

$(P
Ancak, bir üstteki başlıkta belirtildiği gibi, asıl değişkenin $(C immutable) olmadığı durumlarda $(C foo)'nun çağrılabilmesi için bu sefer de $(C .idup) ile kopyalanması gerekecekti:
)

---
    foo(değişebilenDilim$(HILITE .idup));
---

$(P
Görüldüğü gibi, değişmeyecek olan parametrenin türünün $(C const) veya $(C immutable) olarak belirlenmesinin kararı kolay değildir.
)

$(P
İleride göreceğimiz şablonlar bu konuda da yararlı olabilirler. Aşağıdaki kodları kitabın bu aşamasında anlamanızı beklemesem de parametrenin $(C const) veya $(C immutable) olması kararını ortadan kaldırdığını belirtmek istiyorum. Aşağıdaki $(C foo) hem $(I değişebilen) hem de $(C immutable) değişkenlerle çağrılabilir ve yalnızca asıl değişken $(I değişebilen) olduğunda kopya bedeli öder:
)

---
import std.conv;
// ...

/* Şablon olduğu için hem değişebilen hem de immutable
 * değişkenlerle çağrılabilir. */
void foo(T)(T[] dilim) {
    /* Asıl değişken zaten immutable olduğunda 'to' ile
     * kopyalamanın bedeli yoktur. */
    bar(to!(immutable T[])(dilim));
}
---

$(H5 Bütün dilime karşılık elemanlarının değişmezliği)

$(P
$(C immutable) bir dilimin türünün $(C .stringof) ile $(C immutable(int[])) olarak yazdırıldığını yukarıda gördük. $(C immutable)'dan sonra kullanılan parantezlerden anlaşılabileceği gibi, değişmez olan dilimin bütünüdür; o dilimde hiçbir değişiklik yapılamaz. Örneğin dilime eleman eklenemez, dilimden eleman çıkartılamaz, var olan elemanların değerleri değiştirilemez, veya dilimin başka elemanları göstermesi sağlanamaz:
)

---
    immutable int[] değişmezDilim = [ 1, 2 ];
    değişmezDilim ~= 3;                    $(DERLEME_HATASI)
    değişmezDilim[0] = 3;                  $(DERLEME_HATASI)
    değişmezDilim.length = 1;              $(DERLEME_HATASI)

    immutable int[] değişmezBaşkaDilim = [ 10, 11 ];
    değişmezDilim = değişmezBaşkaDilim;    $(DERLEME_HATASI)
---

$(P
Değişmezliğin bu derece ileri götürülmesi bazı durumlara uygun değildir. Çoğu durumda önemli olan, yalnızca elemanların değiştirilmeyecekleri güvencesidir. Dilim nasıl olsa elemanlara erişim sağlayan bir olanak olduğundan o elemanlar değiştirilmedikleri sürece dilimin kendisinde oluşan değişiklikler bazı durumlarda önemli değildir.
)

$(P
Bir dilimin yalnızca elemanlarının değişmeyeceği, $(C immutable)'dan sonraki parantezin yalnızca elemanın türünü içermesi ile sağlanır. Yukarıdaki kod buna uygun olarak değiştirilirse artık yalnızca elemanı değiştiren satır derlenemez; dilimin kendisi değiştirilebilir:
)

---
    immutable$(HILITE (int))[] değişmezDilim = [ 1, 2 ];
    değişmezDilim ~= 3;                    // şimdi derlenir
    değişmezDilim[0] = 3;                  $(DERLEME_HATASI)
    değişmezDilim.length = 1;              // şimdi derlenir

    immutable int[] değişmezBaşkaDilim = [ 10, 11 ];
    değişmezDilim = değişmezBaşkaDilim;    // şimdi derlenir
---

$(P
Birbirlerine çok yakın olan bu söz dizimlerini şöyle karşılaştırabiliriz:
)

---
    immutable int[]  a = [1]; /* Ne elemanları ne kendisi
                                 değiştirilebilen dilim */

    immutable(int[]) b = [1]; /* Üsttekiyle aynı anlam */

    immutable(int)[] c = [1]; /* Elemanları değiştirilemeyen
                                 ama kendisi değiştirilebilen
                                 dilim */
---

$(P
Daha önceki bölümlerde bu konuyla üstü kapalı olarak karşılaştık. Hatırlarsanız, dizgi türlerinin asıl türlerinin $(C immutable) olduklarından bahsetmiştik:
)

$(UL
$(LI $(C string), $(C immutable(char)[])'ın takma ismidir)
$(LI $(C wstring), $(C immutable(wchar)[])'ın takma ismidir)
$(LI $(C dstring), $(C immutable(dchar)[])'ın takma ismidir)
)

$(P
Benzer şekilde, dizgi hazır değerleri de değişmezdirler:
)

$(UL
$(LI $(STRING "merhaba"c) hazır dizgisinin türü $(C string)'dir)
$(LI $(STRING "merhaba"w) hazır dizgisinin türü $(C wstring)'dir)
$(LI $(STRING "merhaba"d) hazır dizgisinin türü $(C dstring)'dir)
)

$(P
Bunlara bakarak D dizgilerinin normalde $(I değiştirilemeyen karakterlerden) oluştuklarını söyleyebiliriz.
)

$(H6 $(IX değişmezlik, geçişli) $(C const) ve $(C immutable) geçişlidir)

$(P
Yukarıdaki $(C a) ve $(C b) dilimlerinin kod açıklamalarında da değinildiği gibi, o dilimlerin ne kendileri ne de elemanları değiştirilebilir.
)

$(P
Bu, ilerideki bölümlerde göreceğimiz $(LINK2 /ders/d/yapilar.html, yapılar) ve $(LINK2 /ders/d/siniflar.html, sınıflar) için de geçerlidir. Örneğin, $(C const) olan bir yapı değişkeninin bütün üyeleri de $(C const)'tır ve $(C immutable) olan bir yapı değişkeninin bütün üyeleri de $(C immutable)'dır. (Aynısı sınıflar için de geçerlidir.)
)

$(H6 $(IX .dup) $(IX .idup) $(C .dup) ve $(C .idup))

$(P
Karakterleri değişmez olduklarından dizgiler işlevlere parametre olarak geçirilirken uyumsuz durumlarla karşılaşılabilir. Bu durumlarda dizilerin $(C .dup) ve $(C .idup) nitelikleri yararlıdır:
)

$(UL
$(LI $(C .dup) dizinin değişebilen bir kopyasını oluşturur; ismi, "kopyasını al" anlamındaki "duplicate"ten gelir)
$(LI $(C .idup) dizinin değişmez bir kopyasını oluşturur; ismi "immutable duplicate"ten gelir)
)

$(P
Örneğin, parametresinin programın çalışması süresince kesinlikle değişmeyecek olmasını isteyen ve bu yüzden onu $(C immutable) olarak belirlemiş olan bir işlevi $(C .idup) ile alınan bir kopya ile çağırmak gerekebilir:
)

---
void foo($(HILITE string) dizgi) {
    // ...
}

void main() {
    char[] selam;
    foo(selam);                $(DERLEME_HATASI)
    foo(selam$(HILITE .idup));           // ← derlenir
}
---


$(H5 Nasıl kullanmalı)

$(UL

$(LI
Genel bir kural olarak, olabildiği kadar değişmezliği yeğleyin.
)

$(LI
Değişken tanımlarken, programın çalışması sırasında kesinlikle değişmeyecek olan ve değerleri derleme zamanında bilinen veya hesaplanabilen değerleri $(C enum) olarak tanımlayın. Örneğin, dakikadaki saniye sayısı değişmez:

---
    enum int dakikaBaşınaSaniye = 60;
---

$(P
Türün sağ taraftan çıkarsanabildiği durumlarda değişkenin türü belirtilmeyebilir:
)

---
    enum dakikaBaşınaSaniye = 60;
---

)

$(LI
$(C enum) dizisi ve $(C enum) eşleme tablosu kullanmanın gizli bedelini göz önünde bulundurun. Fazla büyük olduklarında ve programda birden fazla yerde kullanıldıklarında onları $(C immutable) değişkenler olarak tanımlayın.
)

$(LI
Kesinlikle değişmeyecek olan ama değerleri derleme zamanında bilinmeyen veya hesaplanamayan değişkenleri $(C immutable) olarak tanımlayın. Türün belirtilmesi yine isteğe bağlıdır:

---
    immutable tahmin = sayıOku("Tahmininiz");
---

)

$(LI
Parametre tanımlarken, eğer işlev parametrede bir değişiklik yapmayacaksa parametreyi $(C const) olarak tanımlayın. Öyle yaptığınızda parametreyi değiştirmeme sözü verdiğiniz için $(I değişebilen) ve $(C immutable) değişkenleri o işleve gönderebilirsiniz:

---
void foo(const char[] dizgi) {
    // ...
}

void main() {
    char[] değişebilenDizgi;
    string immutableDizgi;

    foo(değişebilenDizgi);  // ← derlenir
    foo(immutableDizgi);    // ← derlenir
}
---

)

$(LI
Bir üstteki maddeyi uyguladığınızda, $(C const) olarak aldığınız parametreyi $(C immutable) alan işlevlere gönderemeyeceğinizi unutmayın. Bu konunun ayrıntılarını yukarıdaki "$(C const) parametre mi, $(C immutable) parametre mi?" başlığında gördük.
)

$(LI
Eğer parametrede bir değişiklik yapacaksanız o parametreyi değişebilen şekilde tanımlayın ($(C const) veya $(C immutable) olarak tanımlansa zaten derleyici izin vermez):

---
import std.stdio;

void tersÇevir(dchar[] dizgi) {
    foreach (i; 0 .. dizgi.length / 2) {
        immutable geçici = dizgi[i];
        dizgi[i] = dizgi[$ - 1 - i];
        dizgi[$ - 1 - i] = geçici;
    }
}

void main() {
    dchar[] selam = "merhaba"d.dup;
    tersÇevir(selam);
    writeln(selam);
}
---

$(P
Çıktısı:
)

$(SHELL
abahrem
)

)

)

$(H5 Özet)

$(UL

$(LI $(C enum) değişkenler, değerleri derleme zamanında bilinen ve kesinlikle değişmeyecek olan kavramları temsil ederler.)

$(LI $(C immutable) değişkenler, değerleri derleme zamanında bilinemeyen ama kesinlikle değişmeyecek olan kavramları temsil ederler.)

$(LI $(C const) parametreler, işlevin değiştirmeyeceği parametrelerdir. Hem $(I değişebilen) hem de $(C immutable) değişkenler o parametrenin değeri olarak kullanılabilirler.)

$(LI $(C immutable) parametreler, işlevin özellikle $(C immutable) olmasını talep ettiği parametrelerdir. İşlev çağrılırken bu parametrelere karşılık yalnızca $(C immutable) değişkenler gönderilebilir.)

$(LI $(C immutable(int[])), dilimin de elemanlarının da değişmez olduklarını belirler.)

$(LI $(C immutable(int)[]), yalnızca elemanların değişmez olduklarını belirler.)

)

Macros:
        SUBTITLE=Değişmezlik

        DESCRIPTION=D dilinde değişmezlik kavramlarıyla ilgili olan const ve immutable anahtar sözcüklerinin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial const immutable sabit değişmez

SOZLER=
$(degisken)
$(degismez)
$(islev)
$(kapsam)
$(parametre)
$(sabit)
$(takma_isim)
$(tur_nitelendirici)
