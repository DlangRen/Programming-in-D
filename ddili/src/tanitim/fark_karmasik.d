Ddoc

$(H4 Karmaşık Sayı Türleri ve C++'nın std::complex'i)

$(ESKI_KARSILASTIRMA)

$(P
Bu sayfadaki bilgiler digitalmars.com sitesindeki eski bir yazıdan alınmıştır
)

$(H6 Yazım güzelliği)

$(P
C++'ta karmaşık sayı türleri şunlardır:
)

$(C_CODE
complex&lt;float&gt;
complex&lt;double&gt;
complex&lt;long double&gt;
)

$(P
C++'da sanal [imaginary] türler yoktur. D'de 3 karmaşık türe ek olarak 3 tane de sanal tür vardır:
)

---
cfloat
cdouble
creal
ifloat
idouble
ireal
---

$(P
C++'nın karmaşık sayıları aritmetik sabitlerle etkileşebilirler, ama sanal değer kavramı olmadığı için sanal değerler eklemek için kurucu fonksiyon kullanmak gerekir:
)

$(C_CODE
complex&lt;long double&gt; a = 5;                // a = 5 + 0i
complex&lt;long double&gt; b(0,7);               // b = 0 + 7i
c = a + b + complex&lt;long double&gt;(0,7);     // c = 5 + 14i
)

$(P
D'de sanal değer sabitlerinin sonuna $(CODE i) karakteri eklenir. Yukarıdaki kodun eşdeğeri şudur:
)

---
creal a = 5;                  // a = 5 + 0i
ireal b = 7i;                 // b = 7i
c = a + b + 7i;               // c = 5 + 14i
---

$(P
İçinde sabitlerin de olduğu daha uzun bir ifade:
)
---
c = (6 + 2i - 1 + 3i) / 3i;
---

$(P
C++'da şöyle yazılır:
)

$(C_CODE
c = (complex&lt;double&gt;(6,2) + complex&lt;double&gt;(-1,3))
                                        / complex&lt;double&gt;(0,3);
)

$(P
veya C++'ya da bir sanal tür eklenmiş olsaydı şöyle:
)

$(C_CODE
c = (6 + imaginary&lt;double&gt;(2) - 1 + imaginary&lt;double&gt;(3))
                                        / imaginary&lt;double&gt;(3);
)

$(P
Kısacası, D'de nn gibi bir $(I sanal değer) $(CODE nni) olarak yazılabilir; $(CODE complex&lt;long&nbsp;double&gt;(0,nn)) şeklinde nesne oluşturmaya gerek yoktur.
)

$(H6 İşlemlerin etkinliği)

$(P
C++'da sanal sayı türünün olmaması, 0 gerçel sayısının da işlemlerde gereksizce kullanılmasına neden olur. Örneğin D'de iki sanal değerin toplamı tek bir toplama işleminden oluşur:
)

---
ireal a, b, c;
c = a + b;
---

$(P
C++'da ise gerçel kısımlarının da toplandığı iki toplama işlemidir:
)

$(C_CODE
c.re = a.re + b.re;
c.im = a.im + b.im;
)

$(P
Durum çarpma işleminde daha da kötüdür: tek bir çarpma işlemi yerine 4 çarpma ve 2 toplama işlemi:
)

$(C_CODE
c.re = a.re * b.re - a.im * b.im;
c.im = a.im * b.re + a.re * b.im;
)

$(P
En kötüsü de bölme işlemidir: D'deki tek bir bölme işlemi yerine, C++'da normal bir gerçekleştirmede 1 karşılaştırma, 3 bölme, 3 çarpma, ve 3 toplama işlemi vardır:
)

$(C_CODE
if (fabs(b.re) < fabs(b.im))
{
    r = b.re / b.im;
    den = b.im + r * b.re;
    c.re = (a.re * r + a.im) / den;
    c.im = (a.im * r - a.re) / den;
}
else
{
    r = b.im / b.re;
    den = b.re + r * b.im;
    c.re = (a.re + r * a.im) / den;
    c.im = (a.im - r * a.re) / den;
}
)

$(P
Bu yavaşlıkları önlemek için sanal değer yerine C++'da $(CODE double) kullanılabilir. Örneğin D'deki şu kod:
)

