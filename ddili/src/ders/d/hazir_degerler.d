Ddoc

$(DERS_BOLUMU $(IX hazır değer) Hazır Değerler)

$(P
Programlar işlerini değişkenlerin ve nesnelerin değerlerini kullanarak yaparlar. Değişkenleri ve nesneleri işleçlerle ve işlevlerle kullanarak yeni değerler üretirler ve yeni nesneler oluştururlar.
)

$(P
Bazı değerlerin ise hesaplanmaları gerekmez; onlar kaynak kod içine doğrudan hazır olarak yazılırlar. Örneğin şu kod parçasındaki işlemler sırasında kullanılan $(C 0.75) kesirli sayı değeri ve $(C "Toplam fiyat: ") sabit dizgisi kod içine programcı tarafından hazır olarak yazılmıştır:
)

---
    öğrenciFiyatı = biletFiyatı * 0.75;
    fiyat += öğrenciSayısı * öğrenciFiyatı;
    writeln("Toplam fiyat: ", fiyat);
---

$(P
Bu tür değerlere $(I hazır değer) denir. Şimdiye kadar gördüğümüz programlarda zaten çok sayıda hazır değer kullandık. Bu bölümde hazır değerlerin bütün çeşitlerini ve söz dizimlerini göreceğiz.
)

$(H5 Tamsayılar)

$(P
Tamsayıları dört değişik sayı sisteminde yazabilirsiniz: Günlük hayatımızda kullandığımız $(I onlu) sayı sisteminde, bazı durumlarda daha uygun olan $(I on altılı) veya $(I ikili) sayı sistemlerinde, ve nadir olarak $(I sekizli) sayı sisteminde.
)

$(P
Bütün tamsayı değerlerinin rakamlarının aralarına, istediğiniz sayıda, istediğiniz yerlerine, ve herhangi amaçla; örneğin okumayı kolaylaştırmak için $(C _) karakterleri yerleştirebilirsiniz. Örneğin, rakamları üçer üçer ayırmak için: $(C 1_234_567). Bu karakterler tamamen programcının isteğine bağlıdır ve derleyici tarafından gözardı edilirler.
)

$(P $(B Onlu sayı sisteminde:) Günlük hayatımızda kullandığımız gibi, onlu rakamlarla yazılır. Örnek: $(C 12). Onlu değerlerin ilk rakamı 0 olamaz. Bunun nedeni, 0 ile başlayan hazır değerlerin çoğu başka dilde sekizli sayı sistemine ayrılmış olmasıdır. Bu konudaki karışıklıklardan doğabilecek olan hataları önlemek için D'de tamsayı hazır değerleri 0 ile başlayamaz.
)

$(P $(B On altılı sayı sisteminde:) $(C 0x) veya $(C 0X) ile başlayarak ve on altılı sayı sisteminin rakamları olan "0123456789abcdef" ve "ABCDEF" ile yazılır. Örnek: $(C 0x12ab00fe).
)

$(P $(B Sekizli sayı sisteminde:) $(C std.conv) modülündeki $(C octal) ile ve sekizli sayı sisteminin rakamları olan "01234567" ile yazılır. Örnek: $(C octal!576).
)

$(P $(B İkili sayı sisteminde:) $(C 0b) veya $(C 0B) ile başlayarak ve ikili sayı sisteminin rakamları olan 0 ve 1 ile yazılır. Örnek: $(C 0b01100011).
)

$(H6 Tamsayı değerlerin türleri)

$(P
Her değerin olduğu gibi, D'de hazır değerlerin de türleri vardır. Hazır değerlerin türleri $(C int), $(C double), vs. gibi açıkça yazılmaz; derleyici, türü hazır değerin yazımından anlar.
)

$(P
Hazır değerlerin türlerinin aslında programcı açısından çok büyük bir önemi yoktur. Bazen tür, hazır değerin içinde kullanıldığı ifadeye uymayabilir ve derleyici uyarı verir. Öyle durumlarda aşağıdaki bilgilerden yararlanarak hazır değerin türünü açıkça belirtmeniz gerekebilir.
)

