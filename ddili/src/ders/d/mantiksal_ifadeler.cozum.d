Ddoc

$(COZUM_BOLUMU Mantıksal İfadeler)

$(OL

$(LI
 Derleyici $(C 10 < sayı)'yı bir ifade olarak tanıdığı için, ondan sonra bir virgül bekliyor. Bütün ifadenin etrafına parantezler koyulduğunda da sorun çözülmüyor, çünkü bu sefer de $(C 10 < sayı) ifadesinden sonra bir kapama parantezi bekliyor.
)

$(LI
 $(C (10 < sayı) < 20) şeklinde gruplama kullanıldığında derleme hatası olmaz, çünkü derleyici önce $(C 10 < sayı) ifadesini işletir, ondan sonra onun sonucunu $(C < 20) ile kullanır. $(C 10 < sayı) gibi bir mantıksal ifadenin sonucunun da ya $(C false) ya da $(C true) olduğunu biliyoruz.

$(P
$(C false) ve $(C true) değerleri tamsayı işlemlerinde kullanıldıklarında otomatik olarak 0 ve 1 değerlerine dönüşürler. (Otomatik tür dönüşümlerini daha sonra göreceğiz.) O yüzden de bütün ifade ya $(C 0 < 20) ya da $(C 1 < 20) haline gelir ve ikisinin sonucu da her zaman için $(C true)'dur.
)

)

$(LI
"Alt sınırdan büyüktür ve üst sınırdan küçüktür" mantıksal ifadesini şöyle kurarız:

---
    writeln("Arasında: ", (sayı > 10) && (sayı < 20));
---

)

$(LI
"Yeterince bisiklet var" ifadesini $(C kişi_sayısı <= bisiklet_sayısı) veya $(C bisiklet_sayısı >= kişi_sayısı) olarak yazabiliriz. Diğerleri de sorudaki ifade doğrudan D koduna çevrilerek yazılabilir:

---
    writeln("Plaja gidiyoruz: ",
            ((mesafe < 10) && (bisiklet_sayısı >= kişi_sayısı))
            ||
            ((kişi_sayısı <= 5) && araba_var && ehliyet_var)
           );
---

$(P
Okumayı kolaylaştırmak için $(C ||) işlecinin ayrı bir satıra yazıldığına dikkat edin. Böylece sorudaki iki koşulu temiz bir şekilde iki ayrı satırda görebiliyoruz.
)

)

)

Macros:
        SUBTITLE=Mantıksal İfadeler Problem Çözümleri

        DESCRIPTION=D.ershane D programlama dili dersi çözümleri: Mantıksal İfadeler

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial mantıksal ifadeler bool true false
