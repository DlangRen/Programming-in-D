Ddoc

$(DERS_BOLUMU $(IX işlev) İşlevler)

$(P
İşlevler $(I gerçek) programların temel taşlarıdır. Nasıl temel türler, bütün türlerin yapı taşları iseler, işlevler de program davranışlarının yapı taşlarıdır.
)

$(P
İşlevlerin ustalıkla da ilgisi vardır. Usta programcıların yazdıkları işlevler kısa ve öz olur. Bunun tersi de doğrudur: kısa ve öz işlevler yazmaya çalışmak, ustalık yolunda ilerlemenin önemli adımlarındandır. İşlemleri oluşturan alt adımları görmeye çalışmak ve o adımları küçük işlevler halinde yazmak, programcılık konusunda gelişmenize yardım edecektir.
)

$(P
Bundan önceki bölümlerde temel deyimler ve ifadeler öğrendik. Daha hepsini bitirmedik ama D'nin programlarda çok kullanılan, çok yararlı, ve çok önemli olanaklarını gördük. Yine de, hiçbirisi büyük programlar yazmak için yeterli değildir. Şimdiye kadar yazdığımız biçimdeki programlar, deneme programları gibi hiçbir karmaşıklığı olmayan çok basit programlar olabilirler. En ufak bir karmaşıklığı bulunan bir işi işlev kullanmadan yazmaya çalışmak çok zordur, ve ortaya çıkan program da hataya açık olur.
)

$(P
İşlevler, ifade ve deyimleri bir araya getiren olanaklardır. Bir araya getirilen ifade ve deyimlere toplu olarak yeni bir isim verilir ve o işlemlerin hepsi birden bu isimle işletilir.
)

$(P
$(I Bir araya getirerek yeni isim verme) kavramını günlük hayattan tanıyoruz. Örneğin $(I yağda yumurta yapma) işini şu adımlarla tarif edebiliriz:
)

$(UL
$(LI tavayı çıkart)
$(LI yağı çıkart)
$(LI yumurtayı çıkart)
$(LI ateşi aç)
$(LI tavayı ateşe koy)
$(LI tava ısınınca yağı içine at)
$(LI yağ eriyince yumurtayı içine kır)
$(LI yumurtanın beyazı pişince tavayı ateşten al)
$(LI ateşi söndür)
)

$(P
O kadar ayrıntıya girmek zamanla gereksiz ve içinden çıkılmaz bir hâl alacağı için, birbiriyle ilişkili adımların bazılarına tek bir isim verilebilir:
)

$(UL
$(LI $(HILITE malzemeleri hazırla) (tavayı, yağı, yumurtayı çıkart))
$(LI ateşi aç)
$(LI $(HILITE yumurtayı pişir) (tavayı ateşe koy, vs.))
$(LI ateşi söndür)
)

$(P
Daha sonra daha da ileri gidilebilir ve bütün o adımları içeren tek bir ifade de kullanılabilir:
)

$(UL
$(LI $(HILITE yağda yumurta yap) (bütün adımlar))
)

$(P
İşlevlerin bundan farkı yoktur: Yaptıkları işlerin hepsine birden genel bir isim verilebilen adımlar tek bir işlev olarak tanımlanırlar. Örnek olarak kullanıcıya bir menü gösteren şu satırlara bakalım:
)

---
    writeln(" 0 Çıkış");
    writeln(" 1 Toplama");
    writeln(" 2 Çıkarma");
    writeln(" 3 Çarpma");
    writeln(" 4 Bölme");
---

$(P
Onların hepsine birden $(C menüyüGöster) gibi bir isim verilebileceği için onları bir işlev olarak şu şekilde bir araya getirebiliriz:
)

---
$(CODE_NAME menüyüGöster)void menüyüGöster() {
    writeln(" 0 Çıkış");
    writeln(" 1 Toplama");
    writeln(" 2 Çıkarma");
    writeln(" 3 Çarpma");
    writeln(" 4 Bölme");
}
---

$(P
Artık o işlevi $(C main) içinden kısaca ismiyle işletebiliriz:
)

---
$(CODE_XREF menüyüGöster)import std.stdio;

