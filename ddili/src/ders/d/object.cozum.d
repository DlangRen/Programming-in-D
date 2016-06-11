Ddoc

$(COZUM_BOLUMU $(CH4 Object))

$(OL

$(LI
Eşitlik karşılaştırmasında öncelikle $(C sağdaki)'nin $(C null) olmadığına ve yalnızca $(C x) ve $(C y) üyelerine bakmak yeterli olur:

---
enum Renk { mavi, yeşil, kırmızı }

class Nokta {
    int x;
    int y;
    Renk renk;

// ...

    override bool opEquals(Object o) const {
        const sağdaki = cast(const Nokta)o;

        return (sağdaki &&
                (x == sağdaki.x) &&
                (y == sağdaki.y));
    }
}
---

)

$(LI
Sağdaki nesnenin türü de $(C Nokta) olduğunda önce $(C x)'e sonra $(C y)'ye göre karşılaştırılıyor:

---
class Nokta {
    int x;
    int y;
    Renk renk;

// ...

    override int opCmp(Object o) const {
        const sağdaki = cast(const Nokta)o;
        enforce(sağdaki);

        return (x != sağdaki.x
                ? x - sağdaki.x
                : y - sağdaki.y);
    }
}
---

)

$(LI
Aşağıdaki $(C opCmp) içinde tür dönüştürürken $(C const ÜçgenBölge) yazılamadığına dikkat edin. Bunun nedeni, $(C sağdaki)'nin türü $(C const ÜçgenBölge) olduğunda onun üyesi olan $(C sağdaki.noktalar)'ın da $(C const) olacağı ve $(C const) değişkenin $(C nokta.opCmp)'a parametre olarak gönderilemeyeceğidir. ($(C opCmp)'ın parametresinin $(C const Object) değil, $(C Object) olduğunu hatırlayın.)

---
class ÜçgenBölge {
    Nokta[3] noktalar;

    this(Nokta bir, Nokta iki, Nokta üç) {
        noktalar = [ bir, iki, üç ];
    }

    override bool opEquals(Object o) const {
        const sağdaki = cast(const ÜçgenBölge)o;
        return sağdaki && (noktalar == sağdaki.noktalar);
    }

    override int opCmp(Object o) const {
        $(HILITE auto) sağdaki = $(HILITE cast(ÜçgenBölge))o;
        enforce(sağdaki);

        foreach (i, nokta; noktalar) {
            immutable karşılaştırma =
                nokta.opCmp(sağdaki.noktalar[i]);

            if (karşılaştırma != 0) {
                /* Sıralamaları bu noktada belli oldu. */
                return karşılaştırma;
            }
        }

        /* Buraya kadar gelinmişse eşitler demektir. */
        return 0;
    }

    override size_t toHash() const {
        /* 'noktalar' üyesini bir dizi olarak tanımladığımız
         * için dizilerin toHash algoritmasından
         * yararlanabiliriz. */
        return typeid(noktalar).getHash(&noktalar);
    }
}
---

)

)


Macros:
        SUBTITLE=Object Problem Çözümleri

        DESCRIPTION=Object Problem Çözümleri

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial object problem çözüm
