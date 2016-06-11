Ddoc

$(H4 Düzenli İfadeler [Regular Expressions])

$(P
  $(B Çeviren:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Tarih:) 14 Temmuz 2009
)

$(P
Düzenli ifadeler, metinlerin belirli bir $(I desene) uyanlarını bulmaya ve eşleştirmeye yarayan çok güçlü araçlardır. Düzenli ifadeler Perl, Ruby, Javascript gibi dillerin iç olanaklarıdırlar ve özellikle Perl ve Ruby'de son derece beceriklidirler. Peki düzenli ifadeler D'de neden dilin iç olanakları arasında değildir? Aşağıda düzenli ifadelerin D'de Ruby'den ne farklılıklar gösterdiğini bulacaksınız.
)

$(P
Bu makale düzenli ifadelerin D'de nasıl kullanıldıklarını gösterir ama düzenli ifadelerin ne olduklarını anlatmaz. Ne de olsa salt düzenli ifadeleri kapsayan kitaplar yazılmıştır. D'nin düzenli ifadeler olanağı bütünüyle Phobos kütüphanesinin $(LINK2 http://www.dlang.org/phobos/std_regex.html, std.regex) modülünde tanımlanmıştır. Düzenli ifadelerin şablonlarla bağıntılı olarak ileri düzey kullanımlarını görmek için $(LINK2  http://www.dlang.org/templates-revisited.html, Templates Revisited) yazısını da okuyabilirsiniz.
)

$(P
Düzenli ifadeler Ruby'de özel dizgi sabitleri olarak oluşturulurlar:
)

$(C_CODE
r = /desen/
s = /p[1-5]\s*/
)

$(P
D'de özel sabitler olarak değil, nesne olarak oluşturulurlar:
)

---
r = RegExp("desen");
s = RegExp(r"p[1-5]\s*");
---

$(P
Desen içindeki $(CODE \) karakterlerinin C'de olduğu gibi çift olarak yazılmaları gerekmez; başlarındaki $(CODE r) karakteriyle belirtilen $(I wysiwyg) dizgiler ("sonuç gördüğünle aynıdır" anlamında) kullanılabilir. Bu kodda $(CODE r) ve $(CODE s) nesnelerinin türü $(CODE RegExp)'tir ama türleri otomatik olarak da belirlenebilir:
)

---
auto r = RegExp("desen");
auto s = RegExp(r"p[1-5]\s*");
---

$(P
Bir düzenli ifadenin bir $(CODE s) dizgisine uygunluğunu Ruby'de bulmak için $(CODE =~) işleci kullanılır. Bu işleç, aranan desenin dizgi içinde uyduğu ilk yerin indeksini döndürür:
)

$(C_CODE
s = "abcabcabab"
s =~ /b/   /* uyar, 1 döndürür */
s =~ /f/   /* uymaz, nil döndürür */
)

$(P
Bunun D'deki eşdeğeri şöyledir:
)

---
auto s = "abcabcabab";
std.regexp.find(s, "b");    /* uyar, 1 döndürür */
std.regexp.find(s, "f");    /* uymaz, -1 döndürür */
---

$(P
Bunun $(CODE std.string.find)'a benzerliğine dikkat edin: $(CODE std.string.find)'ın farkı, düzenli ifadeye uyan kısmı değil, bir alt dizgiyi bulmasıdır.
)

$(P
Ruby'nin $(CODE =~) işleci, aramanın sonuçlarını gösteren bazı özel değişkenleri otomatik olarak tanımlar:
)

$(C_CODE
s = "abcdef"
if s =~ /c/
    "#{$`}[#{$&}]#{$'}"   /* "ab[c]def" dizgisinin esdegeridir
)

$(P
$(CODE std.regexp.search()) ise uyanların bilgisini taşıyan bir $(CODE RegExp) nesnesi döndürür:
)

---
auto m = std.regexp.search("abcdef", "c");
if (m)
    writefln("%s[%s]%s", m.pre, m.match(0), m.post);
---

$(P
veya daha kısaca:
)

---
if (auto m = std.regexp.search("abcdef", "c"))
    writefln("%s[%s]%s", m.pre, m.match(0), m.post);
                                           // "ab[c]def" yazar
---

$(H6 Metin Arama ve Değiştirme)

$(P
Bu işlem biraz daha ilginçtir. $(CODE "a")ların önce ilkini, sonra da hepsini $(CODE "ZZ") ile değiştirmenin yolu Ruby'de şudur:
)

$(C_CODE
s = "Tavuğa roket tak."
s.sub(/a/, "ZZ")            // sonuç: "TZZvuğa roket tak."
s.gsub(/a/, "ZZ")           // sonuç: "TZZvuğZZ roket tZZk."
)

$(P
D'de ise şöyle:
)

---
s = "Tavuğa roket tak.";
sub(s, "a", "ZZ");          // sonuç: "TZZvuğa roket tak."
sub(s, "a", "ZZ", "g");     // sonuç: "TZZvuğZZ roket tZZk."
---

$(P
Eskisinin yerine gelecek olan metin parçasının içinde, uyan metin parçalarını belirten $(CODE $&, $$, $', $`, .. 9) belirteçleri kullanılabilir:
)

---
sub(s, "[at]", "[$&]", "g");
                        // sonuç: "T[a]vuğ[a] roke[t] [t][a]k."
---

$(P
veya yerleştirilecek dizgi bir $(CODE delegate) tarafından verilebilir:
)

---
sub(s, "[at]",
   (RegExp m) { return toupper(m.match(0)); },
   "g");                // sonuç: "TAvuğA rokeT TAk."
---

$(P
($(CODE toupper()) $(LINK2 http://www.dlang.org/phobos/std_string.html, std.string) modülünde tanımlanmıştır.)
)

$(H6 Döngüler)

$(P
Bir dizgi içindeki uyan bütün yerler bir döngüyle şöyle görülebilir:
)

---
import std.stdio;
import std.regexp;

void main()
{
    foreach(m; RegExp("ab").search("abcabcabab"))
    {
        writefln("%s[%s]%s", m.pre, m.match(0), m.post);
    }
}
// Çıktısı:
// [ab]cabcabab
// abc[ab]cabab
// abcabc[ab]ab
// abcabcab[ab]
---

$(H6 Sonuç)

$(P
Düzenli ifadeler D'de de Ruby kadar güçlüdürler ama yazımları onunki kadar kısa değildir:
)

$(UL
$(LI
Düzenli ifadeleri sabitler olarak yazabilmek - bunu başarabilmek için yalnızca sözcükleme [lexing] yetmezdi; ayrıca söz dizimi [syntax] ve anlam [semantic] çözümlemeleri de gerekirdi
)
$(LI
Uyanları otomatik olarak değişkenlere atamak - bunun isim çakışmaları riski vardır ve zaten D'nin geri kalan olanaklarına uymaz
)
)

$(P
Yine de aynı derecede güçlüdür.
)


Macros:
        SUBTITLE=Düzenli İfadeler [regular expressions]

        DESCRIPTION=Düzenli ifadelerin [regular expressions] D'de Ruby'den ne farklılıklar gösterdiği.

        KEYWORDS=d programlama dili makale d tanıtım düzenli ifadeler regexp