void main() {
    menüyüGöster();

    // ... diğer işlemler ...
}
---

$(P
$(C menüyüGöster) ile $(C main)'in tanımlarındaki benzerliğe bakarak $(C main)'in de bir işlev olduğunu görebilirsiniz. İsmi İngilizce'de "ana işlev" kullanımındaki "ana" anlamına gelen $(C main), D programlarının ana işlevidir. D programlarının işleyişi bu işlevle başlar ve programcının istediği şekilde başka işlevlere dallanır.
)

$(H5 $(IX parametre) Parametreler)

$(P
İşlevlerin güçlü yanlarından birisi, yaptıkları işlerin belirli ölçüde ayarlanabiliyor olmasından gelir.
)

$(P
Yine yumurta örneğine dönelim, ve bu sefer beş yumurta yapmak isteyelim. İzlenmesi gereken adımlar aslında bu durumda da aynıdır; tek farkları, yumurta sayısındadır. Daha önce dörde indirgediğimiz adımları beş yumurtaya uygun olarak şöyle değiştirebiliriz:
)

$(UL
$(LI $(HILITE beş yumurtalık) malzeme hazırla)
$(LI ateşi aç)
$(LI yumurta$(HILITE lar)ı pişir)
$(LI ateşi söndür)
)

$(P
Teke indirgediğimiz adım da şöyle değişir:
)

$(UL
$(LI yağda $(HILITE beş) yumurta yap)
)

$(P
Temelde aynı olan yumurta pişirme işiyle ilgili bir bilgi ek olarak belirtilmektedir: "beş yumurta çıkart" veya "beş yumurta yap" gibi.
)

$(P
$(IX , (virgül), işlev parametre listesi) İşlevlerin davranışları da benzer şekilde ayarlanabilir. İşlevlerin işlerini bu şekilde etkileyen bilgilere $(I parametre) denir. Parametreler, parametre listesinde virgüllerle ayrılarak bildirilirler. Parametre listesi, işlevin isminden hemen sonra yazılan parantezin içidir.
)

$(P
Daha önceki $(C menüyüGöster) işlevinde parametre parantezini boş olarak tanımlamıştık çünkü o işlev her zaman için aynı menüyü göstermekteydi. Menüdeki ilk seçeneğin hep "Çıkış" olması yerine, duruma göre değişen bir seçenek olmasını istesek, bunu bir parametreyle sağlayabiliriz. Örneğin ilk seçeneği bazı durumlarda "Geri Dön" olarak yazdırmak için bu bilgiyi bir parametre olarak tanımlayabiliriz:
)

---
void menüyüGöster($(HILITE string ilkSeçenek)) {
    writeln(" 0 ", ilkSeçenek);
    writeln(" 1 Toplama");
    writeln(" 2 Çıkarma");
    writeln(" 3 Çarpma");
    writeln(" 4 Bölme");
}
---

$(P
$(C ilkSeçenek) parametresi bu örnekte bir dizgi olduğu için türünü de $(C string) olarak belirledik. Bu işlevi artık değişik dizgilerle işleterek menünün ilk satırının farklı olmasını sağlayabiliriz. Tek yapmamız gereken, parametre değerini parantez içinde belirtmektir:
)

---
    menüyüGöster("Çıkış");
    menüyüGöster("Geri Dön");
---

$(P
Not: Burada parametrenin türüyle ilgili bir sorunla karşılaşabilirsiniz: Bu işlev yukarıda yazıldığı haliyle $(C char[]) türünde dizgilerle kullanılamaz. Örneğin, $(C char[]) ve $(C string) uyumlu olmadıklarından aşağıdaki kod derleme hatasına neden olur:
)

---
    char[] birSeçenek;
    birSeçenek ~= "Kare Kök Al";
    menüyüGöster(birSeçenek);   $(DERLEME_HATASI)
---

$(P
Öte yandan, $(C menüyüGöster)'in tanımında parametrenin türünü $(C char[]) olarak belirlediğinizde de işlevi $(STRING "Çıkış") gibi bir $(C string) değeriyle çağıramazsınız. $(C immutable) ile ilgili olan bu konuyu bir sonraki bölümde göreceğiz.
)

