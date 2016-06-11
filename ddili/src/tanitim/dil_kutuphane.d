Ddoc

$(H4 Olanakların Dil İçinde veya Kütüphanelerde Gerçekleştirilmeleri)

$(ESKI_KARSILASTIRMA)

$(P
Bu sayfadaki bilgiler $(LINK2 http://www.dlang.org/builtin.html, Digital Mars'ın sitesindeki aslından) alınmıştır.
)

$(P
C++ gibi bazı başka dillerde kütüphanelerle gerçekleştirilmiş olan bazı olanaklar D'de dilin iç olanaklarıdır:
)

$(OL
$(LI Dinamik diziler)
$(LI Dizgiler [string])
$(LI Eşleme tabloları [associative arrays])
$(LI Karmaşık sayılar)
)

$(P
Bazılarına göre bu, yarar sağlamak yerine dilin gereksizce büyümesine neden olur. Onlara göre bu olanaklar standart kütüphanelerde gerçekleştirilmelidirler.
)

$(P
Önce bazı genel gözlemler:
)

$(OL
$(LI
Bunların hepsi de çok yaygın olarak kullanılan olanaklar oldukları için, kullanışlılıklarını biraz olsun arttırmak çok kişiye yarar sağlar.
)
$(LI
Dil içi türlerin yanlış kullanılmaları durumunda derleyiciler daha anlaşılır ve daha yardımcı hata mesajları verebilirler. Kütüphane olanakları ile ilgili hata mesajları bazen son derece anlaşılmaz olurlar.
)
$(LI
Kütüphaneler yeni söz dizimleri, yeni işleçler, veya yeni anahtar sözcükler oluşturamazlar.
)
$(LI
Her seferinde kütüphane olanaklarının da tekrar tekrar derlenmeleri gerektiği için derleme yavaştır.
)
$(LI
Kütüphanelerin kullanıcıya esneklik sağlamaları beklenir. Eğer derleyicinin bile tanıyabileceği derecede standartlaştırılırlarsa (C++ standardı buna izin verir), zaten dil içi olanaklar kadar sabitleşmişler ve esnekliklerini kaybetmişler demektir.
)
$(LI
Kütüphanelerde yeni türler tanımlayabilme olanağı günümüzde çok gelişmiş olsa da, hâlâ dil olanakları kadar rahat değillerdir: uyumsuz kullanımlar, doğal olmayan söz dizimleri, içine düşülebilecek bazı garip durumlar.
)
)

$(P
Biraz daha ayrıntılı açıklamalar:
)

$(H6 Dinamik diziler)

$(P
Diziler C++'da dilin iç olanaklarındandırlar ama pek kullanışlı oldukları söylenemez. C++'da dizilerin sorunlarını gidermek yerine, standart şablon kütüphanesi [STL] içinde tanımlı bazı yeni diziler tanımlanmıştır. Bunların her birisi dizilerin değişik bir açığını kapatır: 
)

$(UL
$(LI basic_string)
$(LI vector)
$(LI valarray)
$(LI deque)
$(LI slice_array)
$(LI gslice_array)
$(LI mask_array)
$(LI indirect_array)
)

$(P
Dil içindeki dizinin sorunları giderilse, bunların hiçbirisine gerek kalmaz ve öğrenilecek tek bir tür olur. Değişik dizi türlerinin birbirleriyle kullanılabilmeleri için de çaba gerekmemiş olur.
)

$(P
Dil içi diziler bize yazım kolaylığı sağlarlar. Dizi sabitleri [literal] belirleyebiliriz ve dizilere ait yeni işleçler tanımlayabiliriz. Oysa kütüphane gerçekleştirmeleri mevcut işleçleri yüklemek zorundadırlar. D dizileri C++'daki $(CODE dizi[i]) indeks işlecine ek olarak şu işleçleri de sunar: birleştirme işleci $(CODE ~), sonuna ekleme işleci $(CODE ~=), dilimleme işleci $(CODE dizi[i..j]), vektör işleci $(CODE dizi[]).
)

$(P
$(CODE ~) ve $(CODE ~=) işleçleri, yalnızca mevcut işleçlerin yüklenebildiği durumda ortaya çıkan bir sorunun üstesinden gelirler. Normalde kütüphane dizilerini birleştirmek için $(CODE +) işleci kullanılır. Ne yazık ki bu seçim $(CODE +) işlecinin $(I vektör toplamı) anlamında kullanılmasını engellemiş olur. Ayrıca, $(I birleştirme işlemi) ile $(I toplama işlemi) aynı şey olmadıklarından, ikisi için aynı işlecin kullanılıyor olması karışıklık doğurur.
)

$(H6 Dizgiler)

$(P
Bu konuyla ilgili daha ayrıntılı bilgiyi $(LINK2 /tanitim/fark_dizgi.html, Dizgilerin [string] C++ Dizgileri ile Karşılaştırılması) sayfasında okuyabilirsiniz...
)

$(P
C++'da dil içindeki dizgiler $(I sabit dizgiler [string literal]) ve $(I char dizileri) olarak sunulurlar. Ama onların da sorunu, C++ dizilerinin bütün zayıflıklarını aynen taşımalarıdır.
)

$(P
Sonuçta dizgi bir char dizisi değil midir? Dolayısıyla dizilerin sorunları çözüldüğünde, dizgilerin sorunları da çözülmüş olur. D'de ayrı bir dizgi sınıfının bulunmuyor olması baştan garip gelebilir. Ama sonuçta char dizilerinden farklı olmadıklarına göre, özel bir sınıf olarak sunmaya gerek yoktur.
)

$(P
Dahası, kaynak kodda sabit olarak yazılan dizgilerin kütüphanedeki dizgilerle farklı türden olmaları sorunu da çözülmüş olur. $(I [Çevirenin notu: $(CODE "merhaba") gibi bir dizgi sabiti $(CODE std::string) türünden değildir.])
)

$(H6 Eşleme tabloları)

$(P
Bunun temel amacı yazım kolaylığı sağlamaktır. $(CODE T) türünde bir anahtarla indekslenen ve $(CODE int) türünde değerler tutan bir dizi çok doğal olarak şöyle yazılabilir:
)

---
int[T] foo;
---

$(P
ve şöyle bir kullanımdan çok daha kısadır:
)

---
import std.associativeArray;
...
std.associativeArray.AA!(T, int) foo;
---

$(P
Eşleme tablolarının dilin iç olanağı olmaları onların kaynak kodda sabit olarak tanımlanabilmelerini de sağlar. Bu da çok arzulanan bir olanaktır.
)

$(H6 Karmaşık sayılar)

$(P
Bu konuyla ilgili daha ayrıntılı bilgiyi $(LINK2 /tanitim/fark_karmasik.html, Karmaşık Sayı Türleri ve C++'nın std::complex'i) sayfasında okuyabilirsiniz...
)

$(P
Bu olanağın dilin bir iç olanağı olmasının baş nedeni, C'deki sanal ve karmaşık kayan noktalı sayılarla [complex floating point] uyumlu olmaktır. Diğer bir nedeni, sanal kayan noktalı sayıları sabit olarak yazabilmektir:
)

---
c = (6 + 2i - 1 + 3i) / 3i;
---

$(P
Herhalde şöyle bir kullanımdan üstünlüğü açıktır:
)

---
c = (complex!(double)(6,2) + complex!(double)(-1,3))
                                       / complex!(double)(0,3);
---


Macros:
        SUBTITLE=İç Olanak veya Kütüphane

        DESCRIPTION=D programlama dili olanaklarının dil içinde mi yoksa kütüphanelerde mi gerçekleştirildikleri

        KEYWORDS=d programlama dili tanıtım bilgi iç olanak kütüphane gerçekleştirme
