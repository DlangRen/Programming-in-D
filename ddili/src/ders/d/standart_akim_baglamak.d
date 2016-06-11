Ddoc

$(DERS_BOLUMU $(IX bağlamak, standart akım) Standart Akımları Dosyalara Bağlamak)

$(P
Önceki bölümlerdeki programlar hep standart giriş ve çıkış akımları ile etkileşiyorlardı. D'nin standart akımlarının $(C stdin) ve $(C stdout) olduklarını görmüştük, ve açıkça akım bildirmeden çağrılan $(C writeln) gibi işlevlerin de arka planda bu akımları kullandıklarını öğrenmiştik. Ek olarak, standart girişin hep klavye olduğu, ve standart çıkışın da hep ekran olduğu durumlarda çalışmıştık.
)

$(P
Bundan sonraki bölümde programları dosyalarla etkileşecek şekilde yazmayı öğreneceğiz. Dosyaların da karakter akımı olduklarını, ve bu yüzden standart giriş ve çıkışla etkileşmekten bir farkları olmadıklarını göreceksiniz.
)

$(P
Dosya akımlarına geçmeden önce, programcılık hayatınızda çok işinize yarayacak başka bir bilgiyi bu bölümde vermek istiyorum: programınızın standart giriş ve çıkışını, sizin kodunuzda hiçbir değişiklik gerekmeden dosyalara $(I bağlayabilirsiniz). Programınız ekran yerine bir dosyaya yazabilir, ve klavye yerine bir dosyadan veya bir programdan okuyabilir. Bu, bütün modern uç birimlerin hepsinde bulunan ve programlama dilinden bağımsız bir olanaktır.
)

$(H5 $(IX >, çıkış bağlamak) Standart çıkışı $(C >) ile bir dosyaya bağlamak)

$(P
Programınızı bir uç birimden başlatıyorsanız, programı çalıştırmak için yazdığınız komutun sonuna $(C >) karakterinden sonra bir dosya ismi yazmanız, programın standart çıkış akımının o dosyaya bağlanması için yeterlidir. Bu durumda, programın standart çıkışına yazdığı herşey o dosyaya yazılır.
)

$(P
Standart girişinden bir sayı alan, o sayıyı 2 ile çarpan, ve sonucu standart çıkışına yazdıran bir program düşünelim:
)

---
import std.stdio;

void main() {
    double sayı;
    readf(" %s", &sayı);

    writeln(sayı * 2);
}
---

$(P
O programın isminin $(C iki_kat) olduğunu varsayarsak, programı komut satırından
)

$(SHELL
./iki_kat > iki_kat_sonucu.txt
)

$(P
şeklinde başlatır ve girişine örneğin 1.2 yazarsanız, programın çıktısı olan 2.4'ün ekrana $(I değil), $(C iki_kat_sonucu.txt) ismindeki bir dosyaya yazıldığını görürsünüz. $(I Not: Bu program baştan "Lütfen bir sayı giriniz: " gibi bir mesaj yazmadığı halde, siz yine de sayıyı klavyeden yazıp Enter'a basmalısınız.)
)

$(H5 $(IX <, giriş bağlamak) Standart girişi $(C <) ile bir dosyaya bağlamak)

$(P
Çıkışın $(C >) karakteriyle bir dosyaya bağlanmasına benzer şekilde, giriş de $(C <) karakteriyle bir dosyaya bağlanabilir. Bu durumda da girişinden bilgi bekleyen bir program klavyeden okumak yerine, belirtilen dosyadan okur.
)

$(P
Bu sefer de elimizde girişinden aldığı sayının onda birini hesaplayan bir program olsun:
)

---
import std.stdio;

void main() {
    double sayı;
    readf(" %s", &sayı);

    writeln(sayı / 10);
}
---

$(P
Eğer iki kat alan programın oluşturduğu dosya hâlâ klasörde duruyorsa, ve bu programın isminin de $(C onda_bir) olduğunu varsayarsak, programı komut satırından
)

$(SHELL
./onda_bir < iki_kat_sonucu.txt
)

$(P
şeklinde başlatırsanız, girişini daha önce oluşturulan $(C iki_kat_sonucu.txt) dosyasından aldığını ve çıkışa $(C 0.24) yazdırdığını görürsünüz. $(I Not: $(C iki_kat_sonucu.txt) dosyasında 2.4 olduğunu varsayıyorum.)
)

$(P
$(C onda_bir) programı; ihtiyacı olan sayıyı artık klavyeden değil, bir dosyadan okumaktadır.
)

$(H5 Giriş ve çıkış akımlarının ikisini birden dosyalara bağlamak)

$(P
$(C >) ve $(C <) karakterlerini aynı anda kullanabilirsiniz:
)

$(SHELL
./onda_bir < iki_kat_sonucu.txt > butun_sonuc.txt
)

$(P
Bu sefer giriş $(C iki_kat_sonucu.txt) dosyasından okunur, ve çıkış da $(C butun_sonuc.txt) dosyasına yazılır.
)

$(H5 $(IX |, program bağlamak) Programları $(C |) ile birbirlerine bağlamak)

$(P
Yukarıda kullanılan $(C iki_kat_sonucu.txt) dosyasının iki program arasında aracılık yaptığına dikkat edin: $(C iki_kat) programı, hesapladığı sonucu $(C iki_kat_sonucu.txt) dosyasına yazmaktadır, ve $(C onda_bir) programı da ihtiyaç duyduğu sayıyı $(C iki_kat_sonucu.txt) dosyasından okumaktadır.
)

$(P
$(C |) karakteri, programları böyle bir aracı dosyaya gerek olmadan birbirlerine bağlar. $(C |) karakteri, solundaki programın standart çıkışını sağındaki programın standart girişine bağlar. Örneğin komut satırında birbirine şu şekilde bağlanan iki program, toplu olarak "beşte bir" hesaplayan bir komut haline dönüşür:
)

$(SHELL
./iki_kat | ./onda_bir
)

$(P
Önce $(C iki_kat) programı çalışır ve girişinden bir sayı alır. $(I Not: O programın "Lütfen bir sayı giriniz: " gibi bir mesaj yazmadığını hatırlayın; siz yine de sayıyı klavyeden yazıp Enter'a basmalısınız.)
)

$(P
Sonra, $(C iki_kat) programının çıkışı $(C onda_bir) programının girişine verilir ve iki katı alınmış olan sayının onda biri, yani baştaki sayının "beşte biri" çıkışa yazılır.
)

$(PROBLEM_TEK

$(P
İkiden fazla programı art arda bağlamayı deneyin:
)

$(SHELL
./birinci | ./ikinci | ./ucuncu
)

)

Macros:
        SUBTITLE=Standart Akımları Dosyalara Bağlamak

        DESCRIPTION=Standart akımları dosyalara ve başka programların standart giriş ve çıkışlarına bağlanmaları

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial standart giriş çıkış dosya bağlamak yönlendirmek

SOZLER=
$(akim)
$(standart_cikis)
$(standart_giris)
$(uc_birim)
