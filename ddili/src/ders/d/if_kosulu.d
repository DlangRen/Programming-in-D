Ddoc

$(DERS_BOLUMU $(IX if) $(CH4 if) Koşulu)

$(P
Programda asıl işlerin ifadeler tarafından yapıldığını öğrendik. Şimdiye kadar gördüğümüz programlarda işlemler $(C main) isimli işlev içinde baştan sona doğru ve yazıldıkları sırada işletiliyorlardı.
)

$(P
$(IX deyim) D'de deyimler, ifadelerin işletilme kararlarını veren ve ifadelerin işletilme sıralarını etkileyen program yapılarıdır. Kendileri değer üretmezler ve yan etkileri yoktur. Deyimler, ifadelerin işletilip işletilmeyeceklerini ve bu ifadelerin hangi sırada işletileceklerini belirlerler. Bu kararları verirken de yine ifadelerin değerlerinden yararlanırlar.
)

$(P $(I $(B Not:) İfade ve deyim kavramlarının burada öğrendiğiniz tanımları D dilindeki tanımlarıdır. Başka dillerdeki tanımları farklılıklar gösterir ve hatta bazı dillerde böyle bir ayrım yoktur.)
)

$(H5 $(C if) bloğu ve kapsamı)

$(P
$(C if) deyimi, ifadelerin işletilip işletilmeyeceğine belirli bir mantıksal ifadenin sonucuna bakarak karar veren yapıdır. "if", İngilizce'de "eğer" anlamındadır; "eğer tatlı varsa" kullanımında olduğu gibi... 
)

$(P
Parantez içinde bir mantıksal ifade alır, eğer o ifade doğruysa (yani değeri $(C true) ise), küme parantezleri içindeki ifadeleri işletir. Bunun tersi olarak, mantıksal ifade doğru değilse küme parantezleri içindeki ifadeleri işletmez.
)

$(P
Söz dizimi şöyledir:
)

---
    if (bir_mantıksal_ifade) {
        // işletilecek bir ifade
        // işletilecek başka bir ifade
        // vs.
    }
---

$(P
Örneğin "eğer baklava varsa baklava ye ve sonra tabağı kaldır" gibi bir program yapısını şöyle yazabiliriz:
)

---
import std.stdio;

void main() {
    bool baklava_var = true;

    if (baklava_var) {
        writeln("Baklava yiyorum...");
        writeln("Tabağı kaldırıyorum...");
    }
}
---

$(P
O programda $(C baklava_var)'ın değeri $(C false) yapılırsa çıkışa hiçbir şey yazdırılmaz, çünkü $(C if) deyimi kendisine verilen mantıksal ifade $(C false) olduğunda küme parantezi içindeki ifadeleri işletmez.
)

$(P
Küme parantezleriyle gruplanmış ifadelerin tümüne $(I blok), o bölgeye de $(I kapsam) adı verilir.
)

$(P
Yazım yanlışlarına yol açmadığı sürece, okumayı kolaylaştırmak için programda istediğiniz gibi boşluklar kullanabilirsiniz. )

$(H5 $(IX else) $(C else) bloğu ve kapsamı)

$(P
Çoğu zaman $(C if)'e verilen mantıksal ifadenin doğru olmadığı durumda da bazı işlemler yapmak isteriz. Örneğin "eğer ekmek varsa yemek ye, yoksa bakkala git" gibi bir kararda ekmek olsa da olmasa da bir eylem vardır.
)

$(P
D'de ifade $(C false) olduğunda yapılacak işler $(C else) anahtar sözcüğünden sonraki küme parantezleri içinde belirtilir. "else", "değilse" demektir. Söz dizimi şöyledir:
)

---
    if (bir_mantıksal_ifade) {
        // doğru olduğunda işletilen ifadeler

    } else {
        // doğru olMAdığında işletilen ifadeler
    }
---

$(P
Örnek olarak:
)

---
    if (ekmek_var) {
        writeln("Yemek yiyorum");

    } else {
        writeln("Bakkala yürüyorum");
    }