$(P
Biraz daha ileri gidelim ve seçenek numaralarının hep 0 ile değil, duruma göre değişik bir değerle başlamasını istiyor olalım. Bu durumda başlangıç numarasını da parametre olarak verebiliriz. Parametreler virgüllerle ayrılırlar:
)

---
void menüyüGöster(string ilkSeçenek$(HILITE, int ilkNumara)) {
    writeln(' ', ilkNumara, ' ', ilkSeçenek);
    writeln(' ', ilkNumara + 1, " Toplama");
    writeln(' ', ilkNumara + 2, " Çıkarma");
    writeln(' ', ilkNumara + 3, " Çarpma");
    writeln(' ', ilkNumara + 4, " Bölme");
}
---

$(P
O işleve hangi numarayla başlayacağını artık biz bildirebiliriz:
)

---
    menüyüGöster("Geri Dön"$(HILITE , 1));
---

$(H5 İşlev çağırmak)

$(P
İşlevin işini yapması için başlatılmasına işlevin $(I çağrılması) denir. İşlev çağrısının söz dizimi şöyledir:
)

---
    $(I işlevin_ismi)($(I parametre_değerleri))
---

$(P
$(IX parametre değeri) İşini yaparken kullanması için işleve verilen bilgilere $(I parametre değeri) denir. Parametre değerleri işlevin tanımındaki parametrelerle bire bir eşleşirler. Örneğin, yukarıdaki $(C menüyüGöster()) işlev çağrısındaki $(C "Geri Dön") ve $(C 1) değerleri sırayla $(C ilkSeçenek) ve $(C ilkNumara) parametrelerine karşılık gelirler.
)

$(P
Her parametre değerinin türü, karşılık geldiği parametrenin türüne uymalıdır.
)

$(H5 İş yapmak)

$(P
Hem daha önceki bölümlerde hem de bu bölümde $(I iş yapmaktan) söz ettim. Program adımlarının, ifadelerin, işlevlerin, $(I iş yaptıklarını) söyledim. İş yapmak, yan etki oluşturmak veya değer üretmek anlamına gelir:
)

$(UL

$(LI
$(IX yan etki) $(B Yan etki oluşturmak): Bazı işlemlerin yalnızca yan etkileri vardır. Örneğin çıkışa menü yazdıran $(C menüyüGöster) işlevi çıkışı $(I etkilemektedir); oluşturduğu bir değer yoktur. Başka bir örnek olarak, kendisine verilen bir $(C Öğrenci) nesnesini bir öğrenciler listesine ekleyen bir işlevin etkisi, listenin büyümesidir. Onun da ürettiği bir değer yoktur.

$(P
Genel olarak, programın durumunda bir değişikliğe neden olan bir işlemin yan etkisinin olduğu söylenir.
)

)

$(LI
$(B Değer üretmek): Bazı işlemler yalnızca değer üretirler. Örneğin toplama işleminin sonucunu veren bir işlev, toplanan değerlerin toplamını $(I üretir). Başka bir örnek olarak; isim, adres, vs. gibi kendisine verilen bilgiyi bir araya getirerek bir $(C Öğrenci) nesnesi oluşturan bir işlevin de bir nesne $(I ürettiği) söylenir.

$(P
Bu tür işlemlerin ayrıca yan etkileri yoktur; programın durumunda hiçbir değişikliğe neden olmazlar; yalnızca değer üretirler.
)

)

$(LI
$(B Hem değer üretmek, hem yan etki oluşturmak:) Bazı işlemler hem değer üretirler, hem de yan etkileri vardır. Örneğin girişten okuduğu sayıların toplamını hesaplayan bir işlev, hem toplamın sonucunu üretmektedir; hem de içinden karakterler çıkarttığı için girişi etkilemektedir.
)

$(LI
$(B Etkisizlik:) Her işlevin normalde yukarıdaki üç gruptan birisine girdiğini söyleyebiliriz: değer üretirler veya yan etkileri vardır. Buna rağmen, bazı işlevler bazı koşullara bağlı olarak bazen hiç iş yapmayabilirler.
)

)

