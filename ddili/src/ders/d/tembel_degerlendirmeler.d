Ddoc

$(DERS_BOLUMU $(IX tembel işleç) Tembel İşleçler)

$(P
Tembel değerlendirmeler işlemlerin gerçekten gerekli oldukları zamana kadar geciktirilmeleri anlamına gelir. İngilizcesi "lazy evaluation" olan tembel değerlendirmeler Haskell gibi bazı programlama dillerinin de temel olanakları arasındadır.
)

$(P
İşlemlerin gerekene kadar geciktirilmeleri doğal olarak hız kazancı sağlayabilir çünkü belki de gerekmeyecek olan bir işlem için baştan zaman harcanmamış olur. Öte yandan, bir önceki bölümde de gördüğümüz gibi, $(C lazy) parametrelerin her erişildiklerinde tekrar hesaplanıyor olmaları zaman kaybına da neden olabilir. Bu olanak, dikkatli kullanıldığında ilginç programlama yöntemlerine olanak verir.
)

$(P
Tembel değerlendirmelere yakın olan bir kavram, işleçlere verilen ifadelerin duruma göre hiç işletilmiyor olmalarıdır. Bu kavramı daha önce gördüğümüz aşağıdaki işleçlerden tanıyorsunuz:
)

$(UL

$(LI $(IX ||, tembel değerlendirme) $(IX veya, mantıksal işleç) $(C ||) ($(I veya)) işleci: İkinci ifade ancak birincisi $(C false) olduğunda işletilir.

---
    if (birİfade() || belkiDeİşletilmeyecekOlanİfade()) {
        // ...
    }
---

$(P
Eğer $(C birİfade())'nin sonucu $(C true) ise, sonucun da $(C true) olacağı daha ikinci ifade işletilmeden bellidir. O durumda ikinci ifade işletilmez.
)

)

$(LI $(IX &&, tembel değerlendirme) $(IX ve, mantıksal işleç) $(C &&) ($(I ve)) işleci: İkinci ifade ancak birincisi $(C true) olduğunda işletilir.

---
    if (birİfade() && belkiDeİşletilmeyecekOlanİfade()) {
        // ...
    }
---

$(P
Eğer $(C birİfade())'nin sonucu $(C false) ise, sonucun da $(C false) olacağı daha ikinci ifade işletilmeden bellidir. O durumda ikinci ifade işletilmez.
)

)

$(LI $(IX ?:, tembel değerlendirme) $(IX üçlü işleç) $(C ?:) işleci (üçlü işleç): Koşul $(C true) olduğunda birinci ifade, $(C false) olduğunda ikinci ifade işletilir.

---
    int i = birKoşul() ? yaBuİfade() : yaDaBuİfade();
---

$(P
$(C birKoşul())'un sonucuna göre ifadelerden yalnızca birisi işletilir.
)

)

)

$(P
Bu işleçlerdeki tembellik yalnızca hız kazancıyla ilgili değildir. İfadelerden birisinin işletilmesi duruma göre hatalı olabilir.
)

$(P
Örneğin, aşağıdaki $(I baş harfi A ise) koşulu dizginin boş olma olasılığı varsa hatalıdır:
)

---
    dstring s;
    // ...
    if (s[0] == 'A') {
        // ...
    }
---

$(P
$(C s)'nin sıfır indeksli elemanına erişmeden önce öyle bir elemanın varlığından emin olmak gerekir. Bu yüzden aşağıdaki koşul yukarıdaki denetimi $(C &&) işlecinin sağ tarafına almakta ve böylece o denetimi ancak dizgi dolu olduğunda işletmektedir:
)

---
    if ((s.length >= 1) && (s[0] == 'A')) {
        // ...
    }
---

$(P
Tembel değerlendirmeler ilerideki bölümlerde göreceğimiz $(LINK2 /ders/d/kapamalar.html, işlev göstergeleri, temsilciler), ve $(LINK2 /ders/d/araliklar.html, aralıklarla) da sağlanabilir.
)

Macros:
        SUBTITLE=Tembel Değerlendirmeler

        DESCRIPTION=D dilinde tembel değerlendirmeler [lazy evaluation]

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function parametre tembel değerlendirme değerlendirmeler lazy evaluation

SOZLER=
$(deger)
$(fonksiyonel_programlama)
$(islev)
$(parametre)
$(tembel_degerlendirme)
