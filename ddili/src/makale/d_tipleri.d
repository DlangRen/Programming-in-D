Ddoc

$(H4 D Dilindeki Tipleri Anlamak)

$(P
  $(B Yazar:) $(LINK2 http://www.zafercelenk.net/, Zafer Çelenk)
$(BR)
  $(B Tarih:) 6 Mart 2012
)

$(P
Usta bir programcı olma yolunda tipler büyük önem taşır. Tipler hakkında bilgi vermeye başlamadan önce tiplere neden ihtiyacımız olduğu konusunu incelemek gerekir diye düşünüyorum.
)

$(P
Bildiğiniz gibi bilgisayarlar ikili sistemde çalışır yani bir bilgisayara bir şeyler anlatmak isterseniz bunu önce, bir (1) ve sıfırlardan (0) oluşan bir dizi haline getirip bilgisayara vermelisiniz. Ancak bu işlem biz insanlar için çok zor olduğundan dolayı biz anlatmak istediklerimizi kendi tanımladığımız dilde yazıp derleyiciler aracılığı ile bilgisayarların anlayacağı dile çeviriyoruz. Dolayısıyla eğer bir bilgisayarın belleğini çalışırken görebilseydik bir ve sıfırlardan oluşan diziler görürdük. Her şeyin bir ve sıfırlardan oluştuğu böyle bir dünyada neyin rakam neyin harf olduğunu anlamanın tek yolu bu bir sıfır dizilerini uygun bir şekilde işaretlemek olacaktır. İşte programcı olarak bizim yaptığımız da bilgisayara işlemek için verdiğimiz veriyi tipleri kullanarak işaretlemek ve bilgisayarın doğru bir şekilde işlemesini sağlamaktır.
)

$(P
D dilinde işaretli ve işaretsiz olarak ayrılan tipler bulunmaktadır. Bu işaret kavramını anlamak için bit düzeyine bir yolculuk yapmamız gerekir.
)

$(P
Gelin şimdi hep beraber belleğin derinliklerinde ne oyunlar dönüyor bakalım. Bildiğiniz gibi bilgisayarlar ikili sistemde çalışır ve ikili sistemde kullanabileceğiniz sadece iki sayı vardır 1 ve 0. Eğer 1 bit (Binary digiT) ile çalışıyorsanız ifade edebileceğiniz 2 sayı vardır 1 ve 0, eğer 2 bitle çalışıyorsanız aşağıdaki dört sayıyı ifade edebilirsiniz.
)

$(MONO
00 = 0
01 = 1
10 = 2
11 = 3
)

$(P
Eğer üç bit ile çalışıyorsanız sekiz sayıyı gösterebilirsiniz. Gördüğünüz gibi bir bitlik bir artış ifade edebileceğimiz değer sayısını iki katına çıkarmıştır.
)

$(MONO
000 = 0
001 = 1
010 = 2
011 = 3
100 = 4
101 = 5
110 = 6
111 = 7
)

$(P
Bu örneklerden de anlaşıldığı gibi eğer sekiz bite sahipseniz gösterebileceğiniz en büyük sayı 255 dir.
)

$(MONO
11111111 = 255
)

$(P
Burada gördüğünüz gibi sekiz bit bir araya gelerek 1 byte oluşturuyor. Bilgisayarların temelde kullandığı bilgi dizisi byte olarak kabul edilmiştir.
)

$(P
Bu durumda şöyle bir düşünelim, birler ve sıfırlardan oluşan bir dünyada negatif (-) bir değeri nasıl gösterebiliriz. Çözüm sekiz bitten oluşan dizinin ilk bitini sayının negatif olup olmadığını gösteren işaret biti olarak kullanmaktan geçer. Bu durumda verimizi göstermek için bize 7 bit kalır ve 7 bit ile göstereceğimiz en büyük sayı 127 olur. Buraya kadar yazdıklarımızı toparlayacak olursak eğer sayınız sıfırdan küçükse negatif olduğunu göstermek için ilk biti kullanmak zorundadır dolayısıyla size kalan 7 bit ile göstereceğiz en büyük sayı 127 olmaktadır. Aksi halde sayınız negatif değilse 8 bitide kullanabilirsiniz böylece gösterebileceğiniz en büyük sayı 255 olacaktır. İşte işaretli ve işaretsiz tip arasındaki temel fark budur.
)

$(H5 TAMSAYI TİPLERİ)

$(P
D dilinde işaretli ve işaretsiz olmak üzere toplam sekiz tane tamsayı tipi bulunur. D dilinde işaretsiz olan tiplerin başına "u" harfi getirilir.  "u" harfi ingilizce "unsigned" yani işaretsiz kelimesinin baş harfinden gelmektedir. Ayrıca D dilinde 128 bitten oluşan cent ve ucent adında iki tip daha vardır ancak bunlar henüz kullanıma açılmamış ve ilerisi için hazırlanmıştır. Şimdi bunları sıra ile tanıyalım;
)

$(H6 $(C byte) ve $(C ubyte))

$(P
$(C byte) tipi -128 ile 127 arasında değer alabilen işaretli 8 bitten oluşan bir tipdir. $(C ubyte) ise $(C byte) tipinin işaretsiz halidir ve negatif değer alamaz. sınırı ise 255 dir.
)

$(H6 $(C short) ve $(C ushort))

$(P
$(C short) tipi -32_768 ile 32_767 arasında değer alabilen işaretli 16 bitten oluşan bir tiptir. $(C ushort) ise $(C short) tipinin işaretsiz halidir ve negatif değer alamaz. sınırı ise 65_535 dir.
)

$(H6 $(C int) ve $(C uint))

$(P
$(C int) tipi -2_147_483_648 ile 2_147_483_647 arasında değer alabilen işaretli 32  bitten oluşan bir tiptir. $(C uint) ise $(C int) tipinin işaretsiz halidir ve negatif değer alamaz. sınırı ise 4_294_ 967_295 dir.
)

$(H6 $(C long) ve $(C ulong))

$(P
$(C long) tipi -9_223_372_036_854_775_808 ile 9_223_372_036_854_775_807 arasında değer alabilen işaretli 64  bitten oluşan bir tiptir. $(C ulong) ise $(C long) tipinin işaretsiz halidir ve negatif değer alamaz. sınırı ise 18_446_744_073_709_551_615 dir.
)

$(H5 KESİR SAYI TİPLERİ)

$(P
Kayan noktalı sayılar olarakta bilinen kesirli sayıları barındıran tiplerdir. Bu tipler 1.25 gibi sayıları tutan tiplerdir. Bu tiplerde hassasiyeti tiplerin bit sayısı belirler. Bit sayısı ne kadar yüksek ise hassasiyet o kadar çoktur. Kesirli değerleri alabilen tek tipler bunlardır. Şimdi bunları sıra ile tanıyalım;
)

$(H6 $(C float))

$(P
$(C float) tipi 32 bitten oluşan kayan noktalı bir sayı tipidir.
)

$(H6 $(C double))

$(P
$(C double) tipi 64 bitten oluşan kayan noktalı bir sayı tipidir.
)

$(H6 $(C real))

$(P
Donanımın tanımladığı en büyük kayan noktalı sayı tipidir. (Örneğin : x86 işlemcilerde 80 bit) veya $(C double) 'dir hangisi büyükse.
)

$(H5 SANAL TİPLER)

$(P
Karmaşık sayıların sadece sanal değerlerini taşıyabilen bir tipdir. Şimdi bunları sıra ile tanıyalım;
)

$(H6 $(C ifloat))

$(P
$(C ifloat) tipi sanal float tipidir.
)

$(H6 $(C idouble))

$(P
$(C idouble) tipi sanal double tipidir.
)

$(H6 $(C ireal))

$(P
$(C ireal) tipi sanal real tipidir.
)

$(H5 KARMAŞIK SAYI TİPLERİ)

$(P
Matematikte geçen karmaşık sayıları taşıyabilen bir tiptir. Şimdi bunları sıra ile tanıyalım;
)

$(H6 $(C cfloat))

$(P
$(C cfloat) tipi iki float tipden oluşan bir tipdir.
)

$(H6 $(C cdouble))

$(P
$(C cdouble) tipi iki double tipden oluşan bir tipdir.
)

$(H6 $(C creal))

$(P
$(C creal) tipi iki real tipden oluşan tipdir.
)

$(H5 KARAKTER TİPLERİ)

$(P
Karakter tipleri bellekte karakterleri tutabilen tiplerdir. Temel karakter kümesi ASCII olmakla birlikte daha farklı bir çok karakter kümesine ait karakterler bu tiplerle kullanılabilir. Şimdi bunları sıra ile tanıyalım;
)

$(H6 $(C char))

$(P
$(C char) tipi UTF-8 kod birimine uygun karakterleri tutabilen bir tipdir.
)

$(H6 $(C wchar))

$(P
$(C wchar) tipi UTF-16 kod birimine uygun karakterleri tutabilen bir tipdir.
)

$(H6 $(C dchar))

$(P
$(C dchar) tipi UTF-32 kod birimine uygun karakterleri tutabilen bir tipdir.
)

$(H5 TİP NİTELİKLERİ)

$(P
D dilindeki bu zengin tip çeşitlerini kullanarak programlarınızda işlemlerinizi rahat bir şekilde gerçekleştirebilirsiniz. Bunun yanında herhangi bir tip için bilgi almak istediğinizde D yine sizin yardımınıza yetişecektir. D 'nin tipler için tanımladığı nitelikler sayesinde istediğiniz tipin bilgilerini öğrenebilirsiniz. Bu niteliklere ulaşabilmek için tip isminden sonra bir nokta ve nitelik ismini yazmanız yeterli. Kısaca bu olanaklar;
)

$(H6 $(C stringof))

$(P
İlgili tipin okunaklı ismidir. Örnegin: $(C int.stringof))

$(H6 $(C sizeof))

$(P
İlgili tipin bayt olarak uzunluğudur; tipin kaç bitten oluştuğunu hesaplamak için bu değeri bir bayttaki bit sayısı olan 8 ile çarpmak gerekir. Örneğin: $(C int.sizeof))

$(H6 $(C min))

$(P
İlgili tipin alabileceği en küçük değeri gösterir. Örneğin: $(C int.min)
)

$(H6 $(C max))

$(P
İlgili tipin alabileceği en büyük değeri gösterir. Örneğin: $(C int.max)
)

$(P
Bu nitelikleri kullanan örnek bir kod aşağıdaki gibi yazılabilir.
)

---
import std.stdio;

void main()
{
    writeln("Tip : ", int.stringof);
    writeln("Bayt olarak uzunluğu: ", int.sizeof);
    writeln("En küçük değeri : ", int.min);
    writeln("En büyük değeri : ", int.max);
}
---

$(P
D dilinde tipleri tanıtmaya çalıştım. Umarım D dilinin zenginliği sizi de etkilemiştir. D dili tipler yanında diğer pek çok özelliği ile ayrıca ilgi çekici ve güzel bir dildir. Umarım bu dile ilginiz artarak büyür.
)

Macros:
        SUBTITLE="D Dilindeki Tipleri Anlamak", Zafer Çelenk

        DESCRIPTION=Zafer Çelenk'in D'nin temel tiplerini tanıttığı yazısı.

        KEYWORDS=d programlama dili makale d zafer çelenk tip tür
