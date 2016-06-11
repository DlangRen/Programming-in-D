Ddoc

$(DERS_BOLUMU Atama ve İşlem Sıraları)

$(P
Programcılık öğrenirken karşılaşılan engellerden ilk ikisini bu bölümde göreceğiz.
)

$(H5 Atama işlemi)

$(P
Program içinde
)

---
    a = 10;
---

$(P
gibi bir satır gördüğünüzde bu, "a'nın değeri 10 olsun" demektir. Benzer şekilde, aşağıdaki satırın anlamı da "b'nin değeri 20 olsun" demektir:
)

---
    b = 20;
---

$(P
Bu bilgilere dayanarak o iki satırdan sonra aşağıdaki satırı gördüğümüzde ne düşünebiliriz?
)

---
    a = b;
---

$(P
Ne yazık ki matematikten alıştığımız kuralı burada uygulayamayız. O ifade, "a ile b eşittir" demek $(B değildir)! Baştaki iki ifadeyle aynı mantığı yürütünce, o ifadenin "a'nın değeri b olsun" demek olduğunu görürüz. "a'nın b olması" demek, "b'nin değeri ne ise, a'nın değeri de o olsun" demektir.
)

$(P
Matematikten alıştığımız $(C =) işareti programcılıkta bambaşka bir anlamda kullanılmaktadır: Sağ tarafın değeri ne ise, sol tarafın değerini de o yapmak.
)

$(H5 İşlem sıraları)

$(P
Programlarda işlemler adım adım ve belirli bir sırada uygulanırlar. Yukarıdaki üç ifadenin program içinde alt alta bulunduklarını düşünelim:
)

---
    a = 10;
    b = 20;
    a = b;
---

$(P
Onların toplu halde anlamları şudur: "a'nın değeri 10 olsun, $(I sonra) b'nin değeri 20 olsun, $(I sonra) a'nın değeri b'nin değeri olsun". Yani oradaki üç işlem adımından sonra hem a'nın hem de b'nin değerleri 20 olur.
)

$(PROBLEM_TEK

$(P
Aşağıdaki işlemlerin $(C a)'nın ve $(C b)'nin değerlerini değiş tokuş ettiklerini gözlemleyin. Eğer değerler başlangıçta sırasıyla 1 ve 2 iseler, işlemlerden sonra 2 ve 1 olurlar:
)

---
    c = a;
    a = b;
    b = c;
---

)

Macros:
        SUBTITLE=Atama ve İşlem Sıraları

        DESCRIPTION=Programcılık öğrenirken karşılaşılan ilk engellerden olan atama ve işlem sırası kavramlarının açıklanmaları

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial atama işlem sırası programcılık

MINI_SOZLUK=
