Ddoc

$(H4 Dizgilerin [string] C++ Dizgileri ile Karşılaştırılması)

$(ESKI_KARSILASTIRMA)

$(P
Dizgiler C++'da olduğu gibi kütüphanelerle de halledilebilirler. Bu bölümde D'de dizgilerin neden dilin bir iç olanağı olduklarını ve bunun getirdiği yararlar gösteriliyor.
)

$(P
Bu sayfadaki bilgiler $(LINK2 http://www.dlang.org/cppstrings.html, Digital Mars'ın sitesindeki aslından) alınmıştır.
)

$(H6 Birleştirme işleci)

$(P
C++'da dizgiler mevcut işleçleri kullanmak zorundadırlar. Bu konuda en uygun işleçler $(CODE +) ve $(CODE +=) işleçleridir. Bunun zararlarından birisi, $(CODE +) işlecinin doğal anlamının "toplama işlemi" olmasıdır. Kod okunurken işlemin "toplama" mı yoksa "birleştirme" mi olduğunu anlamak için nesnelerin türlerinin ne olduklarının araştırılması gerekebilir.
)

$(P
Ek olarak, $(CODE double) dizileri için yüklenmiş olan bir $(CODE +) işlecinin dizilerle vektör toplamı mı yapacağı, yoksa dizileri mi birleştireceği açık değildir.
)

$(P
Bu sorunlar D'de dizilerle çalışan yeni $(CODE ~) "birleştirme" işleciyle giderilir. "Sonuna ekleme" işleci de $(CODE ~=) işlecidir. Böylece artık $(CODE double) dizilerinde de karışıklık kalmamış olur: $(CODE ~) işleci dizilerin birleştirilecekleri, $(CODE +) işleci de vektör toplamlarının alınacağı anlamına gelir. Eklenen bu yeni işleç dizilerde tutarlılık da sağlamış olur. (D'de $(I dizgi) karakter dizisidir; özel bir tür değildir.)
)

$(H6 Söz dizimi uyumluluğu)

$(P
C++'da işleç yüklemenin çalışabilmesi için işlenenlerden birisinin yüklenebilen bir tür olması gerekir. O yüzden, C++'daki $(CODE string) her ifadeyle kullanılamaz:
)

$(C_CODE
const char abc[5] = "dünya";
string str = "merhaba" + abc;
)

$(P
Onun çalışabilmesi için dizgi kavramının dilin bir iç olanağı olması gerekir:
)

---
const char abc[5] = "dünya";
string str = "merhaba" ~ abc;
---

$(H6 Söz dizimi tutarlılığı)

$(P
Bir C++ dizgisinin uzunluğunu bulmanın üç yolu vardır:
)

$(C_CODE
const char abc[] = "dünya";    :   sizeof(abc)/sizeof(abc[0])-1
                               :   strlen(abc)
string str;                    :   str.length()
)

$(P
O tutarsızlık da şablonlarda sorunlar doğurur. D'nin çözümü tutarlıdır:
)

---
char[5] abc = "dünya";         :   abc.length
char[] str                     :   str.length
---

$(H6 Boş dizgiler)

$(P
C++'da $(CODE string)'lerin boş olup olmadıkları bir fonksiyonla belirlenir:
)

$(C_CODE
string str;
if (str.empty())
        // bos dizgi
)

$(P
D'de boş dizgilerin uzunlukları sıfırdır:
)

---
char[] str;
if (!str.length)
        // boş dizgi
---


$(H6 Dizgi uzunluğunu değiştirmek)

$(P
C++'da $(CODE resize()) fonksiyonu kullanılır:
)

$(C_CODE
string str;
str.resize(yeni_uzunluk);
)

$(P
D'de dizgiler dizi oldukları için $(CODE length) niteliklerini değiştirmek yeterlidir:
)

---
char[] str;
str.length = yeni_uzunluk;
---

$(H6 Dizgi dilimlemek [slicing])

$(P
C++'da bir kurucu fonksiyon kullanılır:
)