$(P
Tamsayı hazır değerlerin öncelikle $(C int) türünde oldukları varsayılır. Eğer değer bir $(C int)'e sığmayacak kadar büyükse, derleyici şu şekilde karar verir:
)

$(UL
$(LI $(C int)'e sığmayacak kadar büyük olan değer onlu sistemde yazılmışsa, $(C long)'dur
)

$(LI $(C int)'e sığmayacak kadar büyük olan değer başka bir sayı sisteminde yazılmışsa, öncelikle $(C uint)'tir, ona da sığmıyorsa $(C long)'dur, ona da sığmıyorsa $(C ulong)'dur
)
)

$(P
Bunu görmek için daha önce öğrendiğimiz $(C typeof)'tan ve $(C stringof)'tan yararlanan şu programı kullanabiliriz:
)

---
import std.stdio;

void main() {
    writeln("\n--- bunlar onlu olarak yazıldılar ---");

    // int'e sığdığı için int
    writeln(       2_147_483_647, "\t\t",
            typeof(2_147_483_647).stringof);

    // int'e sığmadığı ve onlu olarak yazıldığı için long
    writeln(       2_147_483_648, "\t\t",
            typeof(2_147_483_648).stringof);

    writeln("\n--- bunlar onlu olarak yazılMAdılar ---");

    // int'e sığdığı için int
    writeln(       0x7FFF_FFFF, "\t\t",
            typeof(0x7FFF_FFFF).stringof);

    // int'e sığmadığı ve onlu olarak yazılmadığı için uint
    writeln(       0x8000_0000, "\t\t",
            typeof(0x8000_0000).stringof);

    // uint'e sığmadığı ve onlu olarak yazılmadığı için long
    writeln(       0x1_0000_0000, "\t\t",
            typeof(0x1_0000_0000).stringof);

    // long'a sığmadığı ve onlu olarak yazılmadığı için ulong
    writeln(       0x8000_0000_0000_0000, "\t\t",
            typeof(0x8000_0000_0000_0000).stringof);
}
---

$(P
Çıktısı:
)

$(SHELL
--- bunlar onlu olarak yazıldılar ---
2147483647              int
2147483648              long

--- bunlar onlu olarak yazılMAdılar ---
2147483647              int
2147483648              uint
4294967296              long
9223372036854775808             ulong
)

$(H6 $(IX L, son ek) $(C L) son eki)

$(P
Değerin büyüklüğünden bağımsız olarak, eğer değerin sonunda bir $(C L) karakteri varsa, türü $(C long)'dur. Örnek: $(C 10L).
)

$(H6 $(IX U, son ek) $(C U) son eki)

$(P
Değerin büyüklüğünden bağımsız olarak, eğer değerin sonunda bir $(C U) karakteri varsa, işaretsiz bir türdür. Örnek: $(C 10U)'nun türü $(C uint)'tir. Küçük harf $(C u) da kullanılabilir.
)

$(P
$(IX LU, son ek) $(IX UL, son ek) $(C L) ve $(C U) karakterleri birlikte ve sıralarının önemi olmadan da kullanılabilirler. Örneğin $(C 7UL)'nin ve $(C 8LU)'nun ikisinin de türleri $(C ulong)'dur.
)

$(H5 Kesirli sayılar)

$(P
Kesirli sayılar onlu sayı sisteminde veya on altılı sayı sisteminde yazılabilirler. Örneğin onlu olarak $(C 1.234) veya on altılı olarak $(C 0x9a.bc).
)

$(P $(B Onlu sayı sisteminde:) Sayının yanına, $(C e) veya $(C E) belirtecinden sonra "çarpı 10 üzeri" anlamına gelen bir çarpan eklenebilir. Örneğin $(C 3.4e5), "3.4 çarpı 10 üzeri 5" anlamındadır. Bu belirteçten sonra bir $(C +) karakteri de yazılabilir ama onun bir etkisi yoktur. Örneğin, $(C 5.6e2) ile $(C 5.6e+2) aynı anlamdadır.
)

$(P
Belirteçten sonra gelen $(C -) karakterinin etkisi vardır ve "10 üzeri o kadar değere bölünecek" anlamına gelir. Örneğin $(C 7.8e-3), "7.8 bölü 10 üzeri 3" anlamındadır.
)

