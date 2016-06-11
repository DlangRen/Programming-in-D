Ddoc

$(DERS_BOLUMU $(IX işleç öncelikleri) $(IX öncelik, işleç) İşleç Öncelikleri)

$(P
Kitabın başından beri yaptığımız gibi, ikiden fazla ifade birden fazla işleç ile bir araya getirilebilir. Örneğin, aşağıdaki satır üç işleç ile bağlanmış olan dört ifade içerir:
)

---
    a = b + c * d    // üç işleç: =, +, ve *
---

$(P
İşleçlerin öncelik kuralları, birden fazla işleç bulunan durumda o işleçlerin hangi sırada işletileceklerini ve hangi ifadeleri kullanacaklarını belirler. İşleçler önceliklerine göre işletilirler: önce yüksek öncelikli olanlar, sonra düşük öncelikli olanlar.
)

$(P
Aşağıdaki tablo D'nin işleç önceliklerini yüksek öncelikliden düşük öncelikliye doğru sıralanmış olarak verir. Aynı tablo satırında bulunan işleçler aynı önceliğe sahiptir. (Aynı tablo hücresi içindeki satırların önemi yoktur; örneğin, $(C ==) ile $(C !is) aynı önceliğe sahiptir.) Özellikle belirtilmediği sürece bütün işleçler $(I sol birleşimlidir).
)

$(P
Tabloda kullanılan terimlerin bazıları aşağıda açıklanıyor.
)

<table class="full" border="1" cellpadding="4" cellspacing="0">

<col width="25%"/>
<col width="28%"/>
<col width="47%"/>

<th scope="col">İşleçler</th>
<th scope="col">Açıklama</th>
<th scope="col">Notlar</th>

<tr>

<td> $(C !)           </td>
<td class="serif">Şablon gerçekleştirmesi</td>
<td class="serif">Zincirlenemez
</td></tr>
<tr>

<td> $(C =&gt;)          </td>
<td class="serif">İsimsiz işlev tanımı</td>
<td class="serif">Gerçek bir işleç değildir; tabloda iki yerde bulunur; bu satır $(I sol) tarafıyla ilgilidir
</td></tr>
<tr>