$(H5 $(IX dönüş değeri) İşlevin dönüş değeri)

$(P
Değer üreten bir işlevin ürettiği değere o işlevin $(I dönüş değeri) denir. Bu terim, işlevin işini bitirdikten sonra bize geri dönmesi gibi bir düşünceden türemiştir. İşlevi "çağırırız" ve "döndürdüğü" değeri kullanırız.
)

$(P
Her değerin olduğu gibi, dönüş değerinin de türü vardır. Bu tür işlevin isminden önce yazılır. Örneğin iki tane $(C int) değeri toplayan bir işlev, eğer sonuçta yine $(C int) türünde bir değer üretiyorsa, dönüş türü olarak $(C int) yazılır:
)

---
$(HILITE int) topla(int birinci, int ikinci) {
    // ...  yapılan işlemler ...
}
---

$(P
İşlevin döndürdüğü değer, sanki o değer işlev çağrısının yerine yazılmış gibi, onun yerine geçer. Örneğin $(C topla(5, 7)) çağrısının değer olarak 12 ürettiğini düşünürsek, şu iki satır birbirinin eşdeğeridir:
)

---
    writeln("Toplam: ", topla(5, 7));
    writeln("Toplam: ", 12);
---

$(P
$(C writeln) çağrılmadan önce, $(C topla(5, 7)) işlevi çağrılır ve onun döndürdüğü değer olan 12, yazdırması için $(C writeln)'e parametre olarak verilir.
)

$(P
Bu sayede işlevlerin değerlerini başka işlevlere parametre olarak verebilir ve daha karmaşık ifadeler oluşturabiliriz:
)

---
    writeln("Sonuç: ", topla(5, böl(100, kişiSayısı())));
---

$(P
O örnekte $(C kişiSayısı)'nın dönüş değeri $(C böl)'e, $(C böl)'ün dönüş değeri $(C topla)'ya, ve en sonunda da $(C topla)'nın dönüş değeri $(C writeln)'e parametre olarak verilmektedir.
)

$(H5 $(IX return, deyim) $(C return) deyimi)

$(P
İşlevin ürettiği değer, "döndür" anlamına gelen $(C return) anahtar sözcüğü ile bildirilir:
)

---
int topla(int birinci, int ikinci) {
    int toplam = birinci + ikinci;
    $(HILITE return) toplam;
}
---

$(P
İşlev, gereken işlemleri ve hesapları yaparak dönüş değerini üretir ve en son olarak $(C return) ile döndürür. İşlevin işleyişi de o noktada sona erer ve işlevden dönülmüş olur.
)

$(P
İşlevlerde birden fazla $(C return) anahtar sözcüğü kullanılabilir. İfade ve deyimlere bağlı olarak önce hangi $(C return) işletilirse, işlevin dönüş değeri olarak o $(C return)'ün döndürdüğü değer kullanılır:
)

---
int karmaşıkHesap(int birParametre, int başkaParametre) {
    if (birParametre == başkaParametre) {
        return 0;
    }

    return birParametre * başkaParametre;
}
---

$(P
O işlev; iki parametresi birbirlerine eşitse 0 değerini, değilse iki parametrenin çarpımını döndürür.
)

$(H5 $(IX void, işlev) $(C void) işlevler)

$(P
Eğer işlev değer üretmeyen bir işlevse, dönüş türü olarak "boşluk, yokluk" anlamına gelen $(C void) yazılır. O yüzden $(C main)'in ve $(C menüyüGöster)'in dönüş türlerini $(C void) olarak yazdık; şimdiye kadar gördüğümüz kadarıyla ikisi de değer üretmeyen işlevlerdir.
)

$(P
$(I Not: $(C main) aslında $(C int) de döndürebilir. Bunu $(LINK2 /ders/d/main.html, sonraki bir bölümde) göreceğiz.
)
)

$(H5 İşlevin ismi)

$(P
İşlevin ismi, programcı tarafından işlevin yaptığı işi açıklayacak şekilde seçilmelidir. Örneğin iki sayıyı toplayan işlevin ismini $(C topla) olarak seçtik; veya menüyü gösteren işleve $(C menüyüGöster) dedik.
)