---

$(P
O örnekte $(C ekmek_var)'ın değerine göre ya birinci dizgi ya da ikinci dizgi yazdırılır.
)

$(P
$(C else) kendisi bir deyim değildir, $(C if) deyiminin seçime bağlı bir parçasıdır; tek başına kullanılamaz.
)

$(P
Yukarıdaki $(C if) ve $(C else) bloklarının küme parantezlerinin hangi noktalara yazıldıklarına dikkat edin. $(LINK2 http://dlang.org/dstyle.html, Kabul edilen D kodlama standardına) göre küme parantezleri aslında kendi satırlarına yazılırlar. Bu kitap yaygın olan başka bir kodlama standardına uygun olarak deyim küme parantezlerini deyimlerle aynı satırlara yazar.
)

$(H5 Kapsam parantezlerini hep kullanın)

$(P
Hiç tavsiye edilmez ama bunu bilmenizde yarar var: Eğer $(C if)'in veya $(C else)'in altındaki ifade tekse, küme parantezleri gerekmez. Yukarıdaki ifade küme parantezleri kullanılmadan aşağıdaki gibi de yazılabilir:
)

---
    if (ekmek_var)
        writeln("Yemek yiyorum");

    else
        writeln("Bakkala yürüyorum");
---

$(P
Çoğu deneyimli programcı tek ifadelerde bile küme parantezi kullanır. (Bununla ilgili bir hatayı problemler bölümünde göreceksiniz.) Mutlaka küme parantezleri kullanmanızı bu noktada önermemin bir nedeni var: Bu öneriye hemen hemen hiçbir zaman uyulmayan tek durumu da şimdi anlatacağım.
)

$(H5 $(IX else if) "if, else if, else" zinciri)

$(P
Dilin bize verdiği güçlerden birisi, ifade ve deyimleri serbestçe karıştırarak kullanma imkanıdır. İfade ve deyimleri kapsamlar içinde de kullanabiliriz. Örneğin bir $(C else) kapsamında bile $(C if) deyimi bulunabilir. Programların $(I akıllı) olarak algılanmaları, hep bizim ifade ve deyimleri doğru sonuçlar verecek şekilde birbirlerine bağlamamızdan doğar. Bisiklete binmeyi yürümekten daha çok sevdiğimizi varsayarsak:
)

---
    if (ekmek_var) {
        writeln("Yemek yiyorum");

    } else {

        if (bisiklet_var) {
            writeln("Uzaktaki fırına gidiyorum");

        } else {
            writeln("Yakındaki bakkala yürüyorum");
        }

    }   
---

$(P
Oradaki $(C if) deyimlerinin anlamı şudur: "eğer ekmek varsa: yemek yiyorum; eğer ekmek yoksa: bisiklet varsa fırına gidiyorum, yoksa bakkala yürüyorum".
)

$(P
Biraz daha ileri gidelim ve bisiklet olmadığında hemen bakkala yürümek yerine, komşunun evde olup olmamasına göre davranalım:
)

---
    if (ekmek_var) {
        writeln("Yemek yiyorum");

    } else {

        if (bisiklet_var) {
            writeln("Uzaktaki fırına gidiyorum");
        
        } else {

            if (komşu_evde) {
                writeln("Komşudan istiyorum");

            } else{
                writeln("Yakındaki bakkala yürüyorum");
            }   
        }
    }   
---

$(P
Burada görüldüğü gibi "eğer böyleyse bunu yap, değilse ama öyleyse onu yap, o da değilse ama şöyleyse şunu yap, vs." gibi yapılar programcılıkta çok kullanılır. Ne yazık ki böyle yazınca kodda fazla boşluklar oluşur: buradaki 3 $(C if) deyimi ve 4 $(C writeln) ifadesi için toplam 13 satır yazmış olduk (boş satırları saymadan).
)

$(P
Sık karşılaşılan bu yapıyı daha düzenli olarak yazmak için, böyle zincirleme kararlarda bir istisna olarak $(I içlerinde tek bir $(C if) deyimi bulunan) $(C else)'lerin kapsam parantezlerini yazmayız.
)

$(P
Hiçbir zaman kodu aşağıdaki gibi düzensiz bırakmamanızı öneririm. Ben bir sonraki adıma geçme aşaması olarak gösteriyorum. İçlerinde tek bir $(C if) olan $(C else)'lerin küme parantezlerini kaldırınca kod aşağıdaki gibi olur:
)

---
    if (ekmek_var) {
        writeln("Yemek yiyorum");

    } else

        if (bisiklet_var) {
            writeln("Uzaktaki fırına gidiyorum");
        
        } else

            if (komşu_evde) {
                writeln("Komşudan istiyorum");

            } else{
                writeln("Yakındaki bakkala yürüyorum");
            }
---

$(P
Bir adım daha ileri giderek $(C if) anahtar sözcüklerini de üstlerindeki $(C else) satırlarına çeker ve biraz da hizalarsak, son derece okunaklı bir yapı oluşur:
)

---
    if (ekmek_var) {
        writeln("Yemek yiyorum");

    } else if (bisiklet_var) {
        writeln("Uzaktaki fırına gidiyorum");

    } else if (komşu_evde) {
        writeln("Komşudan istiyorum");

    } else{
        writeln("Yakındaki bakkala yürüyorum");
    }
---

$(P
Böylece hem satır sayısı azalmış olur, hem de kararlara göre işletilecek olan bütün ifadeler alt alta gelmiş olurlar. Dört koşulun hangi sırada denetlendiği ve her koşulda ne yapıldığı bir bakışta anlaşılır.
)

$(P
Çok sık karşılaşılan bu kod yapısına "if, else if, else" denir.
)

$(PROBLEM_COK

$(PROBLEM

Aşağıdaki programdaki mantıksal ifadenin $(C true) olduğunu görüyoruz. Dolayısıyla programın $(I limonata içip bardağı yıkamasını) bekleriz:

---
import std.stdio;

void main() {
    bool limonata_var = true;

    if (limonata_var) {
        writeln("Limonata içiyorum");
        writeln("Bardağı yıkıyorum");

    } else 
        writeln("Baklava yiyorum");
        writeln("Tabağı kaldırıyorum");
}
---

Oysa programı çalıştırırsanız, çıktısında bir de $(I tabak kaldırıldığını) göreceksiniz:

$(SHELL
Limonata içiyorum
Bardağı yıkıyorum
Tabağı kaldırıyorum
)

Neden? Programı düzelterek beklenen çıktıyı vermesini sağlayın.

)

$(PROBLEM
Kullanıcıyla oyun oynayan (ve ona fazlasıyla güvenen) bir program yazın. Kullanıcı attığı zarın değerini girsin. Zarın değerine göre ya kullanıcı kazansın, ya da program:

$(MONO
$(B    Zar Değeri         Program Çıktısı)
       1             Siz kazandınız
       2             Siz kazandınız
       3             Siz kazandınız
       4             Ben kazandım
       5             Ben kazandım
       6             Ben kazandım
Başka bir değer      HATA: Geçersiz değer
)

Ek puan: Hatalı giriş oluştuğunda değeri de yazsın. Örneğin:

$(SHELL
HATA: Geçersiz değer: 7
)
)

$(PROBLEM
Aynı oyunu şöyle değiştirelim: Kullanıcı 1'den 1000'e kadar bir sayı girsin ve 1-500 aralığında siz kazanın, 501-1000 aralığında bilgisayar kazansın. Hâlâ bir önceki problemdeki çözümleri uygulayabilir misiniz?
)

)

Macros:
        SUBTITLE=if Koşulu

        DESCRIPTION=D dilinin koşul deyimlerinden if'in tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial if koşul deyim

SOZLER= 
$(blok)
$(deyim)
$(ifade)
$(kapsam)
$(mantiksal_ifade)
