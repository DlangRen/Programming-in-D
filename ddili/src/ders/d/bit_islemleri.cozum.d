Ddoc

$(COZUM_BOLUMU Bit İşlemleri)

$(OL

$(LI IPv4 adreslerinin her zaman 4 parçadan oluştuğu bilindiğinden bu kadar kısa bir işlevde sihirli sabitler kullanılabilir. Bunun nedeni, aksi taktirde aralara nokta karakterlerinin yerleştirilmesinin ek bir karmaşıklık getireceğidir.


---
string noktalıOlarak(uint ipAdresi) {
    return format("%s.%s.%s.%s",
                  (ipAdresi >> 24) & 0xff,
                  (ipAdresi >> 16) & 0xff,
                  (ipAdresi >>  8) & 0xff,
                  (ipAdresi >>  0) & 0xff);
}
---

$(P
Kullanılan tür işaretsiz bir tür olduğu için soldan her zaman için 0 değerli bitler geleceğini hatırlarsak, 24 bit kaydırıldığında ayrıca maskelemeye gerek yoktur. Ek olarak, sıfır kere kaydırmanın da hiçbir etkisi olmadığından o işlevi biraz daha kısa olarak yazabiliriz:
)

---
string noktalıOlarak(uint ipAdresi) {
    return format("%s.%s.%s.%s",
                   ipAdresi >> 24,
                  (ipAdresi >> 16) & 0xff,
                  (ipAdresi >>  8) & 0xff,
                   ipAdresi        & 0xff);
}
---

$(P
Buna rağmen daha okunaklı olduğu için birinci işlev yeğlenebilir çünkü etkisiz olan işlemler bazı durumlarda zaten derleyici tarafından elenebilir.
)

)

$(LI Her bayt IPv4 adresinde bulunduğu yere kaydırılabilir ve bu değerler "$(I veya)"lanabilir:

---
uint ipAdresi(ubyte bayt3,    // en yüksek değerli bayt
              ubyte bayt2,
              ubyte bayt1,
              ubyte bayt0) {  // en düşük değerli bayt
    return
        (bayt3 << 24) |
        (bayt2 << 16) |
        (bayt1 <<  8) |
        (bayt0 <<  0);
}
---

)

$(LI Aşağıdaki yöntem bütün bitlerin 1 olduğu değerle başlıyor. Önce bitleri sağa kaydırarak üst bitlerin 0 olmalarını, daha sonra da sola kaydırarak alt bitlerin 0 olmalarını sağlıyor:

---
uint maskeYap(int düşükBit, int uzunluk) {
    uint maske = uint.max;
    maske >>= (uint.sizeof * 8) - uzunluk;
    maske <<= düşükBit;
    return maske;
}
---

$(P
$(C uint.max), bütün bitlerin 1 olduğu değerdir. Onun yerine 0 değerinin tümleyeni de kullanılabilir:
)

---
    uint maske = ~0;
    // ...
---

)

)

Macros:
        SUBTITLE=Bit İşlemleri Problem Çözümleri

        DESCRIPTION=Bit İşlemleri Problem Çözümleri

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial bit işlemleri problem çözüm
