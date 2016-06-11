Ddoc

$(DERS_BOLUMU $(IX giriş düzeni) Giriş Düzeni)

$(P
$(LINK2 /ders/d/cikti_duzeni.html, Çıktı Düzeni) bölümünde anlatılanlara benzer şekilde, girişten gelen verilerin düzeni de belirtilebilir. Bu düzen; hem okunması istenen bilgiyi, hem de gözardı edilmesi istenen bilgiyi belirtebilir.
)

$(P
Giriş için kullanılan düzen dizgisi C'deki $(C scanf) işlevinin düzen dizgisine benzer.
)

$(P
Düzen dizgisi olarak şimdiye kadar yaptığımız gibi $(STRING " %s") kullanıldığında, okunmakta olan değişkenin türüne en uygun olan düzende okunur. Örneğin aşağıdaki $(C readf) çağrısında değişkenin türü $(C double) olduğu için girişteki karakterler kesirli sayı olarak okunurlar:
)

---
    double sayı;

    readf(" %s", &sayı);
---

$(P
Düzen dizgisi içinde üç tür bilgi bulunabilir:
)

$(UL
$(LI $(B Boşluk karakteri): Girişteki $(I sıfır) veya daha fazla boşluk karakteri anlamına gelir ve onların okunup gözardı edilmelerini sağlar.)

$(LI $(B Düzen belirteci): Önceki bölümdekilere benzer şekilde $(C %) karakteriyle başlar ve girişten gelen karakterlerin hangi türde okunacaklarını belirler.)

$(LI $(B Başka herhangi karakter): Girişte aynen bulunması beklenen bir karakteri ifade eder ve onun okunup gözardı edilmesini sağlar.)
)

$(P
O bilgiler sayesinde, girişten gelen veri içerisinden bizim için önemli olanlarını seçip çıkartmak ve geri kalanını gözardı etmek son derece kolaydır.
)

$(P
Ayrıntıya girmeden önce, bu üç tür bilgiyi kullanan bir örneğe bakalım. Girişte tek satır halinde şöyle bir bilgi bulunsun:
)

$(SHELL
numara:123 not:90
)

$(P
O satır içerisinden bizim için önemli olan iki bilgi, öğrencinin numarası ve notu olsun; yani girişteki $(C numara:) ve $(C not:) gibi karakterlerin bizim için bir önemi bulunmasın. İşte o satır içinden öğrencinin numarasını ve notunu $(I seçen) ve geri kalanını gözardı eden bir düzen dizgisi şöyle yazılabilir:
)

---
    int numara;
    int not;
    readf("numara:%s not:%s", &numara, &not);
---

$(P
$(STRING "$(HILITE numara:)%s&nbsp;$(HILITE not:)%s") düzen dizgisinde işaretli olarak gösterilen bütün karakterler girişte aynen bulunmalıdırlar; onlar $(C readf) tarafından girişten okunup gözardı edilirler.
)

$(P
O düzen dizgisinde kullanılan tek boşluk karakteri, girişte o noktada bulunan bütün boşluk karakterlerinin gözardı edilmelerine neden olur.
)

$(P
$(C %) karakterinin özel anlamı nedeniyle, girişte $(C %) karakterinin kendisinin gözardı edilmesi istendiğinde $(C %%) şeklinde çift olarak yazılır.
)

$(P
Tek satırlık bilgi okumak için $(LINK2 /ders/d/dizgiler.html, Dizgiler bölümünde) $(C strip(readln())) yöntemi önerilmişti. Düzen dizgisinin sonuna yazılan $(C \n) karakteri sayesinde $(C readf) de bu amaçla kullanılabilir:
)

---
import std.stdio;

void main() {
    write("Adınız   : ");
    string ad;
    readf(" %s\n", &ad);       // ← sonda \n

    write("Soyadınız: ");
    string soyad;
    readf(" %s\n", &soyad);    // ← sonda \n

    write("Yaşınız  : ");
    int yaş;
    readf(" %s", &yaş);

    writefln("%s %s (%s)", ad, soyad, yaş);
}
---

$(P
Yukarıda $(C ad) ve $(C soyad) okunurken kullanılan düzen dizgileri satır sonunda basılan Enter tuşunun oluşturduğu $(C \n) karakterinin de okunmasını ve gözardı edilmesini sağlarlar. Buna rağmen, satır sonlarındaki olası boşluk karakterlerinden kurtulmak için yine de $(C strip())'i çağırmak gerekebilir.
)

$(H5 Düzen karakterleri)

$(P
Verinin nasıl okunacağı aşağıdaki düzen karakterleriyle belirtilir:
)

$(P $(IX %d, giriş) $(C d): Onlu sistemde tamsayı oku)

$(P $(IX %o, giriş) $(C o): Sekizli sistemde tamsayı oku)

$(P $(IX %x, giriş) $(C x): On altılı sistemde tamsayı oku)

$(P $(IX %f, giriş) $(C f): Kesirli sayı oku)

$(P $(IX %s, giriş) $(C s): Değişkenin türüne uygun olan düzende oku; en yaygın kullanılan belirteç budur)

$(P $(IX %c) $(C c): Tek karakter oku; bu belirteç boşlukları da okur (gözardı edilmelerini önler))

$(P
Örneğin, girişte 3 tane "23" bulunduğunu varsayarsak, her birisi aşağıdaki farklı düzen karakterlerine göre farklı olarak okunur:
)

---
    int sayı_d;
    int sayı_o;
    int sayı_x;

    readf(" %d %o %x", &sayı_d, &sayı_o, &sayı_x);

    writeln("onlu olarak okununca     : ", sayı_d);
    writeln("sekizli olarak okununca  : ", sayı_o);
    writeln("on altılı olarak okununca: ", sayı_x);
---

$(P
3 defa "23" girildiği halde her birisi farklı okunur:
)

$(SHELL
onlu olarak okununca     : 23
sekizli olarak okununca  : 19
on altılı olarak okununca: 35
)

$(P
$(I Not: "23", sekizli düzende 2x8+3=19 değerinde, ve on altılı düzende 2x16+3=35 değerindedir.)
)

$(PROBLEM_TEK

$(P
Girişten $(I yıl.ay.gün) düzeninde bir tarih bilgisi gelsin. Ekrana kaçıncı ay olduğunu yazdırın. Örneğin 2009.09.30 geldiğinde 9 yazılsın.
)

)

Macros:
        SUBTITLE=Giriş Düzeni

        DESCRIPTION=Girişten bilginin belirli bir düzende okunması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial giriş düzen format

SOZLER=
$(cokme)
$(duzen)
$(islev)
$(parametre)
$(phobos)
