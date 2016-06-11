Ddoc

$(COZUM_BOLUMU Standart Akımları Dosyalara Bağlamak)

$(P
Programların giriş ve çıkışlarının birbirlerine bağlanabilmeleri özellikle Unix türevi işletim sistemlerinde çok kullanılır. Buna olanak vermek için, programların olabildiğince standart giriş ve çıkış akımlarıyla etkileşecek şekilde yazılmalarına çalışılır.
)

$(P
Örneğin ismi $(C deneme.d) olan bir dosyanın hangi klasörde olduğu $(C find) ve $(C grep) programları ile şu şekilde bulunabilir:
)

$(SHELL
find | grep deneme.d
)

$(P
$(C find), içinde bulunulan klasörden itibaren bütün klasörlerin içindeki bütün dosyaların isimlerini çıkışına gönderir. Onun çıktısı $(C |) ile $(C grep)'e verilir ve o da içinde $(C deneme.d) bulunan satırları kendi çıkışına yazdırır.
)


Macros:
        SUBTITLE=Standart Akımları Dosyalara Bağlamak Problem Çözümü

        DESCRIPTION=Standart Akımları Dosyalara Bağlamak Bölümü Problem Çözümü

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial standart giriş çıkış dosya bağlamak yönlendirmek problem çözüm
