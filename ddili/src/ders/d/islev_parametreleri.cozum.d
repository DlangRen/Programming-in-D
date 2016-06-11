Ddoc

$(COZUM_BOLUMU İşlev Parametreleri)

$(P
Bu işlevin parametreleri kopyalanan türden olduklarından işlev içindeki değiş tokuş işlemi yalnızca bu kopyaları değiş tokuş eder.
)

$(P
Parametrelerin referans olarak gönderilmeleri gerekir:
)

---
void değişTokuş($(HILITE ref) int birinci, $(HILITE ref) int ikinci) {
    const int geçici = birinci;
    birinci = ikinci;
    ikinci = geçici;
}
---

$(P
Artık $(C main) içindeki değişkenler etkilenirler:
)

$(SHELL
2 1
)

$(P
Programdaki hatayla ilgisi olmasa da, bir kere ilklendikten sonra değeri değiştirilmeyeceğinden $(C geçici) de $(C const) olarak belirlenmiştir.
)


Macros:
        SUBTITLE=İşlev Parametreleri ve Tembel Değerlendirmeler

        DESCRIPTION=D dilinde işlev (fonksiyon) [function] parametrelerinin çeşitleri ile ilgili problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function parametre in out ref lazy const immutable problem çözüm