---
cdouble c;
idouble im;
c *= im;
---

$(P
sanal kısım için $(CODE double) kullanılarak C++'da şöyle yazılabilir:
)

$(C_CODE
complex&lt;double&gt; c;
double im;
c = complex&lt;double&gt;(-c.imag() * im, c.real() * im);
)

$(P
Ama onun sonucunda da aritmetik işlemlerle kullanılabilen bir kütüphane türü kolaylığını artık geride bırakmış oluruz.
)

$(H6 Anlam)

$(P
Bütün bunların en kötüsü, sanal değer türünün eksikliği nedeniyle istemeden yanlış sonuçlar elde edilebilmesidir. $(LINK2 http://www.cs.berkeley.edu/~wkahan/, Prof. Kahan)'dan bir alıntı:
)

$(QUOTE
$(P
Fortran'da ve C/C++ derleyicileriyle gelen kütüphanelerde gereken karmaşık sayı fonksiyonları $(CODE SQRT) ve $(CODE LOG), eğer IEEE 754 aritmetik işlemlerinde $(CODE 0.0)'ın işaretini gözardı edecek şekilde gerçekleştirilirlerse, karmaşık sayı $(CODE z)'nin negatif gerçel değer aldığı durumlarda artık
)

$(C_CODE
SQRT( CONJ( Z ) ) = CONJ( SQRT( Z ) )
)

$(P
ve
)

$(C_CODE
LOG( CONJ( Z ) ) = CONJ( LOG( Z ) )
)

$(P
eşitlikleri sağlanamaz. Karmaşık sayı aritmetiğinde işlemlerin gerçel ve sanal sayıların $(CODE x + i*y) şeklindeki soyutlamaları yerine (x, y) gibi çiftler üzerinde yapıldıkları durumlarda bu tür bozuklukların önüne geçmek imkansızdır. Karmaşık sayı işlemlerinde çiftlerin kullanılması $(I yanlıştır); bir sanal türe ihtiyaç vardır.
)
)

$(P
Buradaki anlamsal sorunlar şunlardır:
)

$(UL
$(LI
$(CODE (sonsuz + i)) sonucunu veren $(CODE (1 - sonsuz*i) * i) formülünü ele alalım. Burada ikinci çarpan tek başına $(CODE i) olmak yerine $(CODE (0 + i)) olursa, sonuç $(CODE (sonsuz + NaN*i)) haline gelir; yani yanlış bir NaN oluşmuş olur. $(I [Çevirenin notu: "not a number"'ın kısaltması olan NaN, geçersiz sayı değerlerini ifade eder.])
)

$(LI
Ayrı bir sanal tür, 0'ın işaretini de taşıyabilir; bunlar $(I branch cut)'larla ilgili hesaplarda gerekirler.
)

)

$(P
C99 standardının Appendix G bölümü bu sorunla ilgili olarak bazı tavsiyelerde bulunur. Ancak o tavsiyeler C++98 standardına dahil olmadıklarından taşınabilirliklerine güvenilemez.
)

$(H6 Kaynaklar)

$(UL
$(LI
$(LINK2 http://www.cs.berkeley.edu/~wkahan/JAVAhurt.pdf, How Java's Floating-Point Hurts Everyone Everywhere), Prof. W. Kahan and Joseph D. Darcy
)

$(LI
$(LINK2 http://www.cs.berkeley.edu/~wkahan/Curmudge.pdf, The Numerical Analyst as Computer Science Curmudgeon), Prof. W. Kahan
)

$(LI
"Branch Cuts for Complex Elementary Functions, or Much Ado About Nothing's Sign Bit" by W. Kahan, ch. 7 in The State of the Art in Numerical Analysis (1987) ed. by M. Powell and A. Iserles for Oxford U.P.
)
)

Macros:
        SUBTITLE=İç Olanak veya Kütüphane

        DESCRIPTION=D programlama dili olanaklarının dil içinde mi yoksa kütüphanelerde mi gerçekleştirildikleri

        KEYWORDS=d programlama dili tanıtım bilgi iç olanak kütüphane gerçekleştirme
