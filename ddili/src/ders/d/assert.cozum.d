Ddoc
$(COZUM_BOLUMU $(CH4 assert) İfadesi ve $(CH4 enforce))

$(OL

$(LI
Bu programı $(C 06:09) ve $(C 1:2) vererek çalıştırdığınızda hata atmadığını göreceksiniz. Buna rağmen, sonucun doğru olmadığını da farkedebilirsiniz:

$(SHELL
09:06'da başlayan ve 1 saat 2 dakika süren işlem
10:08'de sonlanır.)

$(P
Görüldüğü gibi, $(C 06:09) girildiği halde, çıkışa $(C 09:06) yazdırılmaktadır. Bu hata, bir sonraki problemde bir $(C assert) denetimi yardımıyla yakalanacak.
)

)

$(LI
Programa $(C 06:09) ve $(C 15:2) verildiğinde atılan hata, bizi şu satıra götürür:

---
string zamanDizgisi(in int saat, in int dakika) {
    $(HILITE assert((saat >= 0) && (saat <= 23));)
    // ...
}
---

$(P
Saat bilgisinin 0 ile 23 arasında bir değerde olmasını denetleyen bu $(C assert) denetiminin başarısız olması, ancak bu işlev programın başka yerinden yanlış $(C saat) değeriyle çağrıldığında mümkündür.
)

$(P
$(C zamanDizgisi) işlevinin çağrıldığı $(C sonucuYazdır) işlevine baktığımızda bir yanlışlık göremiyoruz:
)

---
void sonucuYazdır(
        in int başlangıçSaati, in int başlangıçDakikası,
        in int işlemSaati, in int işlemDakikası,
        in int bitişSaati, in int bitişDakikası) {
    writef("%s'%s başlayan",
           $(HILITE zamanDizgisi)(başlangıçSaati,
                        başlangıçDakikası),
           daEki(başlangıçDakikası));

    writef(" ve %s saat %s dakika süren işlem",
           işlemSaati,
           işlemDakikası);

    writef(" %s'%s sonlanır.",
           $(HILITE zamanDizgisi)(bitişSaati, bitişDakikası),
           daEki(bitişDakikası));

    writeln();
}
---

$(P
Bu durumda $(C sonucuYazdır) işlevini çağıran noktalardan şüphelenir ve onun programda $(C main) içinden ve tek bir noktadan çağrıldığını görürüz:
)

---
void $(CODE_DONT_TEST)main() {
    // ...
    $(HILITE sonucuYazdır)(başlangıçSaati, başlangıçDakikası,
                 işlemSaati, işlemDakikası,
                 bitişSaati, bitişDakikası);
}
---

$(P
Çağıran noktada da bir sorun yok gibi görünüyor. Biraz daha dikkat ve zaman harcayarak sonunda başlangıç zamanının ters sırada okunduğunu farkederiz:
)

---
    zamanOku("Başlangıç zamanı",
             başlangıç$(HILITE Dakikası),
             başlangıç$(HILITE Saati));
---

$(P
Programcının yaptığı o dikkatsizlik nedeniyle $(C 06:09) olarak girilen bilgi aslında $(C 09:06) olarak algılanmakta ve daha sonra buna $(C 15:2) süresi eklenmektedir. $(C zamanDizgisi) işlevindeki $(C assert) de saat değerini 24 olarak görür ve bu yüzden hata atılmasına neden olur.
)

$(P
Burada çözüm, başlangıç zamanının okunduğu noktada parametreleri doğru sırada yazmaktır:
)

---
    zamanOku("Başlangıç zamanı",
             başlangıçSaati,
             başlangıçDakikası);
---

$(P
Çıktısı:
)

$(SHELL
Başlangıç zamanı? (SS:DD) 06:09
İşlem süresi? (SS:DD) 15:2
06:09'da başlayan ve 15 saat 2 dakika süren işlem
21:11'de sonlanır.
)

)

$(LI
Bu seferki hata, $(C daEki) işlevindeki $(C assert) ile ilgili:

---
    assert(ek.length != 0);
---

$(P
O denetimin hatalı çıkması, $(I da) ekinin uzunluğunun 0 olduğunu, yani ekin boş olduğunu gösteriyor. Dikkat ederseniz, $(C 06:09) ve $(C 1:1) zamanlarını toplayınca sonuç $(C 07:10) olur. Yani bu sonucun dakika değerinin son hanesi 0'dır. $(C daEki) işlevine dikkat ederseniz, 0'ın hangi eki alacağı bildirilmemiştir. Çözüm, 0'ın $(C case) bloğunu da $(C switch) ifadesine eklemektir:
)

---
    case 6, 9, 0:
        ek = "da";
        break;
---

$(P
Bu hatayı da bir $(C assert) sayesinde yakalamış ve gidermiş olduk:
)

$(SHELL
Başlangıç zamanı? (SS:DD) 06:09
İşlem süresi? (SS:DD) 1:1
06:09'da başlayan ve 1 saat 1 dakika süren işlem
07:10'da sonlanır.
)

)

$(LI
Daha önce de karşılaştığımız $(C assert) yine doğru çıkmıyor:

---
    assert((saat >= 0) && (saat <= 23));
---

$(P
Bunun nedeni, $(C zamanEkle) işlevinin saat değerini 23'ten büyük yapabilmesidir. Bu işlevin sonuna, saat değerinin her zaman için 0 ve 23 aralığında olmasını sağlayan bir $(I kalan) işlemi ekleyebiliriz:
)

---
void zamanEkle(
        in int başlangıçSaati, in int başlangıçDakikası,
        in int eklenecekSaat, in int eklenecekDakika,
        out int sonuçSaati, out int sonuçDakikası) {
    sonuçSaati = başlangıçSaati + eklenecekSaat;
    sonuçDakikası = başlangıçDakikası + eklenecekDakika;

    if (sonuçDakikası > 59) {
        ++sonuçSaati;
    }

    $(HILITE sonuçSaati %= 24;)
}
---

$(P
Yukarıdaki işlevdeki diğer hatayı da görüyor musunuz? $(C sonuçDakikası) 59'dan büyük bir değer olduğunda $(C sonuçSaati) bir arttırılıyor, ama $(C sonuçDakikası)'nın değeri 59'dan büyük olarak kalıyor.
)

$(P
Belki de şu daha doğru bir işlev olur:
)

---
void zamanEkle(
        in int başlangıçSaati, in int başlangıçDakikası,
        in int eklenecekSaat, in int eklenecekDakika,
        out int sonuçSaati, out int sonuçDakikası) {
    sonuçSaati = başlangıçSaati + eklenecekSaat;
    sonuçDakikası = başlangıçDakikası + eklenecekDakika;

    $(HILITE sonuçSaati += sonuçDakikası / 60;)
    $(HILITE sonuçSaati %= 24;)

    $(HILITE assert((sonuçSaati >= 0) && (sonuçSaati <= 23));)
    $(HILITE assert((sonuçDakikası >= 0) && (sonuçDakikası <= 59));)
}
---

$(P
Aslında $(C sonuçDakikası) hâlâ hatalıdır çünkü ona da 60'tan kalanı atamak gerekir. Ama şimdi işin güzel tarafı, artık bu işlevin hatalı saat ve dakika değerleri üretmesi $(C assert) denetimleri nedeniyle olanaksızdır.
)

$(P
Yukarıdaki işlevi örneğin $(C 06:09) ve $(C 1:55) değerleriyle çağırırsanız, $(C sonuçDakikası)'nı denetleyen $(C assert) denetiminin hata vereceğini göreceksiniz.
)

)

$(LI
Burada sorun, son hanenin 0 olmasından kaynaklanıyor. Son hane sıfır olunca onlar hanesini de katarak "on", "kırk", "elli", vs. diye okuyunca 0'a verilmiş olan "da" eki her durumda doğru çalışmıyor. Bu problemin çözümünü size bırakıyorum.
)

)

Macros:
        SUBTITLE=assert İfadesi ve enforce

        DESCRIPTION=D dilinin kod varsayımlarını denetleyen olanağı assert ifadesi problem çözümleri

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial güvenlik kod güvenliği assert varsayım problem çözüm
