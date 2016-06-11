Ddoc

$(DERS_BOLUMU $(IX switch) $(IX case) $(CH4 switch) ve $(CH4 case))

$(P
$(C switch), $(I çoklu koşul) gibi çalışan bir deyimdir ve bu açıdan bir "if else if" zincirine benzer. Buradaki kullanımında "durum" anlamına gelen $(C case), $(C switch)'in denetlediği değerin karşılaştırıldığı durumları belirlemek için kullanılır; kendisi bir deyim değildir.
)

$(P
$(C switch), parantez içinde bir ifade alır; o ifadenin değerini kendi kapsamı içindeki $(C case)'lerle karşılaştırır ve o değere eşit olan $(C case)'in işlemlerini işletir. Söz dizimini şöyle gösterebiliriz:
)

---
    switch ($(I ifade)) {

    case $(I değer_1):
        // ifade'nin değer_1'e eşit olduğu durumdaki işlemler
        // ...
        break;

    case $(I değer_2):
        // ifade'nin değer_2'ye eşit olduğu durumdaki işlemler
        // ...
        break;

    // ... başka case'ler ...

    default:
        // hiçbir değere uymayan durumdaki işlemler
        // ...
        break;
    }
---

$(P
Her ne kadar bir koşul gibi çalışsa da, $(C switch)'in aldığı ifade bir mantıksal ifade olarak kullanılmaz. Yani bir $(C if)'te olduğu gibi "eğer böyleyse" anlamında değildir. $(C switch)'teki ifadenin $(I değerinin), $(C case)'lerdeki değerlere eşit olup olmadığına bakılır. Yani, buradaki koşullar hep eşitlik karşılaştırmalarıdır. Bu açıdan bakıldığında bir "if else if" zinciri gibi düşünülebilir:
)

---
    auto değer = $(I ifade);

    if (değer == $(I değer_1)) {
        // değer_1 durumundaki işlemler
        // ...

    } else if (değer == $(I değer_2)) {
        // değer_2 durumundaki işlemler
        // ...
    }

    // ... başka 'else if'ler ...

    } else {
        // hiçbir değere uymayan durumdaki işlemler
        // ...
    }
---

$(P
Ancak, bu "if else if" $(C switch)'in tam eşdeğeri değildir. Nedenlerini aşağıdaki başlıklarda açıklıyorum.
)

$(P
İfadenin değerine eşit olan bir $(C case) değeri varsa, o $(C case)'in altındaki işlemler işletilir. Eğer yoksa, "varsayılan" anlamına gelen $(C default)'un altındaki işlemler işletilir.
)

$(H5 $(IX goto case) $(IX goto default) $(C goto))

$(P
$(C goto) programcılıkta kaçınılması öğütlenen bir deyimdir. Buna rağmen nadir durumlarda $(C switch) deyimi ile kullanılması gerekebilir. $(C goto) deyimini ayrıntılı olarak $(LINK2 /ders/d/etiketler.html, daha ilerideki bir bölümde) göreceğiz.
)

$(P
$(C if) koşulunun kapsamı olduğu için, kapsamdaki işlemler sonlanınca bütün $(C if) deyiminin işi bitmiş olur. $(C switch)'te ise ifadenin değerine eşit bir $(C case) bulunduğu zaman programın işleyişi o $(C case)'e atlar ve ya bir $(C break) ile ya da bir $(C goto case) ile $(I karşılaşılana kadar) devam eder. $(C goto case) hemen alttaki $(C case)'e devam edilmesine neden olur:
)

---
    switch (değer) {

    case 5:
        writeln("beş");
        $(HILITE goto case);    // bir sonraki case'e devam eder

    case 4:
        writeln("dört");
        break;

    default:
        writeln("bilmiyorum");
        break;
    }
---

$(P
$(C goto case)'in bu kullanımı isteğe bağlıdır çünkü $(C break) deyimi bulunmadığında program zaten bir sonraki $(C case) veya $(C default) bölümüne devam eder:
)