$(P
İşlevlere isim verirken izlenen bir kural, isimleri $(C topla)'da ve $(C menüyüGöster)'de olduğu gibi ikinci tekil şahıs emir kipinde seçmektir. Yani $(C toplam)'da ve $(C menü)'de olduğu gibi isim halinde değil. Böylece işlevin bir eylemde bulunduğu isminden anlaşılır.
)

$(P
Öte yandan hiçbir yan etkileri olmayan, yani yalnızca değer üreten işlevlere içinde eylem bulunmayan isimler de seçilebilir. Örneğin şu andaki hava sıcaklığını veren bir işlev için $(C havaSıcaklığınıVer) yerine $(C havaSıcaklığı) gibi bir ismin daha uygun olduğunu düşünebilirsiniz.
)

$(P
İşlev, nesne, değişken, vs. isim seçimlerinin programcılığın $(I sanat) tarafında kaldığını düşünebilirsiniz. İşe yarar, yeterince kısa, ve programdaki diğer isimlerle tutarlı olan isimler bulmak bazen yaratıcılık gerektirir.
)

$(H5 İşlevlerin kod kalitesine etkileri)

$(P
İşlevlerin kod kalitesine etkileri büyüktür. İşlevlerin küçük olmaları ve sorumluluklarının az olması programların bakımlarını kolaylaştırır.
)

$(P
Programı bir bütün halinde $(C main) içinde yazmak yerine küçük parçalara ayırmak bütün programı kolaylaştırır. Küçük işlevlerin birim olarak işlemleri de basit olacağından, teker teker yazılmaları çok daha kolay olur. Programın diğer işlemleri bu yapı taşları üzerine kurulunca bütün program daha kolay yazılır. Daha da önemlisi, programda daha sonradan gereken değişiklikler de çok daha kolay hale gelirler.
)

$(H6 $(IX kod tekrarı) Kod tekrarından kaçının)

$(P
Programcılıkta kaçınılması gereken bir eylem, kod tekrarıdır. Kod tekrarı, aynı işi yapan işlemlerin programda birden fazla yerde tekrarlanması anlamına gelir.
)

$(P
Bu tekrar bazen bilinçli olarak satırların bir yerden başka bir yere kopyalanması ile yapılabilir. Bazen de farkında olmadan, aynı işlemlerin aynı şekilde kodlanmaları şeklinde ortaya çıkabilir.
)

$(P
Kod tekrarının sakıncalarından birisi; tekrarlanan işlemlerdeki olası hataların bütün kopyalarda da bulunması, ve aynı hatanın her kopyada giderilmesinin gerekmesidir. Oysa; tekrarlanan kod tek bir işlev içinde bulunuyor olsa, hatayı yalnızca bir kere gidermek yeter.
)

$(P
Yukarıda işlevlerin ustalıkla ilgili olduklarına değinmiştim. Usta programcılar koddaki işlemler arasındaki benzerlikleri yakalamaya ve kod tekrarını ortadan kaldırmaya çalışırlar.
)

$(P
Bir örnek olarak, girişten aldığı sayıları önce girişten geldikleri sırada, sonra da sıralanmış olarak yazdıran şu programa bakalım:
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] sayılar;

    int adet;
    write("Kaç sayı gireceksiniz? ");
    readf(" %s", &adet);

    // Sayıları oku
    foreach (i; 0 .. adet) {
        int sayı;
        write("Sayı ", i, "? ");
        readf(" %s", &sayı);

        sayılar ~= sayı;
    }

    // Diziyi çıkışa yazdır
    writeln("Sıralamadan önce:");
    foreach (i, sayı; sayılar) {
        writefln("%3d:%5d", i, sayı);
    }

    sort(sayılar);

    // Diziyi çıkışa yazdır
    writeln("Sıraladıktan sonra:");
    foreach (i, sayı; sayılar) {
        writefln("%3d:%5d", i, sayı);
    }
}
---

