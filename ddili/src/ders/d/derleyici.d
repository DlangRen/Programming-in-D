Ddoc

$(DERS_BOLUMU $(IX derleme) Derleme)

$(P
D programcılığında en çok kullanılan iki aracın $(I metin düzenleyici) ve $(I derleyici) olduklarını gördük. Programlar metin düzenleyicilerde yazılırlar.
)

$(P
D gibi dillerde derleme kavramı ve derleyicinin işlevi de hiç olmazsa kaba hatlarıyla mutlaka bilinmelidir.
)

$(H5 $(IX makine kodu) Makine kodu)

$(P
$(IX CPU) $(IX mikro işlemci) Bilgisayarın beyni CPU denen mikro işlemcidir. Mikro işlemciye ne işler yapacağını bildirmeye $(I kodlama), bu bildirimlere de $(I kod) denir.
)

$(P
Her mikro işlemci modelinin kendisine has kodları vardır. Her mikro işlemcinin nasıl kodlanacağına mimari tasarımı aşamasında ve donanım kısıtlamaları gözetilerek karar verilir. Bu kodlar çok alt düzeyde elektronik sinyaller olarak gerçekleştirilirler. Bu tasarımda kodlama kolaylığı geri planda kaldığı için, doğrudan mikro işlemciyi kodlayarak program yazmak çok güç bir iştir.
)

$(P
Mikro işlemcinin adının parçası olan $(I işlem) kavramı, özel sayılar olarak belirlenmiştir. Örneğin kodları 8 bit olan hayalî bir işlemcide 4 sayısı yükleme işlemini, 5 sayısı depolama işlemini, 6 sayısı da arttırma işlemini gösteriyor olabilir. Bu hayalî işlemcide soldaki 3 bitin işlem sayısı ve sağdaki 5 bitin de o işlemde kullanılacak değer olduğunu düşünürsek, bu mikro işlemcinin makine kodu şöyle olabilir:
)

$(MONO
$(B
İşlem   Değer           Anlamı)
 100    11110        YÜKLE  11110
 101    10100        DEPOLA 10100
 110    10100        ARTTIR 10100
 000    00000        BEKLE
)

$(P
Makine kodunun donanıma bu kadar yakın olması, $(I oyun kağıdı) veya $(I öğrenci kayıtları) gibi üst düzey kavramların bilgisayarda temsil edilmelerini son derece güç hale getirir.
)

$(H5 $(IX programlama dili) Programlama dili)

$(P
Mikro işlemcileri kullanmanın daha etkin yolları aranmış, ve çözüm olarak üst düzey kavramları ifade etmeye elverişli programlama dilleri geliştirilmiştir. Bu dillerin donanım kaygıları olmadığı için, özellikle kullanım kolaylığı ve ifade gücü gözetilerek tasarlanmışlardır. Programlama dilleri insanlara uygun dillerdir ve çok kabaca konuşma dillerine benzerler:
)

$(MONO
if (ortaya_kağıt_atılmış_mı()) {
   oyun_kağıdını_göster();
}
)

$(P
Buna rağmen, programlama dilleri çok daha sıkı kurallara sahiptirler.
)

$(P
Programlama dillerinin bir sorunu, anahtar sözcüklerinin geleneksel olarak İngilizce olmasıdır. Neyse ki bunlar kolayca öğrenebilecek kadar az sayıdadır. Örneğin $(C if)'in "eğer" anlamına geldiğini bir kere öğrenmek yeter.
)

$(H5 $(IX yorumlayıcı) Yorumlayıcı)

$(P
Yorumlayıcı, programın kaynak kodunu okuyan ve yazıldığı amaca uygun olarak işleten bir araçtır. Örneğin, bir yorumlayıcı yukarıdaki kod verildiğinde önce $(C ortaya_kağıt_atılmış_mı())'yı işleteceğini, sonra da onun sonucuna bağlı olarak $(C oyun_kağıdını_göster())'i işletir. Programcının bakış açısından, programı yorumlayıcı ile işletmek yalnızca iki adımdan oluşur: programı yazmak ve yorumlayıcıya vermek.
)

$(P
Yorumlayıcı programı her işletişinde kaynak kodu baştan okumak zorundadır. Bu yüzden, yorumlayıcı ile işletilen program genel olarak o programın derlenmiş halinden daha yavaş çalışır. Ek olarak, yorumlayıcılar genelde kodu kapsamlıca incelemeden işletirler. Bu yüzden, çeşitli program hatası ancak program çalışmaya başladıktan sonra yakalanabilir.
)

$(P
Perl, Python, ve Ruby gibi esnek ve dinamik dillerde yazılmış programların işletilmeden önce incelenmeleri güçtür. Bu yüzden, böyle diller geleneksel olarak yorumlayıcı ile kullanılırlar.
)

$(H5 $(IX derleyici) Derleyici)

$(P
Derleyici, programın kaynak kodunu okuyan başka bir araçtır. Yorumlayıcıdan farkı, kodu işletmemesi ama işletecek olan başka bir program oluşturmasıdır. Programcının yazdığı kodları işletme görevi oluşturulan bu programa aittir. (Bu program genelde makine kodu içerir.) Programcının bakış açısından, programı derleyici ile işletmek üç adımdan oluşur: programı yazmak, derlemek, ve oluşturulan programı çalıştırmak.
)

$(P
Yorumlayıcının aksine, derleyici kaynak kodu tek kere ve derleme sırasında okur. Bu yüzden, derlenmiş program yorumlayıcı tarafından işletilen programdan genelde daha hızlıdır. Derleyiciler kodu genelde kapsamlı olarak da inceleyebildiklerinden hem daha hızlı işleyen programlar üretebilirler hem de program hatalarının çoğunu daha program işlemeye başlamadan önce yakalayabilirler. Öte yandan, yazılan programın her değişiklikten sonra derlenmesinin gerekmesi ek bir külfet olarak görülebilir ve bazı insan hatalarının kaynağıdır. Dahası, derleyicinin ürettiği program ancak belirli bir platformda çalışabilir; programın başka bir mikro işlemci veya işletim sistemi üzerinde çalışabilmesi için tekrar derlenmesi gerekir. Ek olarak, derlenmeleri kolay olan diller yorumlayıcı kullananlardan daha az esnektirler.
)

$(P
Aralarında Ada, C, C++, ve D'nin de bulunduğu bazı diller güvenlik ve performans gibi nedenlerle derlenebilecek biçimde tasarlanmışlardır.
)

$(H6 $(IX derleme hatası) $(IX hata, derleme) Derleme hatası)

$(P
Derleyiciler programı dilin kurallarına uygun olarak derledikleri için, kural dışı kodlar gördüklerinde bir hata mesajı vererek sonlanırlar. Örneğin kapanmamış bir parantez, unutulmuş bir noktalı virgül, yanlış yazılmış bir anahtar sözcük, vs. derleme hatasına yol açar.
)

$(P
Derleyici bazen de kod açıkça kural dışı olmadığı halde, programcının yanlış yapmasından şüphelenebilir ve bu konuda uyarı mesajı verebilir. Program derlenmiş bile olsa, her zaman için uyarıları da hata gibi kabul edip, uyarıya neden olan kodu değiştirmek iyi olur.
)

Macros:
        SUBTITLE=Derleyici

        DESCRIPTION=Derleyici kavramının tanıtılması

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial derleyici makina

SOZLER= 
$(anahtar_sozcuk)
$(bit)
$(derleyici)
$(makine_kodu)
$(metin_duzenleyici)
$(mikro_islemci)
$(program)
