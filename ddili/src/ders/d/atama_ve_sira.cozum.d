Ddoc

$(COZUM_BOLUMU Atama ve İşlem Sıraları)

$(P
$(C a), $(C b), ve $(C c)'nin değerlerini her işlem adımının sağ tarafında ve değişen değeri sarı ile işaretleyerek gösteriyorum:
)

$(MONO
başlangıçta    →     a 1, b 2, c önemsiz
c = a          →     a 1, b 2, $(HILITE c 1)
a = b          →     $(HILITE a 2), b 2, c 1
b = c          →     a 2, $(HILITE b 1), c 1
)

$(P
Sonuçta $(C a) ve $(C b)'nin değerleri değiş tokuş edilmişlerdir.
)

Macros:
        SUBTITLE=Atama ve İşlem Sıraları Problem Çözümü

        DESCRIPTION=Atama ve işlem sıraları bölümü problem çözümü

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial atam ve işlem sıraları problem çözüm