$(P
Kod tekrarını görüyor musunuz? Diziyi yazdırmak için kullanılan son iki $(C foreach) döngüsü birbirinin aynısı. $(C yazdır) ismiyle bir işlev tanımlasak ve yazdırmasını istediğimiz diziyi de parametre olarak versek, bu kod tekrarını ortadan kaldırmış oluruz:
)

---
void yazdır(int[] dizi) {
    foreach (i, eleman; dizi) {
        writefln("%3s:%5s", i, eleman);
    }
}
---

$(P
Dikkat ederseniz, parametrenin ismi olarak $(C sayılar) yerine ondan daha genel olan $(C dizi) ismini seçtik. Bunun nedeni, bu işlev bağlamında dizi yazdırmak dışında bir şey bilmiyor olduğumuzdur. Dizinin elemanlarının ne olduklarından bu işlev içinde haberimiz yoktur. Dizideki $(C int) elemanların ne anlama geldiklerini ancak bu işlevi çağıran kapsam bilir: belki öğrenci kayıt numaralarıdır, belki bir şifrenin parçalarıdır, belki bir grup insanın yaşlarıdır... Ne olduklarını $(C yazdır) işlevi içinde bilemediğimiz için, ancak $(C dizi) ve $(C eleman) gibi genel isimler kullanabiliyoruz.
)

$(P
Şimdi kod biraz daha düzenli bir hale gelir:
)

---
import std.stdio;
import std.algorithm;

void yazdır(int[] dizi) {
    foreach (i, eleman; dizi) {
        writefln("%3s:%5s", i, eleman);
    }
}

void main() {
    int[] sayılar;

    int adet;
    write("Kaç sayı gireceksiniz? ");
    readf(" %s", &adet);

    // Sayıları oku
    foreach (i; 0 .. adet) {
        int sayı;
        write("Sayı ", i, "? ");
        readf(" %s", &sayı);

        sayılar ~= sayı;
    }

    // Diziyi çıkışa yazdır
    writeln("Sıralamadan önce:");
    $(HILITE yazdır(sayılar));

    sort(sayılar);

    // Diziyi çıkışa yazdır
    writeln("Sıraladıktan sonra:");
    $(HILITE yazdır(sayılar));
}
---

$(P
İşimiz bitmedi: iki $(C yazdır) çağrısından önce birer de başlık yazdırılıyor. Yazdırılan dizgi farklı olsa da işlem aynıdır. Eğer başlığı da $(C yazdır)'a parametre olarak verirsek, başlığı yazdırma tekrarından da kurtulmuş oluruz. Programın yalnızca değişen bölümlerini gösteriyorum:
)

---
void yazdır($(HILITE string başlık, )int[] dizi) {
    writeln(başlık, ":");

    foreach (i, eleman; dizi) {
        writefln("%3s:%5s", i, eleman);
    }
}

// ...

    // Diziyi çıkışa yazdır
    yazdır("Sıralamadan önce", sayılar);

// ...

    // Diziyi çıkışa yazdır
    yazdır("Sıraladıktan sonra", sayılar);
---

$(P
Bu işlemin $(C yazdır)'dan önceki açıklama satırlarını da gereksiz hale getirdiğini görebiliriz. İşlemlere $(C yazdır) diye açıklayıcı bir isim verdiğimiz için, ayrıca "Diziyi çıkışa yazdır" gibi bir açıklamaya da gerek kalmamış oluyor. Şimdi programın son satırları şöyle kısaltılabilir:
)

---
    yazdır("Sıralamadan önce", sayılar);
    sort(sayılar);
    yazdır("Sıraladıktan sonra", sayılar);
---

$(P
Bu programda bir kod tekrarı daha var: girişten $(C adet) ve $(C sayı) için aynı şekilde tamsayı okunuyor. Tek farkları, kullanıcıya gösterilen mesaj ve değişkenin ismi:
)

---
    int adet;
    write("Kaç sayı gireceksiniz? ");
    readf(" %s", &adet);

// ...

        int sayı;
        write("Sayı ", i, "? ");
        readf(" %s", &sayı);
---