$(C_CODE
string s1 = "merhaba dünya";
string s2(s1, 8, 5);               // s2 "dünya" olur
)

$(P
D'de dizi dilimleme kullanılır:
)

---
string s1 = "merhaba dünya";
string s2 = s1[8 .. 13];           // s2 "dünya" olur
---

$(H6 Dizgiler arası kopyalama)

$(P
C++'ta dizgiler $(CODE replace) fonksiyonu ile kopyalanırlar:
)

$(C_CODE
string s1 = "merhaba dünya";
string s2 = "güle güle      ";
s2.replace(10, 5, s1, 8, 5);       // s2 "güle güle dünya" olur
)

$(P
D'de ise sol tarafta dilimleme kullanılır:
)

---
char[] s1 = "merhaba dünya".dup;
char[] s2 = "güle güle      ".dup;
s2[10..15] = s1[8..13];            // s2 "güle güle dünya" olur
---

$(P
D'de dizgi sabitleri değiştirilemedikleri için önce $(CODE .dup) ile kopyalarını almak gerekti.
)


$(H6 C dizgilerine dönüştürmek)

$(P
C kütüphaneleriyle etkileşmek için gereken dönüşümler C++'da $(CODE c_str()) ile yapılır.
)

$(C_CODE
void foo(const char *);
string s1;
foo(s1.c_str());
)

$(P
D'de $(CODE .ptr) niteliği ile:
)

---
void foo(char*);
char[] s1;
foo(s1.ptr);
---

$(P
Ama bunun çalışabilmesi için $(CODE s1)'in sonunda bir sonlandırma karakteri bulunması gerekir. Sonlandırma karakterinin bulunduğunu garanti eden $(CODE std.string.toStringz) fonksiyonu da kullanılabilir:
)

---
void foo(char*);
char[] s1;
foo(std.string.toStringz(s1));
---

$(H6 Dizgi dışına taşmaya karşı denetim)

$(P
C++'da $(CODE []) işleci dizginin sınırları dışına çıkılıp çıkılmadığını denetlemez. Bu denetim D'de varsayılan davranış olarak bulunur, ve programın hataları giderildikten sonra bir derleyici ayarıyla kapatılabilir.
)


$(H6 $(CODE switch) deyimlerinde dizgiler)

$(P
Bu C++'da olanaksızdır ve kütüphaneyi daha büyütmek dışında bir yolu da yoktur. D'de ise doğaldır:
)

---
switch (str)
{
    case "merhaba":
    case "dünya":
        ...
}
---

$(P
$(CODE case)'lerle sabit dizgiler yanında $(CODE char[10]) gibi sabit karakter dizileri veya $(CODE char[]) gibi dinamik diziler de kullanılabilir.
)

$(H6 Birden fazla dizgi karakterini bir karakterle değiştirmek)

$(P
C++'ta $(CODE replace()) fonksiyonu ile yapılır:
)

$(C_CODE
string str = "merhaba";
str.replace(1,2,2,'?');         // str "m??haba" olur
)

$(P
D'de dizi dilimleme kullanılır:
)

---
char[5] str = "merhaba";
str[1..3] = '?';                // str "m??haba" olur
---


$(H6 Değerler ve referanslar)

$(P
C++ dizgileri, STLport'ta gerçekleştirildikleri gibi, $(I değer türleridirler) [value type] ve $(CODE '\0') karakteri ile sonlandırılmışlardır. [Aslında sonlandırma karakteri STLport'un bir seçimidir; öyle olmak zorunda değildir.] Çöp toplamanın eksikliği nedeniyle bunun bazı bedelleri vardır. Öncelikle, oluşturulan her $(CODE string)'in karakterlerin kendisine ait bir kopyasını tutması gerekir. Karakterlerin hangi $(CODE string) tarafından sahiplenildiğinin hesabının tutulması gerekir, çünkü sahip ortadan kalktığında bütün referanslar da geçersiz hale gelirler. Bu $(I referansların geçersizliği) [dangling reference] sorunundan kurtulmak amacıyla $(CODE string)'lerin  $(I değer türleri) olarak kullanılmaları gerektiği için; çok sayıdaki bellek ayırma, karakter kopyalama, ve bellek geri verme işlemleri nedeniyle bu tür yavaş hale gelir. Dahası, sonlandırma karakteri dizgilerin diğer dizgileri referans olarak göstermelerine engeldir. $(I Data segment)'teki, program yığıtındaki, vs. karakterlere referans kullanılamaz.
)

