Ddoc

$(H4 Neden D)

$(P
  $(B Yazar:) $(LINK2 http://erdani.org, Andrei Alexandrescu)
$(BR)
  $(B Çeviren:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Tarih:) Haziran 2009
)

$(P
Bakalım D, üzerinde durmaya değecek bir programlama dili mi...
)

$(P
Sizi kolayca ikna edebileceğim yanılgısına düşmeyeceğim. Biz programcılar dil tercihi konusunda oldukça garibizdir. Bir programcının kitapçıda rastladığı "Falanca Programlama Dili" isimli bir kitaba karşı tepkisi herhalde şunun gibi bir şeydir: "Kendime bu dilde hoşlanmadığım bir şey bulana kadar 30 saniye süre tanıyorum." Bir programlama dilini edinmek oldukça uzun ve güç bir iştir. Getireceği tatmin de hem çok uzun vadede gelir, hem de kesin bile değildir. Böyle zorlu bir maceraya atılmayı daha başından engelleyecek nedenler aramak aslında bir savunma mekanizması olarak görülmelidir. Şüpheli ve riskli bir yatırım olduğu için, bu konuda çabucak olumsuz bir karar vermek aslında programcı için büyük bir rahatlıktır.
)

$(P
Öte yandan, bir programlama dili öğrenmek ve kullanabilmek çok zevkli bir uğraştır da. Bir dilin zevkli kabul edilebilmesi için genellikle programcının değer verdiği ilkeleri tatmin edici derecede karşılıyor olması gerekir. Bu konudaki bir uyumsuzluk; programcının o dilin baştan savma, güvensiz, kurumlu, ve usandırıcı olduğunu düşünmesine neden olacaktır. Bir dil her ihtiyacı ve zevki eşit ölçüde karşılayamayacağı için, programcılık alanındaki bir kaç sağlam temel üzerine kurulmuş olması önemlidir.
)

$(P
Nedir D'nin hikayesi? D'yi zaten duymuş olabilirsiniz: garip dil isimlerinden birisinin sahibi, konu dışı olduğu şeklinde uyarılana kadar başka dillerin forumlarında adı duyulan, bir arkadaş tarafından belki hararetle bahsedilmiş olan, veya "Kesin D adında bir dil de vardır" diye düşünerek aratınca karşılaşılan bir dil...
)

$(P
Bu yazıda bu dile çok geniş bir açıdan bakacağım ve bu yüzden dilin bazı kavramlarının ve özelliklerinin üzerinde fazla duramayacağım. Bu yazıda kaynakça da göstermiyorum ama nasıl olsa sözü geçen terimler hakkında daha fazla bilgi edinmek için $(LINK2 http://www.google.com, google.com)'dan yararlanabilirsiniz. $(I [Çevirenin notu: Yardımı olacağını düşündüğüm yerlerde terimlerin İngilizce asıllarını da  köşeli parantezler içinde vereceğim.])
)

$(P
İşe D'nin temel olanaklarını gözden geçirmekle başlayalım. Olanaklarının ve kısıtlamalarının bazıları doğal olarak biraz muallak kalacaklar. Hoşunuza gitmeyen bir şey okuduğunuzda buna fazla takılmayın çünkü anlam bir sonraki cümlede tamamlanıyor olabilir. Örneğin diyelim "D çöp toplamalı [garbage collection] bir dildir" ifadesini okuduğunuzda iliklerinize kadar dondunuz ve oradan hemen uzaklaşma ihtiyacı hissettiniz... Biraz sabır gösterirseniz, D'de kurucu [constructor] ve bozucu [destructor] işlevlerin de bulunduğunu, ve isterseniz nesne yaşam süreçlerini sizin de belirleyebileceğinizi göreceksiniz.
)

$(H5 Konuya girmeden önce)

$(P
Konuya girmeden önce bilmeniz gereken bir kaç şey var. Öncelikle, eğer daha önceden de D'ye şöyle bir bakmaya karar vermiş ve vazgeçmişseniz, bu sefer de öyle olacağını düşünmeyin. Çünkü içinde bulunduğumuz bu dönem, erken başlamanın getirdiği avantajlar açısından öncekilerden çok farklı bir dönem. D gelişmesini çok hızlı ama biraz sessiz olarak sürdürmekte ve ondaki müthiş gelişmeler tam da şu sıralarda duyulmaya başlanmakta... Hatta bazı gelişmeler ilk olarak bu yazı aracılığıyla duyuruluyor. Bu yazıyı hazırladığım sırada üçte biri bitmiş olan "The D Programming Language" isimli kitabımı tamamlamaya ve bir kaç ay içinde çıkartmaya çalışıyorum.
)

$(P
Bu hızlı gelişme süreci doğal olarak bendenizi sürekli hareket halindeki bir hedefin peşinde koşmak durumunda bırakıyor. Uzun süre güncel kalacak olan bir yazı çıkartmaya karar vermiş olsam da, ne yazık ki biraz da moral bozucu olarak bu yazıda ya hiç gerçekleştirilmemiş ya da henüz yarım olarak gerçekleştirilmiş olanaklardan da söz etmek zorunda kalacağım.
)

$(P
Bu dilin D1 ve D2 olarak başlıca iki sürümü var. Ben bu yazıda yalnızca D2 üzerinde duruyorum. D1 şu anda zaten çok kararlı bir durumda: artık üzerinde değişiklik yapılmıyor ve yalnızca hataları gideriliyor. D2 ise önceki sürümlerle uyumluluk konusunda özveride bulunma kararı almış başlıca bir sürüm... Bu özverinin nedeni, kararlı bir şekilde daha iyiye doğru gitmek, ve çok çekirdekli işlemcilerle [manycores] ve türden bağımsız programlamayla [generic programming] ilgili önemli bazı olanaklar getirmektir. Tabii bunun sonucunda dilin karmaşıklığı da artmış oluyor; ama gerçek hayatta kullanılan hiçbir dil zaten hiç küçülmemiş, hep büyümüştür. $(I Küçük ve hoş) olma kaygısıyla başlayan diller bile kullanıldıkça büyümek zorunda kalmışlardır. (Burada ayrıntıya girmeyelim ama evet, Lisp bile.) Programcılar hep küçük ve sade dillerin düşünü kurarlar ama kendilerine geldiklerinde asıl aradıklarının hep daha fazla modelleme yeteneği olduğunu farkederler.
)

$(P
Resmî olarak kabul edilen D derleyicisi dmd, bütün yaygın platformlar (Windows, Mac ve Linux) için $(LINK2 http://www.dlang.org/download.html, dlang.org)'dan edinilebilir. Başka ortamlara uygun sürümlerinin çalışmaları da devam etmekte; özellikle .NET'e taşınmakta olduğunu belirtmekte yarar var. Ayrıca iki tane de temel D kütüphanesi mevcut: resmî olarak kabul edilen Phobos, ve çok sağlam bir kütüphane olarak tanınan Tango. Başlangıçta D1 için tasarlanmış olan Tango, şu sırada D2'ye taşınıyor. D1 sürümü sinir bozucu derecede küçük ve garip olarak tanınan Phobos ise D2'nin tüm yeteneklerinden yararlanabilmek için köklü değişikliklerden geçiyor. (Tahmin edileceği gibi kütüphanelerden hangisinin daha iyi olduğu konusunda politik görüşler ve atışmalar da var; ama bu rekabet sonuçta her ikisinin de daha iyiye gitmesine yardım ediyor.)
)

$(P
Son olarak, gayet yaygın olan Qt pencereleme kütüphanesi de kısa bir süre önce D desteği vermeye başladı (bunu yazdığım sırada henüz alfa sürümündeler). Bu çok önemli bir haber, çünkü Qt taşınabilir görsel programlar yazabilmek için çok önemli bir ortamdır (kimisine göre de en iyisidir); ve yaygın kullanımdaki bütün işletim sistemlerini destekler. Qt'nin bu D desteği, D'yi bir anlamda $(I görselinci boyut)a taşımakta ve sunduğu olanakları mükemmel bir şekilde tamamlamaktadır. Daha da iyisi, bu gelişme tam da Qt'nin LGPL lisansını desteklemeye başlamasının hemen ardından geldi. Ticari programlar Qt'yi artık herhangi bir kısıtlama altında kalmadan ve lisans ücreti ödemeden kullanabiliyorlar.
)

$(H5 D'nin temelleri)

$(P
D'nin en doğru tanımı, $(I üst düzey sistem programlama dili) olarak yapılabilir. Normalde üst düzey dillerde ve hatta betik dillerde [script language] görmeye alıştığımız bazı olanaklara sahiptir: çok hızlı kodlama-derleme-çalıştırma süreci, çöp toplama, dile yerleşik $(I hızlı eşleme tabloları) [hash tables], tür bildirimlerini yazmak zorunda olmamak, vs. Ama aynı zamanda alt düzey olanaklar da sunar: işaretçiler, elle ($(CODE malloc)/$(CODE free)) veya yarı-otomatik (kurucular ve bozucular) olarak yapılabilen kaynak yönetimi, ve bellek ile C ve C++ programcılarının çok sevdikleri gibi doğrudan etkileşebilme olanağı. Hatta D, C fonksiyonlarını hiç bir dönüşüm gerektirmeden çağırabilir. Yani C standart kütüphanesinin tamamı D programcılarının kullanımına hazır durumdadır. Ama genelde o kadar alt düzeye inme ihtiyacı hissedilmez; çünkü hem D'nin kolaylıkları çoğu zaman daha güçlü ve daha güvenlidir, hem de zaten D alt düzey programlama kadar etkin kod üretir. Genelde D'de kolaylık ve verimlilik arasında seçim yapmak gerekmez.
)

$(P
D'nin $(I çok paradigmalı) [multi-paradigm] olduğu söylenebilir: kodlama olarak nesne yönelimli [object-oriented], fonksiyonel [functional], türden bağımsız [generic], ve yordamsal [procedural] programlama tarzlarını destekler. D'deki bazı genel kavramları aşağıdaki küçük bölümlerde bulacaksınız.
)

$(H5 Biraz haksızca sataşarak merhaba)

$(P
Daha fazla uzatmadan şu söz dizimi konusunu aradan çıkartalım:
)

---
import std.stdio;
void main()
{
  writeln("merhaba dünya");
}
---

$(P
Söz dizimi biraz giysi konusuna benzer; mantıklı düşününce giysilerin önemli olmaması gerektiğini biliriz. Hatta bu konuya fazla önem vermenin de biraz sığlık olarak kabul edilebileceğini de görebiliriz; ama giysi konusu hemen dikkatimizi çeker. (The Matrix filmindeki kırmızı elbiseli kızı bugün bile hatırlarım.) C'nin söz dizimine benzerliği nedeniyle D çoğumuza tanıdık gelecektir. Bu benzerliği C++, Java ve C#'ta da görmekteyiz. (Bu dillerden en az birisini bildiğinizi varsayıyorum ve tam sayıların, kayan noktalı sayıların, dizilerin, erişicilerin [iterator] ve özyinelemenin D'de de bulunduğunu söyleme gereği duymuyorum.)
)

$(P
Hazır başka dillerden söz etmişken, C ve C++'nın "merhaba dünya" programlarına biraz haksızca da olsa sataşalım. C programının klasik hali K&amp;R'ın ikinci basımında şöyledir:
)

---
#include <stdio.h>
main()
{
  printf("hello, world\n");
}
---

$(P
ve aynı derecede klasik olan C++ programı da şöyledir (heyecandaki fazlalığa dikkat edin):
)

---
#include <iostream>
int main()
{
  std::cout << "Hello, world!\n";
}
---

$(P
Bu tanıdık programın değişik dillerdeki halleri karşılaştırılırken çoğunlukla kod uzunluğuna ve programı anlamak için gereken bilgi miktarına bakılır. Bu sefer değişik bir yol çizelim ve doğruluktan söz edelim: mesaj standart çıkışa gönderilemezse ne olur? C programı hatayı gözardı eder, çünkü $(CODE printf)'in dönüş değerine bakmamaktadır. Gerçeği söylemek gerekirse, aslında durum daha da kötüdür: C programı benim ortamımda hatasız ve uyarısız olarak derleniyor olsa bile işletim sistemine belirsiz bir değer döndürür, çünkü program akışı $(CODE main)'den bir $(CODE return) deyimi olmaksızın çıkmaktadır. (Ubuntu'da hep 13 değerini gördüğüm için biraz ürktüğümü söyleyebilirim.) Hatta program C89 ve C99 standartlarına uymaz bile. Biraz araştırma sonucunda İnternet'ten de öğrenilebileceği gibi, bu selamlamanın doğrusu C'de aslında şöyle olmalıdır:
)

---
#include <stdio.h>
int main()
{
  printf("hello, world\n");
  return 0;
}
---

$(P
Ama onun da doğruluğu hâlâ şüphelidir; çünkü belirsiz bir dönüş değeri yerine, bu sefer de mesajın yazdırılıp yazdırılmadığından bağımsız olarak hep başarılı sonlanma anlamına gelen $(CODE 0) değerini döndürmektedir.
)

$(P
$(CODE return) deyimi unutulduğunda C++ programının $(CODE 0) döndüreceği standart tarafından garanti edilmiştir ama o da hatayı gözardı etmektedir; çünkü program başladığında $(CODE std::cout.exceptions())'ın değeri sıfırdır ve kimse $(CODE std::cout.bad())'e bakmamaktadır. Sonuçta mesaj doğru olarak yazdırılmamış bile olsa, her iki program da başarılı sonlandığını iddia etmektedirler. Yani aslında C ve C++ programlarının düzeltilmiş halleri alışık olduğumuzdan daha gösterişsizdirler:
)

---
#include <stdio.h>
int main()
{
  return printf("hello, world\n") < 0;
}
---

$(P
ve
)

---
#include <iostream>
int main()
{
  std::cout << "Hello, world!\n";
  return std::cout.bad();
}
---

$(P
Biraz araştırınca, "merhaba dünya" programının Java (yer darlığı nedeniyle kodunu göstermiyorum), J# (Java ile en ufak bir ilgisi olmayan bir dil), ve Perl gibi başka dillerde de her durumda başarı iddiasında bulunulduğunu görmekteyiz. Tam bir komployla karşı karşıya olduğumuzu düşünmek üzereyken, neyse ki Python ve C#'ta öyle olmadığını görüyoruz ve rahatlıyoruz: mesaj yazdırılamadığında ikisinde de hata [exception] atılır.
)

$(P
Peki bu programın D halinde durum nasıl? Hiçbir değişiklik gerekmez, çünkü bir sorun çıktığında $(CODE writeln) hata atar; $(CODE main) içinde oluşan hatalarla ilgili mesajlar eğer mümkünse standart hata akımına yazdırılırlar; ve program da bir hata koduyla sonlanır. Yani program yazıldığı haliyle zaten doğru çalışmaktadır. Diğer dillere böyle haksızca sataşmamın iki nedeni var. Birincisi, "merhaba dünya" programları hep böyle hileliler diye milyonlarca programcının sokaklara dökülerek ayaklandığını hayal etmek oldukça komik. (Gözünüzde canlandırın: "Merhaba dünya! Çıkış kodunun 13 olması bir tesadüf mü?" veya "Merhaba koyunlar! Uyanın artık!" vs.) İkincisi, maalesef bu programlar yaygın bazı programcı davranışlarını sergilemektedirler. Öte yandan D, doğru olanı yapmanıza izin vermek yanında, en kolay yöntemin aynı zamanda en doğru yöntem olduğunu da sağlamaya çalışmaktadır. Kolaylık ve doğruluk arasındaki bu özdeşlik, programcılıkta aslında sandığımızdan çok daha sık olarak karşımıza çıkar. (Bu arada benim kodumun yanlış olduğunu da düşünmeyin; $(CODE void main()) D'de yasaldır ve tam da düşündüğünüz şekilde çalışır. Sonuçta, yeni başlayanları $(CODE int main()) yerine $(CODE void main()) yazdılar diye C++ forumlarında haşlayan titizler, D'ye geçtiklerinde kendilerine yeni uğraşlar bulmak zorunda kalacaklar.)
)

$(P
Söz diziminden bahsedecekken anlam konularına kaydık. Söz dizimine dönersek; D'de C++, C# ve Java'da olmayan dikkate değer bir fark var: D'de parametreli türler $(CODE T&lt;X, Y, Z&gt;) yerine $(CODE T!(X, Y, Z)) olarak gösterilirler ($(CODE T&lt;X&gt;) yerine de $(CODE T!(X)) veya daha kısaca $(CODE T!X) kullanılır). C++'da bu konuda açılı parantezlerin seçilmiş olması; $(CODE &lt;), $(CODE &gt;), ve $(CODE &gt;&gt;) işleçleriyle çakıştığı için büyük gramer sorunlarına yol açmıştır. Böyle belirsiz durumları gidermek için de rasgele kabul edilebilecek kurallar gerekmiştir. Hatta dünyanın en az bilinen söz dizimi kuralı da bu şekilde ortaya çıkmıştır: $(CODE nesne.template fonksiyon&lt;arguman&gt;()). Süpermen düzeyinde iyi C++'cı olan bir arkadaşınıza o söz diziminin ne anlama geldiğini sorun; arkadaşınızın büyük olasılıkla Kriptonit kullanmak zorunda kaldığını göreceksinizdir. Açılı parantezler Java ve C#'ta da kullanılmaktadır fakat o diller aritmetik ifadelerin parametre olarak kullanılmasına izin vermezler; ama sonuçta böyle bir olanağın ileride eklenme şansı da ortadan kalkmıştır. D bu konuda geleneksel birli $(CODE !) işlecini ikili olarak kullanır ve parametreleri geleneksel parantezlerle gösterir (parantezleri hep doğru sayıda kapatıyorsunuzdur (değil mi?)).
)

$(H5 Derleme modeli)

$(P
D'de derleme, erişim denetimi, ve modül kavramlarının temeli dosyadır. Paketleme kavramının temeli de klasördür; bu konuda daha fazla karmaşıklık getirmez. Program kodunun daha gelişmiş bir veri tabanında bulunmasına gerek görülmez. D'nin yaklaşımı olan dosya ve klasör kavramı da zaten bir tür $(I veri tabanı)dır. En iyi programcılar tarafından uzun emekler sonucunda geliştirilmiş olan dosya ve klasör modeli sayesinde şu araçları da hazır olarak kullanma şansımız doğar: sürüm denetimi [version control], yedekleme, işletim sistemi düzeyinde koruma, günlükleme [journaling], vs. Böylece program geliştirmeye başlamak için gereken araçlar da ikiye inmiş olur: metin düzenleyici ve derleyici. Aslında D'de araçlar konusunda henüz fazla gelişme kaydedildiğini söyleyemeyiz ama yine de şunlar mevcut: Emacs'te d-mode modu, Eclipse'in Descent eklentisi, Linux'ta hata ayıklayıcı ZeroBugs, ve Poseidon geliştirme ortamı...
)

$(P
D'de kod üretimi bildiğimiz derleme ve bağlama adımlarından oluşur ama benzerlerinden çok daha hızlıdır; bunun iki, hayır üç nedeni var. Birincisi; dilin grameri sözcükleme [lexing], ayrıştırma [parsing], ve çözümleme [analysis] adımlarını birbirlerinden ayrı ve çok hızlı olarak yapmaya olanak verir. İkincisi; başka derleyicilerin çoğunda olduğu gibi program parçalarını [object file] ayrı ayrı oluşturmak yerine, D derleyicisine herşeyi önce bellekte oluşturmasını ve en sonunda diske yazmasını söyleyebilirsiniz. Üçüncüsü; D'nin yaratıcısı ve ilk gerçekleştiricisi olan Walter Bright, en iyileme [optimization] konusunda son derece deneyimli ve uzman birisidir. Geliştirme aşamalarındaki beklemelerin az olması D'yi çok güçlü bir yorumlayıcı [interpreter] haline de getirir ($(CODE #!/bin/sh) yazımındaki gibi $(CODE #!) bile desteklenir).
)

$(P
D ayrı ayrı derlemeyi destekleyen gerçek bir modül sistemine sahiptir. Modül özetlerini (başlık dosyalarının entel ismi) kaynak dosyalarından otomatik olarak öğrenebilir. Böylece başlık dosyalarıyla kendimiz ilgilenmek zorunda kalmayız; ama istersek bizim yazmamıza da izin verilir; ve bu konunun şikayet edilecek tarafı da kalmamış olur.
)

$(H5 Bellek modeli ve çok çekirdekliler [manycores])

$(P
C fonksiyonlarını doğrudan çağırıyor olması D'nin de C bellek modeli üzerine kurulu olduğunu düşündürmüş olabilir. Öyle olabilse gerçekten iyi olurdu ama ne yazık ki bu, paralel mimarileri ile yüksek işlem gücü sağlayan çok çekirdekli işlemciler yüzünden olanaksızdır. Çok çekirdekliler artık günlük hayatımızdalar; C'nin bu konudaki yaklaşımı ise ne yazık ki çok sıradan ve hataya açık olarak kalmıştır. Yordamsal ve nesne yönelimli bazı başka diller ise bu konuda ancak pek az gelişme gösterebilmişlerdir ve bu durum, paralel işlemlerle ilgili sorunları değişmezlik [immutability] kavramının yardımıyla aşan fonksiyonel dillerin tekrardan gündeme gelmesine neden olmuştur.
)

$(P
Yeni bir dil olduğu için iş parçacıkları [threads] konusunda D çok şanslı bir durumdadır; D'nin bellek modeli diğer modellerden köklü farklılıklar içerir. İş parçacıklarıyla şu şekilde çalışmaya alışmışızdır: iş parçacığı başlatmak için bir fonksiyon çağrılır ve bu yeni iş parçacığı bütün programın belleğini görebilen ve değiştirebilen bir duruma geliverir. Veya seçime bağlı olarak, işletim sistemine bağlı bazı yöntemler kullanılarak iş parçacığına özel [thread-private] bellek de kullanılabilir. Şimdiye kadar yalnızca bir sorun olarak görülen bu durum, günümüzde bir kabus halini almıştır. Dünün sorunları, verinin eş zamanlı olarak değişmesinin getirdiği doğal bir sonuçtu: verinin hep geçerli bir durumda olmasını sağlamak amacıyla bütün değişikleri takip etmek, ve değişikliklerin doğru sırada yapılmalarını hedeflemek son derece güç bir iştir. Ama insanlar yine de bu durumu kabul etmek zorundaydılar; çünkü paylaşımlı bellek, donanımı çok sadık olarak modellemekteydi ve doğru çalıştığında çok verimli olmaktaydı. Şimdi $(I kabus) konusuna geliyoruz: günümüzde bellek eskiden olduğundan daha az paylaşımlıdır. Bugünkü donanımlarda işlemciler belleği daha katmanlı bir şekilde kullanmaktadırlar; her bir çekirdeğin kendine özel bir belleği vardır! Sonuçta paylaşımlı bellek yalnızca zor yöntem olmakla kalmamış, yavaş olan yöntem haline de gelmiştir; çünkü paylaşımlı bellek, artık donanımı sadık bir şekilde modellememektedir.
)

$(P
Geleneksel diller bu tür sorunlarla uğraşırken, fonksiyonel diller bu konuya matematiksel saflıkla yaklaşıyorlardı: donanımı modellemekle değil, gerçek matematiği modellemekle ilgileniyorlardı. Matematik çoğunlukla değişim [mutation] içermediğinden ve zamandan bağımsız olduğundan, paralel işlemler için çok uygundur. (Matematikçilikten dönme o ilk programcıların paralel işlemeyi ilk duyduklarında nasıl sevinmiş olabileceklerini hayal edebiliyorum.) Böyle bir modelin sırasız ve paralel işlemlere ne kadar uygun olduğu fonksiyonel programcılıkta başından beri biliniyordu. Ama bu uygunluk daha çok $(I saklı bir enerji) olarak duruyordu; günümüzde olduğu gibi bir amaç olarak görülmüyordu. Paralel işlemler kullanan ciddi programların en azından bazı bölümlerinin fonksiyonel ve değişimden bağımsız olarak yazılmalarının önemi günümüzde daha iyi anlaşılmaktadır.
)

$(P
Bu konuda D'nin aldığı tutum nedir? D'nin paralelliğe yaklaşımı temel bir kavram üzerine kuruludur: Belleğin öncelikle iş parçacığına özel olduğu varsayılır, ve ancak istendiğinde paylaşımlı olarak kullanılır.
)

$(P
D'de bütün bellek, hatta globaller bile, öncelikle onu kullanan iş parçacığına özeldir. Paylaşılmak istenirse nesneler $(CODE shared) anahtar sözcüğü ile bildirilirler ve ancak ondan sonra başka iş parçacıkları tarafından da görülebilirler. Burada önemli olan, tüm sistemin $(CODE shared) olan nesnelerden haberli olması, ve o nesnelere erişimin doğru sırada yapılmasını sağlamak için bazı kısıtlamalar getirmesidir. Bu model, nesnelerin paylaşımlı olduklarını varsayan dillerdeki bir sürü belalı sorunu böylece ortadan kaldırır. O dillerde nesnelerin hangilerinin paylaşıldıkları bilinmediği için programcıya güvenilmekte ve programcının nesneleri doğru olarak bildirmiş ve kullanmış olması beklenmektedir. Ondan sonra da çeşitli durumları açıklamak için karmaşık kurallar gerekmiştir: paylaşılmayan veriler, paylaşımlı olarak bildirilmiş olan veriler, paylaşımlı oldukları bildirilmediği halde paylaşımlı olan veriler, ve bunların her türlü kombinasyonu... Bu kurallar da onları anlayabilen topu topu beş kişi için gayet açıkça yazılmıştır ve geri kalanlarımıza da pes etmekten başka çare kalmamıştır.
)

$(P
Çok çekirdekliler konusunda araştırma ve geliştirme çabaları yoğun olarak devam ettiği halde hâlâ iyi bir model bulunamamıştır. Ama özel bellek modeli üzerine kurulu olduğu için D'nin bu konuda önü açıktır: saf fonksiyonlar, kilitsiz nesneler [lock-free primitives], alışık olduğumuz kilitlere dayalı programlama, mesaj kuyrukları (henüz plan aşamasında), vs. Sahiplenme türleri gibi daha ileri konular da halen tartışılmaktadır.
)

$(H5 Değişmezlik [Immutability])

$(P
Buraya kadar tamam... Pekiyi matematiğin saflığı, değişmezlik, ve fonksiyonel kodlama gibi konulara ne oldu? D, fonksiyonel programlamanın ve değişmezlik kavramının paralel programlamadaki (ve başka konulardaki) önemini kabul eder ve hiçbir şekilde değişmeyecek olan nesneleri bildirmek için $(CODE immutable) anahtar sözcüğünü getirir. Aynı zamanda, D çoğumuzun yakından tanıdığı değişkenlik kavramını ve bu kavramın en iyi çözüm olduğu durumların varlığını da kabul eder. (Eğer siz çoğumuza dahil değilseniz, $(I bazılarımız) demiş olayım.) D'nin bu soruna yanıtı ilginçtir, çünkü böylece değişken ve değişmez nesneler kusursuzca bir araya getirilmiş olurlar.
)

$(P
Değişmez veriler neden bu kadar yararlıdır? Değişmez verilerin iş parçacıkları tarafından paylaşılmalarında erişim sırasının [synchronization] önemi ortadan kalkar. Doğal olarak da, hiç yapılmayan sıralama en hızlı sıralamadır... Buradaki ustalık, salt okunan [read-only] verilerin gerçekten yalnızca okunduklarını sağlamaktadır; yoksa zaten bu konuda hiçbir güvenceden söz edemeyiz. D, paralel programlamanın bu önemli özelliğini sağlayabilmek için fonksiyonel programlamaya eşi görülmemiş derecede destek verir. $(CODE immutable) olarak bildirilen verilerin değişmezlikleri derleme zamanında belirlenir; ve doğru yazılmış olan bir program $(CODE immutable) veriyi kesinlikle değiştiremez. Dahası, değişmezlik derinlemesinedir: değişmez bir alan içerisinden referansla geçtiğiniz başka bir alan da değişmezdir. (Neden? Çünkü öyle olmadığı zaman bütün sistem zayıflar: değişken verileri farkında olmadan paylaşmaya başlarız ve önlemeye çalıştığımız karmaşık kurallarla tekrar karşı karşıya geliriz.) Birbirlerine bağlı nesnelerin oluşturdukları alt grafların tamamı kolaylıkla $(CODE immutable) olarak bildirilebilirler. D'nin tür sistemi bunları tanıdığı için iş parçacıkları tarafından paylaşılmaları sağlanır ve tek işli [single-threaded] programlar için de eniyileme olanakları doğmuş olur.
)

$(P
Pekiyi özel bellek modelini benimseyen ilk dil D midir? Hiç de değil. D'yi diğerlerinden ayrı kılan, değişken ve değişmez verileri öncelikle özel olarak kabul ettiği tek bir bellek sistemi altında barındırmasıdır. Aslında bu konuda anlatacak çok ayrıntı var; biz yine tanıtıma devam edelim.
)

$(H5 Güvenlik ön planda)

$(P
Bir sistem dili olması nedeniyle D, son derece verimli ama bir o kadar da tehlikeli olanaklar sunar: denetimsiz işaretçiler, programcının elle yapabildiği bellek denetimi, ve en dikkatli tasarımları bile mahvedebilecek tür dönüşümleri. Bununla beraber, modüllerin güvenli olduklarını bildirebilme olanağı ve o olanağı desteklemek için bellek güvenliği sağlayan ve SafeD olarak adlandırılan bir derleme şekli de sunar. Yine de bu şekilde başarılı olarak derlenmiş olması; ne kodun taşınabilir olduğunu, ne güvenli olarak programlandığını, ne de birim testler [unit testing] gerektirmediğini gösterir. SafeD yalnızca bellek hatalarının [memory corruption] olasılığını azaltır.
)

$(P
Böyle güvenli modüller (veya güvenli derleme); işaretçileri olduklarından farklı kullanma ve yığıt nesnelerinin adreslerini fonksiyonlardan döndürme gibi bütün tehlikeli dil olanaklarını daha derleme zamanında önler. SafeD'de bellek hatalarıyla karşılaşamazsınız. Aslında bütün büyük programların kodlarının çoğunluğu böyle güvenli modüllerden oluşmalıdır; bu programların $(I sistem) modüllerinin az sayıda olmasına çalışılmalı, ve sistem modüllerinin kod incelemeleri [code review] çok dikkatlice yapılmalıdır. Çoğu program tamamen SafeD ile yazılabilir, ama tabii bellek ayırma gibi işleri halleden bazı modülleri yazarken biraz el emeği de gerekecektir. Böylelikle, programın bazı bölümlerini başka bir dilde yazmak gerekmemiş olur. SafeD henüz hazır değil; bu yazı yazıldığı sırada SafeD'nin gelişimi halen devam etmekteydi.
)

$(H5 Kabul, başka yollar da olabilir)

$(P
D'nin çok paradigmalı olduğunu söylerken, bazı seçimler sırasında çatışmaların gerekmeyebileceğini kastediyoruz. ["It doesn't have an axe to grind."] D bu konuyu kavramıştır... Herşeyin nesne, fonksiyon, liste, eşleme tablosu, veya Noel Baba olması gerekmez. Ne oldukları size kalmış olmalıdır. Bu yüzden D programcılığı özgürlükler getirir, çünkü bir sorunu çözmeye çalışırken eldeki olanakları o çözüme uydurmak için çabalamak gerekmez. Buradaki bir gerçeği de dile getirmek gerekiyor: özgürlüklerle birlikte sorumluluklar da gelir; bu sefer de çözüm için hangi tasarımın daha uygun olacağına karar vermek için zaman harcamak gerekecektir.
)

$(P
D bu konuda C++'nın izinden yürür; $(I doğru olan tek yol) gibi bir ısrarı yoktur. Ek olarak, D her paradigmaya daha fazla destek verir, paradigmalar arasında daha fazla uyum sağlar, ve seçilen paradigmaların izlenmesinde daha az engel çıkartır. Burada aslında iyi bir öğrenciyle karşı karşıyayız; D C++'tan çok şey öğrenmiştir. Daha az seçici diller olan Java, Haskell, Eiffel, Javascript, Python, ve Lisp'ten de etkilenmiştir. (Aslında çoğu dil Lisp'ten bir şeyler almıştır ama bazıları bunu itiraf edemez.)
)

$(H5 Nesne yönelimli olanaklar)

$(P
D'de hem $(CODE struct) hem de $(CODE class) var. Bunların birçok özellikleri aynı olsa da amaçları farklıdır: $(CODE struct)'lar değer türleridirler [value types], $(CODE class)'lar ise dinamik çokşekillilik [dynamic polymorphism] amacıyla ve yalnızca referans ile kullanılırlar. Böylelikle karışıklıkların, dilimleme [slicing] hatalarının, ve $(CODE $(GREEN //&nbsp;Bu&nbsp;siniftan&nbsp;turetmeyiniz!)) gibi açıklama satırlarının önüne geçilmiş olur. Türler tasarlanırken onların tekşekilli değer mi oldukları yoksa çokşekilli referans mı oldukları başından belirlenir. C++ bu kavramları karışık olarak kullanmaya izin vermesiyle tanınmaktadır; ama gerçekte bunların kullanımları hem nadirdir, hem hataya açıktırlar, hem de zaten tartışmaya açık olduklarından bütünüyle engellemek en doğrusudur.
)

$(P
D'nin nesne yönelimliliği Java ve C#'ınkine benzer: gerçekleştirme olarak tekli, arayüz olarak çoklu kalıtım... Ama D bunu çoklu kalıtımın zararlı olduğu savını sürdürmek için yapmaz; verilerin çoklu kalıtımda yer almalarının ve etkin olarak gerçekleştirilmelerinin ne kadar zor olduğunu kabul ettiği için yapar. Çoklu kalıtımın yararlarını olabildiğince, ama denetimli olarak sunabilmek için birden fazla türden türetmeye şu şekilde izin verir:
)

---
class GereçÜstSınıfı { ... }
class Alet { ... }
class Gereç : GereçÜstSınıfı, Arayüz1, Arayüz2
{
    Alet Alet_döndür() { ... }
    alias Alet_döndür this;  // Gereç Alet'ten türemiş olur
}
---

$(P
$(I [Çevirenin notu: Örnekteki Türkçe harfler dikkatsizlik yüzünden değil: D, kaynak kodlarda Unicode'u destekler!])
)

$(P
Burada $(CODE alias)'ın anlamı şudur: $(CODE Alet)'in gerektiği bir durumda elimizde bir $(CODE Gereç) varsa, derleyici $(CODE Alet_döndür)'ü çağırarak $(CODE Alet) edinir. Burada fonksiyon çağrısı tamamen şeffaf olarak gerçekleşir; zaten öyle olmasaydı $(I alt tür) kavramı değil, olsa olsa ona yakın bir şey olabilirdi. (Bu size imalı geldiyse, imalı olduğu içindir.) Dahası, $(CODE Alet_döndür) döndürdüğü tür konusunda da tam yetki sahibidir: örneğin isterse $(CODE this)'in bir alt türünü döndürür, isterse de yepyeni bir nesneyi. Gereken durumlarda yine de bazı fonksiyon çağrılarını yakalamak için yönlendirmeler yapmak da gerekebilir. Ama ilk bakışta bir sürü kod tekrarı gerektirecek gibi görünse de, burada da D'nin yansıma [reflection] ve kod üretme olanaklarından yararlanılır. Burada temel fikir, D'nin $(CODE alias this) ile yeni alt türler oluşturmaya izin vermesidir. Bu sayede $(CODE int)'ten bile yeni türler türetilebilir.
)

$(P
D nesne yönelimli programcılık deneyimlerinden edinilen yararlı başka yöntemler de getirir: aşırı yüklemenin yanlışlıkla yapılmasını engellemek için açıkça yazılması gereken $(CODE override) sözcüğü; sinyallere [signal] ve yuvalara [slot] doğrudan destek; ve tescilli olduğu için tam adını veremeyeceğim için $(I sözleşmeli programlama) [contract programming] diyeceğim bir yöntem. $(I [Çevirenin notu: Yazar burada Eiffel programlama dilinin tescilli ifadesi "Design by Contract" özelliğine gönderme yapıyor.])
)

$(H5 Fonksiyonel programlama)

$(P
Çabuk cevap verin: Fibonacci serisi fonksiyonel programlamaya uygun olarak nasıl yazılır?
)

---
uint fib(uint n)
{
  return n < 2 ? n : fib(n -1) + fib(n -2);
}
---

$(P
Fantaziler kurmaktan hoşlandığımı itiraf ediyorum. Fantazilerimden birisi zamanda geriye gitmek, Fibonacci'nin bu yazımını tamamen ortadan kaldırmak, ve böylelikle bilgisayar öğretmenlerinin onu öğretmelerine başından engel olmaktır. (Listemde kabarcık sıralama [bubble sort] ve O(n log n) yer kullanan $(CODE quicksort) algoritmaları da var. Ama bu $(CODE fib) o ikisini gölgede bırakır. Ayrıca Hitler veya Stalin'i ortadan kaldırmanın bile yararları tartışılır olsa da, $(CODE fib)'i ortadan kaldırmak gayet iyi olur.) $(CODE fib) fonksiyonunun çalışma süresi $(CODE n) ile üstel olarak değiştiği için; bu şekilde yazılmış olması, karmaşıklık ve işlemlerin bedeli gibi kavramlardan tamamen habersizlik anlamına gelir; sevimliliğin baştansavmacılığa yeğlenmesinin bir örneğidir, ve savurganlıktır. Üstel çalışma süresinin ne kadar kötü olduğu herkesçe biliniyor mu? Benim bilgisayarımda $(CODE fib(10)) ve $(CODE fib(20)) farkedilmeyecek kadar çabuk çalışıyor, ama $(CODE fib(50)) on dokuz buçuk dakika tutuyor. $(CODE fib(1000)) ise herhalde bütün insanlık tarihinin sonuna kadar sürecektir. Belki de insanlık tarihinin sonunu görmek bu fonksiyonu öğretmeye devam ettiğimiz için hiç olmazsa bir teselli olur.
)

$(P
O zaman fonksiyonel Fibonacci'yi $(I çevreci) olarak nasıl yazabiliriz?
)

---
uint fib(uint n)
{
  uint ilerlet(uint i, uint fib_1, uint fib_2)
  {
    return i == n
      ? fib_2
      : ilerlet(i + 1, fib_1 + fib_2, fib_1);
  }
  return ilerlet(0, 1, 0);
}
---

$(P
Bu fonksiyon $(CODE fib(50))'yi gözardı edilebilecek kadar hızlı hesaplar, çünkü bu gerçekleştirme O(n) zaman alır. Bellek karmaşıklığını da kuyruk eniyileştirmesi [tail call optimization] halleder. Bu yeni $(CODE fib)'in sorunu ise eskisi kadar gösterişli olmamasıdır. Yeni $(CODE fib), fonksiyon parametresi kılığında iki durum değişkeni kullanmaktadır. Döngüyü ve bu değişkenleri daha açık olarak şöyle yazabiliriz:
)

---
uint fib(uint n)
{
  uint fib_1 = 1, fib_2 = 0;
  foreach (i; 0 .. n)
  {
    auto t = fib_1;
    fib_1 += fib_2;
    fib_2 = t;
  }
  return fib_2;
}
---

$(P
Eyvah! Ama bu artık fonksiyonel değil! Döngü içindeki o iğrenç dönüşümlere bakın hele! Maalesef yanlış bir adım attık ve matematiksel saflık zirvesinden düşerek basit günahkarların düzeyine inmiş olduk.
)

$(P
Ama şöyle bir düşünecek olursak, döngülü $(CODE fib)'in o kadar da ayıplanır bir tarafı olmadığını görürüz. Kapalı bir kutu olarak görecek olursak, $(CODE fib) verilen aynı giriş değerlerine karşılık hep aynı çıkışı üretmektedir. Yani bu anlamda saftır. Özel durum değişkenleri kullandığı için teorik olarak daha az fonksiyonel oduğunu söyleyebiliriz tabii, ama özünde fonksiyoneldir. Bu düşünceye devam edersek çok ilginç bir sonuca varırız: bir fonksiyondaki durum değişkenleri tamamen geçici iseler (yani program yığıtındaysalar) ve özelseler (yani onları değiştirebilecek başka fonksiyonlara referans olarak geçirilmemişlerse), fonksiyon saf olarak kabul edilebilir.
)

$(P
İşte D'deki fonksiyonel saflığın tanımı da budur: saf bir fonksiyon içerisinde geçici ve özel değişiklikler yapılabilir. Bu tür fonksiyonların bildirimlerine $(CODE pure) koyulur:
)

---
pure uint fib(uint n)
{
  ... döngülü kod ...
}
---

$(P
Saflık kavramını böylece gevşek bırakan D, iki açıdan yarar sağlamış olur: bir tarafta çok sağlam bir saflık garantisi, öte yanda döngülü gerçekleştirmeler tercih edildiği durumlardaki kodlama rahatlığı. Bundan daha güzel bir şey olabilir mi...
)

$(P
Fibonacci serisinin fonksiyonel dillerde aslında bir yazımı daha vardır: $(I sonsuz liste) denen yöntem... Fonksiyon yazmak yerine, sonsuz ve tembel bir liste oluşturulur ve bu listeden Fibonacci sayıları istendikçe çekilirler. Böyle tembel listeler D'de çok güzel bir şekilde tanımlanırlar. Örneğin aşağıdaki kod, ilk 50 Fibonacci sayısını oluşturmaktadır. (Bu örneği çalıştırmak için $(CODE std.range)'i eklemeniz gerekir.)
)

---
foreach (f; take(50, recurrence!("a[n-1] + a[n-2]")(0, 1)))
{
  writeln(f);
}
---

$(P
Aslında tek satır bile değil, yarım satır! Orada $(CODE recurrence)'ın anlamı, $(CODE 0) ve $(CODE 1) ile başlayan ve $(CODE "a[n-1] + a[n-2]") formülünü kullanan sonsuz bir liste oluşturmaktır. Bu ifadenin hiçbir noktasında ne dinamik bellek ayrılır, ne bir fonksiyon çağrılır, ne de geridönüşümsüz bir kaynak kullanılır. Sonuçta bu kod, daha önce gördüğümüz döngülü fonksiyonun eşdeğeridir. Bunun nasıl işlediği bir sonraki bölümde anlatılıyor.
)

$(H5 Şablonlarla türden bağımsız programlama [Generic programming])

$(P
(Hani çok beğendiğiniz bir filmi, kitabı veya bir müziği birisine anlatırken fazla abartmamaya ve karşınızdakinin beklentilerini fazla yükseltmemeye çalışırsınız ya... D'nin türden bağımsız programlama olanağını anlatırken aynı hisler içerisindeyim.) Aslında türden bağımsız programlamanın birden fazla tanımı vardır; hatta $(LINK2 http://www.wikipedia.com, Wikipedia)'daki tarafsız tanımı bile hâlâ tartışmalara neden olmaktadır. Bazı insanlar onu $(I parametreli türlerle programlama) olarak kabul ederler (templates, generics); başkaları ise $(I algoritmaları olabildiğince genel olarak, ama karmaşıklık güvencelerini de koruyacak şekilde ifade etmek) olarak görürler. Bunlardan ilkine bu bölümde, ikincisine de bir sonraki bölümde değineceğim.
)

$(P
Türleri parametreli olabilen $(CODE struct)'lar, $(CODE class)'lar ve fonksiyonlar D'de çok basit bir söz dizimi ile tanımlanırlar. Örneğin bir $(CODE min) fonksiyonu şöyle yazılabilir:
)

---
auto min(T)(T a, T b) { return b < a ? b : a; }
...
auto x = min(4, 5);
---

$(P
Burada $(CODE T) tür parametresidir, $(CODE a) ile $(CODE b) de fonksiyon parametreleridir. Dönüş türünün $(CODE auto) olması, $(CODE min)'in döndürdüğü türün derleyici tarafından belirlendiği anlamına gelir. Bu da bir liste sınıfının özü:
)

---
class Liste(T)
{
  T değer;
  Liste sonraki;
  ...
}
...
Liste!int sayılar;
---

$(P
Aslında eğlence daha yeni başlıyor. Bu konunun hakkını vermek bu kadar kısa bir yazı içinde mümkün olmadığı için, sonraki paragraflarda başka dillerden olan farklılıklarını anlatacağım.
)

$(H5 Parametre çeşitleri)

$(P
Şablonlarda parametre olarak türler yanında sayılar (tam veya kesirli), dizgiler, derleme zamanında bilinen $(CODE struct) değerleri, ve $(CODE alias)'lar da kullanılabilir. Takma isim anlamına gelen $(CODE alias)'lar programdaki herhangi bir ismin yerini alabilirler: değer, tür, fonksiyon, ve hatta başka bir şablon. (D, sonsuz şablon şablon şablon ... parametre sorunundan da böylece sıyrılmış olur; çünkü o durumlarda parametre $(CODE alias) olarak geçirilir.) $(CODE alias) parametreler lambda fonksiyonlarında da işe yararlar. Belirsiz sayıda [variadic] parametreler de desteklenmektedir.
)

$(H5 Dizgi [string] işlemleri)

$(P
Derleme zamanında değiştirilemeseler, dizgileri şablon parametresi olarak kullanmak anlamsız olurdu. D, bütün dizgi işlemlerine derleme zamanında bile izin verir: ekleme, indeksleme, alt dizgi seçme, üzerinde ilerleme, karşılaştırma, vs.
)

$(H5 Kod üretme: Bir anlamda $(I türden bağımsız programlama çeviricisi [assembler]))

$(P
Derleme zamanındaki dizgi işlemleri her ne kadar ilginç olsalar da verilerle kısıtlı kalmak zorundadırlar. Bunun bir ileri aşaması, dizgileri $(CODE mixin) ifadesi yoluyla koda çevirme olanağıdır. $(CODE recurrence) örneğini hatırlıyor musunuz? Fibonacci serisinin formülünü $(CODE recurrence)'e bir dizgi olarak veriyorduk. İşte o dizgi daha sonra koda dönüşür ve parametreler de o koda geçirilirler. Başka bir örnek olarak, bir aralıktaki nesnelerin D'de nasıl sıraya dizildiklerine bakabilirsiniz:
)

---
// bir tamsayılar dizisi
auto dizi = [ 1, 3, 5, 2 ];

// küçükten büyüğe doğru sıralama
sort(dizi);

// bir lambda fonksiyonu yardımıyla ters sırada
sort!((x, y) { return x > y; })(dizi);

// yine ters sırada ama bu sefer kod üretme olanağı ile
// ve parametreleri geleneksel isimleri a ve b olarak
// tanımlayan bir karşılaştırma
sort!("a > b")(dizi);
---

$(P
Kod üretme aslında çok önemli bir özelliktir, çünkü dilde bulunmayan yeni olanaklar sağlar. Örneğin D'de bit alanları [bit fields] bulunmadığı halde standart modül $(CODE std.bitmanip) bütün bit işlemlerini çok da etkin bir biçimde gerçekleştirir.
)

$(H5 İçgözlem [Introspection])

$(P
İçgözlem, yani bir kod birimini inceleyebilme olanağı, bir anlamda kod üretmenin tümleyenidir; çünkü kodu üretmek yerine, üretilen koda bakmakla ilgilidir. Aynı zamanda kod üretmeye de yardımı olur; örneğin numaralama [enumeration] ile ilgili bir ayrıştırma fonksiyonu için gereken bilgiyi sağlar. Aslında içgözlem henüz bütünüyle desteklenmiyor ama eskisinden daha iyi bir tasarımı bitirilmiş durumda ve gerçekleştirilmeyi bekliyor.
)

$(H5 $(CODE is) ve $(CODE static if))

$(P
C++'da en basitinden olmayan şablon yazan hemen hemen herkes bir noktada şu iki şeye ihtiyaç duymuş ve büyük engellerle karşılaşmıştır: a&#41; belirli bir kodun derlenebilip derlenemeyeceğini kodun yazıldığı sırada saptayabilmek ve ona göre karar verebilmek, b&#41; Bool ifadelerini derleme zamanında işletebilmek ve sonuca göre kod üretebilmek. D'de derleme zamanında işletilen $(CODE is(typeof(ifade))) kullanımı, ifade doğru olduğunda $(CODE true), yanlış olduğunda da $(CODE false) sonucunu verir (derleme sonlanmadan). $(CODE static if) de $(CODE if) gibidir ama derleme zamanında işletilir ve derleme zamanında geçerli olan bütün Bool ifadeleriyle kullanılabilir (yani $(CODE #if)'in sonunda gerçekten işe yarayan halidir.) Salt bu iki özelliğin türden bağımsız programlamadaki güçlükleri yarıya indirdiğini söyleyebilirim. C++0x'in bunlardan birisini bile içermeyecek olması ise beni bütünüyle hayal kırıklığına uğratmıştır.
)

$(H5 Dahası var...)

$(P
Türden bağımsız programlama çok geniş bir konu... Her ne kadar D bu konuyu şaşırtıcı derecede az sayıda kavramla hallediyor olsa da, daha fazla bilgiyi iyice ayrıntılarına girmeden vermek mümkün değil. D'de başka olanaklar da var: uyarlanabilen hata mesajları, C++0x'teki kavramlara [concepts] benzeyen kısıtlamalı şablonlar, eşlemeler [tuples], D'ye has $(I yerel somutlama) denen bir özellik [local instantiation] (esnek ve etkin lambda'lar için gerekir), vs.
)

$(H5 Standart kütüphane hakkında bir kaç söz)

$(P
Daha önce de bahsettiğim gibi, bu konu biraz hassas ve politik. Phobos ve Tango adında oldukça kapsamlı iki değişik kütüphane var. Ben bunlardan yalnızca birincisini kullandığım için yazacaklarım yalnızca onunla ilgili olacak.
)

$(P
STL çıktığından bu yana topluluk ve algoritma kavramları yepyeni bir boyuta erişti. Bu o kadar önemli bir olgudur ki, STL'den sonra çıkıp da onu dikkate almayan kütüphaneler beceriksiz ve saf olarak kalma riski altındadırlar. (Dolayısıyla hangi dili kullanıyor olurlarsa olsunlar, bütün programcılara STL'yi mutlaka anlamalarını öneririm.) Bunun nedeni STL'nin mükemmel bir kütüphane olması değildir; çünkü STL zaten mükemmel değildir. STL mecburen C++'nın hem güçlü hem de zayıf taraflarına bağlı kalmak zorundaydı. Örneğin çok etkindir ama üst düzey programlama desteği iyi değildir. C++'ya olan bu yakınlığı, başka dil programcılarının STL'nin kavramlarını anlamalarını güçleştirebilir; çünkü STL'nin çok önemli olan özü, kütüphane olanaklarının arkasında farkedilmeden saklı kalmış olabilir. Dahası, STL'nin kendi hataları da vardır; örneğin kavramsal yapısı, bir sürü başka veri yapısına ve onların elemanları üzerinde ilerlemeye elverişli değildir.
)

$(P
STL'nin en yararlı tarafı, temel topluluklar ve algoritmalar içeren bir kütüphanenin nasıl tasarlanabileceği sorusunu yeniden ortaya atmış olması ve bu sorunun güzel bir yanıtını oluşturmasıdır. STL'nin sorduğu soru şudur: $(I Bir algoritma, üzerinde çalışacağı veriden en az ne istemelidir?) Bu konuya çoğu kütüphanecinin ve çoğu algoritma uzmanının bu kadar süre kayıtsız kalmış olması aslında şaşırtıcıdır. STL'nin yaklaşımı, birleştirici arayüzler [unifying interfaces] arayışından farklıdır. Birleştirici arayüzler örneğin indeksli erişimin hem dizilere hem de listelere uygun olduğunu savunurlar ve toplulukların yapısal özelliklerinin getirebileceği bazı doğal uygunsuzlukları gerçekleştirmelerle ilgili bir sorun olarak görürler. STL, bu tür görüşlerdeki kusurları açıkça ortaya serer; örneğin sıralı arama [linear search] gibi temel bir algoritmanın bile birleştirici bir arayüzde bulunmaması gerektiği açıktır (kimsenin karesel [quadratic] bir algoritmanın sonuçlanmasını beklemek istemeyeceğini varsayıyorum). Bu gerçekleri algoritmalarla ciddi olarak ilgilenen herkesin bilmesi gerekirken; algoritmaları anlamış olmakla, onların bir programlama dilinde nasıl gerçekleştirilebileceklerini görmek arasında her nasılsa bazı kopukluklar oluşmuştur. Örneğin algoritma temelleri konusunda deneyimli birisi olduğum halde, ben sıralı arama algoritmasındaki saflığı ve mükemmelliği on beş yıl önce STL'deki gerçekleştirmesini görene kadar kendim farkedememiştim.
)

$(P
Bu kadar sözün özü, Phobos'un da STL'ye benzer bir kütüphane olduğudur (belgelerinde $(CODE std.algorithm) ve $(CODE std.range)'e bakabilirsiniz). Bence aslında Phobos'un algoritmaları STL'ninkilerden iki nedenden ötürü daha iyidir. Birincisi, Phobos tabii ki kendisinden önceki kütüphanelerden yararlanma avantajına sahiptir. İkincisi, daha üstün bir dilden ve hem de tam anlamıyla yararlanmıştır.
)

$(H5 Aralıklar [ranges] iyi, erişiciler [iterators] değil)

$(P
STL'den en farklı tarafı, Phobos'ta erişicilerin bulunmamasıdır. Onda erişici soyutlamasının yerini aralık soyutlaması almıştır. Erişiciler kadar etkin olmalarının yanında aralıklar; sarma [encapsulation], doğruluk denetimi, ve soyutlama konularında çok daha güçlüdürler. (Dikkat ederseniz, erişicilerde temel işlemlerin hiçbirisi denetlenemez bile; garip...) Aralık kullanan kodlar en az erişici kullanan kodlar kadar hızlıdırlar, onlardan daha güvenlidirler, ve yazımları da daha kısadır. Böylece sonunda $(CODE for) döngüleri de tek satıra sığacak kadar kısa yazılabilmektedir. Aralıklar kullanan kod o kadar kısa ve özdür ki, erişicilerle yazıldığında çok külfetli olabilecek bir çok kodlama tarzının önü açılmış olur. Örneğin iki aralıkta art arda zincirleme olarak ilerlemeyi sağlayan $(CODE chain) diye bir fonksiyon düşünülebilir ve son derece de kullanışlıdır [chain: zincir]. $(CODE chain)'i erişici kullanacak şekilde yazmaya kalksak, giriş olarak dört erişici, çıkış olarak da iki erişici gerekeceği için; bu, kullanışsız olacak düzeyde hantaldır. Öte yandan, $(CODE chain)'i aralıklarla yazmak yalnızca iki giriş aralığı ve tek bir çıkış aralığı gerektirir. Dahası, belirsiz sayıda parametre olanağı [variadic] kullanıldığında $(CODE chain)'e belirsiz sayıda aralık verilebilir ve birdenbire kullanışlılığı iyice artmış olur. $(CODE chain), $(CODE std.range) modülünde tanımlanmıştır. Örneğin üç farklı dizinin elemanları üzerinde ilerlemek şu kadar kolaydır:
)

---
int[] a, b, c;
...
foreach (e; chain(a, b, c))
{
    // ... e'yi kullan ...
}
---

$(P
O kodda dizilerin birbirlerine eklenmediklerine dikkat edin! $(CODE chain) onları oldukları yerde bırakır ve dizileri sırayla ayrı ayrı gezer. Bunun sonucunda da $(CODE chain) yoluyla erişilerek yapılan değişikler dizilerdeki elemanların kendilerini değiştirmiş olurlar. Örneğin şu kodun ne yaptığını tahmin edin:
)

---
sort(chain(a, b, c));
---

$(P
Doğru bildiniz: dizilerin elemanları ortaklaşa olarak sıralanırlar; yani dizilerin boyları hiç değişmeden, en küçük elemanlar $(CODE a)'da olacak şekilde... Tabii bu sadece aralıkların ve aralık birleştiricilerinin algoritmalarla birlikte kullanıldıklarında ne kadar güçlü olduklarını gösteren küçücük bir örnek.
)

$(H5 Sonsuza kadar tembellik ve ötesi)

$(P
STL algoritmalarının (tabii başkalarının da) $(I hevesli) olduklarını söyleyebiliriz: fonksiyondan dönüldüğünde işlerini çoktan bitirmişlerdir. Phobos ise uygun olan yerlerde $(I tembel) davranır. Böylelikle Phobos'un birleştirme [composition] ve sonsuz aralıklarla çalışabilme gibi yetenekleri ortaya çıkmıştır. Örnek olarak üst düzey bir $(CODE map) fonksiyonunu ele alalım (fonksiyonel programlamada çok bilinen $(CODE map) fonksiyonundan bahsediyorum, STL'deki $(CODE map) topluluğundan değil); bu fonksiyon, kendisine verilen bir fonksiyonu yine kendisine verilen bir aralıktaki nesnelerle teker teker çağırır. Bu $(CODE map) hevesli olsa, iki sorun ortaya çıkardı. Birincisi, sonucu yerleştirmek için yer ayırması gerekirdi (örneğin bir liste veya bir dizi). İkincisi, fonksiyondan dönmeden önce aralıktaki bütün nesneleri kullanmış olması gerekirdi. Bunlardan birincisi etkinlikle ilgilidir: çoğu durumda bellek ayırmak zaten gerekmemelidir ve mümkünse kaçınılmalıdır (örneğin kullanıcının tek istediğinin $(CODE map)'in ürettiği sonuçlara sırayla bakmak olduğunu düşünün). İkincisi ise temel bir sorundur: hevesli $(CODE map) sonsuz aralıklarla çalışamaz, çünkü o zaman sonsuz iş yapması gerekir.
)

$(P
Phobos'taki map, bu nedenle tembel bir aralık döndürecek şekilde tasarlanmıştır; işini adım adım ve ancak kullanıcı elemanları sonuçtan okudukça halleder. Öte yandan $(CODE reduce) fonksiyonu (bir anlamda $(CODE map)'in tersidir) işini hevesli olarak yapar. Bazı işlemlerin de hem hevesli olanları, hem de tembel olanları gerekir. Örneğin $(CODE retro(r)) verilen $(CODE r) aralığını ters sırada bir aralık olarak döndürür, $(CODE reverse(r)) ise $(CODE r) aralığını olduğu yerde tersine çevirir.
)

$(H5 Sonuç)

$(P
Aslında böyle kısa bir tanıtım yazısında bile anlatacak başka şeyler olmalıydı: birim testler, UTF dizgileri, derleme zamanı fonksiyon çalıştırabilmek (bir anlamda derleme zamanındaki D yorumlayıcısı), dinamik kapamalar [dynamic closures], ve başka bir sürü olanak. Umarım ilginizi uyandırmayı başarabilmişimdir. Eğer kendinize acısız bir sistem programlama dili, usandırmayan bir uygulama dili, ilke sahibi olduğu halde burnu havada olmayan bir dil, veya en önemlisi, bütün bunların ağırlıklı bir bileşimi olan bir dil arıyorsanız, belki de sizin için de uygun olan D'dir.
)

$(P
Sorularınızı doğrudan yazara gönderebilirsiniz, ama daha da iyisi, news.digitalmars.com Usenet sunucusuna bağlanarak çok hareketli bir ortam olan digitalmars.d haber grubunda sorabilirsiniz.
)

Macros:
        SUBTITLE="Neden D", Andrei Alexandrescu

        DESCRIPTION=Andrei Alexandrescu'nun 'The Case for D' makalesinin Türkçe çevirisi 'Neden D'

        KEYWORDS=d programlama dili makale d tanıtım özellik olanak karşılaştırma andrei alexandrescu
