Ddoc

$(DERS_BOLUMU $(IX while) $(IX döngü, while) $(CH4 while) Döngüsü)

$(P
$(C while) döngüsü $(C if) koşuluna çok benzer ve onun tekrar tekrar işletilmesidir. Mantıksal bir ifade alır, bu ifade doğru ise kapsamdaki ifadeleri işletir. Kapsamdaki işlemler tamamlanınca mantıksal ifadeye tekrar bakar ve doğru olduğu sürece bu döngüde devam eder. "while", "olduğu sürece" demektir. Söz dizimi şöyledir:
)

---
    while (bir_mantıksal_ifade) {
        // işletilecek bir ifade
        // işletilecek başka bir ifade
        // vs...
    }
---

$(P
Örneğin "baklava olduğu sürece baklava ye" gibi bir ifade şöyle programlanabilir:
)

---
import std.stdio;

void main() {
    bool hâlâ_baklava_var = true;

    while (hâlâ_baklava_var) {
        writeln("Tabağa baklava koyuyorum");
        writeln("Baklava yiyorum");
    }
}
---

$(P
O program sonsuza kadar o döngü içinde kalacaktır, çünkü $(C hâlâ_baklava_var) değişkeninin değeri hiç değişmemekte ve hep $(C true) olarak kalmaktadır.
)

$(P
$(C while)'ın gücü, mantıksal ifadenin programın çalışması sırasında değiştiği durumlarda daha iyi anlaşılır. Bunu görmek için kullanıcıdan bir sayı alan ve bu sayı "0 veya daha büyük" olduğu sürece döngüde kalan bir program düşünelim. Hatırlarsanız, $(C int) türündeki değişkenlerin ilk değeri 0 olduğu için bu programda da $(C sayı)'nın ilk değeri 0'dır:
)

---
import std.stdio;

void main() {
    int sayı;

    while (sayı >= 0) {
        write("Bir sayı girin: ");
        readf(" %s", &sayı);

        writeln(sayı, " için teşekkürler!");
    }

    writeln("Döngüden çıktım");
}
---

$(P
O program girilen sayı için teşekkür eder ve eksi bir sayı girildiğinde döngüden çıkar.
)

$(H5 $(IX continue) $(C continue) deyimi)

$(P
"continue", "devam et" demektir. Bu deyim, döngünün geri kalanındaki ifadelerin işletilmeleri yerine, hemen döngünün başına dönülmesini sağlar.
)

$(P
Yukarıdaki programda girilen her sayı için teşekkür etmek yerine, biraz seçici olalım ve 13 değeri girildiğinde beğenmeyip tekrar döngünün başına dönelim. Bu programda 13'e teşekkür edilmez, çünkü sayı 13 olduğunda $(C continue) ile hemen döngünün başına gidilir:
)

---
import std.stdio;

void main() {
    int sayı;

    while (sayı >= 0) {
        write("Bir sayı girin: ");
        readf(" %s", &sayı);

        if (sayı == 13) {
            writeln("Uğursuz sayı kabul etmiyorum...");
            continue;
        }

        writeln(sayı, " için teşekkürler!");
    }

    writeln("Döngüden çıktım");
}
---

$(P
O programın davranışını şöyle özetleyebiliriz: girilen sayı 0 veya daha büyük olduğu sürece sayı al, ama 13 değerini kullanma.
)

$(P
$(C continue) deyimi $(C do-while), $(C for), ve $(C foreach) deyimleriyle birlikte de kullanılabilir. Bu olanakları sonraki bölümlerde göreceğiz.
)

$(H5 $(IX break) $(C break) deyimi)

$(P
Bir çok sözlük anlamı olan "break" D'de "döngüyü kır" anlamındadır. Bazen artık döngüyle işimiz kalmadığını anladığımızda döngüden hemen çıkmak isteriz; $(C break) bunu sağlar. Bu programın aradığı özel sayının 42 olduğunu varsayalım ve o sayıyı bulduğu an döngüyle işi bitsin:
)

