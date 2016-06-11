Ddoc

$(COZUM_BOLUMU İşlevler)

$(OL

$(LI

---
import std.stdio;

void menüyüGöster(string[] seçenekler, int ilkNumara) {
    foreach (i, seçenek; seçenekler) {
        writeln(' ', i + ilkNumara, ' ', seçenek);
    }
}

void main() {
    string[] seçenekler =
        [ "Siyah", "Kırmızı", "Yeşil", "Mavi", "Beyaz" ];
    menüyüGöster(seçenekler, 1);
}
---
)

$(LI
Bir kaç fikir:

$(UL

$(LI Yatay çizgi çizen $(C yatayÇizgiÇiz) adında bir işlev tanımlayın.)

$(LI Kare çizen $(C kareÇiz) adında bir işlev tanımlayın. Bu işlev $(C düşeyÇizgiÇiz) ve $(C yatayÇizgiÇiz) işlevlerinden yararlanabilir.)

$(LI Boyarken hangi karakteri kullanacaklarını çizim işlevlerine bir parametre olarak verin. Böylece her şekil farklı bir karakterle çizilebilir:

---
void benekKoy(Kağıt kağıt, int satır, int sütun$(HILITE, dchar boya)) {
    kağıt[satır][sütun] = $(HILITE boya);
}
---

)

)

)

)

Macros:
        SUBTITLE=İşlevler Dersi Çözümleri

        DESCRIPTION=D dilinde işlevler (fonksiyonlar) [functions] ders problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function çözüm
