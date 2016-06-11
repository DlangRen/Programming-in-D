Ddoc

$(H4 Fonksiyon Argümanlarında Tembel Değerlendirmeler)

$(P
  $(B Yazar:) $(LINK2 http://www.dlang.org, Walter Bright)
$(BR)
  $(B Çeviren:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Tarih:) 10 Temmuz 2009
$(BR)
  $(B İngilizcesi:) $(LINK2 http://www.dlang.org/lazy-evaluation.html, Lazy Evaluation of Function Arguments)
)

$(P
Tembel değerlendirme [lazy evaluation], bir ifadenin işletilmesinin ancak gerçekten gerek duyulana kadar geciktirilmesidir. Tembel değerlendirme geleneksel olarak $(CODE &&), $(CODE ||), ve $(CODE ?:) işleçlerinde karşımıza çıkar.
)

---
void deneme(int* p)
{
    if (p && p[0])
        ...
}
---

$(P
İkinci ifade olan $(CODE p[0]), ancak $(CODE p)'nin $(CODE NULL)'dan farklı olduğu durumda işletilecektir. Eğer ikinci ifade tembel olarak işletilmemiş olsa, $(CODE p)'nin $(CODE NULL) olduğu durumda bir çalışma zamanı hatası oluşurdu.
)

$(P
Ne kadar değerli olsalar da tembel işleçlerin ciddi kısıtlamaları vardır. Örneğin çalışması global bir değişkenle yönetilen bir loglama fonksiyonunu ele alalım. Loglamayı bu global değişkenin değerine göre açıp kapatıyor olalım:
)

---
void log(char[] mesaj)
{
    if (loglama_açık)
        fwritefln(log_dosyası, mesaj);
}
---

$(P
Yazdırılacak olan mesaj çoğu durumda çalışma zamanında oluşturulur:
)

---
void foo(int i)
{
    log("foo(), i'nin " ~ toString(i) ~ " değeriyle çağrıldı");
}
---

$(P
Bu kod istediğimiz gibi çalışıyor olsa da; burada mesaj loglamanın kapalı olduğu zamanlarda bile oluşturulmaktadır. Çok miktarda loglama yapan programlar bu yüzden gereksizce zaman kaybederler.
)

$(P
Bir çözüm, tembel değerlendirmenin programcı tarafından açıkça yapılmasıdır:
)

---
void foo(int i)
{
    if (loglama_açık) log("foo(), i'nin " ~ toString(i) 
                                     ~ " değeriyle çağrıldı");
}
---

$(P
Ancak bu, loglama yönetimiyle ilgili bir değişkeni kullanıcıya gösterdiği için sarma ilkesine aykırı bir kullanımdır. Bunun önüne geçmenin C'deki bir yolu makro tanımlamaktır:
)

$(C_CODE
#define LOG(mesaj)  (loglama_acik && log(mesaj))
)

$(P
Ama bu çözüm de makroların bilinen eksiklikleri nedeniyle yeni sorunlar doğurur:
)

$(UL
$(LI $(CODE loglama_acik) değişkeni kullanıcının isim alanına dahil olmuştur)
$(LI Makrolar hata ayıklayıcılar tarafından görülemezler)
$(LI Makrolar global olarak çalışırlar; bir kapsam içine alınamazlar)
$(LI Makrolar sınıf üyeleri olamazlar)
$(LI Adresleri alınamadığı için başka fonksiyonlara fonksiyon olarak geçirilemezler)
)

$(P
Bunun yerine fonksiyon parametrelerinin tembel olarak işletilmeleri daha sağlam bir çözümdür. D'de bunu yapmanın bir yolu, $(CODE delegate()) parametreler kullanmaktır:
)

---
void log(char[] delegate() dg)
{
    if (loglama_açık)
        fwritefln(log_dosyası, dg());
}

void foo(int i)
{
    log( { return "foo(), i'nin " ~ toString(i) 
                                  ~ " değeriyle çağrıldı"; } );
}
---

$(P
Bu kodda mesaj yalnızca loglamanın açık olduğu durumda oluşturulacaktır ve bu sefer sarma ilkesi de korunmaktadır. Bu seferki sorun ise, ifadelerin $(CODE { return $(I ifade); }) olarak yazılmalarını gerektirmesidir.
)

$(P
D bu noktada Andrei Alexandrescu tarafından önerilmiş olan küçük ama önemli bir adım atar: D'de her ifade, dönüş türü $(CODE void) veya ifadenin kendi türü olan bir $(CODE delegate)'e otomatik olarak dönüşür. $(CODE delegate) bildiriminin yerini de Tomasz Stachowiak'ın önerisi olan $(CODE lazy) türler alır. Fonksiyonların yeni yazımı şöyledir:
)

---
void log(lazy char[] dg)
{
    if (loglama_açık)
        fwritefln(log_dosyası, dg());
}

void foo(int i)
{
    log("foo(), i'nin " ~ toString(i) ~ " değeriyle çağrıldı");
}
---

$(P
Tekrar en baştaki kullanıma dönmüş olduk, ama burada ifade ancak loglama açık olduğunda işletilmektedir.
)

$(P
Kodda karşılaşılan yazım veya tasarım tekrarlarını soyutlamak ve bir şekilde sarmalamak, hem kodun karmaşıklığını hem de hata risklerini azaltır. Bunun en güzel örneklerinden birisi fonksiyon kavramının ta kendisidir. Tembel değerlendirme kavramı ise bir sürü başka yöntemin soyutlanabilmesini sağlar.
)

$(P
Basit bir örnek olarak $(CODE tekrar) kere tekrarlanması gereken bir ifadeyi ele alalım. Bunun en klasik yazımı şöyledir:
)

---
for (int i = 0; i < tekrar; i++)
   ifade;
---

$(P
O yöntemi tembel değerlendirme kullanarak şu şekilde sarmalayabiliriz:
)

---
void tekrarla(int tekrar, lazy void ifade)
{
    for (int i = 0; i < tekrar; i++)
       ifade();
}
---

$(P
ve şöyle kullanabiliriz:
)

---
void foo()
{
    int x = 0;
    tekrarla(10, writef(x++));
}
---

$(P
Çıktısı bekleneceği gibi şu şekildedir:
)

$(SHELL
0123456789
)

$(P
Daha karmaşık kontrol yapıları da kurulabilir. Örneğin şöyle $(CODE switch) benzeri bir yapı oluşturulabilir:
)

---
bool eğer(bool b, lazy void dg)
{
    if (b)
        dg();
    return b;
}

/* Buradaki belirsiz argümanlar bu özel durumda bir
   delegate dizisine dönüşürler.
 */
void seçenekler(bool delegate()[] kontroller...)
{
    foreach (c; kontroller)
    {        if (c())
            break;
    }
}
---

$(P
ve şöyle kullanılabilir:
)

---
void foo()
{
    int v = 2;
    seçenekler
    (
        eğer(v == 1, writefln("değeri 1")),
        eğer(v == 2, writefln("değeri 2")),
        eğer(v == 3, writefln("değeri 3")),
        eğer(true,   writefln("varsayılan değer"))
    );
}
---

$(P
Bunun çıktısı şöyle olur:
)

$(SHELL
değeri 2
)

$(P
Burada Lisp programlama dilinin makrolarıyla olan benzerlikleri farketmiş olabilirsiniz.
)

$(P
Son bir örnek olarak şu çok karşılaşılan kod örüntüsüne [pattern] bakalım:
)

---
Abc p;
p = foo();
if (!p)
    throw new Hata("foo() başarısız");
p.bar();        // p'yi şimdi kullanabiliriz
---

$(P
$(CODE throw) ifade değil, bir deyim olduğu için; bunu kullanan ifadelerin birden fazla satırda yazılmaları ve değişken tanımlanması gerekmektedir. (Bu konuda daha ayrıntılı bilgi için Andrei Alexandrescu ve Petru Marginean'ın $(LINK2 http://erdani.org/publications/cuj-06-2003.html, Enforcements) makalesini okuyabilirsiniz.) Oysa bütün bu kod tembel değerlendirme kullanılarak bir fonksiyon içine alınabilir:
)

---
Abc Güvenli(Abc p, lazy char[] mesaj)
{
    if (!p)
        throw new Hata(mesaj());
    return p;
}
---

$(P
ve biraz önceki kod şöyle basit bir hale gelir:
)

---
Güvenli(foo(), "foo() başarısız").bar();
---

$(P
ve 5 satırlık kod tek satıra indirgenmiş olur. Hattâ bir şablona dönüştürülürse $(CODE Güvenli) çok daha kullanışlı bir hale getirilebilir:
)

---
T Güvenli(T)(T p, lazy char[] mesaj)
{
    if (!p)
        throw new Hata(mesaj());
    return p;
}
---

$(H6 Sonuç)

$(P
Fonksiyon argümanlarının tembel olarak işletilebilmeleri fonksiyonların ifade yeteneklerini olağanüstü bir biçimde arttırmaktadır. Çok kullanılan kod örüntülerinin daha önceden hantal veya olanaksız olan sarmalanmaları da bu sayede olanaklı hale gelmektedir.
)

$(H6 Teşekkür)

$(P
Andrei Alexandrescu, Bartosz Milewski, ve David Held bana bu konuda hem ilham kaynağı oldular hem de büyük yardımda bulundular. Kendilerine içten teşekkür ederim. D camiasının da $(LINK2 http://www.digitalmars.com/pnews/read.php?server=news.digitalmars.com&group=digitalmars.D&artnum=41633, Tomasz Stachowiak'ın açtığı bir konuda) da görüldüğü gibi yapıcı eleştirileri olmuştur.
)

Macros:
        SUBTITLE="Fonksiyon Argümanlarında Tembel Değerlendirme", Walter Bright

        DESCRIPTION=Walter Bright'ın 'Lazy Evaluation of Function Arguments' makalesinin Türkçe çevirisi 'Fonksiyon Argümanlarında Tembel Değerlendirmeler'

        KEYWORDS=d programlama dili makale d tanıtım lazy evaluation tembel değerlendirme walter bright