$(P $(B On altılı sayı sisteminde:) Sayı $(C 0x) veya $(C 0X) ile başlar; noktadan önceki ve sonraki bölümleri on altılı sayı sisteminin rakamlarıyla yazılır. $(C e) ve $(C E) de on altılı sistemde geçerli rakamlar olduklarından, üs belirteci olarak başka bir harf kullanılır: $(C p) (veya $(C P)).
)

$(P
Başka bir fark, bu belirteçten sonra gelen değerin "10 üzeri" değil, "2 üzeri" anlamına gelmesidir. Örneğin $(C 0xabc.defP4)'ün sonundaki belirteç, "2 üzeri 4 ile çarpılacak" anlamına gelir.
)

$(P
Kesirli sayı değerler hemen hemen her zaman için bir nokta içerirler, ama belirteç varsa noktaya gerek yoktur. Örneğin $(C 2e3), 2000 değerinde bir kesirli sayıdır.
)

$(P
Noktadan önceki değer $(C 0) ise yazılmayabilir. Örneğin $(C .25), "çeyrek" anlamında bir kesirli sayı değeridir.
)

$(P
Gözardı edilen $(C _) karakterlerini kesirli sayılarla da kullanabilirsiniz: $(C 1_000.5)
)

$(H6 Kesirli sayı değerlerin türleri)

$(P
Kesirli değerler özellikle belirtilmemişse $(C double) türündedir. Sonlarına $(C f) veya $(C F) eklenirse, $(C float); $(C L) eklenirse $(C real) olurlar. Örneğin $(C 1.2) $(C double)'dır, $(C 3.4f) $(C float)'tur, ve $(C 5.6L) $(C real)'dir.
)

$(H5 Karakterler)

$(P
Karakter türündeki hazır değerler her zaman için tek tırnaklar arasında yazılırlar. Örneğin $(C 'a'), $(C '\n'), $(C '\x21').
)

$(P $(B Karakterin kendisi olarak:) Tek tırnaklar arasına karakterin kendisi klavyeden yazılabilir veya başka bir metinden kopyalanabilir: $(C 'a'), $(C 'ş'), vs.
)

$(P $(IX kontrol karakteri) $(B Kontrol karakteri olarak:) Ters bölü işaretinden sonra bir karakter belirteci kullanılabilir. Örneğin ters bölü karakterinin kendisi $(C '\\') şeklinde yazılır. Kontrol karakterleri şunlardır:
)

<table class="full" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">&nbsp;Yazımı&nbsp;</th> <th scope="col">Anlamı</th>
</tr>
<tr align="center"><td>\'</td>
    <td>tek tırnak</td>
</tr>
<tr align="center"><td>\"</td>
    <td>çift tırnak</td>
</tr>
<tr align="center"><td>\?</td>
    <td>soru işareti</td>
</tr>
<tr align="center"><td>\\</td>
    <td>ters bölü</td>
</tr>
<tr align="center"><td>\a</td>
    <td>uyarı karakteri (bazı ortamlarda zil sesi)</td>
</tr>
<tr align="center"><td>\b</td>
    <td>silme karakteri</td>
 </tr>
<tr align="center"><td>\f</td>
    <td>sayfa sonu</td>
 </tr>
<tr align="center"><td>\n</td>
    <td>satır sonu</td>
 </tr>
<tr align="center"><td>\r</td>
    <td>aynı satırın başına götürür</td>
 </tr>
<tr align="center"><td>\t</td>
    <td>bir sonraki sekme adımına götürür</td>
 </tr>
<tr align="center"><td>\v</td>
    <td>bir sonraki düşey sekme adımına götürür</td>
 </tr>
</table>

$(P $(B Genişletilmiş ASCII karakter kodu olarak:) Karakterleri doğrudan kodları ile belirtebilirsiniz. Yukarıda tamsayılar başlığında anlatılanlara uygun olarak, kodu $(C \x) ile başlayan 2 haneli on altılı sayı olarak veya $(C \) ile başlayan 3 haneye kadar sekizli sayı olarak yazabilirsiniz. Örneğin $(C '\x21') ve $(C '\41') ünlem işareti karakterinin iki farklı yazımıdır.
)

