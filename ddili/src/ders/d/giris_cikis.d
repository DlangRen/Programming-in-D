Ddoc

$(DERS_BOLUMU $(IX standart giriş) $(IX standart çıkış) Standart Giriş ve Çıkış Akımları)

$(P
Bizim $(I ekran) olarak algıladığımız çıkış, aslında D programının $(I standart çıkışıdır). Standart çıkış $(I karakter) temellidir: yazdırılan bütün bilgi önce karakter karşılığına dönüştürülür ve ondan sonra art arda karakterler olarak standart çıkışa gönderilir. Önceki bölümlerde çıkışa gönderilen tamsayılar, örneğin öğrenci sayısı olan 100 değeri, ekrana aslında tamsayı 100 değeri olarak değil; $(C 1), $(C 0), ve $(C 0) şeklinde üç karakter olarak gönderilmiştir.
)

$(P
Normalde $(I klavye) olarak algıladığımız standart giriş de bunun tersi olarak çalışır: bilgi art arda karakterler olarak gelir ve ondan sonra programda kullanılacak değerlere dönüştürülür. Örneğin girişten okunan 42 gibi bir değer, aslında $(C 4) ve $(C 2) karakterleri olarak okunur.
)

$(P
Bu dönüşümler bizim özel bir şey yapmamıza gerek olmadan, otomatik olarak gerçekleşirler.
)

$(P
$(IX stdin) $(IX stdout) Art arda gelen karakterler kavramına $(I karakter akımı) adı verilir. Bu tanıma uydukları için D programlarının standart girişi ve çıkışı birer karakter akımıdır. Standart giriş akımının ismi $(C stdin), standart çıkış akımının ismi de $(C stdout)'tur.
)

$(P
Akımları kullanırken normalde akımın ismi, bir nokta, ve o akımla yapılacak işlem yazılır: $(C akım.işlem) gibi. Buna rağmen, çok kullanılan akımlar oldukları için, $(C stdin) ve $(C stdout)'un özellikle belirtilmeleri gerekmez.
)

$(P
Önceki bölümlerde kullandığımız $(C writeln), aslında $(C stdout.writeln)'in kısaltmasıdır. Benzer şekilde, $(C write) da $(C stdout.write)'in kısaltmasıdır. $(I Merhaba dünya) programını böyle bir kısaltma kullanmadan şöyle de yazabiliriz:
)

---
import std.stdio;

void main() {
    stdout.writeln("Merhaba dünya!");
}
---

$(PROBLEM_TEK

$(P
Yukarıdaki programda $(C stdout)'u yine $(C writeln) işlemiyle kullanın ama bir seferde birden fazla değişken yazdırın.
)

)

Macros:
        SUBTITLE=Standart Giriş ve Çıkış Akımları

        DESCRIPTION=D dilinde standart giriş ve çıkış akımları stdin ve stdout'un tanıtılmaları

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial standart giriş çıkış stdin stdout

SOZLER=
$(akim)
$(karakter)
$(standart_cikis)
$(standart_giris)