$(P
$(C sayıOku) diye bir işlev yazarsak ve kullanıcıya gösterilecek mesajı bir parametre olarak alırsak, kod çok daha temiz bir hale gelir. Bu sefer bu işlevin girişten okuduğu değeri döndürmesi gerektiğine dikkat edin:
)

---
int sayıOku(string mesaj) {
    int sayı;
    write(mesaj, "? ");
    readf(" %s", &sayı);
    return sayı;
}
---

$(P
Bu işlevi çağırarak $(C adet)'in değerini okumak kolay. $(C adet)'i işlevin dönüş değeriyle ilkleyebiliriz:
)

---
    int adet = sayıOku("Kaç sayı gireceksiniz");
---

$(P
$(C sayı)'yı okurken kullanılan mesaj döngü sayacı olan $(C i)'yi de içerdiğinden o mesaj $(C std.string) modülündeki $(C format)'tan yararlanılarak her $(C i) için farklı olarak oluşturulabilir:
)

---
import std.string;
// ...
        int sayı = sayıOku(format("Sayı %s", i));
---

$(P
$(C sayı)'nın $(C foreach) içinde tek bir yerde kullanıldığını görerek $(C sayı)'nın tanımını da tamamen kaldırabilir ve onun kullanıldığı tek yerde doğrudan $(C sayıOku) işlevini çağırabiliriz. Böylece döngü içindeki satırlar da azalmış olur:
)

---
    foreach (i; 0 .. adet) {
        sayılar ~= $(HILITE sayıOku)(format("Sayı %s", i));
    }
---

$(P
Ben bu programda son bir değişiklik daha yapacağım ve sayıların okunmasıyla ilgili bütün işlemleri tek bir işleve taşıyacağım. Böylece "Sayıları oku" açıklaması da ortadan kalkacak; çünkü yeni işlevin ismi zaten ne işlem yapılmakta olduğunu açıklayacak.
)

$(P
$(C sayılarıOku) ismini verebileceğimiz bu işlevin hiçbir parametre alması gerekmez, ama değer olarak bütün diziyi üretirse ismi ile de uyumlu bir kullanımı olur.)

$(P
Böylece bütün program son olarak şöyle yazılabilir:
)

---
import std.stdio;
import std.string;
import std.algorithm;

void yazdır(string başlık, int[] dizi) {
    writeln(başlık, ":");

    foreach (i, eleman; dizi) {
        writefln("%3s:%5s", i, eleman);
    }
}

int sayıOku(string mesaj) {
    int sayı;
    write(mesaj, "? ");
    readf(" %s", &sayı);
    return sayı;
}

int[] $(HILITE sayılarıOku)() {
    int[] sayılar;

    int adet = sayıOku("Kaç sayı gireceksiniz");

    foreach (i; 0 .. adet) {
        sayılar ~= sayıOku(format("Sayı %s", i));
    }

    return sayılar;
}

void main() {
    int[] sayılar = sayılarıOku();
    yazdır("Sıralamadan önce", sayılar);
    sort(sayılar);
    yazdır("Sıraladıktan sonra", sayılar);
}
---

$(P
Programın bu halini ilk haliyle karşılaştırın. Yeni programda $(C main) işlevi içinde programın ana adımları açık bir şekilde anlaşılmaktadır. Oysa ilk halinde programın ne yaptığını ancak kodları ve açıklamaları okuyarak anlamak zorunda kalıyorduk.
)

$(P
Programın son halinde daha fazla satır bulunuyor olması sizi yanıltmasın. İşlevler aslında kodu küçültürler, ama bunu çok kısa olan bu programda göremiyoruz. Örneğin $(C sayıOku) işlevini yazmadan önce girişten tamsayı okumak için her seferinde 3 satır kod yazıyorduk. Şimdi ise $(C sayıOku)'yu çağırarak her noktadaki kod satırı sayısını 1'e indirmiş olduk. Hatta, $(C foreach) döngüsü içindeki $(C sayı)'nın tanımını da tamamen kaldırabildik.
)

$(H6 Açıklamalı kod satırlarını işlevlere dönüştürün)

