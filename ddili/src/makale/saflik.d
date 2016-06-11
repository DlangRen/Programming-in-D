Ddoc

$(H4 D'nin Saflık Kavramı)

$(P
  $(B Yazar:) $(LINK2 http://klickverbot.at/, David Nadlinger)
$(BR)
  $(B Çevirmen:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Çeviri Tarihi:) Ekim 2013
$(BR)
  $(B İngilizcesi:) $(LINK2 http://klickverbot.at/blog/2012/05/purity-in-d/, Purity in D)
)

<span style="font-size:1.1em">

$(P
Programlama dillerinin tasarımları tartışmaya açık konulardır. Buna rağmen, hem donanımda yaşanan gelişmelerin hem de belirli bir dilde yazılmış olan programların bakımlarının önemli konular olmaları nedeniyle daha önceden $(LINK2 http://en.wikipedia.org/wiki/Functional_programming, fonksiyonel programlamada) ortaya çıkmış olan kavramlar yeni dillerde tekrardan keşfedilmektedirler. $(LINK2 http://dlang.org/, D programlama dili) de $(I fonksiyonel saflık) konusuna kendi yaklaşımını getirir. Bu yazı D'nin $(C pure) $(ASIL saf) anahtar sözcüğünü tanıtmakta ve onun diğer olanaklarla nasıl etkileştiğini göstermektedir.
)

</span>

$(P
Saflık kavramı hem programcının hem de derleyicinin kaynak kodu anlama konusunda yararlandıkları güçlü bir araçtır. Bu olanağın yararlarına ve asıl kullanımlarına geçmeden önce $(C pure) anahtar sözcüğünün D'de tam olarak ne anlama geldiğine bakalım. Eğer bu kavramı başka dillerden tanıyorsanız lütfen bir süreliğine hiç duymamış gibi davranın. Bu kavramın D'deki gerçekleştirmesindeki küçük farkların büyük etkileri olduğunu göreceksiniz.
)

$(P
$(C pure), bir işlevi çağıran ile o işlev arasında bir sözleşme belirleyen bir niteliktir. Saf bir işlev değişebilen $(ASIL mutable) $(I evrensel) değişkenleri $(I kullanamaz). Burada "evrensel" ile kastedilen, işlevin parametreleri dışındaki tüm değerlerdir (işlevin parametreleri de iş parçacıkları arasında paylaşılabilen $(ASIL shared) veriler olamazlar). Ek olarak, burada "kullanamaz" sözü ile kastedilen, o değişkenlere okumak için de yazmak için de erişilemediğidir. Bunun tersi olarak, $(C pure) olarak işaretlenmemiş olan bir işlev de $(I saf değil) $(ASIL impure) olarak adlandırılır.
)

$(P
Yukarıdaki tanımın anlamı, saf bir işlevin aynı parametre değerlerine $(ASIL argument) karşılık olarak hep aynı yan etkiyi üreteceği ve aynı değeri döndüreceğidir. Dolayısıyla, saf bir işlev saf olmayan işlevleri çağıramaz ve klasik anlamda giriş ve çıkış işlemleri uygulayamaz.
)

$(P
Saflık kavramının fazla kısıtlayıcı olmasını engellemek adına, aslında izin verilmemesi gereken bazı yan etkiler yine de mümkün bırakılmıştır (isterseniz bu ayrıntıları atlayabilirsiniz):
)

$(UL

$(LI
$(I Programın sonlanması): D gibi bir sistem dilinde programın hemen sonlanabilmesi her zaman için olasıdır. Bunun önüne geçmek olanaksız olduğundan D'nin saflık kavramı buna açıkça izin verir.
)

$(LI
$(I Kesirli sayı işlemleri): x86 işlemcilerinde (ve belki başka işlemcilerde de) kesirli sayı hesapları evrensel bayrakların değerlerine bağlıdır. Bir işlev $(C x&nbsp;+&nbsp;y) veya $(C cast(int)x) kadar masum bile olsa tek x87/SSE kesirli sayı ifadesi içerse, o işlevin etkisi veya hata atıp atmayacağı programın evrensel durumuna bağlı demektir.$(DIPNOT 1) Dolayısıyla, saflık kavramının en katı tanımında tek kesirli sayı işlemine bile izin verilmemesi gerekir. Böyle bir karar fazla kısıtlayıcı olacağından, D'de saf işlevlerin kesirli işlem bayraklarını okumalarına ve onlara yazmalarına izin verilir. (Buna rağmen, bu gibi işlevlerin işlemlerinin sonunda o bayrakları tekrar eski değerlerine getirecekleri beklenir.)
)

$(LI
$(I Çöp toplayıcıdan bellek ayırmak): İlk bakışta gözden kaçabilse de, bellek ayırmak bile (örneğin $(C malloc) ile) programın evrensel durumu ile ilgili bir işlemdir çünkü sistemde ne kadar boş bellek bulunduğu evrensel bilgisinden yararlanmak zorundadır. Buna rağmen, bellek ayıramıyor olmak çok sayıda işlem için ciddi derecede kısıtlayıcı bir durum olurdu. Ancak, D'de çöp toplayıcıdan $(ASIL GC) $(C new) ile bellek ayrılamadığı zaman zaten $(C Error)'dan türemiş olan bir hata atılır. Dolayısıyla, saf işlevler de $(I tür sisteminin) $(ASIL type system) verdiği garantileri ihlal etmeden $(C new) işlecini çağırabilirler. ($(I Not: Aslında program yığıtının $(ASIL stack) kullanılması bile saflığı bozabilir çünkü yığıtın belirli bir andaki durumuna göre her işlev yığıt taşmasına $(ASIL stack overflow) neden olabilir.))
)

$(P
$(I Not: D'de üstesinden gelinemeyen hata türleri $(C Error) sınıfından türerler. Bu tür hatalar $(C @safe)$(DIPNOT 2) olmayan kodlar tarafından yakalanabilseler de $(C Error) hatalarının yakalanmalarından sonra tür sistemi artık programın işleyişi ve mutlak değişmezleri konusunda hiçbir garanti veremez.
)
)

)

$(H5 Referans saydamlığı $(ASIL referential transparency))

$(P
Fonksiyonel programlama dili dünyasında çok yaygın olarak geçen parametrelerin değişmezliği $(ASIL immutability) kavramının yukarıdaki tanımda geçmiyor olması size şaşırtıcı gelmiş olabilir. D'de saf işlevler parametrelerinde değişiklik yapabilirler. Örneğin, aşağıdaki kod D'de yasaldır:
)

---
int okuVeArttır(ref int x) pure {
  return x++;
}
---

$(P
Programlama dilleri açısından bakıldığında saflık kavramı normalde referans saydamlığını da içerir. Bunun anlamı, saf bir işlev çağrısı yerine o çağrının dönüş değerinin yerleştirilmesi sonucunda programın davranışında hiçbir değişiklik olmayacağıdır. Bu, D'nin varsayılan davranışı değildir. Örneğin, aşağıdaki kod
)

---
int değer = 1;
auto sonuç = okuVeArttır(değer) * okuVeArttır(değer);
// assert(değer == 3 && sonuç == 2);
---

$(P
$(C okuVeArttır)'ın tek kere çağrılması ile aynı sonucu doğurmaz:
)

---
int değer = 1;
auto geçici = okuVeArttır(değer);
auto sonuç = geçici * geçici;
// assert(değer == 2 && sonuç == 1);
---

$(P
Bir sonraki başlıkta da göreceğimiz gibi, bu aslında emirli dillerde çok aranan bir özelliktir. Buna rağmen, saflık kavramının klasik tanımının verdiği garantiler ve bunun getirdiği yararlar da göz ardı edilmemelidir. Bu konuda D'nin tür sisteminin başka bir özelliğinden yararlanılır: Veriye erişimin geçişli olarak $(C const) olarak işaretlenebilmesi veya verinin en başından $(C immutable) olarak tanımlanabilmesi$(DIPNOT 3). Bu konuyu biraz daha yakından incelemek için aşağıdaki üç işlev bildirimine bakalım:
)

---
int a(int[] val) pure;
int b(const int[] val) pure;
int c(immutable int[] val) pure;
---

$(P
Parametresi değişebilen türden olan $(C a)'nın durumu $(C okuVeArttır)'ınkinin aynısıdır ($(C int[]) türü bir gösterge ve bir uzunluktan oluşan ve belleğin bir bölgesine erişim sağlamaya yarayan bir dinamik dizidir). $(C b) ve $(C c) ise çok daha iyi durumdadırlar: Saf olduklarından bu işlevlerin programın evrensel durumunu okuyamadıklarını ve evrensel durumunda değişiklik yapamadıklarını biliyoruz. Dolayısıyla, $(C b) ve $(C c) işlevlerinin kelimenin yaygın anlamı ile $(I yan etkileri olmadığını) ve bu yüzden bu işlevlere yapılan çağrıların referans saydamlığına sahip olduklarını söyleyebiliriz.
)

$(P
Peki, $(C b) ile $(C c) arasındaki bir farklılıktan söz edilebilir mi? Saflık kavramı açısından hayır, çünkü $(C const) ve $(C immutable) işlevin parametre üzerindeki hakları konusunda aynı anlama gelir. ($(C immutable) ayrıca verinin kesinlikle değişmeyeceği garantisini de verir ama işlev saf olduğundan bu parametreye erişim sağlayan referanslar zaten işlevden dışarıya sızdırılamazlar (dönüş değeri dışında).)
)

$(P
Yine de, işlevi çağıranı ilgilendiren ince ama önemli bir farktan söz edilebilir: Bu fark, parametre değerinin gerçekte yalnızca $(C const) mı yoksa $(C immutable) mı olduğuna bağlıdır. Bunun nedeni, $(C const)'ın hem değişebilen hem $(C immutable) değerlere erişim sağlayabilmesine karşın $(C immutable)'ın yalnızca $(C immutable) olan veya $(C immutable)'a dönüşebilen değerlere erişim sağlayabilmesidir. Dolayısıyla, aşağıda yazılanlar $(C immutable) bir dizi ile çağrılan durumda hem $(C b) için hem de $(C c) için aynen geçerlidir.
)

$(P
Örnek olarak, $(I ifade değerlerini hatırlamaya) $(ASIL memoization) veya alt ifadelerin azaltılmalarına dayanan eniyileştirme yöntemlerini düşünelim. $(C pure) bir işleve aynı $(C immutable) değerlerle yapılan birden fazla çağrının teke indirilebilmesi için o değerlerin yalnızca kimliklerine bakılması yeterlidir. (Örneğin, yalnızca o değerlerin adreslerine bakmak gibi bir kaç basit karşılaştırma yaparak.) Öte yandan, $(C const) olan bir parametre değerinin değişebilen referanslar içerdiği durumda o referans iki çağrı arasında başka kodlar tarafından değiştirilebileceğinden, o referansların çalışma zamanında derinlemesine incelenmeleri veya derleyicinin program akışını derleme zamanında anlayabilmesi gerekir.
)

$(P
Aynı durum koşut işlemleri de etkiler: $(C pure) bir işlevin parametre değerlerinin referans içermediği veya yalnızca $(C immutable) referans içerdiği durumlarda işlemlerin koşut olarak işletilmelerinde bir sakınca yoktur çünkü o işlev programın davranışında belirsizliklere neden olabilecek yan etkiler oluşturamaz; ek olarak, parametre değerlerine erişim konusunda $(I yarış) $(ASIL data race) halinde de olunamaz. Ne var ki, $(C const) parametreleri inceleyerek aynı tür sonuçlara varılamayabilir çünkü aynı değerlere değişebilen çeşitten erişimi olan kodlar onları değiştirebilirler.
)

$(H5 Dönüş türünün referans içermesi)

$(P
Parametrelerinin değişebilme açısından farklılıklar göstermelerine karşın, yukarıdaki örneklerdeki $(C a), $(C b), ve $(C c) işlevlerinin  üçünün de dönüş türü bu gibi örneklerde sık kullanılan $(C int) idi. Peki, saf bir işlevin referans içeren bir tür döndürdüğü durumlarda neler önemli olabilir?
)

$(P
İlk önemli konu, referans saydamlığı göze alınırken eşitlik karşılaştırmalarında yararlanılan adreslerdir. Genelde fonksiyonel dillerde bir verinin belleğin hangi noktasında bulunduğunun önemi ya hiç yoktur ya da çok azdır. Bir sistem dili olan D bu kavramı da kullanıma sunar. Örneğin, bir dizi oluşturan ve o diziyi ilk $(C adet) adet asal sayı ile dolduran $(C ulong[]&nbsp;asallar(uint&nbsp;adet)&nbsp;pure) işlevine bakalım. $(C asallar) aynı $(C adet) değeri ile her çağrıldığında aynı sonucu üretiyor olsa da, o sonuçları içeren diziler her seferinde farklı adreslerde bulunacaklardır. Dolayısıyla, dönüş değerlerinde referans içeren işlevlerin referans saydamlığı göze alınırken bit düzeyindeki eşitlik kavramı ($(C is)) değil, mantıksal anlamdaki eşitlik kavramı ($(C ==)) önemlidir.
)

$(P
Referans saydamlığındaki ikinci önemli konu ise dönüş türünün değişebilen referanslar içerip içermediğidir. $(C asallar) işlevini kullanan aşağıdaki koda bakalım:
)

---
auto p = asallar(42);
auto q = asallar(42);
p[] *= 2;
---

$(P
$(C asallar)'a yapılan yukarıdaki ikinci çağrı yerine $(C q&nbsp;=&nbsp;p) işleminin gelemeyeceği açıktır çünkü o durumda $(C q) da $(C p) ile aynı bellek bölgesine erişim sağlayacağından çarpma işleminden sonra o da sonuçların iki katlarına sahip olmaya başlayacaktır. Genel açıdan bakıldığında, dönüş türünde değişebilen referanslar içeren saf işlev çağrılarının referans saydamlığı taşıdığı söylenemez; buna rağmen, bazı çağrılar çağıran taraftaki kullanımlara bağlı olarak yine de eniyileştirilebilirler.
)

$(H5 $(I Yarı saflık) ve getirdiği garantiler)

$(P
D'nin $(C pure) anahtar sözcüğünün ilk tasarımı çok daha sıkı kurallara bağlıydı. Dil, o zamanlarda bu yazının başında verilen tanıma uyan tek saflık kavramı içeriyor idiyse de, sonuçta kabul edilen ve daha gevşek kurallar getiren bugünkü saflık kavramının tartışmaları sırasında iki terim ortaya çıkmıştı: Yukarıdaki $(C okuVeArttır) ve $(C a) işlevlerinde de görüldüğü gibi, değişebilen parametrelere sahip işlevleri tanımlayan $(I yarı saf) $(ASIL weakly pure), ve $(C b) ve $(C c) işlevlerinde görüldüğü gibi, yan etkileri bulunmayan işlevleri tanımlayan $(I tam saf) $(ASIL strongly pure). Ancak, bu terimler konusunda tam bir anlaşma bulunmamakta ve bunların forumlardaki kullanımları sürekli olarak karışıklıklara neden olmaktadır; bu terimleri saflık kavramı tasarımında ilk ortaya atan Don Clugston bile artık kullanılmamalarını istemektedir.
)

$(P
Buna rağmen, belki de parametre ve dönüş türlerine bağlı olarak verilen garantilerin farklılıkları nedeniyle bu terimler hâlâ kullanılmaktadır. Çok basit olmalarına rağmen belki de kurallarına yabancı kalındığından D'deki saflık kavramı tam olarak anlaşılamamaktadır. Peki, saf işlevlerin parametrelerini değiştirmelerine neden izin verilmektedir?
)

$(P
D'deki saflık kavramının arkasındaki asıl güç, kuralları böyle yumuşatmanın aslında daha fazla sayıda işlevin $(I tam) saf olabilmelerini sağlamasıdır. Bunu göstermek için $(I id Software)'den tanınan John Carmack'ın $(I Functional Programming in C++) başlıklı $(LINK2 http://altdevblogaday.com/, #AltDevBlogADay) yazısından bir bölüm aktarayım. Yazı, fonksiyonel programlama ilkelerinin C++'a uygulanmasının yararlarını gösterir:
)

$(QUOTE
Programcılıkta saf işlevler verinin daha fazla kopyalanmasına neden olur; program hızı açısından bakıldığında bunun yanlış bir gerçekleştirme yöntemi olduğu açıktır. Bir uç örnek olarak, $(C ÜçgenÇiz) gibi bir işlev parametre olarak bir çerçeve ara belleği $(ASIL framebuffer) alır ve sonuç olarak içine üçgen çizilmiş olan yepyeni bir çerçeve ara belleği döndürür. Bunu yapmayın.  — <span style="font-size:.9em">$(LINK http://www.altdevblogaday.com/2012/04/26/functional-programming-in-c/)</span>
)

$(P
Yukarıdaki görüş doğrudur; çerçeve ara belleğinin her üçgen çizimi için tekrar kopyalanmasının iyi bir fikir olmadığı açıktır. Buna rağmen, üçgen çizen saf bir işlev D'de hızdan ödün vermeden de gerçekleştirilebilir! Böyle bir işlevin bildirimi aşağıdaki gibi olabilir:$(DIPNOT 4)
)

---
alias Renk = ubyte[4];
struct Köşe { float[3] konum; /* ... */ }
alias Üçgen = Köşe[3];
void üçgenÇiz(Renk[] çerçeve, const ref Üçgen üçgen) pure;
---

$(P
Bu kadarıyla iyi: Yukarıdaki alıntıda da belirtildiği gibi, $(C üçgenÇiz)'in referans saydamlığı taşıdığını söyleyemiyoruz çünkü çerçeve ara belleğine yazmak zorundadır. Yine de, $(C pure) belirteci sayesinde bu işlevin programın gizli veya evrensel durumunu kullanamadığından eminiz. Dahası, saf olması nedeniyle bu işlev başka saf işlevler tarafından da çağrılabilmektedir. Küçük örneğimize devam edersek, eğer her çerçeve için yeni bir ara bellek ayrılsaydı, üçgenlerden oluşan bir görüntüyü oluşturan bir işlev aşağıdaki gibi olurdu:
)

---
Renk[] sahneÇiz(
   const Üçgen[] üçgenler,
   ushort en = 640,
   ushort boy = 480
) pure {
   auto sahne = new Renk[en * boy];
   foreach (ref üçgen; üçgenler) {
      üçgenÇiz(sahne, üçgen);
   }
   return sahne;
}
---

$(P
$(C sahneÇiz)'in parametrelerinin değişebilen referanslar içermediklerine dikkat edin – parametrelerinde değişiklik yapan $(C üçgenÇiz)'i çağırdığı halde kendisi parametrelerinde değişiklik yapmamaktadır!
)

$(P
Bu her ne kadar zorlama bir örnek olsa da, emirli kod performansından ödün vermeyen D'de benzer durumlarla sık karşılaşılır (örneğin, değişebilen toplulukların saf işlevler içinde geçtikleri her durum). Bu konu saflık kavramının yukarıda anlatılan ilk tasarımından edinilen deneyimlere de uymaktadır – saflık kuralları yumuşatıldığında, aynı güçlü garantiler çelişkili bir biçimde daha çok sayıda kod için sağlanabilmektedir.
)

$(P
Çoğu modern kodlama standardı zaten evrensel değişkenlerden kaçınılmasını önerdiğinden, giriş çıkış işlemleri ile ilgilenmeyen çoğu D işlevi kolaylıkla $(C pure) olarak işaretlenebilir. Bu doğru olduğuna göre neden varsayılan belirteç $(C pure) olmamıştır ve diğer işlevlerin örneğin $(C impure) diye işaretlenmeleri gerekmemiştir? D'nin ikinci sürümü açısından bakıldığında bunun nedeni saflık kavramının son tasarımının dilin gelişmesinin sonlarına rastlaması ve böyle bir değişikliğin halihazırda yazılmış olan kodları etkileme riskinin fazla yüksek olmasıdır. Yine de bu, gelecekteki başka diller ve belki de D'nin bir sonraki ana sürümü açısından dikkate alınacak bir fikirdir.
)

$(H5 Şablonlar ve saflık)

$(P
Bu noktaya kadar saflık tasarımını başka olanaklardan bağımsız olarak ele aldık. Bundan sonraki başlıklarda öncelikle işlev şablonları olmak üzere saflığın diğer dil olanaklarıyla etkileşimlerini göreceğiz.
)

$(P
Bir işlev şablonunun tür parametrelerinin belirli türler için her kullanımı, sıradan bir işlevin eşdeğeridir. Bu yüzden saflık kavramı onlar için de yukarıda anlatıldığı gibidir. Buna rağmen, belirli bir şablonun saf olup olamadığı o şablonun kullanıldığı türlere bağlı olabildiğinden şablonların durumu biraz daha karışıktır.
)

$(P
Bunun bir örneği olarak bir aralık$(DIPNOT 5) $(ASIL range) alan ve o aralıktaki elemanlardan oluşan bir dizi döndüren bir işleve bakalım (bu işlev $(C std.array) modülünde zaten bulunur ve oradaki gerçekleştirmesi çok daha kullanışlıdır). Böyle bir işlev aşağıdaki gibi yazılabilir:
)

---
auto array(R)(R r) if (isInputRange!R) {
   ElementType!R[] sonuç;
   while (!r.empty) {
      sonuç ~= r.front;
      r.popFront();
   }
   return sonuç;
}
---

$(P
$(I Yukarıdaki işlev, bir aralıktaki elemanları bir dizi olarak döndüren $(C std.array.array)'in fazla hızlı olmayan bir gerçekleştirmesidir. Bu işlev $(C pure) olabilir mi?)
)

$(P
Bu işlevin nasıl işlediğini tahmin etmek güç olmasa gerek – aralığın başındaki eleman aralıktan çıkartılıyor ve dizinin sonuna ekleniyor, ve bu işlem aralıkta eleman kalmayana kadar sürdürülüyor. Soru: Bu işlev $(C pure) yapılabilir mi? $(C R) türü $(C map) veya $(C filter) gibi işlevlerin dönüş türü olduğunda bu kodun saf kodlar tarafından çağrılamaması için bir neden yoktur. Öte yandan, eğer $(C R) örneğin girişten satır okuma gibi bir işlemi de sarmalıyorsa $(C r.empty), $(C r.front), ve $(C r.popFront)'un hepsinin birden $(C pure) olmaları olanaksızdır. Dolayısıyla, $(C array) $(C pure) olarak işaretlense, böyle aralıklarla çalışamaz. Peki, ne yapılabilir?
)

$(P
Buna bir çözüm olarak $(C pure) belirtecini $(C R)'ye bağlı olarak koymayı sağlayan bir D söz dizimi değişikliği önerilmişti. Bu çözüm önerisi dile getireceği karmaşıklık ve neden olacağı aşırı kod tekrarı nedeniyle benimsenmedi. Sonuçta kabul edilen çözüm oldukça basittir: D'de şablon kodları nasıl olsa derleyici tarafından görülmek zorunda olduklarından şablonların saflığı derleyici tarafından otomatik olarak belirlenebilir (aynısı $(C nothrow) ve başka belirteçler için de geçerlidir).
)

$(P
Bunun anlamı, yukarıdaki örnekteki $(C array)'in buna izin veren aralık türleri için saf işlevler tarafından çağrılabilmesi, başka türler için ise çağrılamamasıdır. Saflığın şablon parametrelerine bağlı olmadığı durumda işlev şablonları en azından belgeleme açısından yine de açıkça $(C pure) olarak işaretlenebilir.
)

$(H5 Saf üye işlevler)

$(P
Doğal olarak, yapı ve sınıf üye işlevleri de saf olabilir. Normal işlevlerin saflık kuralları bir farkla onlar için de geçerlidir: Saflık kuralları üye işlevlerin gizli $(C this) parametresini de kapsar. Bunun anlamı, saf işlevlerin üye değişkenlere de erişebilecekleri ve onları da değiştirebilecekleridir.
)

---
class Foo {
  int getBar() const pure {
    return bar;
  }

  void setBar(int bar) pure {
    this.bar = bar;
  }

  private int bar;
}
---

$(P
$(I Saf işlevler üye değişkenlere erişebilirler. (Not: Normalde getter/setter işlevleri yerine D'de nitelik işlevlerinden $(ASIL property) yararlanılır.
))
)

$(P
Bir üye işlev $(C const) veya $(C immutable) olarak işaretlendiğinde de o belirteç aslında $(C this) parametresine uygulanır. Dolayısıyla, yukarıda değişebilme konusunda anlatılanlar burada da geçerlidir.
)

$(P
Saflık, türeme konusunda da beklenebileceği gibidir: Genel olarak, bir alt sınıfın beklentileri üst sınıfınkilerden daha azdır; verdiği garantiler ise daha fazladır (dönüş türlerinin $(I ortakdeğişkeliğinde) $(ASIL covariance) görüldüğü gibi). Dolayısıyla, saf olmayan bir işlevin alt sınıftaki tanımı saf olabilir ama bunun tersi doğru değildir. Bir kolaylık olarak da, saf olan bir üst sınıf işlevinin alt sınıftaki tanımının açıkça $(C pure) olarak işaretlenmesi gerekmez; böyle bir işlev otomatik olarak saftır (C++'taki $(C virtual) gibi). Walter Bright'ın bu konuda bir $(LINK2 http://www.drdobbs.com/blogs/cpp/232601305, blog yazısı) vardır.
)

$(H5 $(C pure) ve $(C immutable) – bir kere daha)

$(P
$(C const) ve $(C immutable) belirteçlerinin referans saydamlığına etkilerini yukarıda gördük. $(C pure)'un getirdiği garantiler bazı durumlarda bazı ek çıkarımlar da sağlar. Bunun tür sisteminin bir parçası da olan belirgin bir örneği, $(C pure) işlevlerin dönüş türlerinin bazı durumlarda güvenle $(C immutable) olarak kullanılabilmeleridir. Örnek olarak yine yukarıdaki $(C ulong[]&nbsp;asallar(uint&nbsp;adet)&nbsp;pure) işlevine bakalım. Aşağıdaki kodun nasıl olup da derlenebildiği ilk bakışta açık olmayabilir:
)

---
immutable ulong[] a = asallar(5);
---

$(P
$(C immutable) bir verinin başka hiçbir değişebilen referansı olamadığını biliyoruz. Buna rağmen, $(C asallar)'ın döndürdüğü ve değişebilen değerlerden oluşan dizi $(C immutable) olarak tanımlanabilmektedir. Peki, yukarıdaki kodun derlenebilmesinin nedeni nedir? Döndürdüğü değerleri değiştirebilecek olan başka referansların bulunamayacağı, bir işlevin $(C pure) olmasının sonucudur: Böyle bir işlev değişebilen referanslar içeren parametrelere sahip değildir ve değişebilen evrensel değişkenlere erişemez. Dolayısıyla, her ne kadar değişebilen değerlerden oluşan bir referans döndürüyor olsa da o işlevi çağıranlar o değerlerin değişemeyeceklerinden emindirler.
)

$(P
Her ne kadar fazla önemsiz bir ayrıntıymış gibi görünse de bu aslında şaşırtıcı derecede kullanışlı bir olanaktır çünkü hem işlevlerin $(I fonksiyonel programlamada) olduğu gibi değişmez veriler kullanabilmelerini, hem de verinin hız nedeniyle olduğu yerde değiştirildiği $(I geleneksel kodlarda) gereksiz veri kopyalarının önüne geçilmesini sağlamaktadır.
)

$(H5 Peki, kaçış kapısı nerede?)

$(P
Saf bir işlevin kullandığı bütün kodların da saf olmaları gerektiği gerçeğinden yola çıkıldığında saflığın bulaşıcı $(ASIL viral) olduğu görülür. D'nin saflık kuralları her ne kadar bu konuda kolaylıklar getiriyor olsalar da bazen saf olmayan kodların saf kodlar tarafından çağrılmaları gerekebilir.
)

$(P
Bunun bir örneği, halihazırda yazılmış olan $(ASIL legacy) kodlardır. Örneğin, saflığın gereklerini yerine getirdiği halde $(C pure) olarak işaretlenmemiş olan bir C işlevi bulunabilir. Tür sisteminin kendi başına çıkarsayamadığı başka durumlarda da olduğu gibi, bu durumun üstesinden gelmenin çaresi de $(C cast) kullanmaktır. İşlevin adresi alınır, tür dönüşümü ile $(C pure) belirteci eklenir, ve işlev o adres yoluyla çağrılır (tür sistemini yanıltabildiğinden $(C @safe) kodlar içerisinde bu mümkün değildir). Belirli bir kod içinde böyle $(I numaralara) ihtiyacın yeterince fazla olduğu durumlarda $(C safOlduğunuVarsay) $(ASIL $(C assumePure)) gibi bir şablondan yararlanılabilir.
)

$(P
Saflık bazen kısa süreliğine de olsa ayak bağı olabilir: Hata ayıklama amacıyla ekrana mesaj yazdırmak için veya istatistiksel amaçla evrensel bir sayacı arttırmak için bir işleve saf olmayan kodlar eklenmiş olabilir. Saf olmayan böyle bir kodun zincirleme çağrılmış olan $(C pure) işlevlerin en içtekine eklenmesinin gerekmesi ama bunun tür sistemi tarafından engellenmesi büyük bir sıkıntı kaynağı olurdu. Her ne kadar bazılarınca küçümsenen bir davranış olsa da bu tür kodlar gerçekte oldukça kullanışlıdırlar.
)

$(P
Saflığın hata ayıklama amacıyla $(I geçici olarak) etkisizleştirilmesi ihtiyacına rağmen başlangıçta D'de bu kullanıma yönelik hiçbir olanak bulunmuyordu. Sonunda özel bir kural olarak $(C debug) blokları içindeki saf olmayan kodların saf kodlar arasında bulunmalarına izin verildi. Bu kullanışlı olanağın etkinleştirilmesi için derleyiciye $(C -debug) komut satırı seçeneğinin verilmesi gerekir.
)

$(H5 Sonuç)

$(P
Başlangıçtaki görüşü tekrarlarsak, saflık kavramının önemi, işlevlerin gizli durum kullanmadıklarının tür sistemi tarafından garanti edilmesidir. D'nin $(C pure) anahtar sözcüğünün başka dillerdekilerden daha az kısıtlama getirdiğini gördük. Buna rağmen, $(C const) ve $(C immutable) belirteçleri yardımıyla aynı garantilerin sağlanabildiklerini ve $(C pure)'un D'nin başka olanakları ile etkileşimlerinin doğal olabildiğini ve belki de en önemlisi, emirli programlamaya izin verilebildiğini gördük.
)

$(P
Peki, bu konuda daha fazla bilgi için başka kaynaklar nelerdir? Aslında $(C pure) anahtar sözcüğü ile ilgili kurallar oldukça kısadır. Bu kurallar için dil referansının $(LINK2 http://dlang.org/, dlang.org'daki) $(LINK2 http://dlang.org/function.html, Functions bölümüne) bakabilirsiniz. Don Clugston'ın başlatmış olduğu ve $(LINK2 http://forum.dlang.org/thread/i7bp8o$(DOLAR)6po$(DOLAR)1@digitalmars.com, son değişikleri de getirmiş olan tartışma) da $(C pure)'un gelişimini görmek açısından oldukça ilginçtir. Burada anlatılan kavramların tasarımları ve gerçekleştirmeleri ile ilgili soruları da $(LINK2 http://forum.dlang.org/group/digitalmars.D, D dili forumlarında) sormak isteyebilirsiniz.
)

$(P
Bu yazıyı beğendiyseniz $(LINK2 http://twitter.com/?status=@klickverbot:, bana fikrinizi bildirmenizi), yazıyı $(LINK2 http://twitter.com/?status=Just%20read%20%C2%BBPurity%20in%20D%C2%AB%20by%20@klickverbot:%20http://klickverbot.at/blog/2012/05/purity-in-d, Twitter'da paylaşmanızı), ve yazının $(LINK2 http://news.ycombinator.com/item?id=4032248, Hacker News'deki) ve $(LINK2 http://www.reddit.com/r/programming/comments/u84fc/purity_in_d/, Reddit'teki) tartışmalarına katılmanızı isterim. $(LINK2 http://klickverbot.at/blog/tags/D/, D) hakkında başka yazılarım da var.
)

<span style="font-size:.9em">

$(H5 Notlar)

$(OL

<a name="dipnot1"></a>

$(LI
Bunun etkileri ilk akla geldiğinden çok daha ciddi ve şaşırtıcı olabilir: Bir çok Windows yazıcı sürücüsünün yazdırma işlemi sırasında değiştirdikleri FPU bayraklarını tekrar eski değerlerine çevirmedikleri olurdu. Bir belge yazdırıldıktan sonra bir çok programın çökmesi bunun yüzündendi – bu, yalnızca müşteri bilgisayarında oluşan çökme hatalarının güzel bir örneğidir.
)

<a name="dipnot2"></a>

$(LI
D kodları dilin bazen SafeD olarak adlandırılan bir alt kümesine kısıtlanabilir. Bu olanak üç anahtar sözcük sayesinde her işlev için teker teker ayarlanabilir: $(C @safe) olarak işaretlenen kod bellek hataları içeremez; dolayısıyla, bu gibi işlevlerde örneğin gösterge aritmetiği ve C'deki gibi bellek yönetimi kullanılamaz. $(C @system) olarak işaretlenmiş olan kod bunun tersidir – bu gibi işlevlerde $(I inline assembly) de dahil olmak üzere dilin bütün olanakları kullanılabilir. Son olarak, $(C @trusted) belirteci bu iki kavram arasında bir köprü kurar; programcının araştırarak güvenli olduğuna karar verdiği halde aslında güvenli olarak işaretlenmemiş olan kodlara arayüz oluşturur. $(C void*) türünden bir C arayüz işlevini sarmalayan bir D işlevi bunun bir örneği olarak görülebilir.
)

<a name="dipnot3"></a>

$(LI
C++'ın tersine, D'de $(C const) ve $(C immutable) geçişlidir. Bir $(C const) referans yoluyla erişilen her değer otomatik olarak $(C const)'tır. Örneğin, aşağıdaki kodu ele alalım:
)

---
struct Foo {
  int bar;
  int* baz;
};

void fun(const Foo* foo);
---

$(P
C++'ta $(C fun) $(C foo)'nun kendisini değiştiremez; örneğin, $(C foo->bar)'a yeni bir değer atayamaz. Buna rağmen, $(C foo->baz)'ın gösterdiği değeri değiştirmesi yasaldır – buna $(I sığ const) $(ASIL shallow const) da denir. Öte yandan, D'de $(C const) $(I derindir); $(C fun) içinde $(C foo.baz), $(C const int) gösteren $(C const) bir göstergedir ve bu yüzden $(C *foo.baz)'da da değişiklik yapılamaz. Aynı kural $(C immutable) için de geçerlidir; ek olarak, $(C immutable) olan veriyi değiştirebilecek başka referans bulunmadığı da garanti edilmiştir. Yani, veriyi $(C fun) değiştiremediği gibi, başka hiçbir kod da değiştiremez ($(C immutable) değerlerin ROM gibi bir bellek bölgesinde duruyor olduklarını düşünebiliriz). $(C immutable) otomatik olarak $(C const)'tır da.
)

<a name="dipnot4"></a>

$(LI
Bu örnek yalnızca açıklayıcı olduğu için seçilmiştir; yoksa, bu işlev herhalde ancak çok basit bir görüntüleyicide kullanılabilir. Saflığın bu örneğe bir yarar katıp katmadığı bir yana, bu işlev gerçek bir grafik arayüzü üzerinde gerçekleştirilmiş olsa, GPU'nun durumunun saflığının nasıl sağlanacağı konusu da düşünülmelidir.
)

<a name="dipnot5"></a>

$(LI
C++'ın erişicilerinin $(ASIL iterator) gösterge genellemeleri olmalarına benzer biçimde, D aralıkları da $(I topluluk) kavramının genellemeleridir. En basit aralık üç temel işlev sunar: $(C empty), $(C front), ve $(C popFront). Bu arayüzün kullanıcıları verinin perde arkasında nasıl saklandığından habersizdirler – örneğin, veri bir bellek bölgesinden, ağ üzerinden, standart girişten, vs. geliyor olabilir. Aralıklar algoritmaların kullanabilecekleri basit ama güçlü bir soyutlama sunarlar.
)

)

</span>

Macros:
        SUBTITLE="D'de Saflık Kavramı", David Nadlinger

        DESCRIPTION=David Nadlinger'ın D'deki saflık kavramını anlatan makalesinin Türkçe çevirisi "D'de Saflık Kavramı".

        KEYWORDS=d programlama dili makale d david nadlinger purity pure saflık saf

DIPNOT=$(LINK2 #dipnot$1, $(SUP $1))
