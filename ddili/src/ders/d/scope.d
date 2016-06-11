Ddoc

$(DERS_BOLUMU $(IX scope(success)) $(IX scope(exit)) $(IX scope(failure)) $(CH4 scope))

$(P
Kesinlikle işletilmeleri gereken ifadelerin $(C finally) bloklarına, hatalı durumlarda işletilmeleri gereken ifadelerin de $(C catch) bloklarına yazıldıklarını bir önceki bölümde gördük. Bu blokların kullanımlarıyla ilgili bir kaç gözlemde bulunabiliriz:
)

$(UL

$(LI $(C catch) ve $(C finally) blokları $(C try) bloğu olmadan kullanılamaz.)

$(LI Bu bloklarda kullanılmak istenen bazı değişkenler o noktalarda geçerli olmayabilirler:

---
void birİşlev(ref int çıkış) {
    try {
        $(HILITE int birDeğer) = 42;

        çıkış += birDeğer;
        hataAtabilecekBirİşlev();

    } catch (Exception hata) {
        çıkış -= birDeğer;      $(DERLEME_HATASI)
    }
}
---

$(P
Yukarıdaki işlev, referans türündeki parametresinde değişiklik yapmakta ve hata atılması durumunda onu eski haline getirmeye çalışmaktadır. Ne yazık ki, $(C birDeğer) yalnızca $(C try) bloğu içinde tanımlı olduğu için bir derleme hatası alınır. $(I (Not: Yaşam süreçleriyle ilgili olan bu konuyu ilerideki bir bölümde tekrar değineceğim.))
)

)

$(LI Bir kapsamdan çıkılırken kesinlikle işletilmesi gereken ifadelerin hepsinin bir arada en aşağıdaki $(C finally) bloğuna yazılmaları, ilgili oldukları kodlardan uzakta kalacakları için istenmeyebilir.)

)

$(P
$(C catch) ve $(C finally) bloklarına benzer şekilde işleyen ve bazı durumlarda daha uygun olan olanak $(C scope) deyimidir. Üç farklı $(C scope) kullanımı, yine ifadelerin kapsamlardan çıkılırken kesinlikle işletilmeleri ile ilgilidir:
)

$(UL

$(LI $(C scope(success)): Kapsamdan başarıyla çıkılırken işletilecek olan ifadeleri belirler.)

$(LI $(C scope(failure)): Kapsamdan hatayla çıkılırken işletilecek olan ifadeleri belirler.)

$(LI $(C scope(exit)): Kapsamdan başarıyla veya hatayla çıkılırken işletilecek olan ifadeleri belirler.)
)

$(P
Bu deyimler yine atılan hatalarla ilgili olsalar da $(C try-catch) bloklarının parçası değillerdir.
)

$(P
Örneğin, hata atıldığında $(C çıkış)'ın değerini düzeltmeye çalışan yukarıdaki işlevi bir $(C scope(failure)) deyimiyle daha kısa olarak şöyle yazabiliriz:
)

---
void birİşlev(ref int çıkış) {
    int birDeğer = 42;

    çıkış += birDeğer;
    $(HILITE scope(failure)) çıkış -= birDeğer;

    hataAtabilecekBirİşlev();
}
---

$(P
Yukarıdaki $(C scope) deyimi, kendisinden sonra yazılan ifadenin işlevden hata ile çıkıldığı durumda işletileceğini bildirir. Bunun bir yararı, yapılan bir değişikliğin hatalı durumda geri çevrilecek olduğunun tam da değişikliğin yapıldığı yerde görülebilmesidir.
)

$(P
$(C scope) deyimleri bloklar halinde de bildirilebilirler:
)

---
    scope(exit) {
        // ... çıkarken işletilecek olan ifadeler ...
    }
---

$(P
Bu kavramları deneyen bir işlevi şöyle yazabiliriz:
)

---
void deneme() {
    scope(exit) writeln("çıkarken 1");

    scope(success) {
        writeln("başarılıysa 1");
        writeln("başarılıysa 2");
    }

    scope(failure) writeln("hata atılırsa 1");
    scope(exit) writeln("çıkarken 2");
    scope(failure) writeln("hata atılırsa 2");

    yüzdeElliHataAtanİşlev();
}
---

$(P
İşlevin çıktısı, hata atılmayan durumda yalnızca $(C scope(exit)) ve $(C scope(success)) ifadelerini içerir:
)

$(SHELL
çıkarken 2
başarılıysa 1
başarılıysa 2
çıkarken 1
)

$(P
Hata atılan durumda ise $(C scope(exit)) ve $(C scope(failure)) ifadelerini içerir:
)

$(SHELL
hata atılırsa 2
çıkarken 2
hata atılırsa 1
çıkarken 1
object.Exception: hata mesajı
)

$(P
Çıktılardan anlaşıldığı gibi, $(C scope) deyimlerinin ifadeleri ters sırada işletilmektedir. Bunun nedeni, daha sonra gelen kodların daha önceki değişkenlerin durumlarına bağlı olabilecekleridir. $(C scope) deyimlerindeki ifadelerinin ters sırada işletilmeleri programın durumunda yapılan değişikliklerin geri adımlar atılarak ters sırada işletilmelerini sağlar.
)

Macros:
        SUBTITLE=scope

        DESCRIPTION=Kapsamlardan çıkılırken işletilmesi gereken ifadeler için kullanılan scope(success), scope(failure), ve scope(exit) deyimleri.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial scope

SOZLER=
$(blok)
$(deyim)
$(hata_atma)
$(ifade)
$(kapsam)
