Ddoc

$(DERS_BOLUMU $(IX değişken) Değişkenler)

$(P
Programda kullanılan kavramları temsil eden yapılara $(I değişken) denir. Örnek olarak $(I hava sıcaklığı) gibi bir değeri veya $(I yarış arabası motoru) gibi karmaşık bir nesneyi düşünebilirsiniz.
)

$(P
Bir değişkenin temel amacı bir değeri ifade etmektir. Değişkenin değeri, ona en son atanan değerdir. Her değerin belirli bir türünün olması gerektiği gibi, her değişken de belirli bir türdendir. Değişkenlerin çoğunun isimleri de olur ama programda açıkça anılmaları gerekmeyen değişkenlerin isimleri olmayabilir de.
)

$(P
Örnek olarak bir okuldaki öğrenci sayısı $(I kavramını) ifade eden bir değişken düşünebiliriz. Öğrenci sayısı bir tamsayı olduğu için, türünü $(C int) olarak seçebiliriz. Açıklayıcı bir isim olarak da $(C öğrenci_sayısı) uygun olur.
)

$(P
D'nin yazım kuralları gereği, değişkenler önce türleri sonra isimleri yazılarak tanıtılırlar. Bir değişkenin bu şekilde tanıtılmasına, o değişkenin $(I tanımı), ve bu eyleme o değişkenin $(I tanımlanması) denir. Değişkenin ismi, programda geçtiği her yerde değerine dönüşür.
)

---
import std.stdio;

void main() {
    // Değişkenin tanımlanması; öğrenci_sayısı'nın int
    // türünde bir değişken olduğunu belirtir:
    int öğrenci_sayısı;

    // Değişkenin isminin kullanıldığı yerde değerine
    // dönüşmesi:
    writeln("Bu okulda ", öğrenci_sayısı, " öğrenci var.");
}
---

$(P
Bu programın çıktısı şudur:
)

$(SHELL
Bu okulda 0 öğrenci var.
)

$(P
Programın çıktısından anlaşıldığına göre, $(C öğrenci_sayısı)'nın değeri 0'dır. Bunun nedeni, $(C int)'in ilk değerinin temel türler tablosundan hatırlayacağınız gibi 0 olmasıdır.
)

$(P
Dikkat ederseniz, $(C öğrenci_sayısı) çıktıda ismi olarak değil, değeri olarak belirmiştir; yani programın çıktısı $(C Bu&nbsp;okulda&nbsp;öğrenci_sayısı&nbsp;öğrenci&nbsp;var.) şeklinde olmamıştır.
)

$(P
Değişkenlerin değerleri $(C =) işleci ile değiştirilir. Yaptığı iş $(I değer atamak) olduğu için, bu işlece $(I atama işleci) denir:
)

---
import std.stdio;

void main() {
    int öğrenci_sayısı;
    writeln("Bu okulda ", öğrenci_sayısı, " öğrenci var.");

    // öğrenci_sayısı'na 200 değerinin atanması:
    öğrenci_sayısı = 200;
    writeln("Bu okulda şimdi ", öğrenci_sayısı, " öğrenci var.");
}
---

$(SHELL
Bu okulda 0 öğrenci var.
Bu okulda şimdi 200 öğrenci var.
)

$(P
Eğer değişkenin değeri tanımlandığı sırada biliniyorsa, tanımlanmasıyla değerinin atanması aynı anda yapılabilir, ve hata riskini azalttığı için de önerilen bir yöntemdir:
)

---
import std.stdio;

void main() {
    // Hem tanım, hem atama:
    int öğrenci_sayısı = 100;

    writeln("Bu okulda ", öğrenci_sayısı, " öğrenci var.");
}
---

$(SHELL
Bu okulda 100 öğrenci var.
)

$(PROBLEM_TEK

$(P
İki değişken kullanarak ekrana "2.11 kurundan 20 avro bozdurdum." yazdırın. Değişkenlerden kesirli sayı olanı için $(C double) türünü kullanabilirsiniz.
)

)

Macros:
        SUBTITLE=Değişkenler

        DESCRIPTION=D dilinde değişkenler

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial değişkenler

SOZLER= 
$(atama)
$(cikti)
$(degisken)
$(islec) 
$(tanim)