---
import std.stdio;

void main() {
    int sayı;

    while (sayı >= 0) {
        write("Bir sayı girin: ");
        readf(" %s", &sayı);

        if (sayı == 42) {
            writeln("ARADIĞIMI BULDUM!");
            break;
        }

        writeln(sayı, " için teşekkürler!");
    }

    writeln("Döngüden çıktım");
}
---

$(P
Şimdiki davranışını da şöyle özetleyebiliriz: girilen sayı 0 veya daha büyük olduğu sürece sayı al, 42 gelirse hemen çık.
)

$(P
$(C break) deyimi $(C do-while), $(C for), $(C foreach), ve $(C switch) deyimleriyle birlikte de kullanılabilir. Bu olanakları sonraki bölümlerde göreceğiz.
)

$(H5 $(IX döngü, sonsuz) Sonsuz döngü)

$(P
$(C break) deyiminin kullanıldığı bazı durumlarda bilerek sonsuz döngü oluşturulur ve $(C break) deyimi o döngünün tek çıkışı olur. Sonsuz döngü oluşturmak için $(C while)'a sabit $(C true) değeri verilir. Örneğin kullanıcıya bir menü göstererek ondan bir komut bekleyen aşağıdaki program, ancak kullanıcı özellikle istediğinde bu döngüden çıkmaktadır:
)

---
import std.stdio;

void main() {
    // Sonsuz döngü, çünkü mantıksal ifade hep true:
    while (true) {
        write("0:Çık, 1:Türkçe, 2:İngilizce - Seçiminiz? ");

        int seçim;
        readf(" %s", &seçim);

        if (seçim == 0) {
            writeln("Tamam, sonra görüşürüz...");
            $(HILITE break);   // Bu döngünün tek çıkışı

        } else if (seçim == 1) {
            writeln("Merhaba!");

        } else if (seçim == 2) {
            writeln("Hello!");

        } else {
            writeln("O dili bilmiyorum. :/");
        }
    }
}
---

$(P
($(I Not: Sonsuz döngülerden hata atılınca da çıkılabilir. Hata atma düzeneğini daha sonraki bir bölümde göreceğiz.))
)

$(PROBLEM_COK

$(PROBLEM
Şu program girişten 3 geldiği sürece döngüde kalmak için programlanmış ama bir hata var: kullanıcıdan bir kere bile sayı istemiyor:

---
import std.stdio;

void main() {
    int sayı;

    while (sayı == 3) {
        write("Sayı? ");
        readf(" %s", &sayı);
    }
}
---

$(P
Neden? O programdaki hatayı giderin ve beklendiği gibi çalışmasını sağlayın: kullanıcıdan sayı alsın ve sayı 3 olduğu sürece döngüde kalsın.
)

)

$(PROBLEM
Bilgisayar iki kişiye (Ayşe ve Barış) şöyle bir oyun oynatsın: en başta Ayşe'den 1-10 aralığında bir sayı alsın. Ayşe'nin bu aralık dışında sayı girmesini kabul etmesin ve doğru sayı girene kadar Ayşe'den sayı almaya devam etsin.

$(P
Ondan sonra Barış'tan teker teker sayı almaya başlasın ve Barış'ın girdiği sayı Ayşe'nin baştan girdiği sayıya eşit olunca oyunu sonlandırsın.
)

$(P
$(B Not:) Ayşe'nin girdiği sayı ekranda göründüğünden tabii ki Barış tarafından hemen bilinir. Bu aşamada bunun bir önemi yok; burada amacımız döngüleri öğrenmek.
)

)

)


Macros:
        SUBTITLE=while Döngüsü

        DESCRIPTION=D dilinin döngü deyimlerinden while'ın tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial while döngü deyim

SOZLER=
$(deyim)
$(dongu)
$(ifade)
$(kapsam)
$(mantiksal_ifade)