$(P
Eğer programdaki işlemlerin bazılarının ne yaptıklarını açıklama satırları yazarak açıklama gereği duyuyorsanız, belki de o işlemlerin bir işleve taşınmaları zamanı gelmiştir. İşlevin ismini açıklayıcı olarak seçmek, açıklama satırının gereğini de ortadan kaldırır.
)

$(P
Yukarıdaki programdaki üç açıklama satırından bu sayede kurtulmuş olduk.
)

$(P
Açıklama satırlarından kurtulmanın önemli başka bir nedeni daha vardır: açıklama satırları zaman içinde kodun ne yaptığı hakkında yanlış bilgi vermeye başlarlar. Baştan iyi niyetle ve doğru olarak yazılan açıklama satırı, kod değiştiğinde unutulur ve zamanla koddan ilgisiz hale gelebilir. Artık açıklama satırı ya yanlış bilgi veriyordur, ya da tamamen işe yaramaz durumdadır. Bu yüzden programları açıklama satırlarına gerek bırakmadan yazmaya çalışmak önemlidir.
)

$(PROBLEM_COK

$(PROBLEM $(C menüyüGöster) işlevini bütün seçeneklerini bir dizi olarak alacak şekilde değiştirin. Örneğin şu şekilde çağırabilelim:

---
    string[] seçenekler =
        [ "Siyah", "Kırmızı", "Yeşil", "Mavi", "Beyaz" ];
    menüyüGöster(seçenekler, 1);
---

$(P
Çıktısı şöyle olsun:
)

$(SHELL &nbsp;1 Siyah
 2 Kırmızı
 3 Yeşil
 4 Mavi
 5 Beyaz
)

)

$(PROBLEM
İki boyutlu bir diziyi bir resim kağıdı gibi kullanan bir program yazdım. Siz bu programı istediğiniz şekilde değiştirin:

---
import std.stdio;

enum satırAdedi = 20;
enum sütunAdedi = 60;

/* alias, "takma isim" anlamına gelir. Programın geri
 * kalanında hep dchar[sütunAdedi] yazmak yerine, daha
 * açıklayıcı olarak 'Satır' yazabilmemizi sağlıyor.
 *
 * Dikkat ederseniz Satır "sabit uzunluklu dizi" türüdür. */
alias Satır = dchar[sütunAdedi];

/* Bir Satır dilimine de kısaca 'Kağıt' takma ismini
 * veriyoruz. */
alias Kağıt = Satır[];

/* Verilen kağıdı satır satır ve kare kare çıkışa gönderir. */
void kağıdıGöster(Kağıt kağıt) {
    foreach (satır; kağıt) {
        writeln(satır);
    }
}

/* Verilen kağıdın belirtilen yerine bir benek koyar; bir
 * anlamda o kareyi "boyar". */
void benekKoy(Kağıt kağıt, int satır, int sütun) {
    kağıt[satır][sütun] = '#';
}

/* Kağıdın belirtilen yerinden aşağıya doğru, belirtilen
 * uzunlukta çizgi çizer. */
void düşeyÇizgiÇiz(Kağıt kağıt, int satır,
                   int sütun, int uzunluk) {
    foreach (çizilecekSatır; satır .. satır + uzunluk) {
        benekKoy(kağıt, çizilecekSatır, sütun);
    }
}

void main() {
    Satır boşSatır = '.';

    /* Hiç satırı bulunmayan bir kağıt */
    Kağıt kağıt;

    /* Ona boş satırlar ekliyoruz */
    foreach (i; 0 .. satırAdedi) {
        kağıt ~= boşSatır;
    }

    /* Ve kullanmaya başlıyoruz */
    benekKoy(kağıt, 7, 30);
    düşeyÇizgiÇiz(kağıt, 5, 10, 4);

    kağıdıGöster(kağıt);
}
---

)

)

Macros:
        SUBTITLE=İşlevler

        DESCRIPTION=D dilinde işlevler (fonksiyonlar) [functions]

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial işlev fonksiyon function

SOZLER=
$(deger)
$(degisken)
$(degismez)
$(deyim)
$(dizgi)
$(donus_degeri)
$(ifade)
$(islev)
$(nesne)
$(parametre)
$(parametre_degeri)
$(yan_etki)