---
    case 5:
        writeln("beş");
        // 'break' deyimi yok; bir sonraki case'e devam eder

    case 4:
        writeln("dört");
        break;
---

$(P
$(C değer) 5 olduğunda $(C case 5) satırının altına gidilir ve orada "beş" yazdırılır. Onun sonundaki $(C goto case) bir sonraki $(C case)'e devam edilmesini sağladığı için "dört" de yazdırılır ve çıktıda ikisi de yer alırlar:
)

$(SHELL
beş
dört
)

$(P
$(C goto) deyimi $(C case) bölümlerinde üç farklı biçimde kullanılabilir:
)

$(UL

$(LI $(C goto case), bir sonraki $(C case)'e atlanmasını sağlar.)

$(LI $(C goto default), $(C default) bölümüne atlanmasını sağlar.)

$(LI $(C goto case $(I ifade)), ifadeye uyan $(C case)'e atlanmasını sağlar.)

)

$(P
Bu üç kullanımı bir önceki bölümde gördüğümüz $(C foreach)'ten de yararlanan aşağıdaki programla deneyebiliriz:
)

---
import std.stdio;

void main() {
    foreach (değer; [ 1, 2, 3, 10, 20 ]) {
        writefln("--- değer: %s ---", değer);

        switch (değer) {

        case 1:
            writeln("case 1");
            $(HILITE goto case);

        case 2:
            writeln("case 2");
            $(HILITE goto case 10);

        case 3:
            writeln("case 3");
            $(HILITE goto default);

        case 10:
            writeln("case 10");
            break;

        default:
            writeln("default");
            break;
        }
    }
}
---

$(P
Çıktısı:
)

$(SHELL
--- değer: 1 ---
case 1
case 2
case 10
--- değer: 2 ---
case 2
case 10
--- değer: 3 ---
case 3
default
--- değer: 10 ---
case 10
--- değer: 20 ---
default
)

$(H5 İfadenin değeri ancak tamsayı, $(C bool), veya dizgi olabilir)

$(P
$(C if)'te eşitlik karşılaştırmasında herhangi bir tür kullanılabilir. $(C switch)'te ise ifade değeri olarak ancak tamsayılar, bool, veya dizgiler kullanılabilir.
)

---
    string işlem = /* ... */;
    // ...
    switch (işlem) {

    case "toplama":
        sonuç = birinci + ikinci;
        break;

    case "çıkarma":
        sonuç = birinci - ikinci;
        break;

    case "çarpma":
        sonuç = birinci * ikinci;
        break;

    case "bölme":
        sonuç = birinci / ikinci;
        break;

    default:
        throw new Exception(format("Geçersiz işlem: %s", işlem));
    }
---

$(P $(I Not: Yukarıdaki kod hiçbir $(C case)'e uymayan durumda bir hata atmaktadır. Hataları $(LINK2 /ders/d/hatalar.html, ilerideki bir bölümde) göreceğiz.)
)

$(P
Her ne kadar ifade türü olarak $(C bool) da kullanılabiliyor olsa da, $(C false) ve $(C true) diye iki değeri olan bu tür için çoğu durumda $(C if)'in veya $(C ?:) üçlü işlecinin daha uygun olduğunu düşünebilirsiniz.
)

$(H5 $(IX .., case değer aralığı) $(IX aralık, case) Değer aralıkları)

$(P
Belirli bir değer aralığındaki durumlar $(C case)'ler arasına $(C ..) karakterleri yerleştirilerek belirtilir:
)

---
    switch (zarDeğeri) {

    case 1:
        writeln("Sen kazandın");
        break;

    case 2: $(HILITE ..) case 5:
        writeln("Berabere");
        break;

    case 6:
        writeln("Ben kazandım");
        break;

    default:
        /* Aslında bu durumun hiç gerçekleşmemesi gerekir çünkü
         * yukarıdaki durumlar bütün olası değerleri
         * kapsamaktadır. (Aşağıdaki 'final switch'e bakınız.) */
        break;
    }
---

$(P
Yukarıdaki zarla oynanan oyunda zarın 2, 3, 4, veya 5 değerinde berabere kalınmaktadır.
)

$(H5 $(IX , (virgül), case değer listesi)  Ayrık değerler)

$(P
Yukarıdaki oyunda [2,5] aralığında değil de 2 ve 4 değerleri geldiğinde berabere kalındığını varsayalım. Öyle durumlarda $(C case)'in değerlerinin aralarına virgül yazılır:
)

---
    case 2$(HILITE ,) 4:
        writeln("Berabere");
        break;
---

$(H5 $(IX final switch) $(C final switch) deyimi)

$(P
Bu deyim de $(C switch) gibidir ama bazı kısıtlamaları vardır:
)

$(UL
$(LI $(C default) bölümü bulunamaz; zaten bu durum bazı koşullarda anlamsızdır: Örneğin, zarın değerlerinin altısının da işlemlerinin belirli olduğu bir durumda $(C default) bölümüne gerek yoktur.
)

$(LI $(C case)'lerde aralıklı değerler kullanılamaz (virgülle gösterilen ayrık değerler ise kullanılabilir).
)

$(LI Eğer ifade bir $(C enum) türüyse türün bütün değerlerinin $(C case)'ler tarafından kapsanmış olmaları gerekir ($(C enum)'ları bir sonraki bölümde göreceğiz).
)

)

---
    final switch (zarDeğeri) {

    case 1:
        writeln("Sen kazandın");
        break;

    case 2, 3, 4, 5:
        writeln("Berabere");
        break;

    case 6:
        writeln("Ben kazandım");
        break;
    }
---

$(H5 Ne zaman kullanmalı)

$(P
Yukarıda anlatılanlardan anlaşıldığı gibi; $(C switch), bir ifadenin derleme zamanında bilinen değerlerle karşılaştırıldığı durumlarda kullanışlıdır.
)

$(P
Eğer karşılaştırılacak değer yalnızca iki taneyse, $(C switch) yerine bir "if else" daha uygun olabilir. Örneğin yazı/tura gibi bir sonuçta $(C if) deyimi yeterlidir:
)

---
    if (yazıTuraSonucu == yazı) {
        // ...

    } else {
        // ...
    }
---

$(P
Genel bir kural olarak, $(C switch)'i üç veya daha fazla değer olduğunda düşünebilirsiniz.
)

$(P
Mevcut değerlerin her birisinin $(C case) değeri olarak yer alması gereken durumlarda $(C final switch)'i yeğleyin. Bu, özellikle $(C enum) türlerine uygundur.
)

$(PROBLEM_COK
$(PROBLEM
Yukarıdaki örneklerden birisindeki gibi bir hesap makinesi yapın. Kullanıcıdan önce işlemi $(C string) olarak, sonra da sayıları $(C double) olarak alsın ve işleme göre hesap yapsın. Örneğin işlem "topla" olarak ve sayılar "5&nbsp;7" olarak girildiğinde ekrana 12 yazsın.

$(P
Girişi şu şekilde okuyabilirsiniz:
)

---
    string işlem;
    double birinci;
    double ikinci;

    // ...

    işlem = strip(readln());
    readf(" %s %s", &birinci, &ikinci);
---

)

$(PROBLEM
Hesap makinesini geliştirin ve "topla" gibi sözlü işlemler yanında "+" gibi simgeleri de desteklemesini sağlayın: işlem dizgisi olarak "+" girildiğinde de aynı şekilde çalışsın.
)

$(PROBLEM
Program bilinmeyen bir işlem girildiğinde hata atsın. Hata atma düzeneğini $(LINK2 /ders/d/hatalar.html, ilerideki bir bölümde) göreceğiz. Şimdilik yukarıdaki $(C throw) deyimini kendi programınıza uygulayın.
)

)

Macros:
        SUBTITLE=switch ve case

        DESCRIPTION=D dilinin çoklu koşul olanağını gerçekleştiren switch ve case deyiminin tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial switch case koşul

SOZLER=
$(deyim)
$(kapsam)
$(uclu_islec)