$(P $(B Unicode karakter kodu olarak:) $(C u) karakterinden sonra 4 on altılı rakam olarak yazılırsa türü $(C wchar) olur; $(C U) karakterinden sonra 8 on altılı rakam olarak yazılırsa türü $(C dchar) olur. Örneğin $(C '\u011e') ve $(C '\U0000011e') Ğ karakterinin sırasıyla $(C wchar) ve $(C dchar) türünde olan değeridir.
)

$(P $(B İsimli karakter olarak:) İsimleri olan karakterleri isimleriyle ve $(C '\&$(I karakter_ismi);') söz dizimiyle yazabilirsiniz. D, $(LINK2 http://dlang.org/entity.html, HTML 5 karakter isimlerinin hepsini destekler). Örneğin $(C '\&amp;euro;') €, $(C '\&amp;hearts;') ♥, ve $(C '\&amp;copy;') de © karakteridir.
)

 $(H5 $(IX dizgi hazır değeri) $(IX hazır değer, dizgi) Dizgiler)

$(P
Hazır dizgiler sabit karakterlerin bileşimlerinden oluşurlar ve çok sayıda farklı söz dizimiyle yazılabilirler.
)

$(H6 Çift tırnaklar arasında yazılan dizgiler)

$(P
Dizgilerin başka dillerde de bulunan en yaygın yazımı, çift tırnaklar arasında yazılmalarıdır: örneğin $(C "merhaba"). Bu şekilde yazıldığında, içindeki karakterler yukarıdaki karakter yazımlarına uygun olarak yazılırlar. Örneğin, göstermek amacıyla yukarıdaki karakter sabitlerinden bazılarını içeren $(C "A4&nbsp;ka\u011fıt:&nbsp;3\&amp;frac12;TL") dizgisi, $(C "A4&nbsp;kağıt:&nbsp;3½TL")nin eşdeğeridir.
)

$(H6 $(IX göründüğü gibi dizgi) $(IX dizgi, göründüğü gibi) $(IX `) $(I Göründüğü gibi çıkan) dizgiler)

$(P
Ters tırnak işaretleri arasında yazılan dizgilerin içindeki karakterler, yukarıda karakter sabitleriyle ilgili olarak anlatılan kurallar işletilmeden, görüldükleri anlama gelirler. Örneğin $(STRING $(BACK_TICK)c:\nurten$(BACK_TICK)) şeklinde yazılan dizgi, Windows işletim sisteminde bir klasör ismi olabilir. Oysa çift tırnaklar arasında yazılmış olsa, dizginin içinde geçen $(C '\n'), $(I satır sonu) anlamına gelirdi:
)

---
    writeln(`c:\nurten`);
    writeln("c:\nurten");
---

$(SHELL
c:\nurten  $(SHELL_NOTE göründüğü gibi)
c:         $(SHELL_NOTE_WRONG satır sonu olarak anlaşılan karakter)
urten
)

$(P
Göründüğü gibi çıkan dizgilerin diğer bir yazım şekli, çift tırnaklar kullanmak, ama öncesine bir $(C r) belirteci eklemektir: $(C r"c:\nurten") de göründüğü gibi anlaşılır.
)

$(H6 $(IX on altılı dizgi) On altılı sistemde yazılan dizgiler)

$(P
Karakterlerinin kodları on altılı sayı sisteminde yazılacak olan dizgilerin her karakterinin başına $(C \x) yazmak yerine, başına  $(C x) belirteci gelen dizgiler kullanılabilir. Hatta bu dizgilerin içine okumayı kolaylaştırmak amacıyla boşluklar da yazılabilir. Bu boşluklar derleyici tarafından gözardı edilirler. Örneğin $(C "\x44\x64\x69\x6c\x69") yerine $(C x"44&nbsp;64&nbsp;69&nbsp;6c&nbsp;69") yazılabilir.
)

$(H6 $(IX q&quot;&quot;) $(IX ayraçlı dizgi) Ayraçlı dizgiler)

$(P
Çift tırnakların hemen içine gelmek koşuluyla, dizginin parçası olmayan ayraçlar yerleştirebilirsiniz. Ayraçlı dizgilerde çift tırnaklardan önce $(C q) karakteri gelir: $(C q".merhaba.") dizgisinin değeri "merhaba"dır; noktalar değere ait değillerdir. Hemen sonrası satır sonuna gelmek koşuluyla, ayraçları sözcükler olarak da belirleyebilirsiniz:
)

---
writeln(q"AYRAÇ
birinci satır
ikinci satır
AYRAÇ");
---

$(P
Bu örnekteki AYRAÇ sözcüğü dizginin parçası değildir:
)

$(SHELL
birinci satır
ikinci satır
)

$(H6 $(IX q{}) $(IX kod dizgisi) $(IX hazır değer, kod dizgisi) D kodu dizgileri)

$(P
Yine başında $(C q) karakteri olmak üzere, $(C {) ve $(C }) karakterleri arasında yasal D kodu içeren dizgiler yazılabilir:
)

---
    auto dizgi = q{int sayı = 42; ++sayı;};
    writeln(dizgi);
---

$(P
Çıktısı:
)

$(SHELL
int sayı = 42; ++sayı;
)

$(H6 $(IX string) $(IX wstring) $(IX dstring) Dizgi değerlerin türleri)

$(P
Dizgiler özellikle belirtilmediğinde $(C immutable(char)[]) türündedirler. Sonlarına eklenen $(C c), $(C w), ve $(C d) karakterleri dizginin türünü sırasıyla $(C immutable(char)[]), $(C immutable(wchar)[]), ve $(C immutable(dchar)[]) olarak belirler. Örneğin $(C "merhaba"d) dizgisinin karakterleri $(C immutable(dchar)) türündedirler.
)

$(P
Bu üç türün sırasıyla $(C string), $(C wstring), ve $(C dstring) olan takma isimlerini $(LINK2 /ders/d/dizgiler.html, Dizgiler bölümünde) öğrenmiştiniz.
)

$(H5 Hazır değerler derleme zamanında hesaplanırlar)

$(P
Hazır değerleri işlem halinde de yazabilirsiniz. Örneğin Ocak ayındaki toplam saniye değerini $(C 2678400) veya $(C 2_678_400) olarak yazmak yerine, değerin doğruluğundan emin olmamıza yarayan $(C 60 * 60 * 24 * 31) şeklinde de yazabilirsiniz. İçinde çarpma işleçleri olsa da, o işlem programınızın çalışma hızını düşürmez; hazır değer, derleme zamanında yine de 2678400 olarak hesaplanır ve sanki siz öyle yazmışsınız gibi derlenir.
)

$(P
Aynı durum dizgi hazır değerleri için de geçerlidir. Örneğin $(C "merhaba&nbsp;"&nbsp;~&nbsp;"dünya") yazımındaki $(I dizgi birleştirme) işlemi çalışma zamanında değil, derleme zamanında yapıldığı için programınız sanki "merhaba&nbsp;dünya" yazılmış gibi derlenir ve çalışır.
)

$(PROBLEM_COK

$(PROBLEM
Aşağıdaki satır derlenemez:

---
    int miktar = 10_000_000_000;    $(DERLEME_HATASI)
---

$(P
Derleme hatasını giderin ve $(C miktar)'ın on milyara eşit olmasını sağlayın.
)

)

$(PROBLEM
Bir tamsayının değerini sonsuz bir döngüde arttıran ve bunu ekrana yazdıran bir program yazın. Döngünün her tekrarında sayının değeri ekrana yazdırıldığı halde, yazılan değer hep aynı satırda çıksın:

$(SHELL
Sayı: 25774  $(SHELL_NOTE hep aynı satırın üstüne yazılsın)
)

$(P
Bunun için yukarıdaki kontrol karakterlerinden birisi işinize yarayacak.
)

)

)

Macros:
        SUBTITLE=Hazır Değerler

        DESCRIPTION=D dilinde kaynak kod içine hazır olarak yazılan sabit değerlerin tanıtılması ve söz dizimleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial hazır değer literal

SOZLER=
$(degisken)
$(hazir_deger)
$(isaretli_tur)
$(isaretsiz_tur)
$(islec)
$(islev)
$(nesne)
$(sekme)
