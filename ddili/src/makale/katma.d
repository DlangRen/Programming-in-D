Ddoc

$(H4 Dizgi Katmaları [mixin])


$(P
$(LINK2 http://www.dlang.org/template-mixin.html, $(I Şablon) katmalarına) hem isim olarak hem de işlev olarak benziyor olsalar da, $(I dizgi) katmaları farklı olanaklardır.
)

$(P
Dizgi katmaları, derleme zamanı dizgilerinin D kodu olarak derlenmelerini ve programa dahil edilmelerini sağlayan olanaktır. D'de dizgi işlemlerine derleme zamanında da izin verildiği için, bu iki olanak birleştirilince özel bir alana yönelik [domain-specific] diller oluşturulabilmektedir.
)

$(P
Örneğin belirtilen isim ve üyelerle yapı oluşturan bir şablon şöyle tanımlanabilir:
)

---
template YapıOluştur(char[] Yapı, char[] Üyeler)
{
    const char[] YapıOluştur =
                  "struct " ~ Yapı ~ "{ int " ~ Üyeler ~ "; }";
}

mixin(YapıOluştur!("Koordinat", "x, y"));
---

$(P
Bu $(CODE mixin)'in ürettiği kod şöyledir:
)

---
struct Koordinat { int x, y; }
---

$(P
ve programda sıradan bir D kodu gibi kullanılabilir:
)

---
void main()
{
    Koordinat k;
    k.x = 42;
    k.y = 7;

    writefln("%d,%d", k.x, k.y);
}
---

$(P
Yaptığı iş metin dönüştürmek ve o metni kod olarak derletmek olduğu için dizgi katmaları C önişlemcisi olanaklarına benzerler. Ama aralarında önemli farklar vardır:
)

$(UL
$(LI
C önişlemcisi sözcük çözümleme [lexical analysis] aşamasından $(B önce) çalışır. O yüzden C'nin sözcüklenmesi [lexing] ve ayrıştırılması [parsing] ancak bütün başlıkların eklenmesinden sonra olabilir; bütün klasörlerin içerikleri ve derleyici ayarları bilinmelidir. Katmalar ise anlamsal çözümleme [semantic analysis] aşamasında oluşurlar ve sözcükleme ve ayrıştırma aşamalarını etkilemezler. Sözcükleme ve ayrıştırma, çözümleme olmadan da yapılabilir.
)

$(LI
C önişlemcisi farklı gibi görünen söz dizimleri oluşturabilir:

$(C_CODE
#define BEGIN {
#define END   }

BEGIN
  int x = 3;
  foo(x);
END
)

$(P
Böyle bir şey katmalarda mümkün değildir. Katılan kodun yasal bildirimlerden, deyimlerden, ve ifadelerden oluşması gerekir.
)

)

$(LI
C makroları tanımlandıkları noktadan başlayarak kendi isimlerine uyan bütün kodu etkileyebilirler; o isimler iç kapsamlarda olsalar bile... C makroları kapsamlardan habersizdirler. Bu, $(I kod sağlığına) aykırı olarak kabul edilir. D katmaları ise normal dil kurallarına uyarlar ve bu açıdan sağlıklıdırlar.
)

$(LI
C önişlemcisi ifadelerinin söz dizimleri ve anlamları C dilinden farklıdır. C önişlemcisi ayrı bir dil olarak görülebilir. D'nin katmaları ise aynı dilin parçalarıdırlar.
)

$(LI
C önişlemcisinin C'nin $(CODE const) belirteçlerinden ve C++'nın şablonlarından haberi yoktur. D'nin katmalarında ise şablonlar ve $(CODE const) belirteçleri kullanılabilir.
)

)



Macros:
        SUBTITLE="Katmalar", Walter Bright

        DESCRIPTION=Dizgi sabitlerinin derleme zamanında D kodu olarak derlenmelerini sağlayan $(I katma) olanağı

        KEYWORDS=d programlama dili makale d tanıtım mixin dizgi katmaları