$(P
D'de dizgiler $(I referans türleridirler) ve bellek çöp toplamalıdır. Bu yüzden yalnızca referansların kopyalanmaları gerekir, karakterlerin değil... Karakterler nerede olurlarsa olsunlar D dizgileri onları referans olarak gösterebilir: $(I static data segment), program yığıtı, başka dizgilerin bir bölümü, nesneler, dosya ara bellekleri, vs. Dizgideki karakterlerin sahibinin hesabını tutmaya gerek yoktur.
)

$(P
Bu noktadaki doğal soru; birden fazla dizginin ortaklaşa karakter kullandıkları durumda dizgilerden birisinde değişiklik yapıldığında ne olacağıdır. Karakterleri gösteren bütün dizgiler değişmiş olurlar. Bunun istenmediği durumda $(I yazınca kopyalama) [copy-on-write] yöntemi kullanılabilir. Bu yöntemde, dizgide değişiklik yapılmadan önce karakterlerin o dizgiye ait bir kopyası alınır ve değişiklik o kopyada yapılır.
)

$(P
D dizgilerinin referans türleri ve çöp toplamalı olmaları, dizgilerle yoğun işlemler yapan lzw sıkıştırma algoritması gibi işlemlerde hem hızda hem de bellek kullanımında kazanç sağlar.
)

$(H6 Hız karşılaştırması)

$(P
Bir dosyadaki sözcüklerin histogramını alan küçük bir programa bakalım. Bu program D'de şöyle yazılabilir:
)

---
import std.file;
import std.stdio;

int main (char[][] argümanlar)
{
    int kelime_toplamı;
    int satır_toplamı;
    int karakter_toplamı;
    int[char[]] sözlük;

    writefln("   satır  kelime    bayt dosya");
    for (int i = 1; i < argümanlar.length; ++i)
    {
        char[] giriş;
        int kelime_top, satır_top, karakter_top;
        int kelime_içindeyiz;
        int kelime_başı;

        giriş = cast(char[])std.file.read(argümanlar[i]);

        for (int j = 0; j < giriş.length; j++)
        {   char karakter;

            karakter = giriş[j];
            if (karakter == '\n')
                ++satır_top;
            if (karakter >= '0' && karakter <= '9')
            {
            }
            else if (karakter >= 'a' && karakter <= 'z' ||
                     karakter >= 'A' && karakter <= 'Z')
            {
                if (!kelime_içindeyiz)
                {
                    kelime_başı = j;
                    kelime_içindeyiz = 1;
                    ++kelime_top;
                }
            }
            else if (kelime_içindeyiz)
            {   char[] kelime = giriş[kelime_başı .. j];

                sözlük[kelime]++;
                kelime_içindeyiz = 0;
            }
            ++karakter_top;
        }
        if (kelime_içindeyiz)
        {   char[] kelime = giriş[kelime_başı .. giriş.length];
            sözlük[kelime]++;
        }
        writefln("%8s%8s%8s %s",
                  satır_top, kelime_top, karakter_top,
                  argümanlar[i]);
        satır_toplamı += satır_top;
        kelime_toplamı += kelime_top;
        karakter_toplamı += karakter_top;
    }

    if (argümanlar.length > 2)
    {
        writefln("--------------------------------------\n"
                 "%8s%8s%8s toplam",
                 satır_toplamı,
                 kelime_toplamı,
                 karakter_toplamı);
    }

    writefln("--------------------------------------");

    foreach (const char[] kelime; sözlük.keys.sort)
    {
        writefln("%3d %s", sözlük[kelime], kelime);
    }
    return 0;
}
---