<td> $(C . ++ -- $(PARANTEZ_AC) [) </td>
<td class="serif">Sonek işleçler</td>
<td class="serif">$(C $(PARANTEZ_AC)) ve $(C [) parantezleri sırasıyla $(C $(PARANTEZ_KAPA)) ve $(C ]) ile kapatılmalıdır
</td></tr>
<tr>

<td> $(C ^^)          </td>
<td class="serif">Üs alma işleci</td>
<td class="serif">Sağ birleşimli
</td></tr>
<tr>

<td> $(C ++ -- * + - ! &amp; ~ cast) </td>
<td class="serif">Tekli işleçler</td>
<td class="serif">
</td></tr>
<tr>

<td> $(C * / %)       </td>
<td class="serif">İkili işleçler</td>
<td class="serif">
</td></tr>
<tr>

<td> $(C + - ~)       </td>
<td class="serif">İkili işleçler</td>
<td class="serif"></td>

</tr>
<tr>

<td> $(C &lt;&lt; &gt;&gt; &gt;&gt;&gt;)   </td>
<td class="serif">Bit kaydırma işleçleri</td>
<td class="serif">
</td></tr>
<tr>

<td>$(C == != &gt; &lt; &gt;= &lt;= !&gt; !&lt; !&gt;= !&lt;= &lt;&gt; !&lt;&gt; &lt;&gt;= !&lt;&gt;= in !in is !is) </td>
<td class="serif">Karşılaştırma işleçleri</td>
<td class="serif">Bit işleçleri ile aralarında öncelik tanımlı değildir; Zincirlenemezler
</td></tr>
<tr>

<td> $(C &amp;)           </td>
<td class="serif">Bit işlemi $(I ve)</td>
<td class="serif">Karşılaştırma işleçleri ile aralarında öncelik tanımlı değildir
</td></tr>
<tr>

<td> $(C ^)           </td>
<td class="serif">Bit işlemi $(I ya da)</td>
<td class="serif">Karşılaştırma işleçleri ile aralarında öncelik tanımlı değildir
</td></tr>
<tr>

<td> $(C |)           </td>
<td class="serif">Bit işlemi $(I veya)</td>
<td class="serif">Karşılaştırma işleçleri ile aralarında öncelik tanımlı değildir
</td></tr>
<tr>

<td> $(C &amp;&amp;)          </td>
<td class="serif">Mantıksal $(I ve)</td>
<td class="serif">İkinci ifade işletilmeyebilir</td>

</tr>
<tr>

<td>$(C ||)</td>
<td class="serif">Mantıksal $(I veya)</td>
<td class="serif">İkinci ifade işletilmeyebilir</td>

</tr>
<tr>

<td>$(C ?:)</td>
<td class="serif">Üçlü işleç</td>
<td class="serif">Sağ birleşimli
</td></tr>
<tr>

<td>$(C = -= += = *= %= ^= ^^= ~= &lt;&lt;= &gt;&gt;= &gt;&gt;&gt;=)
 </td>
<td class="serif">Atamalı işleçler</td>
<td class="serif">Sağ birleşimli
</td></tr>
<tr>

<td> $(C =&gt;)          </td>
<td class="serif">İsimsiz işlev tanımı</td>
<td class="serif">Gerçek bir işleç değildir; tabloda iki yerde bulunur; bu satır $(I sağ) tarafıyla ilgilidir</td>
</tr>
<tr>

<td> $(C ,)           </td>
<td class="serif">Virgül işleci</td>
<td class="serif">Ayraç olarak kullanılan virgül ile karıştırılmamalıdır</td>

</tr>
<tr>

<td> $(C ..)          </td>
<td class="serif">Sayı aralığı</td>
<td class="serif">Gerçek bir işleç değildir; söz diziminin özel bir parçasıdır
</td></tr>
</table>


$(H6 $(IX işleç zincirleme) $(IX zincirleme, işleç) İşleç zincirleme)

$(P
Bölümün başındaki ifadeye tekrar bakalım:
)

---
    a = b + c * d
---

$(P
İkili $(C *) işlecinin önceliği ikili $(C +) işlecininkinden ve ikili $(C +) işlecinin önceliği $(C =) işlecininkinden yüksek olduklarından o ifade aşağıdaki parantezli eşdeğeri gibi işletilir:
)

---
    a = (b + (c * d))    // önce *, sonra +, sonra =
---

$(P
Başka bir örnek olarak, sonek $(C .) işlecinin önceliği tekli $(C *) işlecininkinden yüksek olduğundan aşağıdaki ifade önce $(C n) nesnesinin $(C gösterge) üyesine erişir, sonra da onun gösterdiğine:
)

---
    *n.gösterge      // ← n.gösterge'nin gösterdiğine erişir
    *(n.gösterge)    // ← üsttekinin eşdeğeri
    (*n).gösterge    $(CODE_NOTE_WRONG üsttekinin eşdeğeri DEĞİL)
---

$(P
Bazı işleçler zincirlenemezler:
)

---
    if (a > b == c) {      $(DERLEME_HATASI)
        // ...
    }
---

$(SHELL
Error: found '==' when expecting '$(PARANTEZ_KAPA)'
)

$(P
İşlem sırasını programcının örneğin parantezlerle belirtmesi gerekir:
)

---
    if ((a > b) == c) {    $(CODE_NOTE derlenir)
        // ...
    }
---

$(H6 $(IX sol birleşimli) $(IX sağ birleşimli) $(IX birleşim, işleç önceliği) $(IX işleç birleşimi) Birleşim)

$(P
Aynı önceliğe sahip işleçler bulunduğunda hangisinin önce işletileceği işleç birleşimlerine göre belirlenir: ya soldaki ya da sağdaki.
)

$(P
Çoğu işleç sol birleşimlidir; önce soldaki işletilir:
)

---
    10 - 7 - 3;
    (10 - 7) - 3;    $(CODE_NOTE üsttekinin eşdeğeri (== 0))
    10 - (7 - 3);    $(CODE_NOTE_WRONG üsttekinin eşdeğeri DEĞİL (== 6))
---

$(P
Bazı işleçler sağ birleşimlidir; önce sağdaki işletilir:
)

---
    4 ^^ 3 ^^ 2;
    4 ^^ (3 ^^ 2);    $(CODE_NOTE üsttekinin eşdeğeri (== 262144))
    (4 ^^ 3) ^^ 2;    $(CODE_NOTE_WRONG üsttekinin eşdeğeri DEĞİL (== 4096))
---

$(H6 Öncelikleri tanımsız işleç grupları)

$(P
Bit işleçleriyle karşılaştırma işleçleri arasında öncelik tanımlı değildir:
)

---
    if (a & b == c) {      $(DERLEME_HATASI)
        // ...
    }
---

$(SHELL
Error: b == c must be parenthesized when next to operator &
)

$(P
İşlem sırasını programcının örneğin parantezlerle belirtmesi gerekir:
)

---
    if ((a & b) == c) {    $(CODE_NOTE derlenir)
        // ...
    }
---

$(H6 $(IX =>, işleç önceliği) $(C =>) işaretinin önceliği)

$(P
Aslında bir işleç olmayan $(C =>), solundaki ve sağındaki işleçlerle farklı önceliklere sahip olduğundan tabloda iki satırda yer alır.
)

---
    l = a => a = 1;
---

$(P
Yukarıda $(C =>) işaretinin her iki tarafında da $(C =) işleci olduğu halde, $(C =>) sol tarafta $(C =) işlecinden daha öncelikli olduğundan soldaki $(C a)'ya kendisi bağlanır ve sanki programcı aşağıdaki parantezleri yazmış gibi kabul edilir:
)

---
    l = (a => a = 1);
---

$(P
Öte yandan, $(C =>) sağ tarafta $(C =) işlecinden daha düşük öncelikli olduğundan, sağdaki $(C a) $(C =) işlecine bağlanır ve sanki aşağıdaki parantezler de yazılmış gibi kabul edilir:
)

---
    l = (a => $(HILITE $(PARANTEZ_AC))a = 1$(HILITE $(PARANTEZ_KAPA)));
---

$(P
Dolayısıyla, isimsiz işlevin tanımı $(C a&nbsp;=>&nbsp;a) haline $(I gelmez); ifadenin geri kalanını da içerir: $(C a&nbsp;=>&nbsp;a&nbsp;=&nbsp;1) (anlamı: $(I a'ya karşılık a = 1 değerini üret)). O isimsiz işlev de sonuçta $(C l) değişkenine atanmaktadır.
)

$(P
$(I Not: Bunu yalnızca bir örnek olarak kabul edin. $(C a&nbsp;=&nbsp;1) ifadesi bir isimsiz işlevin içeriği olarak anlamlı değildir çünkü parametresine yapılan o atama normalde etkisizdir ve işlev hep 1 değerini üretir. (Burada "normalde" denmesinin nedeni, aslında $(C a)'nın atama işlecinin yüklenmiş olabileceği ve işletildiğinde yan etki üretebileceğidir.))
)

$(H6 $(IX , (virgül), işleç) $(IX virgül işleci) Virgül işleci)

$(P
Virgül işleci ikili bir işleçtir. Önce sol tarafındaki ifadeyi sonra sağ tarafındaki ifadeyi işletir. Sol tarafın ürettiği değer göz ardı edilir ama sağ tarafın değeri virgül işlecinin değeri olarak kullanılır:
)

---
    int a = 1;
    int b = (foo()$(HILITE ,) bar()$(HILITE ,) ++a + 10);

    assert(a == 2);
    assert(b == 12);
---

$(P
Yukarıdaki iki virgül işleci üç ifadeyi bağlamaktadır. İlk iki ifade ($(C foo()) ve $(C bar())) işletildikleri halde, onların değerleri kullanılmaz ve virgül işlecinin değeri son ifadenin ($(C ++a + 10)) değeri olur.
)

Macros:
        SUBTITLE=İşleç Öncelikleri

        DESCRIPTION=D işleçlerinin öncelikleri ve birleşimleri (sol veya sağ)

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işleç öncelik birleşim

SOZLER=
$(ifade)
$(isimsiz_islev)
$(islec)
$(islec_birlesimi)
$(sonek_islec)