$(P
(Ara bellekli giriş/çıkış kullanan $(LINK2 http://www.dlang.org/wc.html, başka bir gerçekleştirmesi) de var.)
)

$(P
İki programcı bu programın C++ gerçekleştirmelerini de yazdılar: $(LINK2 http://groups.google.com/groups?q=g:thl953709878d&dq=&hl=en&lr=&ie=UTF-8&oe=UTF-8&selm=bjacrl%244un%2401%241%40news.t-online.com, wccpp1) ve $(LINK2 #wccpp2, wccpp2). Programa giriş olarak "Alice Harikalar Diyarında"nın metnini oluşturan $(LINK2 http://www.gutenberg.org/dirs/etext91/alice30.txt, alice30.txt) verildi. D derleyicisi olarak $(LINK2 http://ftp.digitalmars.com/dmd.zip, dmd) ve C++ derleyicisi olarak da $(LINK2 http://ftp.digitalmars.com/dmc.zip, dmc) kullanıldı. Bu iki derleyici aynı eniyileştiriciyi ve aynı kod üreticiyi kullandıkları için, bu karşılaştırma iki dildeki dizgilerin daha gerçekçi bir karşılaştırmasını verir. Programlar bir Windows XP sisteminde denendiler ve dmc için şablon gerçekleştirmesi olarak STLport kullanıldı.
)

<table border="1" cellpadding="4" cellspacing="0">
<tr>
<th scope="col">Program</th>
<th scope="col">Derleme Komutu</th>
<th scope="col">Derleme Süresi</th>
<th scope="col">Çalıştırma Komutu</th>
<th scope="col">Çalışma Süresi</th>
</tr>

<tr>        <td>D wc</td>
<td>dmd wc -O -release</td>
<td>0.0719</td>
<td>wc alice30.txt &gt;log</td>
<td>0.0326</td>
</tr>

<tr>        <td>C++ wccpp1</td>
<td>dmc wccpp1 -o -I\dm\stlport\stlport</td>
<td>2.1917</td>
<td>wccpp1 alice30.txt &gt;log</td>
<td>0.0944</td>
</tr>

<tr>        <td>C++ wccpp2</td>
<td>dmc wccpp2 -o -I\dm\stlport\stlport</td>
<td>2.0463</td>
<td>wccpp2 alice30.txt &gt;log</td>
<td>0.1012</td>
</tr>
</table>


$(P
Aşağıdaki sonuçlar ise Linux üzerinde ve yine aynı eniyileştiriciyi ve kod üreticiyi paylaşan iki derleyici ile alındılar: D için $(LINK2 http://home.earthlink.net/~dvdfrdmn/d, gdc) ve C++ için g++. Bu seferki sistem gcc 3.4.2'li bir RedHat Linux 8.0 çalıştıran 800MHz'lik bir Pentium III'tü. Ek bilgi açısından Digital Mars'ın derleyicisi dmd'nin sonuçları da eklenmiştir.
)


<table border=1 cellpadding=4 cellspacing=0>
<tr>
<th scope="col">Program</th>
<th scope="col">Derleme Komutu</th>
<th scope="col">Derleme Süresi</th>
<th scope="col">Çalıştırma Komutu</th>
<th scope="col">Çalışma Süresi</th>
</tr>

<tr>
<td>D wc</td>
<td>gdc -O2 -frelease -o wc wc.d</td>
<td>0.326</td>
<td>wc alice30.txt &gt; /dev/null</td>
<td>0.041</td>
</tr>
<tr>        <td>D wc</td>
<td>dmd wc -O -release</td>
<td>0.235</td>
<td>wc alice30.txt &gt; /dev/null</td>

<td>0.041</td>
</tr>
<tr>        <td>C++ wccpp1</td>
<td>g++ -O2 -o wccpp1 wccpp1.cc</td>
<td>2.874</td>
<td>wccpp1 alice30.txt &gt; /dev/null</td>

<td>0.086</td>
</tr>
<tr>        <td>C++ wccpp2</td>
<td>g++ -O2 -o wccpp2 wccpp2.cc</td>
<td>2.886</td>
<td>wccpp2 alice30.txt &gt; /dev/null</td>

<td>0.095</td>
</tr>
</table>

$(P
Aşağıdaki sonuçlar da gcc 3.4.2'li bir MacOS X 10.3.5 çalıştıran bir PowerMac G5 2x2.0GHz ile alınmışlardır. (Burada ölçümlerin doğruluğu biraz daha düşüktü.)
)

<table border=1 cellpadding=4 cellspacing=0
<tr>
<th scope="col">Program</th>
<th scope="col">Derleme Komutu</th>
<th scope="col">Derleme Süresi</th>
<th scope="col">Çalışma Komutu</th>
<th scope="col">Çalışma Süresi</th>
</tr>

<tr>        <td>D wc</td>

<td>gdc -O2 -frelease -o wc wc.d</td>
<td>0.28</td>
<td>wc alice30.txt &gt; /dev/null</td>
<td>0.03</td>
</tr>

<tr>        <td>C++ wccpp1</td>
<td>g++ -O2 -o wccpp1 wccpp1.cc</td>
<td>1.90</td>
<td>wccpp1 alice30.txt &gt; /dev/null</td>
<td>0.07</td>

</tr>
<tr>        <td>C++ wccpp2</td>
<td>g++ -O2 -o wccpp2 wccpp2.cc</td>
<td>1.88</td>
<td>wccpp2 alice30.txt &gt; /dev/null</td>

<td>0.08</td>
</tr>
</table>

$(HR)
<h6><a name="wccpp2">Allan Odgaard'ın wccpp2 programı:</a></h6>

$(C_CODE
#include &lt;algorithm&gt;
#include &lt;cstdio&gt;
#include &lt;fstream&gt;
#include &lt;iterator&gt;
#include &lt;map&gt;
#include &lt;vector&gt;

bool isWordStartChar (char c)      { return isalpha(c); }
bool isWordEndChar (char c)        { return !isalnum(c); }

int main (int argc, char const* argv[])
{
    using namespace std;
    printf("Lines Words Bytes File:\n");

    map&lt;string, int&gt; dict;
    int tLines = 0, tWords = 0, tBytes = 0;
    for(int i = 1; i < argc; i++)
    {
        ifstream file(argv[i]);
        istreambuf_iterator&lt;char&gt; from(file.rdbuf()), to;
        vector&lt;char&gt; v(from, to);
        vector&lt;char&gt;::iterator first = v.begin(), 
                                last = v.end(),
                                bow, eow;

        int numLines = count(first, last, '\n');
        int numWords = 0;
        int numBytes = last - first;

        for(eow = first; eow != last; )
        {
            bow = find_if(eow, last, isWordStartChar);
            eow = find_if(bow, last, isWordEndChar);
            if(bow != eow)
                ++dict[string(bow, eow)], ++numWords;
        }

        printf("%5d %5d %5d %s\n", 
                numLines, numWords, numBytes, argv[i]);

        tLines += numLines;
        tWords += numWords;
        tBytes += numBytes;
    }

    if(argc > 2)
            printf("-----------------------\n%5d %5d %5d\n",
                   tLines, tWords, tBytes);
    printf("-----------------------\n\n");

    for(map&lt;string, int&gt;::const_iterator it = dict.begin();
         it != dict.end(); ++it)
            printf("%5d %s\n", it->second, it->first.c_str());

    return 0;
}
)





Macros:
        SUBTITLE=D Dizgilerinin [string] C++ ile Farkları

        DESCRIPTION=D programlama dilindeki dizgilerin C++ dilinden farklılıkları

        KEYWORDS=d programlama dili tanıtım bilgi karşılaştırma c++ cpp dili dizgi string
